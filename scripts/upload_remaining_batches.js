const fs = require('fs');
const path = require('path');

// Try loading dotenv from etl module to auto-populate credentials from .env
try {
    const dotenvPath = path.join(__dirname, '../etl/node_modules/dotenv');
    require(dotenvPath).config({ path: path.join(__dirname, '../.env') });
} catch (err) {
    try {
        require('dotenv').config({ path: path.join(__dirname, '../.env') });
    } catch (e) {
        // Silent fallback
    }
}

console.log('⚡ Initializing Pre-generated Batches Uploader...');

const BATCH_DIR = path.join(__dirname, '../etl/output/batches');
const APPWRITE_ENDPOINT = process.env.APPWRITE_ENDPOINT || 'https://sgp.cloud.appwrite.io/v1';
const APPWRITE_PROJECT_ID = process.env.APPWRITE_PROJECT_ID;
const APPWRITE_API_KEY = process.env.APPWRITE_API_KEY;
const APPWRITE_DATABASE_ID = process.env.APPWRITE_DATABASE_ID || 'fitkarma-db';
const APPWRITE_COLLECTION_ID = process.env.APPWRITE_COLLECTION_ID || 'food_database';

if (!APPWRITE_PROJECT_ID || !APPWRITE_API_KEY) {
    console.error('❌ Missing APPWRITE_PROJECT_ID or APPWRITE_API_KEY in .env file.');
    process.exit(1);
}

// Load node-appwrite
let nodeAppwrite;
try {
    nodeAppwrite = require('node-appwrite');
} catch (err) {
    try {
        nodeAppwrite = require('../etl/node_modules/node-appwrite');
    } catch (e) {
        console.error('❌ node-appwrite package not found. Run "npm install" in etl directory.');
        process.exit(1);
    }
}

const { Client, Databases, ID } = nodeAppwrite;

const client = new Client()
    .setEndpoint(APPWRITE_ENDPOINT)
    .setProject(APPWRITE_PROJECT_ID)
    .setKey(APPWRITE_API_KEY);

const databases = new Databases(client);

// Parse starting batch index from command line arguments
const args = process.argv.slice(2);
let startBatch = 1;
if (args.length > 0) {
    const parsed = parseInt(args[0], 10);
    if (!isNaN(parsed) && parsed > 0) {
        startBatch = parsed;
    }
}

console.log(`\n📡 Target Appwrite Project: ${APPWRITE_PROJECT_ID}`);
console.log(`📂 Reading batches from: ${BATCH_DIR}`);
console.log(`🚀 Starting upload from Batch #${startBatch} up to 1550\n`);
console.log('💡 Tip: To start from a different batch, run: node scripts/upload_remaining_batches.js <BATCH_NUMBER>');
console.log('--------------------------------------------------------------------------------');

async function uploadBatchFiles() {
    const totalBatches = 1550;
    
    for (let batchIndex = startBatch; batchIndex <= totalBatches; batchIndex++) {
        const batchFileName = `batch_${String(batchIndex).padStart(4, '0')}.json`;
        const batchFilePath = path.join(BATCH_DIR, batchFileName);
        
        if (!fs.existsSync(batchFilePath)) {
            console.warn(`⚠ Batch file not found: ${batchFileName}, skipping...`);
            continue;
        }
        
        console.log(`⏳ Processing ${batchFileName}...`);
        let batchData;
        try {
            batchData = JSON.parse(fs.readFileSync(batchFilePath, 'utf8'));
        } catch (err) {
            console.error(`❌ Failed to parse JSON in ${batchFileName}: ${err.message}`);
            continue;
        }

        let successCount = 0;
        let failCount = 0;

        for (const doc of batchData) {
            try {
                const appwriteDoc = { ...doc };
                // Strip local-only management properties matching original seed script logic
                delete appwriteDoc.priority;
                delete appwriteDoc.bundled;
                delete appwriteDoc.group;

                await databases.createDocument(
                    APPWRITE_DATABASE_ID,
                    APPWRITE_COLLECTION_ID,
                    ID.unique(),
                    appwriteDoc
                );
                successCount++;
                // 50ms delay for gentle, continuous cloud rate-limiting compliance
                await new Promise(resolve => setTimeout(resolve, 50));
            } catch (err) {
                failCount++;
                console.error(`  ⚠ Failed to upload "${doc.name}": ${err.message}`);
            }
        }
        
        console.log(`✔ Completed ${batchFileName}: ${successCount} successfully uploaded, ${failCount} failed.`);
    }
    
    console.log('\n✨ All requested batches have been processed!');
}

uploadBatchFiles().catch(err => {
    console.error('❌ Uncaught upload error:', err);
});
