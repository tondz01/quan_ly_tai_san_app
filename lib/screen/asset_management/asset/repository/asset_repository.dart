import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import '../models/asset_model.dart';

class PaginationResult<T> {
  final List<T> items;
  final int totalItems;
  final int currentPage;
  final int pageSize;
  final int totalPages;

  PaginationResult({
    required this.items,
    required this.totalItems,
    required this.currentPage,
    required this.pageSize,
  }) : totalPages = (totalItems / pageSize).ceil();
}

class AssetRepository {
  static const String _csvPath = 'assets/data/thong_tin_tai_san/tai_san.csv';

  Future<List<AssetModel>> getAssets() async {
    try {
      // Đọc file CSV từ assets
      final String rawData = await rootBundle.loadString(_csvPath);

      // Parse CSV
      final List<List<dynamic>> csvTable = const CsvToListConverter(
        fieldDelimiter: ',',
        eol: '\r\n', // nếu \n không đúng
        shouldParseNumbers: false,
      ).convert(rawData);

      // Bỏ qua dòng header (dòng đầu tiên)
      final List<List<dynamic>> data = csvTable.skip(1).toList();

      // Chuyển đổi từng dòng thành AssetModel
      final List<AssetModel> assets = data.map((row) => AssetModel.fromCsv(row)).toList();
      return assets;
    } catch (e) {
      throw Exception('Không thể đọc dữ liệu tài sản: $e');
    }
  }

  // Phương thức mới để lấy dữ liệu phân trang
  Future<PaginationResult<AssetModel>> getAssetsWithPagination({
    required int page, 
    required int pageSize, 
    String? searchQuery,
    String? department, 
    String? assetType
  }) async {
    try {
      // Lấy tất cả dữ liệu
      List<AssetModel> allAssets = await getAssets();

      // Lọc dữ liệu theo các tiêu chí nếu có
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        allAssets = allAssets.where((asset) => 
          asset.id.toLowerCase().contains(query) || 
          asset.name.toLowerCase().contains(query)
        ).toList();
      }

      if (department != null && department.isNotEmpty) {
        allAssets = allAssets.where((asset) => asset.department == department).toList();
      }

      if (assetType != null && assetType.isNotEmpty) {
        allAssets = allAssets.where((asset) => asset.assetType == assetType).toList();
      }

      // Tính toán chỉ số bắt đầu và kết thúc cho trang hiện tại
      final int totalItems = allAssets.length;
      final int startIndex = (page - 1) * pageSize;
      int endIndex = startIndex + pageSize;
      
      // Đảm bảo endIndex không vượt quá độ dài của danh sách
      if (endIndex > totalItems) {
        endIndex = totalItems;
      }

      // Trường hợp trang không hợp lệ
      if (startIndex >= totalItems) {
        return PaginationResult(
          items: [],
          totalItems: totalItems,
          currentPage: page,
          pageSize: pageSize,
        );
      }

      // Lấy dữ liệu cho trang hiện tại
      final List<AssetModel> pagedItems = allAssets.sublist(startIndex, endIndex);

      return PaginationResult(
        items: pagedItems,
        totalItems: totalItems,
        currentPage: page,
        pageSize: pageSize,
      );
    } catch (e) {
      SGLog.error('getAssetsWithPagination', e.toString());
      throw Exception('Không thể lấy dữ liệu phân trang: $e');
    }
  }

  // Tìm kiếm tài sản theo ID
  Future<AssetModel?> getAssetById(String id) async {
    final List<AssetModel> assets = await getAssets();
    try {
      return assets.firstWhere((asset) => asset.id == id);
    } catch (e) {
      return null;
    }
  }

  // Lọc tài sản theo các tiêu chí
  Future<List<AssetModel>> filterAssets({String? searchQuery, String? department, String? assetType}) async {
    List<AssetModel> assets = await getAssets();

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      assets = assets.where((asset) => asset.id.toLowerCase().contains(query) || asset.name.toLowerCase().contains(query)).toList();
    }

    if (department != null && department.isNotEmpty) {
      assets = assets.where((asset) => asset.department == department).toList();
    }

    if (assetType != null && assetType.isNotEmpty) {
      assets = assets.where((asset) => asset.assetType == assetType).toList();
    }

    return assets;
  }
}
