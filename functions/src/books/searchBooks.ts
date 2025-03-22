import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

if (!admin.apps.length) {
    admin.initializeApp();
}

export const searchBooks = functions.https.onRequest(async (req, res) => {
    try {
        const { query } = req.query;
        if (!query) {
            res.status(400).json({ message: "Missing query parameter" });
            return;
        }

        const searchQuery = 
        typeof query === "string" ? query.toLowerCase().trim() : 
        Array.isArray(query) && typeof query[0] === "string" ? query[0].toLowerCase().trim() : 
        "";
        const postfix = req.query.postfix as string | undefined;
        const collectionName = `books${postfix ? '-' + postfix : ''}`;
        const booksRef = admin.firestore().collection(collectionName);

        // 1. Шукаємо в полі `title`
        const titleSnapshot = await booksRef
            .where("title", ">=", searchQuery)
            .where("title", "<=", searchQuery + "\uf8ff").get(); 

        // 2. Шукаємо в полі `author`
        const authorSnapshot = await booksRef
            .where("author", ">=", searchQuery)
            .where("author", "<=", searchQuery + "\uf8ff") // Емуляція часткового пошуку
            .get();

        // 3. Об'єднуємо результати (уникнення дублікатів)
        const books = new Map();

        titleSnapshot.docs.forEach(doc => books.set(doc.id, doc.data()));
        authorSnapshot.docs.forEach(doc => books.set(doc.id, doc.data()));

        res.status(200).json(Array.from(books.values()));

    } catch (error) {
        console.error("Error searching books:", error);
        res.status(500).json({ message: "Internal server error" });
    }
});
