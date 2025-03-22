import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

export const checkAuthAndRole = async (req: functions.https.Request) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    throw new Error('Unauthorized: Missing token');
  }

  const idToken = authHeader.split('Bearer ')[1];
  const decodedToken = await admin.auth().verifyIdToken(idToken);
  const userId = decodedToken.uid;

  const roleDoc = await admin.firestore().collection('roles').doc(userId).get();

  if (!roleDoc.exists) {
    throw new Error('Forbidden: No role assigned');
  }

  const role = roleDoc.data()?.role;
  return { userId, email: decodedToken.email, role };
};
