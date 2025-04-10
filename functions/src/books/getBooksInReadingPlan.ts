import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

export const getBooksInReadingPlan = functions.https.onRequest(async (req, res) => {
    try {
      const userId = req.query.userId as string | undefined;
      const postfix = req.query.postfix as string | undefined;
      const collectionName = `readingPlans${postfix ? '-' + postfix : ''}`;
  
      if (!userId) {
        res.status(400).json({ message: "Missing userId in query" });
        return;
      }
  
      // 1. all books from  readingPlans for userId
      const plansSnapshot = await admin.firestore()
        .collection(collectionName)
        .where("userId", "==", userId)
        .get();
  
      const bookIds = plansSnapshot.docs.map(doc => doc.data().bookId);
  
      if (bookIds.length === 0) {
        res.status(200).json([]);
        return;
      }
  
      // 2. get books from books collection
      const booksRef = admin.firestore().collection("books");
      
      // Firestore allow max 10 values for `in`-query
      const chunked = (arr: string[], size: number) =>
        Array.from({ length: Math.ceil(arr.length / size) }, (_, i) =>
          arr.slice(i * size, i * size + size)
        );
  
      const chunks = chunked(bookIds, 10);
      const books: any[] = [];
  
      for (const chunk of chunks) {
        const booksSnapshot = await booksRef.where(admin.firestore.FieldPath.documentId(), 'in', chunk).get();
        books.push(...booksSnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() })));
      }
  
      res.status(200).json(books);
    } catch (error) {
      console.error("Error getting books in reading plan:", error);
      res.status(500).json({ message: "Internal server error" });
    }
  });
  