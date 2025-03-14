import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { getBook } from './getBook';
import { createBook } from './createBook';
import { updateBook } from './updateBook';

if (!admin.apps.length) {
    admin.initializeApp();
}

export const books = {
    getBook: functions.https.onRequest(getBook),
    createBook: functions.https.onRequest(createBook),
    updateBook: functions.https.onRequest(updateBook),
};
