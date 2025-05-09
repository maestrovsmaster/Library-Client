
import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { Timestamp } from 'firebase-admin/firestore';
import { checkAuthAndRole } from '../middleware/middleware';

export const createBook = functions.https.onRequest(async (req, res) => {
    try {

        const { role } = await checkAuthAndRole(req);
        

        if (role !== 'admin' && role !== 'librarian') {
             res.status(403).json({ message: 'Access denied: Insufficient permissions' });
             return
        }

        const { title, author, genre, barcode, imageUrl, publisher, description } = req.body;

        if (!title || !author || !genre) {
             res.status(400).json({ message: "Missing required fields" });
             return;
        }

        const newBook = {
            title,
            author,
            genre,
            barcode: barcode || null, 
            imageUrl: imageUrl || null,
            publisher: publisher || null,
            description: description || null,
            isAvailable: true,
            createdAt: Timestamp.now(),
            updatedAt: Timestamp.now(),
        };

        const postfix = req.query.postfix as string | undefined;
        const collectionName = `books${postfix ? '-' + postfix : ''}`;
        const bookRef = await admin.firestore().collection(collectionName).add(newBook);

         res.status(201).json({ id: bookRef.id, ...newBook });
    } catch (error) {
        console.error("Error creating book:", error);
         res.status(500).json({ message: "Internal server error" });
    }
});
