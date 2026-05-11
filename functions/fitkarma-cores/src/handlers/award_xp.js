import { ID, Query } from 'node-appwrite';

const XP_TABLE = {
  food_log: 15,
  water_log: 5,
  workout: 50,
  bp_reading: 10,
  glucose_reading: 10,
  medication: 10,
  sleep_log: 25,
  journal_entry: 20,
  achievement: 100
};

const LEVEL_THRESHOLDS = [
  { level: 1, xp: 0, name: "Seeker" },
  { level: 2, xp: 500, name: "Aspirant" },
  { level: 3, xp: 1500, name: "Practitioner" },
  { level: 4, xp: 3000, name: "Warrior" },
  { level: 5, xp: 5000, name: "Master" },
  { level: 6, xp: 8000, name: "Sage" },
  { level: 7, xp: 12000, name: "Legend" },
  { level: 8, xp: 17000, name: "Immortal" },
  { level: 9, xp: 23000, name: "Divine" },
  { level: 10, xp: 30000, name: "Antigravity" }
];

function computeLevel(xp) {
  let currentLevel = LEVEL_THRESHOLDS[0];
  for (const threshold of LEVEL_THRESHOLDS) {
    if (xp >= threshold.xp) {
      currentLevel = threshold;
    } else {
      break;
    }
  }
  return currentLevel;
}

export async function handleAwardXp(data, context, req, res) {
  const { eventType, userId } = data;
  const { databases, log, error } = context;

  if (!userId || !eventType) {
    return res.json({ ok: false, error: "Missing userId or eventType" }, 400);
  }

  const xpAwarded = XP_TABLE[eventType] || 0;
  if (xpAwarded === 0) {
    log(`Unknown event type or 0 XP: ${eventType}`);
  }

  try {
    // 1. Get current user data
    const userDoc = await databases.getDocument('fitkarma-db', 'users', userId);
    const currentXP = userDoc.karmaXP || 0;
    const newXP = currentXP + xpAwarded;
    const newLevelData = computeLevel(newXP);

    // 2. Create karma event
    await databases.createDocument('fitkarma-db', 'karma_events', ID.unique(), {
      userId,
      eventType,
      xpAwarded,
      occurredAt: Date.now()
    });

    // 3. Update user
    await databases.updateDocument('fitkarma-db', 'users', userId, {
      karmaXP: newXP,
      karmaLevel: `${newLevelData.level}: ${newLevelData.name}`
    });

    return res.json({
      ok: true,
      xpAwarded,
      newXP,
      newLevel: newLevelData.level,
      levelName: newLevelData.name
    });
  } catch (e) {
    error(`Error in handleAwardXp: ${e.message}`);
    return res.json({ ok: false, error: e.message }, 500);
  }
}
