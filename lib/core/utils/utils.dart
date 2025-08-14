import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/utils/model_country.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:intl/intl.dart';

class LyDoTang {
  final int id;
  final String name;

  LyDoTang({required this.id, required this.name});
}

class HienTrang {
  final int id;
  final String name;

  HienTrang({required this.id, required this.name});
}

abstract class AppUtility {
  static List<LyDoTang> get listLyDoTang => [
    LyDoTang(id: 1, name: 'Dự án'),
    LyDoTang(id: 2, name: 'Tăng xây dựng'),
    LyDoTang(id: 3, name: 'Tăng kế hoạch'),
  ];

  static List<HienTrang> get listHienTrang => [
    HienTrang(id: 1, name: 'Đang sử dụng'),
    HienTrang(id: 2, name: 'Chờ thanh lý'),
    HienTrang(id: 3, name: 'Không sử dụng'),
    HienTrang(id: 4, name: 'Hỏng'),
  ];

  static List<Country> get listCountry => countries;

  static String formatDateDdMmYyyy(DateTime date) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String day = twoDigits(date.day);
    String month = twoDigits(date.month);
    String year = date.year.toString();
    return '$day/$month/$year';
  }

  // SEARCH
  static bool fuzzySearch(String text, String searchTerm) {
    if (searchTerm.isEmpty) return true;

    List<String> searchWords = searchTerm.split(' ').where((word) => word.isNotEmpty).toList();

    for (String word in searchWords) {
      if (!text.contains(word)) {
        return false;
      }
    }
    return true;
  }

  static List<DropdownMenuItem<String>> phuongPhapKhauHaos = [
    const DropdownMenuItem(
      value: '1',
      child: SGText(text: 'Đường thẳng', size: 14),
    ),
  ];

  static String formatCurrencyNumber(String input) {
    try {
      final number = int.parse(input.replaceAll('.', ''));
      final formatter = NumberFormat('#,###', 'vi_VN');
      return formatter.format(number).replaceAll(',', '.');
    } catch (_) {
      return input;
    }
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green, duration: Duration(seconds: 2)));
  }

  static DateTime? parseDate(String? input) {
    if (input == null || input.isEmpty) return null;
    final parsed = DateTime.tryParse(input);
    if (parsed != null) return parsed;
    try {
      final parts = input.split('/');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);
        if (day != null && month != null && year != null) {
          return DateTime(year, month, day);
        }
      }
    } catch (_) {}
    return null;
  }

  static DateTime parseDateTimeOrNow(String? input) {
    if (input == null || input.trim().isEmpty) return DateTime.now();
    try {
      return DateFormat('dd/MM/yyyy HH:mm').parse(input);
    } catch (_) {
      return DateTime.now();
    }
  }

  static double parseCurrency(String input) {
    if (input.isEmpty) return 0.0;
    String sanitized = input.trim();
    sanitized = sanitized.replaceAll('.', '');
    sanitized = sanitized.replaceAll(',', '.');
    return double.tryParse(sanitized) ?? 0.0;
  }

  static DateTime? parseFlexibleDateTime(String input) {
    if (input.isEmpty) return null;
    try {
      return DateTime.parse(input);
    } catch (_) {}
    final patterns = [
      'dd/MM/yyyy HH:mm:ss',
      'dd/MM/yyyy HH:mm',
      'dd/MM/yyyy',
      'yyyy-MM-dd HH:mm:ss',
      'yyyy-MM-dd',
    ];
    for (final p in patterns) {
      try {
        return DateFormat(p).parseStrict(input);
      } catch (_) {}
    }
    return null;
  }
}
