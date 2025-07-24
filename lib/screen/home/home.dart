import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/home/widget/header.dart';
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

  @override
  Widget build(BuildContext context) {
    return MainWrapper(
      header: Header(),
      sidebar: SGSidebarHorizontal(
        items: [
          SGSidebarHorizontalItem(
            label: 'Tổng quan',
            icon: Icons.dashboard,
            isActive: _selectedIndex == 0,
            onTap:
                () => setState(() {
                  _selectedIndex = 0;
                  _selectedSubIndex = 0;
                }),
            subItems: [
              SGSidebarSubItem(
                label: 'Báo cáo ngày',
                icon: Icons.calendar_today,
                isActive: _selectedIndex == 0 && _selectedSubIndex == 0,
                onTap:
                    () => setState(() {
                      _selectedIndex = 0;
                      _selectedSubIndex = 0;
                    }),
              ),
              SGSidebarSubItem(
                label: 'Báo cáo tuần',
                icon: Icons.date_range,
                isActive: _selectedIndex == 0 && _selectedSubIndex == 1,
                onTap:
                    () => setState(() {
                      _selectedIndex = 0;
                      _selectedSubIndex = 1;
                    }),
              ),
              SGSidebarSubItem(
                label: 'Báo cáo tháng',
                icon: Icons.event_note,
                isActive: _selectedIndex == 0 && _selectedSubIndex == 2,
                onTap:
                    () => setState(() {
                      _selectedIndex = 0;
                      _selectedSubIndex = 2;
                    }),
              ),
            ],
          ),
          SGSidebarHorizontalItem(
            label: 'Sản phẩm',
            icon: Icons.shopping_bag,
            isActive: _selectedIndex == 1,
            onTap:
                () => setState(() {
                  _selectedIndex = 1;
                  _selectedSubIndex = 0;
                }),
            subItems: [
              SGSidebarSubItem(
                label: 'Danh sách sản phẩm',
                icon: Icons.list,
                isActive: _selectedIndex == 1 && _selectedSubIndex == 0,
                onTap:
                    () => setState(() {
                      _selectedIndex = 1;
                      _selectedSubIndex = 0;
                    }),
              ),
              SGSidebarSubItem(
                label: 'Thêm sản phẩm',
                icon: Icons.add_circle_outline,
                isActive: _selectedIndex == 1 && _selectedSubIndex == 1,
                onTap:
                    () => setState(() {
                      _selectedIndex = 1;
                      _selectedSubIndex = 1;
                    }),
              ),
            ],
          ),
          SGSidebarHorizontalItem(
            label: 'Khách hàng',
            icon: Icons.people,
            isActive: _selectedIndex == 2,
            onTap:
                () => setState(() {
                  _selectedIndex = 2;
                  _selectedSubIndex = 0;
                }),
            subItems: [
              SGSidebarSubItem(
                label: 'Danh sách khách hàng',
                icon: Icons.people_outline,
                isActive: _selectedIndex == 2 && _selectedSubIndex == 0,
                onTap:
                    () => setState(() {
                      _selectedIndex = 2;
                      _selectedSubIndex = 0;
                    }),
              ),
              SGSidebarSubItem(
                label: 'Nhóm khách hàng',
                icon: Icons.group_work,
                isActive: _selectedIndex == 2 && _selectedSubIndex == 1,
                onTap:
                    () => setState(() {
                      _selectedIndex = 2;
                      _selectedSubIndex = 1;
                    }),
              ),
            ],
          ),
          SGSidebarHorizontalItem(
            label: 'Báo cáo',
            icon: Icons.bar_chart,
            isActive: _selectedIndex == 3,
            onTap: () => setState(() => _selectedIndex = 3),
          ),
          SGSidebarHorizontalItem(
            label: 'Cài đặt',
            icon: Icons.settings,
            isActive: _selectedIndex == 4,
            onTap: () => setState(() => _selectedIndex = 4),
          ),
        ],
      ),
      body: widget.child,
    );
  }
}
