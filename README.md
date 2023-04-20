# CCA Vijayapura

## Prerequisite
```
node & yarn,
flutter,
android sdk,
java,
firebase-cli & keychain registration,
```
## Check setup
`flutter doctor -v`

https://firebase.google.com/docs/flutter/setup?platform=android
# sign app for the google authentication
## Google
```
cd android/app/google-services.json
./gradlew signingReport
```
https://developers.google.com/android/guides/client-auth  

## FB
https://facebook.meedu.app/docs/4.x.x/android
https://console.firebase.google.com/project/crud-eb4cc/authentication/providers
https://developers.facebook.com/docs/facebook-login/android/?locale=en
https://developers.facebook.com/apps/?show_reminder=true
keytool -exportcert -alias androiddebugkey -keystore ~/.android/debug.keystore | openssl sha1 -binary | openssl base64


## install modules
`yarn`

## run dev server
`yarn start`

