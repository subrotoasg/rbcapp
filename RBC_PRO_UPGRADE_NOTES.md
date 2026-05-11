# RBC Professional Upgrade

এই build-এ current working Flutter app-এর উপরেই professional upgrade করা হয়েছে।

## Added

- ৫ বছর login session persistence (`flutter_secure_storage`)
- Professional 3-color design palette
- Animated RBC splash screen
- Smart Services Hub
- RBC About / mission section
- বাংলা পঞ্জিকা ও সনাতন সেবা section
- Google Calendar event add support
- Google Meet / YouTube / website / sports links inside app via WebView
- Live location share via Google Maps link
- Village services section: health, education, development, religious, sports
- Better profile screen with session expiry date
- Better drawer and bottom navigation
- Notification registration improvements
- Android permissions: internet, notification, location
- API error message helper

## Important backend change

`NewServerRbc-main/src/Controller/UserAuth/UserAuthPostController.js` token expiry changed from `24h` to `5y`.

আপনার deployed backend-এ এই change deploy না করলে frontend app ৫ বছর login ধরে রাখলেও protected API token ২৪ ঘণ্টা পরে expire হতে পারে।

## Run

```bash
flutter clean && flutter pub get && flutter run
```

## Release

```bash
flutter build appbundle --release
```

Final AAB:

```txt
build/app/outputs/bundle/release/app-release.aab
```

## Play Store note

Release/upload keystore-এর SHA-1 এবং SHA-256 Firebase Console-এ add করতে হবে, তারপর নতুন `google-services.json` download করে `android/app/google-services.json` replace করতে হবে।
