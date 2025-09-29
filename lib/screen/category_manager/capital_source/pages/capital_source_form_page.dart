import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/bloc/capital_source_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/bloc/capital_source_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/models/capital_source.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/pages/department_form_page.dart';

class CapitalSourceFormPage extends StatefulWidget {
  final NguonKinhPhi? capitalSource;
  final int? index;
  final VoidCallback? onCancel;
  final VoidCallback? onSaved;
  final bool isNew;
  final bool isCanUpdate;
  const CapitalSourceFormPage({
    super.key,
    this.capitalSource,
    this.index,
    this.onCancel,
    this.onSaved,
    this.isNew = false,
    this.isCanUpdate = false,
  });

  @override
  State<CapitalSourceFormPage> createState() => _CapitalSourceFormPageState();
}

class _CapitalSourceFormPageState extends State<CapitalSourceFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _noteController;
  bool _isActive = true;
  bool isEditing = false;
  @override
  void initState() {
    _initData();
    super.initState();
  }

  @override
  void didUpdateWidget(CapitalSourceFormPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.capitalSource != widget.capitalSource) {
      _initData();
    }
  }

  void _initData() {
    if (widget.capitalSource != null) {
      isEditing = false;
    } else {
      isEditing = true;
    }
    // if (!widget.isCanUpdate && !widget.isNew) {
    //   isEditing = false;
    // }
    _codeController = TextEditingController(
      text: widget.capitalSource?.id ?? '',
    );
    _nameController = TextEditingController(
      text: widget.capitalSource?.tenNguonKinhPhi ?? '',
    );
    _noteController = TextEditingController(
      text: widget.capitalSource?.ghiChu ?? '',
    );
    _isActive = widget.capitalSource?.isActive ?? true;
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
      final capitalSource = NguonKinhPhi(
        id: _codeController.text.trim(),
        tenNguonKinhPhi: _nameController.text.trim(),
        ghiChu: _noteController.text.trim(),
        isActive: _isActive,
      );
      if (widget.capitalSource == null) {
        context.read<CapitalSourceBloc>().add(AddCapitalSource(capitalSource));
      } else {
        context.read<CapitalSourceBloc>().add(
          UpdateCapitalSource(capitalSource),
        );
      }
      if (widget.onSaved != null) {
        widget.onSaved!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.capitalSource != null;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle(Icons.info_outline, 'Thông tin nguồn vốn'),
                const SizedBox(height: 16),
                if (widget.isNew ||
                    (widget.isCanUpdate &&
                        !widget.isNew &&
                        widget.capitalSource != null))
                  _buildHeaderDetail(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _codeController,
                        enabled: !isEdit, // Read-only khi update
                        decoration: inputDecoration(
                          'Mã nguồn kinh phí',
                          required: true,
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Nhập mã nguồn kinh phí'
                                    : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _nameController,
                        enabled: isEditing,
                        decoration: inputDecoration(
                          'Tên nguồn kinh phí',
                          required: true,
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Nhập tên nguồn kinh phí'
                                    : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _noteController,
                  decoration: inputDecoration('Ghi chú'),
                  enabled: isEditing,
                  minLines: 1,
                  maxLines: 3,
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
        ],
      ),
    );
  }

  Widget _buildHeaderDetail() {
    return isEditing
        ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MaterialTextButton(
              text: 'Lưu',
              icon: Icons.save,
              backgroundColor: ColorValue.success,
              foregroundColor: Colors.white,
              onPressed: () {
                _save();
              },
            ),
            const SizedBox(width: 8),
            MaterialTextButton(
              text: 'Hủy',
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
          text: 'Chỉnh sửa nguồn vốn',
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
