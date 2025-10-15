import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static const String environment = "dev";

  static const String appVersion = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '${environment}_0.0.1',
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

  await dotenv.load(fileName: '.env', isOptional: true);
  ApiConfig.setBaseURL(Config.baseUrl);
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'vi_VN';
  await initializeDateFormatting('vi');
  await initializeDateFormatting('vi_VN');
  await di.init();
  Bloc.transformer = bloc_concurrency.sequential();
  Bloc.observer = const AppBlocObserver();

  // Inicializar GetX
  Get.put(MyLocale());

  runApp(App());
}
