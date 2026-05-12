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
            const appwriteDoc = {
                name: doc.name ? String(doc.name).substring(0, 200) : 'Unknown',
                source: doc.source ? String(doc.source).substring(0, 20) : null,
                caloriesPer100g: Number(doc.caloriesPer100g) || 0,
                category: doc.category ? String(doc.category).substring(0, 50) : (doc.group ? String(doc.group).substring(0, 50) : null)
            };
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

        const srcMatch = cleanLine.match(/"source":"([^"]+)"/);
        const src = srcMatch ? srcMatch[1] : 'unknown';

        const priorityMatch = cleanLine.match(/"priority":([0-9]+)/);
        const priority = priorityMatch ? parseInt(priorityMatch[1], 10) : 99;

        const isTier1 = TIER1_SOURCES.has(src) || priority <= 4 || cleanLine.includes('"premium"') || cleanLine.includes('"phase-i"');

        if (isTier1) tier1Count++; else tier2Count++;

        if (batchIndex <= maxBatchesToGenerate) {
            const nameMatch = cleanLine.match(/"name":"([^"]+)"/);
            const name = nameMatch ? nameMatch[1] : `Food Document #${totalProcessed}`;
            
            const calMatch = cleanLine.match(/"(?:caloriesPer100g|energy_kcal)":([0-9.]+)/);
            const caloriesPer100g = calMatch ? parseFloat(calMatch[1]) : 0;

            const groupMatch = cleanLine.match(/"group":"([^"]+)"/);
            const categoryMatch = cleanLine.match(/"category":"([^"]+)"/);

            currentBatch.push({
                name,
                source: src,
                priority,
                caloriesPer100g,
                bundled: isTier1,
                group: groupMatch ? groupMatch[1] : null,
                category: categoryMatch ? categoryMatch[1] : null,
            });

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
        const batchesToUpload = batchesForUpload.slice(0, 5);
        for (const { batch, index } of batchesToUpload) {
            await uploadBatch(batch, index, batchesToUpload.length);
        }
        console.log('\n✨ Documents uploaded to Appwrite!');
    } else {
        console.log('\n🚀 Mock mode - set ENABLE_REAL_UPLOAD=true with APPWRITE_PROJECT_ID and APPWRITE_API_KEY');
    }
})();