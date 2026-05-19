import { ID } from 'node-appwrite';
import crypto from 'crypto';

export async function handleShareLink(data, context, req, res) {
  const { userId, reportId } = data;
  const { databases, log, error } = context;

  if (!userId || !reportId) {
    return res.json({ ok: false, error: "Missing userId or reportId" }, 400);
  }

  try {
    // Generate 32-byte (64-char hex) token — matches share_tokens.token column size:64
    const token = crypto.randomBytes(32).toString('hex');
    const expiresAt = Date.now() + (7 * 24 * 60 * 60 * 1000); // 7 days

    // Create share token record
    await databases.createDocument('fitkarma-db', 'share_tokens', ID.unique(), {
      userId,
      reportId,
      token,
      expiresAt
    });

    const appBaseUrl = process.env.APP_BASE_URL || 'https://fitkarma.app';
    const shareUrl = `${appBaseUrl}/share/${token}`;

    return res.json({
      ok: true,
      token,
      expiresAt,
      shareUrl
    });
  } catch (e) {
    error(`Error in handleShareLink: ${e.message}`);
    return res.json({ ok: false, error: e.message }, 500);
  }
}
