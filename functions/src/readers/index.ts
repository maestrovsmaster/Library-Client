import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { createReader } from './createReader';


if (!admin.apps.length) {
    admin.initializeApp();
}

export const readers = {
    createReader: functions.https.onRequest(createReader)
};