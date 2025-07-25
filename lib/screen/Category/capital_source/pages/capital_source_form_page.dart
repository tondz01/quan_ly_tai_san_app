import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/capital_source/bloc/capital_source_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/capital_source/bloc/capital_source_event.dart';
import 'package:quan_ly_tai_san_app/screen/category/capital_source/models/capital_source.dart';
import 'package:se_gay_components/common/sg_button.dart';
import 'package:se_gay_components/common/sg_textfield.dart';


class CapitalSourceFormPage extends StatefulWidget {
  final CapitalSource? capitalSource;
  final int? index;
  final VoidCallback? onCancel;
  final VoidCallback? onSaved;
  const CapitalSourceFormPage({super.key, this.capitalSource, this.index, this.onCancel, this.onSaved});

  @override
  State<CapitalSourceFormPage> createState() => _CapitalSourceFormPageState();
}

class _CapitalSourceFormPageState extends State<CapitalSourceFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _noteController;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.capitalSource?.code ?? '');
    _nameController = TextEditingController(text: widget.capitalSource?.name ?? '');
    _noteController = TextEditingController(text: widget.capitalSource?.note ?? '');
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
      final capitalSource = CapitalSource(
        code: _codeController.text.trim(),
        name: _nameController.text.trim(),
        note: _noteController.text.trim(),
        isActive: _isActive,
      );
      if (widget.capitalSource == null) {
        context.read<CapitalSourceBloc>().add(AddCapitalSource(capitalSource));
      } else {
        context.read<CapitalSourceBloc>().add(UpdateCapitalSource(capitalSource));
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
    final isEdit = widget.capitalSource != null;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        margin: EdgeInsets.only(right: 50, top: 16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      isEdit ? 'Cập nhật thông tin nguồn vốn' : 'Thêm mới nguồn vốn',
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
                                    label: 'Mã nguồn kinh phí',
                                    prefixIcon: Icon(
                                      Icons.code,
                                      color: Colors.orange,
                                    ),
                                    validator:
                                        (v) =>
                                            v == null || v.isEmpty
                                                ? 'Nhập mã nguồn kinh phí'
                                                : null,
                                  ),
                                ),
                                const SizedBox(width: 25),
                                Expanded(
                                  child: SGTextField(
                                    controller: _nameController,
                                    label: 'Tên nguồn kinh phí',
                                    prefixIcon: Icon(
                                      Icons.title,
                                      color: Colors.orange,
                                    ),
                                    validator:
                                        (v) =>
                                            v == null || v.isEmpty
                                                ? 'Nhập tên nguồn kinh phí'
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
