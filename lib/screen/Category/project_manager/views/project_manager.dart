import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/pages/project_list_page.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/pages/project_form_page.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/models/project.dart';

class ProjectManager extends StatefulWidget {
  const ProjectManager({super.key});

  @override
  State<ProjectManager> createState() => _ProjectManagerState();
}

class _ProjectManagerState extends State<ProjectManager> {
  bool showForm = false;
  Project? editingProject;

  void _showForm([Project? project]) {
    setState(() {
      showForm = true;
      editingProject = project;
    });
  }

  void _showList() {
    setState(() {
      showForm = false;
      editingProject = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showForm) {
      return ProjectFormPage(
        project: editingProject,
        // Khi bấm Hủy hoặc Lưu sẽ quay lại danh sách
        key: ValueKey(editingProject?.code ?? 'new'),
        onCancel: _showList,
        onSaved: _showList,
      );
    } else {
      return ProjectListPage(
        onAdd: () => _showForm(),
        onEdit: (project) => _showForm(project),
      );
    }
  }
}