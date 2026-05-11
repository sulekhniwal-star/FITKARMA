import { Client, Databases, Users, Functions, Storage } from 'node-appwrite';
import { handleAwardXp } from './handlers/award_xp.js';
import { handleShareLink } from './handlers/share_link.js';
import { handleAiCoach } from './handlers/ai_coach.js';
import { handleFoodSearch } from './handlers/food_search.js';
import { handleFeatureFlags } from './handlers/feature_flags.js';

export default async ({ req, res, log, error }) => {
  // Initialize Appwrite Client
  const client = new Client()
    .setEndpoint(process.env.APPWRITE_FUNCTION_API_ENDPOINT)
    .setProject(process.env.APPWRITE_FUNCTION_PROJECT_ID)
    .setKey(process.env.APPWRITE_API_KEY);

  const databases = new Databases(client);
  const users = new Users(client);

  const context = { client, databases, users, log, error };

  let payload;
  try {
    payload = typeof req.body === 'string' ? JSON.parse(req.body) : req.body;
  } catch (e) {
    return res.json({ ok: false, error: "Invalid JSON payload" }, 400);
  }

  const { action, ...data } = payload || {};

  log(`Action: ${action}`);

  switch (action) {
    case "award_xp":
      return handleAwardXp(data, context, req, res);
    case "generate_share_link":
      return handleShareLink(data, context, req, res);
    case "ai_coach":
      return handleAiCoach(data, context, req, res);
    case "search_food":
      return handleFoodSearch(data, context, req, res);
    case "get_feature_flags":
      return handleFeatureFlags(data, context, req, res);
    default:
      return res.json({ ok: false, error: `Unknown action: ${action}` }, 400);
  }
};
