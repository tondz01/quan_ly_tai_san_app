import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';

class TableActionButtons {
  /// Button View với icon và màu xanh lá
  static Widget viewButton({
    required VoidCallback onPressed,
    String tooltip = 'Xem',
    double size = 32,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ColorValue.success,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: ColorValue.success.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: size,
            height: size,
            padding: const EdgeInsets.all(6),
            child: Icon(
              Icons.visibility,
              color: Colors.white,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }

  /// Button Edit với icon và màu xanh dương
  static Widget editButton({
    required VoidCallback onPressed,
    String tooltip = 'Sửa',
    double size = 32,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ColorValue.primaryBlue,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: ColorValue.primaryBlue.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: size,
            height: size,
            padding: const EdgeInsets.all(6),
            child: Icon(
              Icons.edit,
              color: Colors.white,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }

  /// Button Delete với icon và màu đỏ
  static Widget deleteButton({
    required VoidCallback onPressed,
    String tooltip = 'Xóa',
    double size = 32,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ColorValue.error,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: ColorValue.error.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: size,
            height: size,
            padding: const EdgeInsets.all(6),
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }

  /// Button Download với icon và màu xanh dương nhạt
  static Widget downloadButton({
    required VoidCallback onPressed,
    String tooltip = 'Tải xuống',
    double size = 32,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ColorValue.primaryLightBlue,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: ColorValue.primaryLightBlue.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: size,
            height: size,
            padding: const EdgeInsets.all(6),
            child: Icon(
              Icons.download,
              color: Colors.white,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }

  /// Button Print với icon và màu cam
  static Widget printButton({
    required VoidCallback onPressed,
    String tooltip = 'In',
    double size = 32,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ColorValue.warning,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: ColorValue.warning.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: size,
            height: size,
            padding: const EdgeInsets.all(6),
            child: Icon(
              Icons.print,
              color: Colors.white,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }

  /// Button Share với icon và màu xanh lá nhạt
  static Widget shareButton({
    required VoidCallback onPressed,
    String tooltip = 'Chia sẻ',
    double size = 32,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ColorValue.success.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: ColorValue.success.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: size,
            height: size,
            padding: const EdgeInsets.all(6),
            child: Icon(
              Icons.share,
              color: Colors.white,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }

  /// Row chứa các action buttons
  static Widget actionButtonsRow({
    required List<Widget> buttons,
    double spacing = 8,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: buttons.asMap().entries.map((entry) {
        final index = entry.key;
        final button = entry.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            button,
            if (index < buttons.length - 1) SizedBox(width: spacing),
          ],
        );
      }).toList(),
    );
  }

  /// Tạo action buttons row với các action phổ biến
  static Widget commonActionButtons({
    VoidCallback? onView,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    VoidCallback? onDownload,
    VoidCallback? onPrint,
    VoidCallback? onShare,
    double buttonSize = 32,
    double spacing = 8,
  }) {
    final buttons = <Widget>[];

    if (onView != null) {
      buttons.add(viewButton(onPressed: onView, size: buttonSize));
    }
    if (onEdit != null) {
      buttons.add(editButton(onPressed: onEdit, size: buttonSize));
    }
    if (onDelete != null) {
      buttons.add(deleteButton(onPressed: onDelete, size: buttonSize));
    }
    if (onDownload != null) {
      buttons.add(downloadButton(onPressed: onDownload, size: buttonSize));
    }
    if (onPrint != null) {
      buttons.add(printButton(onPressed: onPrint, size: buttonSize));
    }
    if (onShare != null) {
      buttons.add(shareButton(onPressed: onShare, size: buttonSize));
    }

    return actionButtonsRow(buttons: buttons, spacing: spacing);
  }
} 