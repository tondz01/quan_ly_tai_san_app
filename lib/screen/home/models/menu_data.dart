// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/enum/role_code.dart';
import 'package:quan_ly_tai_san_app/core/utils/permission_service.dart';
import 'package:quan_ly_tai_san_app/routes/app_route_path.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:se_gay_components/main_wrapper/sg_sidebar_horizontal.dart';

/// Class đại diện cho một mục trong menu
class MenuItem {
  // Biến static để đếm và tạo ID tự động
  static int _nextIndex = 0;
  final String label;
  final IconData? icon;
  final Widget? child;
  final int index;
  final List<SubMenuItem> reportSubItems;
  final List<SubMenuGroup> projectGroups;
  final String route;

  // Constructor với tham số index tùy chọn
  const MenuItem._internal({
    required this.label,
    required this.index,
    this.child,
    this.icon,
    this.reportSubItems = const [],
    this.projectGroups = const [],
    this.route = '',
  });

  // Factory constructor tự động tạo index
  factory MenuItem({
    required String label,
    IconData? icon,
    Widget? child,
    int? index,
    List<SubMenuItem> reportSubItems = const [],
    List<SubMenuGroup> projectGroups = const [],
    String route = '',
  }) {
    // Nếu index được chỉ định, sử dụng nó
    // Nếu không, dùng giá trị tiếp theo và tăng biến đếm
    final actualIndex = index ?? _nextIndex++;

    return MenuItem._internal(
      label: label,
      index: actualIndex,
      icon: icon,
      reportSubItems: reportSubItems,
      projectGroups: projectGroups,
      route: route,
      child: child,
    );
  }
}

/// Class đại diện cho một mục con trong submenu
class SubMenuItem {
  final String label;
  final IconData? icon;
  final Widget? child;
  final String route;
  final String? extra;
  final Function(BuildContext context)? callback;
  const SubMenuItem({
    required this.label,
    this.icon,
    this.route = '',
    this.extra,
    this.child,
    this.callback,
  });
}

/// Class đại diện cho một nhóm các mục trong submenu
class SubMenuGroup {
  final String title;
  final List<SubMenuItem> items;

  const SubMenuGroup({required this.title, required this.items});
}

/// Notifier để quản lý việc cập nhật count values
class MenuDataNotifier extends ChangeNotifier {
  static final MenuDataNotifier _instance = MenuDataNotifier._internal();
  factory MenuDataNotifier() => _instance;
  MenuDataNotifier._internal();

  /// Refresh tất cả count values và thông báo cho listeners
  void refreshCounts() {
    log('message refreshCounts MenuDataNotifier');
    notifyListeners();
  }
}

/// Class quản lý toàn bộ dữ liệu menu
class AppMenuData extends ChangeNotifier {
  late List<MenuItem> menuItems;
  final MenuDataNotifier _notifier = MenuDataNotifier();

  final ValueNotifier<int> _countTrigger = ValueNotifier<int>(0);

  static AppMenuData? _instance;
  static AppMenuData get instance {
    _instance ??= AppMenuData._internal();
    return _instance!;
  }

  AppMenuData._internal() {
    MenuItem._nextIndex = 0;
    _buildMenuItems();

    // Lắng nghe thay đổi từ notifier
    _notifier.addListener(() {
      notifyListeners();
    });
  }

  void _buildMenuItems() {
    final per = PermissionService.instance;
    menuItems = [
      MenuItem(label: 'Tổng quan', route: AppRoute.dashboard.path),
      MenuItem(
        label: 'Danh mục',
        route: AppRoute.category.path,
        reportSubItems: [
          if (per.hasPermission(RoleCode.NHANVIEN))
            SubMenuItem(
              label: 'Quản lý nhân viên',
              route: AppRoute.staffManager.path,
            ),
          if (per.hasPermission(RoleCode.PHONGBAN))
            SubMenuItem(
              label: 'Quản lý phòng ban',
              route: AppRoute.departmentManager.path,
            ),
          // if (per.hasPermission(RoleCode.CHUCVU))
          SubMenuItem(label: 'Quản lý chức vụ', route: AppRoute.role.path),
          SubMenuItem(
            label: 'Quản lý dự án',
            route: AppRoute.projectManager.path,
          ),
          if (per.hasPermission(RoleCode.NGUONVON))
            SubMenuItem(
              label: 'Quản lý nguồn vốn',
              route: AppRoute.capitalSource.path,
            ),
          if (per.hasPermission(RoleCode.MOHINHTAISAN))
            SubMenuItem(
              label: 'Mô hình tài sản',
              route: AppRoute.assetCategory.path,
            ),

          if (per.hasPermission(RoleCode.NHOMTAISAN))
            SubMenuItem(label: 'Nhóm tài sản', route: AppRoute.assetGroup.path),

          SubMenuItem(label: 'Loại tài sản', route: AppRoute.loaiTaiSan.path),

          SubMenuItem(label: 'Nhóm ccdc', route: AppRoute.ccdcGroup.path),

          SubMenuItem(label: 'Loại ccdc', route: AppRoute.loaiCcdc.path),
          SubMenuItem(label: 'Đơn vị tính', route: AppRoute.unit.path),
          SubMenuItem(label: 'Lý do tăng', route: AppRoute.reasonIncrease.path),
        ],
      ),
      if (per.hasPermission(RoleCode.TAISAN))
        MenuItem(
          label: 'Quản lý tài sản',
          route: AppRoute.assetManagement.path,
        ),
      if (per.hasPermission(RoleCode.CCDCVT))
        MenuItem(
          label: 'Quản lý CCDC - Vật tư',
          route: AppRoute.toolsAndSupplies.path,
        ),
      if (per.hasPermission(RoleCode.DIEUDONG_TAISAN))
        MenuItem(
          label: 'Điều động tài sản ',
          child: _buildRealtimeCountWidget(
            () =>
                countAssetTransfer + countAssetTransfer2 + countAssetTransfer3,
          ),
          reportSubItems: [
            SubMenuItem(
              label: 'Cấp phát tài sản',
              child: _buildRealtimeCountWidgetInSubMenu(
                () => countAssetTransfer,
              ),
              route: AppRoute.assetTransfer.path,
              extra: "1",
            ),
            SubMenuItem(
              label: 'Điều chuyển tài sản',
              child: _buildRealtimeCountWidgetInSubMenu(
                () => countAssetTransfer2,
              ),
              route: AppRoute.assetTransfer.path,
              extra: "2",
            ),
            SubMenuItem(
              label: 'Thu hồi tài sản',
              child: _buildRealtimeCountWidgetInSubMenu(
                () => countAssetTransfer3,
              ),
              route: AppRoute.assetTransfer.path,
              extra: "3",
            ),
          ],
        ),
      if (per.hasPermission(RoleCode.DIEUDONG_CCDC))
        MenuItem(
          label: 'Điều động CCDC - Vật tư',
          child: _buildRealtimeCountWidget(
            () =>
                countToolAndSupplies +
                countToolAndSupplies2 +
                countToolAndSupplies3,
          ),
          route: AppRoute.toolAndMaterialTransfer.path,
          reportSubItems: [
            SubMenuItem(
              label: 'Cấp phát CCDC - vật tư',
              child: _buildRealtimeCountWidgetInSubMenu(
                () => countToolAndSupplies,
              ),
              route: AppRoute.toolAndMaterialTransfer.path,
              extra: "1",
            ),
            SubMenuItem(
              label: 'Điều chuyển CCDC - vật tư',
              child: _buildRealtimeCountWidgetInSubMenu(
                () => countToolAndSupplies2,
              ),
              route: AppRoute.toolAndMaterialTransfer.path,
              extra: "2",
            ),
            SubMenuItem(
              label: 'Thu hồi CCDC - vật tư',
              child: _buildRealtimeCountWidgetInSubMenu(
                () => countToolAndSupplies3,
              ),
              route: AppRoute.toolAndMaterialTransfer.path,
              extra: "3",
            ),
          ],
        ),
      if (per.hasPermission(RoleCode.BANGIAO_TAISAN))
        MenuItem(
          label: 'Bàn giao tài sản',
          child: _buildRealtimeCountWidget(() => countAssetHandover),
          route: AppRoute.assetHandover.path,
        ),
      if (per.hasPermission(RoleCode.BANGIAO_CCDC))
        MenuItem(
          label: 'Bàn giao CCDC-Vật tư',
          child: _buildRealtimeCountWidget(() => countToolAndMaterialHandover),
          route: AppRoute.toolAndSuppliesHandover.path,
        ),
      if (per.hasPermission(RoleCode.BAOCAO))
        MenuItem(
          label: 'Báo cáo',
          reportSubItems: [
            SubMenuItem(
              label: "Báo cáo Cấp phát tài sản trong kỳ",
              route: AppRoute.allocationReport.path,
            ),
            SubMenuItem(
              label: "Báo cáo Điều chuyển tài sản trong kỳ",
              route: AppRoute.transferReport.path,
            ),
            SubMenuItem(
              label: "Báo cáo Thu hồi tài sản trong kỳ",
              route: AppRoute.recoveryReport.path,
            ),
            SubMenuItem(
              label: 'Biên bản kiểm kê',
              route: AppRoute.bienBanKiemKe.path,
            ),
            SubMenuItem(
              label: 'Biên bản kiểm kê CCDC',
              route: AppRoute.bienBanKiemKeCcdc.path,
            ),
          ],
        ),
    ];
  }

  // Getter methods để lấy count values
  int get countAssetTransfer => AccountHelper.instance.getAssetTransferCount(1);
  int get countAssetTransfer2 =>
      AccountHelper.instance.getAssetTransferCount(2);
  int get countAssetTransfer3 =>
      AccountHelper.instance.getAssetTransferCount(3);
  int get countToolAndSupplies =>
      AccountHelper.instance.getToolAndMaterialTransferCount(1);
  int get countToolAndSupplies2 =>
      AccountHelper.instance.getToolAndMaterialTransferCount(2);
  int get countToolAndSupplies3 =>
      AccountHelper.instance.getToolAndMaterialTransferCount(3);
  int get countAssetHandover => AccountHelper.instance.getAssetHandoverCount();
  int get countToolAndMaterialHandover =>
      AccountHelper.instance.getToolAndMaterialHandoverCount();

  /// Method để refresh counts và rebuild menu items
  void refreshCounts() {
    _countTrigger.value++;
    notifyListeners();
  }

  /// Public method để rebuild lại menu khi quyền thay đổi (ví dụ sau khi login)
  void rebuildMenuItems() {
    MenuItem._nextIndex = 0;
    _buildMenuItems();
    notifyListeners();
  }

  /// Static method để refresh counts từ bất kỳ đâu
  static void refreshAllCounts() {
    instance.refreshCounts();
  }

  Widget _buildRealtimeCountWidget(int Function() countGetter) {
    return ValueListenableBuilder<int>(
      valueListenable: _countTrigger,
      builder: (context, value, child) {
        final count = countGetter();
        return _buildShowCount(count);
      },
    );
  }

  Widget _buildRealtimeCountWidgetInSubMenu(int Function() countGetter) {
    return ValueListenableBuilder<int>(
      valueListenable: _countTrigger,
      builder: (context, value, child) {
        final count = countGetter();
        log('message test: count ${count}');
        return _buildShowCountInSubMenu(count);
      },
    );
  }

  // Chuyển đổi SubMenuItem thành SGSidebarSubItem
  SGSidebarSubItem convertToSGSubItem(
    SubMenuItem item,
    int parentIndex,
    int subIndex,
    bool isActive,
    VoidCallback onTap,
  ) {
    return SGSidebarSubItem(
      label: item.label,
      icon: item.icon,
      isActive: isActive,
      onTap: onTap,
      child: item.child,
    );
  }

  // Chuyển đổi SubMenuGroup thành SGSubItemGroup
  SGSubItemGroup convertToSGSubItemGroup(
    SubMenuGroup group,
    int parentIndex,
    int groupIndex,
    int selectedIndex,
    int selectedSubIndex,
    Function(int, int) onTapCallback,
  ) {
    return SGSubItemGroup(
      title: group.title,
      items: List.generate(group.items.length, (itemIndex) {
        final subIndex = groupIndex * 100 + itemIndex; // Tạo subIndex duy nhất
        return SGSidebarSubItem(
          label: group.items[itemIndex].label,
          icon: group.items[itemIndex].icon,
          isActive:
              selectedIndex == parentIndex && selectedSubIndex == subIndex,
          onTap: () => onTapCallback(parentIndex, subIndex),
          child: group.items[itemIndex].child,
        );
      }),
    );
  }

  Widget _buildShowCount(int count) {
    if (count <= 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      child: Center(
        child: Text(
          count > 99 ? '99+' : '$count',
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildShowCountInSubMenu(int count) {
    if (count <= 0) return const SizedBox.shrink();
    Color badgeColor;
    String displayText;

    // Phân loại màu theo loại tài liệu
    if (count > 99) {
      badgeColor = const Color(0xFF2196F3); // Blue
      displayText = '99+ mới';
    } else if (count > 50) {
      badgeColor = const Color(0xFF4CAF50); // Green
      displayText = '$count mới';
    } else if (count > 10) {
      badgeColor = const Color(0xFFFF9800); // Orange
      displayText = '$count mới';
    } else {
      badgeColor = ColorValue.coral;
      displayText = '$count mới';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      constraints: const BoxConstraints(minWidth: 24, minHeight: 20),
      child: Center(
        child: Text(
          displayText,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _countTrigger.dispose();
    _notifier.removeListener(() {});
    super.dispose();
  }
}
