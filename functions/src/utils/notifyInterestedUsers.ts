
import * as admin from 'firebase-admin';
import { sendPushNotification } from './sendPushNotification';

export const notifyInterestedUsers = async (
  bookId: string,
  postfix: string = ''
) => {
  const readingPlansCollection = `readingPlans${postfix ? '-' + postfix : ''}`;

  const plansQuery = await admin.firestore()
    .collection(readingPlansCollection)
    .where('bookId', '==', bookId)
    .get();

  if (plansQuery.empty) {
    console.log(`No reading plans found for book ${bookId}`);
    return;
  }

  const userIds = plansQuery.docs.map(doc => doc.data().userId);

  for (const userId of userIds) {
    await sendPushNotification(userId, bookId);
  }
};
