import * as functions from 'firebase-functions';
import { verifyAuthorization, isUserBanned } from './authorizationUtils'; 

export async function verifyAdminAccess(req: functions.https.Request): Promise<void> {
    const user = await verifyAuthorization(req);
    if (!user || !user.userId) {
        throw new functions.https.HttpsError('unauthenticated', 'User is unauthorized');
    }

    const isBanned = await isUserBanned(user.userId);
    if (isBanned) {
        throw new functions.https.HttpsError('permission-denied', 'User is banned');
    }

   // if (!user.isAdmin) {
   //     throw new functions.https.HttpsError('permission-denied', 'User does not have admin permissions');
   // }
}