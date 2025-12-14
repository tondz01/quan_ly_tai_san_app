import 'dart:async';
import 'dart:developer';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/asset_transfer_reponsitory.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/repository/asset_handover_repository.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/repository/tool_and_material_transfer_reponsitory.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/repository/tool_and_supplies_handover_repository.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';

/// Service quản lý việc load count cho các biên bản
/// Logic: Load lại danh sách các phiếu → AccountHelper tự động tính count từ danh sách đó
/// Tối ưu: debounce, throttle, load song song
class CountService {
  static final CountService _instance = CountService._internal();
  factory CountService() => _instance;
  CountService._internal();

  bool _isLoading = false;
  DateTime? _lastLoadTime;
  Timer? _debounceTimer;
  
  static const Duration _minLoadInterval = Duration(seconds: 3);
  static const Duration _debounceDuration = Duration(milliseconds: 500);
  
  final Map<String, Function(int)> _callbacks = {};

  void registerCallback(String key, Function(int) callback) {
    _callbacks[key] = callback;
  }

  void unregisterCallback(String key) {
    _callbacks.remove(key);
  }

  void _notifyCallbacks(String type, int count) {
    _callbacks.forEach((key, callback) {
      if (key.startsWith(type)) {
        try {
          callback(count);
        } catch (e) {
          log('Error in callback $key: $e');
        }
      }
    });
  }

  /// Load tất cả danh sách các phiếu bất đồng bộ
  /// Sau đó AccountHelper sẽ tự động tính count từ danh sách đó
  Future<Map<String, int>> loadAllCounts({bool force = false}) async {
    final now = DateTime.now();
    if (!force && _lastLoadTime != null && now.difference(_lastLoadTime!) < _minLoadInterval) {
      return _getCountsFromAccountHelper();
    }

    if (_isLoading && !force) return _getCountsFromAccountHelper();

    final userId = AccountHelper.instance.getUserInfo()?.tenDangNhap ?? '';
    if (userId.isEmpty) return _getCountsFromAccountHelper();

    _isLoading = true;
    _lastLoadTime = now;

    try {
      // Load tất cả danh sách các phiếu song song (parallel)
      // Các method này sẽ tự động lưu vào AccountHelper và trigger refreshAllCounts()
      await Future.wait([
        AssetTransferRepository().getCountUseSign(),
        AssetHandoverRepository().getCountUseSign(),
        ToolAndMaterialTransferRepository().getCountUseSign(),
        ToolAndSuppliesHandoverRepository().getCountUseSign(),
      ], eagerError: false);

      // Sau khi load xong, AccountHelper đã tự động tính count từ danh sách
      // Chỉ cần refresh menu để hiển thị counts mới
      AccountHelper.refreshAllCounts();

      // Lấy counts từ AccountHelper để return
      final counts = _getCountsFromAccountHelper();
      
      // Notify callbacks
      _notifyCallbacks('assetTransfer', counts['assetTransfer']!);
      _notifyCallbacks('assetHandover', counts['assetHandover']!);
      _notifyCallbacks('toolMaterialTransfer', counts['toolMaterialTransfer']!);
      _notifyCallbacks('toolSuppliesHandover', counts['toolSuppliesHandover']!);

      return counts;
    } catch (e) {
      log('[CountService] Error loading lists: $e');
      return _getCountsFromAccountHelper();
    } finally {
      _isLoading = false;
    }
  }

  /// Lấy counts từ AccountHelper (đã được tính từ danh sách các phiếu)
  Map<String, int> _getCountsFromAccountHelper() {
    final helper = AccountHelper.instance;
    return {
      'assetTransfer': _sumCounts([1, 2, 3], (t) => helper.getAssetTransferCount(t)),
      'assetHandover': helper.getAssetHandoverCount(),
      'toolMaterialTransfer': _sumCounts([1, 2, 3], (t) => helper.getToolAndMaterialTransferCount(t)),
      'toolSuppliesHandover': helper.getToolAndMaterialHandoverCount(),
    };
  }

  /// Helper: tính tổng counts theo types
  int _sumCounts(List<int> types, int Function(int) getter) {
    return types.fold(0, (sum, type) => sum + getter(type));
  }

  /// Debounce load counts (cho realtime updates)
  void debouncedLoadAllCounts() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, loadAllCounts);
  }

  void clearCache() {
    _lastLoadTime = null;
  }

  void dispose() {
    _debounceTimer?.cancel();
    _callbacks.clear();
    clearCache();
  }
}
