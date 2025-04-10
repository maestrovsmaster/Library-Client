import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { updateBookReviewStats } from './updateBookReviewStats';

export const deleteReview = functions.https.onRequest(async (req, res) => {
  try {
    /*const { bookId, reviewId } = req.query;
 
    if (!bookId || !reviewId) {
      res.status(400).json({ message: "Missing reviewId" });
      return;
    }*/

    const bookId = Array.isArray(req.query.bookId) ? req.query.bookId[0] : req.query.bookId;
    const reviewId = Array.isArray(req.query.reviewId) ? req.query.reviewId[0] : req.query.reviewId;

    if (typeof bookId !== 'string' || typeof reviewId !== 'string') {
      res.status(400).json({ message: "Invalid or missing bookId/reviewId" });
      return;
    }

    const postfix = req.query.postfix as string | undefined;
    const collectionName = `reviews${postfix ? '-' + postfix : ''}`;
    const reviewRef = admin.firestore().collection(collectionName).doc(reviewId as string);


    await reviewRef.delete();


    await updateBookReviewStats(bookId, postfix);

    res.status(200).json({ message: "Review deleted successfully" });
  } catch (error) {
    console.error("Error deleting review:", error);
    res.status(500).json({ message: "Internal server error" });
  }
});
