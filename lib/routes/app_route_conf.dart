import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/asset_management_view.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/asset_category_view.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/asset_group_view.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/asset_handover_view.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/asset_transfer_view.dart';
import 'package:quan_ly_tai_san_app/screen/category/asset/views/asset_manager.dart';
import 'package:quan_ly_tai_san_app/screen/category/capital_source/views/capital_source_manager.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/views/department_manager.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/views/project_manager.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/views/staff_manager.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/dashboard_screen.dart';
import 'package:quan_ly_tai_san_app/screen/home/exemple/exemple_screen_1.dart';
import 'package:quan_ly_tai_san_app/screen/home/exemple/exemple_screen_2.dart';
import 'package:quan_ly_tai_san_app/screen/home/exemple/exemple_screen_3.dart';
import 'package:quan_ly_tai_san_app/screen/home/exemple/exemple_screen_4.dart';
import 'package:quan_ly_tai_san_app/screen/home/home.dart';
import 'package:quan_ly_tai_san_app/screen/login/login_view.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/tool_and_material_transfer_view.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/tools_and_supplies_view.dart';

import 'routes.dart';

class AppRouteConf {
  GoRouter get router => _router;
  late final _router = GoRouter(
    initialLocation: AppRoute.login.path,
    debugLogDiagnostics: true,
    errorBuilder: (context, state) => const NotFoundScreen(),
    routes: [
      GoRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        pageBuilder: (context, state) => NoTransitionPage(child: LoginView()),
      ),
      ShellRoute(
        builder: (context, state, child) {
          log('message child: $child');
          return Home(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoute.dashboard.path,
            name: AppRoute.dashboard.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const DashboardScreen(),
                ),
          ),
          GoRoute(
            path: AppRoute.exemple.path,
            redirect: (_, __) => AppRoute.exemple1.path,
          ),
          GoRoute(
            path: AppRoute.exemple1.path,
            name: AppRoute.exemple1.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const ExempleScreen1(),
                ),
          ),
          GoRoute(
            path: AppRoute.exemple2.path,
            name: AppRoute.exemple2.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const ExempleScreen2(),
                ),
          ),
          GoRoute(
            path: AppRoute.exemple3.path,
            name: AppRoute.exemple3.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const ExempleScreen3(),
                ),
          ),
          GoRoute(
            path: AppRoute.exemple4.path,
            name: AppRoute.exemple4.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const ExempleScreen4(),
                ),
          ),
          GoRoute(
            path: AppRoute.toolsAndSupplies.path,
            name: AppRoute.toolsAndSupplies.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const ToolsAndSuppliesView(),
                ),
          ),
          GoRoute(
            path: AppRoute.assetTransfer.path,
            name: AppRoute.assetTransfer.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: AssetTransferView(
                    typeAssetTransfer:
                        state.extra != null && state.extra is String
                            ? int.tryParse(state.extra as String) ?? 0
                            : 0,
                  ),
                ),
          ),
          GoRoute(
            path: AppRoute.assetHandover.path,
            name: AppRoute.assetHandover.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const AssetHandoverView(),
                ),
          ),
          GoRoute(
            path: AppRoute.staffManager.path,
            name: AppRoute.staffManager.name,
            pageBuilder:
                (context, state) =>
                    NoTransitionPage(key: state.pageKey, child: StaffManager()),
          ),
          GoRoute(
            path: AppRoute.projectManager.path,
            name: AppRoute.projectManager.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: ProjectManager(),
                ),
          ),
          GoRoute(
            path: AppRoute.departmentManager.path,
            name: AppRoute.departmentManager.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: DepartmentManager(),
                ),
          ),
          GoRoute(
            path: AppRoute.capitalSource.path,
            name: AppRoute.capitalSource.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: CapitalSourceManager(),
                ),
          ),
          GoRoute(
            path: AppRoute.assetManager.path,
            name: AppRoute.assetManager.name,
            pageBuilder:
                (context, state) =>
                    NoTransitionPage(key: state.pageKey, child: AssetManager()),
          ),
          GoRoute(
            path: AppRoute.toolAndMaterialTransfer.path,
            name: AppRoute.toolAndMaterialTransfer.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: ToolAndMaterialTransferView(),
                ),
          ),
          GoRoute(
            path: AppRoute.assetGroup.path,
            name: AppRoute.assetGroup.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: AssetGroupView(),
                ),
          ),
          GoRoute(
            path: AppRoute.assetManagement.path,
            name: AppRoute.assetManagement.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: AssetManagementView(),
                ),
          ),
          GoRoute(
            path: AppRoute.assetCategory.path,
            name: AppRoute.assetCategory.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: AssetCategoryView(),
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
