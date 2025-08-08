import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  //Item dropdown lý do tăng
  static List<DropdownMenuItem<LyDoTang>>  itemsLyDoTang = [
    for (var element in listLyDoTang)
      DropdownMenuItem<LyDoTang>(
        value: element,
        child: SGText(text: element.name, size: 14),
      ),
  ];
  static LyDoTang getLyDoTang(int id) {
    return listLyDoTang.firstWhere((element) => element.id == id);
  }

  //Item dropdown hien trang
  static List<DropdownMenuItem<HienTrang>> get itemsHienTrang => [
    for (var element in listHienTrang)
      DropdownMenuItem<HienTrang>(
        value: element,
        child: SGText(text: element.name, size: 14),
      ),
  ];

  static HienTrang getHienTrang(int id) {
    return listHienTrang.firstWhere((element) => element.id == id);
  }

  //Item dropdown country
  static List<DropdownMenuItem<Country>> get itemsCountry => [
    for (var element in listCountry)
      DropdownMenuItem<Country>(
        value: element,
        child: SGText(text: element.name, size: 14),
      ),
  ];

  static Country? findCountryByName(String name) {
    
    return listCountry.firstWhereOrNull(
      (country) => country.name.toLowerCase() == name.toLowerCase(),
    );
  }
}
