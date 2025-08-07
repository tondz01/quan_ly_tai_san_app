import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/nhan_vien.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class NhanVienProvider extends ApiBase {
  Future<List<NhanVien>> fetchNhanViens() async {
    final response = await get(EndPointAPI.NHAN_VIEN, queryParameters: {'idcongty': "ct001"});
    try {
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) => NhanVien.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      SGLog.error("NhanVienProvider", e.toString());
      return [];
    }
  }
}
