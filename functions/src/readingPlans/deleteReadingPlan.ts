import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

export const deleteReadingPlan = functions.https.onRequest(async (req, res) => {
    console.log("deleteReadingPlan");
    try {
      const { bookId, userId } = req.body;

      console.log("deleteReadingPlan1");
  
      if (!bookId || !userId) {
        console.log("deleteReadingPlan missed fields");
        res.status(400).json({ message: "Missing required fields" });
        return;
      }



      console.log("deleteReadingPlan bookId = ",bookId);
      console.log("deleteReadingPlan userId = ",userId);

      const postfix = req.query.postfix as string | undefined;
      const collectionName = `readingPlans${postfix ? '-' + postfix : ''}`;
  
      const docId = `${userId}_${bookId}`;
      console.log("deleteReadingPlan docId = ",docId);
      console.log("deleteReadingPlan collectionName = ",collectionName);
      const docRef = admin.firestore().collection(collectionName).doc(docId);
      console.log("deleteReadingPlan docRef = ",docRef);
      await docRef.delete();
  
      res.status(200).json({ message: "Reading plan removed", id: docId });
    } catch (error) {
      console.error("Error deleting reading plan:", error);
      res.status(500).json({ message: "Internal server error" });
    }
  });
  