import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/nhom_don_vi.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';

class DepartmentsProvider extends ApiBase {
  Future<List<PhongBan>> fetchDepartments() async {
    try {
      final response = await get(EndPointAPI.PHONG_BAN, queryParameters: {
        'idcongty': "ct001",
      });
      final List<dynamic> data = response.data;
      return data.map((json) => PhongBan.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
  Future<void> addDepartment(PhongBan department) async {
    try {
      await post(EndPointAPI.PHONG_BAN, data: department.toJson());
    } catch (e) {
      rethrow;
    }
  }
  Future<void> updateDepartment(PhongBan department) async {
    try {
      await put('${EndPointAPI.PHONG_BAN}/${department.id}', data: department.toJson());
    } catch (e) {
      rethrow;
    }
  }
  Future<void> deleteDepartment(String departmentId) async {
    try {
      await delete('${EndPointAPI.PHONG_BAN}/$departmentId');
    } catch (e) {
      rethrow;
    }
  }
  Future<List<NhomDonVi>> fetchDepartmentGroups() async {
    try {
      final response = await get(EndPointAPI.NHOM_DON_VI, queryParameters: {
        'idcongty': "ct001",
      });
      final List<dynamic> data = response.data;
      return data.map((json) => NhomDonVi.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
