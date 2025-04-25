import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { Timestamp } from 'firebase-admin/firestore';
import { updateBookAvailability } from '../utils/updateBookAvailability';


export const createLoan = functions.https.onRequest(async (req, res) => {

    console.log("createLoan...")
    try {
        const { book, reader } = req.body;

        if (!book || !reader) {
            res.status(400).json({ message: "Missing book or reader information" });
            return;
        }

        const postfix = req.query.postfix as string | undefined;
        const loansCollection = `loans${postfix ? '-' + postfix : ''}`;
       // const booksCollection = `books${postfix ? '-' + postfix : ''}`;

        const dateBorrowed = Timestamp.now().toDate().toISOString().split('T')[0];

        const loan = {
            book,
            reader: {
                id: reader.id || null,
                email: reader.email,
                name: reader.name,
                phoneNumber: reader.phoneNumber || "",
                phoneNumberAlt: reader.phoneNumberAlt || "",
            },
            borrowedBy: req.body.borrowedBy || "",
            //dateBorrowed: Timestamp.now(),
            //dateReturned: null,
            dateBorrowed: dateBorrowed, // Timestamp.fromDate(new Date(req.body.dateBorrowed)),
            dateReturned: "", //req.body.dateReturned ? Timestamp.fromDate(new Date(req.body.dateReturned)) : "",
        };

        // console.log("createLoan = ",loan)

        const loanRef = await admin.firestore().collection(loansCollection).add(loan);
        console.log("createLoan Success!!")
        const bookId = book.id;
        console.log("bookId = ", bookId)
        try {
            if (bookId) {
                //await admin.firestore().collection(booksCollection).doc(bookId).update({
               //     isAvailable: false,
                    updatedAt: Timestamp.now(),
               // });
               await updateBookAvailability(bookId, false, postfix);
               
            }
        } catch (error) {
            console.error("Error updating book available:", error);
            res.status(201).json({
                id: loanRef.id,
                ...loan,
                warnings: ["Book was already marked unavailable", "Could not update book availability"],
            });
        }

        res.status(201).json({ id: loanRef.id, ...loan });
    } catch (error) {
        console.error("Error creating loan:", error);
        res.status(500).json({ message: "Internal server error" });
    }
});

