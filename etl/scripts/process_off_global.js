/**
 * process_off_global.js — Phase E: Open Food Facts Global dump processor
 *
 * Source: en.openfoodfacts.org.products.csv.gz (~1.2 GB compressed)
 * Download from: https://static.openfoodfacts.org/data/en.openfoodfacts.org.products.csv.gz
 * Place at: etl/data/raw/en.openfoodfacts.org.products.csv.gz
 *
 * Strategy:
 *   - Stream-decompress gz → pipe through CSV parser (never loads full file into RAM)
 *   - Accept rows where energy_100g > 0 and product_name is non-empty
 *   - Deduplicate: exact barcode match first, then fuzzy name ≥88 against running index
 *   - Write final merged seed JSON once stream ends
 *
 * OFF CSV key columns (tab-separated):
 *   code, product_name, generic_name, categories, countries,
 *   energy-kcal_100g, proteins_100g, carbohydrates_100g, fat_100g,
 *   fiber_100g, sugars_100g, sodium_100g, salt_100g,
 *   calcium_100g, iron_100g, vitamin-c_100g,
 *   saturated-fat_100g, trans-fat_100g,
 *   nutrition_grade_fr, nova_group
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { createGunzip } from 'zlib';
import { createRequire } from 'module';
import { parse } from 'csv-parse';
import { pipeline } from 'stream/promises';
import { Transform } from 'stream';

const require = createRequire(import.meta.url);
const fuzz = require('fuzzball');

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const GZ_PATH = path.join(__dirname, '../data/raw/en.openfoodfacts.org.products.csv.gz');
const SEED    = path.join(__dirname, '../../assets/data/indian_foods_seed.json');

const DEDUP_THRESHOLD = 88;
const LOG_INTERVAL    = 100_000;

// ── guard ─────────────────────────────────────────────────────────────────────

if (!fs.existsSync(GZ_PATH) || fs.statSync(GZ_PATH).size < 100_000) {
  console.error('❌ OFF gz file not found or is a stub (< 100 KB).');
  console.error('   Download: https://static.openfoodfacts.org/data/en.openfoodfacts.org.products.csv.gz');
  console.error('   Place at: etl/data/raw/en.openfoodfacts.org.products.csv.gz');
  process.exit(1);
}

// ── load existing seed ────────────────────────────────────────────────────────

const master = JSON.parse(fs.readFileSync(SEED, 'utf8'));
const base   = master.filter(x => x.source !== 'off_global');
console.log(`✅ Loaded ${base.length} existing items (Phase A–D)`);

// Build dedup indexes
const barcodeSet = new Set(base.map(x => x.barcode).filter(Boolean));
const nameIndex  = base.map(x => normaliseKey(x.name));

function normaliseKey(s) {
  return (s ?? '').toLowerCase().replace(/[^a-z0-9 ]/g, '').replace(/\s+/g, ' ').trim();
}

function isDuplicateName(name) {
  const key = normaliseKey(name);
  for (const k of nameIndex) {
    if (fuzz.token_sort_ratio(key, k) >= DEDUP_THRESHOLD) return true;
  }
  return false;
}

const n = (v, fallback = 0) => {
  const f = parseFloat(v);
  return isNaN(f) || f < 0 ? fallback : parseFloat(f.toFixed(4));
};

// ── streaming processor ───────────────────────────────────────────────────────

const netNew   = [];
let   rowsSeen = 0;
let   skipped  = 0;

const processor = new Transform({
  objectMode: true,
  transform(row, _enc, cb) {
    rowsSeen++;
    if (rowsSeen % LOG_INTERVAL === 0) {
      process.stdout.write(`\r   Processed ${rowsSeen.toLocaleString()} rows | accepted ${netNew.length.toLocaleString()} | skipped ${skipped.toLocaleString()}`);
    }

    const name    = (row['product_name'] ?? row['generic_name'] ?? '').trim();
    const barcode = (row['code'] ?? '').trim();
    const kcal    = n(row['energy-kcal_100g'] ?? row['energy_100g']);

    // Basic validity
    if (!name || kcal <= 0 || kcal > 900) { skipped++; cb(); return; }

    // Barcode dedup (fast path)
    if (barcode && barcodeSet.has(barcode)) { skipped++; cb(); return; }

    // Name fuzzy dedup (slower — only if barcode is new/absent)
    if (isDuplicateName(name)) { skipped++; cb(); return; }

    // Accept
    if (barcode) barcodeSet.add(barcode);
    nameIndex.push(normaliseKey(name));

    netNew.push({
      name,
      barcode:  barcode || undefined,
      group:    (row['categories'] ?? '').split(',')[0].trim() || 'Packaged Foods',
      tags:     '',

      energy_kcal:  kcal,
      protein_g:    n(row['proteins_100g']),
      fat_g:        n(row['fat_100g']),
      carbs_g:      n(row['carbohydrates_100g']),
      fiber_g:      n(row['fiber_100g']),
      sugars_g:     n(row['sugars_100g']),
      sodium_mg:    n(row['sodium_100g']) * 1000,   // OFF stores g, convert to mg
      calcium_mg:   n(row['calcium_100g']) * 1000,
      iron_mg:      n(row['iron_100g']) * 1000,
      vitaminC_mg:  n(row['vitamin-c_100g']) * 1000,
      saturatedFat_g: n(row['saturated-fat_100g']),
      transFat_g:     n(row['trans-fat_100g']),

      nutritionGrade: row['nutrition_grade_fr'] ?? '',
      novaGroup:      row['nova_group'] ?? '',

      source:   'off_global',
      priority: 6,
    });

    cb();
  }
});

// ── run pipeline ──────────────────────────────────────────────────────────────

console.log('⚡ Streaming OFF gz dump…');
const startMs = Date.now();

await pipeline(
  fs.createReadStream(GZ_PATH),
  createGunzip(),
  parse({
    delimiter: '\t',
    columns: true,
    skip_empty_lines: true,
    relax_column_count: true,
    bom: true,
  }),
  processor
);

const elapsed = ((Date.now() - startMs) / 1000).toFixed(1);
process.stdout.write('\n');
console.log(`   Done in ${elapsed}s`);

// ── write merged seed ─────────────────────────────────────────────────────────

const merged = [...base, ...netNew];
fs.writeFileSync(SEED, JSON.stringify(merged, null, 2));

console.log(`\n📊 Phase E Summary:`);
console.log(`   Phase A–D base:  ${base.length} items`);
console.log(`   OFF rows seen:   ${rowsSeen.toLocaleString()}`);
console.log(`   OFF net new:     ${netNew.length.toLocaleString()} items`);
console.log(`   Skipped (dedup): ${skipped.toLocaleString()}`);
console.log(`   Total seed:      ${merged.length.toLocaleString()} items`);
console.log(`✨ Written → ${SEED}`);
