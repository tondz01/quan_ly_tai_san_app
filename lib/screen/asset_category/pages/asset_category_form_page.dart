import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/models/asset_category_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/pages/department_form_page.dart';

class AssetCategoryFormPage extends StatefulWidget {
  final AssetCategoryDto? data;
  final Function(AssetCategoryDto)? onSave;
  final VoidCallback? onCancel;

  const AssetCategoryFormPage({
    super.key,
    this.data,
    this.onSave,
    this.onCancel,
  });

  @override
  State<AssetCategoryFormPage> createState() => _AssetCategoryFormPageState();
}

class _AssetCategoryFormPageState extends State<AssetCategoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _methodController = TextEditingController();
  final _periodController = TextEditingController();
  final _typeController = TextEditingController();
  final _assetAccountController = TextEditingController();
  final _depreciationAccountController = TextEditingController();
  final _expenseAccountController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _updateControllers();
  }

  @override
  void didUpdateWidget(AssetCategoryFormPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _updateControllers();
    }
  }

  void _updateControllers() {
    if (widget.data != null) {
      _idController.text = widget.data!.id ?? '';
      _nameController.text = widget.data!.tenMoHinh ?? '';
      _methodController.text = widget.data!.phuongPhapKhauHao?.toString() ?? '';
      _periodController.text = widget.data!.kyKhauHao?.toString() ?? '';
      _typeController.text = widget.data!.loaiKyKhauHao ?? '';
      _assetAccountController.text = widget.data!.taiKhoanTaiSan ?? '';
      _depreciationAccountController.text = widget.data!.taiKhoanKhauHao ?? '';
      _expenseAccountController.text = widget.data!.taiKhoanChiPhi ?? '';
      setState(() {
        _isEditing = false;
      });
    } else {
      _idController.text = '';
      _nameController.text = '';
      _methodController.text = '';
      _periodController.text = '';
      _typeController.text = '';
      _assetAccountController.text = '';
      _depreciationAccountController.text = '';
      _expenseAccountController.text = '';
      setState(() {
        _isEditing = true;
      });
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _methodController.dispose();
    _periodController.dispose();
    _typeController.dispose();
    _assetAccountController.dispose();
    _depreciationAccountController.dispose();
    _expenseAccountController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final assetCategory = AssetCategoryDto(
        id: _idController.text.isNotEmpty ? _idController.text : null,
        tenMoHinh: _nameController.text,
        phuongPhapKhauHao: int.tryParse(_methodController.text),
        kyKhauHao: int.tryParse(_periodController.text),
        loaiKyKhauHao: _typeController.text,
        taiKhoanTaiSan: _assetAccountController.text,
        taiKhoanKhauHao: _depreciationAccountController.text,
        taiKhoanChiPhi: _expenseAccountController.text,
        idCongTy: 'ct001',
        isActive: true,
      );
      widget.onSave?.call(assetCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.data != null
                  ? 'Chỉnh sửa mô hình tài sản'
                  : 'Thêm mô hình tài sản',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildHeaderDetail(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _idController,
                    enabled: widget.data != null ? false : _isEditing,
                    decoration: inputDecoration('Mã mô hình', required: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nhập mã mô hình';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _nameController,
                    enabled: _isEditing,
                    decoration: inputDecoration('Tên mô hình', required: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nhập tên mô hình tài sản';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child:
                   TextFormField(
                    controller: _methodController,
                    enabled: _isEditing,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1),
                    ],
                    decoration: inputDecoration(
                      'Phương pháp khấu hao (1: Đường thẳng)',
                      required: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nhập phương pháp khấu hao';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Chỉ được nhập số';
                      }
                      if (int.parse(value) != 1) {
                        return 'Chỉ được nhập 1 (Đường thẳng)';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _periodController,
                    enabled: _isEditing,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    decoration: inputDecoration('Kỳ khấu hao', required: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nhập kỳ khấu hao ';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Chỉ được nhập số';
                      }
                      if (int.parse(value) <= 0) {
                        return 'Kỳ khấu hao phải lớn hơn 0';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _typeController,
                    enabled: _isEditing,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1),
                    ],
                    decoration: inputDecoration(
                      'Loại kỳ khấu hao (1: Tháng, 2: Năm)',
                      required: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nhập loại kỳ khấu hao';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Chỉ được nhập số';
                      }
                      if (int.parse(value) != 1 && int.parse(value) != 2) {
                        return 'Chỉ được nhập 1 (Tháng) hoặc 2 (Năm)';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _expenseAccountController,
                    enabled: _isEditing,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: inputDecoration(
                      'Tài khoản chi phí',
                      required: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nhập tài khoản chi phí';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Chỉ được nhập số';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _assetAccountController,
                    enabled: _isEditing,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: inputDecoration(
                      'Tài khoản tài sản',
                      required: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nhập tài khoản tài sản';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Chỉ được nhập số';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _depreciationAccountController,
                    enabled: _isEditing,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: inputDecoration(
                      'Tài khoản khấu hao',
                      required: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nhập tài khoản khấu hao';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Chỉ được nhập số';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderDetail() {
    return _isEditing
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
          text: 'Chỉnh sửa mô hình tài sản',
          icon: Icons.save,
          backgroundColor: ColorValue.success,
          foregroundColor: Colors.white,
          onPressed: () {
            setState(() {
              _isEditing = true;
            });
          },
        );
  }
}
