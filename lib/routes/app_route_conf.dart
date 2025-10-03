import 'package:quan_ly_tai_san_app/screen/reason_increase/reason_increase_view.dart';
import 'package:quan_ly_tai_san_app/screen/unit/unit_view.dart';

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
                  child: const DashboardView(),
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
                  child: AssetTransferView(),
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
            path: AppRoute.toolAndSuppliesHandover.path,
            name: AppRoute.toolAndSuppliesHandover.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const ToolAndSuppliesHandoverView(),
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
                  child: BienBanKiemKeScreen(),
                ),
          ),
          GoRoute(
            path: AppRoute.bienBanKiemKeCcdc.path,
            name: AppRoute.bienBanKiemKeCcdc.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: BienBanKiemKeCcdcScreen(),
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
          GoRoute(
            path: AppRoute.role.path,
            name: AppRoute.role.name,
            pageBuilder:
                (context, state) =>
                    NoTransitionPage(key: state.pageKey, child: RoleView()),
          ),
          GoRoute(
            path: AppRoute.ccdcGroup.path,
            name: AppRoute.ccdcGroup.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: CcdcGroupView(),
                ),
          ),
          GoRoute(
            path: AppRoute.loaiCcdc.path,
            name: AppRoute.loaiCcdc.name,
            pageBuilder:
                (context, state) =>
                    NoTransitionPage(key: state.pageKey, child: TypeCcdcView()),
          ),
          GoRoute(
            path: AppRoute.loaiTaiSan.path,
            name: AppRoute.loaiTaiSan.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: TypeAssetView(),
                ),
          ),
          GoRoute(
            path: AppRoute.unit.path,
            name: AppRoute.unit.name,
            pageBuilder:
                (context, state) =>
                    NoTransitionPage(key: state.pageKey, child: UnitView()),
          ),
          GoRoute(
            path: AppRoute.reasonIncrease.path,
            name: AppRoute.reasonIncrease.name,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: ReasonIncreaseView(),
                ),
          ),
        ],
      ),
    ],
  );
}
