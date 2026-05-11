# Part V — Full Appwrite CLI Schemas (All Collections)

## §A1. Complete Appwrite Collection Definitions

> Every attribute, index, and permission for all 17 collections. Run these commands after the database is created.

### Users Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "users" --name "Users" \
  --permissions 'read("users")' 'create("users")' 'update("users")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "userId"          --size 36  --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "name"            --size 100 --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "email"           --size 254 --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "gender"          --size 10  --required false
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "users" \
  --key "dob"             --required false
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "users" \
  --key "heightCm"        --required false
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "users" \
  --key "weightKg"        --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "bloodGroup"      --size 5   --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "fitnessGoal"     --size 30  --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "activityLevel"   --size 20  --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "dominantDosha"   --size 10  --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "language"        --size 10  --required false --default "en"
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "karmaLevel"      --size 20  --required false
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "users" \
  --key "karmaXP"         --required false --default 0
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "conditions"      --size 500 --required false
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "users" \
  --key "firstLaunchTs"   --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "weddingDate"     --size 20  --required false
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "users" \
  --key "targetWeightKg"  --required false
appwrite databases createBooleanAttribute --databaseId "fitkarma-db" --collectionId "users" \
  --key "isPro"           --required false --default false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "users" \
  --key "revenueCatId"    --size 100 --required false

appwrite databases createIndex \
  --databaseId "fitkarma-db" --collectionId "users" \
  --key "userId_idx" --type unique --attributes userId
```

### Food Logs Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "food_logs" --name "Food Logs" \
  --permissions 'read("user:{{userId}}")' 'create("user:{{userId}}")' \
                'update("user:{{userId}}")' 'delete("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "userId"        --size 36  --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "localId"       --size 36  --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "foodName"      --size 200 --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "mealType"      --size 20  --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "loggedAt"      --required true
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "calories"      --required true
appwrite databases createBooleanAttribute --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "isDeleted"     --required false --default false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_logs" \
  --key "syncStatus"    --size 10  --required false --default "synced"
```

### Blood Pressure Readings

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "bp_readings" --name "Blood Pressure Readings" \
  --permissions 'read("user:{{userId}}")' 'create("user:{{userId}}")' \
                'update("user:{{userId}}")' 'delete("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "bp_readings" \
  --key "userId"         --size 36  --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "bp_readings" \
  --key "systolic"       --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "bp_readings" \
  --key "diastolic"      --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "bp_readings" \
  --key "measuredAt"     --required true
```

### Glucose Readings

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "glucose_readings" --name "Glucose Readings" \
  --permissions 'read("user:{{userId}}")' 'create("user:{{userId}}")' \
                'update("user:{{userId}}")' 'delete("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "glucose_readings" \
  --key "userId"          --size 36 --required true
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "glucose_readings" \
  --key "valueMgDl"       --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "glucose_readings" \
  --key "readingType"     --size 20 --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "glucose_readings" \
  --key "measuredAt"      --required true
```

### Sleep Logs

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "sleep_logs" --name "Sleep Logs" \
  --permissions 'read("user:{{userId}}")' 'create("user:{{userId}}")' \
                'update("user:{{userId}}")' 'delete("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "sleep_logs" \
  --key "userId"        --size 36 --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "sleep_logs" \
  --key "sleepStart"    --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "sleep_logs" \
  --key "sleepEnd"      --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "sleep_logs" \
  --key "qualityScore"  --required false
```

### Workouts Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "workouts" --name "Workouts" \
  --permissions 'read("user:{{userId}}")' 'create("user:{{userId}}")' \
                'update("user:{{userId}}")' 'delete("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "workouts" \
  --key "userId"          --size 36   --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "workouts" \
  --key "name"            --size 100  --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "workouts" \
  --key "startedAt"       --required true
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "workouts" \
  --key "caloriesBurned"  --required false
```

### Habits Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "habits" --name "Habits" \
  --permissions 'read("user:{{userId}}")' 'create("user:{{userId}}")' \
                'update("user:{{userId}}")' 'delete("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "habits" \
  --key "userId"           --size 36   --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "habits" \
  --key "name"             --size 100  --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "habits" \
  --key "currentStreak"    --required false --default 0
```

### Journal Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "journal" --name "Journal" \
  --permissions 'read("user:{{userId}}")' 'create("user:{{userId}}")' \
                'update("user:{{userId}}")' 'delete("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "journal" \
  --key "userId"        --size 36   --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "journal" \
  --key "body"          --size 5000 --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "journal" \
  --key "createdAt"     --required true
```

### Lab Reports Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "lab_reports" --name "Lab Reports" \
  --permissions 'read("user:{{userId}}")' 'create("user:{{userId}}")' \
                'update("user:{{userId}}")' 'delete("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "lab_reports" \
  --key "userId"        --size 36   --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "lab_reports" \
  --key "reportName"    --size 200  --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "lab_reports" \
  --key "reportDate"    --required true
```

### Karma Events Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "karma_events" --name "Karma Events" \
  --permissions 'read("user:{{userId}}")' 'create("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "karma_events" \
  --key "userId"      --size 36  --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "karma_events" \
  --key "eventType"   --size 50  --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "karma_events" \
  --key "xpAwarded"   --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "karma_events" \
  --key "occurredAt"  --required true
```

### Festivals Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "festivals" --name "Festivals" \
  --permissions 'read("users")' 'create("team:admins")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "festivals" \
  --key "name"          --size 100 --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "festivals" \
  --key "date"          --required true
```

### Medications Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "medications" --name "Medications" \
  --permissions 'read("user:{{userId}}")' 'create("user:{{userId}}")' \
                'update("user:{{userId}}")' 'delete("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "medications" \
  --key "userId"        --size 36  --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "medications" \
  --key "name"          --size 200 --required true
```

### Water Logs Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "water_logs" --name "Water Logs" \
  --permissions 'read("user:{{userId}}")' 'create("user:{{userId}}")' \
                'delete("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "water_logs" \
  --key "userId"      --size 36  --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "water_logs" \
  --key "amountMl"    --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "water_logs" \
  --key "loggedAt"    --required true
```

### Social Posts Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "social_posts" --name "Social Posts" \
  --permissions 'read("users")' 'create("users")' \
                'update("user:{{userId}}")' 'delete("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "social_posts" \
  --key "userId"       --size 36   --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "social_posts" \
  --key "content"      --size 1000 --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "social_posts" \
  --key "createdAt"    --required true
```

### Groups Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "groups" --name "Groups" \
  --permissions 'read("users")' 'create("users")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "groups" \
  --key "name"          --size 100  --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "groups" \
  --key "createdBy"     --size 36   --required true
```

### Share Tokens Collection

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "share_tokens" --name "Share Tokens" \
  --permissions 'read("users")' 'create("users")' 'delete("user:{{userId}}")'

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "share_tokens" \
  --key "userId"      --size 36 --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "share_tokens" \
  --key "reportId"    --size 36 --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "share_tokens" \
  --key "token"       --size 64 --required true
appwrite databases createIntegerAttribute --databaseId "fitkarma-db" --collectionId "share_tokens" \
  --key "expiresAt"   --required true
```
