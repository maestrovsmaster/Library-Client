import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { Timestamp } from 'firebase-admin/firestore';
import { handleError } from './../utils/error_handler';
import { corsHandler, handlePreflight } from './../utils/corsMiddleware';
//import { verifyUserAccess } from './../utils/authMiddleware';
import { getDecodedAccessToken } from './authorizationUtils';

if (!admin.apps.length) {
    admin.initializeApp();
}

const firestore = admin.firestore();
const usersCollection = firestore.collection('Users');

export const updateUser = functions.https.onRequest((req, res) => {
    handlePreflight(req, res, () => {
        corsHandler(req, res, async () => {
            try {
                 const authorization = req.headers.authorization;
                                if (!authorization || !authorization.startsWith('Bearer ')) {
                                    throw new functions.https.HttpsError('unauthenticated', 'Токен відсутній або неправильний.');
                                }
                // Перевірка токена користувача
              
                const idToken = authorization.split('Bearer ')[1];
                console.log("authorization idToken = ", idToken);
                const decodedToken = await getDecodedAccessToken(idToken);
                const userId = decodedToken.user_id;

                if (!userId) {
                    return res.status(401).json({
                        message: 'Unauthorized - Missing user ID',
                        code: 401,
                    });
                }

                const { name, phoneNumber, phoneNumberAlt } = req.body;

                if (!name || !phoneNumber) {
                    return res.status(400).json({
                        message: 'Missing required fields: name and phoneNumber',
                        code: 400,
                    });
                }

                const userRef = usersCollection.doc(userId);
                const userDoc = await userRef.get();

                if (!userDoc.exists) {
                    return res.status(404).json({
                        message: 'User not found',
                        code: 404,
                    });
                }

                const updatedUser = {
                    name,
                    phoneNumber,
                    phoneNumberAlt: phoneNumberAlt || null,
                    updatedAt: Timestamp.now(),
                };

                await userRef.update(updatedUser);

                functions.logger.info(`User ${userId} updated successfully`);
                return res.status(200).json({
                    message: 'User updated successfully',
                    code: 200,
                    data: { userId, ...updatedUser },
                });
            } catch (error) {
                console.error('Error updating user:', error);
                return handleError(res, error);
            }
        });
    });
});
