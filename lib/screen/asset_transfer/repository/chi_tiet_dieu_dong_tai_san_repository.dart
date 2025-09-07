import 'package:dio/dio.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:se_gay_components/base_api/api_config.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

import '../model/chi_tiet_dieu_dong_tai_san.dart';

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
    // (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    //   final client = HttpClient();
    //   client.badCertificateCallback =
    //       (X509Certificate cert, String host, int port) => true;
    //   return client;
    // };
  }

  Future<List<ChiTietDieuDongTaiSan>> getAll(String idDieuDongTaiSan) async {
    try {
      final res = await _dio.get(
        '',
        queryParameters: {"iddieudongtaisan": idDieuDongTaiSan},
      );
      List<ChiTietDieuDongTaiSan> chiTietDieuDongs = (res.data as List)
          .map((e) => ChiTietDieuDongTaiSan.fromJson(e))
          .toList();
      return chiTietDieuDongs;
    } on DioException catch (e) {
      // Thử fallback key tham số khác trong trường hợp API yêu cầu tên khác
      if (e.response?.statusCode == Numeral.STATUS_CODE_DELETE) {
        SGLog.error(
          'ChiTietDieuDongTaiSanRepository.getAll',
          '400 Bad Request với key iddieudongtaisan, thử lại với idDieuDongTaiSan',
        );
        try {
          final resRetry = await _dio.get(
            '',
            queryParameters: {"idDieuDongTaiSan": idDieuDongTaiSan},
          );
          List<ChiTietDieuDongTaiSan> chiTietDieuDongs =
              (resRetry.data as List)
                  .map((e) => ChiTietDieuDongTaiSan.fromJson(e))
                  .toList();
          return chiTietDieuDongs;
        } catch (e2) {
          SGLog.error(
            'ChiTietDieuDongTaiSanRepository.getAll',
            'Fallback thất bại: $e2',
          );
          return [];
        }
      }
      SGLog.error(
        'ChiTietDieuDongTaiSanRepository.getAll',
        'Lỗi khi gọi API: ${e.message}',
      );
      return [];
    } catch (e) {
      SGLog.error(
        'ChiTietDieuDongTaiSanRepository.getAll',
        'Lỗi không xác định: $e',
      );
      return [];
    }
  }

  Future<ChiTietDieuDongTaiSan> getById(String id) async {
    final res = await _dio.get('/$id');
    ChiTietDieuDongTaiSan chiTietDieuDongTaiSan =
        ChiTietDieuDongTaiSan.fromJson(res.data);

    return chiTietDieuDongTaiSan;
  }

  Future<dynamic> create(ChiTietDieuDongTaiSan obj) async {
    final res = await _dio.post('', data: obj.toJson());
    return res.data;
  }

  Future<dynamic> update(String id, ChiTietDieuDongTaiSan obj) async {
    final res = await _dio.put('/$id', data: obj.toJson());
    return res.data;
  }

  Future<dynamic> delete(String id) async {
    final res = await _dio.delete('/$id');
    return res.data;
  }
}
