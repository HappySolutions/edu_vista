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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC0bBCkoiAoj1Zd_GkUF2dFeLLXdsgeDbY',
    appId: '1:122796254332:web:e77adf9960f468cd2215f9',
    messagingSenderId: '122796254332',
    projectId: 'edu-vista-83dc6',
    authDomain: 'edu-vista-83dc6.firebaseapp.com',
    storageBucket: 'edu-vista-83dc6.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyANyhV_Az0ftOpRwgBG3hACNQgRFfum1ko',
    appId: '1:122796254332:android:4755447b644fbde32215f9',
    messagingSenderId: '122796254332',
    projectId: 'edu-vista-83dc6',
    storageBucket: 'edu-vista-83dc6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCVd2r1b-3g8qFMTXTOPK9-nQPAFELInp4',
    appId: '1:122796254332:ios:9d304750cd2d4d3e2215f9',
    messagingSenderId: '122796254332',
    projectId: 'edu-vista-83dc6',
    storageBucket: 'edu-vista-83dc6.appspot.com',
    iosBundleId: 'com.example.eduVista',
  );
}
