import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/nhan_vien.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';

class NhanVienProvider extends ApiBase {
  Future<List<NhanVien>> fetchNhanViens() async {
    final response = await get(EndPointAPI.NHAN_VIEN, queryParameters: {
      'idcongty': "ct001",
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((item) => NhanVien.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load nhân viên');
    }
  }
}
