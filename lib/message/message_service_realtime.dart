import 'package:firebase_database/firebase_database.dart';

class MessageServiceRealtime {
  final DatabaseReference messagesRef =
      FirebaseDatabase.instance.ref("quan_ly_ts/messages");

  /// Push JSON vào realtime database
  Future<void> pushJsonMessage({
    required int typeFunc,
    required int typeAction,
    required String idNeedToDo,
  }) async {
    await messagesRef.push().set({
      "type_func": typeFunc,
      "type_action": typeAction,
      "id_need_to_do": idNeedToDo,
      "time": ServerValue.timestamp,
    });
  }

  /// Lắng nghe message JSON mới nhất
  Stream<Map<String, dynamic>> listenLatestJson() {
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
