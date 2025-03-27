import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

export const checkAuthAndRole = async (req: functions.https.Request) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    throw new Error('Unauthorized: Missing token');
  }

  const idToken = authHeader.split('Bearer ')[1];
  //console.error(">idToken=",idToken);
  const decodedToken = await admin.auth().verifyIdToken(idToken);
  const userId = decodedToken.uid;
  console.error(">userId=",userId);
  const postfix = req.query.postfix as string | undefined;
  const collectionName = `roles${postfix ? '-' + postfix : ''}`;
  const roleDoc = await admin.firestore().collection(collectionName).doc(userId).get();
  console.error(">roleDoc=",roleDoc);
  if (!roleDoc.exists) {
    throw new Error('Forbidden: No role assigned');
  }

  const role = roleDoc.data()?.role;
  return { userId, email: decodedToken.email, role };
};
