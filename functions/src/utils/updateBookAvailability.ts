// src/utils/updateBookAvailability.ts
import * as admin from 'firebase-admin';
import { Timestamp } from 'firebase-admin/firestore';

export const updateBookAvailability = async (
  bookId: string,
  isAvailable: boolean,
  postfix: string = ''
) => {
  const booksCollection = `books${postfix ? '-' + postfix : ''}`;

  const bookRef = admin.firestore().collection(booksCollection).doc(bookId);
  await bookRef.update({
    isAvailable,
    updatedAt: Timestamp.now(),
  });

  

  return bookRef;
};
