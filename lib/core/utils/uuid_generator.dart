import 'dart:math';

class UUIDGenerator {
  static const _chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  static final _rnd = Random();

  /// Sinh chuỗi random với độ dài [length]
  static String _randomString(int length) {
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),
      ),
    );
  }

  /// Sinh UUID theo format custom
  /// Ví dụ: "MTS****" => "MTS4a7B"
  static String generateWithFormat(String format) {
    return format.split('').map((char) {
      if (char == '*') {
        return _randomString(1); // 1 ký tự random
      }
      return char;
    }).join();
  }

  /// Sinh UUID ngẫu nhiên (cả số và chữ) với độ dài tùy chọn
  static String generateRandom(int length) {
    return _randomString(length);
  }
}
