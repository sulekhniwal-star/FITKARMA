/**
 * download_kaggle.js — Download Phase B Kaggle datasets via REST API
 *
 * Reads credentials from ~/.kaggle/kaggle.json (username + key).
 * Downloads zip, extracts target CSV into etl/data/raw/.
 */

import axios from 'axios';
import fs from 'fs';
import path from 'path';
import os from 'os';
import { fileURLToPath } from 'url';
import { createWriteStream } from 'fs';
import { pipeline } from 'stream/promises';
import { createUnzip } from 'zlib';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const RAW_DIR = path.join(__dirname, '../data/raw');

// Load Kaggle credentials
const credPath = path.join(os.homedir(), '.kaggle', 'kaggle.json');
if (!fs.existsSync(credPath)) {
  console.error('❌ ~/.kaggle/kaggle.json not found');
  process.exit(1);
}
const { username, key } = JSON.parse(fs.readFileSync(credPath, 'utf8'));
const auth = { username, password: key };

const DATASETS = [
  {
    owner: 'batthulavinay',
    dataset: 'indian-food-nutrition',
    file: 'Indian_Food_Nutrition_Processed.csv',
    dest: 'Indian_Food_Nutrition_Processed.csv',
  },
  {
    owner: 'ahsanneural',
    dataset: '10k-south-asian-recipes-with-nutrition-and-steps',
    file: '10k_south_asian_recipes.csv',
    dest: '10k_south_asian_recipes.csv',
  },
  {
    owner: 'gijoe707',
    dataset: 'ifct2017',
    file: 'ifct2017_compositions.csv',
    dest: 'ifct2017_compositions.csv',
  },
  {
    owner: 'sonalshinde123',
    dataset: 'food-nutrition-dataset-150-everyday-foods',
    file: 'everyday_foods_150.csv',
    dest: 'everyday_foods_150.csv',
  },
  {
    owner: 'umangsinghal5',
    dataset: 'nutritional-and-carbon-footprint-data-of-indian-diet',
    file: 'indian_diet_footprint.csv',
    dest: 'indian_diet_footprint.csv',
  },
];

async function downloadFile(owner, dataset, file, dest) {
  const url = `https://www.kaggle.com/api/v1/datasets/download/${owner}/${dataset}/${file}`;
  const destPath = path.join(RAW_DIR, dest);

  console.log(`⬇  ${owner}/${dataset}/${file}`);
  const res = await axios.get(url, {
    auth,
    responseType: 'stream',
    maxRedirects: 5,
    timeout: 120_000,
  });

  // Response may be gzip-compressed even for CSV files
  const contentEncoding = res.headers['content-encoding'];
  const isGzip = contentEncoding === 'gzip' || file.endsWith('.gz');

  const dest$ = createWriteStream(destPath);
  if (isGzip) {
    await pipeline(res.data, createUnzip(), dest$);
  } else {
    await pipeline(res.data, dest$);
  }

  const size = fs.statSync(destPath).size;
  console.log(`   ✅ ${dest} (${(size / 1024).toFixed(1)} KB)`);
}

for (const d of DATASETS) {
  try {
    await downloadFile(d.owner, d.dataset, d.file, d.dest);
  } catch (err) {
    const status = err.response?.status;
    console.error(`   ❌ ${d.owner}/${d.dataset}: HTTP ${status ?? err.message}`);
    // Continue — normaliser will skip missing files
  }
}

console.log('\n✨ Kaggle download complete.');
