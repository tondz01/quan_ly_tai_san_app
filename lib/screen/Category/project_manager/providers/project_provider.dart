import 'package:quan_ly_tai_san_app/core/network/Services/end_point_api.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/models/duan.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';

class ProjectProvider extends ApiBase {
  Future<List<DuAn>> fetchProjects() async {
    try {
      final response = await get(EndPointAPI.DU_AN, queryParameters: {
        'idcongty': "ct001",
      });
      final List<dynamic> data = response.data;
      return data.map((json) => DuAn.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
  Future<void> addProject(DuAn project) async {
    try {
      await post(EndPointAPI.DU_AN, data: project.toJson());
    } catch (e) {
      rethrow;
    }
  }
  Future<void> updateProject(DuAn project) async {
    try {
      await put('${EndPointAPI.DU_AN}/${project.id}', data: project.toJson());
    } catch (e) {
      rethrow;
    }
  }
  Future<void> deleteProject(String projectId) async {
    try {
      await delete('${EndPointAPI.DU_AN}/$projectId');
    } catch (e) {
      rethrow;
    }
  }
}
