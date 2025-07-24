import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/home/widget/header.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/main_wrapper/index.dart';

class Home extends StatefulWidget {
  final Widget child;
  const Home({super.key, required this.child});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  int _selectedSubIndex = 0;

  double _calculatePopupWidth(List<Map<String, Object>> subMenuItems) {
    if (subMenuItems.isEmpty) return 200.0;

    // Tìm label dài nhất trong danh sách subMenu
    String longestLabel = '';
    for (var item in subMenuItems) {
      final label = item['label'] as String;
      if (label.length > longestLabel.length) {
        longestLabel = label;
      }
    }

    double width = longestLabel.length * 8.0 + 60.0;

    return width;
  }

  List<SGSidebarHorizontalItem> _getItems() {
    // Dữ liệu cho các menu
    final menuData = [
      {'label': 'Tổng quan'},
      {'label': 'Quản lý dự án'},
      {'label': 'Quản lý nhân viên'},
      {'label': 'Quản lý tài sản'},
      {'label': 'Công cụ dụng cụ'},
      {'label': 'Báo cáo'},
      {'label': 'Cài đặt'},
    ];

    // Các thuộc tính chung
    final commonProps = {
      'popupBorderRadius': 4.0,
      'popupOffset': const Offset(60, 10),
      'buttonEnterColor': Colors.grey.shade100,
      'heightButton': 28.0,
      'borderRadiusButton': 4.0,
      'padding': const EdgeInsets.only(bottom: 8, left: 12, right: 12),
    };

    // Dữ liệu cho các submenu
    final subMenuData = [
      {'label': 'Báo cáo ngày'},
      {'label': 'Báo cáo tuần'},
      {'label': 'Báo cáo tháng'},
    ];

    // Tính toán chiều rộng popup dựa trên label dài nhất
    final popupWidth = _calculatePopupWidth(subMenuData);

    // Tạo danh sách items
    return List.generate(menuData.length, (index) {
      return SGSidebarHorizontalItem(
        label: menuData[index]['label'] as String,
        isActive: _selectedIndex == index,
        popupWidth: popupWidth,
        popupBorderRadius: commonProps['popupBorderRadius'] as double,
        popupOffset: commonProps['popupOffset'] as Offset,
        buttonEnterColor: commonProps['buttonEnterColor'] as Color,
        heightButton: commonProps['heightButton'] as double,
        borderRadiusButton: commonProps['borderRadiusButton'] as double,
        paddingButton: commonProps['padding'] as EdgeInsetsGeometry,
        onTap:
            () => setState(() {
              _selectedIndex = index;
              _selectedSubIndex = 0;
            }),
        subItems: List.generate(subMenuData.length, (subIndex) {
          return SGSidebarSubItem(
            label: subMenuData[subIndex]['label'] as String,
            isActive: _selectedIndex == index && _selectedSubIndex == subIndex,
            onTap:
                () => setState(() {
                  _selectedIndex = index;
                  _selectedSubIndex = subIndex;
                }),
          );
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainWrapper(
      header: Header(),
      sidebar: Column(
        children: [
          const Divider(color: SGAppColors.neutral300, height: 1),
          Padding(padding: const EdgeInsets.only(top: 6, left: 24, right: 24, bottom: 24), child: SGSidebarHorizontal(items: _getItems())),
        ],
      ),
      body: widget.child,
    );
  }
}
