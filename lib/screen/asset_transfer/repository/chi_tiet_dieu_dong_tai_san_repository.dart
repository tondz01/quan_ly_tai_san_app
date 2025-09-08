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
        // Không ném DioException cho các mã lỗi HTTP, cho phép tự xử lý
        validateStatus: (status) => true,
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
      // Bỏ qua nếu id rỗng
      if (idDieuDongTaiSan.isEmpty) {
        SGLog.error(
          'ChiTietDieuDongTaiSanRepository.getAll',
          'Bỏ qua gọi API vì idDieuDongTaiSan rỗng',
        );
        return [];
      }

      // Thử với key chuẩn thường dùng theo backend
      Response res = await _dio.get(
        '',
        queryParameters: {"iddieudongtaisan": idDieuDongTaiSan},
      );

      if ((res.statusCode ?? 0) >= 200 && (res.statusCode ?? 0) < 300) {
        List<ChiTietDieuDongTaiSan> chiTietDieuDongs = (res.data as List)
            .map((e) => ChiTietDieuDongTaiSan.fromJson(e))
            .toList();
        return chiTietDieuDongs;
      }

      // Nếu 400 (hoặc không thành công), thử fallback với key khác
      if (res.statusCode == Numeral.STATUS_CODE_DELETE ||
          (res.statusCode ?? 0) < 200 ||
          (res.statusCode ?? 0) >= 300) {
        SGLog.error(
          'ChiTietDieuDongTaiSanRepository.getAll',
          'HTTP ${res.statusCode} với key iddieudongtaisan, thử lại với idDieuDongTaiSan',
        );
        final resRetry = await _dio.get(
          '',
          queryParameters: {"idDieuDongTaiSan": idDieuDongTaiSan},
        );
        if ((resRetry.statusCode ?? 0) >= 200 &&
            (resRetry.statusCode ?? 0) < 300) {
          List<ChiTietDieuDongTaiSan> chiTietDieuDongs =
              (resRetry.data as List)
                  .map((e) => ChiTietDieuDongTaiSan.fromJson(e))
                  .toList();
          return chiTietDieuDongs;
        }
        SGLog.error(
          'ChiTietDieuDongTaiSanRepository.getAll',
          'Fallback thất bại với HTTP ${resRetry.statusCode}',
        );
        return [];
      }

      // Trường hợp khác không thành công
      SGLog.error(
        'ChiTietDieuDongTaiSanRepository.getAll',
        'Gọi API không thành công: HTTP ${res.statusCode}',
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
