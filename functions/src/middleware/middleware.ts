import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import * as jwt_decode from "jwt-decode";

export const checkAuthAndRole = async (req: functions.https.Request) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    throw new Error('Unauthorized: Missing token');
  }

  const idToken = authHeader.split('Bearer ')[1];
  //console.error(">idToken=",idToken);
  //const decodedToken = await admin.auth().verifyIdToken(idToken);
  const decodedToken =  jwt_decode.jwtDecode<DecodedIdToken>(idToken);
  console.log("decodedToken = ",decodedToken);
  const userId = decodedToken.user_id;//uid;
  //console.error(">userId=",userId);



  const postfix = req.query.postfix as string | undefined;
  const collectionName = `users${postfix ? '-' + postfix : ''}`;
  const userDoc = await admin.firestore().collection(collectionName).doc(userId).get();
  console.error(">userDoc=",userDoc);
  if (!userDoc.exists) {
    throw new Error('Forbidden: No role assigned');
  }

  const role = userDoc.data()?.role;
  return { userId, email: decodedToken.email, role };
};
