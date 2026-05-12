import 'dotenv/config';

import OpenAI from "openai";

const client = new OpenAI({
  baseURL: "https://models.inference.ai.azure.com",
  apiKey: process.env.GITHUB_TOKEN,
});

async function main() {

  const response =
    await client.chat.completions.create({

      model: "gpt-4o-mini",

      messages: [
        {
          role: "system",
          content: `
You are a food AI.

Return ONLY valid JSON.

Generate:
- nameHindi
- cuisine
- emoji
- isVegan
- servingSizes
`
        },
        {
          role: "user",
          content: "Masala Dosa"
        }
      ],

      temperature: 0.2,
      max_tokens: 300
    });

  console.log(
    response.choices[0]
      .message.content
  );
}

main();