import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { Timestamp } from 'firebase-admin/firestore';
import { updateBookReviewStats } from './updateBookReviewStats'; 

export const createReview = functions.https.onRequest(async (req, res) => {
    try {
      const { bookId, userId, userName, userAvatarUrl, rate, text } = req.body;
  
      console.log("bookId =",bookId);
      console.log("userId =",userId);
      console.log("userName =",userName);
      console.log("userAvatarUrl =",userAvatarUrl);
      console.log("rate =",rate);
      console.log("text =",text);

      if (!bookId || !userId || !userName || !rate || !text) {
       
        res.status(400).json({ message: "Missing required fields" });
        return;
      }
  
      const newReview = {
        bookId,
        userId,
        userName,
        userAvatarUrl: userAvatarUrl || "",
        rate,
        text,
        date: Timestamp.now(),
      };
  
      const postfix = req.query.postfix as string | undefined;
      const collectionName = `reviews${postfix ? '-' + postfix : ''}`;
      const docRef = await admin.firestore().collection(collectionName).add(newReview);

      await updateBookReviewStats(bookId, postfix);
  
      res.status(201).json({ id: docRef.id, ...newReview });
    } catch (error) {
      console.error("Error creating review:", error);
      res.status(500).json({ message: "Internal server error" });
    }
  });
  