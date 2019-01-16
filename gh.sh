cp ios/Runner/Info.plist ios/Runner/Info.plist.xml
cp ios/Runner/GoogleService-Info.plist ios/Runner/GoogleService-Info.plist.xml
cloc lib pubspec.yaml functions/functions/index.js data/fun.js tsfunctions/functions/src ios/Runner/GoogleService-Info.plist.xml ios/Runner/Info.plist.xml android/build.gradle android/gradle.properties android/settings.gradle android/app/google-services.json android/app/build.gradle android/app/src/main/AndroidManifest.xml --ignored=cloc.ignore
rm ios/Runner/*.plist.xml
