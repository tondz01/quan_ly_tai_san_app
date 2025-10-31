// ignore_for_file: constant_identifier_names

import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';


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
    try {
      if (kIsWeb) {
        // Guard against exceeding localStorage quota (~5MB on many browsers)
        try {
          final encoded = jsonEncode(value);
          // Leave some headroom under the typical 5MB limit
          const maxBytes = 4 * 1024 * 1024; // 4MB
          if (encoded.length > maxBytes) {
            // Skip caching oversized payloads on web to avoid quota errors
            // Consider server-side pagination or lighter caches for these keys
            return;
          }
        } catch (_) {
          // If value isn't JSON encodable, proceed and let storage handle it
        }
      }
      await storage.write(key, value);
    } catch (e) {
      // Best-effort fallback: ignore quota errors to keep app running
      // Optionally, you can erase specific heavy keys before retrying
      // For stability, just swallow here
    }
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
  static const REASON_INCREASE = "REASON_INCREASE";
  static const ASSETS = "ASSETS";
  static const CCDC_VT = "CCDC_VT";
}