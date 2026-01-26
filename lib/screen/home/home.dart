// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quan_ly_tai_san_app/common/components/commom_loading.dart';
import 'package:quan_ly_tai_san_app/common/model/config_dto.dart';
import 'package:quan_ly_tai_san_app/common/reponsitory/config_reponsitory.dart';
import 'package:quan_ly_tai_san_app/common/widgets/gradient_header.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_image.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/routes/app_route_path.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/home/component/popup_setting_expiration_time.dart';
import 'package:quan_ly_tai_san_app/screen/home/utils/calculate_popup_width.dart';
import 'package:quan_ly_tai_san_app/screen/home/utils/menu_prefs.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/provider/login_provider.dart';
import 'package:se_gay_components/common/sg_colors.dart' show SGAppColors;
import 'package:se_gay_components/common/sg_popup_controller.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import 'package:se_gay_components/main_wrapper/index.dart';
import 'package:quan_ly_tai_san_app/screen/chatbot/views/chatbot_floating_button.dart';
import 'models/menu_data.dart';
import 'scroll_controller.dart';

class Home extends StatefulWidget {
  final Widget child;
  const Home({super.key, required this.child});

  @override
  State<Home> createState() => _HomeState();
}

// Global key để truy cập từ bên ngoài
final GlobalKey<_HomeState> homeKey = GlobalKey<_HomeState>();

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  int _selectedSubIndex = 0;
  UserInfoDTO? userInfo;
  late SGPopupManager _popupManager;
  // 🔥 SỬA: Sử dụng singleton instance thay vì tạo mới
  late AppMenuData _menuData;
  // Thêm biến để theo dõi trạng thái của popup
  bool _isPopupOpen = false;

  bool isItemOne = false;
  String messageRefreshData = "Làm mới dữ liệu 'Tài sản' và 'CCDC'";

  void _updateSelectedIndex(int index, int subIndex) {
    if (_selectedIndex != index || _selectedSubIndex != subIndex) {
      setState(() {
        _selectedIndex = index;
        _selectedSubIndex = subIndex;
      });
      // Lưu trạng thái lựa chọn
      MenuPrefs.setSelection(_selectedIndex, _selectedSubIndex);
    }
  }

  @override
  void dispose() {
    // Hủy đăng ký khi widget bị hủy
    _popupManager.removeGlobalListener(_onPopupStateChanged);
    _scrollController.removeListener(_onScrollStateChanged);
    _parentScrollController.removeListener(_onParentScrollChanged);
    _parentScrollController.dispose();
    _scrollDebounceTimer?.cancel();

    // Reset về trạng thái ban đầu
    _selectedIndex = 0;
    _selectedSubIndex = 0;
    _isPopupOpen = false;
    isItemOne = false;

    // Xóa trạng thái đã lưu
    MenuPrefs.clearSelection();

    super.dispose();
  }

  // Callback được gọi khi trạng thái popup thay đổi
  void _onPopupStateChanged() {
    setState(() {
      _isPopupOpen = _popupManager.hasActivePopup;
    });
  }

  List<SGSidebarHorizontalItem> _getItems() {
    // Tạo danh sách items từ model
    return List.generate(_menuData.menuItems.length, (index) {
      final item = _menuData.menuItems[index];

      return SGSidebarHorizontalItem(
        label: item.label,
        icon: item.icon,
        child: item.child,
        isActive: _selectedIndex == item.index,
        popupWidth: calculatePopupWidth(item),
        popupBorderRadius: 4.0,
        buttonEnterColor: Colors.grey.shade100,
        heightButton: 28.0,
        borderRadiusButton: 4.0,
        paddingButton: const EdgeInsets.only(bottom: 4, left: 10, right: 10),
        popupOffsetY: 3.0,
        popupPadding: EdgeInsets.symmetric(
          vertical:
              (item.reportSubItems.isEmpty && item.projectGroups.isEmpty)
                  ? 0
                  : 2,
        ),
        onTap:
            () => setState(() {
              if (item.reportSubItems.isEmpty && item.projectGroups.isEmpty) {
                // Đảm bảo index được dùng là vị trí của item trong mảng
                _selectedIndex = index;
                _selectedSubIndex = 0;
                MenuPrefs.setSelection(_selectedIndex, _selectedSubIndex);
                if (item.route.isNotEmpty) {
                  isItemOne = true;
                  context.go(item.route);
                }
              }
            }),
        subItems: item.reportSubItems.isNotEmpty ? _buildSubItems(index) : null,
        subItemGroups:
            item.projectGroups.isNotEmpty
                ? _buildSubItemGroups(index, item.projectGroups)
                : null,
      );
    });
  }

  // Tạo subItems thông thường từ model
  List<SGSidebarSubItem> _buildSubItems(int parentIndex) {
    // Kiểm tra xem parentIndex có hợp lệ không
    if (parentIndex < 0 || parentIndex >= _menuData.menuItems.length) {
      // Trả về danh sách rỗng nếu index không hợp lệ
      return [];
    }
    return List.generate(
      _menuData.menuItems[parentIndex].reportSubItems.length,
      (subIndex) {
        final subItem =
            _menuData.menuItems[parentIndex].reportSubItems[subIndex];
        return SGSidebarSubItem(
          label: subItem.label,
          child: subItem.child,
          icon: subItem.icon,
          isActive:
              (_selectedIndex == parentIndex && _selectedSubIndex == subIndex),
          onTap:
              () => setState(() {
                _updateSelectedIndex(parentIndex, subIndex);
                _popupManager.closeAllPopups();
                subItem.callback?.call(context);
                if (subItem.route.isNotEmpty) {
                  isItemOne = false;
                  if (subItem.extra?.isNotEmpty ?? false) {
                    context.go('${subItem.route}?type=${subItem.extra}');
                  } else {
                    context.go(subItem.route);
                  }
                }
              }),
        );
      },
    );
  }

  // Tạo subItemGroups có nhóm từ model
  List<SGSubItemGroup> _buildSubItemGroups(
    int parentIndex,
    List<SubMenuGroup> groupData,
  ) {
    // Kiểm tra xem parentIndex có hợp lệ không
    if (parentIndex < 0 || parentIndex >= _menuData.menuItems.length) {
      // Trả về danh sách rỗng nếu index không hợp lệ
      return [];
    }

    return List.generate(groupData.length, (groupIndex) {
      final group = groupData[groupIndex];
      return SGSubItemGroup(
        title: group.title,
        items: List.generate(group.items.length, (itemIndex) {
          final item = group.items[itemIndex];
          final subIndex =
              groupIndex * 100 + itemIndex; // Tạo subIndex duy nhất
          SGLog.debug(
            "Home",
            'Check: ${(_selectedIndex == parentIndex && _selectedSubIndex == subIndex)}',
          );
          return SGSidebarSubItem(
            label: item.label,
            icon: item.icon,
            child: item.child, // 🔥 THÊM DÒNG NÀY
            isActive:
                _selectedIndex == parentIndex && _selectedSubIndex == subIndex,
            onTap:
                () => setState(() {
                  _updateSelectedIndex(parentIndex, subIndex);
                  _popupManager.closeAllPopups();
                  if (item.route.isNotEmpty) {
                    isItemOne = false;
                    if (item.route == AppRoute.toolAndMaterialTransfer.path &&
                        (item.extra?.isNotEmpty ?? false)) {
                      context.go('${item.route}?type=${item.extra}');
                    } else {
                      context.go(item.route, extra: item.extra);
                    }
                  }
                }),
          );
        }),
      );
    });
  }

  late HomeScrollController _scrollController;
  late ScrollController _parentScrollController;
  Timer? _scrollDebounceTimer;
  bool _lastScrollState = true; // Track last state to prevent rapid changes

  @override
  void initState() {
    super.initState();
    _scrollController = HomeScrollController();
    _scrollController.addListener(_onScrollStateChanged);
    _parentScrollController = ScrollController();
    _parentScrollController.addListener(_onParentScrollChanged);

    // Khởi tạo state ban đầu
    _lastScrollState = true;

    // 🔥 SỬA: Sử dụng singleton instance
    _menuData = AppMenuData.instance;
    _popupManager = SGPopupManager();
    _selectedIndex = 0;
    _selectedSubIndex = 0;

    // Khôi phục trạng thái menu đã lưu (web)
    final savedIndex = MenuPrefs.getSelectedIndex();
    final savedSubIndex = MenuPrefs.getSelectedSubIndex();
    if (savedIndex != null) {
      // Ràng buộc trong phạm vi
      if (savedIndex >= 0 && savedIndex < _menuData.menuItems.length) {
        _selectedIndex = savedIndex;
      }
    }
    if (savedSubIndex != null) {
      final hasSubs =
          _menuData.menuItems[_selectedIndex].reportSubItems.isNotEmpty ||
          _menuData.menuItems[_selectedIndex].projectGroups.isNotEmpty;
      if (hasSubs) {
        _selectedSubIndex = savedSubIndex;
      } else {
        _selectedSubIndex = 0;
      }
    }

    // Đăng ký lắng nghe thay đổi trạng thái popup
    _popupManager.addGlobalListener(_onPopupStateChanged);
    userInfo = AccountHelper.instance.getUserInfo();
    if (userInfo == null) {
      // Use addPostFrameCallback to avoid navigation during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go(AppRoute.login.path);
        }
      });
    }
  }

  // Callback khi scroll state thay đổi
  void _onScrollStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  // Callback khi parent scroll thay đổi
  void _onParentScrollChanged() {
    if (!_parentScrollController.hasClients) return;

    // Hủy timer cũ nếu có
    _scrollDebounceTimer?.cancel();

    // Tạo timer mới để debounce
    _scrollDebounceTimer = Timer(const Duration(milliseconds: 100), () {
      _updateScrollState();
    });
  }

  void _updateScrollState() {
    if (!_parentScrollController.hasClients) return;

    final currentPixels = _parentScrollController.position.pixels;
    final maxScrollExtent = _parentScrollController.position.maxScrollExtent;

    // Sử dụng hysteresis để tránh rapid state changes
    const double bottomThreshold =
        20.0; // Phải scroll xuống ít nhất 20px từ bottom
    const double topThreshold = 20.0; // Phải scroll lên ít nhất 20px từ top

    bool shouldParentScroll;

    if (_lastScrollState) {
      // Nếu đang ở state "parent scroll", chỉ chuyển sang "child scroll" khi thực sự ở bottom
      shouldParentScroll = currentPixels < (maxScrollExtent - bottomThreshold);
    } else {
      // Nếu đang ở state "child scroll", chỉ chuyển sang "parent scroll" khi thực sự ở top
      // HOẶC khi parent scroll về 0 (đầu trang)
      shouldParentScroll = currentPixels <= topThreshold;
    }

    // Chỉ thay đổi state khi thực sự cần thiết
    if (_lastScrollState != shouldParentScroll) {
      _lastScrollState = shouldParentScroll;
      _scrollController.setParentScrollState(shouldParentScroll);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _menuData, // 🔥 SỬA: Sử dụng _menuData thay vì tạo mới
      builder: (context, child) {
        // Lấy danh sách items từ model
        final sidebarItems = _getItems();
        return Scaffold(
          key: homeKey, // Thêm key để có thể truy cập từ bên ngoài
          backgroundColor: SGAppColors.neutral0,
          body: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              return true; // Parent xử lý scroll event
            },
            child: SingleChildScrollView(
              controller: _parentScrollController,
              child: Column(
                children: [
                  // Header - ưu tiên cuộn trước
                  GradientHeader(
                    logoPath: AppImage.imageLogo,
                    title: 'PHẦN MỀM QUẢN LÝ TÀI SẢN',
                    onLogoTap: () {
                      // Handle logo tap if needed
                    },
                  ),
                  Container(
                    height: 64,
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF009E60),
                          Color(0xFF026E42),
                          Color(0xFF026E42),
                        ],
                      ),
                      border: const Border(
                        top: BorderSide(color: Colors.white, width: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child:
                              sidebarItems.isNotEmpty
                                  ? SGSidebarHorizontal(
                                    items: sidebarItems,
                                    onShowSubItems: (subItems) {
                                      setState(() {});
                                    },
                                  )
                                  : const SizedBox.shrink(),
                        ),
                        const SizedBox(width: 16),
                        userInfo != null
                            ? _buildHeaderActionRight(userInfo!)
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),

                  // Body - chỉ cuộn khi header đã cuộn hết
                  Container(
                    height: MediaQuery.of(context).size.height - 64,
                    decoration: BoxDecoration(color: ColorValue.neutral50),
                    child: Stack(
                      children: [
                        // Content
                        widget.child,
                        // Thêm barrier chỉ hiển thị khi popup đang mở
                        if (_isPopupOpen && !isItemOne)
                          Positioned.fill(
                            child: GestureDetector(
                              onTap: () {
                                primaryFocus?.unfocus();
                                FocusScope.of(context).unfocus();
                                _popupManager.closeAllPopups();
                              },
                              behavior: HitTestBehavior.translucent,
                              child: Container(color: Colors.transparent),
                            ),
                          ),
                        // Chatbot floating button
                        const ChatbotFloatingButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserInfo(UserInfoDTO userInfo) {
    String info = '';
    if (userInfo.tenDangNhap == 'admin') {
      info = 'Admin';
    } else {
      NhanVien? nhanVien = AccountHelper.instance.getNhanVienById(
        userInfo.tenDangNhap,
      );
      info = '${nhanVien?.hoTen} - ${nhanVien?.id}';
    }
    return SGText(
      text: info.toUpperCase(),
      color: ColorValue.background,
      size: 14,
    );
  }

  Widget _buildHeaderActionRight(UserInfoDTO userInfo) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildUserInfo(userInfo),
        const SizedBox(width: 16),
        // Settings button
        PopupMenuButton<String>(
          tooltip: 'Quản lý hệ thống',
          position: PopupMenuPosition.under,
          color: Colors.white,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: ColorValue.primaryLightBlue,
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(AppImage.imageUser),
              backgroundColor: Colors.white,
            ),
          ),
          itemBuilder:
              (context) => [
                PopupMenuItem(child: _buildInfoAvatar()),
                PopupMenuItem(
                  value: 'profile',
                  child: _buildAvatarMenuOption(
                    'Quản lý tài khoản',
                    Icons.person,
                  ),
                ),
                PopupMenuItem(
                  value: 'settings',
                  child: _buildAvatarMenuOption(
                    'Thiết lập thời gian hết hạn',
                    Icons.settings,
                  ),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: _buildAvatarMenuOption('Đăng xuất', Icons.logout),
                ),
              ],
          onSelected: (value) {
            // Xử lý các action tương ứng
            switch (value) {
              case 'profile':
                // Navigate to account page
                context.go(AppRoute.account.path);
                break;
              case 'settings':
                // Navigate to settings page
                showConfigExpirationTime(userInfo);
                break;
              case 'logout':
                // Handle logout
                context.read<LoginProvider>().logout(context);
                break;
            }
          },
        ),
      ],
    );
  }

  // Helper method for avatar menu options
  Widget _buildAvatarMenuOption(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF21A366)),
          const SizedBox(width: 12),
          Text(title),
        ],
      ),
    );
  }

  // Helper method for avatar menu options
  Widget _buildInfoAvatar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        spacing: 10,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: ColorValue.primaryLightBlue,
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage(AppImage.imageUser),
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Text(userInfo!.hoTen),
            ],
          ),
          const Divider(color: ColorValue.darkGrey, height: 2, thickness: 1),
        ],
      ),
    );
  }

  // 🔥 Logic: show popup setting expiration time
  void showConfigExpirationTime(UserInfoDTO userInfo) {
    ConfigDto? config = AccountHelper.instance.getConfigTimeExpire();
    if (config == null) {
      ConfigReponsitory().getConfigTimeExpire();
    }
    showPopupSettingExpirationTime(
      context: context,
      title: "Thiết lập thời gian hết hạn",
      description:
          "Nhập số ngày để thiết lập thời gian hết hạn cho các biên bản",
      initialValue: config?.thoiHanTaiLieu ?? 0,
      initialValueNotifiDealing: config?.ngayBaoHetHan ?? 0,
      minValue: 1,
      // maxValue: 365,
      step: 1,
      onConfirm: (value, valueNotifiDealing) async {
        if (config?.thoiHanTaiLieu != value ||
            config?.ngayBaoHetHan != valueNotifiDealing) {
          Map<String, dynamic> body = {
            'idAccount': userInfo.id,
            'thoiHanTaiLieu': value,
            'ngayBaoHetHan': valueNotifiDealing,
          };
          await showLoadingPopup(context);
          fetchConfigTimeExpire(context, body);
        }
      },
    );
  }

  // 🔥 Logic: fetch config time expire
  void fetchConfigTimeExpire(
    BuildContext context,
    Map<String, dynamic> value,
  ) async {
    final result = await ConfigReponsitory().setConfigTimeExpire(value);
    SGLog.debug("Home", "result: $result");
    if (!context.mounted) return;
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS ||
        result['status_code'] == Numeral.STATUS_CODE_SUCCESS_CREATE) {
      hideLoadingPopup(context);
      AppUtility.showSnackBar(
        context,
        "Thiết lập thời gian hết hạn thành công",
      );
    } else {
      hideLoadingPopup(context);
      AppUtility.showSnackBar(
        context,
        "Thiết lập thời gian hết hạn thất bại: ${result['message']}",
      );
    }
  }
}
