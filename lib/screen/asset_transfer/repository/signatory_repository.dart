import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';
import 'package:se_gay_components/base_api/api_config.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import 'package:quan_ly_tai_san_app/core/utils/response_parser.dart';

class SignatoryRepository {
  late final Dio _dio;
  late final Dio _dioDelete;

  SignatoryRepository() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "${ApiConfig.getBaseURL()}/api/chuky/nguoi-ky",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    _dioDelete = Dio(
      BaseOptions(
        baseUrl: "${ApiConfig.getBaseURL()}/api/chuky",
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

  Future<List<SignatoryDto>> getAll(String idDieuDongTaiSan) async {
    try {
      final res = await _dio.get('/tailieu/$idDieuDongTaiSan');
      // Sử dụng ResponseParser để parse an toàn
      final signatories = ResponseParser.parseToList<SignatoryDto>(
        res.data["data"],
        SignatoryDto.fromJson,
      );
      return signatories;
    } on DioException catch (e) {
      // Thử fallback key tham số khác trong trường hợp API yêu cầu tên khác
      if (e.response?.statusCode == Numeral.STATUS_CODE_DELETE) {
        SGLog.error(
          'Signatory Requesst.getAll',
          '400 Bad Request với key iddieudongtaisan, thử lại với idDieuDongTaiSan',
        );
        try {
          final resRetry = await _dio.get(
            '',
            queryParameters: {"idDieuDongTaiSan": idDieuDongTaiSan},
          );

          // Xử lý tương tự cho retry
          if (resRetry.data is Map<String, dynamic>) {
            final responseData = resRetry.data as Map<String, dynamic>;
            if (responseData['data'] is List) {
              List<SignatoryDto> listSignatory =
                  (responseData['data'] as List)
                      .map((e) => SignatoryDto.fromJson(e))
                      .toList();
              return listSignatory;
            }
          }

          return [];
        } catch (e2) {
          SGLog.error('Signatory Requesst.getAll', 'Fallback thất bại: $e2');
          return [];
        }
      }
      return [];
    } catch (e) {
      SGLog.error('Signatory Requesst.getAll', 'Lỗi không xác định: $e');
      return [];
    }
  }

  Future<SignatoryDto> getById(String id) async {
    final res = await _dio.get('/$id');
    SignatoryDto signatory = SignatoryDto.fromJson(res.data);

    return signatory;
  }

  Future<int> create(SignatoryDto obj) async {
    final res = await _dio.post('', data: obj.toJson());
    return res.data;
  }

  Future<int> update(String id, SignatoryDto obj) async {
    final res = await _dio.put('/$id', data: obj.toJson());
    return res.data;
  }

  Future<int> delete(String id) async {
    log('Delete signatory: $id');
   
    final res = await _dioDelete.delete('/$id');
    return res.data;
  }
}
