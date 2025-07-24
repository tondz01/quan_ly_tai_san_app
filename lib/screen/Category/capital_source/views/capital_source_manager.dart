import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/Category/capital_source/models/capital_source.dart';
import 'package:quan_ly_tai_san_app/screen/Category/capital_source/pages/capital_source_form_page.dart';
import 'package:quan_ly_tai_san_app/screen/Category/capital_source/pages/capital_source_list_page.dart';

class CapitalSourceManager extends StatefulWidget {
  const CapitalSourceManager({super.key});

  @override
  State<CapitalSourceManager> createState() => _CapitalSourceManagerState();
}

class _CapitalSourceManagerState extends State<CapitalSourceManager> {
  bool showForm = false;
  CapitalSource? editingCapitalSource;

  void _showForm([CapitalSource? capitalSource]) {
    setState(() {
      showForm = true;
      editingCapitalSource = capitalSource;
    });
  }

  void _showList() {
    setState(() {
      showForm = false;
      editingCapitalSource = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showForm) {
      return CapitalSourceFormPage(
        capitalSource: editingCapitalSource,
        // Khi bấm Hủy hoặc Lưu sẽ quay lại danh sách
        key: ValueKey(editingCapitalSource?.code ?? 'new'),
        onCancel: _showList,
        onSaved: _showList,
      );
    } else {
      return CapitalSourceListPage(
        onAdd: () => _showForm(),
        onEdit: (capitalSource) => _showForm(capitalSource),
      );
    }
  }
}