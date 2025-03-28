import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { Timestamp } from 'firebase-admin/firestore';

export const createReader = functions.https.onRequest(async (req, res) => {
  try {
    const { email, name, phoneNumber, phoneNumberAlt } = req.body;

    if (!email || !name || !phoneNumber) {
      res.status(400).json({ message: "Missing required fields" });
      return;
    }

    const newReader = {
      email,
      name,
      phoneNumber,
      phoneNumberAlt: phoneNumberAlt || "",
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    };

    const postfix = req.query.postfix as string | undefined;
    const collectionName = `readers${postfix ? '-' + postfix : ''}`;
    const docRef = await admin.firestore().collection(collectionName).add(newReader);

    res.status(201).json({ id: docRef.id, ...newReader });
  } catch (error) {
    console.error("Error creating reader:", error);
    res.status(500).json({ message: "Internal server error" });
  }
});
