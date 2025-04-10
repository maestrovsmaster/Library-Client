import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

import { createReadingPlan } from './createReadingPlan';
import { deleteReadingPlan } from './deleteReadingPlan';
import { isBookInReadingPlan } from './isBookInReadingPlan';


if (!admin.apps.length) {
    admin.initializeApp();
}

export const readingPlans = {
    createReadingPlan: functions.https.onRequest(createReadingPlan),
    deleteReadingPlan: functions.https.onRequest(deleteReadingPlan),
    isBookInReadingPlan: functions.https.onRequest(isBookInReadingPlan),
};