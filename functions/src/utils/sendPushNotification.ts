
import * as admin from 'firebase-admin';

export const sendPushNotification = async (
  userId: string,
  bookId: string
) => {
  const userDoc = await admin.firestore().collection('users-dev').doc(userId).get();
  const fcmToken = userDoc.data()?.fcmToken;

  if (!fcmToken) {
    console.warn(`User ${userId} has no FCM token`);
    return;
  }

  const payload = {
    token: fcmToken,
    notification: {
      title: 'Книга доступна!',
      body: 'Ваша книга тепер вільна для позики!',
    },
    data: {
      bookId: bookId,
      type: 'book_available',
    },
  };

  try {
    await admin.messaging().send(payload);
    console.log(`Push sent to user ${userId}`);
  } catch (error) {
    console.error(`Error sending push to user ${userId}:`, error);
  }
};
