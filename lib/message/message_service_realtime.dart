import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class MessageServiceRealtime {
  final DatabaseReference messagesRef =
      FirebaseDatabase.instance.ref("quan_ly_ts/messages");

  /// Check if Firebase Realtime Database is supported on current platform
  bool get isSupported {
    // Firebase Realtime Database is NOT supported on Windows/Linux desktop
    return kIsWeb || defaultTargetPlatform == TargetPlatform.iOS || 
           defaultTargetPlatform == TargetPlatform.android ||
           defaultTargetPlatform == TargetPlatform.macOS;
  }

  /// Push JSON vào realtime database
  Future<void> pushJsonMessage({
    required int typeFunc,
    required int typeAction,
    required String idNeedToDo,
  }) async {
    if (!isSupported) {
      debugPrint('⚠️ Firebase Realtime Database không hỗ trợ trên platform này');
      return;
    }
    
    try {
      await messagesRef.push().set({
        "type_func": typeFunc,
        "type_action": typeAction,
        "id_need_to_do": idNeedToDo,
        "time": ServerValue.timestamp,
      });
    } catch (e) {
      debugPrint('❌ Lỗi push message Firebase: $e');
    }
  }

  /// Lắng nghe message JSON mới nhất
  Stream<Map<String, dynamic>> listenLatestJson() {
    if (!isSupported) {
      debugPrint('⚠️ Firebase Realtime Database không hỗ trợ trên platform này');
      return Stream.value({}); // Return empty stream on unsupported platforms
    }
    
    return messagesRef.onChildAdded.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) return {};

      return {
        "type_func": data["type_func"] ?? 0,
        "time": data["time"] ?? 0,
        "type_action": data["type_action"] ?? 0,
        "id_need_to_do": data["id_need_to_do"] ?? "",
      };
    });
  }
}
