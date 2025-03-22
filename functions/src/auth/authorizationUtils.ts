import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

import * as jwt_decode from "jwt-decode";
import { User } from '../models/user';


if (!admin.apps.length) {
    admin.initializeApp();
}

// Функція для декодування токена
function getDecodedAccessToken(token: string): any {
    try {
        const decodedToken =  jwt_decode.jwtDecode(token);
        console.log("getDecodedAccessToken decodedToken = ", decodedToken);
        return decodedToken;
    } catch (error) {
        console.log("getDecodedAccessToken error = ", error);
        throw new functions.https.HttpsError('unauthenticated', 'Invalid token format');
    }
}

// Функція для перевірки, чи є користувач у бан-листі
async function isUserBanned(userId: string): Promise<boolean> {
    try {
        const banRef = admin.firestore().collection('UserBans').doc(userId);
        const banDoc = await banRef.get();

        if (banDoc.exists) {
            console.log(`User ${userId} is banned.`);
            return true;
        }

        return false;
    } catch (error) {
        console.error('Error checking user ban status:', error);
        throw new functions.https.HttpsError('internal', 'Failed to check ban status');
    }
}

// Функція для верифікації авторизації
async function verifyAuthorization(req: functions.https.Request): Promise<User | null> {
    try {
        const authorization = req.headers.authorization;

        if (!authorization || !authorization.startsWith('Bearer ')) {
            console.log("Missing or invalid authorization header");
            return null;
        }

        const idToken = authorization.split('Bearer ')[1];
        console.log("Authorization idToken =", idToken);

        // Декодуємо токен
        const decodedToken = getDecodedAccessToken(idToken);
        const userId = decodedToken.user_id;

        console.log("Authorization uid =", userId);

        const postfix = req.query.postfix as string | undefined;
        const collectionName = `users${postfix ? '-' + postfix : ''}`;
        // Перевіряємо, чи є користувач у базі даних
        const userRef = admin.firestore().collection(collectionName).doc(userId);
        const userDoc = await userRef.get();

        if (!userDoc.exists) {
            console.log(`User with ID ${userId} not found.`);
            return null;
        }

        const userData = userDoc.data();

        if (!userData) {
            console.log("User data is empty.");
            return null;
        }

        // Створюємо об'єкт користувача
        const user = User.fromFirestore(userData);

        // Перевіряємо, чи користувач у бан-листі
        const banned = await isUserBanned(userId);
        if (banned) {
            throw new functions.https.HttpsError('permission-denied', 'User is banned.');
        }

        return user;
    } catch (error) {
        console.error("Error in verifyAuthorization:", error);
        return null;
    }
}

export { verifyAuthorization, isUserBanned, getDecodedAccessToken };
