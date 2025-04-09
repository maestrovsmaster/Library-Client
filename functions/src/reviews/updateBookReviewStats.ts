import * as admin from 'firebase-admin';

async function updateBookReviewStats(bookId: string, postfix?: string) {
    const collectionName = `reviews${postfix ? '-' + postfix : ''}`;
    const reviewsSnap = await admin
      .firestore()
      .collection(collectionName)
      .where("bookId", "==", bookId)
      .get();
  
    const reviews = reviewsSnap.docs.map(doc => doc.data());
    const total = reviews.length;
  
    if (total === 0) {
      await admin.firestore().collection(`books${postfix ? '-'+postfix : ''}`).doc(bookId).update({
        averageRating: null,
        reviewsCount: 0,
      });
      return;
    }
  
    const average =
      reviews.reduce((sum, r) => sum + (r.rate ?? 0), 0) / total;
  
    await admin.firestore().collection(`books${postfix ? '-'+postfix : ''}`).doc(bookId).update({
      averageRating: parseFloat(average.toFixed(1)), // округлено до 1 знаку
      reviewsCount: total,
    });
  }

  export { updateBookReviewStats };
  