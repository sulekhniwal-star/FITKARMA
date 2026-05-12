import { ID, Query } from 'node-appwrite';
import axios from 'axios';

export async function handleFoodSearch(data, context, req, res) {
  const { query, barcode } = data;
  const { databases, log, error } = context;

  try {
    if (barcode) {
      const existing = await databases.listDocuments('fitkarma-db', 'food_database', [
        Query.equal('barcode', barcode),
        Query.limit(1)
      ]);

      if (existing.total > 0) {
        return res.json({ ok: true, source: 'local', product: existing.documents[0] });
      }

      const response = await axios.get(`https://world.openfoodfacts.org/api/v0/product/${barcode}.json`);
      if (response.data.status === 1) {
        const product = mapOFFProduct(response.data.product);
        
        const saved = await databases.createDocument('fitkarma-db', 'food_database', ID.unique(), {
          ...product,
          source: 'off_barcode'
        });

        return res.json({ ok: true, source: 'off', product: saved });
      }
      return res.json({ ok: false, error: "Product not found" }, 404);
    } else if (query) {
      const response = await axios.get(`https://world.openfoodfacts.org/cgi/search.pl?search_terms=${encodeURIComponent(query)}&json=true&page_size=10`);
      const products = response.data.products.map(p => mapOFFProduct(p));
      
      return res.json({ ok: true, source: 'off_search', products });
    } else {
      return res.json({ ok: false, error: "Missing query or barcode" }, 400);
    }
  } catch (e) {
    error(`Error in handleFoodSearch: ${e.message}`);
    return res.json({ ok: false, error: e.message }, 500);
  }
}

async function appwriteFullTextSearch(query, databases) {
  try {
    const response = await databases.listDocuments('fitkarma-db', 'food_database', [
      Query.search('name', query),
      Query.limit(20)
    ]);
    return response.documents;
  } catch (e) {
    return [];
  }
}

function mapOFFProduct(p) {
  const nutriments = p.nutriments || {};
  return {
    name: p.product_name || 'Unknown Food',
    nameHindi: p.product_name_hi || null,
    category: p.categories ? p.categories.split(',')[0] : 'General',
    caloriesPer100g: parseFloat(nutriments['energy-kcal_100g'] || 0),
    proteinPer100g: parseFloat(nutriments.proteins_100g || 0),
    carbsPer100g: parseFloat(nutriments.carbohydrates_100g || 0),
    fatPer100g: parseFloat(nutriments.fat_100g || 0),
    fiberPer100g: parseFloat(nutriments.fiber_100g || 0),
    barcode: p.code || null,
    emoji: getEmojiByCategory(p.categories),
    source: 'off'
  };
}

function getEmojiByCategory(categories) {
  if (!categories) return '🥗';
  const c = categories.toLowerCase();
  if (c.includes('beverage')) return '🥤';
  if (c.includes('fruit')) return '🍎';
  if (c.includes('vegetable')) return '🥦';
  if (c.includes('meat')) return '🍗';
  if (c.includes('dairy')) return '🥛';
  if (c.includes('snack')) return '🍿';
  if (c.includes('dessert')) return '🍰';
  return '🍛';
}