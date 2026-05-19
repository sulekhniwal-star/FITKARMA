import { Query } from 'node-appwrite';

/**
 * generate_report — Generates a monthly summary report with averages, trends, and clinical/AI insights.
 *
 * Input:  { userId, month, year }
 * Output: { ok, report: { bp_avg: { systolic, diastolic }, glucose_avg, sleep_avg_mins, total_steps, insights: [] } }
 */
export async function handleGenerateReport(data, context, req, res) {
  const { userId, month, year } = data;
  const { databases, log, error } = context;

  if (!userId || !month || !year) {
    return res.json({ ok: false, error: 'Missing userId, month, or year' }, 400);
  }

  try {
    const startDate = new Date(year, month - 1, 1).getTime();
    const endDate = new Date(year, month, 0, 23, 59, 59, 999).getTime();

    log(`Generating report for userId=${userId} from ${new Date(startDate).toISOString()} to ${new Date(endDate).toISOString()}`);

    // Query databases for month's records
    const [bpDocs, glucoseDocs, sleepDocs, foodDocs] = await Promise.all([
      databases.listDocuments('fitkarma-db', 'bp_readings', [
        Query.equal('userId', userId),
        Query.greaterThanEqual('measuredAt', startDate),
        Query.lessThanEqual('measuredAt', endDate),
        Query.limit(100)
      ]).catch(() => ({ documents: [] })),
      databases.listDocuments('fitkarma-db', 'glucose_readings', [
        Query.equal('userId', userId),
        Query.greaterThanEqual('measuredAt', startDate),
        Query.lessThanEqual('measuredAt', endDate),
        Query.limit(100)
      ]).catch(() => ({ documents: [] })),
      databases.listDocuments('fitkarma-db', 'sleep_logs', [
        Query.equal('userId', userId),
        Query.greaterThanEqual('sleepStart', Math.floor(startDate / 1000)),
        Query.lessThanEqual('sleepStart', Math.floor(endDate / 1000)),
        Query.limit(100)
      ]).catch(() => ({ documents: [] })),
      databases.listDocuments('fitkarma-db', 'food_logs', [
        Query.equal('userId', userId),
        Query.greaterThanEqual('loggedAt', startDate),
        Query.lessThanEqual('loggedAt', endDate),
        Query.limit(100)
      ]).catch(() => ({ documents: [] }))
    ]);

    // 1. BP Averages
    let bp_avg = null;
    if (bpDocs.documents.length > 0) {
      const sumSys = bpDocs.documents.reduce((sum, d) => sum + (d.systolic || 0), 0);
      const sumDia = bpDocs.documents.reduce((sum, d) => sum + (d.diastolic || 0), 0);
      const count = bpDocs.documents.length;
      bp_avg = {
        systolic: Math.round(sumSys / count),
        diastolic: Math.round(sumDia / count),
        count
      };
    }

    // 2. Glucose Average
    let glucose_avg = null;
    if (glucoseDocs.documents.length > 0) {
      const sumGlucose = glucoseDocs.documents.reduce((sum, d) => sum + (d.valueMgDl || 0), 0);
      glucose_avg = Math.round(sumGlucose / glucoseDocs.documents.length);
    }

    // 3. Sleep Average
    let sleep_avg_mins = null;
    if (sleepDocs.documents.length > 0) {
      const sumSleep = sleepDocs.documents.reduce((sum, d) => {
        const diff = d.totalMinutes || ((d.sleepEnd - d.sleepStart) / 60);
        return sum + diff;
      }, 0);
      sleep_avg_mins = Math.round(sumSleep / sleepDocs.documents.length);
    }

    // 4. Food / Calorie averages
    let calorie_avg = null;
    if (foodDocs.documents.length > 0) {
      const sumCal = foodDocs.documents.reduce((sum, d) => sum + (d.calories || 0), 0);
      calorie_avg = Math.round(sumCal / foodDocs.documents.length);
    }

    // Compile clinical/AI insights
    const insights = [];
    if (bp_avg) {
      if (bp_avg.systolic >= 140 || bp_avg.diastolic >= 90) {
        insights.push({
          type: 'alert',
          title: 'Hypertension Pattern Detected',
          message: 'Your average blood pressure falls in the Stage 2 Hypertension range. Please discuss this with a doctor.'
        });
      } else if (bp_avg.systolic >= 130 || bp_avg.diastolic >= 80) {
        insights.push({
          type: 'warning',
          title: 'Elevated Blood Pressure',
          message: 'Average blood pressure is elevated. Consider dietary sodium reductions and stress management.'
        });
      } else {
        insights.push({
          type: 'success',
          title: 'Optimal Blood Pressure',
          message: 'Your monthly average blood pressure is stable and healthy.'
        });
      }
    }

    if (glucose_avg) {
      if (glucose_avg > 140) {
        insights.push({
          type: 'warning',
          title: 'High Average Glycemia',
          message: 'Your monthly average glucose is elevated. Try pairing carbs with protein/fat to stabilize spikes.'
        });
      } else {
        insights.push({
          type: 'success',
          title: 'Stable Glycemic Pattern',
          message: 'Your monthly average glucose is within target bounds.'
        });
      }
    }

    if (sleep_avg_mins && sleep_avg_mins < 420) {
      insights.push({
        type: 'info',
        title: 'Sleep Deficit Pattern',
        message: `Averaging ${Math.round(sleep_avg_mins / 60)}h of sleep, which is below the recommended 7-8h baseline.`
      });
    }

    const report = {
      month,
      year,
      bp_avg,
      glucose_avg,
      sleep_avg_mins,
      calorie_avg,
      insights
    };

    return res.json({ ok: true, report });
  } catch (e) {
    error(`handleGenerateReport error: ${e.message}`);
    return res.json({ ok: false, error: e.message }, 500);
  }
}
