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

async function executeWithRetry(operation, maxRetries = 5, baseDelay = 1000) {
    for (let attempt = 1; attempt <= maxRetries; attempt++) {
        try {
            return await operation();
        } catch (err) {
            // Treat 409 (Document already exists) as a successful upload to avoid duplicate errors
            if (err.code === 409) {
                return;
            }
            const isTransient = !err.code || err.code >= 500 || err.code === 429 || (err.message && err.message.includes('fetch failed'));
            if (!isTransient || attempt === maxRetries) {
                throw err;
            }
            const delay = baseDelay * Math.pow(2, attempt - 1) + Math.random() * 200;
            console.warn(`    ⚠ Transient error (${err.message}). Retrying attempt ${attempt}/${maxRetries} in ${Math.round(delay)}ms...`);
            await new Promise(resolve => setTimeout(resolve, delay));
        }
    }
}

async function clearCollection() {
    console.log('🗑️ Phase 1: Deleting all previously uploaded documents to start fresh...');
    let deletedCount = 0;
    
    while (true) {
        try {
            // Fetch up to 100 documents at a time using the official Query helper with retries
            const response = await executeWithRetry(async () => {
                return await databases.listDocuments(
                    APPWRITE_DATABASE_ID,
                    APPWRITE_COLLECTION_ID,
                    [Query.limit(100)]
                );
            });

            if (!response.documents || response.documents.length === 0) {
                break;
            }

            for (const doc of response.documents) {
                try {
                    await executeWithRetry(async () => {
                        await databases.deleteDocument(
                            APPWRITE_DATABASE_ID,
                            APPWRITE_COLLECTION_ID,
                            doc.$id
                        );
                    });
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
    const failedDocuments = [];
    const FAILED_UPLOADS_PATH = path.join(__dirname, '../etl/output/failed_uploads.json');
    
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

                await executeWithRetry(async () => {
                    await databases.createDocument(
                        APPWRITE_DATABASE_ID,
                        APPWRITE_COLLECTION_ID,
                        ID.unique(),
                        appwriteDoc
                    );
                });
                successCount++;
                totalUploaded++;
                await new Promise(resolve => setTimeout(resolve, 50));
            } catch (err) {
                failCount++;
                console.error(`  ⚠ Failed to upload "${doc.name}": ${err.message}`);
                failedDocuments.push({ doc, error: err.message, batchFileName });
            }
        }
        
        console.log(`✔ Completed ${batchFileName}: ${successCount} success, ${failCount} failed. (Total uploaded: ${totalUploaded})`);
    }
    
    if (failedDocuments.length > 0) {
        fs.writeFileSync(FAILED_UPLOADS_PATH, JSON.stringify(failedDocuments, null, 2), 'utf8');
        console.log(`\n📝 Saved ${failedDocuments.length} permanently failed documents to etl/output/failed_uploads.json for later retry.`);
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
