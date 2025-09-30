// ignore_for_file: constant_identifier_names

import 'package:get_storage/get_storage.dart';


class StorageService {
  static final storage = GetStorage();

  static void init() async {
    await GetStorage.init();
  }

  static Future<bool> hasData(String key) async {
    return storage.hasData(key);
  }

  static dynamic read(String key) {
    return storage.read(key);
  }

  static Future<void> write(String key, dynamic value) async {
    await storage.write(key, value);
  }

  static Future<void> remove(String key) async {
    print('Removing $key from local storage');
    await storage.remove(key);
  }

  static Future<void> erase() async {
    await storage.erase();
  }
}

class StorageKey {
  static const USER_INFO = 'user_info';
  static const AUTH_INFO = 'auth_info';
  static const TOKEN = 'token';
  static const FIREBASE_TOKEN = 'fcmToken';
  static const LANGUAGE = 'currentLang';
  static const DEVICE_ID = 'deviceId';
  static const VERSION = 'version';
  static const APP_VERSION = 'app_version';
  static const BUILD_NUMBER = 'buildNumber';
  static const REMEMBER_LOGIN = 'remember_login';
  static const DEPARTMENT = 'department';
  static const NHAN_VIEN = 'nhan_vien';
  static const CHUC_VU = 'chuc_vu';
  static const ASSET_TRANSFER = 'asset_transfer';
  static const ASSET_HANDOVER = 'asset_handover';
  static const TOOL_AND_MATERIAL_TRANSFER = 'tool_and_material_transfer';
  static const TOOL_AND_MATERIAL_TRANSFER_HANDOVER = 'tool_and_material_transfer_handover';
  static const CONFIG_TIME_EXPIRE = 'config_time_expire';
  static const ROLES_KEY = "USER_ROLES";
  static const ASSET_GROUP = "ASSET_GROUP";
  static const CCDC_GROUP = "CCDC_GROUP";
  static const TYPE_ASSET = "TYPE_ASSET";
  static const TYPE_CCDCV = "TYPE_CCDCV";
  static const ASSET_CATEGORY = "ASSET_CATEGORY";
  static const UNIT = "UNIT";
}