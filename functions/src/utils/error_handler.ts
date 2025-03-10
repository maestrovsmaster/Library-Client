import * as functions from 'firebase-functions';
import { Response } from 'express';

export function handleError(response: Response, error: unknown): void {
    if (error instanceof functions.https.HttpsError) {
        response.status(error.httpErrorCode.status).json({
            message: error.message,
            code: error.code,
        });
    } else {
        response.status(500).json({
            message: 'Internal Server Error',
            code: 500,
            error: error instanceof Error ? error.message : 'Unknown error',
        });
    }
}
