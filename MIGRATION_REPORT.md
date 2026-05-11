# Migration Report: React Native to Flutter

## Source inspected
- Expo Router based React Native app
- Backend: `https://rbc-server.vercel.app`
- Existing auth endpoint: `/api/auth/create`
- Package name: `com.rbc15.rbc`

## Flutter architecture
- `Provider` for auth state
- `Dio` for API requests
- `flutter_secure_storage` for secure token storage
- `google_sign_in` for Google login
- `firebase_messaging` for notification token registration
- `image_picker` and ImgBB upload for post images
- Feature-based folder structure

## Three-color design system
Only the following core colors are used across app UI:

```dart
primary = Color(0xFF0B3D91)
accent = Color(0xFFF2B705)
surface = Color(0xFFF7F9FC)
```

Opacity variants are used for depth, borders and subtle states.

## Migrated screens
- Sign in
- Splash
- Home dashboard
- Earn list
- Spend list
- Month cada
- Dues amount
- Puja pronami
- Puja history
- Puja details
- Festival list
- Posts
- User posts
- Add post
- Profile
- Drawer navigation

## API mapping
- `GET /api/v1/banners`
- `GET /api/v1/top-banners`
- `GET /api/v1/bottom-banners`
- `GET /api/v1/app-posts`
- `GET /api/v1/app-posts/user/posts`
- `POST /api/v1/app-posts`
- `DELETE /api/v1/app-posts/:id`
- `POST /api/v1/app-comment/create-comment`
- `POST /api/v1/app-comment/create-reaction`
- `GET /api/v1/earns?search=`
- `GET /api/v1/spends?search=`
- `GET /api/month/cada/`
- `GET /api/month/cada/admin`
- `GET /due/details`
- `GET /cada/details`
- `GET /title/heading`
- `GET /puja/parbon`
- `GET /events`
- `POST /api/v1/notification`

## Native Android setup
Run:

```bash
flutter create . --platforms=android
cp android_app_config/google-services.json android/app/google-services.json
```

Then set package/applicationId to:

```txt
com.rbc15.rbc
```

Build AAB:

```bash
flutter build appbundle --release
```
