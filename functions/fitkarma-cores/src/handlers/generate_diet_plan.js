import { Query } from 'node-appwrite';
import axios from 'axios';

/**
 * generate_diet_plan — Generates a personalised 7-day Indian diet plan.
 *
 * Input:  { userId, dosha, bmi, tdee, goals[], dietaryPreference }
 * Output: { ok, plan: { days: [{ day, meals: [{ name, time, calories, protein, carbs, fat }] }] } }
 */
export async function handleGenerateDietPlan(data, context, req, res) {
  const { userId, dosha, bmi, tdee, goals = [], dietaryPreference = 'vegetarian' } = data;
  const { databases, log, error } = context;

  if (!userId) return res.json({ ok: false, error: 'Missing userId' }, 400);

  const groqKey = process.env.GROQ_API_KEY;
  if (!groqKey) return res.json({ ok: false, error: 'Groq API key not configured' }, 500);

  try {
    // Fetch user profile for richer personalisation
    let userProfile = { dominantDosha: dosha, bmi, tdee, goals, dietaryPreference };
    try {
      const userDoc = await databases.getDocument('fitkarma-db', 'users', userId);
      userProfile = {
        dominantDosha: dosha || userDoc.dominantDosha || 'vata',
        bmi: bmi || userDoc.bmi || 22,
        tdee: tdee || 2000,
        goals: goals.length ? goals : (userDoc.fitnessGoal || '').split(',').filter(Boolean),
        dietaryPreference,
        activityLevel: userDoc.activityLevel || 'moderate',
        conditions: userDoc.conditions || '',
      };
    } catch (_) { /* Use provided data if user doc not found */ }

    const systemPrompt = `You are a certified Indian nutritionist and Ayurveda specialist.
Generate a practical, delicious, culturally authentic 7-day Indian meal plan.
Rules:
- Each day has 4 meals: Breakfast, Lunch, Snack, Dinner
- Use real Indian dish names (e.g., Poha, Dal Tadka, Rajma, Roti)
- Respect the dietary preference: ${userProfile.dietaryPreference}
- Target TDEE: ${userProfile.tdee} kcal/day
- Dosha type: ${userProfile.dominantDosha} (tailor food selections accordingly)
- Health conditions: ${userProfile.conditions || 'none'}
- Respond ONLY with a valid JSON object in this exact structure — no markdown, no extra text:
{
  "days": [
    {
      "day": 1,
      "meals": [
        { "name": "Poha", "time": "08:00", "calories": 250, "protein": 8, "carbs": 42, "fat": 5 }
      ]
    }
  ]
}`;

    const userPrompt = `Create a 7-day meal plan. BMI: ${userProfile.bmi}. Goals: ${userProfile.goals.join(', ') || 'general fitness'}.`;

    const response = await axios.post('https://api.groq.com/openai/v1/chat/completions', {
      model: 'llama3-70b-8192',
      max_tokens: 3000,
      temperature: 0.3,
      messages: [
        { role: 'system', content: systemPrompt },
        { role: 'user', content: userPrompt },
      ],
    }, {
      headers: { 'Authorization': `Bearer ${groqKey}`, 'Content-Type': 'application/json' },
    });

    const raw = response.data.choices[0].message.content.trim();

    // Extract JSON safely (model may wrap in markdown fences)
    const jsonMatch = raw.match(/\{[\s\S]*\}/);
    if (!jsonMatch) throw new Error('Model did not return valid JSON');

    const plan = JSON.parse(jsonMatch[0]);

    log(`Diet plan generated for userId=${userId}, ${plan.days?.length ?? 0} days`);
    return res.json({ ok: true, plan });
  } catch (e) {
    error(`handleGenerateDietPlan error: ${e.message}`);
    return res.json({ ok: false, error: e.message }, 500);
  }
}
