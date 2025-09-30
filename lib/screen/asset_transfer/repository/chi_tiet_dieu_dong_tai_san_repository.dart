import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:se_gay_components/base_api/api_config.dart';

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

  String generateCurlCommand(
    String method,
    String url,
    Map<String, dynamic>? queryParams,
    dynamic data,
  ) {
    final baseUrl = "${ApiConfig.getBaseURL()}/api/chitietdieudongtaisan";
    final fullUrl = baseUrl + url;

    String curl = 'curl -X $method';

    // Add headers
    curl += ' -H "Content-Type: application/json"';
    curl += ' -H "Accept: application/json"';

    // Add query parameters
    if (queryParams != null && queryParams.isNotEmpty) {
      final queryString = queryParams.entries
          .map(
            (e) =>
                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}',
          )
          .join('&');
      curl += ' "$fullUrl?$queryString"';
    } else {
      curl += ' "$fullUrl"';
    }

    // Add data for POST/PUT requests
    if (data != null && (method == 'POST' || method == 'PUT')) {
      curl += ' -d \'${jsonEncode(data)}\'';
    }

    return curl;
  }
}
