const fs = require('fs');
const path = require('path');
const readline = require('readline');

console.log('⚡ Initializing Phase L — Database Seeding, Tiering Partition & Appwrite Cloud Batch Builder...');

const SEED_FILE = path.join(__dirname, '../assets/data/indian_foods_seed.json');
const BATCH_DIR = path.join(__dirname, '../etl/output/batches');

if (!fs.existsSync(BATCH_DIR)) {
    fs.mkdirSync(BATCH_DIR, { recursive: true });
}

const TIER1_SOURCES = new Set(['ifct2017', 'icmr_nin', 'indb', 'kaggle', 'spoonacular', 'fao_infoods', 'phase_i_expansion']);

const APPWRITE_ENDPOINT = process.env.APPWRITE_ENDPOINT || 'https://sgp.cloud.appwrite.io/v1';
const APPWRITE_PROJECT_ID = process.env.APPWRITE_PROJECT_ID;
const APPWRITE_API_KEY = process.env.APPWRITE_API_KEY;
const APPWRITE_DATABASE_ID = process.env.APPWRITE_DATABASE_ID || 'fitkarma-db';
const APPWRITE_COLLECTION_ID = process.env.APPWRITE_COLLECTION_ID || 'food_database';
const ENABLE_REAL_UPLOAD = process.env.ENABLE_REAL_UPLOAD === 'true';

let appwriteDatabases = null;
let batchesForUpload = [];
let totalProcessed = 0;
let tier1Count = 0;
let tier2Count = 0;

async function initAppwrite() {
    if (!ENABLE_REAL_UPLOAD) return null;
    
    try {
        let nodeAppwrite;
        try {
            nodeAppwrite = require('node-appwrite');
        } catch (err) {
            nodeAppwrite = require('../etl/node_modules/node-appwrite');
        }
        const { Client, Databases } = nodeAppwrite;
        appwriteDatabases = new Databases(
            new Client()
                .setEndpoint(APPWRITE_ENDPOINT)
                .setProject(APPWRITE_PROJECT_ID)
                .setKey(APPWRITE_API_KEY)
        );
        console.log('✔ Appwrite client initialized');
        return true;
    } catch (e) {
        console.error('⚠ Failed to initialize Appwrite client:', e.message);
        return false;
    }
}

async function uploadBatch(batch, batchIndex, totalBatches) {
    if (!appwriteDatabases) return false;
    
    let successCount = 0;
    let failCount = 0;
    
    for (let i = 0; i < batch.length; i++) {
        const doc = batch[i];
        try {
            const appwriteDoc = { ...doc };
            delete appwriteDoc.priority;
            delete appwriteDoc.bundled;
            delete appwriteDoc.group;
            await appwriteDatabases.createDocument(
                APPWRITE_DATABASE_ID,
                APPWRITE_COLLECTION_ID,
                'unique()',
                appwriteDoc
            );
            successCount++;
            await new Promise(r => setTimeout(r, 100)); // Rate limiting
        } catch (e) {
            failCount++;
            console.error(`  ⚠ Failed to upload ${doc.name}: ${e.message}`);
        }
    }
    
    console.log(`    Uploaded batch ${batchIndex}/${totalBatches}: ${successCount} success, ${failCount} failed`);
    return true;
}

async function processFile() {
    totalProcessed = 0;
    tier1Count = 0;
    tier2Count = 0;
    let currentBatch = [];
    let batchIndex = 1;
    const maxBatchesToGenerate = 1550;

    const fileStream = fs.createReadStream(SEED_FILE, { encoding: 'utf8' });
    const rl = readline.createInterface({ input: fileStream, crlftDelay: Infinity });

    rl.on('line', line => {
        const cleanLine = line.replace(/^,/, '').trim();
        if (!cleanLine.startsWith('{')) return;

        totalProcessed++;

        let itemObj = {};
        try {
            itemObj = JSON.parse(cleanLine.replace(/,+$/, ''));
        } catch (e) {
            // fallback
        }

        const src = itemObj.source || 'unknown';
        const priority = itemObj.priority !== undefined ? Number(itemObj.priority) : 99;
        const isTier1 = TIER1_SOURCES.has(src) || priority <= 4 || cleanLine.includes('"premium"') || cleanLine.includes('"phase-i"');

        if (isTier1) tier1Count++; else tier2Count++;

        if (batchIndex <= maxBatchesToGenerate) {
            const safeNum = val => (val !== undefined && val !== null && !isNaN(Number(val)) ? Number(val) : null);
            const name = itemObj.name || `Food Document #${totalProcessed}`;
            const caloriesPer100g = safeNum(itemObj.caloriesPer100g ?? itemObj.energy_kcal) || 0;

            let nameHindi = itemObj.nameHindi || null;
            if (!nameHindi && itemObj.languageNames && itemObj.languageNames.H) {
                nameHindi = Array.isArray(itemObj.languageNames.H) ? itemObj.languageNames.H.join(', ') : String(itemObj.languageNames.H);
            }
            const nameRegional = itemObj.nameRegional || itemObj.lang || null;
            const servingSizesStr = typeof itemObj.servingSizes === 'object' && itemObj.servingSizes !== null 
                ? JSON.stringify(itemObj.servingSizes) 
                : (itemObj.servingSizes ? String(itemObj.servingSizes) : null);

            const enrichedDoc = {
                name: name ? String(name).substring(0, 200) : 'Unknown',
                nameHindi: nameHindi ? String(nameHindi).substring(0, 200) : null,
                nameRegional: nameRegional ? String(nameRegional).substring(0, 200) : null,
                category: itemObj.category ? String(itemObj.category).substring(0, 50) : (itemObj.group ? String(itemObj.group).substring(0, 50) : null),
                cuisine: itemObj.cuisine ? String(itemObj.cuisine).substring(0, 50) : null,
                caloriesPer100g,
                proteinPer100g: safeNum(itemObj.proteinPer100g ?? itemObj.protein_g),
                carbsPer100g: safeNum(itemObj.carbsPer100g ?? itemObj.carbs_g),
                fatPer100g: safeNum(itemObj.fatPer100g ?? itemObj.fat_g),
                fiberPer100g: safeNum(itemObj.fiberPer100g ?? itemObj.fiber_g),
                barcode: itemObj.barcode ? String(itemObj.barcode).substring(0, 20) : null,
                servingSizes: servingSizesStr ? servingSizesStr.substring(0, 500) : null,
                emoji: itemObj.emoji ? String(itemObj.emoji).substring(0, 4) : null,
                source: src ? String(src).substring(0, 20) : null,
                calcium_mg: safeNum(itemObj.calcium_mg),
                iron_mg: safeNum(itemObj.iron_mg),
                vitaminC_mg: safeNum(itemObj.vitaminC_mg),
                vitaminA_ug: safeNum(itemObj.vitaminA_ug),
                vitaminD_ug: safeNum(itemObj.vitaminD_ug),
                vitaminB12_ug: safeNum(itemObj.vitaminB12_ug),
                folate_ug: safeNum(itemObj.folate_ug ?? itemObj.vitaminB9_folate_ug),
                zinc_mg: safeNum(itemObj.zinc_mg),
                sodium_mg: safeNum(itemObj.sodium_mg),
                potassium_mg: safeNum(itemObj.potassium_mg),
                magnesium_mg: safeNum(itemObj.magnesium_mg),
                glycemicIndex: safeNum(itemObj.glycemicIndex),
                omega3_g: safeNum(itemObj.omega3_g),
                saturatedFat_g: safeNum(itemObj.saturatedFat_g),
                transFat_g: safeNum(itemObj.transFat_g),
                isVegan: Boolean(itemObj.isVegan),
                isJain: Boolean(itemObj.isJain),
                isSattvic: Boolean(itemObj.isSattvic),
                isGlutenFree: Boolean(itemObj.isGlutenFree),
                isNavratriSafe: Boolean(itemObj.isNavratriSafe),
                isDiabeticFriendly: Boolean(itemObj.isDiabeticFriendly),
                priority,
                bundled: isTier1,
                group: itemObj.group || null
            };

            currentBatch.push(enrichedDoc);

            if (currentBatch.length === 100) {
                const batchFileName = `batch_${String(batchIndex).padStart(4, '0')}.json`;
                const batchFilePath = path.join(BATCH_DIR, batchFileName);
                fs.writeFileSync(batchFilePath, JSON.stringify(currentBatch, null, 2));
                batchesForUpload.push({ batch: [...currentBatch], index: batchIndex });
                currentBatch = [];
                batchIndex++;

                if (batchIndex % 250 === 0) {
                    console.log(`✔ Synthesized ${batchIndex - 1} Appwrite import batches...`);
                }
            }
        }
    });

    return new Promise(resolve => {
        rl.on('close', resolve);
    });
}

(async () => {
    if (!fs.existsSync(SEED_FILE)) {
        console.error(`❌ Master database file not accessible at ${SEED_FILE}`);
        process.exit(1);
    }

    const hasRealCredentials = APPWRITE_PROJECT_ID && APPWRITE_API_KEY;
    if (ENABLE_REAL_UPLOAD && !hasRealCredentials) {
        console.warn('⚠ ENABLE_REAL_UPLOAD is true but credentials not found.');
    }

    console.log('Streaming master dataset...');
    if (ENABLE_REAL_UPLOAD) {
        console.log('📡 Real Appwrite upload mode ENABLED');
        const initialized = await initAppwrite();
        if (!initialized) {
            console.error('Failed to initialize Appwrite. Check credentials.');
            process.exit(1);
        }
    }

    await processFile();

    const generatedDocsCount = batchesForUpload.length * 100;

    console.log('\n📊 Phase L — Data Seeding & Integration Execution Report:');
    console.log('--------------------------------------------------------------------------------');
    console.log(`Total Unified Records Streamed      | ${totalProcessed.toLocaleString()} items`);
    console.log(`Tier 1 Offline Bundled Target Count | ${tier1Count.toLocaleString()} pre-loaded items`);
    console.log(`Tier 2 Cloud On-Demand Search Depth | ${tier2Count.toLocaleString()} items`);
    console.log(`Appwrite Batches Exported to Disk   | ${batchesForUpload.length} files`);
    console.log(`Total Documents Packaged for Upload | ${generatedDocsCount.toLocaleString()} documents`);
    console.log('--------------------------------------------------------------------------------');

    if (ENABLE_REAL_UPLOAD && appwriteDatabases && batchesForUpload.length > 0) {
        console.log('\n📤 Uploading batches to Appwrite...');
        for (const { batch, index } of batchesForUpload) {
            await uploadBatch(batch, index, batchesForUpload.length);
        }
        console.log('\n✨ Documents uploaded to Appwrite!');
    } else {
        console.log('\n🚀 Mock mode - set ENABLE_REAL_UPLOAD=true with APPWRITE_PROJECT_ID and APPWRITE_API_KEY');
    }
})();