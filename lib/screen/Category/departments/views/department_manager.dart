import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/pages/department_form_page.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/pages/department_list_page.dart';

class DepartmentManager extends StatefulWidget {
  const DepartmentManager({super.key});

  @override
  State<DepartmentManager> createState() => _DepartmentManagerState();
}

class _DepartmentManagerState extends State<DepartmentManager> {
  bool showForm = false;
  Department? editingDepartment;

  void _showForm([Department? department]) {
    setState(() {
      showForm = true;
      editingDepartment = department;
    });
  }

  void _showList() {
    setState(() {
      showForm = false;
      editingDepartment = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showForm) {
      return DepartmentFormPage(
        department: editingDepartment,
        // Khi bấm Hủy hoặc Lưu sẽ quay lại danh sách
        key: ValueKey(editingDepartment?.departmentId ?? 'new'),
        onCancel: _showList,
        onSaved: _showList,
      );
    } else {
      return DepartmentListPage(
        onAdd: () => _showForm(),
        onEdit: (department) => _showForm(department),
      );
    }
  }
}