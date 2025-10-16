import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:se_gay_components/common/sg_text.dart';

abstract class ConfigViewAT {
  static String getStatus(int status) {
    switch (status) {
      case 0:
        return 'Nháp';
      case 1:
        return 'Duyệt';
      case 2:
        return 'Hủy';
      case 3:
        return 'Hoàn thành';
      default:
        return '';
    }
  }

  static Widget showStatus(int status) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 48.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: getColorStatus(status),
          borderRadius: BorderRadius.circular(4),
        ),
        child: SGText(
          text: getStatus(status),
          size: 12,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
  static Widget showShareStatus(bool isShare, bool isMyCreated) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 48.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: isShare ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(4),
        ),
        child: SGText(
          text: isShare ? isMyCreated ? 'Đã gửi': "Được gửi" : 'Chưa gửi',
          size: 12,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  static Color getColorStatus(int status) {
    switch (status) {
      case 0:
        return ColorValue.silverGray;
      case 1:
        return ColorValue.lightAmber;
      case 2:
        return ColorValue.mediumGreen;
      case 3:
        return ColorValue.lightBlue;
      case 4:
        return ColorValue.cyan;
      case 5:
        return ColorValue.brightRed;
      case 6:
        return ColorValue.coral;
      case 7:
        return ColorValue.forestGreen;
      default:
        return ColorValue.paleRose;
    }
  }

  static String convertStringToIso(String dateString) {
    // Giả sử dateString đang ở dạng "dd/MM/yyyy"
    final parts = dateString.split('/');
    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);

    final date = DateTime(year, month, day);
    return DateTime(
      date.year,
      date.month,
      date.day,
    ).toIso8601String().split('.').first;
  }
}
