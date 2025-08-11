import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/app.dart';
import 'package:quan_ly_tai_san_app/core/utils/app_bloc_observer.dart';
import 'package:quan_ly_tai_san_app/injection.dart' as di;
import 'package:quan_ly_tai_san_app/locale/locale_controller.dart';
import 'package:se_gay_components/base_api/api_config.dart';
import 'package:intl/date_symbol_data_local.dart';

class Config {
  static const String environment = "dev";

  static String get baseUrl {
    switch (environment) {
      case 'dev':
        return 'http://103.112.211.148:8443';
      default:
        return 'https://ecotel-odoo.id.vn:8386';
    }
  }
}

void main() async {
  ApiConfig.setBaseURL(Config.baseUrl);
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
