import 'package:quan_ly_tai_san_app/screen/asset_management/asset_management_view.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/asset_category_view.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/asset_group_view.dart';

// import 'package:quan_ly_tai_san_app/screen/asset_handover/asset_handover_view.dart';
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
import 'package:quan_ly_tai_san_app/screen/login/account_view.dart';
import 'package:quan_ly_tai_san_app/screen/report/views/bien_ban_doi_chieu_page.dart';
import 'package:quan_ly_tai_san_app/screen/report/views/bien_ban_kiem_ke_page.dart';
import 'package:quan_ly_tai_san_app/screen/report/views/so_tai_san_co_dinh.dart';
import 'package:quan_ly_tai_san_app/screen/report/views/so_tai_san_co_dinh_200.dart';
import 'package:quan_ly_tai_san_app/screen/report/views/so_theo_doi.dart';
import 'package:quan_ly_tai_san_app/screen/report/widget/bien_ban_doi_chieu_screen.dart';
import 'package:quan_ly_tai_san_app/screen/report/widget/report_screen.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/tool_and_material_transfer_view.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/tools_and_supplies_view.dart';

import '../screen/asset_handover/asset_handover_view.dart';
import '../screen/report/widget/bien_ban_kiem_ke_screen.dart';
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
                  child: ToolAndMaterialTransferView(
                    typeAssetTransfer:
                        state.extra != null && state.extra is String
                            ? int.tryParse(state.extra as String) ?? 0
                            : 0,
                  ),
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

          GoRoute(
            path: AppRoute.fixedAssetRegister.path,
            name: AppRoute.fixedAssetRegister.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: SoTaiSanCoDinh(),
                ),
          ),
          GoRoute(
            path: AppRoute.fixedAssetRegisterCircular200.path,
            name: AppRoute.fixedAssetRegisterCircular200.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: SoTaiSanCoDinh200(),
                ),
          ),
          GoRoute(
            path: AppRoute.trackingRecord.path,
            name: AppRoute.trackingRecord.name,
            pageBuilder:
                (context, state) =>
                    NoTransitionPage(key: state.pageKey, child: SoTheoDoi()),
          ),
          GoRoute(
            path: AppRoute.account.path,
            name: AppRoute.account.name,
            pageBuilder:
                (context, state) =>
                    NoTransitionPage(key: state.pageKey, child: AccountView()),
          ),
          GoRoute(
            path: AppRoute.allocationReport.path,
            name: AppRoute.allocationReport.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: ReportScreen(idCongty: 'CT001', loai: 1),
                ),
          ),
          GoRoute(
            path: AppRoute.transferReport.path,
            name: AppRoute.transferReport.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: ReportScreen(idCongty: 'CT001', loai: 2),
                ),
          ),
          GoRoute(
            path: AppRoute.recoveryReport.path,
            name: AppRoute.recoveryReport.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: ReportScreen(idCongty: 'CT001', loai: 3),
                ),
          ),
          GoRoute(
            path: AppRoute.bienBanKiemKe.path,
            name: AppRoute.bienBanKiemKe.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: BienBanKiemKeScreen(idCongty: 'CT001'),
                ),
          ),
          GoRoute(
            path: AppRoute.bienBanDoiChieu.path,
            name: AppRoute.bienBanDoiChieu.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: BienBanDoiChieuScreen(idCongty: "CT001"),
                ),
          ),
        ],
      ),
    ],
  );
}
