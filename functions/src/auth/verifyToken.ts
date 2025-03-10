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
                const userRef = admin.firestore().collection('Users').doc(user_id);
                const userDoc = await userRef.get();

                let userData;

                if (userDoc.exists) {
                    userData = userDoc.data();
                } else {
                    userData = {
                        user_id,
                        email: decodedToken.email || '',
                        login: decodedToken.name || '',
                        name: null,
                        phoneNumber: null,
                        phoneNumberAlt: null,
                        role: null, // Нові користувачі за замовчуванням не є адміністраторами
                        createdAt: timestamp,
                    };

                    await userRef.set(userData);
                }

                // Перевіряємо статус "isBanned" (якщо потрібно)
                const banRef = admin.firestore().collection('UserBans').doc(user_id);
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
