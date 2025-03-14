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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB7TvRCPWlXtqL8ORI3Be--Txnk7xcNipA',
    appId: '1:364978692305:web:ea5e084a196c2f22e365f0',
    messagingSenderId: '364978692305',
    projectId: 'appbooking-41089',
    authDomain: 'appbooking-41089.firebaseapp.com',
    storageBucket: 'appbooking-41089.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCexnkDLwLKlCLTo9SaCUQAvbBV-BXOaUI',
    appId: '1:364978692305:android:31a36da3b3195b4ce365f0',
    messagingSenderId: '364978692305',
    projectId: 'appbooking-41089',
    storageBucket: 'appbooking-41089.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBQOMf4AhVbXcwXGi_uZaj7h7lnwL2CeFk',
    appId: '1:364978692305:ios:2473462344f40ecde365f0',
    messagingSenderId: '364978692305',
    projectId: 'appbooking-41089',
    storageBucket: 'appbooking-41089.firebasestorage.app',
    iosBundleId: 'com.example.appbooking',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBQOMf4AhVbXcwXGi_uZaj7h7lnwL2CeFk',
    appId: '1:364978692305:ios:2473462344f40ecde365f0',
    messagingSenderId: '364978692305',
    projectId: 'appbooking-41089',
    storageBucket: 'appbooking-41089.firebasestorage.app',
    iosBundleId: 'com.example.appbooking',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB7TvRCPWlXtqL8ORI3Be--Txnk7xcNipA',
    appId: '1:364978692305:web:074eb8d6e4620ab8e365f0',
    messagingSenderId: '364978692305',
    projectId: 'appbooking-41089',
    authDomain: 'appbooking-41089.firebaseapp.com',
    storageBucket: 'appbooking-41089.firebasestorage.app',
  );
}
