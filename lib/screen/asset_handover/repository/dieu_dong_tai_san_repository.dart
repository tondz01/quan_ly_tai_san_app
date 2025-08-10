// repositories/dieu_dong_tai_san_repository.dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/dieu_dong_tai_san.dart';
import 'package:se_gay_components/base_api/api_config.dart';

class DieuDongTaiSanRepository {
  late final Dio _dio;

  DieuDongTaiSanRepository() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "${ApiConfig.getBaseURL()}/api/dieudongtaisan",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // Bỏ qua chứng chỉ SSL
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<List<DieuDongTaiSan>> getAll(String idCongTy) async {
    final res = await _dio.get('', queryParameters: {"idcongty": idCongTy});
    return (res.data as List).map((e) => DieuDongTaiSan.fromJson(e)).toList();
  }

  Future<DieuDongTaiSan> getById(String id) async {
    final res = await _dio.get('/$id');
    return DieuDongTaiSan.fromJson(res.data);
  }

  Future<int> create(DieuDongTaiSan obj) async {
    final res = await _dio.post('', data: obj.toJson());
    return res.data;
  }

  Future<int> update(String id, DieuDongTaiSan obj) async {
    final res = await _dio.put('/$id', data: obj.toJson());
    return res.data;
  }

  Future<int> delete(String id) async {
    final res = await _dio.delete('/$id');
    return res.data;
  }
}
