import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { Timestamp } from 'firebase-admin/firestore';

export const updateReview = functions.https.onRequest(async (req, res) => {
  try {
    const { reviewId, rate, text } = req.body;

    if (!reviewId || !rate || !text) {
      res.status(400).json({ message: "Missing required fields" });
      return;
    }

    const postfix = req.query.postfix as string | undefined;
    const collectionName = `reviews${postfix ? '-' + postfix : ''}`;
    const reviewRef = admin.firestore().collection(collectionName).doc(reviewId);

    await reviewRef.update({
      rate,
      text,
      dateUpdated: Timestamp.now(),
    });

    res.status(200).json({ message: "Review updated successfully" });
  } catch (error) {
    console.error("Error updating review:", error);
    res.status(500).json({ message: "Internal server error" });
  }
});
