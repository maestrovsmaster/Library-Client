import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

export const deleteReadingPlan = functions.https.onRequest(async (req, res) => {
    try {
      const { bookId, userId } = req.body;
  
      if (!bookId || !userId) {
        res.status(400).json({ message: "Missing required fields" });
        return;
      }

      const postfix = req.query.postfix as string | undefined;
      const collectionName = `readingPlans${postfix ? '-' + postfix : ''}`;
  
      const docId = `${userId}_${bookId}`;
      const docRef = admin.firestore().collection(collectionName).doc(docId);
  
      await docRef.delete();
  
      res.status(200).json({ message: "Reading plan removed", id: docId });
    } catch (error) {
      console.error("Error deleting reading plan:", error);
      res.status(500).json({ message: "Internal server error" });
    }
  });
  