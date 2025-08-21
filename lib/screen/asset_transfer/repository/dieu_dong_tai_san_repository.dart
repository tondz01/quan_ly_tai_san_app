import 'package:dio/dio.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/request/lenh_dieu_dong_request.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:se_gay_components/base_api/api_config.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

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
		_chiTietDieuDongTaiSanRepository = ChiTietDieuDongTaiSanRepository();

		// Bỏ qua chứng chỉ SSL
		// if (!kIsWeb) {
		//   (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
		//     final client = HttpClient();
		//     client.badCertificateCallback =
		//         (X509Certificate cert, String host, int port) => true;
		//     return client;
		//   };
		// }
	}

	Future<List<DieuDongTaiSanDto>> getAll(int type) async {
		UserInfoDTO userInfo = AccountHelper.instance.getUserInfo()!;

		final res = await _dio.get('/getbyuserid/${userInfo.id}');
		List<DieuDongTaiSanDto> dieuDongTaiSans = [];
		dieuDongTaiSans =
			(res.data as List)
				.map((e) => DieuDongTaiSanDto.fromJson(e))
				.where((e) => e.loai == type)
				.toList();
		if (dieuDongTaiSans.isEmpty) {
			SGLog.debug(
				'getAll',
				'No asset transfers found for user: ${userInfo.id}',
			);
			return [];
		}
		await Future.wait(
			dieuDongTaiSans.map((dieuDongTaiSan) async {
				dieuDongTaiSan
						.chiTietDieuDongTaiSans = await _chiTietDieuDongTaiSanRepository
						.getAll(dieuDongTaiSan.id.toString());
			}),
		);

		SGLog.debug(
			'getAll',
			'Fetched all asset transfers: ${dieuDongTaiSans.length}',
		);
		return dieuDongTaiSans;
	}

	Future<DieuDongTaiSanDto> getById(String id) async {
		final res = await _dio.get('/$id');
		DieuDongTaiSanDto dieuDongTaiSan = DieuDongTaiSanDto.fromJson(res.data);
		List<ChiTietDieuDongTaiSan> chiTietDieuDongTS =
				await _chiTietDieuDongTaiSanRepository.getAll(
					dieuDongTaiSan.id.toString(),
				);
		dieuDongTaiSan.chiTietDieuDongTaiSans = chiTietDieuDongTS;
		return dieuDongTaiSan;
	}

	Future<int> create(DieuDongTaiSan obj) async {
		final res = await _dio.post('', data: obj.toJson());
		final data = res.data;
		if (data is int) return data;
		if (data is Map<String, dynamic>) {
			final code = data['status_code'] ?? data['statusCode'] ?? data['code'];
			if (code is int) return code;
			if (code is String) return int.tryParse(code) ?? (res.statusCode ?? 0);
		}
		return res.statusCode ?? 0;
	}

	Future<int> update(String id, LenhDieuDongRequest obj) async {
		final res = await _dio.put('/$id', data: obj.toJson());
		final data = res.data;
		if (data is int) return data;
		if (data is Map<String, dynamic>) {
			final code = data['status_code'] ?? data['statusCode'] ?? data['code'];
			if (code is int) return code;
			if (code is String) return int.tryParse(code) ?? (res.statusCode ?? 0);
		}
		return res.statusCode ?? 0;
	}

	Future<int> delete(String id) async {
		final res = await _dio.delete('/$id');
		final data = res.data;
		if (data is int) return data;
		if (data is Map<String, dynamic>) {
			final code = data['status_code'] ?? data['statusCode'] ?? data['code'];
			if (code is int) return code;
			if (code is String) return int.tryParse(code) ?? (res.statusCode ?? 0);
		}
		return res.statusCode ?? 0;
	}
}
