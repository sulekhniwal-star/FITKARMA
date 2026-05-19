import { Query } from 'node-appwrite';

/**
 * get_readiness — Calculates user readiness score based on last 7 days of sleep and recovery logs.
 *
 * Input:  { userId }
 * Output: { ok, score, zone, recommendation, factors: { sleepScore, recoveryScore, activityScore } }
 */
export async function handleGetReadiness(data, context, req, res) {
  const { userId } = data;
  const { databases, log, error } = context;

  if (!userId) {
    return res.json({ ok: false, error: 'Missing userId' }, 400);
  }

  try {
    const now = Date.now();
    const oneDayAgo = now - (24 * 60 * 60 * 1000);
    const sevenDaysAgo = now - (7 * 24 * 60 * 60 * 1000);

    // Fetch latest sleep log and latest recovery log
    const [sleepDocs, recoveryDocs, userDocs] = await Promise.all([
      databases.listDocuments('fitkarma-db', 'sleep_logs', [
        Query.equal('userId', userId),
        Query.orderDesc('sleepEnd'),
        Query.limit(1)
      ]).catch(() => ({ documents: [] })),
      databases.listDocuments('fitkarma-db', 'recovery_logs', [
        Query.equal('userId', userId),
        Query.orderDesc('loggedAt'),
        Query.limit(1)
      ]).catch(() => ({ documents: [] })),
      databases.listDocuments('fitkarma-db', 'users', [
        Query.equal('userId', userId),
        Query.limit(1)
      ]).catch(() => ({ documents: [] }))
    ]);

    const latestSleep = sleepDocs.documents[0];
    const latestRecovery = recoveryDocs.documents[0];
    const user = userDocs.documents[0];

    // 1. Sleep Factor (0-100)
    let sleepScore = 70; // baseline default
    if (latestSleep) {
      const sleepMin = latestSleep.totalMinutes || ((latestSleep.sleepEnd - latestSleep.sleepStart) / 60000);
      const sleepQuality = latestSleep.qualityScore || 7; // 1-10

      // ideal sleep is 8 hours (480 mins)
      const durationPct = Math.min(100, (sleepMin / 480) * 100);
      const qualityPct = sleepQuality * 10;
      sleepScore = Math.round((durationPct * 0.6) + (qualityPct * 0.4));
    }

    // 2. Recovery / Subjective Factor (0-100)
    let recoveryScore = 70; // baseline default
    let soreness = 0;
    let stress = 5;
    let energy = 5;
    if (latestRecovery) {
      soreness = latestRecovery.sorenessLevel || 0; // 0-10 (0 means no soreness)
      stress = latestRecovery.stressLevel || 5;    // 0-10 (lower is better)
      energy = latestRecovery.energyLevel || 5;    // 0-10 (higher is better)

      const sorenessPct = (10 - soreness) * 10;
      const stressPct = (10 - stress) * 10;
      const energyPct = energy * 10;

      recoveryScore = Math.round((sorenessPct * 0.4) + (stressPct * 0.3) + (energyPct * 0.3));
    }

    // Calculate final readiness score
    let score = Math.round((sleepScore * 0.6) + (recoveryScore * 0.4));
    score = Math.max(10, Math.min(100, score));

    // Determine zone and color mapping
    let zone = 'moderate';
    let recommendation = 'Listen to your body. Today is perfect for a moderate workout.';
    if (score >= 85) {
      zone = 'optimal';
      recommendation = 'You are in the prime zone! Great day to push for a new personal record or high-intensity training.';
    } else if (score >= 70) {
      zone = 'good';
      recommendation = 'Solid recovery profile. You are ready for standard intensity workouts.';
    } else if (score >= 50) {
      zone = 'moderate';
      recommendation = 'Moderate fatigue detected. Keep workouts focused and avoid extreme loads.';
    } else if (score >= 30) {
      zone = 'low';
      recommendation = 'High stress or low sleep. Opt for active recovery, stretching, or light walking today.';
    } else {
      zone = 'rest';
      recommendation = 'Critical recovery required. Prioritize complete rest, hydration, and early sleep today.';
    }

    log(`Readiness calculated for userId=${userId}: Score=${score}, Zone=${zone}`);

    return res.json({
      ok: true,
      score,
      zone,
      recommendation,
      factors: {
        sleepScore,
        recoveryScore,
        sleepQuality: latestSleep ? (latestSleep.qualityScore || 7) : null,
        soreness,
        stress,
        energy
      }
    });
  } catch (e) {
    error(`handleGetReadiness error: ${e.message}`);
    return res.json({ ok: false, error: e.message }, 500);
  }
}
