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

console.log('⚡ Initializing Remaining Batches & Failed Uploads Resumer...');

const BATCH_DIR = path.join(__dirname, '../etl/output/batches');
const FAILED_UPLOADS_PATH = path.join(__dirname, '../etl/output/failed_uploads.json');
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

const { Client, Databases, ID } = nodeAppwrite;

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
            // Treat 409 (Document already exists) as a successful upload to avoid duplicate errors during resume
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

async function retryFailedUploads() {
    if (!fs.existsSync(FAILED_UPLOADS_PATH)) {
        return;
    }

    console.log('♻️ Phase 1: Retrying previously failed individual uploads from failed_uploads.json...');
    let failedItems;
    try {
        failedItems = JSON.parse(fs.readFileSync(FAILED_UPLOADS_PATH, 'utf8'));
    } catch (err) {
        console.error(`❌ Failed to parse ${FAILED_UPLOADS_PATH}: ${err.message}`);
        return;
    }

    if (!Array.isArray(failedItems) || failedItems.length === 0) {
        console.log('✔ No failed items to retry.');
        return;
    }

    console.log(`⏳ Found ${failedItems.length} failed documents to retry...`);
    let successCount = 0;
    const stillFailed = [];

    for (const item of failedItems) {
        const doc = item.doc || item;
        if (!doc || !doc.name) continue;

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
            await new Promise(resolve => setTimeout(resolve, 50));
        } catch (err) {
            console.error(`  ⚠ Still failed to upload "${doc.name}": ${err.message}`);
            stillFailed.push(item);
        }
    }

    if (stillFailed.length > 0) {
        fs.writeFileSync(FAILED_UPLOADS_PATH, JSON.stringify(stillFailed, null, 2), 'utf8');
        console.log(`✔ Retried failed uploads: ${successCount} succeeded, ${stillFailed.length} still failing.`);
    } else {
        fs.unlinkSync(FAILED_UPLOADS_PATH);
        console.log(`✔ Successfully uploaded all ${successCount} previously failed documents! Cleared failed_uploads.json.`);
    }
    console.log('--------------------------------------------------------------------------------');
}

async function uploadRemainingBatches(startBatch) {
    console.log(`🚀 Phase 2: Resuming batch uploads starting from batch_${String(startBatch).padStart(4, '0')}.json...`);
    const totalBatches = 1550;
    let totalUploaded = 0;
    const failedDocuments = [];
    
    // Load existing failed documents if any, to append to them
    if (fs.existsSync(FAILED_UPLOADS_PATH)) {
        try {
            const existing = JSON.parse(fs.readFileSync(FAILED_UPLOADS_PATH, 'utf8'));
            if (Array.isArray(existing)) {
                failedDocuments.push(...existing);
            }
        } catch (e) {}
    }

    for (let batchIndex = startBatch; batchIndex <= totalBatches; batchIndex++) {
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
        
        console.log(`✔ Completed ${batchFileName}: ${successCount} success, ${failCount} failed. (Session total: ${totalUploaded})`);
    }
    
    if (failedDocuments.length > 0) {
        fs.writeFileSync(FAILED_UPLOADS_PATH, JSON.stringify(failedDocuments, null, 2), 'utf8');
        console.log(`\n📝 Updated etl/output/failed_uploads.json with ${failedDocuments.length} total permanently failed documents.`);
    }
    
    console.log(`\n✨ Phase 2 Complete: Successfully uploaded ${totalUploaded} documents from remaining batches!`);
}

async function main() {
    const arg = process.argv[2];
    // Default to 206 since the previous upload log failed at batch_0206.json
    const startBatch = arg ? parseInt(arg, 10) : 206;
    
    if (isNaN(startBatch) || startBatch < 1 || startBatch > 1550) {
        console.error('❌ Invalid starting batch number. Please provide a number between 1 and 1550.');
        console.error('Usage: node scripts/upload_remaining_batches.js [startBatchIndex]');
        process.exit(1);
    }

    await retryFailedUploads();
    await uploadRemainingBatches(startBatch);
}

main().catch(err => {
    console.error('❌ Uncaught execution error:', err);
});
