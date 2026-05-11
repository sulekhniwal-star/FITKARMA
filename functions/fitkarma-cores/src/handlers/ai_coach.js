import { Query } from 'node-appwrite';
import axios from 'axios';

export async function handleAiCoach(data, context, req, res) {
  const { userId, message } = data;
  const { databases, log, error } = context;

  if (!userId || !message) {
    return res.json({ ok: false, error: "Missing userId or message" }, 400);
  }

  const anthropicKey = process.env.ANTHROPIC_API_KEY;
  if (!anthropicKey) {
    return res.json({ ok: false, error: "Anthropic API key not configured" }, 500);
  }

  try {
    const sevenDaysAgo = Date.now() - (7 * 24 * 60 * 60 * 1000);

    // Fetch health context
    const [bp, glucose, food, sleep] = await Promise.all([
      databases.listDocuments('fitkarma-db', 'bp_readings', [
        Query.equal('userId', userId),
        Query.greaterThanEqual('measuredAt', sevenDaysAgo),
        Query.limit(10)
      ]),
      databases.listDocuments('fitkarma-db', 'glucose_readings', [
        Query.equal('userId', userId),
        Query.greaterThanEqual('measuredAt', sevenDaysAgo),
        Query.limit(10)
      ]),
      databases.listDocuments('fitkarma-db', 'food_logs', [
        Query.equal('userId', userId),
        Query.greaterThanEqual('loggedAt', sevenDaysAgo),
        Query.limit(20)
      ]),
      databases.listDocuments('fitkarma-db', 'sleep_logs', [
        Query.equal('userId', userId),
        Query.greaterThanEqual('sleepStart', Math.floor(sevenDaysAgo / 1000)),
        Query.limit(7)
      ])
    ]);

    const healthContext = {
      bloodPressure: bp.documents.map(d => ({ sys: d.systolic, dia: d.diastolic, date: d.measuredAt })),
      glucose: glucose.documents.map(d => ({ value: d.valueMgDl, type: d.readingType, date: d.measuredAt })),
      recentMeals: food.documents.map(d => ({ name: d.foodName, calories: d.calories, date: d.loggedAt })),
      sleep: sleep.documents.map(d => ({ start: d.sleepStart, end: d.sleepEnd, quality: d.qualityScore }))
    };

    const systemPrompt = `You are FitKarma AI Coach, a warm and empathetic health assistant tailored for an Indian audience. 
Use a mix of encouragement and data-driven insights. 
Responses should be 3-5 sentences long. 
Always recommend seeing a doctor if BP or Glucose levels are dangerously high (e.g., BP > 180/120 or Glucose > 250). 
Never provide a medical diagnosis. 
Focus on holistic wellness, incorporating Ayurveda concepts (Dosha) if relevant.`;

    const prompt = `User Message: ${message}\n\nUser Health Data (Last 7 Days):\n${JSON.stringify(healthContext, null, 2)}`;

    const response = await axios.post('https://api.anthropic.com/v1/messages', {
      model: 'claude-3-haiku-20240307',
      max_tokens: 1024,
      system: systemPrompt,
      messages: [{ role: 'user', content: prompt }]
    }, {
      headers: {
        'x-api-key': anthropicKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json'
      }
    });

    const reply = response.data.content[0].text;

    return res.json({
      ok: true,
      reply
    });
  } catch (e) {
    error(`Error in handleAiCoach: ${e.message}`);
    if (e.response) {
      error(`Anthropic API Error: ${JSON.stringify(e.response.data)}`);
    }
    return res.json({ ok: false, error: e.message }, 500);
  }
}
