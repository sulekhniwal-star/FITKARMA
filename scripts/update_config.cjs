const fs = require('fs');
const path = 'f:/fitkarma/appwrite.config.json';
try {
    const content = fs.readFileSync(path, 'utf8');
    const config = JSON.parse(content);
    config.functions = [
      {
        "$id": "fitkarma-core",
        "name": "fitkarma-core",
        "enabled": true,
        "runtime": "node-22",
        "path": "functions/fitkarma-core",
        "entrypoint": "src/main.js",
        "commands": "npm install",
        "execute": ["users"],
        "timeout": 15,
        "vars": [
          { "key": "ANTHROPIC_API_KEY", "value": "" },
          { "key": "APP_BASE_URL", "value": "https://fitkarma.app" }
        ]
      }
    ];
    fs.writeFileSync(path, JSON.stringify(config, null, 4));
    console.log('Successfully updated appwrite.config.json');
} catch (e) {
    console.error('Error updating config:', e);
    process.exit(1);
}
