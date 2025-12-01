import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/app.dart';
import 'package:quan_ly_tai_san_app/core/utils/app_bloc_observer.dart';
import 'package:quan_ly_tai_san_app/injection.dart' as di;
import 'package:get_storage/get_storage.dart';
import 'package:quan_ly_tai_san_app/locale/locale_controller.dart';
import 'package:se_gay_components/base_api/api_config.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:dynamic_path_url_strategy/dynamic_path_url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';

class Config {
  static const String environment = "prd";

  static const String appVersion = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '${environment}_0.1.0_01/12/2025',
  );
  static const String appBuild = String.fromEnvironment(
    'APP_BUILD',
    defaultValue: '1',
  );

  static String get baseUrl {
    switch (environment) {
      case 'dev':
        return 'https://ecotel-odoo.id.vn:8386';
      default:
        return 'http://42.119.110.246:8386';
    }
  }
}

void main() async {
  // Bỏ dấu # trên web
  if (kIsWeb) {
    setPathUrlStrategy();
  }

  ApiConfig.setBaseURL(Config.baseUrl);
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'vi_VN';
  await initializeDateFormatting('vi');
  await initializeDateFormatting('vi_VN');
  await di.init();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyA1ao20BuCfBbjROooGzn_qbO8x3XJoFHU",
      authDomain: "quanlyphuongtien-22dd4.firebaseapp.com",
      databaseURL: "https://quanlyphuongtien-22dd4-default-rtdb.firebaseio.com",
      projectId: "quanlyphuongtien-22dd4",
      storageBucket: "quanlyphuongtien-22dd4.appspot.com",
      messagingSenderId: "51589792579",
      appId: "1:51589792579:web:23c1d200f54a3dcb5ba5f6",
      measurementId: "G-MJ8V6TWTD6",
    ),
  );
  FirebaseDatabase.instance;
  Bloc.transformer = bloc_concurrency.sequential();
  Bloc.observer = const AppBlocObserver();

  // Inicializar GetX
  Get.put(MyLocale());

  runApp(const ProviderScope(child: App()));
}
