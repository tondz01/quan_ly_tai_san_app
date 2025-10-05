import 'package:flutter/material.dart';

/// Singleton class để quản lý scroll state của Home
class HomeScrollController {
  static final HomeScrollController _instance = HomeScrollController._internal();
  factory HomeScrollController() => _instance;
  HomeScrollController._internal();

  bool _parentShouldScroll = true;
  final List<VoidCallback> _listeners = [];

  // Getter
  bool get parentShouldScroll => _parentShouldScroll;
  bool get isParentScrolling => _parentShouldScroll;

  // Setter với notification
  void setParentScrollState(bool shouldScroll) {
    if (_parentShouldScroll != shouldScroll) {
      _parentShouldScroll = shouldScroll;
      _notifyListeners();
    }
  }

  // Thêm listener
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  // Xóa listener
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  // Thông báo cho tất cả listeners
  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  // Reset về trạng thái ban đầu
  void reset() {
    _parentShouldScroll = true;
    _notifyListeners();
  }
}
