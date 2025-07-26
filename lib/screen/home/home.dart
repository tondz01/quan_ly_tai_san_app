import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quan_ly_tai_san_app/screen/home/utils/calculate_popup_width.dart';
import 'package:quan_ly_tai_san_app/screen/home/widget/header.dart';
import 'package:se_gay_components/common/sg_colors.dart';
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
  final SGPopupManager _popupManager = SGPopupManager();
  // Khởi tạo model menu data
  final AppMenuData _menuData = AppMenuData();
  // Thêm biến để theo dõi trạng thái của popup
  bool _isPopupOpen = false;

  @override
  void initState() {
    super.initState();
    // Đăng ký lắng nghe thay đổi trạng thái popup
    _popupManager.addGlobalListener(_onPopupStateChanged);
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
        popupPadding: const EdgeInsets.symmetric(vertical: 2),
        onTap:
            () => setState(() {
              if (item.reportSubItems.isEmpty && item.projectGroups.isEmpty) {
                _selectedIndex = item.index;
                if (item.route.isNotEmpty) {
                  context.go(item.route);
                }
              }
            }),
        subItems: item.reportSubItems.isNotEmpty ? _buildSubItems(item.index) : null,
        subItemGroups: item.projectGroups.isNotEmpty ? _buildSubItemGroups(item.index, item.projectGroups) : null,
      );
    });
  }

  // Tạo subItems thông thường từ model
  List<SGSidebarSubItem> _buildSubItems(int parentIndex) {
    return List.generate(_menuData.menuItems[parentIndex].reportSubItems.length, (subIndex) {
      final subItem = _menuData.menuItems[parentIndex].reportSubItems[subIndex];
      return SGSidebarSubItem(
        label: subItem.label,
        icon: subItem.icon,
        isActive: _selectedIndex == parentIndex && _selectedSubIndex == subIndex,
        onTap:
            () => setState(() {
              _selectedIndex = parentIndex;
              _selectedSubIndex = subIndex;
              _popupManager.closeAllPopups();
              if (subItem.route.isNotEmpty) {
                context.go(subItem.route);
              }
            }),
      );
    });
  }

  // Tạo subItemGroups có nhóm từ model
  List<SGSubItemGroup> _buildSubItemGroups(int parentIndex, List<SubMenuGroup> groupData) {
    return List.generate(groupData.length, (groupIndex) {
      final group = groupData[groupIndex];

      return SGSubItemGroup(
        title: group.title,
        items: List.generate(group.items.length, (itemIndex) {
          final item = group.items[itemIndex];
          final subIndex = groupIndex * 100 + itemIndex; // Tạo subIndex duy nhất
          return SGSidebarSubItem(
            label: item.label,
            icon: item.icon,
            isActive: _selectedIndex == parentIndex && _selectedSubIndex == subIndex,
            onTap:
                () => setState(() {
                  _selectedIndex = parentIndex;
                  _selectedSubIndex = subIndex;
                  _popupManager.closeAllPopups();
                  if (item.route.isNotEmpty) {
                    context.go(item.route);
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
      header: Header(),
      sidebar: Column(
        children: [
          const Divider(color: SGAppColors.neutral300, height: 1),
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 24, right: 24, bottom: 6),
            child: SGSidebarHorizontal(
              items: sidebarItems,
              onShowSubItems: (subItems) {
                // Cập nhật lại UI nếu cần thiết
                setState(() {});
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Content
          widget.child,

          // Thêm barrier chỉ hiển thị khi popup đang mở
          if (_isPopupOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  SGLog.debug("Home", "Barrier tapped");
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
    );
  }
}
