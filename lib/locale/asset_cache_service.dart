import 'package:idb_shim/idb_browser.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/repository/asset_management_repository.dart';

class AssetListCacheService {
  static const String dbName = "asset_cache_db";
  static const String storeName = "asset_list_store";
  static const String listKey = "asset_list";

  static Future<Database>? _dbFuture;

  /// CHỈ MỞ DB 1 LẦN DUY NHẤT
  static Future<Database> _openDb() {
    _dbFuture ??= _initDb();
    return _dbFuture!;
  }

  static Future<Database> _initDb() async {
    final idbFactory = getIdbFactory();

    return await idbFactory!.open(
      dbName,
      version: 1,
      onUpgradeNeeded: (VersionChangeEvent event) {
        final db = event.database;
        if (!db.objectStoreNames.contains(storeName)) {
          db.createObjectStore(storeName);
        }
      },
    );
  }

  /// Lưu cả danh sách
  static Future<void> saveAssetList(List<Map<String, dynamic>> list) async {
    final db = await _openDb();
    final txn = db.transaction(storeName, idbModeReadWrite);
    await txn.objectStore(storeName).put(list, listKey);
    await txn.completed;
  }

  /// Lấy list asset từ cache
  static Future<List<Map<String, dynamic>>> getAssetList() async {
    final db = await _openDb();
    final txn = db.transaction(storeName, idbModeReadOnly);
    final data = await txn.objectStore(storeName).getObject(listKey);
    await txn.completed;

    if (data is List) {
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }

  static Future<bool> hasAssetList() async {
    final list = await getAssetList();
    return list.isNotEmpty;
  }

  static Future<void> clear() async {
    final db = await _openDb();
    final txn = db.transaction(storeName, idbModeReadWrite);
    await txn.objectStore(storeName).delete(listKey);
    await txn.completed;
  }

  /// Load nhanh: lấy cache → gọi API song song
  Future<List<AssetManagementDto>> loadAssetList() async {
    /// Lấy từ cache trước
    final cachedList = await getAssetList();

    if (cachedList.isNotEmpty) {
      print(
        "AssetListCacheService:👉 Loaded from cache: ${cachedList.length} items",
      );
    }

    /// Gọi API song song (không chờ)
    AssetManagementRepository().getListAssetManagement('ct001').then((
      fresh,
    ) async {
      // Convert List<AssetManagementDto> to List<Map<String, dynamic>>
      final freshData = fresh['data'] as List<dynamic>;
      final freshList = freshData
          .map((item) {
            if (item is AssetManagementDto) {
              return item.toJson();
            } else if (item is Map<String, dynamic>) {
              return item;
            } else if (item is Map) {
              return Map<String, dynamic>.from(item);
            } else {
              return <String, dynamic>{};
            }
          })
          .where((map) => map.isNotEmpty)
          .toList();

      await saveAssetList(freshList);

      print(
        "AssetListCacheService:🔥 API loaded & cached again: ${freshList.length} items",
      );
    });

    /// Trả về cache ngay lập tức
    return cachedList.map((e) => AssetManagementDto.fromJson(e)).toList();
  }
}
