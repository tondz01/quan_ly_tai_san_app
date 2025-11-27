import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/reponsitory/permission_sign_service.dart';
import 'package:quan_ly_tai_san_app/core/constants/function_type.dart';
import 'package:quan_ly_tai_san_app/core/utils/bloc_providers.dart';
import 'package:quan_ly_tai_san_app/core/utils/providers.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/injection.dart';
import 'package:quan_ly_tai_san_app/locale/locale_controller.dart';
import 'package:quan_ly_tai_san_app/message/message_providers.dart';
import 'package:quan_ly_tai_san_app/routes/app_route_conf.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/repository/asset_handover_repository.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/repository/asset_management_repository.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/asset_transfer_reponsitory.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/repository/auth_repository.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/repository/tool_and_material_transfer_reponsitory.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/repository/tool_and_supplies_handover_repository.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/repository/tools_and_supplies_repository.dart';
import 'package:se_gay_components/common/sg_popup_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  final permissionSignService = PermissionSignService();
  late ProviderSubscription<Map<String, dynamic>?> _messageSub;
  @override
  void initState() {
    super.initState();
    // _loadDataIfNeeded(userInfo);
    // permissionSignService.startCheckingPermission();
    // onReloadCount(context, ref); // Commented out because 'ref' is undefined in this context
    // permissionSignService.stream.listen((data) {
    //   AccountHelper.refreshAllCounts();
    // });
    AuthRepository().loadData('ct001');
    _messageSub = ref.listenManual(messageLatestJsonProvider, (
      previous,
      next,
    ) async {
      if (next == null || next.isEmpty) return;
      log('message [ref.listen] [App] Nhận realtime: $next');
      if (AppUtility.userInList(
        AccountHelper.instance.getUserInfo()?.tenDangNhap ?? '',
        next['id_need_to_do'] ?? '',
      )) {
        if (next['type_func'] == FunctionType.ASSET_TRANSFER) {
          await AssetTransferRepository().getListDieuDongTaiSan();
        } else if (next['type_func'] == FunctionType.ASSET_HANDOVER) {
          await AssetHandoverRepository().getListAssetHandover();
        } else if (next['type_func'] ==
            FunctionType.TOOL_AND_MATERIAL_TRANSFER) {
          await ToolAndMaterialTransferRepository()
              .getAllToolAndMeterialTransfer(-1);
        } else if (next['type_func'] ==
            FunctionType.TOOL_AND_SUPPLIES_HANDOVER) {
          await ToolAndSuppliesHandoverRepository()
              .getListToolAndSuppliesHandover();
        }
        AccountHelper.refreshAllCounts();
      } else {
        log('[App] Bỏ qua realtime vì user không nằm trong danh sách cần xử lý');
      }
    });
    getDataAssetAndCCDC();
  }

  @override
  void dispose() {
    _messageSub.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = locator<AppRouteConf>().router;
    return MultiBlocProvider(
      providers: blocProvider,
      child: MultiProvider(
        providers: providers,
        child: GestureDetector(
          onTap: () {
            primaryFocus?.unfocus();
            FocusScope.of(context).unfocus();
            SGPopupManager().closeAllPopups();
          },
          child: GetMaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Quan Ly Tai San',
            theme: ThemeData.light(),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('vi', 'VN'), Locale('en', 'US')],
            locale: const Locale('vi', 'VN'),
            fallbackLocale: const Locale('en', 'US'),
            translations: MyLocale(),
            routerDelegate: router.routerDelegate,
            routeInformationParser: router.routeInformationParser,
            routeInformationProvider: router.routeInformationProvider,
          ),
        ),
      ),
    );
  }

  // Future<void> _loadDataIfNeeded(UserInfoDTO userInfo) async {
  //   log('message test: _loadDataIfNeeded');
  //   if (userInfo.idCongTy.isNotEmpty) {
  //     log('message test: _loadDataIfNeeded 2');
  //     await AuthRepository().loadData(userInfo.idCongTy);
  //   }
  // }

  void getDataAssetAndCCDC() {
    if (AccountHelper.instance.getAllAssets().isEmpty) {
      AssetManagementRepository().getListAssetManagement('ct001');
    }

    if (AccountHelper.instance.getAllCCDC().isEmpty) {
      ToolsAndSuppliesRepository().getListToolsAndSupplies('ct001');
    }

    if (AccountHelper.instance.getAllCapitalSource().isEmpty) {
      AssetManagementRepository().getListCapitalSource('ct001');
    }

    if (AccountHelper.instance.getAllProject().isEmpty) {
      AssetManagementRepository().getListDuAn('ct001');
    }
  }
}
