import fs from 'fs';
import { createReadStream } from 'fs';
import readline from 'readline';

const path = 'assets/data/indian_foods_seed.json';
const stat = fs.statSync(path);
console.log('File size:', (stat.size / 1024 / 1024).toFixed(1) + ' MB');

let count = 0;
const sources = {};
const rl = readline.createInterface({ input: createReadStream(path, { encoding: 'utf8' }) });

rl.on('line', line => {
  const clean = line.replace(/^,/, '').trim();
  if (!clean.startsWith('{')) return;
  count++;
  const m = clean.match(/"source":"([^"]+)"/);
  if (m) sources[m[1]] = (sources[m[1]] || 0) + 1;
});

rl.on('close', () => {
  console.log('Total items:', count.toLocaleString());
  console.log('Sources:');
  for (const [src, cnt] of Object.entries(sources)) {
    console.log(`  ${src}: ${cnt.toLocaleString()}`);
  }
});
