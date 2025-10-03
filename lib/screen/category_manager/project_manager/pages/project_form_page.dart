import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/widgets/input_decoration_custom.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/pages/department_form_page.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/bloc/project_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/bloc/project_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/constants/project_constants.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/models/duan.dart';

class ProjectFormPage extends StatefulWidget {
  final DuAn? duAn;
  final int? index;
  final VoidCallback? onCancel;
  final VoidCallback? onSaved;
  const ProjectFormPage({
    super.key,
    this.duAn,
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
  bool isEditing = false;

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
    if (oldWidget.duAn != widget.duAn) {
      if (mounted) {
        _initData();
      }
    }
  }

  void _initData() {
    if (widget.duAn != null) {
      isEditing = false;
    } else {
      isEditing = true;
    }
    _codeController.text = widget.duAn?.id ?? '';
    _nameController.text = widget.duAn?.tenDuAn ?? '';
    _noteController.text = widget.duAn?.ghiChu ?? '';
    _isActive = widget.duAn?.hieuLuc ?? ProjectConstants.defaultHieuLuc;
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
      final project = DuAn(
        id: _codeController.text.trim(),
        tenDuAn: _nameController.text.trim(),
        ghiChu: _noteController.text.trim(),
        hieuLuc: _isActive,
      );
      if (widget.duAn == null) {
        context.read<ProjectBloc>().add(AddProjectEvent(project));
      } else {
        context.read<ProjectBloc>().add(UpdateProjectEvent(project));
      }
      if (widget.onSaved != null) {
        widget.onSaved!();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ProjectConstants.validationFormIncomplete),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildHeaderDetail(),
            sectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle(Icons.info_outline, ProjectConstants.sectionProjectInfo),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _codeController,
                          enabled: widget.duAn != null ? false : isEditing, // Read-only khi update
                          decoration: inputDecoration(
                            ProjectConstants.labelProjectId,
                            required: true,
                          ),
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? ProjectConstants.validationProjectIdRequired
                                      : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          decoration: inputDecoration(
                            ProjectConstants.labelProjectName,
                            required: true,
                          ),
                          enabled: isEditing,
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? ProjectConstants.validationProjectNameRequired
                                      : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _noteController,
                    decoration: inputDecoration(ProjectConstants.labelProjectNote, required: false),
                    enabled: isEditing,
                    // validator:
                    //     (v) => v == null || v.isEmpty ? ProjectConstants.validationProjectNoteRequired : null,
                  ),
                  const SizedBox(height: 16),
                  // Row(
                  //   children: [
                  //     Checkbox(
                  //       value: _isActive,
                  //       onChanged: (v) => !isEditing ? null : setState(() => _isActive = v ?? true),
                  //     ),
                  //     Text(ProjectConstants.labelIsActive, style: const TextStyle(fontSize: 16)),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderDetail() {
    return isEditing
        ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MaterialTextButton(
              text: ProjectConstants.saveText,
              icon: Icons.save,
              backgroundColor: ColorValue.success,
              foregroundColor: Colors.white,
              onPressed: () {
                _save();
              },
            ),
            const SizedBox(width: 8),
            MaterialTextButton(
              text: ProjectConstants.cancelText,
              icon: Icons.cancel,
              backgroundColor: ColorValue.error,
              foregroundColor: Colors.white,
              onPressed: () {
                if (widget.onCancel != null) {
                  widget.onCancel!();
                }
              },
            ),
          ],
        )
        : MaterialTextButton(
          text: ProjectConstants.editText,
          icon: Icons.save,
          backgroundColor: ColorValue.success,
          foregroundColor: Colors.white,
          onPressed: () {
            setState(() {
              isEditing = true;
            });
          },
        );
  }
}
