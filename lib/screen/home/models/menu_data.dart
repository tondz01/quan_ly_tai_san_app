import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/routes/app_route_path.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:se_gay_components/main_wrapper/sg_sidebar_horizontal.dart';

/// Class đại diện cho một mục trong menu
class MenuItem {
  // Biến static để đếm và tạo ID tự động
  static int _nextIndex = 0;
  final String label;
  final IconData? icon;
  final int index;
  final List<SubMenuItem> reportSubItems;
  final List<SubMenuGroup> projectGroups;
  final String route;

  // Constructor với tham số index tùy chọn
  const MenuItem._internal({
    required this.label,
    required this.index,
    this.icon,
    this.reportSubItems = const [],
    this.projectGroups = const [],
    this.route = '',
  });

  // Factory constructor tự động tạo index
  factory MenuItem({
    required String label,
    IconData? icon,
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
    );
  }
}

/// Class đại diện cho một mục con trong submenu
class SubMenuItem {
  final String label;
  final IconData? icon;
  final String route;
  final String? extra;
  final Function(BuildContext context)? callback;
  const SubMenuItem({
    required this.label,
    this.icon,
    this.route = '',
    this.extra,
    this.callback,
  });
}

/// Class đại diện cho một nhóm các mục trong submenu
class SubMenuGroup {
  final String title;
  final List<SubMenuItem> items;

  const SubMenuGroup({required this.title, required this.items});
}

/// Class quản lý toàn bộ dữ liệu menu
class AppMenuData {
  late final List<MenuItem> menuItems;

  AppMenuData() {
    MenuItem._nextIndex = 0;
    menuItems = [
      MenuItem(label: 'Tổng quan', route: AppRoute.dashboard.path),
      MenuItem(
        label: 'Danh mục',
        route: AppRoute.category.path,
        reportSubItems: [
          SubMenuItem(
            label: 'Quản lý nhân viên',
            route: AppRoute.staffManager.path,
          ),
          SubMenuItem(
            label: 'Quản lý phòng ban',
            route: AppRoute.departmentManager.path,
          ),
          SubMenuItem(label: 'Quản lý chức vụ', route: AppRoute.role.path),
          SubMenuItem(
            label: 'Quản lý dự án',
            route: AppRoute.projectManager.path,
          ),
          SubMenuItem(
            label: 'Quản lý nguồn vốn',
            route: AppRoute.capitalSource.path,
          ),
          SubMenuItem(
            label: 'Mô hình tài sản',
            route: AppRoute.assetCategory.path,
          ),
          SubMenuItem(label: 'Nhóm tài sản', route: AppRoute.assetGroup.path),
          SubMenuItem(label: 'Nhóm ccdc', route: AppRoute.ccdcGroup.path),
        ],
      ),
      MenuItem(
        label: 'Quản lý tài sản',
        route: AppRoute.assetManagement.path,
      ),
      MenuItem(
        label: 'Quản lý CCDC - Vật tư',
        route: AppRoute.toolsAndSupplies.path,
      ),
      MenuItem(
        label: 'Điều động tài sản ',
        reportSubItems: [
          SubMenuItem(
            label: 'Cấp phát tài sản ${countAssetTransfer}',
            route: AppRoute.assetTransfer.path,
            extra: "1",
          ),
          SubMenuItem(
            label: 'Điều chuyển tài sản ${countAssetTransfer2}',
            route: AppRoute.assetTransfer.path,
            extra: "3",
          ),
          SubMenuItem(
            label: 'Thu hồi tài sản ${countAssetTransfer3}',
            route: AppRoute.assetTransfer.path,
            extra: "2",
          ),
        ],
      ),
      MenuItem(
        label: 'Điều động CCDC - Vật tư',
        route: AppRoute.toolAndMaterialTransfer.path,
        reportSubItems: [
          SubMenuItem(
            label: 'Cấp phát CCDC - vật tư ${countToolAndSupplies}',
            route: AppRoute.toolAndMaterialTransfer.path,
            extra: "1",
          ),
          SubMenuItem(
            label: 'Điều chuyển CCDC - vật tư ${countToolAndSupplies2}',
            route: AppRoute.toolAndMaterialTransfer.path,
            extra: "3",
          ),
          SubMenuItem(
            label: 'Thu hồi CCDC - vật tư ${countToolAndSupplies3}',
            route: AppRoute.toolAndMaterialTransfer.path,
            extra: "2",
          ),
        ],
      ),
      MenuItem(label: 'Bàn giao tài sản ${AccountHelper.instance.getAssetHandoverCount()}', route: AppRoute.assetHandover.path),
      MenuItem(label: 'Bàn giao CCDC-Vật tư ${AccountHelper.instance.getToolAndMaterialHandoverCount()}', route: AppRoute.toolAndSuppliesHandover.path),
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
  
  int get countAssetTransfer => AccountHelper.instance.getAssetTransferCount(1);
  int get countAssetTransfer2 => AccountHelper.instance.getAssetTransferCount(2);
  int get countAssetTransfer3 => AccountHelper.instance.getAssetTransferCount(3);
  int get countToolAndSupplies => AccountHelper.instance.getToolAndMaterialTransferCount(1);
  int get countToolAndSupplies2 => AccountHelper.instance.getToolAndMaterialTransferCount(2);
  int get countToolAndSupplies3 => AccountHelper.instance.getToolAndMaterialTransferCount(3);
  int get countAssetHandover => AccountHelper.instance.getAssetHandoverCount();
  int get countToolAndMaterialHandover => AccountHelper.instance.getToolAndMaterialHandoverCount();
 
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
        );
      }),
    );
  }
}
