import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
// import { Timestamp } from 'firebase-admin/firestore';
// import { handleError } from './../utils/error_handler';
// import { corsHandler, handlePreflight } from './../utils/corsMiddleware';
//import { verifyUserAccess } from './../utils/authMiddleware';
// import { getDecodedAccessToken } from './authorizationUtils';

if (!admin.apps.length) {
    admin.initializeApp();
}

// const firestore = admin.firestore();
//const usersCollection = firestore.collection('Users');

export const getBook = functions.https.onRequest(async (req, res) => {
    try {
        console.log("getBook");
        const { barcode } = req.query;
        console.log("getBookb ", barcode);
        if (!barcode) {
            res.status(400).json({ message: "Missing barcode parameter" });
            return;
        }
        console.log("getBookb 1");
        const booksRef = admin.firestore().collection('books');
        console.log("getBookb 2");
        const querySnapshot = await booksRef.where('barcode', '==', barcode).get();
        console.log("getBookb 3");
        if (querySnapshot.empty) {
            console.log("getBookb 31");
             res.status(200).json(null); 
           
        }
        console.log("getBookb 4");
        const book = querySnapshot.docs[0].data();
        console.log("getBookb 5");
        res.status(200).json(book);
    } catch (error) {
        console.error("Error getting book:", error);
        res.status(500).json({ message: "Internal server error" });
    }
});

