import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';

/// Class cung cấp các icon được sử dụng trong toàn bộ ứng dụng
class AppIcons {
  // Navigation and app bar icons
  static Icon menu({Color? color, double? size}) => Icon(
    Icons.menu_rounded,
    color: color ?? Colors.white,
    size: size ?? 24,
  );
  
  static Icon back({Color? color, double? size}) => Icon(
    Icons.arrow_back_rounded,
    color: color ?? Colors.white,
    size: size ?? 24,
  );
  
  static Icon home({Color? color, double? size}) => Icon(
    Icons.home_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );

  // Action icons
  static Icon add({Color? color, double? size}) => Icon(
    Icons.add_circle_outline_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  static Icon edit({Color? color, double? size}) => Icon(
    Icons.edit_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  static Icon delete({Color? color, double? size}) => Icon(
    Icons.delete_forever_rounded,
    color: color ?? ColorValue.brightRed,
    size: size ?? 24,
  );
  
  static Icon save({Color? color, double? size}) => Icon(
    Icons.save_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  static Icon cancel({Color? color, double? size}) => Icon(
    Icons.cancel_outlined,
    color: color ?? Colors.grey,
    size: size ?? 24,
  );
  
  // Filter and search icons
  static Icon search({Color? color, double? size}) => Icon(
    Icons.search_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  static Icon filter({Color? color, double? size}) => Icon(
    Icons.filter_list_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  static Icon sort({Color? color, double? size}) => Icon(
    Icons.sort_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  // Status icons
  static Icon success({Color? color, double? size}) => Icon(
    Icons.check_circle_outline_rounded,
    color: color ?? ColorValue.mediumGreen,
    size: size ?? 24,
  );
  
  static Icon error({Color? color, double? size}) => Icon(
    Icons.error_outline_rounded,
    color: color ?? ColorValue.brightRed,
    size: size ?? 24,
  );
  
  static Icon warning({Color? color, double? size}) => Icon(
    Icons.warning_amber_rounded,
    color: color ?? ColorValue.lightAmber,
    size: size ?? 24,
  );
  
  static Icon info({Color? color, double? size}) => Icon(
    Icons.info_outline_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  // Asset management specific icons
  static Icon asset({Color? color, double? size}) => Icon(
    Icons.inventory_2_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  static Icon category({Color? color, double? size}) => Icon(
    Icons.category_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  static Icon department({Color? color, double? size}) => Icon(
    Icons.business_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  static Icon staff({Color? color, double? size}) => Icon(
    Icons.people_alt_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  static Icon transfer({Color? color, double? size}) => Icon(
    Icons.swap_horiz_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  static Icon calendar({Color? color, double? size}) => Icon(
    Icons.calendar_today_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  static Icon report({Color? color, double? size}) => Icon(
    Icons.assessment_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  static Icon settings({Color? color, double? size}) => Icon(
    Icons.settings_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  static Icon notification({Color? color, double? size}) => Icon(
    Icons.notifications_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  static Icon language({Color? color, double? size}) => Icon(
    Icons.language_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  static Icon logout({Color? color, double? size}) => Icon(
    Icons.logout_rounded,
    color: color ?? ColorValue.brightRed,
    size: size ?? 24,
  );
  
  static Icon user({Color? color, double? size}) => Icon(
    Icons.person_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  static Icon location({Color? color, double? size}) => Icon(
    Icons.location_on_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  static Icon time({Color? color, double? size}) => Icon(
    Icons.access_time_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  static Icon money({Color? color, double? size}) => Icon(
    Icons.attach_money_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  static Icon document({Color? color, double? size}) => Icon(
    Icons.description_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  static Icon download({Color? color, double? size}) => Icon(
    Icons.download_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  static Icon upload({Color? color, double? size}) => Icon(
    Icons.upload_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  static Icon print({Color? color, double? size}) => Icon(
    Icons.print_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  static Icon share({Color? color, double? size}) => Icon(
    Icons.share_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  static Icon moreVertical({Color? color, double? size}) => Icon(
    Icons.more_vert_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
  
  static Icon moreHorizontal({Color? color, double? size}) => Icon(
    Icons.more_horiz_rounded,
    color: color ?? ColorValue.oceanBlue,
    size: size ?? 24,
  );
}
