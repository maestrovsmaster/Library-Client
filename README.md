# Library-Client

**Library-Client** is a cross-platform mobile application connected to a cloud server, designed for library catalog management and presenting books to users.



<p align="left">
  <img src="https://github.com/user-attachments/assets/64ed23b7-6bbc-435e-a54a-a89b4acf60d5" alt="pf111" height="300">
  <img src="https://github.com/user-attachments/assets/487bbebc-999a-403b-8336-06a1f171c9f1" alt="pf111" height="300">
  <img src="https://github.com/user-attachments/assets/4e61e829-683c-4dd9-8ec1-9e3187224ce4" alt="img112" height="300">

</p>


## Features

### Common
- User authentication (Google Sign-In).

### Librarian
- Manage the book database: add, edit, and delete books.
- Generate book covers and barcodes using the device's camera.
- Issue and return books by title or barcode scan.
- View a list of active loans.
- Manage the list of registered readers.

### Reader
- Browse the book catalog.
- Search and filter books by genre.
- View book details, including availability status.
- Subscribe to notifications when a reserved book becomes available.
- Add books to the personal reading plan.
- View reserved and borrowed books.
- Receive reminders for book returns.

---

## Architecture

### Frontend
- **Framework:** Flutter (Android/iOS)
- **State Management:** BLoC
- **Dependency Injection:** getIt
- **Routing:** go_router
- **Environment Variables:** flutter_dotenv
- **Authentication:** google_sign_in
- **Push Notifications:** firebase_messaging
- **Barcode Scanning:** mobile_scanner
- **Image Caching:** cached_network_image

### Backend
- **Serverless Functions:** Firebase Functions (TypeScript, Node.js)
- **Packages:**
  - cors
  - firebase-admin
  - firebase-functions
  - jwt-decode
- **Database:** Firestore

---

## Setup Instructions

### Prerequisites

- Flutter SDK
- Node.js (for Firebase Functions)
- Firebase CLI (`npm install -g firebase-tools`)
- Android Studio / Xcode

---

## Environment Variables (.env)

Create a `.env` file at the project root with the following structure:

```env
# Base URLs for Cloud Functions
BASE_URL=https://<your-cloud-function-url>.cloudfunctions.net
#BASE_URL=http://<your-local-server-ip>:5001/library-541e4/us-central1

# Collection Postfix (for development environments, e.g., "-dev")
POSTFIX=

# Alternative Firestore Collection Postfix (optional for dev)
BOOX_COLLECTION_POSTFIX=

# Use Firestore Emulator locally (true/false)
USE_FIRESTORE_EMULATOR=

# Firebase Web Configuration
FIREBASE_API_KEY_WEB=...
FIREBASE_APP_ID_WEB=...
FIREBASE_MESSAGING_SENDER_ID=...
FIREBASE_PROJECT_ID=...
FIREBASE_AUTH_DOMAIN=...
FIREBASE_DATABASE_URL=... # URL of your Realtime Database (even if not used, required for Firebase config)
FIREBASE_STORAGE_BUCKET=... # Firebase Storage bucket name (used for uploading book covers)
FIREBASE_MEASUREMENT_ID=...

# Firebase Android Configuration
FIREBASE_API_KEY_ANDROID=...
FIREBASE_APP_ID_ANDROID=...

# Firebase iOS Configuration
FIREBASE_API_KEY_IOS=...
FIREBASE_APP_ID_IOS=...
FIREBASE_IOS_CLIENT_ID=...
FIREBASE_IOS_BUNDLE_ID=...

```

## Firebase Project Configuration

Make sure your Firebase project includes the following:

- **Firestore Database** (in Native mode)
- **Firebase Authentication** (enable Google Sign-In)
- **Firebase Cloud Messaging** (for push notifications)
- **Firebase Storage** (for storing book cover images)

You also need a valid `firebase.json` configuration file at the root of your project:

```json
{
  "functions": {
    "source": "functions"
  },
  "emulators": {
    "functions": {
      "port": 5001
    },
    "firestore": {
      "port": 8080
    },
    "auth": {
      "port": 9099
    }
  }
}

```

## Running the Project

### 1. Mobile App (Flutter)

Install dependencies:

```bash
flutter pub get

flutter run

```

## Deployment

### Mobile App

#### Android APK

```bash
flutter build apk

flutter build appbundle

```

#### Android APK

```bash

flutter build ios

```

Backend (Firebase Functions)
Navigate to the functions directory and deploy:

```bash

cd functions
firebase deploy --only functions

```


