// File: lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyA1ao20BuCfBbjROooGzn_qbO8x3XJoFHU",
    authDomain: "quanlyphuongtien-22dd4.firebaseapp.com",
    databaseURL: "https://quanlyphuongtien-22dd4-default-rtdb.firebaseio.com",
    projectId: "quanlyphuongtien-22dd4",
    storageBucket: "quanlyphuongtien-22dd4.appspot.com",
    messagingSenderId: "51589792579",
    appId: "1:51589792579:web:23c1d200f54a3dcb5ba5f6",
    measurementId: "G-MJ8V6TWTD6",
  );
}
