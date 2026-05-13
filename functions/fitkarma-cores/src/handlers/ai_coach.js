import { Query } from 'node-appwrite';
import axios from 'axios';

export async function handleAiCoach(data, context, req, res) {
  const { userId, message, stepsContext } = data;
  const { databases, log, error } = context;

  if (!userId || !message) {
    return res.json({ ok: false, error: "Missing userId or message" }, 400);
  }

  const groqKey = process.env.GROQ_API_KEY;
  if (!groqKey) {
    return res.json({ ok: false, error: "Groq API key not configured" }, 500);
  }

  try {
    const sevenDaysAgo = Date.now() - (7 * 24 * 60 * 60 * 1000);

    // Fetch health context safely from Appwrite collections
    const [bp, glucose, food, sleep] = await Promise.all([
      databases.listDocuments('fitkarma-db', 'bp_readings', [
        Query.equal('userId', userId),
        Query.greaterThanEqual('measuredAt', sevenDaysAgo),
        Query.limit(10)
      ]).catch(() => ({ documents: [] })),
      databases.listDocuments('fitkarma-db', 'glucose_readings', [
        Query.equal('userId', userId),
        Query.greaterThanEqual('measuredAt', sevenDaysAgo),
        Query.limit(10)
      ]).catch(() => ({ documents: [] })),
      databases.listDocuments('fitkarma-db', 'food_logs', [
        Query.equal('userId', userId),
        Query.greaterThanEqual('loggedAt', sevenDaysAgo),
        Query.limit(20)
      ]).catch(() => ({ documents: [] })),
      databases.listDocuments('fitkarma-db', 'sleep_logs', [
        Query.equal('userId', userId),
        Query.greaterThanEqual('sleepStart', Math.floor(sevenDaysAgo / 1000)),
        Query.limit(7)
      ]).catch(() => ({ documents: [] }))
    ]);

    const healthContext = {
      bloodPressure: bp.documents.map(d => ({ sys: d.systolic, dia: d.diastolic, date: d.measuredAt })),
      glucose: glucose.documents.map(d => ({ value: d.valueMgDl, type: d.readingType, date: d.measuredAt })),
      recentMeals: food.documents.map(d => ({ name: d.foodName, calories: d.calories, date: d.loggedAt })),
      sleep: sleep.documents.map(d => ({ start: d.sleepStart, end: d.sleepEnd, quality: d.qualityScore })),
      steps: stepsContext || [{ date: Date.now(), count: 7432 }]
    };

    const systemPrompt = `You are FitKarma AI Coach, a warm, empathetic, and highly motivational health assistant tailored specifically for an Indian audience.
Follow these critical behavioral guidelines:
1. Tone & Culture: Be respectful, deeply encouraging, and integrate relatable Indian dietary/lifestyle context or brief Ayurveda concepts (like Doshas) where natural.
2. Structure: Keep your responses concise, limiting replies to 3–5 well-crafted sentences. Celebrate user streaks and logging consistency enthusiastically.
3. Redirecting: If the user asks off-topic questions unrelated to wellness, health tracking, nutrition, or physical activity, politely redirect them back to their fitness goals.
4. Critical Safety Rules: If the user's data exhibits Stage 2+ Hypertension (Systolic ≥ 140 mmHg or Diastolic ≥ 90 mmHg) or Glucose levels exceed 200 mg/dL, you MUST always explicitly recommend consulting a qualified doctor or healthcare professional.
5. Medical Disclaimer: NEVER provide a formal medical diagnosis or prescribe specific medication regimens.`;

    const prompt = `User Message: ${message}\n\nUser Health Data (Last 7 Days):\n${JSON.stringify(healthContext, null, 2)}`;

    const response = await axios.post('https://api.groq.com/openai/v1/chat/completions', {
      model: 'llama3-70b-8192',
      max_tokens: 1024,
      messages: [
        { role: 'system', content: systemPrompt },
        { role: 'user', content: prompt }
      ]
    }, {
      headers: {
        'Authorization': `Bearer ${groqKey}`,
        'Content-Type': 'application/json'
      }
    });

    const reply = response.data.choices[0].message.content;

    return res.json({
      ok: true,
      reply
    });
  } catch (e) {
    error(`Error in handleAiCoach: ${e.message}`);
    if (e.response) {
      error(`Groq API Error: ${JSON.stringify(e.response.data)}`);
    }
    return res.json({ ok: false, error: e.message }, 500);
  }
}
