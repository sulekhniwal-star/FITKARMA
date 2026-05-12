import fs from "fs";

const foods = JSON.parse(
  fs.readFileSync(
    "fitkarma/assets/data/indian_foods_seed.json",
    "utf8"
  )
);

const unique = new Map();

for (const food of foods) {

  if (!food.name) continue;

  const key = food.name
    .toLowerCase()
    .trim();

  if (!unique.has(key)) {

    unique.set(key, {
      name: food.name,
      category:
        food.category || ""
    });
  }
}

const result =
  Array.from(unique.values());

if (!fs.existsSync("./data")) {
  fs.mkdirSync("./data");
}

fs.writeFileSync(
  "./data/unique_foods.json",
  JSON.stringify(result, null, 2)
);

console.log(
  `Saved ${result.length} unique foods`
);