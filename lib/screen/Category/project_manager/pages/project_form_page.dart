import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/pages/department_form_page.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/bloc/project_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/bloc/project_event.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/models/project.dart';

class ProjectFormPage extends StatefulWidget {
  final Project? project;
  final int? index;
  final VoidCallback? onCancel;
  final VoidCallback? onSaved;
  const ProjectFormPage({
    super.key,
    this.project,
    this.index,
    this.onCancel,
    this.onSaved,
  });

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _noteController;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _initData();
  }

  void _initControllers() {
    _codeController = TextEditingController();
    _nameController = TextEditingController();
    _noteController = TextEditingController();
  }

  @override
  void didUpdateWidget(ProjectFormPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Kiểm tra nếu có thay đổi trong project
    if (oldWidget.project != widget.project) {
      if (mounted) {
        _initData();
      }
    }
  }

  void _initData() {
    _codeController.text = widget.project?.code ?? '';
    _nameController.text = widget.project?.name ?? '';
    _noteController.text = widget.project?.note ?? '';
    _isActive = widget.project?.isActive ?? true;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final project = Project(
        code: _codeController.text.trim(),
        name: _nameController.text.trim(),
        note: _noteController.text.trim(),
        isActive: _isActive,
      );
      if (widget.project == null) {
        context.read<ProjectBloc>().add(AddProject(project));
      } else {
        context.read<ProjectBloc>().add(UpdateProject(project));
      }
      if (widget.onSaved != null) {
        widget.onSaved!();
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.project != null;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            sectionTitle(
              Icons.account_tree,
              isEdit ? 'Cập nhật dự án' : 'Thêm mới dự án',
              'Nhập thông tin dự án mới.',
            ),
            sectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle(Icons.info_outline, 'Thông tin dự án'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _codeController,
                          decoration: inputDecoration(
                            'Mã dự án',
                            required: true,
                          ),
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Nhập mã dự án'
                                      : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          decoration: inputDecoration(
                            'Tên dự án',
                            required: true,
                          ),
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Nhập tên dự án'
                                      : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _noteController,
                    decoration: inputDecoration(
                      'Ghi chú',
                      required: true,
                    ),
                    validator:
                        (v) =>
                            v == null || v.isEmpty
                                ? 'Nhập ghi chú'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _isActive,
                        onChanged:
                            (v) => setState(() => _isActive = v ?? true),
                      ),
                      const Text(
                        'Có hiệu lực',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    if (widget.onCancel != null) {
                      widget.onCancel!();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF7B8EC8),
                    side: const BorderSide(color: Color(0xFFE6EAF3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Hủy'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2264E5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: Text(isEdit ? 'Cập nhật' : 'Lưu'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
