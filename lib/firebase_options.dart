// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return macos;
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
    apiKey: 'AIzaSyAiFRxlL5Nnq-Kl6FFvknTXe3w3P4UI7ys',
    appId: '1:719830039728:android:64e1a92bb13346b1c00f75',
    messagingSenderId: '719830039728',
    projectId: 'fyp-fb-fbdb4',
    storageBucket: 'fyp-fb-fbdb4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB739fFksi2LS4GOJy6D6wghEqBZaMkc6c',
    appId: '1:719830039728:ios:aaf3876bfcd0438ec00f75',
    messagingSenderId: '719830039728',
    projectId: 'fyp-fb-fbdb4',
    storageBucket: 'fyp-fb-fbdb4.appspot.com',
    iosBundleId: 'com.example.salonbookingapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB739fFksi2LS4GOJy6D6wghEqBZaMkc6c',
    appId: '1:719830039728:ios:132eddec8eb6b296c00f75',
    messagingSenderId: '719830039728',
    projectId: 'fyp-fb-fbdb4',
    storageBucket: 'fyp-fb-fbdb4.appspot.com',
    iosBundleId: 'com.example.salonbookingapp.RunnerTests',
  );
}
