import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBA7q_iMqBrVAaF0BbFQLA_z3K2TcNePu4',
    appId: '1:1041476986440:web:592c423c00c038a2dcda7d',
    messagingSenderId: '1041476986440',
    projectId: 'ip-projet-db',
    authDomain: 'ip-projet-db.firebaseapp.com',
    storageBucket: 'ip-projet-db.firebasestorage.app',
    measurementId: 'G-T14E6379J5',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBA7q_iMqBrVAaF0BbFQLA_z3K2TcNePu4',
    appId: '1:1041476986440:web:8ae7679a7a4bfc36dcda7d',
    messagingSenderId: '1041476986440',
    projectId: 'ip-projet-db',
    authDomain: 'ip-projet-db.firebaseapp.com',
    storageBucket: 'ip-projet-db.firebasestorage.app',
    measurementId: 'G-84387YZ3GM',
  );
}
