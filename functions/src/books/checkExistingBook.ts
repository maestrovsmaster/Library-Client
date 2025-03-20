import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { Book } from "../models/book";

export const checkExistingBook = functions.https.onRequest(async (req, res) => {
    try {
        const { title, author } = req.query;

        if (!title || !author) {
            res.status(400).json({ message: "Missing title or author parameter" });
            return;
        }

        // Приведення введених значень до нижнього регістру та обрізання пробілів
        const titleQuery = String(title).toLowerCase().trim();
        const authorQuery = String(author).toLowerCase().trim();

        const booksRef = admin.firestore().collection("books");

        // Отримання книг, що збігаються за назвою та автором (з ігноруванням регістру)
        const snapshot = await booksRef.get();


        const matchedBooks = snapshot.docs
            .map(doc => ({ id: doc.id, ...(doc.data() as Book) })) // Явно вказуємо, що doc.data() має тип Book
            .filter(book =>
                book.title && book.author &&
                String(book.title).toLowerCase().trim() === titleQuery &&
                String(book.author).toLowerCase().trim() === authorQuery
            );

        res.status(200).json(matchedBooks);
    } catch (error) {
        console.error("Error checking book existence:", error);
        res.status(500).json({ message: "Internal server error" });
    }
});