import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/common/table/table_styles.dart';

/// Helper class để áp dụng style cho toàn bộ ứng dụng
class StyleHelper {
  /// Cập nhật style cho app bar
  static AppBar materialAppBar({
    required String title,
    List<Widget>? actions,
    Widget? leading,
    PreferredSizeWidget? bottom,
    Color? backgroundColor,
  }) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      backgroundColor: backgroundColor ?? ColorValue.oceanBlue,
      foregroundColor: Colors.white,
      actions: actions,
      leading: leading,
      elevation: 0,
      centerTitle: true,
      bottom: bottom,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
    );
  }

  /// Style cho card trong ứng dụng
  static Card materialCard({
    required Widget child,
    double? elevation,
    Color? color,
    EdgeInsetsGeometry? padding,
    double borderRadius = 12.0,
  }) {
    return Card(
      elevation: elevation ?? 2,
      color: color ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  /// Style cho material button
  static ElevatedButton materialButton({
    required VoidCallback onPressed,
    required String text,
    Color? backgroundColor,
    Color? textColor,
    double? elevation,
    EdgeInsetsGeometry? padding,
    Size? minimumSize,
    double borderRadius = 8.0,
    Widget? icon,
    bool isOutlined = false,
  }) {
    if (isOutlined) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: backgroundColor ?? ColorValue.oceanBlue,
          elevation: 0,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          minimumSize: minimumSize ?? const Size(88, 36),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(color: backgroundColor ?? ColorValue.oceanBlue),
          ),
        ),
        child: icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon,
                  const SizedBox(width: 8),
                  Text(text),
                ],
              )
            : Text(text),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? ColorValue.oceanBlue,
        foregroundColor: textColor ?? Colors.white,
        elevation: elevation ?? 2,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        minimumSize: minimumSize ?? const Size(88, 36),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                const SizedBox(width: 8),
                Text(text),
              ],
            )
          : Text(text),
    );
  }

  /// Style cho text field
  static InputDecoration materialInputDecoration({
    required String labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? errorText,
    bool isDense = false,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      errorText: errorText,
      isDense: isDense,
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: ColorValue.oceanBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      floatingLabelStyle: TextStyle(color: ColorValue.oceanBlue),
    );
  }
  
  /// Decorator cho container
  static BoxDecoration materialContainerDecoration({
    Color? color,
    double borderRadius = 8.0,
    bool withShadow = true,
    Border? border,
  }) {
    return BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: BorderRadius.circular(borderRadius),
      border: border,
      boxShadow: withShadow 
          ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
    );
  }
  
  /// Style cho TabBar
  static TabBar materialTabBar({
    required List<Tab> tabs,
    Color? indicatorColor,
    Color? labelColor,
    Color? unselectedLabelColor,
  }) {
    return TabBar(
      tabs: tabs,
      indicatorColor: indicatorColor ?? ColorValue.oceanBlue,
      labelColor: labelColor ?? ColorValue.oceanBlue,
      unselectedLabelColor: unselectedLabelColor ?? Colors.grey.shade700,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
    );
  }
  
  /// Style cho Chip
  static Chip materialChip({
    required String label,
    Color? backgroundColor,
    Color? labelColor,
    VoidCallback? onDeleted,
    Widget? avatar,
  }) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: labelColor ?? ColorValue.primaryText,
          fontSize: 12,
        ),
      ),
      backgroundColor: backgroundColor ?? ColorValue.lightOceanBlue.withOpacity(0.2),
      deleteIcon: onDeleted != null ? const Icon(Icons.close, size: 16) : null,
      onDeleted: onDeleted,
      avatar: avatar,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
  
  /// Style cho Icon Button
  static IconButton materialIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
    double? size,
    String? tooltip,
  }) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      color: color ?? ColorValue.oceanBlue,
      iconSize: size ?? 24,
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.all(8),
      ),
    );
  }

  /// Style cho dropdown menu item
  static DropdownMenuItem<T> materialDropdownMenuItem<T>({
    required T value,
    required String text,
    Widget? icon,
  }) {
    return DropdownMenuItem<T>(
      value: value,
      child: Row(
        children: [
          if (icon != null) ...[
            icon,
            const SizedBox(width: 8),
          ],
          Text(text),
        ],
      ),
    );
  }
}
