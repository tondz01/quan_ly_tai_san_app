import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/capital_source/bloc/capital_source_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/capital_source/bloc/capital_source_event.dart';
import 'package:quan_ly_tai_san_app/screen/category/capital_source/models/capital_source.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/pages/department_form_page.dart';

class CapitalSourceFormPage extends StatefulWidget {
  final CapitalSource? capitalSource;
  final int? index;
  final VoidCallback? onCancel;
  final VoidCallback? onSaved;
  const CapitalSourceFormPage({
    super.key,
    this.capitalSource,
    this.index,
    this.onCancel,
    this.onSaved,
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
    _codeController = TextEditingController(
      text: widget.capitalSource?.code ?? '',
    );
    _nameController = TextEditingController(
      text: widget.capitalSource?.name ?? '',
    );
    _noteController = TextEditingController(
      text: widget.capitalSource?.note ?? '',
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
      final capitalSource = CapitalSource(
        code: _codeController.text.trim(),
        name: _nameController.text.trim(),
        note: _noteController.text.trim(),
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
    return Container(
      // constraints: BoxConstraints(
      //   maxWidth: MediaQuery.of(context).size.width * 0.8,
      // ),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 32.0,
              horizontal: 32.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  sectionTitle(
                    Icons.account_balance_wallet,
                    isEdit ? 'Cập nhật nguồn vốn' : 'Thêm mới nguồn vốn',
                    'Nhập thông tin nguồn vốn.',
                  ),
                  sectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionTitle(Icons.info_outline, 'Thông tin nguồn vốn'),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _codeController,
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
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          if (widget.onCancel != null) {
                            widget.onCancel!();
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
          ),
        ],
      ),
    );
  }
}
