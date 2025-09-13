import 'dart:developer';

import 'package:quan_ly_tai_san_app/screen/home/models/menu_data.dart';

class MenuRefreshService {
  static final MenuRefreshService _instance = MenuRefreshService._internal();
  factory MenuRefreshService() => _instance;
  MenuRefreshService._internal();

  /// Refresh tất cả count values trong menu
  void refreshCounts() {
    log('message refreshCounts MenuRefreshService');
    MenuDataNotifier().refreshCounts();
  }
} 