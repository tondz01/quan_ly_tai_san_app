// ignore_for_file: unused_element

import 'package:flutter/material.dart';

/// Stub implementation cho non-web platforms (iOS, Android, Desktop)
/// Service này không làm gì trên các platform không phải web
/// vì vấn đề multi-tab chỉ xảy ra trên browser
class CrossTabAuthService {
  static final CrossTabAuthService instance = CrossTabAuthService._();
  CrossTabAuthService._();

  /// Khởi tạo service - không làm gì trên non-web
  void init(BuildContext context) {}

  /// Cập nhật user hiện tại - không làm gì trên non-web
  void updateCurrentUser(String? userId) {}

  /// Cleanup resources - không làm gì trên non-web
  void dispose() {}
}
