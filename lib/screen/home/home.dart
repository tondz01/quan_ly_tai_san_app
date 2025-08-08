import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_image.dart';
import 'package:quan_ly_tai_san_app/screen/home/utils/calculate_popup_width.dart';
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

  bool isItemOne = false;

  @override
  void initState() {
    super.initState();
    // Đăng ký lắng nghe thay đổi trạng thái popup
    _popupManager.addGlobalListener(_onPopupStateChanged);

    // Lắng nghe thay đổi route để cập nhật selectedIndex
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSelectedIndexFromRoute();
    });
  }

  @override
  void didUpdateWidget(Home oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Cập nhật selectedIndex khi widget được update
    _updateSelectedIndexFromRoute();
  }

  void _updateSelectedIndexFromRoute() {
    final currentLocation = GoRouterState.of(context).uri.path;
    final extra = GoRouterState.of(context).extra;

    log('Current route: $currentLocation, extra: $extra');

    // Tìm menu item tương ứng với route hiện tại
    for (int i = 0; i < _menuData.menuItems.length; i++) {
      final menuItem = _menuData.menuItems[i];

      // Kiểm tra route chính
      if (menuItem.route == currentLocation) {
        _updateSelectedIndex(i, 0);
        return;
      }

      // Kiểm tra subItems
      for (int j = 0; j < menuItem.reportSubItems.length; j++) {
        final subItem = menuItem.reportSubItems[j];
        if (subItem.route == currentLocation) {
          _updateSelectedIndex(i, j);
          return;
        }
      }

      // Kiểm tra projectGroups
      for (
        int groupIndex = 0;
        groupIndex < menuItem.projectGroups.length;
        groupIndex++
      ) {
        final group = menuItem.projectGroups[groupIndex];
        for (int itemIndex = 0; itemIndex < group.items.length; itemIndex++) {
          final item = group.items[itemIndex];
          if (item.route == currentLocation) {
            final subIndex = groupIndex * 100 + itemIndex;
            _updateSelectedIndex(i, subIndex);
            return;
          }
        }
      }
    }
  }

  void _updateSelectedIndex(int index, int subIndex) {
    if (_selectedIndex != index || _selectedSubIndex != subIndex) {
      setState(() {
        _selectedIndex = index;
        _selectedSubIndex = subIndex;
      });
      log(
        'Updated selectedIndex: $_selectedIndex, selectedSubIndex: $_selectedSubIndex',
      );
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
        popupPadding: const EdgeInsets.symmetric(vertical: 2),
        onTap:
            () => setState(() {
              if (item.reportSubItems.isEmpty && item.projectGroups.isEmpty) {
                _selectedIndex = item.index;
                if (item.route.isNotEmpty) {
                  isItemOne = true;
                  context.go(item.route);
                }
              }
            }),
        subItems:
            item.reportSubItems.isNotEmpty ? _buildSubItems(item.index) : null,
        subItemGroups:
            item.projectGroups.isNotEmpty
                ? _buildSubItemGroups(item.index, item.projectGroups)
                : null,
      );
    });
  }

  // Tạo subItems thông thường từ model
  List<SGSidebarSubItem> _buildSubItems(int parentIndex) {
    return List.generate(
      _menuData.menuItems[parentIndex].reportSubItems.length,
      (subIndex) {
        final subItem =
            _menuData.menuItems[parentIndex].reportSubItems[subIndex];
        return SGSidebarSubItem(
          label: subItem.label,
          icon: subItem.icon,
          isActive:
              _selectedIndex == parentIndex && _selectedSubIndex == subIndex,
          onTap:
              () => setState(() {
                _selectedIndex = parentIndex;
                _selectedSubIndex = subIndex;
                _popupManager.closeAllPopups();
                if (subItem.route.isNotEmpty) {
                  isItemOne = false;
                  log('subItem.route: ${subItem.extra}');
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
    return List.generate(groupData.length, (groupIndex) {
      final group = groupData[groupIndex];

      return SGSubItemGroup(
        title: group.title,
        items: List.generate(group.items.length, (itemIndex) {
          final item = group.items[itemIndex];
          final subIndex =
              groupIndex * 100 + itemIndex; // Tạo subIndex duy nhất
          return SGSidebarSubItem(
            label: item.label,
            icon: item.icon,
            isActive:
                _selectedIndex == parentIndex && _selectedSubIndex == subIndex,
            onTap:
                () => setState(() {
                  _selectedIndex = parentIndex;
                  _selectedSubIndex = subIndex;
                  _popupManager.closeAllPopups();
                  if (item.route.isNotEmpty) {
                    isItemOne = false;
                    log('item.extra: ${item.extra}');
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
    log('sidebarItems: ${sidebarItems.toString()}');
    return MainWrapper(
      header: null,
      sidebar: Container(
        padding: const EdgeInsets.only(top: 8, left: 24, right: 24, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: ColorValue.neutral200.withValues(alpha: .3),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            if (AppImage.imageLogo.isNotEmpty)
              SizedBox(
                width: 48,
                height: 48,
                child: Image.asset(AppImage.imageLogo),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: SGSidebarHorizontal(
                items: sidebarItems,
                onShowSubItems: (subItems) {
                  // Cập nhật lại UI nếu cần thiết
                  setState(() {});
                },
              ),
            ),
            const SizedBox(width: 16),
            _buildHeaderActionRight(),
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
      ),
    );
  }

  Widget _buildHeaderActionRight() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Settings button
        MaterialIconButton(
          icon: Icons.settings,
          onPressed: () {},
          tooltip: 'Cài đặt',
        ),
        const SizedBox(width: 8),
        // Chat button with popup
        PopupMenuButton<String>(
          offset: const Offset(-83, 10),
          child: MaterialIconButton(
            icon: Icons.chat_bubble_outline,
            onPressed: null,
            tooltip: 'Chat',
          ),
          itemBuilder:
              (context) => [
                PopupMenuItem(value: 'today', child: _buildTimeOption('Today')),
                PopupMenuItem(
                  value: 'yesterday',
                  child: _buildTimeOption('Yesterday'),
                ),
                PopupMenuItem(
                  value: 'last7days',
                  child: _buildTimeOption('Last 7 days'),
                ),
                PopupMenuItem(
                  value: 'thismonth',
                  child: _buildTimeOption('This month'),
                ),
                PopupMenuItem(
                  value: 'custom',
                  child: _buildTimeOption('Custom range'),
                ),
              ],
          onSelected: (value) {
            SGLog.debug('Header', '$value selected');
          },
        ),
        const SizedBox(width: 8),
        // Time button with popup
        PopupMenuButton<String>(
          offset: const Offset(-83, 10),
          child: MaterialIconButton(
            icon: Icons.access_time,
            onPressed: null,
            tooltip: 'Thời gian',
          ),
          itemBuilder:
              (context) => [
                PopupMenuItem(value: 'today', child: _buildTimeOption('Today')),
                PopupMenuItem(
                  value: 'yesterday',
                  child: _buildTimeOption('Yesterday'),
                ),
                PopupMenuItem(
                  value: 'last7days',
                  child: _buildTimeOption('Last 7 days'),
                ),
                PopupMenuItem(
                  value: 'thismonth',
                  child: _buildTimeOption('This month'),
                ),
                PopupMenuItem(
                  value: 'custom',
                  child: _buildTimeOption('Custom range'),
                ),
              ],
          onSelected: (value) {
            SGLog.debug('Header', '$value selected');
          },
        ),
        const SizedBox(width: 16),
        // User avatar
        CircleAvatar(
          radius: 20,
          backgroundColor: ColorValue.primaryLightBlue,
          child: CircleAvatar(
            radius: 18,
            backgroundImage: const NetworkImage(
              'https://i.pravatar.cc/150?img=3',
            ),
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeOption(String title) {
    return InkWell(
      onTap: () {
        SGLog.debug('Header', '$title selected');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(title),
      ),
    );
  }
}
