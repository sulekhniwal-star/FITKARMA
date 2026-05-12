/**
 * extract_indb.mjs — Parse INDB.xlsx (Indian Nutrient Databank)
 *
 * Source: github.com/lindsayjaacks/Indian-Nutrient-Databank-INDB-
 * Place INDB.xlsx in etl/data/raw/ before running.
 *
 * Outputs: etl/data/raw/indb_extracted.json
 */

import XLSX from 'xlsx';
import fs from 'fs';
import path from 'path';

const INDB_PATH = './data/raw/INDB.xlsx';

if (!fs.existsSync(INDB_PATH)) {
  console.error('❌ INDB.xlsx not found at', INDB_PATH);
  console.error('   Clone https://github.com/lindsayjaacks/Indian-Nutrient-Databank-INDB-');
  console.error('   and copy INDB.xlsx to etl/data/raw/');
  process.exit(1);
}

const wb = XLSX.readFile(INDB_PATH);
const sheet = wb.Sheets[wb.SheetNames[0]];
const rows = XLSX.utils.sheet_to_json(sheet, { defval: 0 });

console.log(`✅ Loaded ${rows.length} rows from INDB.xlsx`);
console.log('   Columns:', Object.keys(rows[0]).join(', '));

// Normalise column names to lowercase with underscores
const normalise = key => key.trim().toLowerCase().replace(/\s+/g, '_').replace(/[^a-z0-9_]/g, '');

const extracted = rows.map((row, i) => {
  const n = {};
  for (const [k, v] of Object.entries(row)) n[normalise(k)] = v;

  return {
    code: `INDB-${String(i + 1).padStart(4, '0')}`,
    name: n.food_name || n.name || n.food || `INDB Item ${i + 1}`,
    group: n.food_group || n.group || n.category || '',
    
    energy_kcal: parseFloat(n.energy_kcal || n.energy || n.kcal || 0),
    protein_g: parseFloat(n.protein_g || n.protein || n.prot || 0),
    fat_g: parseFloat(n.fat_g || n.fat || n.total_fat || 0),
    carbs_g: parseFloat(n.carbohydrate_g || n.carbohydrate || n.cho || 0),
    fiber_g: parseFloat(n.dietary_fibre_g || n.fibre || n.fiber || 0),
    
    calcium_mg: parseFloat(n.calcium_mg || n.calcium || n.ca || 0),
    iron_mg: parseFloat(n.iron_mg || n.iron || n.fe || 0),
    magnesium_mg: parseFloat(n.magnesium_mg || n.magnesium || n.mg || 0),
    phosphorus_mg: parseFloat(n.phosphorus_mg || n.phosphorus || n.p || 0),
    potassium_mg: parseFloat(n.potassium_mg || n.potassium || n.k || 0),
    sodium_mg: parseFloat(n.sodium_mg || n.sodium || n.na || 0),
    zinc_mg: parseFloat(n.zinc_mg || n.zinc || n.zn || 0),
    
    vitaminA_ug: parseFloat(n.vitamin_a_ug || n.vitamin_a || n.vita || 0),
    vitaminC_mg: parseFloat(n.vitamin_c_mg || n.vitamin_c || n.vitc || 0),
    vitaminB1_thiamine_mg: parseFloat(n.thiamine_mg || n.thiamine || n.thia || 0),
    vitaminB2_riboflavin_mg: parseFloat(n.riboflavin_mg || n.riboflavin || n.ribf || 0),
    vitaminB3_niacin_mg: parseFloat(n.niacin_mg || n.niacin || n.nia || 0),
    vitaminB9_folate_ug: parseFloat(n.folate_ug || n.folate || n.fol || 0),
    
    source: 'indb',
    priority: 2
  };
});

fs.writeFileSync('./data/raw/indb_extracted.json', JSON.stringify(extracted, null, 2));
console.log(`✨ Extracted ${extracted.length} INDB composite recipes`);
