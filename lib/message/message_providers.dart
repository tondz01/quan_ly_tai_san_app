import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'message_service_realtime.dart';

/// Service provider (singleton)
final messageServiceProvider = Provider<MessageServiceRealtime>((ref) {
  return MessageServiceRealtime();
});


/// Notifier lưu JSON mới nhất (1 listener duy nhất toàn app)
class LatestJsonNotifier extends Notifier<Map<String, dynamic>?> {
  @override
  Map<String, dynamic>? build() {
    final service = ref.read(messageServiceProvider);

    service.listenLatestJson().listen((jsonMsg) {
      state = jsonMsg; // cập nhật JSON mới nhất
    });

    return null; // bắt đầu chưa có message nào
  }
}

final messageLatestJsonProvider =
    NotifierProvider<LatestJsonNotifier, Map<String, dynamic>?>(
        LatestJsonNotifier.new);
