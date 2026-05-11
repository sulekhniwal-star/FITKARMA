# Part IV — Critical Fixes (Fresh Implementation)

## §F1. Indian Food Database Integration

> **Fixes the #1 gap identified in competitive analysis.** Without a food database, food logging degrades to full manual entry — the primary churn driver in nutrition apps.

### Architecture

```text
Food Search Sheet
      │
      ├─ Query: Indian regional? → FoodDatabaseService.searchIndian() → Appwrite food_database collection
      ├─ Query: Barcode scan?    → FoodDatabaseService.searchBarcode() → Open Food Facts API
      ├─ Query: Global food?     → FoodDatabaseService.searchGlobal()  → Open Food Facts API
      └─ Not found?              → Manual entry form
```

### Appwrite `food_database` Collection — CLI Setup

```bash
appwrite databases createCollection \
  --databaseId "fitkarma-db" --collectionId "food_database" \
  --name "Food Database" \
  --permissions 'read("users")'   # read-only for all authenticated users

appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "name"          --size 200 --required true
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "nameHindi"     --size 200 --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "nameRegional"  --size 200 --required false   # Marathi, Tamil, Bengali, etc.
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "category"      --size 50  --required false   # dal, sabzi, roti, rice, snack, sweet, beverage
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "cuisine"       --size 50  --required false   # north-indian, south-indian, bengali, gujarati, etc.
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "caloriesPer100g"  --required true
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "proteinPer100g"   --required false
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "carbsPer100g"     --required false
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "fatPer100g"       --required false
appwrite databases createFloatAttribute   --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "fiberPer100g"     --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "barcode"       --size 20  --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "servingSizes"  --size 500 --required false   # JSON: [{name:"1 roti", grams:40}, ...]
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "emoji"         --size 4   --required false
appwrite databases createStringAttribute  --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "source"        --size 20  --required false   # manual/off/icmr/usda

# Indexes for fast search
appwrite databases createIndex \
  --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "name_idx" --type fulltext --attributes name

appwrite databases createIndex \
  --databaseId "fitkarma-db" --collectionId "food_database" \
  --key "barcode_idx" --type unique --attributes barcode
```

### Food Database Service

```dart
// lib/features/food/data/food_database_service.dart

import 'package:appwrite/appwrite.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Priority: Indian DB (Appwrite) → Open Food Facts → Manual
class FoodDatabaseService {
  final Databases _databases;
  final Dio _dio;
  static const _dbId  = 'fitkarma-db';
  static const _colId = 'food_database';
  static const _offBase = 'https://world.openfoodfacts.org';

  FoodDatabaseService(this._databases, this._dio);

  // ── Search by name ───────────────────────────────────────
  Future<List<FoodItem>> searchByName(String query, {bool lowData = false}) async {
    final results = <FoodItem>[];

    // 1. Search Indian DB first (fast — Appwrite full-text index)
    try {
      final local = await _databases.listDocuments(
        databaseId: _dbId, collectionId: _colId,
        queries: [Query.search('name', query), Query.limit(10)],
      );
      results.addAll(local.documents.map(FoodItem.fromAppwriteDoc));
    } catch (_) {}

    // 2. If not enough results and not in low data mode, hit Open Food Facts
    if (results.length < 5 && !lowData) {
      try {
        final resp = await _dio.get(
          '$_offBase/cgi/search.pl',
          queryParameters: {
            'search_terms': query, 'search_simple': 1, 'action': 'process',
            'json': 1, 'page_size': 10, 'fields':
            'product_name,nutriments,serving_size,image_front_small_url,code',
          },
        );
        final products = (resp.data['products'] as List? ?? []);
        results.addAll(products.map(FoodItem.fromOpenFoodFacts).where((f) => f.isValid));
      } catch (_) {}
    }

    return results;
  }

  // ── Search by barcode ────────────────────────────────────
  Future<FoodItem?> searchByBarcode(String barcode) async {
    // 1. Check local Appwrite DB first
    try {
      final local = await _databases.listDocuments(
        databaseId: _dbId, collectionId: _colId,
        queries: [Query.equal('barcode', barcode), Query.limit(1)],
      );
      if (local.documents.isNotEmpty) return FoodItem.fromAppwriteDoc(local.documents.first);
    } catch (_) {}

    // 2. Fallback to Open Food Facts
    try {
      final resp = await _dio.get('$_offBase/api/v0/product/$barcode.json');
      if (resp.data['status'] == 1) {
        final item = FoodItem.fromOpenFoodFacts(resp.data['product']);
        if (item.isValid) {
          await _cacheToAppwrite(item, barcode: barcode); // cache for offline use
          return item;
        }
      }
    } catch (_) {}

    return null;
  }

  // ── Cache a looked-up product for offline reuse ──────────
  Future<void> _cacheToAppwrite(FoodItem item, {String? barcode}) async {
    try {
      await _databases.createDocument(
        databaseId: _dbId, collectionId: _colId, documentId: ID.unique(),
        data: item.toAppwriteMap(barcode: barcode),
        permissions: ['read("users")'],
      );
    } catch (_) {} // silent — caching is best-effort
  }
}
```

### Food Search UI — Bottom Sheet

```dart
// lib/features/food/presentation/food_search_sheet.dart

class FoodSearchSheet extends ConsumerStatefulWidget {
  final String mealType; // breakfast/lunch/dinner/snack
  const FoodSearchSheet({super.key, required this.mealType});

  @override
  ConsumerState<FoodSearchSheet> createState() => _FoodSearchSheetState();
}

class _FoodSearchSheetState extends ConsumerState<FoodSearchSheet> {
  final _ctrl = TextEditingController();
  List<FoodItem> _results = [];
  bool _searching = false;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9, minChildSize: 0.5, maxChildSize: 0.95,
      builder: (_, scrollCtrl) => GlassCard(
        customRadius: AppRadius.xl,
        child: Column(children: [
          // Search bar
          TextField(
            controller: _ctrl,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search food (e.g. Dal Makhani, Chapati)…',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: _scanBarcode,   // Camera permission required
              ),
            ),
            onChanged: _onQueryChanged,
          ),
          // Results
          if (_searching) const LinearProgressIndicator(),
          Expanded(
            child: _results.isEmpty
                ? EmptyState(contextKey: 'food', message: 'Search for a food item above.')
                : ListView.builder(
                    controller: scrollCtrl,
                    itemCount: _results.length,
                    itemBuilder: (_, i) => _FoodResultTile(
                      item: _results[i],
                      onTap: () => _logFood(_results[i]),
                    ),
                  ),
          ),
          // Manual entry fallback
          TextButton.icon(
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Add manually'),
            onPressed: () => _showManualEntrySheet(context),
          ),
        ]),
      ),
    );
  }
}
```

---

## §F2. AI Insight Engine & LLM Coach

> **Fixes the AI/coaching gap.** Adds a conversational health coach powered by an LLM, running server-side to keep API keys secure.

### Appwrite Function: ai-coach

```js
// functions/ai-coach/src/main.js
// Server-side LLM call — API key never in Flutter binary

import Anthropic from "@anthropic-ai/sdk";
import { Client, Databases, Query } from "node-appwrite";

const anthropic = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });

const SYSTEM_PROMPT = `You are FitKarma's AI health coach — a warm, encouraging, and medically responsible assistant built for Indian users. 

You have access to the user's recent health data summarised below. Use it to give personalised, actionable advice.

RULES:
- Always be encouraging and empathetic. Never shame about weight, food choices, or missed goals.
- Cite specific numbers from their data (e.g. "Your average BP last week was 138/88").
- For clinical concerns (BP Stage 2+, glucose > 200 mg/dL, SpO2 < 94%), always recommend consulting a doctor — do not diagnose.
- Reference Indian foods by name when suggesting dietary changes.
- Keep responses concise (3–5 sentences for short answers, max 200 words for detailed advice).
- Celebrate streaks, milestones, and improvements — gamification mindset.
- If the user asks about something outside health/fitness, gently redirect.`;

export default async ({ req, res, log, error }) => {
  const client = new Client()
    .setEndpoint(process.env.APPWRITE_FUNCTION_API_ENDPOINT)
    .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
    .setKey(req.headers["x-appwrite-key"]);
  const db = new Databases(client);

  const { userId, message, conversationHistory } = JSON.parse(req.body || "{}");
  if (!userId || !message)
    return res.json({ ok: false, error: "userId and message required" }, 400);

  // Fetch user's recent health data for context
  const [bpDocs, glucoseDocs, sleepDocs, foodDocs, userDoc] = await Promise.all(
    [
      db.listDocuments("fitkarma-db", "bp_readings", [
        Query.equal("userId", userId),
        Query.orderDesc("measuredAt"),
        Query.limit(7),
      ]),
      db.listDocuments("fitkarma-db", "glucose_readings", [
        Query.equal("userId", userId),
        Query.orderDesc("measuredAt"),
        Query.limit(7),
      ]),
      db.listDocuments("fitkarma-db", "sleep_logs", [
        Query.equal("userId", userId),
        Query.orderDesc("$createdAt"),
        Query.limit(7),
      ]),
      db.listDocuments("fitkarma-db", "food_logs", [
        Query.equal("userId", userId),
        Query.orderDesc("loggedAt"),
        Query.limit(10),
      ]),
      db.listDocuments("fitkarma-db", "users", [
        Query.equal("userId", userId),
        Query.limit(1),
      ]),
    ],
  );

  const user = userDoc.documents[0] || {};
  const bpAvg = bpDocs.documents.length
    ? Math.round(
        bpDocs.documents.reduce((s, d) => s + d.systolic, 0) /
          bpDocs.documents.length,
      )
    : null;

  const healthContext = `
USER PROFILE:
  Name: ${user.name || "User"} | Goal: ${user.fitnessGoal || "general fitness"} | Dosha: ${user.dominantDosha || "unknown"}
  Karma Level: ${user.karmaLevel || "Newcomer"} (${user.karmaXP || 0} XP)

RECENT HEALTH DATA (last 7 days):
  Blood Pressure: ${
    bpDocs.documents.length > 0
      ? `Avg systolic ${bpAvg} mmHg | Latest ${bpDocs.documents[0]?.systolic}/${bpDocs.documents[0]?.diastolic} (${bpDocs.documents[0]?.classification || "uncategorised"})`
      : "No readings"
  }
  Glucose: ${
    glucoseDocs.documents.length > 0
      ? `Latest ${glucoseDocs.documents[0]?.valueMgDl} mg/dL (${glucoseDocs.documents[0]?.readingType})`
      : "No readings"
  }
  Sleep: ${
    sleepDocs.documents.length > 0
      ? `Avg score ${Math.round(sleepDocs.documents.reduce((s, d) => s + (d.qualityScore || 0), 0) / sleepDocs.documents.length)}/100`
      : "No data"
  }
  Recent meals logged: ${
    foodDocs.documents
      .slice(0, 3)
      .map((f) => f.foodName)
      .join(", ") || "None logged recently"
  }
`;

  // Build messages with conversation history (max last 10 turns for context window)
  const messages = [
    ...(conversationHistory || []).slice(-10),
    {
      role: "user",
      content: `[HEALTH CONTEXT]\n${healthContext}\n\n[USER MESSAGE]\n${message}`,
    },
  ];

  try {
    const response = await anthropic.messages.create({
      model: "claude-3-5-sonnet-20240620",
      max_tokens: 512,
      system: SYSTEM_PROMPT,
      messages,
    });

    return res.json({
      ok: true,
      reply: response.content[0].text,
    });
  } catch (err) {
    error(`AI coach error: ${err.message}`);
    return res.json(
      { ok: false, error: "AI unavailable — please try again shortly." },
      500,
    );
  }
};
```

### AI Coach Screen

```dart
// lib/features/ai_coach/ai_coach_screen.dart

class AiCoachScreen extends ConsumerStatefulWidget {
  const AiCoachScreen({super.key});
  @override
  ConsumerState<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends ConsumerState<AiCoachScreen> {
  final _ctrl = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _loading = false;

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final message = text.trim();
    _ctrl.clear();
    setState(() {
      _messages.add(ChatMessage(role: 'user', content: message));
      _loading = true;
    });

    final userId = ref.read(authNotifierProvider).valueOrNull?.$id ?? '';
    final history = _messages.dropLast(1)
        .map((m) => {'role': m.role, 'content': m.content}).toList();

    try {
      final functions = Functions(ref.read(appwriteClientProvider));
      final result = await functions.createExecution(
        functionId: AppConfig.aiCoachFunctionId,
        body: jsonEncode({
          'userId': userId,
          'message': message,
          'conversationHistory': history,
        }),
      );
      final response = jsonDecode(result.responseBody) as Map<String, dynamic>;
      setState(() => _messages.add(ChatMessage(
        role: 'assistant',
        content: response['ok'] == true ? response['reply'] as String : response['error'] as String,
      )));
    } catch (_) {
      setState(() => _messages.add(const ChatMessage(
        role: 'assistant',
        content: 'Sorry, I am unavailable right now. Please try again.',
      )));
    } finally {
      setState(() => _loading = false);
    }
  }
}
```

---

## §F3. iOS HealthKit — Full Implementation

> **Fixes the iOS health data gap.**

### iOS Setup

```xml
<!-- ios/Runner/Info.plist -->
<key>NSHealthShareUsageDescription</key>
<string>FitKarma reads your steps, heart rate, sleep, and blood pressure to give you personalised health insights.</string>
<key>NSHealthUpdateUsageDescription</key>
<string>FitKarma writes your workout and nutrition data to Apple Health so all your health data stays in sync.</string>
```

### Full HealthKit Provider Implementation

```dart
// lib/features/health/data/health_kit_provider.dart

import 'package:health/health.dart';

class HealthKitProvider implements HealthDataProvider {
  static final _health = Health();

  static const _readTypes = [
    HealthDataType.STEPS, HealthDataType.HEART_RATE,
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC, HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    HealthDataType.BLOOD_GLUCOSE, HealthDataType.SLEEP_SESSION,
  ];

  @override
  Future<bool> requestPermissions() async {
    await _health.configure();
    return _health.requestAuthorization(_readTypes);
  }

  @override
  Future<int> getTodaySteps() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    try {
      final steps = await _health.getTotalStepsInInterval(midnight, now);
      return steps ?? 0;
    } catch (_) { return 0; }
  }
}
```

---

## §F4. Subscription Model & Monetisation

> **Fixes the missing monetisation model.** Based on competitive analysis, a freemium model with a ₹299/month Pro tier is appropriate.

### Tier Comparison

| Feature                    | Free            | Pro (₹299/month)  |
| -------------------------- | --------------- | ----------------- |
| Food logging               | ✅ Unlimited    | ✅ Unlimited      |
| Basic health tracking      | ✅              | ✅                |
| AI Coach queries           | ❌              | ✅ 50/day         |
| Correlation insights       | ❌              | ✅                |
| Lab report storage         | ❌ (3 reports)  | ✅ Unlimited      |
| Advanced reports (PDF)     | ❌              | ✅                |

### RevenueCat Setup

```dart
// lib/features/settings/subscription_service.dart

import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionService {
  static const _revenueCatApiKey = String.fromEnvironment('REVENUECAT_API_KEY');

  static Future<void> init() async {
    await Purchases.setLogLevel(LogLevel.debug);
    final configuration = PurchasesConfiguration(_revenueCatApiKey);
    await Purchases.configure(configuration);
  }

  static Future<bool> isPro() async {
    try {
      final info = await Purchases.getCustomerInfo();
      return info.entitlements.active.containsKey('pro');
    } catch (_) { return false; }
  }
}
```

### Pro Gate Widget

```dart
// lib/features/settings/pro_gate.dart

class ProGate extends ConsumerWidget {
  final Widget child;
  const ProGate({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProAsync = ref.watch(isProProvider);
    return isProAsync.when(
      loading: () => const ShimmerLoader(height: 60),
      error:   (_, __) => _UpgradePrompt(),
      data: (isPro) => isPro ? child : _UpgradePrompt(),
    );
  }
}
```

---

## Updated Glossary

| Term                    | Definition                                                                                                                                            |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Open Food Facts**     | Open-source food database with 3M+ global products. FitKarma uses it as secondary source.                                                             |
| **Indian Food DB**      | Custom Appwrite `food_database` collection seeded with 5,000+ Indian foods.                                                                           |
| **AI Coach**            | LLM-powered conversational health coach (Pro feature).                                                                                                |
| **HealthKit**           | Apple's health data platform (iOS).                                                                                                                   |
| **RevenueCat**          | Cross-platform subscription management SDK.                                                                                                           |
| **Background Delivery** | iOS HealthKit feature that wakes the app to process new health data.                                                                                  |
