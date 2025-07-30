import 'package:quan_ly_tai_san_app/screen/asset_handover/asset_handover_view.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/asset_transfer_view.dart';
import 'package:quan_ly_tai_san_app/screen/home/exemple/exemple_screen_1.dart';
import 'package:quan_ly_tai_san_app/screen/home/exemple/exemple_screen_2.dart';
import 'package:quan_ly_tai_san_app/screen/home/exemple/exemple_screen_3.dart';
import 'package:quan_ly_tai_san_app/screen/home/exemple/exemple_screen_4.dart';
import 'package:quan_ly_tai_san_app/screen/home/home.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/tools_and_supplies_view.dart';

import 'routes.dart';

class AppRouteConf {
  GoRouter get router => _router;

  late final _router = GoRouter(
    initialLocation: AppRoute.exemple.path,
    debugLogDiagnostics: true,
    errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return Home(child: child);
        },
        routes: [
          GoRoute(path: AppRoute.exemple.path, redirect: (_, __) => AppRoute.exemple1.path),
          GoRoute(path: AppRoute.exemple1.path, name: AppRoute.exemple1.name, pageBuilder: (context, state) => NoTransitionPage(key: state.pageKey, child: const ExempleScreen1())),
          GoRoute(path: AppRoute.exemple2.path, name: AppRoute.exemple2.name, pageBuilder: (context, state) => NoTransitionPage(key: state.pageKey, child: const ExempleScreen2())),
          GoRoute(path: AppRoute.exemple3.path, name: AppRoute.exemple3.name, pageBuilder: (context, state) => NoTransitionPage(key: state.pageKey, child: const ExempleScreen3())),
          GoRoute(
            path: AppRoute.exemple4.path,
            name: AppRoute.exemple4.name,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ExempleScreen4(),
            ),
          ),
          GoRoute(
            path: AppRoute.toolsAndSupplies.path,
            name: AppRoute.toolsAndSupplies.name,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ToolsAndSuppliesView(),
            ),
          ),
          GoRoute(
            path: AppRoute.assetTransfer.path,
            name: AppRoute.assetTransfer.name,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: AssetTransferView(
                typeAssetTransfer: state.extra != null && state.extra is String
                    ? int.tryParse(state.extra as String) ?? 0
                    : 0,
              ),
            ),
          ),
            GoRoute(
              path: AppRoute.assetHandover.path,
              name: AppRoute.assetHandover.name,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const AssetHandoverView(),
              ),
            ),
          // GoRoute(
          //   name: AppRoute.liveVideoVar.name,
          //   pageBuilder: (_, __) => const NoTransitionPage(child: LiveVideoV2Page()),
          // ),
        ],
      ),
    ],
  );
}
