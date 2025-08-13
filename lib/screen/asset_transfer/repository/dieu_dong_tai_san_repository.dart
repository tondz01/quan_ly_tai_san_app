// repositories/dieu_dong_tai_san_repository.dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:se_gay_components/base_api/api_config.dart';

import '../model/chi_tiet_dieu_dong_tai_san.dart';
import '../model/dieu_dong_tai_san.dart';
import '../model/dieu_dong_tai_san_dto.dart';
import 'chi_tiet_dieu_dong_tai_san_repository.dart';

class DieuDongTaiSanRepository {
  late final Dio _dio;
  late final ChiTietDieuDongTaiSanRepository _chiTietDieuDongTaiSanRepository;

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

  Future<List<DieuDongTaiSanDto>> getAll(String idCongTy, int type) async {
    final res = await _dio.get('', queryParameters: {"idcongty": idCongTy});
    print('log dieu dong tai san');
    print(res);

    List<DieuDongTaiSanDto> dieuDongTaiSans =
        (res.data as List)
            .map((e) => DieuDongTaiSanDto.fromJson(e))
            .where((e) => e.loai == type)
            .toList();

    await Future.wait(
      dieuDongTaiSans.map((dieuDongTaiSan) async {
        dieuDongTaiSan
            .chiTietDieuDongTaiSan = await _chiTietDieuDongTaiSanRepository
            .getAll(dieuDongTaiSan.id.toString());
      }),
    );

    return dieuDongTaiSans;
  }

  Future<DieuDongTaiSanDto> getById(String id) async {
    final res = await _dio.get('/$id');
    DieuDongTaiSanDto dieuDongTaiSan = DieuDongTaiSanDto.fromJson(res.data);
    List<ChiTietDieuDongTaiSan> _chiTietDieuDongTS =
        await _chiTietDieuDongTaiSanRepository.getAll(
          dieuDongTaiSan.id.toString(),
        );
    dieuDongTaiSan.chiTietDieuDongTaiSan = _chiTietDieuDongTS;
    return dieuDongTaiSan;
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
