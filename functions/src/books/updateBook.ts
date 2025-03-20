
import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { Timestamp } from 'firebase-admin/firestore';

export const updateBook = functions.https.onRequest(async (req, res) => {
    try {
        const { id, title, author, genre, barcode, imageUrl, publisher, description } = req.body;

        if (!id) {
             res.status(400).json({ message: "Missing book ID" });
        }

        const bookRef = admin.firestore().collection('books').doc(id);
        const bookDoc = await bookRef.get();

        if (!bookDoc.exists) {
             res.status(404).json({ message: "Book not found" });
        }

        const updatedBook = {
            title: title || bookDoc.data()?.title,
            author: author || bookDoc.data()?.author,
            genre: genre || bookDoc.data()?.genre,
            barcode: barcode || bookDoc.data()?.barcode,
            imageUrl: imageUrl || bookDoc.data()?.imageUrl,
            publisher: publisher || bookDoc.data()?.publisher,
            description: description || bookDoc.data()?.description,
            updatedAt: Timestamp.now(),
        };

        await bookRef.update(updatedBook);

         res.status(200).json({ message: "Book updated successfully", data: updatedBook });
    } catch (error) {
        console.error("Error updating book:", error);
         res.status(500).json({ message: "Internal server error" });
    }
});
