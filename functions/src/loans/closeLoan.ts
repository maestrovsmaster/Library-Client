import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { Timestamp } from 'firebase-admin/firestore';

export const closeLoan = functions.https.onRequest(async (req, res) => {

  console.log("CloseLoan");
  try {
    const { loanId, bookId } = req.body;

    if (!loanId && !bookId) {
      res.status(400).json({ message: "Missing loanId or bookId" });
      return;
    }

    const postfix = req.query.postfix as string | undefined;
    const loansCollection = `loans${postfix ? '-' + postfix : ''}`;
    const booksCollection = `books${postfix ? '-' + postfix : ''}`;

    let loanRef: FirebaseFirestore.DocumentReference;
    let loanData: FirebaseFirestore.DocumentData | undefined;

    if (loanId) {
      loanRef = admin.firestore().collection(loansCollection).doc(loanId);
      const doc = await loanRef.get();
      if (!doc.exists) {
        res.status(404).json({ message: "Loan not found" });
        return;
      }
      loanData = doc.data();
    } else {
      const loanQuery = await admin.firestore()
        .collection(loansCollection)
        .where("book.id", "==", bookId)
        .where("dateReturned", "==", null) // тільки активні
        .limit(1)
        .get();

      if (loanQuery.empty) {
        res.status(404).json({ message: "Active loan for this book not found" });
        return;
      }
      console.log("LoanQuery = ", loanQuery);

      loanRef = loanQuery.docs[0].ref;
      loanData = loanQuery.docs[0].data();
    }
    console.log("loanRef = ", loanRef);
    const finalBookId = loanData?.book?.id;

    const dateReturned = Timestamp.now().toDate().toISOString().split('T')[0];

    await loanRef.update({
      dateReturned: dateReturned// Timestamp.now(),
    });

    if (finalBookId) {
      await admin.firestore().collection(booksCollection).doc(finalBookId).update({
        isAvailable: true,
        updatedAt: Timestamp.now(),
      });
    }

    res.status(200).json({ message: "Loan closed successfully", loanId: loanRef.id });
  } catch (error) {
    console.error("Error closing loan:", error);
    res.status(500).json({ message: "Internal server error" });
  }
});

