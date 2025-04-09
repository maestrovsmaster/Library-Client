import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

export const deleteReview = functions.https.onRequest(async (req, res) => {
    try {
      const { reviewId } = req.query;
  
      if (!reviewId) {
        res.status(400).json({ message: "Missing reviewId" });
        return;
      }
  
      const postfix = req.query.postfix as string | undefined;
      const collectionName = `reviews${postfix ? '-' + postfix : ''}`;
      const reviewRef = admin.firestore().collection(collectionName).doc(reviewId as string);
  
      await reviewRef.delete();
  
      res.status(200).json({ message: "Review deleted successfully" });
    } catch (error) {
      console.error("Error deleting review:", error);
      res.status(500).json({ message: "Internal server error" });
    }
  });
  