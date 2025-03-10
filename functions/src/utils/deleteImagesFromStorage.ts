import * as admin from 'firebase-admin';

export const deleteImagesFromStorage = async (imageUrls: string[]): Promise<void> => {
  const storage = admin.storage();
  const bucket = storage.bucket();

  try {
    const deletePromises = imageUrls.map((url: string) => {
      // Отримуємо шлях зображення з URL
      const path = decodeURIComponent(url.split('/o/')[1].split('?')[0]); // Розбираємо шлях зображення
      const fileRef = bucket.file(path);

      return fileRef.delete();
    });

    await Promise.all(deletePromises);
    console.log('All images deleted successfully');
  } catch (error) {
    console.error('Error deleting images from Storage:', error);
  }
};

