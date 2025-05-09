import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

import { createReview } from './createReview';
import { updateReview } from './updateReview';
import { deleteReview } from './deleteReview';
import { reviewsList } from './reviewsList';

if (!admin.apps.length) {
  admin.initializeApp();
}

export const reviews = {
  createReview: functions.https.onRequest(createReview),
  updateReview: functions.https.onRequest(updateReview),
  deleteReview: functions.https.onRequest(deleteReview),
  reviewsList: functions.https.onRequest(reviewsList),
};
