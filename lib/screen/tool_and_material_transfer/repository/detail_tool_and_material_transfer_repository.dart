import 'package:dio/dio.dart';
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

  Future<List<DetailToolAndMaterialTransferDto>> getAll(String idToolAndMaterialTransfer) async {
    
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

  Future<int> create(DetailToolAndMaterialTransferDto obj) async {
    final res = await _dio.post('', data: obj.toJson());
    return res.data;
  }

  Future<int> update(String id, DetailToolAndMaterialTransferDto obj) async {
    final res = await _dio.put('/$id', data: obj.toJson());
    return res.data;
  }

  Future<int> delete(String id) async {
    final res = await _dio.delete('/$id');
    return res.data;
  }
}
