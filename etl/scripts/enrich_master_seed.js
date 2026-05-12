/**
 * enrich_master_seed.js — Option 2 Utility Script
 * 
 * Permanently streams and enriches assets/data/indian_foods_seed.json in-place
 * with servingSizes, emoji, language fields, and boolean dietary flags.
 */

import fs from 'fs';
import path from 'path';
import readline from 'readline';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const SEED_FILE = path.join(__dirname, '../../assets/data/indian_foods_seed.json');
const TEMP_FILE = path.join(__dirname, '../../assets/data/indian_foods_seed_temp.json');

console.log('⚡ Initializing Master Seed Enrichment Utility (Option 2)...');
console.log(`Input File: ${SEED_FILE}`);

if (!fs.existsSync(SEED_FILE)) {
    console.error(`❌ Master seed file not found at ${SEED_FILE}`);
    process.exit(1);
}

const safeNum = val => (val !== undefined && val !== null && !isNaN(Number(val)) ? Number(val) : null);

const outStream = fs.createWriteStream(TEMP_FILE, { encoding: 'utf8' });
outStream.write('[\n');

const fileStream = fs.createReadStream(SEED_FILE, { encoding: 'utf8' });
const rl = readline.createInterface({ input: fileStream, crlfDelay: Infinity });

let totalProcessed = 0;
let firstItem = true;

rl.on('line', line => {
    const cleanLine = line.replace(/^,/, '').trim();
    if (!cleanLine.startsWith('{')) return;

    let itemObj = {};
    try {
        itemObj = JSON.parse(cleanLine.replace(/,+$/, ''));
    } catch (e) {
        return;
    }

    totalProcessed++;
    if (totalProcessed % 100_000 === 0) {
        process.stdout.write(`\r✔ Enriched ${totalProcessed.toLocaleString()} items...`);
    }

    const name = itemObj.name || `Food Document #${totalProcessed}`;
    
    // 1. Multilingual Fallbacks
    let nameHindi = itemObj.nameHindi || null;
    if (!nameHindi && itemObj.languageNames && itemObj.languageNames.H) {
        nameHindi = Array.isArray(itemObj.languageNames.H) ? itemObj.languageNames.H.join(', ') : String(itemObj.languageNames.H);
    }
    if (!nameHindi && itemObj.lang) {
        const hMatch = itemObj.lang.match(/H\.\s*([^;]+)/);
        if (hMatch) nameHindi = hMatch[1].trim();
    }
    const nameRegional = itemObj.nameRegional || itemObj.lang || null;

    // 2. Cuisine Fallback
    let cuisine = itemObj.cuisine || null;
    if (!cuisine) {
        const lowerTags = (itemObj.tags || '').toLowerCase();
        if (lowerTags.includes('south indian')) cuisine = 'South Indian';
        else if (lowerTags.includes('north indian')) cuisine = 'North Indian';
        else cuisine = 'Indian';
    }

    // 3. Serving Sizes Fallback
    let servingSizesStr = typeof itemObj.servingSizes === 'object' && itemObj.servingSizes !== null 
        ? JSON.stringify(itemObj.servingSizes) 
        : (itemObj.servingSizes ? String(itemObj.servingSizes) : null);
    if (!servingSizesStr) {
        servingSizesStr = JSON.stringify([
            { label: "100g", weight_g: 100 },
            { label: "1 standard serving", weight_g: 150 }
        ]);
    }

    // 4. Vibrant Emoji Fallback
    let emoji = itemObj.emoji || null;
    if (!emoji) {
        const groupLower = (itemObj.group || '').toLowerCase();
        const nameLower = (name || '').toLowerCase();
        if (groupLower.includes('cereal') || groupLower.includes('millet')) emoji = '🌾';
        else if (groupLower.includes('legume') || groupLower.includes('pulse') || nameLower.includes('dal')) emoji = '🫘';
        else if (groupLower.includes('leafy') || nameLower.includes('spinach') || nameLower.includes('saag')) emoji = '🥬';
        else if (groupLower.includes('tuber') || nameLower.includes('potato') || nameLower.includes('aloo')) emoji = '🥔';
        else if (groupLower.includes('vegetable')) emoji = '🥦';
        else if (groupLower.includes('fruit')) emoji = '🍎';
        else if (groupLower.includes('nut') || groupLower.includes('seed')) emoji = '🥜';
        else if (groupLower.includes('sugar') || groupLower.includes('sweet') || nameLower.includes('ladoo')) emoji = '🍬';
        else if (groupLower.includes('beverage') || nameLower.includes('tea') || nameLower.includes('chai')) emoji = '☕';
        else if (groupLower.includes('fat') || groupLower.includes('oil') || nameLower.includes('ghee')) emoji = '🧈';
        else if (groupLower.includes('meat') || groupLower.includes('poultry') || nameLower.includes('chicken')) emoji = '🍗';
        else if (groupLower.includes('fish') || groupLower.includes('sea')) emoji = '🐟';
        else if (groupLower.includes('milk') || nameLower.includes('paneer') || nameLower.includes('curd')) emoji = '🥛';
        else if (groupLower.includes('spice')) emoji = '🌶️';
        else emoji = '🍲';
    }

    // 5. Intelligent Dietary Logic Inference
    const tagsLower = (itemObj.tags || '').toLowerCase();
    const groupLower = (itemObj.group || '').toLowerCase();
    const nameLower = (name || '').toLowerCase();

    const isMeatGroup = groupLower.includes('meat') || groupLower.includes('poultry') || groupLower.includes('fish') || groupLower.includes('egg');
    const hasAnimalKeywords = nameLower.includes('chicken') || nameLower.includes('mutton') || nameLower.includes('beef') || nameLower.includes('pork') || nameLower.includes('fish') || nameLower.includes('prawn') || nameLower.includes('egg');
    const hasDairyKeywords = nameLower.includes('milk') || nameLower.includes('paneer') || nameLower.includes('ghee') || nameLower.includes('butter') || nameLower.includes('curd') || nameLower.includes('cheese') || nameLower.includes('whey');

    let isVegan = itemObj.isVegan !== undefined ? Boolean(itemObj.isVegan) : false;
    if (itemObj.isVegan === undefined) {
        if (tagsLower.includes('vegan')) {
            isVegan = true;
        } else if (!isMeatGroup && !hasAnimalKeywords && !hasDairyKeywords && !groupLower.includes('milk')) {
            isVegan = true;
        }
    }

    let isJain = itemObj.isJain !== undefined ? Boolean(itemObj.isJain) : false;
    if (itemObj.isJain === undefined) {
        const isRootGroup = groupLower.includes('root') || groupLower.includes('tuber');
        const hasRootKeywords = nameLower.includes('onion') || nameLower.includes('garlic') || nameLower.includes('potato') || nameLower.includes('aloo') || nameLower.includes('ginger') || nameLower.includes('carrot') || nameLower.includes('radish') || nameLower.includes('beetroot');
        if (isVegan && !isRootGroup && !hasRootKeywords) {
            isJain = true;
        }
    }

    let isSattvic = itemObj.isSattvic !== undefined ? Boolean(itemObj.isSattvic) : false;
    if (itemObj.isSattvic === undefined) {
        const hasRajasicTamasicKeywords = nameLower.includes('onion') || nameLower.includes('garlic') || nameLower.includes('chilli') || nameLower.includes('pepper') || nameLower.includes('tea') || nameLower.includes('coffee') || nameLower.includes('alcohol') || nameLower.includes('fried');
        if (isVegan && !hasRajasicTamasicKeywords) {
            isSattvic = true;
        }
    }

    let isGlutenFree = itemObj.isGlutenFree !== undefined ? Boolean(itemObj.isGlutenFree) : false;
    if (itemObj.isGlutenFree === undefined) {
        const hasGlutenKeywords = nameLower.includes('wheat') || nameLower.includes('maida') || nameLower.includes('suji') || nameLower.includes('semolina') || nameLower.includes('barley') || nameLower.includes('rye') || nameLower.includes('pasta') || nameLower.includes('bread') || nameLower.includes('noodle');
        if (!hasGlutenKeywords) {
            isGlutenFree = true;
        }
    }

    let isNavratriSafe = itemObj.isNavratriSafe !== undefined ? Boolean(itemObj.isNavratriSafe) : false;
    if (itemObj.isNavratriSafe === undefined) {
        const isVratFriendlyKeyword = nameLower.includes('kuttu') || nameLower.includes('buckwheat') || nameLower.includes('singhara') || nameLower.includes('amaranth') || nameLower.includes('ramdana') || nameLower.includes('sabudana') || nameLower.includes('makhana') || groupLower.includes('fruit');
        const hasProhibitedKeywords = nameLower.includes('wheat') || nameLower.includes('rice') || nameLower.includes('dal') || nameLower.includes('onion') || nameLower.includes('garlic');
        if (isVratFriendlyKeyword && !hasProhibitedKeywords) {
            isNavratriSafe = true;
        }
    }

    let isDiabeticFriendly = itemObj.isDiabeticFriendly !== undefined ? Boolean(itemObj.isDiabeticFriendly) : false;
    if (itemObj.isDiabeticFriendly === undefined) {
        const gi = safeNum(itemObj.glycemicIndex);
        const sugars = safeNum(itemObj.sugars_g);
        const fiber = safeNum(itemObj.fiber_g);
        if ((gi !== null && gi < 55) || (sugars !== null && sugars <= 5 && fiber !== null && fiber >= 3) || groupLower.includes('leafy') || groupLower.includes('legume')) {
            isDiabeticFriendly = true;
        }
    }

    // Attach missing keys permanently to itemObj
    itemObj.nameHindi = nameHindi ? String(nameHindi).substring(0, 200) : null;
    itemObj.nameRegional = nameRegional ? String(nameRegional).substring(0, 200) : null;
    itemObj.cuisine = cuisine ? String(cuisine).substring(0, 50) : null;
    itemObj.servingSizes = servingSizesStr ? servingSizesStr.substring(0, 500) : null;
    itemObj.emoji = emoji ? String(emoji).substring(0, 4) : null;
    itemObj.isVegan = isVegan;
    itemObj.isJain = isJain;
    itemObj.isSattvic = isSattvic;
    itemObj.isGlutenFree = isGlutenFree;
    itemObj.isNavratriSafe = isNavratriSafe;
    itemObj.isDiabeticFriendly = isDiabeticFriendly;

    // Write record cleanly
    const prefix = firstItem ? '' : ',\n';
    outStream.write(prefix + JSON.stringify(itemObj));
    firstItem = false;
});

rl.on('close', () => {
    outStream.write('\n]\n');
    outStream.end();
});

outStream.on('finish', () => {
    process.stdout.write('\n');
    console.log(`✔ Finished stream writing ${totalProcessed.toLocaleString()} fully enriched records.`);
    console.log('💾 Overwriting original master seed file atomically...');
    fs.renameSync(TEMP_FILE, SEED_FILE);
    console.log('✨ Success! assets/data/indian_foods_seed.json is permanently enriched with all properties.');
});
