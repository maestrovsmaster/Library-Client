import cors from 'cors';
import { Request, Response, NextFunction } from 'express';

// Список дозволених доменів
const allowedOrigins = [
    'https://reveal-luxury-candles.co.uk',
    'https://reveal-luxury-candles.web.app',
    'http://localhost:5001',
    'https://reveal-luxury-candles.firebaseapp.com'
];

// CORS middleware з динамічним `Access-Control-Allow-Origin`
/*export const corsHandler = cors({
    origin: (origin, callback) => {
        if (!origin || allowedOrigins.includes(origin)) {
            callback(null, true);
        } else {
            callback(new Error('Not allowed by CORS'));
        }
    },
});*/

export const corsHandler = cors({
    origin: (origin: string | undefined, callback: (err: Error | null, allow?: boolean) => void) => {
      if (!origin || allowedOrigins.includes(origin)) {
        callback(null, true);
      } else {
        callback(new Error('Not allowed by CORS'));
      }
    },
  });
  

// Middleware для preflight-запитів
export const handlePreflight = (req: Request, res: Response, next: NextFunction) => {
    if (req.method === 'OPTIONS') {
        const origin = req.headers.origin;

        // Додаємо заголовки тільки для дозволених доменів
        if (origin && allowedOrigins.includes(origin)) {
            res.set('Access-Control-Allow-Origin', origin);
        }
        res.set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
        res.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');
        res.set('Access-Control-Allow-Credentials', 'true');
        res.status(204).send('');
    } else {
        next();
    }
};

