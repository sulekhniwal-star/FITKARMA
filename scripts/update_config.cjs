const fs = require('fs');
const path = 'f:/fitkarma/appwrite.config.json';

try {
    const content = fs.readFileSync(path, 'utf8');
    const config = JSON.parse(content);

    // 1. Remove 'vars' array from functions config as per latest Appwrite CLI spec
    if (config.functions && Array.isArray(config.functions)) {
        for (const fn of config.functions) {
            if (fn.vars) {
                delete fn.vars;
            }
        }
    }

    // 2. Clean up out-of-bounds integer/float/double min and max values across all tables
    // Due to JavaScript's 64-bit float limits (Number.MAX_SAFE_INTEGER is ~9e15), parsing 2^63-1 rounds up
    // and causes strict CLI JSON schema validations to fail. Removing these optional extreme bounds resolves it.
    if (config.tables && Array.isArray(config.tables)) {
        for (const table of config.tables) {
            if (table.columns && Array.isArray(table.columns)) {
                for (const col of table.columns) {
                    if (col.min !== undefined && col.min !== null) {
                        if (col.min <= -9e15 || Math.abs(col.min) > 9e15) {
                            delete col.min;
                        }
                    }
                    if (col.max !== undefined && col.max !== null) {
                        if (col.max >= 9e15 || Math.abs(col.max) > 9e15) {
                            delete col.max;
                        }
                    }
                }
            }
        }
    }

    fs.writeFileSync(path, JSON.stringify(config, null, 4));
    console.log('✔ Successfully sanitized all integer and double columns in appwrite.config.json.');
} catch (e) {
    console.error('Error sanitizing config:', e);
    process.exit(1);
}
