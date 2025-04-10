import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { Timestamp } from "firebase-admin/firestore";

export const createReadingPlan = functions.https.onRequest(async (req, res) => {
  try {
    const { bookId, userId } = req.body;

    console.log("bookId =", bookId);
    console.log("userId =", userId);

    if (!bookId || !userId) {
      res.status(400).json({ message: "Missing required fields" });
      return;
    }

    const postfix = req.query.postfix as string | undefined;
    const collectionName = `readingPlans${postfix ? '-' + postfix : ''}`;

    const docId = `${userId}_${bookId}`;
    const docRef = admin.firestore().collection(collectionName).doc(docId);

    await docRef.set({
      userId,
      bookId,
      createdAt: Timestamp.now(),
    });

    res.status(201).json({ message: "Reading plan added", id: docId });
  } catch (error) {
    console.error("Error creating reading plan:", error);
    res.status(500).json({ message: "Internal server error" });
  }
});
