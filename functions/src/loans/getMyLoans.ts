import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

export const getMyLoans = functions.https.onRequest(async (req, res) => {
    console.log("getMyLoans");
    try {
        //const userId = req.query.userId as string | undefined;
        //const bookId = req.query.bookId as string | undefined;
        const { userId } = req.body;

        if (!userId) {
            console.log("getMyLoans missed fields");
            res.status(400).json({ message: "Missing userId  in query" });
            return;
        }
        console.log("getMyLoans 2");
        const postfix = req.query.postfix as string | undefined;
        const collectionName = `loans${postfix ? '-' + postfix : ''}`;

        const docRef = admin.firestore().collection(collectionName).where('reader.id', '==', userId);
        const docSnapshot = await docRef.get();
        if (docSnapshot.empty) {
            res.status(200).json(null);

        }

        const loans = docSnapshot.docs.map(doc => ({
            id: doc.id,
            ...doc.data()
        }));

        res.status(200).json(loans);
    } catch (error) {
        console.error("Error checking reading plan:", error);
        res.status(500).json({ message: "Internal server error" });
    }
});
