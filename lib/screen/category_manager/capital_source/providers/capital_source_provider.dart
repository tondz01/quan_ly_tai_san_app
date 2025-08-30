import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/models/capital_source.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';

class CapitalSourceProvider extends ApiBase {
  Future<List<NguonKinhPhi>> fetchCapitalSources() async {
    try {
      final response = await get(EndPointAPI.NGUON_KINH_PHI, queryParameters: {
        'idcongty': "ct001",
      });
      final List<dynamic> data = response.data;
      return data.map((json) => NguonKinhPhi.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
  Future<void> addCapitalSource(NguonKinhPhi capitalSource) async {
    try {
      await post(EndPointAPI.NGUON_KINH_PHI, data: capitalSource.toJson());
    } catch (e) {
      rethrow;
    }
  }
  Future<void> updateCapitalSource(NguonKinhPhi capitalSource) async {
    try {
      await put('${EndPointAPI.NGUON_KINH_PHI}/${capitalSource.id}', data: capitalSource.toJson());
    } catch (e) {
      rethrow;
    }
  }
  Future<void> deleteCapitalSource(String capitalSourceId) async {
    try {
      await delete('${EndPointAPI.NGUON_KINH_PHI}/$capitalSourceId');
    } catch (e) {
      rethrow;
    }
  }
}
