import 'dart:async';
import 'package:quan_ly_tai_san_app/screen/asset_handover/repository/asset_handover_repository.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/asset_transfer_reponsitory.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/repository/tool_and_material_transfer_reponsitory.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/repository/tool_and_supplies_handover_repository.dart';

import 'package:se_gay_components/core/utils/sg_log.dart';

class PermissionSignService {
  Timer? _timer;
  StreamController<Map<String, dynamic>>? _controller;
  bool _isRunning = false;

  Stream<Map<String, dynamic>>? get stream => _controller?.stream;

  void startCheckingPermission() {
    // Prevent multiple timers
    if (_isRunning) {
      SGLog.debug('PermissionSignService', 'Already running, skipping start');
      return;
    }

    _isRunning = true;
    _controller ??= StreamController<Map<String, dynamic>>.broadcast();

    _timer?.cancel(); // Cancel existing timer if any
    _timer = Timer.periodic(const Duration(seconds: 15), (_) async {
      try {
        if (AccountHelper.instance.getUserInfo() == null ||
            AccountHelper.instance.getUserInfo()?.tenDangNhap == "admin") {
          return;
        }
        await AssetTransferRepository().getListDieuDongTaiSan();
        await ToolAndSuppliesHandoverRepository()
            .getListToolAndSuppliesHandover();
        await AssetHandoverRepository().getListAssetHandover();
        await ToolAndMaterialTransferRepository().getAllToolAndMeterialTransfer(
          -1,
        );
      } catch (e) {
        SGLog.error('PermissionSignService', 'Lỗi call API: $e');
      }
    });
  }

  void reloadData(Future<void> Function() callback) {
    _timer?.cancel(); // Hủy timer cũ trước khi tạo mới

    if (!_isRunning) {
      _isRunning = true;
      _controller ??= StreamController<Map<String, dynamic>>.broadcast();
    }

    _timer = Timer.periodic(const Duration(seconds: 15), (_) async {
      try {
        await callback();
      } catch (e) {
        SGLog.error('PermissionSignService', 'Lỗi call API: $e');
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;

    if (_controller != null && !_controller!.isClosed) {
      _controller!.close();
    }
    _controller = null;
    _isRunning = false;
  }

  // Helper method to ensure proper cleanup
  void dispose() {
    stop();
  }
}
