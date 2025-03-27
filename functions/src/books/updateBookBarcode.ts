import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { Timestamp } from 'firebase-admin/firestore';
import { checkAuthAndRole } from '../middleware/middleware';

export const updateBookBarcode = functions.https.onRequest(async (req, res) => {
    try {
        console.error('checkAuthAndRole ....');
      const { role } = await checkAuthAndRole(req);
      console.error('role', role);
      if (role !== 'admin' && role !== 'librarian') {
        res.status(403).json({ message: 'Access denied: Insufficient permissions' });
        return;
      }
      console.error('role ok');
      const postfix = req.query.postfix as string | undefined;
      const collectionName = `books${postfix ? '-' + postfix : ''}`;
  
      const { id, barcode } = req.body;
  
      if (!id || !barcode) {
        res.status(400).json({ message: 'Missing book ID or barcode' });
        return;
      }
  
      const bookRef = admin.firestore().collection(collectionName).doc(id);
      const bookDoc = await bookRef.get();
  
      if (!bookDoc.exists) {
        res.status(404).json({ message: 'Book not found' });
        return;
      }
  
      await bookRef.update({
        barcode,
        updatedAt: Timestamp.now(),
      });
  
      res.status(200).json({ message: 'Barcode updated successfully' });
    } catch (error) {
      console.error('Error updating barcode:', error);
      res.status(500).json({ message: 'Internal server error' });
    }
  });
  