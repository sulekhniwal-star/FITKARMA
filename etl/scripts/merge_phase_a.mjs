/**
 * merge_phase_a.mjs — Merge Phase A sources into Flutter seed JSON
 *
 * Priority: ifct2017 (1) > indb (2)
 * IFCT 2017 records are never overwritten.
 * Outputs: assets/data/indian_foods_seed.json
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const ifctPath = path.join(__dirname, '../data/raw/ifct2017_with_languages.json');
const indbPath = path.join(__dirname, '../data/raw/indb_extracted.json');
const outPath = path.join(__dirname, '../../assets/data/indian_foods_seed.json');

const ifct = JSON.parse(fs.readFileSync(ifctPath, 'utf8'));
const indb = fs.existsSync(indbPath)
  ? JSON.parse(fs.readFileSync(indbPath, 'utf8'))
  : [];

// Deduplicate by normalised name — ifct2017 wins
const seen = new Set(ifct.map(x => x.name.toLowerCase().trim()));
const uniqueIndb = indb.filter(x => !seen.has(x.name.toLowerCase().trim()));

const merged = [...ifct, ...uniqueIndb];

fs.writeFileSync(outPath, JSON.stringify(merged, null, 2));

console.log(`✅ IFCT 2017: ${ifct.length} items (priority 1 — never overwritten)`);
console.log(`✅ INDB:      ${uniqueIndb.length} unique composite recipes (priority 2)`);
console.log(`✨ Merged ${merged.length} total items → ${outPath}`);
