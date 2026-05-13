const fs = require('fs');
const path = require('path');

// Auto-load credentials from .env
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

console.log('⚡ Initializing Complete Database Reset & Batch Uploader...');

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

const { Client, Databases, ID, Query } = nodeAppwrite;

const client = new Client()
    .setEndpoint(APPWRITE_ENDPOINT)
    .setProject(APPWRITE_PROJECT_ID)
    .setKey(APPWRITE_API_KEY);

const databases = new Databases(client);

console.log(`\n📡 Target Appwrite Project: ${APPWRITE_PROJECT_ID}`);
console.log(`📂 Collection: ${APPWRITE_COLLECTION_ID}`);
console.log('--------------------------------------------------------------------------------');

async function clearCollection() {
    console.log('🗑️ Phase 1: Deleting all previously uploaded documents to start fresh...');
    let deletedCount = 0;
    
    while (true) {
        try {
            // Fetch up to 100 documents at a time using the official Query helper
            const response = await databases.listDocuments(
                APPWRITE_DATABASE_ID,
                APPWRITE_COLLECTION_ID,
                [Query.limit(100)]
            );

            if (!response.documents || response.documents.length === 0) {
                break;
            }

            for (const doc of response.documents) {
                try {
                    await databases.deleteDocument(
                        APPWRITE_DATABASE_ID,
                        APPWRITE_COLLECTION_ID,
                        doc.$id
                    );
                    deletedCount++;
                } catch (delErr) {
                    // Gracefully ignore 404 errors if document is already deleted/eventually consistent
                    if (delErr.code !== 404) {
                        console.warn(`  ⚠ Non-404 error deleting doc ${doc.$id}:`, delErr.message);
                    }
                }
                // Gentle 50ms pause per document to prevent Cloudflare/Appwrite rate limiting and TCP exhaustion
                await new Promise(resolve => setTimeout(resolve, 50));
            }
            
            console.log(`  ✔ Deleted ${deletedCount} documents so far...`);
        } catch (err) {
            console.error('❌ Error during deletion phase:', err.message);
            console.log('Cooling down for 5 seconds before retrying...');
            await new Promise(resolve => setTimeout(resolve, 5000));
        }
    }
    
    console.log(`✔ Phase 1 Complete: Successfully cleared all ${deletedCount} documents!\n`);
}

async function uploadAllBatches() {
    console.log('🚀 Phase 2: Uploading all 1550 pre-generated batches from scratch...');
    const totalBatches = 1550;
    let totalUploaded = 0;
    
    for (let batchIndex = 1; batchIndex <= totalBatches; batchIndex++) {
        const batchFileName = `batch_${String(batchIndex).padStart(4, '0')}.json`;
        const batchFilePath = path.join(BATCH_DIR, batchFileName);
        
        if (!fs.existsSync(batchFilePath)) {
            console.warn(`⚠ Batch file not found: ${batchFileName}, skipping...`);
            continue;
        }
        
        console.log(`⏳ Uploading ${batchFileName}...`);
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
                totalUploaded++;
                await new Promise(resolve => setTimeout(resolve, 50));
            } catch (err) {
                failCount++;
                console.error(`  ⚠ Failed to upload "${doc.name}": ${err.message}`);
            }
        }
        
        console.log(`✔ Completed ${batchFileName}: ${successCount} success, ${failCount} failed. (Total uploaded: ${totalUploaded})`);
    }
    
    console.log(`\n✨ Phase 2 Complete: Successfully uploaded ${totalUploaded} documents from all batches!`);
}

async function main() {
    await clearCollection();
    await uploadAllBatches();
}

main().catch(err => {
    console.error('❌ Uncaught execution error:', err);
});
