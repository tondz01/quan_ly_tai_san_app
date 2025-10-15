import 'dart:async';
import 'package:quan_ly_tai_san_app/screen/asset_handover/repository/asset_handover_repository.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/asset_transfer_reponsitory.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/repository/tool_and_material_transfer_reponsitory.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/repository/tool_and_supplies_handover_repository.dart';

import 'package:se_gay_components/core/utils/sg_log.dart';

class PermissionSignService {
  Timer? _timer;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  void startCheckingPermission() {
    // Poll mỗi 30 giây (hoặc bao lâu tùy bạn)
    _timer = Timer.periodic(const Duration(seconds: 15), (_) async {
      // String tenDangNhap = AccountHelper.instance.getUserInfo()?.tenDangNhap ?? '';
      try {
        // final response = await http.get(
        //   Uri.parse(
        //     'https://ecotel-odoo.id.vn:8386/api/bangiaotaisan/permission-signing/?tenDangNhap=$tenDangNhap',
        //   ),
        //   headers: {'Cookie': 'JSESSIONID=978E7873E60BA42EE69DA775C0E0AFA5'},
        // );
        // final responseDieuDong = await http.get(
        //   Uri.parse(
        //     'https://ecotel-odoo.id.vn:8386/api/dieudongtaisan/permission-signing/?tenDangNhap=$tenDangNhap',
        //   ),
        //   headers: {'Cookie': 'JSESSIONID=978E7873E60BA42EE69DA775C0E0AFA5'},
        // );
        await AssetTransferRepository().getListDieuDongTaiSan();
        await ToolAndSuppliesHandoverRepository().getListToolAndSuppliesHandover();
        await AssetHandoverRepository().getListAssetHandover();
        await ToolAndMaterialTransferRepository().getAllToolAndMeterialTransfer(-1);

        // if (response.statusCode == 200) {
        //   final data = json.decode(response.body);
        //   _controller.add(data);
        // } else {
        //   SGLog.error('PermissionSignService', 'Lỗi ${response.statusCode}: ${response.body}');
        // }
      } catch (e) {
        SGLog.error('PermissionSignService', 'Lỗi call API: $e');
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _controller.close();
  }
}
