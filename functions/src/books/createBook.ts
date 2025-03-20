
import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { Timestamp } from 'firebase-admin/firestore';

export const createBook = functions.https.onRequest(async (req, res) => {
    try {
        const { title, author, genre, barcode, imageUrl, publisher, description } = req.body;

        if (!title || !author || !genre) {
             res.status(400).json({ message: "Missing required fields" });
        }

        const newBook = {
            title,
            author,
            genre,
            barcode: barcode || null, // може бути null
            imageUrl: imageUrl || null,
            publisher: publisher || null,
            description: description || null,
            isAvailable: true,
            createdAt: Timestamp.now(),
            updatedAt: Timestamp.now(),
        };

        const bookRef = await admin.firestore().collection('books').add(newBook);

         res.status(201).json({ id: bookRef.id, ...newBook });
    } catch (error) {
        console.error("Error creating book:", error);
         res.status(500).json({ message: "Internal server error" });
    }
});
