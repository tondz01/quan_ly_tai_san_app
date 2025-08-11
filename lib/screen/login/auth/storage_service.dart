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
}