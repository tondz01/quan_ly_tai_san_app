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

  /// Sinh ID theo thời gian: PREFIX-YYYY.M.D.HH.mm.ss.SSS
  /// - [prefix] mặc định là "SCT"
  /// - Tháng/ngày không padding (M, D) theo yêu cầu ví dụ
  /// - Giờ/phút/giây padding 2 chữ số, milli giây 3 chữ số
  static String generateTimestampId({String prefix = 'SCT'}) {
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    String three(int n) => n.toString().padLeft(3, '0');

    final year = now.year; // YYYY
    final month = now.month; // M
    final day = now.day; // D
    final hour = two(now.hour); // HH
    final minute = two(now.minute); // mm
    final second = two(now.second); // ss
    final millisecond = three(now.millisecond); // SSS

    return '$prefix-$year.$month.$day.$hour.$minute.$second.$millisecond';
  }
}
