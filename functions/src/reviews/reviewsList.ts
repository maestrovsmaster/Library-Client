import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

export const reviewsList = functions.https.onRequest(async (req, res) => {
    try {
      const { bookId } = req.query;
  
      if (!bookId) {
        res.status(400).json({ message: "Missing bookId" });
        return;
      }
  
      const postfix = req.query.postfix as string | undefined;
      const collectionName = `reviews${postfix ? '-' + postfix : ''}`;
      const snapshot = await admin.firestore()
        .collection(collectionName)
        .where("bookId", "==", bookId)
        .orderBy("date", "desc")
        .get();
  
      const reviews = snapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data()
      }));
  
      res.status(200).json(reviews);
    } catch (error) {
      console.error("Error fetching reviews:", error);
      res.status(500).json({ message: "Internal server error" });
    }
  });
  