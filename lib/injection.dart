import 'package:get_it/get_it.dart';
import 'package:quan_ly_tai_san_app/routes/app_route_conf.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/asset/repository/asset_repository.dart';

final locator = GetIt.I;

Future<void> init() async {
  locator.registerLazySingleton<AssetRepository>(() => AssetRepository());
  // Routes
  locator.registerLazySingleton<AppRouteConf>(() => AppRouteConf());
}
