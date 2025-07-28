import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/routes/app_route_path.dart';
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
  const MenuItem._internal({required this.label, required this.index, this.icon, this.reportSubItems = const [], this.projectGroups = const [], this.route = '/'});

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

    return MenuItem._internal(label: label, index: actualIndex, icon: icon, reportSubItems: reportSubItems, projectGroups: projectGroups, route: route);
  }
}

/// Class đại diện cho một mục con trong submenu
class SubMenuItem {
  final String label;
  final IconData? icon;
  final String route;
  final String? extra;

  const SubMenuItem({required this.label, this.icon, this.route = '/', this.extra});
}

/// Class đại diện cho một nhóm các mục trong submenu
class SubMenuGroup {
  final String title;
  final List<SubMenuItem> items;

  const SubMenuGroup({required this.title, required this.items});
}

/// Class quản lý toàn bộ dữ liệu menu
class AppMenuData {
  // Menu items chính
  final List<MenuItem> menuItems = [
    MenuItem(
      label: 'Tổng quan',
      reportSubItems: [
        SubMenuItem(label: 'Exemple 1', route: AppRoute.exemple1.path),
        SubMenuItem(label: 'Exemple 2', route: AppRoute.exemple2.path),
        SubMenuItem(label: 'Exemple 3', route: AppRoute.exemple3.path),
        SubMenuItem(label: 'Exemple 4', route: AppRoute.exemple4.path),
      ],
    ),
    MenuItem(
      label: 'Quản lý dự án',
      projectGroups: [
        SubMenuGroup(title: 'Dự án', items: [SubMenuItem(label: 'Danh sách dự án'), SubMenuItem(label: 'Thêm dự án mới'), SubMenuItem(label: 'Dự án đã hoàn thành')]),
        SubMenuGroup(title: 'Hợp đồng', items: [SubMenuItem(label: 'Danh sách hợp đồng'), SubMenuItem(label: 'Hợp đồng đã ký')]),
      ],
    ),
    MenuItem(label: 'Quản lý nhân viên', reportSubItems: [SubMenuItem(label: 'Báo cáo ngày'), SubMenuItem(label: 'Báo cáo tuần'), SubMenuItem(label: 'Báo cáo tháng')]),
    MenuItem(
      label: 'Quản lý tài sản',
      projectGroups: [
        SubMenuGroup(title: 'Công cụ', items: [SubMenuItem(label: 'Máy móc'), SubMenuItem(label: 'Thiết bị điện tử')]),
        SubMenuGroup(title: 'Dụng cụ', items: [SubMenuItem(label: 'Dụng cụ văn phòng'), SubMenuItem(label: 'Dụng cụ lắp đặt')]),
      ],
    ),
    MenuItem(
      label: 'Công cụ dụng cụ',
      projectGroups: [
        SubMenuGroup(title: 'Công cụ', items: [SubMenuItem(label: 'Máy móc'), SubMenuItem(label: 'Thiết bị điện tử')]),
        SubMenuGroup(title: 'Dụng cụ', items: [SubMenuItem(label: 'Dụng cụ văn phòng'), SubMenuItem(label: 'Dụng cụ lắp đặt')]),
      ],
    ),
    MenuItem(
      label: 'Quản lý CCDC - Vật tư',
      reportSubItems: 
        [SubMenuItem(label: 'Công cụ dụng cụ - Vật tư',route: AppRoute.toolsAndSupplies.path),
      ],
    ),
    MenuItem(
      label: 'Điều động tài sản ',
      reportSubItems: 
      [
          SubMenuItem(
          label: 'Cấp phát tài sản',
          route: AppRoute.assetTransfer.path,
          extra: "1",
        ),
        SubMenuItem(
          label: 'Thu hồi tài sản',
          route: AppRoute.assetTransfer.path,
          extra: "2",
        ),
        SubMenuItem(
          label: 'Điều chuyển tài sản',
          route: AppRoute.assetTransfer.path,
          extra: "3",
        ),
      ],
    ),
    MenuItem(
      label: 'Bàn giao tài sản',
      reportSubItems: [
        SubMenuItem(
          label: 'Biên bản bàn giao tài sản',
          route: AppRoute.assetHandover.path,
        ),
        SubMenuItem(label: 'Chi tiết Bàn giao tài sản'),
      ],
    ),
    MenuItem(label: 'Cài đặt', reportSubItems: [SubMenuItem(label: 'Báo cáo ngày'), SubMenuItem(label: 'Báo cáo tuần'), SubMenuItem(label: 'Báo cáo tháng')]),
    MenuItem(label: 'Cài đặt', reportSubItems: [SubMenuItem(label: 'Báo cáo ngày'), SubMenuItem(label: 'Báo cáo tuần'), SubMenuItem(label: 'Báo cáo tháng')]),
    MenuItem(label: 'Cài đặt', reportSubItems: [SubMenuItem(label: 'Báo cáo ngày'), SubMenuItem(label: 'Báo cáo tuần'), SubMenuItem(label: 'Báo cáo tháng')]),
    MenuItem(label: 'Cài đặt', reportSubItems: [SubMenuItem(label: 'Báo cáo ngày'), SubMenuItem(label: 'Báo cáo tuần'), SubMenuItem(label: 'Báo cáo tháng')]),
    MenuItem(label: 'Cài đặt', reportSubItems: [SubMenuItem(label: 'Báo cáo ngày'), SubMenuItem(label: 'Báo cáo tuần'), SubMenuItem(label: 'Báo cáo tháng')]),
    MenuItem(label: 'Cài đặt', reportSubItems: [SubMenuItem(label: 'Báo cáo ngày'), SubMenuItem(label: 'Báo cáo tuần'), SubMenuItem(label: 'Báo cáo tháng')]),
    MenuItem(label: 'Cài đặt', reportSubItems: [SubMenuItem(label: 'Báo cáo ngày'), SubMenuItem(label: 'Báo cáo tuần'), SubMenuItem(label: 'Báo cáo tháng')]),
    MenuItem(label: 'Cài đặt', reportSubItems: [SubMenuItem(label: 'Báo cáo ngày'), SubMenuItem(label: 'Báo cáo tuần'), SubMenuItem(label: 'Báo cáo tháng')]),
    MenuItem(label: 'Cài đặt', reportSubItems: [SubMenuItem(label: 'Báo cáo ngày'), SubMenuItem(label: 'Báo cáo tuần'), SubMenuItem(label: 'Báo cáo tháng')]),
    MenuItem(label: 'Cài đặt', reportSubItems: [SubMenuItem(label: 'Báo cáo ngày'), SubMenuItem(label: 'Báo cáo tuần'), SubMenuItem(label: 'Báo cáo tháng')]),
    MenuItem(label: 'Cài đặt', reportSubItems: [SubMenuItem(label: 'Báo cáo ngày'), SubMenuItem(label: 'Báo cáo tuần'), SubMenuItem(label: 'Báo cáo tháng')]),
    MenuItem(label: 'Cài đặt', reportSubItems: [SubMenuItem(label: 'Báo cáo ngày'), SubMenuItem(label: 'Báo cáo tuần'), SubMenuItem(label: 'Báo cáo tháng')]),
    MenuItem(label: 'Cài đặt', reportSubItems: [SubMenuItem(label: 'Báo cáo ngày'), SubMenuItem(label: 'Báo cáo tuần'), SubMenuItem(label: 'Báo cáo tháng')]),
    MenuItem(label: 'Cài đặt', reportSubItems: [SubMenuItem(label: 'Báo cáo ngày'), SubMenuItem(label: 'Báo cáo tuần'), SubMenuItem(label: 'Báo cáo tháng')]),
    MenuItem(label: 'Cài đặt', reportSubItems: [SubMenuItem(label: 'Báo cáo ngày'), SubMenuItem(label: 'Báo cáo tuần'), SubMenuItem(label: 'Báo cáo tháng')]),
    MenuItem(label: 'Cài đặt', reportSubItems: [SubMenuItem(label: 'Báo cáo ngày'), SubMenuItem(label: 'Báo cáo tuần'), SubMenuItem(label: 'Báo cáo tháng')]),
    MenuItem(label: 'Cài đặt', reportSubItems: [SubMenuItem(label: 'Báo cáo ngày'), SubMenuItem(label: 'Báo cáo tuần'), SubMenuItem(label: 'Báo cáo tháng')]),
    MenuItem(label: 'Cài đặt', reportSubItems: [SubMenuItem(label: 'Báo cáo ngày'), SubMenuItem(label: 'Báo cáo tuần'), SubMenuItem(label: 'Báo cáo tháng')]),
    MenuItem(label: 'Cài đặt', reportSubItems: [SubMenuItem(label: 'Báo cáo ngày'), SubMenuItem(label: 'Báo cáo tuần'), SubMenuItem(label: 'Báo cáo tháng')]),
    MenuItem(label: 'Cài đặt', reportSubItems: [SubMenuItem(label: 'Báo cáo ngày'), SubMenuItem(label: 'Báo cáo tuần'), SubMenuItem(label: 'Báo cáo tháng')]),
  ];

  // Chuyển đổi SubMenuItem thành SGSidebarSubItem
  SGSidebarSubItem convertToSGSubItem(SubMenuItem item, int parentIndex, int subIndex, bool isActive, VoidCallback onTap) {
    return SGSidebarSubItem(label: item.label, icon: item.icon, isActive: isActive, onTap: onTap);
  }

  // Chuyển đổi SubMenuGroup thành SGSubItemGroup
  SGSubItemGroup convertToSGSubItemGroup(SubMenuGroup group, int parentIndex, int groupIndex, int selectedIndex, int selectedSubIndex, Function(int, int) onTapCallback) {
    return SGSubItemGroup(
      title: group.title,
      items: List.generate(group.items.length, (itemIndex) {
        final subIndex = groupIndex * 100 + itemIndex; // Tạo subIndex duy nhất
        return SGSidebarSubItem(
          label: group.items[itemIndex].label,
          icon: group.items[itemIndex].icon,
          isActive: selectedIndex == parentIndex && selectedSubIndex == subIndex,
          onTap: () => onTapCallback(parentIndex, subIndex),
        );
      }),
    );
  }
}
