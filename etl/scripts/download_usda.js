/**
 * download_usda.js — Phase C: USDA FoodData Central normaliser
 *
 * Sources (already extracted to etl/data/raw/):
 *   foundationDownload.json                              — 316 Foundation Foods
 *   FoodData_Central_sr_legacy_food_json_2021-10-28.json — 7,793 SR Legacy
 *
 * Nutrient mapping: by nutrient.name substring match (case-insensitive)
 * Dedup: token-sort fuzzy ≥88 against existing seed
 * Output: assets/data/indian_foods_seed.json
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { createRequire } from 'module';

const require = createRequire(import.meta.url);
const fuzz = require('fuzzball');

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const RAW  = path.join(__dirname, '../data/raw');
const SEED = path.join(__dirname, '../../assets/data/indian_foods_seed.json');

const DEDUP_THRESHOLD = 88;

// ── nutrient extractor ────────────────────────────────────────────────────────

function getNutrient(nutrients, namePart, unit) {
  const match = nutrients.find(n =>
    n.nutrient?.name?.toLowerCase().includes(namePart.toLowerCase()) &&
    (!unit || n.nutrient?.unitName === unit)
  );
  return match?.amount ?? 0;
}

function normaliseItem(item) {
  const nuts = item.foodNutrients ?? [];
  return {
    fdcId:      item.fdcId,
    name:       item.description?.trim() ?? '',
    group:      item.foodCategory?.description?.trim() ?? '',
    tags:       '',

    energy_kcal:  getNutrient(nuts, 'Energy', 'kcal') || Math.round(getNutrient(nuts, 'Energy', 'kJ') / 4.184),
    protein_g:    getNutrient(nuts, 'Protein'),
    fat_g:        getNutrient(nuts, 'Total lipid'),
    carbs_g:      getNutrient(nuts, 'Carbohydrate, by difference'),
    fiber_g:      getNutrient(nuts, 'Fiber, total dietary'),
    sugars_g:     getNutrient(nuts, 'Sugars, total'),
    water_g:      getNutrient(nuts, 'Water'),

    calcium_mg:   getNutrient(nuts, 'Calcium, Ca'),
    iron_mg:      getNutrient(nuts, 'Iron, Fe'),
    magnesium_mg: getNutrient(nuts, 'Magnesium, Mg'),
    phosphorus_mg:getNutrient(nuts, 'Phosphorus, P'),
    potassium_mg: getNutrient(nuts, 'Potassium, K'),
    sodium_mg:    getNutrient(nuts, 'Sodium, Na'),
    zinc_mg:      getNutrient(nuts, 'Zinc, Zn'),

    vitaminA_ug:  getNutrient(nuts, 'Vitamin A, RAE'),
    vitaminC_mg:  getNutrient(nuts, 'Vitamin C, total ascorbic acid'),
    vitaminD_ug:  getNutrient(nuts, 'Vitamin D '),
    vitaminB12_ug:getNutrient(nuts, 'Vitamin B-12'),
    vitaminB9_folate_ug: getNutrient(nuts, 'Folate, total'),
    vitaminB1_thiamine_mg:  getNutrient(nuts, 'Thiamin'),
    vitaminB2_riboflavin_mg:getNutrient(nuts, 'Riboflavin'),
    vitaminB3_niacin_mg:    getNutrient(nuts, 'Niacin'),

    cholesterol_mg:    getNutrient(nuts, 'Cholesterol'),
    saturatedFat_g:    getNutrient(nuts, 'Fatty acids, total saturated'),
    monounsaturatedFat_g: getNutrient(nuts, 'Fatty acids, total monounsaturated'),
    polyunsaturatedFat_g: getNutrient(nuts, 'Fatty acids, total polyunsaturated'),

    source:   'usda',
    priority: 4,
  };
}

// ── dedup helpers ─────────────────────────────────────────────────────────────

const normaliseKey = s => s.toLowerCase().replace(/[^a-z0-9 ]/g, '').replace(/\s+/g, ' ').trim();

function buildIndex(items) {
  return items.map(x => normaliseKey(x.name));
}

function isDuplicate(name, index) {
  const key = normaliseKey(name);
  for (const k of index) {
    if (fuzz.token_sort_ratio(key, k) >= DEDUP_THRESHOLD) return true;
  }
  return false;
}

// ── load existing seed ────────────────────────────────────────────────────────

const master = JSON.parse(fs.readFileSync(SEED, 'utf8'));
const base   = master.filter(x => x.source !== 'usda');
const index  = buildIndex(base);
console.log(`✅ Loaded ${base.length} existing items (Phase A+B)`);

const netNew  = [];
let   skipped = 0;

function tryAdd(raw) {
  const item = normaliseItem(raw);
  if (!item.name || item.energy_kcal <= 0 || item.energy_kcal > 900) { skipped++; return; }
  if (isDuplicate(item.name, index)) { skipped++; return; }
  index.push(normaliseKey(item.name));
  netNew.push(item);
}

// ── Foundation Foods (316 items) ──────────────────────────────────────────────

const ff = JSON.parse(fs.readFileSync(path.join(RAW, 'foundationDownload.json'), 'utf8'));
for (const item of ff.FoundationFoods ?? []) tryAdd(item);
console.log(`   Foundation Foods: ${ff.FoundationFoods?.length} items → ${netNew.length} net new so far`);

// ── SR Legacy (7,793 items) ───────────────────────────────────────────────────

const beforeSR = netNew.length;
const sr = JSON.parse(fs.readFileSync(
  path.join(RAW, 'FoodData_Central_sr_legacy_food_json_2021-10-28.json'), 'utf8'
));
for (const item of sr.SRLegacyFoods ?? []) tryAdd(item);
console.log(`   SR Legacy:        ${sr.SRLegacyFoods?.length} items → ${netNew.length - beforeSR} net new`);

// ── update stub files to point at real data ───────────────────────────────────

fs.writeFileSync(path.join(RAW, 'FoundationFoods.json'),
  JSON.stringify({ source: 'foundationDownload.json', count: ff.FoundationFoods?.length }, null, 2));
fs.writeFileSync(path.join(RAW, 'SRLegacy.json'),
  JSON.stringify({ source: 'FoodData_Central_sr_legacy_food_json_2021-10-28.json', count: sr.SRLegacyFoods?.length }, null, 2));

// ── write merged seed ─────────────────────────────────────────────────────────

const merged = [...base, ...netNew];
fs.writeFileSync(SEED, JSON.stringify(merged, null, 2));

console.log(`\n📊 Phase C Summary:`);
console.log(`   Phase A+B base:  ${base.length} items`);
console.log(`   USDA net new:    ${netNew.length} items`);
console.log(`   Skipped (dedup): ${skipped}`);
console.log(`   Total seed:      ${merged.length} items`);
console.log(`✨ Written → ${SEED}`);
