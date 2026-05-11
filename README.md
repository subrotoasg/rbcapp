# RBC Flutter Professional App

এটা আপনার React Native `rbcApps` app-এর Flutter rebuild। UI/UX professional করা হয়েছে এবং পুরো app-এ ৩টা core color system রাখা হয়েছে:

- Primary Navy: `#0B3D91`
- Accent Gold: `#F2B705`
- Soft Surface: `#F7F9FC`

## Migrated functionality

- Google login এবং existing backend token save
- Secure token storage
- Professional splash screen
- Home dashboard
- Top/bottom/banner ads
- Puja category grid
- Puja history and details
- Income details by category
- Earn list
- Spend list
- Monthly cada
- Dues screen
- Puja pronami list
- Festival list
- All posts
- My posts
- Add post with camera/gallery image upload
- Like/comment/delete post
- Profile and community pledge screen
- Firebase push token registration
- Role-based protected financial views

## First setup

```bash
flutter pub get
```

Android native files generate করতে:

```bash
flutter create . --platforms=android
```

তারপর Firebase config copy করুন:

```bash
cp android_app_config/google-services.json android/app/google-services.json
```

Package name `com.rbc15.rbc` রাখতে `android/app/build.gradle`-এ `namespace` এবং `applicationId` update করুন।

## Run

```bash
flutter run
```

## Release AAB

```bash
keytool -genkey -v -keystore android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

`android/key.properties` তৈরি করুন:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=app/upload-keystore.jks
```

`android/app/build.gradle` release signing config add করার template `scripts/release_signing_snippet.gradle` ফাইলে দেওয়া আছে।

Build:

```bash
flutter build appbundle --release
```

Output:

```txt
build/app/outputs/bundle/release/app-release.aab
```

## Config

`lib/core/config/app_config.dart` ফাইলে API base URL, Google server client id এবং ImgBB key আছে। Production release-এর আগে এগুলো verify করবেন।
