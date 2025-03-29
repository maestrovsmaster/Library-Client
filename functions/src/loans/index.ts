import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { createLoan } from './createLoan';
import { closeLoan } from './closeLoan';


if (!admin.apps.length) {
    admin.initializeApp();
}

export const loans = {
    createLoan: functions.https.onRequest(createLoan),
    closeLoan: functions.https.onRequest(closeLoan)
};