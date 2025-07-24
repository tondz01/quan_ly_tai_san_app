import 'package:get_it/get_it.dart';
import 'package:quan_ly_tai_san_app/routes/app_route_conf.dart';

final locator = GetIt.I;

Future<void> init() async {
  // Routes
  locator.registerLazySingleton<AppRouteConf>(() => AppRouteConf());
}
