// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use, avoid_print

import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/app.dart';
import 'package:quan_ly_tai_san_app/injection.dart';
import 'package:quan_ly_tai_san_app/routes/routes.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';

/// Web implementation của CrossTabAuthService
/// Sử dụng BroadcastChannel API để giao tiếp giữa các tab
class CrossTabAuthService {
  static final CrossTabAuthService instance = CrossTabAuthService._();
  CrossTabAuthService._();

  static const String _channelName = 'quan_ly_tai_san_auth_channel';

  html.BroadcastChannel? _channel;
  String? _currentUserId;
  BuildContext? _context;

  /// Khởi tạo service
  void init(BuildContext context) {
    _context = context;
    _currentUserId = AccountHelper.instance.getUserInfo()?.tenDangNhap;

    print('🔵 [CrossTabAuth] init - userId: $_currentUserId');

    try {
      _channel = html.BroadcastChannel(_channelName);
      print('🔵 [CrossTabAuth] BroadcastChannel created');

      _channel!.onMessage.listen((event) {
        print('🟢 [CrossTabAuth] Message received: ${event.data}');
        _handleMessage(event.data);
      });
    } catch (e) {
      print('🔴 [CrossTabAuth] Error creating channel: $e');
    }
  }

  /// Cập nhật user và broadcast
  void updateCurrentUser(String? userId) {
    final oldUserId = _currentUserId;
    _currentUserId = userId;

    print('🔵 [CrossTabAuth] updateCurrentUser: $oldUserId -> $userId');

    _broadcastUserChange(userId);
  }

  /// Broadcast message
  void _broadcastUserChange(String? newUserId) {
    if (_channel == null) {
      print('🔴 [CrossTabAuth] Channel is null, cannot broadcast');
      return;
    }

    try {
      // Gửi message đơn giản dạng JSON string
      final message = jsonEncode({
        'type': 'USER_CHANGED',
        'userId': newUserId ?? '',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      _channel!.postMessage(message);
      print('🟢 [CrossTabAuth] Broadcasted: $message');
    } catch (e) {
      print('🔴 [CrossTabAuth] Broadcast error: $e');
    }
  }

  /// Xử lý message
  void _handleMessage(dynamic data) {
    print('🔵 [CrossTabAuth] _handleMessage called with: $data');
    print('🔵 [CrossTabAuth] context: $_context, mounted: ${_context?.mounted}');
    print('🔵 [CrossTabAuth] currentUserId: $_currentUserId');

    if (_context == null || !_context!.mounted) {
      print('🔴 [CrossTabAuth] Context not available');
      return;
    }

    try {
      // Parse JSON string
      Map<String, dynamic> parsed;
      if (data is String) {
        parsed = jsonDecode(data);
      } else {
        print('🔴 [CrossTabAuth] Unknown data type: ${data.runtimeType}');
        return;
      }

      final type = parsed['type'];
      final newUserId = parsed['userId']?.toString() ?? '';

      print('🔵 [CrossTabAuth] Parsed - type: $type, newUserId: $newUserId');

      if (type != 'USER_CHANGED') return;

      final isLogout = newUserId.isEmpty;
      final isDifferentUser = !isLogout && newUserId != _currentUserId;

      print('🔵 [CrossTabAuth] isLogout: $isLogout, isDifferentUser: $isDifferentUser');

      if (_currentUserId != null && _currentUserId!.isNotEmpty) {
        if (isLogout || isDifferentUser) {
          print('🟢 [CrossTabAuth] Session changed, redirecting to login...');
          _forceLogout();
        }
      } else {
        print('🔵 [CrossTabAuth] Current user is null/empty, ignoring');
      }
    } catch (e) {
      print('🔴 [CrossTabAuth] Error: $e');
    }
  }

  /// Force logout và chuyển về màn hình login
  void _forceLogout() {
    // Reset app state
    App.resetCountsLoadedFlag();
    _currentUserId = null;

    // Navigate to login using router directly
    // Không cần clear storage vì tab khác đã làm rồi
    try {
      locator<AppRouteConf>().router.go(AppRoute.login.path);
    } catch (e) {
      print('🔴 [CrossTabAuth] Navigation error: $e');
    }
  }

  /// Cleanup resources
  void dispose() {
    _channel?.close();
    _channel = null;
    _context = null;
  }
}
