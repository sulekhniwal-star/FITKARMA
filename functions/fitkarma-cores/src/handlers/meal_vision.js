import axios from 'axios';

/**
 * meal_vision — Visual analysis of a meal using Groq Llama 3.2 Vision.
 *
 * Input:  { userId, imageBase64, mimeType }
 * Output: { ok: true, items: [{ name, calories, protein, carbs, fat }] }
 */
export async function handleMealVision(data, context, req, res) {
  const { userId, imageBase64, mimeType = 'image/jpeg' } = data;
  const { log, error } = context;

  if (!userId || !imageBase64) {
    return res.json({ ok: false, error: 'Missing userId or imageBase64' }, 400);
  }

  const groqKey = process.env.GROQ_API_KEY;
  if (!groqKey) {
    return res.json({ ok: false, error: 'Groq API key not configured' }, 500);
  }

  try {
    log(`Running meal vision analysis for user=${userId}`);

    // Call Groq Llama-3.2-11b-vision-preview model
    const response = await axios.post('https://api.groq.com/openai/v1/chat/completions', {
      model: 'llama-3.2-11b-vision-preview',
      max_tokens: 1024,
      temperature: 0.2,
      messages: [
        {
          role: 'user',
          content: [
            {
              type: 'text',
              text: `Analyze this meal image and return a JSON list of all identified foods with estimated portion size and nutritional values (calories, protein, carbs, fat in grams).
Use this exact JSON format — do not wrap in markdown tags or write any explanatory text:
{
  "items": [
    {
      "name": "Roti",
      "portion": "2 medium",
      "calories": 160,
      "protein": 6,
      "carbs": 32,
      "fat": 1
    }
  ]
}`
            },
            {
              type: 'image_url',
              image_url: {
                url: `data:${mimeType};base64,${imageBase64}`
              }
            }
          ]
        }
      ]
    }, {
      headers: {
        'Authorization': `Bearer ${groqKey}`,
        'Content-Type': 'application/json'
      }
    });

    const rawContent = response.data.choices[0].message.content.trim();
    log(`Raw response from Groq: ${rawContent}`);

    // Parse JSON safely
    const jsonMatch = rawContent.match(/\{[\s\S]*\}/);
    if (!jsonMatch) {
      throw new Error(`Model response did not contain JSON object: ${rawContent}`);
    }

    const parsed = JSON.parse(jsonMatch[0]);

    return res.json({
      ok: true,
      items: parsed.items || []
    });
  } catch (e) {
    error(`handleMealVision error: ${e.message}`);
    if (e.response) {
      error(`Groq API response error: ${JSON.stringify(e.response.data)}`);
    }
    return res.json({ ok: false, error: e.message }, 500);
  }
}
