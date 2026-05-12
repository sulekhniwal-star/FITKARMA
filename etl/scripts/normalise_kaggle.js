/**
 * normalise_kaggle.js — Phase B Kaggle normaliser
 *
 * Sources (all per-100g unless noted):
 *   1. Indian_Food_Nutrition_Processed.csv   — batthulavinay (1,014 rows)
 *   2. ifct2017_compositions.csv             — gijoe707 (542 rows, deduped vs Phase A)
 *   3. Food_Nutrition_Dataset.csv            — sonalshinde123 (205 rows)
 *   4. nutrition_cf - Sheet5.csv             — umangsinghal5 (753 rows, per-serving → per-100g)
 *   5. recipe_nutrition.csv + recipes_master — ahsanneural (9,997 rows, per-serving → per-100g)
 *
 * Dedup: token-sort fuzzy match ≥88 against existing seed names (fuzzball)
 * Output: assets/data/indian_foods_seed.json  (Phase A + net-new kaggle items)
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { createReadStream } from 'fs';
import csvParser from 'csv-parser';
import { createRequire } from 'module';
const require = createRequire(import.meta.url);
const fuzz = require('fuzzball');

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const RAW = path.join(__dirname, '../data/raw');
const SEED = path.join(__dirname, '../../assets/data/indian_foods_seed.json');

const DEDUP_THRESHOLD = 88;

// ── helpers ──────────────────────────────────────────────────────────────────

const n = (v, fallback = 0) => {
  const f = parseFloat(v);
  return isNaN(f) || f < 0 ? fallback : f;
};

function readCsv(file) {
  return new Promise((resolve, reject) => {
    const rows = [];
    createReadStream(path.join(RAW, file))
      .pipe(csvParser())
      .on('data', r => rows.push(r))
      .on('end', () => resolve(rows))
      .on('error', reject);
  });
}

function normaliseKey(name) {
  return name.toLowerCase().replace(/[^a-z0-9 ]/g, '').replace(/\s+/g, ' ').trim();
}

function isDuplicate(name, existingKeys) {
  const key = normaliseKey(name);
  for (const k of existingKeys) {
    if (fuzz.token_sort_ratio(key, k) >= DEDUP_THRESHOLD) return true;
  }
  return false;
}

// ── load existing seed ────────────────────────────────────────────────────────

const master = JSON.parse(fs.readFileSync(SEED, 'utf8'));
// Remove any stale kaggle entries from previous runs
const base = master.filter(x => x.source !== 'kaggle');
const existingKeys = base.map(x => normaliseKey(x.name));
console.log(`✅ Loaded ${base.length} Phase A items`);

const netNew = [];
let skipped = 0;

function tryAdd(item) {
  if (!item.name || item.energy_kcal <= 0 || item.energy_kcal > 900) { skipped++; return; }
  if (isDuplicate(item.name, existingKeys)) { skipped++; return; }
  existingKeys.push(normaliseKey(item.name));
  netNew.push(item);
}

// ── S1: Indian_Food_Nutrition_Processed.csv (batthulavinay) ──────────────────
// Columns: Dish Name, Calories (kcal), Carbohydrates (g), Protein (g), Fats (g),
//          Free Sugar (g), Fibre (g), Sodium (mg), Calcium (mg), Iron (mg),
//          Vitamin C (mg), Folate (µg)
// Values are per-serving; dataset notes serving = 100g equivalent for most dishes

{
  const rows = await readCsv('Indian_Food_Nutrition_Processed.csv');
  for (const r of rows) {
    tryAdd({
      name: r['Dish Name']?.trim(),
      group: 'Indian Dishes',
      tags: 'vegetarian',
      energy_kcal: n(r['Calories (kcal)']),
      protein_g: n(r['Protein (g)']),
      fat_g: n(r['Fats (g)']),
      carbs_g: n(r['Carbohydrates (g)']),
      fiber_g: n(r['Fibre (g)']),
      sodium_mg: n(r['Sodium (mg)']),
      calcium_mg: n(r['Calcium (mg)']),
      iron_mg: n(r['Iron (mg)']),
      vitaminC_mg: n(r['Vitamin C (mg)']),
      vitaminB9_folate_ug: n(r['Folate (µg)']),
      source: 'kaggle',
      priority: 3,
    });
  }
  console.log(`   batthulavinay: ${rows.length} rows → ${netNew.length} added so far`);
}

// ── S2: ifct2017_compositions.csv (gijoe707) ─────────────────────────────────
// Columns: food_name, food_code, food_group, energy_kcal, protein_g, fat_g,
//          carbohydrate_g, fiber_g, calcium_mg, iron_mg, ...
// Fully deduped against Phase A IFCT 2017 — expect ~0 net new

{
  const before = netNew.length;
  const rows = await readCsv('ifct2017_compositions.csv');
  // Detect actual columns from first row
  const cols = Object.keys(rows[0] || {});
  const nameCol = cols.find(c => /name|food/i.test(c)) || cols[0];
  const kcalCol = cols.find(c => /kcal|energy|calori/i.test(c));
  const protCol = cols.find(c => /prot/i.test(c));
  const fatCol  = cols.find(c => /^fat/i.test(c));
  const carbCol = cols.find(c => /carb|cho/i.test(c));
  const fibCol  = cols.find(c => /fib/i.test(c));

  for (const r of rows) {
    tryAdd({
      name: r[nameCol]?.trim(),
      group: r['food_group'] || r['group'] || 'Indian Foods',
      tags: 'vegetarian',
      energy_kcal: n(kcalCol ? r[kcalCol] : 0),
      protein_g: n(protCol ? r[protCol] : 0),
      fat_g: n(fatCol ? r[fatCol] : 0),
      carbs_g: n(carbCol ? r[carbCol] : 0),
      fiber_g: n(fibCol ? r[fibCol] : 0),
      source: 'kaggle',
      priority: 3,
    });
  }
  console.log(`   gijoe707/ifct2017: ${rows.length} rows → ${netNew.length - before} net new (rest deduped vs Phase A)`);
}

// ── S3: Food_Nutrition_Dataset.csv (sonalshinde123) ──────────────────────────
// Columns: food_name, category, calories, protein, carbs, fat, iron, vitamin_c
// Per 100g

{
  const before = netNew.length;
  const rows = await readCsv('Food_Nutrition_Dataset.csv');
  for (const r of rows) {
    tryAdd({
      name: r['food_name']?.trim(),
      group: r['category']?.trim() || 'General',
      tags: 'vegetarian',
      energy_kcal: n(r['calories']),
      protein_g: n(r['protein']),
      fat_g: n(r['fat']),
      carbs_g: n(r['carbs']),
      fiber_g: 0,
      iron_mg: n(r['iron']),
      vitaminC_mg: n(r['vitamin_c']),
      source: 'kaggle',
      priority: 3,
    });
  }
  console.log(`   sonalshinde123: ${rows.length} rows → ${netNew.length - before} net new`);
}

// ── S4: nutrition_cf - Sheet5.csv (umangsinghal5) ────────────────────────────
// Columns: Food, Associativity, Region, Type, Category, Allergy, Serving,
//          Total Weight (gms), Energy(kcal), Proteins, Carbohydrates, Fats,
//          Fiber, Carbon Footprint(kg CO2e), Ingredients
// Values are per-serving → convert to per-100g using Total Weight

{
  const before = netNew.length;
  const rows = await readCsv('nutrition_cf - Sheet5.csv');
  for (const r of rows) {
    const weight = n(r['Total Weight (gms)'], 100);
    const scale = weight > 0 ? 100 / weight : 1;
    const isVeg = (r['Type'] || '').toLowerCase().includes('veg');
    tryAdd({
      name: r['Food']?.trim(),
      group: r['Category']?.trim() || 'Indian Dishes',
      region: r['Region']?.trim(),
      tags: isVeg ? 'vegetarian' : 'non-vegetarian',
      energy_kcal: parseFloat((n(r['Energy(kcal)']) * scale).toFixed(1)),
      protein_g: parseFloat((n(r['Proteins']) * scale).toFixed(2)),
      fat_g: parseFloat((n(r['Fats']) * scale).toFixed(2)),
      carbs_g: parseFloat((n(r['Carbohydrates']) * scale).toFixed(2)),
      fiber_g: parseFloat((n(r['Fiber']) * scale).toFixed(2)),
      source: 'kaggle',
      priority: 3,
    });
  }
  console.log(`   umangsinghal5: ${rows.length} rows → ${netNew.length - before} net new`);
}

// ── S5: recipe_nutrition.csv + recipes_master.csv (ahsanneural) ──────────────
// recipe_nutrition: recipe_id, calories, protein_g, carbohydrates_g, fat_g,
//                   fiber_g, sugar_g, sodium_mg, cholesterol_mg, ...
// recipes_master:   recipe_id, recipe_name, cuisine, category, is_vegetarian,
//                   is_vegan, is_gluten_free, calories_per_serving, servings
// Values are per-serving → convert to per-100g using calories_per_serving ratio

{
  const before = netNew.length;
  const [nutrition, master_rows] = await Promise.all([
    readCsv('recipe_nutrition.csv'),
    readCsv('recipes_master.csv'),
  ]);

  // Build nutrition lookup by recipe_id
  const nutMap = {};
  for (const r of nutrition) nutMap[r['recipe_id']] = r;

  for (const r of master_rows) {
    const nut = nutMap[r['recipe_id']];
    if (!nut) continue;

    const servings = n(r['servings'], 1);
    const calPerServing = n(nut['calories']);
    // Estimate serving weight: use 150g as default for Indian dishes
    const servingWeight = 150;
    const scale = servingWeight > 0 ? 100 / servingWeight : 1;

    const isVeg = r['is_vegetarian'] === 'True';
    const isVegan = r['is_vegan'] === 'True';
    const cuisine = r['cuisine']?.trim();

    tryAdd({
      name: r['recipe_name']?.trim(),
      group: r['category']?.trim() || 'Recipes',
      cuisine,
      tags: [
        isVeg ? 'vegetarian' : 'non-vegetarian',
        isVegan ? 'vegan' : '',
        r['is_gluten_free'] === 'True' ? 'gluten-free' : '',
        r['is_halal'] === 'True' ? 'halal' : '',
      ].filter(Boolean).join(' '),
      energy_kcal: parseFloat((n(nut['calories']) * scale).toFixed(1)),
      protein_g: parseFloat((n(nut['protein_g']) * scale).toFixed(2)),
      fat_g: parseFloat((n(nut['fat_g']) * scale).toFixed(2)),
      carbs_g: parseFloat((n(nut['carbohydrates_g']) * scale).toFixed(2)),
      fiber_g: parseFloat((n(nut['fiber_g']) * scale).toFixed(2)),
      sugars_g: parseFloat((n(nut['sugar_g']) * scale).toFixed(2)),
      sodium_mg: parseFloat((n(nut['sodium_mg']) * scale).toFixed(1)),
      cholesterol_mg: parseFloat((n(nut['cholesterol_mg']) * scale).toFixed(1)),
      source: 'kaggle',
      priority: 3,
    });
  }
  console.log(`   ahsanneural 10k: ${master_rows.length} rows → ${netNew.length - before} net new`);
}

// ── merge & write ─────────────────────────────────────────────────────────────

const merged = [...base, ...netNew];
fs.writeFileSync(SEED, JSON.stringify(merged, null, 2));

console.log(`\n📊 Phase B Summary:`);
console.log(`   Phase A base:    ${base.length} items`);
console.log(`   Kaggle net new:  ${netNew.length} items`);
console.log(`   Skipped (dedup): ${skipped}`);
console.log(`   Total seed:      ${merged.length} items`);
console.log(`✨ Written → ${SEED}`);
