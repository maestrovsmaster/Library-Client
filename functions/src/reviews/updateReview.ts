import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { Timestamp } from 'firebase-admin/firestore';
import { updateBookReviewStats } from './updateBookReviewStats';

export const updateReview = functions.https.onRequest(async (req, res) => {
  try {
    const { bookId , reviewId, rate, text } = req.body;
   /* const bookId = Array.isArray(req.query.bookId) ? req.query.bookId[0] : req.query.bookId;
    if (typeof bookId !== 'string' || typeof reviewId !== 'string') {
      res.status(400).json({ message: "Invalid or missing bookId/reviewId" });
      return;
    }*/

    if (!bookId ||  !reviewId || !rate || !text) {
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


    await updateBookReviewStats(bookId, postfix);

    res.status(200).json({ message: "Review updated successfully" });
  } catch (error) {
    console.error("Error updating review:", error);
    res.status(500).json({ message: "Internal server error" });
  }
});
