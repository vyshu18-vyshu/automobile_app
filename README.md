# 🚗 Automobile App

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)](https://firebase.google.com)
[![Platform](https://img.shields.io/badge/Platform-Android%20|%20iOS%20|%20Web%20|%20Windows-4CAF50)](https://github.com/parvathi-s25/automobile_app)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A premium Flutter-based automobile browsing and management application with Firebase integration for authentication and cloud storage.

## 📱 Live Demo

**GitHub Repository**: [https://github.com/parvathi-s25/automobile_app](https://github.com/parvathi-s25/automobile_app)

## ✨ Features

### 🔐 Authentication & User Management
- **Firebase Authentication** - Secure email/password login and signup
- **Firestore Integration** - Automatic cloud storage of user profiles
- **User Profiles** - Display name, email, timestamps (created, last sign-in)
- **Guest Mode** - Browse without account creation
- **Development Mode** - Flexible authentication for testing

### 🚙 Car Browsing & Discovery
- **Extensive Car Database** - Browse multiple brands and models
- **Advanced Search** - Find cars by name, brand, category
- **Detailed Car Info** - Specs, pricing, images, descriptions
- **Brand Categories** - Organized by manufacturer (Luxury, Sports, SUV, etc.)
- **Favorites System** - Save and manage favorite cars
- **Recently Viewed** - Track browsing history

### 🔧 Tools & Utilities
- **EMI Calculator** - Calculate loan payments with customizable rates
- **Car Comparison** - Compare specs side-by-side
- **Share Feature** - Share car details with others
- **Biometric Authentication** - Fingerprint/face unlock support

### 🎨 Premium Design
- **Glassmorphic UI** - Modern, translucent design elements
- **Dark Theme** - Eye-friendly dark mode interface
- **Skeleton Loaders** - Smooth loading states
- **Staggered Grid Layout** - Beautiful card-based browsing
- **Smooth Animations** - Polished micro-interactions

### 📊 Analytics & Tracking
- **Firebase Analytics** - User behavior insights
- **Event Tracking** - Monitor user interactions
- **Usage Metrics** - Understand app performance

## 🛠️ Tech Stack

- **Framework**: Flutter 3.0+
- **Language**: Dart
- **Backend**: Firebase
  - Firebase Authentication
  - Cloud Firestore
  - Firebase Analytics
  - Firebase Storage
- **State Management**: Provider pattern
- **Local Storage**: SharedPreferences
- **HTTP Client**: http package
- **UI Components**: Custom glassmorphic widgets

## 📂 Project Structure

```
lib/
├── features/          # Feature modules
│   ├── auth/         # Login, signup screens
│   ├── cars/         # Car browsing, details, comparison
│   ├── favorites/    # Favorites management
│   ├── profile/      # User profile & settings
│   ├── settings/     # App settings
│   ├── splash/       # Splash screen
│   └── tools/        # Utilities (EMI calculator)
├── models/           # Data models
│   ├── car_model.dart
│   └── user_model.dart
├── services/         # Business logic
│   ├── analytics_service.dart
│   ├── api_service.dart
│   ├── car_data.dart
│   ├── firebase_auth_service.dart
│   ├── search_service.dart
│   ├── share_service.dart
│   ├── storage_service.dart
│   └── user_service.dart
├── utils/            # Constants, helpers
├── widgets/          # Reusable UI components
└── main.dart         # App entry point
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK
- Firebase project with Firestore and Authentication enabled
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/parvathi-s25/automobile_app.git
   cd automobile_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Add your `google-services.json` (Android) to `android/app/`
   - Add your `GoogleService-Info.plist` (iOS) to `ios/Runner/`
   - Update Firebase configuration files

4. **Run the app**
   ```bash
   # For Windows
   flutter run -d windows
   
   # For Android
   flutter run -d android
   
   # For Web
   flutter run -d chrome
   ```

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🔑 Firebase Setup

### Firestore Collections

The app uses the following Firestore structure:

```
users/
  {userId}/
    - userId: string
    - email: string
    - displayName: string
    - createdAt: timestamp
    - lastSignIn: timestamp

cars/ (optional - for dynamic data)
  {carId}/
    - brand: string
    - model: string
    - price: number
    - imageUrl: string
    - specs: map
    ...
```

### Security Rules

Recommended Firestore security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own profile
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // All authenticated users can read car data
    match /cars/{carId} {
      allow read: if request.auth != null;
    }
  }
}
```

## 📸 Screenshots

<!-- Add screenshots here -->
*Screenshots coming soon*

## 🎯 Recent Updates

### Latest Commit (18f6e36)
**Firebase Firestore Integration for User Management**

- ✅ Created `UserModel` with Firestore serialization
- ✅ Added Firestore methods to `UserService`:
  - `createUserInFirestore()` - Saves user profile on signup
  - `getUserFromFirestore()` - Fetches user data on login
  - `updateLastSignIn()` - Tracks user activity
- ✅ Updated signup screen to automatically save user data to Firestore
- ✅ Updated login screen to fetch user profile and update last sign-in
- ✅ Maintains local SharedPreferences as fallback for offline support

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Parvathi**
- GitHub: [@parvathi-s25](https://github.com/parvathi-s25)
- Repository: [automobile_app](https://github.com/parvathi-s25/automobile_app)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- All contributors and supporters

---

**⭐ Star this repository if you find it helpful!**

**🔗 Project Link**: [https://github.com/parvathi-s25/automobile_app](https://github.com/parvathi-s25/automobile_app)
## Maintained by Vaishnavi