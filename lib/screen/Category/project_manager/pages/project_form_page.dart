import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/bloc/project_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/bloc/project_event.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/models/project.dart';
import 'package:se_gay_components/common/sg_button.dart';
import 'package:se_gay_components/common/sg_textfield.dart';

class ProjectFormPage extends StatefulWidget {
  final Project? project;
  final int? index;
  final VoidCallback? onCancel;
  final VoidCallback? onSaved;
  const ProjectFormPage({super.key, this.project, this.index, this.onCancel, this.onSaved});

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
    _codeController = TextEditingController(text: widget.project?.code ?? '');
    _nameController = TextEditingController(text: widget.project?.name ?? '');
    _noteController = TextEditingController(text: widget.project?.note ?? '');
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        margin: EdgeInsets.only(top: 16),
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),

        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      isEdit ? 'Cập nhật thông tin dự án' : 'Thêm mới dự án',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 32.0,
                horizontal: 32.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: SGTextField(
                                    controller: _codeController,
                                    label: 'Mã dự án',
                                    prefixIcon: Icon(
                                      Icons.code,
                                      color: Colors.orange,
                                    ),
                                    validator:
                                        (v) =>
                                            v == null || v.isEmpty
                                                ? 'Nhập mã dự án'
                                                : null,
                                  ),
                                ),
                                const SizedBox(width: 25),
                                Expanded(
                                  child: SGTextField(
                                    controller: _nameController,
                                    label: 'Tên dự án',
                                    prefixIcon: Icon(
                                      Icons.title,
                                      color: Colors.orange,
                                    ),
                                    validator:
                                        (v) =>
                                            v == null || v.isEmpty
                                                ? 'Nhập tên dự án'
                                                : null,
                                    minLines: 1,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SGTextField(
                              controller: _noteController,
                              label: 'Ghi chú',
                              prefixIcon: Icon(
                                Icons.note_alt,
                                color: Colors.orange,
                              ),
                              minLines: 1,
                              maxLines: 3,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Checkbox(
                                  value: _isActive,
                                  activeColor: Colors.orange,
                                  onChanged:
                                      (v) =>
                                          setState(() => _isActive = v ?? true),
                                ),
                                const Text(
                                  'Có hiệu lực',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SGButton(
                          text: 'Hủy',
                          onPressed: () {
                            if (widget.onCancel != null) {
                              widget.onCancel!();
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          mainColor: Colors.blueAccent,
                        ),
                        const SizedBox(width: 16),
                        SGButton(text: isEdit ? 'Cập nhật':'Thêm mới', onPressed: _save),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
