import 'dotenv/config';

import fs from "fs";
import OpenAI from "openai";

const client = new OpenAI({
  baseURL: "https://models.inference.ai.azure.com",
  apiKey: process.env.GITHUB_TOKEN,
});

const foods = JSON.parse(
  fs.readFileSync(
    "./data/unique_foods.json",
    "utf8"
  )
);

const enriched = [];

const emojiMap = {
  dosa: "🥞",
  idli: "🍘",
  biryani: "🍛",
  rice: "🍚",
  roti: "🫓",
  naan: "🫓",
  curry: "🍲",
  chai: "☕",
  mango: "🥭",
  banana: "🍌",
  milk: "🥛",
  paneer: "🧀",
  egg: "🥚",
  chicken: "🍗",
  fish: "🐟"
};

const servingMap = {
  dosa: [{ name: "1 dosa", grams: 120 }],
  idli: [{ name: "1 idli", grams: 40 }],
  roti: [{ name: "1 roti", grams: 35 }],
  rice: [{ name: "1 katori", grams: 150 }],
  biryani: [{ name: "1 plate", grams: 250 }],
  curry: [{ name: "1 bowl", grams: 180 }],
  chai: [{ name: "1 cup", grams: 150 }]
};

const nonVeganIngredients = [
  "chicken",
  "mutton",
  "fish",
  "egg",
  "beef",
  "pork",
  "milk",
  "paneer",
  "butter",
  "ghee",
  "cheese",
  "curd"
];

const glutenIngredients = [
  "wheat",
  "maida",
  "barley",
  "rye",
  "naan",
  "roti",
  "bread"
];

const jainIngredients = [
  "onion",
  "garlic",
  "potato",
  "carrot",
  "beetroot",
  "radish"
];

const navratriBlocked = [
  "rice",
  "wheat",
  "maida",
  "dal"
];

function getEmoji(name) {

  const lower = name.toLowerCase();

  for (const key in emojiMap) {
    if (lower.includes(key)) {
      return emojiMap[key];
    }
  }

  return "🍽️";
}

function getServingSizes(name) {

  const lower = name.toLowerCase();

  for (const key in servingMap) {
    if (lower.includes(key)) {
      return servingMap[key];
    }
  }

  return [
    {
      name: "1 serving",
      grams: 100
    }
  ];
}

function containsAny(name, list) {

  const lower = name.toLowerCase();

  return list.some(x =>
    lower.includes(x)
  );
}

function classifyRules(food) {

  const lower = food.name.toLowerCase();

  return {

    isVegan:
      !containsAny(
        lower,
        nonVeganIngredients
      ),

    isGlutenFree:
      !containsAny(
        lower,
        glutenIngredients
      ),

    isJain:
      !containsAny(
        lower,
        jainIngredients
      ),

    isNavratriSafe:
      !containsAny(
        lower,
        navratriBlocked
      ),

    isSattvic:
      !containsAny(
        lower,
        [
          "onion",
          "garlic",
          "egg",
          "meat",
          "fish"
        ]
      )
  };
}

function chunk(arr, size) {

  const out = [];

  for (let i = 0; i < arr.length; i += size) {
    out.push(arr.slice(i, i + size));
  }

  return out;
}

const batches = chunk(foods, 20);

async function enrichBatch(batch) {

  const names = batch
    .map(x => x.name)
    .join("\n");

  const response =
    await client.chat.completions.create({

      model: "gpt-4o-mini",

      messages: [
        {
          role: "system",
          content: `
Return ONLY valid JSON array.

For each food return:
- name
- nameHindi
- cuisine
- isDiabeticFriendly

Keep answers concise.
`
        },
        {
          role: "user",
          content: names
        }
      ],

      temperature: 0.1,
      max_tokens: 2000
    });

  return JSON.parse(
    response.choices[0]
      .message.content
  );
}

async function main() {

  for (const batch of batches) {

    try {

      console.log(
        "Processing batch..."
      );

      const aiData =
        await enrichBatch(batch);

      for (const item of aiData) {

        const rules =
          classifyRules(item);

        enriched.push({

          name: item.name,

          nameHindi:
            item.nameHindi || "",

          cuisine:
            item.cuisine || "Indian",

          emoji:
            getEmoji(item.name),

          servingSizes:
            getServingSizes(item.name),

          isVegan:
            rules.isVegan,

          isJain:
            rules.isJain,

          isSattvic:
            rules.isSattvic,

          isGlutenFree:
            rules.isGlutenFree,

          isNavratriSafe:
            rules.isNavratriSafe,

          isDiabeticFriendly:
            item.isDiabeticFriendly ?? false
        });
      }

      fs.writeFileSync(
        "./data/enriched_foods.json",
        JSON.stringify(
          enriched,
          null,
          2
        )
      );

      console.log(
        `Saved ${enriched.length}`
      );

    } catch (err) {

      console.log(
        "FAILED BATCH"
      );

      console.log(err.message);
    }
  }
}

main();