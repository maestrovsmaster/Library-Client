import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

if (!admin.apps.length) {
    admin.initializeApp();
}

export const getBook = functions.https.onRequest(async (req, res) => {
    try {
        const { barcode } = req.query;
        if (!barcode) {
            res.status(400).json({ message: "Missing barcode parameter" });
            return;
        }
        const booksRef = admin.firestore().collection('books');
        const querySnapshot = await booksRef.where('barcode', '==', barcode).get();
        if (querySnapshot.empty) {
             res.status(200).json(null); 
           
        }
        const book = querySnapshot.docs[0].data();
        res.status(200).json(book);
    } catch (error) {
        console.error("Error getting book:", error);
        res.status(500).json({ message: "Internal server error" });
    }
});

