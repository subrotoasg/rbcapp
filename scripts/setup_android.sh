#!/usr/bin/env bash
set -e
flutter create . --platforms=android
cp android_app_config/google-services.json android/app/google-services.json
printf '\nAndroid project generated. Now set package name com.rbc15.rbc in android/app/build.gradle if Flutter generated another id.\n'
