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

    // 2. Clean up out-of-bounds float/double min and max values across all tables
    if (config.tables && Array.isArray(config.tables)) {
        for (const table of config.tables) {
            if (table.columns && Array.isArray(table.columns)) {
                for (const col of table.columns) {
                    if (col.type === 'double' || col.type === 'float') {
                        // If min or max exceed 64-bit signed integer limits parsed by CLI, remove them
                        if (col.min !== undefined && (col.min < -9223372036854775000 || Math.abs(col.min) > 1e18)) {
                            delete col.min;
                        }
                        if (col.max !== undefined && (col.max > 9223372036854775000 || Math.abs(col.max) > 1e18)) {
                            delete col.max;
                        }
                    }
                }
            }
        }
    }

    fs.writeFileSync(path, JSON.stringify(config, null, 4));
    console.log('✔ Successfully sanitized appwrite.config.json to pass strict Appwrite CLI schema validation.');
} catch (e) {
    console.error('Error sanitizing config:', e);
    process.exit(1);
}
