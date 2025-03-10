export const convertTimestampToDate = (timestamp: FirebaseFirestore.Timestamp) => {
    return timestamp.toDate();
  };
  