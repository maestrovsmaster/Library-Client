import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

export const isBookInReadingPlan = functions.https.onRequest(async (req, res) => {
  console.log("isBookInReadingPlan");
    try {
      //const userId = req.query.userId as string | undefined;
      //const bookId = req.query.bookId as string | undefined;
      const { bookId, userId } = req.body;
  
      if (!userId || !bookId) {
        console.log("isBookInReadingPlan missed fields");
        res.status(400).json({ message: "Missing userId or bookId in query" });
        return;
      }
      console.log("isBookInReadingPlan2");
      const postfix = req.query.postfix as string | undefined;
      const collectionName = `readingPlans${postfix ? '-' + postfix : ''}`;
  
      const docId = `${userId}_${bookId}`;
      const docRef = admin.firestore().collection(collectionName).doc(docId);
      const docSnapshot = await docRef.get();
  
      res.status(200).json({ inPlan: docSnapshot.exists });
    } catch (error) {
      console.error("Error checking reading plan:", error);
      res.status(500).json({ message: "Internal server error" });
    }
  });
  
  