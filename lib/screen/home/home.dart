import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_image.dart';
import 'package:quan_ly_tai_san_app/routes/app_route_path.dart';
import 'package:quan_ly_tai_san_app/screen/home/utils/calculate_popup_width.dart';
import 'package:quan_ly_tai_san_app/screen/home/utils/menu_prefs.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/provider/login_provider.dart';
import 'package:se_gay_components/common/sg_popup_controller.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import 'package:se_gay_components/main_wrapper/index.dart';
import 'models/menu_data.dart';

class Home extends StatefulWidget {
  final Widget child;
  const Home({super.key, required this.child});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  int _selectedSubIndex = 0;
  UserInfoDTO? userInfo;
  late SGPopupManager _popupManager;
  // Khởi tạo model menu data
  late AppMenuData _menuData;
  // Thêm biến để theo dõi trạng thái của popup
  bool _isPopupOpen = false;

  bool isItemOne = false;

  @override
  void initState() {
    super.initState();
    _menuData = AppMenuData();
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
      final hasSubs = _menuData.menuItems[_selectedIndex].reportSubItems.isNotEmpty ||
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
    if(userInfo == null){
      context.go(AppRoute.login.path);
    }
  }

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
        isActive: _selectedIndex == item.index,
        popupWidth: calculatePopupWidth(item),
        popupBorderRadius: 4.0,
        buttonEnterColor: Colors.grey.shade100,
        heightButton: 28.0,
        borderRadiusButton: 4.0,
        paddingButton: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
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
                  context.go(subItem.route, extra: subItem.extra);
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
            isActive:
                _selectedIndex == parentIndex && _selectedSubIndex == subIndex,
            onTap:
                () => setState(() {
                  _updateSelectedIndex(parentIndex, subIndex);
                  _popupManager.closeAllPopups();
                  if (item.route.isNotEmpty) {
                    isItemOne = false;
                    context.go(item.route, extra: item.extra);
                  }
                }),
          );
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lấy danh sách items từ model
    final sidebarItems = _getItems();
    return MainWrapper(
      header: null,
      sidebar: Container(
        padding: const EdgeInsets.only(top: 8, left: 24, right: 24, bottom: 8),
        decoration: BoxDecoration(color: Colors.blue),
        child: Row(
          children: [
            if (AppImage.imageLogo.isNotEmpty)
              CircleAvatar(
                radius: 24,
                child: Image.asset(
                  AppImage.imageLogo,
                  fit: BoxFit.cover,
                ), // kích thước avatar
              ),
            const SizedBox(width: 16),
            Expanded(
              child:
                  sidebarItems.isNotEmpty
                      ? SGSidebarHorizontal(
                        items: sidebarItems,
                        onShowSubItems: (subItems) {
                          // Cập nhật lại UI nếu cần thiết
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
      body: Container(
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
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderActionRight(UserInfoDTO userInfo) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Settings button
        if(userInfo.rule == 0 || userInfo.rule == 1)
        MaterialIconButton(
          icon: Icons.settings,
          onPressed: () {
            context.go(AppRoute.account.path);
          },
          tooltip: 'Quản lý tài khoản',
        ),
        // const SizedBox(width: 8),
        // Chat button with popup
        // PopupMenuButton<String>(
        //   offset: const Offset(-83, 10),
        //   child: MaterialIconButton(icon: Icons.chat_bubble_outline, onPressed: null, tooltip: 'Chat'),
        //   itemBuilder:
        //       (context) => [
        //         PopupMenuItem(value: 'today', child: _buildTimeOption('Today')),
        //         PopupMenuItem(value: 'yesterday', child: _buildTimeOption('Yesterday')),
        //         PopupMenuItem(value: 'last7days', child: _buildTimeOption('Last 7 days')),
        //         PopupMenuItem(value: 'thismonth', child: _buildTimeOption('This month')),
        //         PopupMenuItem(value: 'custom', child: _buildTimeOption('Custom range')),
        //       ],
        //   onSelected: (value) {
        //     SGLog.debug('Header', '$value selected');
        //   },
        // ),
        // const SizedBox(width: 8),
        // Time button with popup
        // PopupMenuButton<String>(
        //   offset: const Offset(-83, 10),
        //   child: MaterialIconButton(icon: Icons.access_time, onPressed: null, tooltip: 'Thời gian'),
        //   itemBuilder:
        //       (context) => [
        //         PopupMenuItem(value: 'today', child: _buildTimeOption('Today')),
        //         PopupMenuItem(value: 'yesterday', child: _buildTimeOption('Yesterday')),
        //         PopupMenuItem(value: 'last7days', child: _buildTimeOption('Last 7 days')),
        //         PopupMenuItem(value: 'thismonth', child: _buildTimeOption('This month')),
        //         PopupMenuItem(value: 'custom', child: _buildTimeOption('Custom range')),
        //       ],
        //   onSelected: (value) {
        //     SGLog.debug('Header', '$value selected');
        //   },
        // ),
        const SizedBox(width: 16),
        // User avatar
        Tooltip(
          message:
              'Tên: ${userInfo.hoTen}\nTên đăng nhập: ${userInfo.tenDangNhap}',
          child: CircleAvatar(
            radius: 20,
            backgroundColor: ColorValue.primaryLightBlue,
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(AppImage.imageUser),
              backgroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Tooltip(
          message: 'Đăng xuất',
          child: IconButton(
            onPressed: () {
              context.read<LoginProvider>().logout(context);
            },
            icon: const Icon(Icons.logout_outlined, size: 24,color: ColorValue.background,),
          ),
        ),
      ],
    );
  }

}
