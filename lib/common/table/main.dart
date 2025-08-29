import 'package:se_gay_components/core/utils/sg_log.dart';

void main() {
  final items = [
    Item(
      1,
      DateTime.parse("2025-08-20"),
      DateTime.parse("2025-08-22"),
      DateTime.parse("2025-08-30"),
    ),
    Item(
      2,
      DateTime.parse("2025-08-25"),
      DateTime.parse("2025-08-27"),
      DateTime.parse("2025-09-01"),
    ),
    Item(
      3,
      DateTime.parse("2025-08-28"),
      DateTime.parse("2025-08-29"),
      DateTime.parse("2025-09-05"),
    ),
  ];

  DateTime start = DateTime.parse("2025-08-25");
  DateTime end = DateTime.parse("2025-08-29");

  // Lọc chỉ theo ngày tạo
  final byCreated = filterByMultipleFields<Item>(
    data: items,
    getters: [(i) => i.createdAt],
    start: start,
    end: end,
  );
  SGLog.debug(
    "TEST",
    "Theo ngày tạo: ${byCreated.map((e) => e.id).toList()}",
  ); // [2, 3]

  // Lọc theo cả ngày tạo và ngày cập nhật
  final byCreatedOrUpdated = filterByMultipleFields<Item>(
    data: items,
    getters: [(i) => i.createdAt, (i) => i.updatedAt],
    start: start,
    end: end,
  );
  
  SGLog.debug(
    "TEST",
    "Theo ngày tạo hoặc ngày cập nhật: ${byCreatedOrUpdated.map((e) => e.id).toList()}",
  ); // [2, 3]
}

class Item {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime endAt;

  Item(this.id, this.createdAt, this.updatedAt, this.endAt);
}

List<T> filterByMultipleFields<T>({
  required List<T> data,
  required List<DateTime Function(T)> getters,
  required DateTime start,
  required DateTime end,
  bool inclusive = true,
}) {
  return data.where((item) {
    final times = getters.map((g) => g(item));
    return times.any((createdAt) {
      if (inclusive) {
        return (createdAt.isAfter(start) ||
                createdAt.isAtSameMomentAs(start)) &&
            (createdAt.isBefore(end) || createdAt.isAtSameMomentAs(end));
      } else {
        return createdAt.isAfter(start) && createdAt.isBefore(end);
      }
    });
  }).toList();
}
