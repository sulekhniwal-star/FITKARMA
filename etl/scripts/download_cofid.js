/**
 * download_cofid.js — Phase D: UK CoFID 2021 normaliser
 *
 * Source: McCance_and_Widdowson_Composition_of_Foods_Integrated_Dataset_2021.xlsx
 * Place the real file at etl/data/raw/ before running.
 * Download from: https://www.gov.uk/government/publications/composition-of-foods-integrated-dataset-cofid
 *
 * CoFID 2021 worksheet structure (13 sheets, all keyed on food code col A):
 *   Proximates     — energy, water, protein, fat, carbs, fibre, alcohol, NSP
 *   Inorganics     — Na, K, Ca, Mg, P, Fe, Cu, Zn, Cl, Mn, Se, I
 *   Vitamins       — retinol, carotene, vit D, vit E, vit K, thiamin, riboflavin,
 *                    niacin, B6, B12, folate, pantothenate, biotin, vit C
 *   Fatty acids    — satd, mono, poly, trans, n-3, n-6
 *   Amino acids    — 18 amino acids
 *   (+ additional sheets: Proximates2, Carbohydrates, Sterols, etc.)
 *
 * Dedup: token-sort fuzzy ≥88 against existing seed
 * Output: assets/data/indian_foods_seed.json
 */

import XLSX from 'xlsx';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { createRequire } from 'module';

const require = createRequire(import.meta.url);
const fuzz = require('fuzzball');

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const XLSX_PATH = path.join(__dirname, '../data/raw/McCance_and_Widdowson_Composition_of_Foods_Integrated_Dataset_2021.xlsx');
const SEED      = path.join(__dirname, '../../assets/data/indian_foods_seed.json');
const DEDUP_THRESHOLD = 88;

// ── guard ─────────────────────────────────────────────────────────────────────

if (!fs.existsSync(XLSX_PATH) || fs.statSync(XLSX_PATH).size < 10_000) {
  console.error('❌ Real CoFID xlsx not found or is a stub.');
  console.error('   Download from: https://www.gov.uk/government/publications/composition-of-foods-integrated-dataset-cofid');
  console.error('   Save to: etl/data/raw/McCance_and_Widdowson_Composition_of_Foods_Integrated_Dataset_2021.xlsx');
  process.exit(1);
}

// ── load workbook ─────────────────────────────────────────────────────────────

console.log('⚡ Loading CoFID 2021 workbook…');
const wb = XLSX.readFile(XLSX_PATH, { cellDates: false, sheetStubs: false });
console.log(`   Sheets found: ${wb.SheetNames.join(', ')}`);

// ── sheet → row array helper ──────────────────────────────────────────────────

function sheetRows(name) {
  const ws = wb.Sheets[name];
  if (!ws) return [];
  return XLSX.utils.sheet_to_json(ws, { defval: '' });
}

// ── find column by partial header match ──────────────────────────────────────

function col(row, ...parts) {
  for (const key of Object.keys(row)) {
    const k = key.toLowerCase();
    if (parts.every(p => k.includes(p.toLowerCase()))) return row[key];
  }
  return '';
}

const n = (v, fallback = 0) => {
  const f = parseFloat(v);
  return isNaN(f) || f < 0 ? fallback : parseFloat(f.toFixed(4));
};

// ── build per-food-code maps from each sheet ──────────────────────────────────
// CoFID uses a numeric food code in the first column as the join key.

function buildMap(sheetName, codeCol) {
  const map = {};
  for (const row of sheetRows(sheetName)) {
    const code = String(row[codeCol] ?? '').trim();
    if (code) map[code] = row;
  }
  return map;
}

// Detect the code column name (varies slightly across sheets)
function detectCodeCol(sheetName) {
  const rows = sheetRows(sheetName);
  if (!rows.length) return null;
  const keys = Object.keys(rows[0]);
  // CoFID code column is typically 'Food Code', 'Code', or first numeric-looking column
  return keys.find(k => /^food.?code$|^code$/i.test(k)) ?? keys[0];
}

// ── load all sheets ───────────────────────────────────────────────────────────

function findSheet(candidates) {
  for (const c of candidates) {
    const found = wb.SheetNames.find(s => s.toLowerCase().includes(c.toLowerCase()));
    if (found) return found;
  }
  return null;
}

const proxSheet  = findSheet(['Proximates', 'Prox']);
const inorgSheet = findSheet(['Inorganics', 'Inorganic', 'Minerals']);
const vitSheet   = findSheet(['1.5 Vitamins', 'Vitamins', 'Vitamin']);
// CoFID splits fatty acids: merge SFA + MUFA + PUFA per 100g food into one map
const sfaSheet   = findSheet(['SFA per 100gFood',  'SFA per 100g Food']);
const mufaSheet  = findSheet(['MUFA per 100gFood', 'MUFA per 100g Food']);
const pufaSheet  = findSheet(['PUFA per 100gFood', 'PUFA per 100g Food']);

console.log(`   Proximates : ${proxSheet}`);
console.log(`   Inorganics : ${inorgSheet}`);
console.log(`   Vitamins   : ${vitSheet}`);
console.log(`   SFA sheet  : ${sfaSheet}`);
console.log(`   MUFA sheet : ${mufaSheet}`);
console.log(`   PUFA sheet : ${pufaSheet}`);

if (!proxSheet) {
  console.error('❌ Could not find Proximates sheet. Sheet names:', wb.SheetNames.join(', '));
  process.exit(1);
}

const proxRows = sheetRows(proxSheet);
const codeCol  = detectCodeCol(proxSheet);
console.log(`   Code column: "${codeCol}" | Proximates rows: ${proxRows.length}`);
console.log(`   Sample columns: ${Object.keys(proxRows[0] ?? {}).slice(0, 12).join(', ')}`);

const inorgMap = inorgSheet ? buildMap(inorgSheet, detectCodeCol(inorgSheet)) : {};
const vitMap   = vitSheet   ? buildMap(vitSheet,   detectCodeCol(vitSheet))   : {};

// Merge SFA + MUFA + PUFA rows by food code into a single fat map
const fatMap = {};
for (const sheet of [sfaSheet, mufaSheet, pufaSheet].filter(Boolean)) {
  const cc = detectCodeCol(sheet);
  for (const row of sheetRows(sheet)) {
    const code = String(row[cc] ?? '').trim();
    if (code) fatMap[code] = { ...(fatMap[code] ?? {}), ...row };
  }
}

// ── dedup helpers ─────────────────────────────────────────────────────────────

const normaliseKey = s => s.toLowerCase().replace(/[^a-z0-9 ]/g, '').replace(/\s+/g, ' ').trim();

const master = JSON.parse(fs.readFileSync(SEED, 'utf8'));
const base   = master.filter(x => x.source !== 'cofid_uk');
const index  = base.map(x => normaliseKey(x.name));
console.log(`✅ Loaded ${base.length} existing items (Phase A–C)`);

function isDuplicate(name) {
  const key = normaliseKey(name);
  for (const k of index) {
    if (fuzz.token_sort_ratio(key, k) >= DEDUP_THRESHOLD) return true;
  }
  return false;
}

// ── process each food row ─────────────────────────────────────────────────────

const netNew  = [];
let   skipped = 0;

for (const row of proxRows) {
  const code = String(row[codeCol] ?? '').trim();
  const name = String(col(row, 'food', 'name') || col(row, 'description') || col(row, 'name') || '').trim();

  if (!name || !code) { skipped++; continue; }

  // Energy: CoFID stores kcal and kJ — prefer kcal column
  const kcal = n(col(row, 'kcal') || col(row, 'energy', 'kcal') || col(row, 'energy (kcal)'));
  const kj   = n(col(row, 'kj')   || col(row, 'energy', 'kj')   || col(row, 'energy (kj)'));
  const energy_kcal = kcal > 0 ? kcal : Math.round(kj / 4.184);

  if (energy_kcal <= 0 || energy_kcal > 900) { skipped++; continue; }
  if (isDuplicate(name)) { skipped++; continue; }

  const inorg = inorgMap[code] ?? {};
  const vit   = vitMap[code]   ?? {};
  const fat   = fatMap[code]   ?? {};

  const item = {
    code,
    name,
    group: String(col(row, 'food', 'group') || col(row, 'group') || col(row, 'category') || '').trim(),
    tags:  '',

    // Proximates (g/100g)
    energy_kcal,
    water_g:   n(col(row, 'water')),
    protein_g: n(col(row, 'protein')),
    fat_g:     n(col(row, 'fat') || col(row, 'total fat') || col(row, 'lipid')),
    carbs_g:   n(col(row, 'carbohydrate') || col(row, 'carbs')),
    fiber_g:   n(col(row, 'fibre') || col(row, 'fiber') || col(row, 'nsp')),
    sugars_g:  n(col(row, 'sugar')),
    starch_g:  n(col(row, 'starch')),
    alcohol_g: n(col(row, 'alcohol')),

    // Inorganics (mg/100g)
    sodium_mg:    n(col(inorg, 'na') || col(inorg, 'sodium')),
    potassium_mg: n(col(inorg, 'k')  || col(inorg, 'potassium')),
    calcium_mg:   n(col(inorg, 'ca') || col(inorg, 'calcium')),
    magnesium_mg: n(col(inorg, 'mg') || col(inorg, 'magnesium')),
    phosphorus_mg:n(col(inorg, 'p')  || col(inorg, 'phosphorus')),
    iron_mg:      n(col(inorg, 'fe') || col(inorg, 'iron')),
    copper_mg:    n(col(inorg, 'cu') || col(inorg, 'copper')),
    zinc_mg:      n(col(inorg, 'zn') || col(inorg, 'zinc')),
    manganese_mg: n(col(inorg, 'mn') || col(inorg, 'manganese')),
    selenium_ug:  n(col(inorg, 'se') || col(inorg, 'selenium')),
    iodine_ug:    n(col(inorg, 'i')  || col(inorg, 'iodine')),

    // Vitamins
    vitaminA_ug:             n(col(vit, 'retinol') || col(vit, 'vitamin a')),
    carotene_ug:             n(col(vit, 'carotene')),
    vitaminD_ug:             n(col(vit, 'vitamin d')),
    vitaminE_mg:             n(col(vit, 'vitamin e')),
    vitaminK_ug:             n(col(vit, 'vitamin k')),
    vitaminB1_thiamine_mg:   n(col(vit, 'thiamin')),
    vitaminB2_riboflavin_mg: n(col(vit, 'riboflavin')),
    vitaminB3_niacin_mg:     n(col(vit, 'niacin')),
    vitaminB6_mg:            n(col(vit, 'b6') || col(vit, 'vitamin b6')),
    vitaminB12_ug:           n(col(vit, 'b12') || col(vit, 'vitamin b12')),
    vitaminB9_folate_ug:     n(col(vit, 'folate') || col(vit, 'folic')),
    vitaminB5_pantothenic_mg:n(col(vit, 'pantothenate') || col(vit, 'pantothenic')),
    vitaminB7_biotin_ug:     n(col(vit, 'biotin')),
    vitaminC_mg:             n(col(vit, 'vitamin c') || col(vit, 'ascorbic')),

    // Fatty acids (g/100g)
    saturatedFat_g:       n(col(fat, 'satd') || col(fat, 'saturated')),
    monounsaturatedFat_g: n(col(fat, 'mono')),
    polyunsaturatedFat_g: n(col(fat, 'poly')),
    transFat_g:           n(col(fat, 'trans')),
    omega3_g:             n(col(fat, 'n-3') || col(fat, 'omega-3') || col(fat, 'omega3')),
    omega6_g:             n(col(fat, 'n-6') || col(fat, 'omega-6') || col(fat, 'omega6')),

    source:   'cofid_uk',
    priority: 5,
  };

  index.push(normaliseKey(name));
  netNew.push(item);
}

// ── write merged seed ─────────────────────────────────────────────────────────

const merged = [...base, ...netNew];
fs.writeFileSync(SEED, JSON.stringify(merged, null, 2));

console.log(`\n📊 Phase D Summary:`);
console.log(`   Phase A–C base:  ${base.length} items`);
console.log(`   CoFID net new:   ${netNew.length} items`);
console.log(`   Skipped (dedup): ${skipped}`);
console.log(`   Total seed:      ${merged.length} items`);
console.log(`✨ Written → ${SEED}`);
