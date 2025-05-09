import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { Timestamp } from 'firebase-admin/firestore';
import { handleError } from './../utils/error_handler';
import { corsHandler, handlePreflight } from './../utils/corsMiddleware';
import { getDecodedAccessToken } from './authorizationUtils';

if (!admin.apps.length) {
    admin.initializeApp();
}

const timestamp: Timestamp = Timestamp.now();


export const verifyToken = functions.https.onRequest((req, res) => {
    handlePreflight(req, res, () => {
      corsHandler(req, res, async () => {
        try {
          const authorization = req.headers.authorization;
          if (!authorization || !authorization.startsWith('Bearer ')) {
            throw new functions.https.HttpsError('unauthenticated', 'Токен відсутній або неправильний.');
          }
  
          const idToken = authorization.split('Bearer ')[1];
          const decodedToken = await getDecodedAccessToken(idToken);
  
          const user_id = decodedToken.user_id;
          const email = decodedToken.email || '';
          const login = decodedToken.name || '';
          const photoUrl = decodedToken.picture || '';
          const postfix = req.query.postfix as string | undefined;
  
          const collectionUsers = `users${postfix ? '-' + postfix : ''}`;
          const collectionReaders = `readers${postfix ? '-' + postfix : ''}`;
          //const collectionRoles = `roles${postfix ? '-' + postfix : ''}`;
          const collectionBans = `userBans${postfix ? '-' + postfix : ''}`;
  
          const userRef = admin.firestore().collection(collectionUsers).doc(user_id);
          let userDoc = await userRef.get();
  
          // Role logic
          
          /*const roleDoc = await admin.firestore().collection(collectionRoles).doc(user_id).get();
          if (roleDoc.exists && roleDoc.data()?.role) {
            role = roleDoc.data()!.role;
          }*/
  
          let userData: any;
  
          // Якщо user існує — перевіримо, чи є readerId або name / phoneNumber
          if (userDoc.exists) {
            userData = userDoc.data();
  
            const needsReaderData =
              !userData.readerId || !userData.name || !userData.phoneNumber;
  
            if (needsReaderData && email) {
              const readerQuery = await admin.firestore()
                .collection(collectionReaders)
                .where('email', '==', email)
                .limit(1)
                .get();
  
              if (!readerQuery.empty) {
                const readerDoc = readerQuery.docs[0];
                const reader = readerDoc.data();
  
                userData.readerId = readerDoc.id;
  
                if (!userData.name && reader.name) {
                  userData.name = reader.name;
                }
  
                if (!userData.phoneNumber && reader.phoneNumber) {
                  userData.phoneNumber = reader.phoneNumber;
                }
  
                // Зберігаємо оновлення
                await userRef.set(userData, { merge: true });
              }
            }
  
          } else {
            // Створення нового користувача
            let role = 'reader';

            userData = {
              userId: user_id,
              email: email,
              login: login,
              name: null,
              phoneNumber: null,
              phoneNumberAlt: null,
              photoUrl: photoUrl,
              role: role,
              createdAt: timestamp,
            };
  
            // Перевірка, чи є reader
            const readerQuery = await admin.firestore()
              .collection(collectionReaders)
              .where('email', '==', email)
              .limit(1)
              .get();
  
            if (!readerQuery.empty) {
              const readerDoc = readerQuery.docs[0];
              const reader = readerDoc.data();
  
              userData.readerId = readerDoc.id;
              if (reader.name) userData.name = reader.name;
              if (reader.phoneNumber) userData.phoneNumber = reader.phoneNumber;
            }
  
            await userRef.set(userData);
          }
  
          // Check for ban
          const banDoc = await admin.firestore().collection(collectionBans).doc(user_id).get();
          if (banDoc.exists) {
            throw new functions.https.HttpsError('permission-denied', 'Користувач заблокований.');
          }
  
          // OK: повертаємо профіль
         // userData.role = role;
          res.status(200).json(userData);
  
        } catch (error) {
          console.error('Error user authorization:', error);
          return handleError(res, error);
        }
      });
    });
  });
  
