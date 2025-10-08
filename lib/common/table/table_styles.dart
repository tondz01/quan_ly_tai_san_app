// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';

/// Class để cung cấp style thống nhất cho tất cả các bảng trong ứng dụng
class TableStyles {
  /// Style cho SgTable thông thường với Material Design
  static Map<String, dynamic> materialTableStyle() {
    return {
      'headerBackgroundColor': ColorValue.primaryBlue,
      'headerTextColor': Colors.white,
      'oddRowBackgroundColor': Colors.white,
      'evenRowBackgroundColor': ColorValue.neutral50,
      'selectedRowColor': ColorValue.primaryLightBlue.withOpacity(0.2),
      'gridLineColor': ColorValue.neutral200,
      'rowHeight': 56.0,
      'gridLineWidth': 1.0,
      'showVerticalLines': true,
      'showHorizontalLines': true,
      'borderRadius': 12.0,
      'elevation': 4.0,
      'headerTextStyle': const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Colors.white,
        letterSpacing: 0.5,
      ),
      'cellTextStyle': TextStyle(
        fontSize: 13,
        color: ColorValue.neutral800,
        fontWeight: FontWeight.w500,
      ),
      'cellPadding': const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      'rowHoverColor': ColorValue.primaryLightBlue.withOpacity(0.1),
      'actionViewColor': ColorValue.success,
      'actionEditColor': ColorValue.primaryBlue,
      'actionDeleteColor': ColorValue.error,
      'actionColumnWidth': 160.0,
      'actionColumnTitle': 'Thao tác',
    };
  }

  /// Style cho SgEditableTable với Material Design
  static Map<String, dynamic> materialEditableTableStyle() {
    final baseStyle = materialTableStyle();
    
    return {
      ...baseStyle,
      'actionButtonColor': ColorValue.primaryBlue,
      'actionIconColor': Colors.white,
      'editIconColor': ColorValue.accentCyan,
      'deleteIconColor': ColorValue.error,
      'addRowBackgroundColor': ColorValue.neutral50,
      'addRowTextColor': ColorValue.primaryBlue,
      'addRowIcon': Icons.add_circle_outline,
      'inputBorderColor': ColorValue.primaryBlue,
      'inputFillColor': Colors.white,
      'inputTextStyle': TextStyle(
        fontSize: 13,
        color: ColorValue.neutral800,
        fontWeight: FontWeight.w500,
      ),
      'addRowButtonStyle': ElevatedButton.styleFrom(
        backgroundColor: ColorValue.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    };
  }
  
  /// Tạo BoxDecoration cho container chứa bảng với Material Design
  static BoxDecoration tableContainerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.0),
      boxShadow: [
        BoxShadow(
          color: ColorValue.neutral300.withOpacity(0.3),
          spreadRadius: 0,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: ColorValue.neutral200.withOpacity(0.2),
          spreadRadius: 0,
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ],
    );
  }
  
  /// Style cho header của bảng với Material Design
  static TextStyle headerTextStyle() {
    return const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 14,
      color: Colors.white,
      letterSpacing: 0.5,
    );
  }
  
  /// Style cho text trong cell của bảng với Material Design
  static TextStyle cellTextStyle() {
    return TextStyle(
      fontSize: 13,
      color: ColorValue.neutral800,
      fontWeight: FontWeight.w500,
    );
  }
  
  /// Style cho pagination controls với Material Design
  static Map<String, dynamic> paginationStyle() {
    return {
      'activeColor': ColorValue.primaryBlue,
      'inactiveColor': ColorValue.neutral500,
      'backgroundColor': Colors.white,
      'textStyle': TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: ColorValue.neutral800,
      ),
      'iconSize': 20.0,
      'spacing': 8.0,
      'buttonPadding': const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      'buttonStyle': ElevatedButton.styleFrom(
        backgroundColor: ColorValue.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    };
  }
  
  /// Style cho các button trong bảng với Material Design
  static ButtonStyle tableButtonStyle({Color? backgroundColor, Color? foregroundColor}) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? ColorValue.primaryBlue,
      foregroundColor: foregroundColor ?? Colors.white,
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      minimumSize: const Size(32, 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      textStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }
  
  /// Style cho các icon button trong bảng với Material Design
  static ButtonStyle tableIconButtonStyle({Color? backgroundColor, Color? foregroundColor}) {
    return IconButton.styleFrom(
      backgroundColor: backgroundColor ?? ColorValue.neutral100,
      foregroundColor: foregroundColor ?? ColorValue.primaryBlue,
      elevation: 1,
      padding: const EdgeInsets.all(8),
      minimumSize: const Size(40, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  /// Style cho action buttons trong bảng
  static Map<String, ButtonStyle> actionButtonStyles() {
    return {
      'view': ElevatedButton.styleFrom(
        backgroundColor: ColorValue.success,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: const Size(32, 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        textStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
      'edit': ElevatedButton.styleFrom(
        backgroundColor: ColorValue.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: const Size(32, 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        textStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
      'delete': ElevatedButton.styleFrom(
        backgroundColor: ColorValue.error,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: const Size(32, 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        textStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    };
  }

  /// Style cho status badges trong bảng
  static Map<String, Color> statusColors() {
    return {
      'success': ColorValue.success,
      'warning': ColorValue.warning,
      'error': ColorValue.error,
      'info': ColorValue.info,
      'pending': ColorValue.neutral500,
    };
  }

  /// Tạo decoration cho row hover effect
  static BoxDecoration rowHoverDecoration() {
    return BoxDecoration(
      color: ColorValue.primaryLightBlue.withOpacity(0.1),
      borderRadius: BorderRadius.circular(4),
    );
  }

  /// Tạo decoration cho selected row
  static BoxDecoration selectedRowDecoration() {
    return BoxDecoration(
      color: ColorValue.primaryLightBlue.withOpacity(0.2),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(
        color: ColorValue.primaryBlue.withOpacity(0.3),
        width: 1,
      ),
    );
  }

  /// Tạo decoration cho checked row
  static BoxDecoration checkedRowDecoration() {
    return BoxDecoration(
      color: ColorValue.primaryLightBlue.withOpacity(0.1),
      borderRadius: BorderRadius.circular(4),
    );
  }
}
