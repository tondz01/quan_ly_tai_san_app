import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/request/detail_tool_and_material_transfer_request.dart';
import 'package:se_gay_components/base_api/api_config.dart';

import '../model/detail_tool_and_material_transfer_dto.dart';

class DetailToolAndMaterialTransferRepository {
  late final Dio _dio;

  DetailToolAndMaterialTransferRepository() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "${ApiConfig.getBaseURL()}/api/chitietdieudongccdcvattu",
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
  String generateCurlCommand(
    String method,
    String url,
    Map<String, dynamic>? queryParams,
    dynamic data,
  ) {
    final baseUrl = "${ApiConfig.getBaseURL()}/api/chitietdieudongccdcvattu";
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

  Future<List<DetailToolAndMaterialTransferDto>> getAll(
    String idToolAndMaterialTransfer,
  ) async {
    final queryParams = {"iddieudongccdcvattu": idToolAndMaterialTransfer};
    
    // Log cURL command
    final curlCommand = generateCurlCommand('GET', '', queryParams, null);
    log('cURL command: $curlCommand');
    final res = await _dio.get(
      '',
      queryParameters: {"iddieudongccdcvattu": idToolAndMaterialTransfer},
    );
    List<DetailToolAndMaterialTransferDto> chiTietDieuDongs =
        (res.data as List)
            .map((e) => DetailToolAndMaterialTransferDto.fromJson(e))
            .toList();
    return chiTietDieuDongs;
  }

  Future<DetailToolAndMaterialTransferDto> getById(String id) async {
    final res = await _dio.get('/$id');
    DetailToolAndMaterialTransferDto chiTietToolAndMaterialTransfer =
        DetailToolAndMaterialTransferDto.fromJson(res.data);

    return chiTietToolAndMaterialTransfer;
  }

  Future<int> create(List<ChiTietBanGiaoRequest> obj) async {
    final res = await _dio.post('/batch', data: jsonEncode(obj));
    return res.data;
  }

  Future<int> update(String id, ChiTietBanGiaoRequest obj) async {
    final res = await _dio.put('/$id', data: obj.toJson());
    return res.data;
  }

  Future<int> delete(String id) async {
    final res = await _dio.delete('/$id');
    return res.data;
  }
}
