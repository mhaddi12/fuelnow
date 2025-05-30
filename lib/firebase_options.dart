// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDzKOqA3jUCr1M5AcCWqp7lpUkiTqivXSw',
    appId: '1:12117966625:android:fe27d108e114d0c72e4860',
    messagingSenderId: '12117966625',
    projectId: 'simple-app-f309d',
    databaseURL: 'https://simple-app-f309d-default-rtdb.firebaseio.com',
    storageBucket: 'simple-app-f309d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDwisNIQdsUcmsYxk-3vwM0Er7PqexqomA',
    appId: '1:12117966625:ios:bf36f775138b92a02e4860',
    messagingSenderId: '12117966625',
    projectId: 'simple-app-f309d',
    databaseURL: 'https://simple-app-f309d-default-rtdb.firebaseio.com',
    storageBucket: 'simple-app-f309d.firebasestorage.app',
    androidClientId: '12117966625-2blcn9e1bseacq254kds0nv758i0vvt2.apps.googleusercontent.com',
    iosClientId: '12117966625-fu1trke68ru891o227nkosm7s8n4nbgj.apps.googleusercontent.com',
    iosBundleId: 'com.example.fuelnow',
  );
}
