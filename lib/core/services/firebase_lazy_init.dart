import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

/// Lazy Firebase initialization service
/// Only initializes Firebase when realtime features are actually needed
class FirebaseLazyInit {
  static FirebaseLazyInit? _instance;
  static FirebaseLazyInit get instance => _instance ??= FirebaseLazyInit._();

  FirebaseLazyInit._();

  bool _isInitialized = false;
  bool _isInitializing = false;

  /// Initialize Firebase if not already initialized
  /// Returns true if successful, false otherwise
  Future<bool> ensureInitialized() async {
    // Already initialized
    if (_isInitialized) {
      return true;
    }

    // Currently initializing (prevent duplicate calls)
    if (_isInitializing) {
      // Wait for ongoing initialization
      while (_isInitializing) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return _isInitialized;
    }

    _isInitializing = true;

    try {
      debugPrint('[Firebase] Lazy initializing Firebase...');

      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyA1ao20BuCfBbjROooGzn_qbO8x3XJoFHU",
          authDomain: "quanlyphuongtien-22dd4.firebaseapp.com",
          databaseURL: "https://quanlyphuongtien-22dd4-default-rtdb.firebaseio.com",
          projectId: "quanlyphuongtien-22dd4",
          storageBucket: "quanlyphuongtien-22dd4.appspot.com",
          messagingSenderId: "51589792579",
          appId: "1:51589792579:web:23c1d200f54a3dcb5ba5f6",
          measurementId: "G-MJ8V6TWTD6",
        ),
      );

      // Force initialize database instance
      FirebaseDatabase.instance;

      _isInitialized = true;
      debugPrint('[Firebase] ✓ Firebase initialized successfully');
      return true;
    } catch (e) {
      debugPrint('[Firebase] ✗ Failed to initialize Firebase: $e');
      _isInitialized = false;
      return false;
    } finally {
      _isInitializing = false;
    }
  }

  /// Check if Firebase is already initialized
  bool get isInitialized => _isInitialized;
}
