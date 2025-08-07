import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:intl/intl.dart';

abstract class AppUtility {
  static String formatDateDdMmYyyy(DateTime date) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String day = twoDigits(date.day);
    String month = twoDigits(date.month);
    String year = date.year.toString();
    return '$day/$month/$year';
  }

  static String formatDateTimeVN(String isoDate) {
    final dateUtc = DateTime.parse(isoDate);
    final dateVN = dateUtc.toLocal(); // hoặc: dateUtc.add(Duration(hours: 7));
    final formatter = DateFormat('dd/MM/yyyy HH:mm', 'vi_VN');
    return formatter.format(dateVN);
  }

  // SEARCH
  static bool fuzzySearch(String text, String searchTerm) {
    if (searchTerm.isEmpty) return true;

    List<String> searchWords =
        searchTerm.split(' ').where((word) => word.isNotEmpty).toList();

    for (String word in searchWords) {
      if (!text.contains(word)) {
        return false;
      }
    }
    return true;
  }

  static List<DropdownMenuItem<String>> phuongPhapKhauHaos = [
    const DropdownMenuItem(
      value: 'Đường thẳng',
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
}
