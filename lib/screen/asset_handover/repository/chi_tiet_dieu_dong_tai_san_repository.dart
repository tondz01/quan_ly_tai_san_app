// repositories/dieu_dong_tai_san_repository.dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:se_gay_components/base_api/api_config.dart';

class ChiTietDieuDongTaiSanRepository {
  late final Dio _dio;

  ChiTietDieuDongTaiSanRepository() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "${ApiConfig.getBaseURL()}/api/chitietdieudongtaisan",
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

  Future<List<ChiTietDieuDongTaiSan>> getAll(String idDieuDongTaiSan) async {
    final res = await _dio.get(
      '',
      queryParameters: {"iddieudongtaisan": idDieuDongTaiSan},
    );
    List<ChiTietDieuDongTaiSan> chiTietDieuDongs =
        (res.data as List)
            .map((e) => ChiTietDieuDongTaiSan.fromJson(e))
            .toList();
    return chiTietDieuDongs;
  }

  Future<ChiTietDieuDongTaiSan> getById(String id) async {
    final res = await _dio.get('/$id');
    ChiTietDieuDongTaiSan chiTietDieuDongTaiSan =
        ChiTietDieuDongTaiSan.fromJson(res.data);

    return chiTietDieuDongTaiSan;
  }

  Future<int> create(ChiTietDieuDongTaiSan obj) async {
    final res = await _dio.post('', data: obj.toJson());
    return res.data;
  }

  Future<int> update(String id, ChiTietDieuDongTaiSan obj) async {
    final res = await _dio.put('/$id', data: obj.toJson());
    return res.data;
  }

  Future<int> delete(String id) async {
    final res = await _dio.delete('/$id');
    return res.data;
  }
}
