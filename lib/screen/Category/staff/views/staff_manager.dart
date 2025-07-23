import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/Category/staff/models/staff.dart';
import 'package:quan_ly_tai_san_app/screen/Category/staff/pages/staff_form_page.dart';
import 'package:quan_ly_tai_san_app/screen/Category/staff/pages/staff_list_page.dart';

class StaffManager extends StatefulWidget {
  const StaffManager({super.key});

  @override
  State<StaffManager> createState() => _StaffManagerState();
}

class _StaffManagerState extends State<StaffManager> {
  bool showForm = false;
  StaffDTO? editingStaff;

  void _showForm([StaffDTO? staff]) {
    setState(() {
      showForm = true;
      editingStaff = staff;
    });
  }

  void _showList() {
    setState(() {
      showForm = false;
      editingStaff = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showForm) {
      return StaffFormPage(
        staff: editingStaff,
        // Khi bấm Hủy hoặc Lưu sẽ quay lại danh sách
        key: ValueKey(editingStaff?.staffId ?? 'new'),
        onCancel: _showList,
        onSaved: _showList,
      );
    } else {
      return StaffListPage(
        onAdd: () => _showForm(),
        onEdit: (staff) => _showForm(staff),
      );
    }
  }
}