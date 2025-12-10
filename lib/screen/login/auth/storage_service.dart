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
          final encodedBytes = encoded.length;
          // Leave some headroom under the typical 5MB limit
          const maxBytes = 4 * 1024 * 1024; // 4MB
          if (encodedBytes > maxBytes) {
            // IMPROVED: Try to free up space by removing old/large keys
            print('WARNING: Data too large for key "$key": ${(encodedBytes / 1024 / 1024).toStringAsFixed(2)}MB');

            // Strategy 1: Clear old heavy keys first
            final heavyKeys = [
              StorageKey.ASSETS,
              StorageKey.CCDC_VT,
              StorageKey.ASSET_TRANSFER,
              StorageKey.ASSET_HANDOVER,
            ];

            for (var heavyKey in heavyKeys) {
              if (heavyKey != key && storage.hasData(heavyKey)) {
                print('Clearing heavy key "$heavyKey" to free up space');
                await storage.remove(heavyKey);
              }
            }

            // Strategy 2: Try writing again
            try {
              await storage.write(key, value);
              print('✓ Successfully wrote "$key" after clearing space');
              return;
            } catch (retryError) {
              print('✗ Still failed after cleanup. Data will not be cached for "$key"');
              return;
            }
          } else {
            print('StorageService.write: key "$key" - size: ${(encodedBytes / 1024 / 1024).toStringAsFixed(2)}MB');
          }
        } catch (e) {
          // If value isn't JSON encodable, proceed and let storage handle it
          print('StorageService.write: JSON encode error for key "$key": $e');
        }
      }
      await storage.write(key, value);
      print('StorageService.write: Successfully wrote key "$key"');
    } catch (e) {
      // Quota exceeded error - try emergency cleanup
      if (e.toString().contains('QuotaExceededError') ||
          e.toString().contains('quota') ||
          e.toString().contains('QUOTA')) {
        print('QUOTA EXCEEDED: Attempting emergency cleanup...');

        // Emergency: Clear ALL cache except user data
        final criticalKeys = [
          StorageKey.USER_INFO,
          StorageKey.AUTH_INFO,
          StorageKey.TOKEN,
          StorageKey.REMEMBER_LOGIN,
        ];

        // Get all keys and clear non-critical ones
        final allKeys = storage.getKeys();
        for (var existingKey in allKeys) {
          if (!criticalKeys.contains(existingKey)) {
            await storage.remove(existingKey);
          }
        }

        print('Emergency cleanup done. Trying write again...');
        try {
          await storage.write(key, value);
          print('✓ Write successful after emergency cleanup');
        } catch (finalError) {
          print('✗ FINAL FAILURE: Cannot write "$key" even after cleanup: $finalError');
        }
      } else {
        print('ERROR: StorageService.write failed for key "$key": $e');
      }
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
  static const NGUON_KINH_PHI = "NGUON_KINH_PHI";
  static const DU_AN = "DU_AN";
}