import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/Category/capital_source/views/capital_source_manager.dart';
import 'package:quan_ly_tai_san_app/screen/Category/departments/views/department_manager.dart';
import 'package:quan_ly_tai_san_app/screen/Category/project_manager/views/project_manager.dart';
import 'package:quan_ly_tai_san_app/screen/Category/staff/views/staff_manager.dart';
import 'package:se_gay_components/web_base/sg_sidebar/sg_sidebar.dart';

final List<MenuItem> menuItems = [
  MenuItem(icon: Icons.dashboard, label: 'Dashboards', idMenu: 'dashboard'),
  MenuItem(
    icon: Icons.category,
    label: 'Quản lý danh mục',
    idMenu: 'category',
    children: [
      MenuItem(icon: Icons.person, label: 'Nhân viên', idMenu: 'staff'),
      MenuItem(icon: Icons.home, label: 'Phòng ban', idMenu: 'department'),
      MenuItem(
        icon: Icons.category,
        label: 'Nguồn vốn',
        idMenu: 'capital_source',
      ),
      MenuItem(icon: Icons.category, label: 'Dự án', idMenu: 'project'),
    ],
  ),
  MenuItem(icon: Icons.category, label: 'Quản lý vật tư', idMenu: 'materials'),
  MenuItem(icon: Icons.pie_chart, label: 'Sale', idMenu: 'sale'),
  MenuItem(
    icon: Icons.receipt_long,
    label: 'Purchases',
    idMenu: 'purchases',
    children: [
      MenuItem(icon: Icons.add, label: 'Add Purchase', idMenu: 'add_purchase'),
      MenuItem(
        icon: Icons.edit,
        label: 'Edit Purchase',
        idMenu: 'edit_purchase',
      ),
      MenuItem(
        icon: Icons.delete,
        label: 'Delete Purchase',
        idMenu: 'delete_purchase',
      ),
    ],
  ),
  MenuItem(icon: Icons.reply, label: 'Biên bản nghiệm thu', idMenu: 'bbnt'),
];
final Map<String, Widget> pages = {
  'dashboard': Center(child: Text('Dashboard')),
};

final Map<String, Widget> subPages = {
  'project': ProjectManager(),
  'staff': StaffManager(),
  'department': DepartmentManager(),
  'capital_source': CapitalSourceManager(),
};
