import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/reponsitory/permission_sign_service.dart';
import 'package:quan_ly_tai_san_app/core/constants/function_type.dart';
import 'package:quan_ly_tai_san_app/core/utils/bloc_providers.dart';
import 'package:quan_ly_tai_san_app/core/utils/cross_tab_auth_service.dart';
import 'package:quan_ly_tai_san_app/core/utils/providers.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/injection.dart';
import 'package:quan_ly_tai_san_app/locale/asset_cache_service.dart';
import 'package:quan_ly_tai_san_app/locale/locale_controller.dart';
import 'package:quan_ly_tai_san_app/message/message_providers.dart';
import 'package:quan_ly_tai_san_app/routes/app_route_conf.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/repository/asset_handover_repository.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/repository/asset_management_repository.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/asset_transfer_reponsitory.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/repository/auth_repository.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/repository/tool_and_material_transfer_reponsitory.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/repository/tool_and_supplies_handover_repository.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/repository/tools_and_supplies_repository.dart';
import 'package:quan_ly_tai_san_app/core/services/count_service.dart';
import 'package:se_gay_components/common/sg_popup_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
  
  /// Reset flag để đảm bảo lần login tiếp theo sẽ load lại counts
  static void resetCountsLoadedFlag() {
    _AppState._isCountsLoaded = false;
  }
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  final permissionSignService = PermissionSignService();
  ProviderSubscription<Map<String, dynamic>?>? _messageSub;
  
  // Static flags để tránh gọi lại nhiều lần khi reload trang (web)
  static bool _isDataLoaded = false;
  static bool _isInitialDataLoaded = false;
  static bool _isListenerSetup = false;
  static bool _isCountsLoaded = false;
  
  final CountService _countService = CountService();
  
  // Throttle cho realtime message - tăng từ 500ms lên 2000ms
  static DateTime? _lastMessageTime;
  static const _throttleMs = 2000; // 2 giây throttle

  // Track pending messages để skip duplicates
  static final Set<String> _pendingMessages = {};
  
  @override
  void initState() {
    super.initState();
    // _loadDataIfNeeded(userInfo);
    // permissionSignService.startCheckingPermission();
    // onReloadCount(context, ref); // Commented out because 'ref' is undefined in this context
    // permissionSignService.stream.listen((data) {
    //   AccountHelper.refreshAllCounts();
    // });
    _loadDataIfNeeded();
    _setupRealtimeMessageListener();
    _getDataAssetAndCCDCIfNeeded();
    _loadAllCountsIfNeeded();
    // Init CrossTabAuthService để xử lý multi-tab login conflict
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CrossTabAuthService.instance.init(context);
    });
  }

  @override
  void dispose() {
    _messageSub?.close();
    _countService.dispose();
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

  /// Kiểm tra và load dữ liệu nếu chưa được load
  /// Tránh gọi lại loadData nhiều lần khi reload trang
  Future<void> _loadDataIfNeeded() async {
    // Đã load rồi thì bỏ qua (static flag giữ qua reload trên web)
    if (_isInitialDataLoaded) {
      log('message [App] Initial data already loaded (static flag), skipping...');
      return;
    }
    
    // Kiểm tra xem dữ liệu cơ bản đã được load chưa
    final hasDepartment = AccountHelper.instance.getDepartment()?.isNotEmpty ?? false;
    final hasNhanVien = AccountHelper.instance.getNhanVien()?.isNotEmpty ?? false;
    
    // Chỉ load nếu dữ liệu quan trọng chưa có
    if (!hasDepartment || !hasNhanVien) {
      log('message [App] Loading initial data...');
      await AuthRepository().loadData('ct001');
    } else {
      log('message [App] Data already loaded, skipping loadData');
    }
    
    _isInitialDataLoaded = true;
  }

  /// Thiết lập listener cho realtime message
  void _setupRealtimeMessageListener() {
    // Đã setup rồi thì bỏ qua
    if (_isListenerSetup) {
      log('message [App] Realtime listener already setup, skipping...');
      return;
    }
    _isListenerSetup = true;
    
    _messageSub = ref.listenManual(
      messageLatestJsonProvider,
      (previous, next) async {
        await _handleRealtimeMessage(next);
      },
    );
  }

  /// Xử lý realtime message và reload data tương ứng
  Future<void> _handleRealtimeMessage(Map<String, dynamic>? message) async {
    if (message == null || message.isEmpty) return;

    // Throttle: bỏ qua nếu message đến quá nhanh (tăng từ 500ms lên 2s)
    final now = DateTime.now();
    if (_lastMessageTime != null) {
      final diff = now.difference(_lastMessageTime!).inMilliseconds;
      if (diff < _throttleMs) {
        log('[App] Throttle: bỏ qua message (chỉ $diff ms từ message trước, cần $_throttleMs ms)');
        return;
      }
    }

    // Tạo message key để detect duplicates
    final typeFunc = message['type_func'];
    final idNeedToDo = message['id_need_to_do'] ?? '';
    final messageKey = '$typeFunc-$idNeedToDo';

    // Skip nếu đang xử lý message tương tự
    if (_pendingMessages.contains(messageKey)) {
      log('[App] Skip duplicate message: $messageKey');
      return;
    }

    _lastMessageTime = now;
    _pendingMessages.add(messageKey);

    try {
      log('message [ref.listen] [App] Nhận realtime: $message');

      final userInfo = AccountHelper.instance.getUserInfo();
      final userTenDangNhap = userInfo?.tenDangNhap ?? '';

      // Kiểm tra xem user có trong danh sách cần xử lý không
      if (!AppUtility.userInList(userTenDangNhap, idNeedToDo)) {
        log('[App] Bỏ qua realtime vì user không nằm trong danh sách cần xử lý');
        return;
      }

      // Xử lý reload data dựa trên type_func (không await để không block)
      await _reloadDataByFunctionType(typeFunc);

      // Refresh counts sau khi reload - chỉ gọi 1 lần
      AccountHelper.refreshAllCounts();
      
      // Debounce load counts để tránh call quá nhiều lần
      _countService.debouncedLoadAllCounts();
    } finally {
      // Remove from pending sau 1 giây để allow retry nếu cần
      Future.delayed(const Duration(seconds: 1), () {
        _pendingMessages.remove(messageKey);
      });
    }
  }

  /// Reload data dựa trên function type
  Future<void> _reloadDataByFunctionType(dynamic typeFunc) async {
    if (typeFunc == null) return;

    // Chuyển đổi typeFunc sang int nếu là String
    final int? functionType = typeFunc is int
        ? typeFunc
        : typeFunc is String
            ? int.tryParse(typeFunc)
            : null;

    if (functionType == null) {
      log('[App] Invalid function type: $typeFunc');
      return;
    }

    switch (functionType) {
      case FunctionType.ASSET_TRANSFER:
        await AssetTransferRepository().getListDieuDongTaiSan();
        break;
      case FunctionType.ASSET_HANDOVER:
        await AssetHandoverRepository().getListAssetHandover();
        break;
      case FunctionType.TOOL_AND_MATERIAL_TRANSFER:
        await ToolAndMaterialTransferRepository()
            .getAllToolAndMeterialTransfer(-1);
        break;
      case FunctionType.TOOL_AND_SUPPLIES_HANDOVER:
        await ToolAndSuppliesHandoverRepository()
            .getListToolAndSuppliesHandover();
        break;
      default:
        log('[App] Unknown function type: $functionType');
    }
  }

  Future<void> _getDataAssetAndCCDCIfNeeded() async {
    // Nếu đã load rồi thì bỏ qua
    if (_isDataLoaded) {
      log('message [App] Asset & CCDC data already loaded, skipping...');
      return;
    }
    
    _isDataLoaded = true;
    await getDataAssetAndCCDC();
  }

  Future<void> getDataAssetAndCCDC() async {
    List<AssetManagementDto> listAsset = [];
    listAsset = await AssetListCacheService().loadAssetList();
    if (listAsset.isEmpty) {
      AssetManagementRepository().getListAssetManagement('ct001');
    }
    // AssetListCacheService().loadAssetList();

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

  /// Load tất cả counts cho các biên bản khi vào màn hình
  /// Chỉ load sau khi user đã đăng nhập
  /// Mỗi lần login sẽ load lại counts
  Future<void> _loadAllCountsIfNeeded({bool force = false}) async {
    // Kiểm tra user đã đăng nhập chưa
    final userInfo = AccountHelper.instance.getUserInfo();
    final userId = userInfo?.tenDangNhap ?? '';
    
    if (userId.isEmpty) {
      log('[App] User not logged in yet, skip loading counts');
      _isCountsLoaded = false; // Reset flag để có thể load sau khi đăng nhập
      return;
    }

    // Nếu force = true (khi login), luôn load lại
    // Nếu không force và đã load rồi thì skip
    if (!force && _isCountsLoaded) {
      log('[App] Counts already loaded, skipping...');
      return;
    }

    _isCountsLoaded = true;
    
    // Load bất đồng bộ, không await để không block UI
    _countService.loadAllCounts(force: true).then((counts) {
      log('[App] Loaded all counts: $counts');
    }).catchError((error) {
      log('[App] Error loading counts: $error');
      _isCountsLoaded = false; // Reset để có thể retry
    });
    _loadDataIfNeeded();
  }
  
  
}
