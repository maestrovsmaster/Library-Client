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
                console.log("authorization idToken = ", idToken);
                const decodedToken = await getDecodedAccessToken(idToken);

                const user_id = decodedToken.user_id;
                console.log("authorization uid = ", user_id);

                // Check user in Firestore
                const postfix = req.query.postfix as string | undefined;
                const collectionNameUsers = `users${postfix ? '-' + postfix : ''}`;
                const userRef = admin.firestore().collection(collectionNameUsers).doc(user_id);
                const userDoc = await userRef.get();


                let role = 'reader'; // default role
                const collectionNameRoles = `roles${postfix ? '-' + postfix : ''}`;
                const roleDoc = await admin.firestore().collection(collectionNameRoles).doc(user_id).get();
                if (roleDoc.exists && roleDoc.data()?.role) {
                  role = roleDoc.data()!.role;
                }


                let userData;

                if (userDoc.exists) {
                    userData = userDoc.data();
                    if (userData) {
                        userData.role = role;
                      }
                } else {
                    userData = {
                        user_id,
                        email: decodedToken.email || '',
                        login: decodedToken.name || '',
                        name: null,
                        phoneNumber: null,
                        phoneNumberAlt: null,
                        photoUrl: decodedToken.picture,
                        role: role, // Нові користувачі за замовчуванням не є адміністраторами
                        createdAt: timestamp,
                    };

                    await userRef.set(userData);
                }

                // Перевіряємо статус "isBanned" (якщо потрібно)
                const collectionName = `userBans${postfix ? '-' + postfix : ''}`;
                const banRef = admin.firestore().collection(collectionName).doc(user_id);
                const banDoc = await banRef.get();

                if (banDoc.exists) {
                    throw new functions.https.HttpsError('permission-denied', 'Користувач заблокований.');
                }

                // Повертаємо користувача на клієнт
                res.status(200).json(userData);
            } catch (error) {
                console.error('Error user authorization:', error);
                return handleError(res, error);
            }
        });
    });
});
