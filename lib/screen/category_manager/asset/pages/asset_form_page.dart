import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/asset/bloc/asset_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/asset/bloc/asset_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/asset/models/asset.dart';

class AssetFormPage extends StatefulWidget {
  final AssetDTO? asset;
  final int? index;
  final VoidCallback? onCancel;
  final VoidCallback? onSaved;
  const AssetFormPage({
    super.key,
    this.asset,
    this.index,
    this.onCancel,
    this.onSaved,
  });

  @override
  State<AssetFormPage> createState() => _AssetFormPageState();
}

class _AssetFormPageState extends State<AssetFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _assetIdController;
  late TextEditingController _originalPriceController;
  late TextEditingController _initialDepreciationValueController;
  late TextEditingController _initialDepreciationPeriodController;
  late TextEditingController _liquidationValueController;
  late TextEditingController _assetModelController;
  late TextEditingController _depreciationMethodController;
  late TextEditingController _depreciationPeriodsController;
  late TextEditingController _assetAccountController;
  late TextEditingController _depreciationAccountController;
  late TextEditingController _costAccountController;
  late TextEditingController _assetGroupController;
  late TextEditingController _entryDateController;
  late TextEditingController _usageDateController;
  late TextEditingController _projectController;
  late TextEditingController _fundingSourceController;
  late TextEditingController _symbolController;
  late TextEditingController _symbolNumberController;
  late TextEditingController _capacityController;
  late TextEditingController _countryOfOriginController;
  late TextEditingController _yearOfManufactureController;
  late TextEditingController _reasonForIncreaseController;
  late TextEditingController _statusController;
  late TextEditingController _quantityController;
  late TextEditingController _unitController;
  late TextEditingController _noteController;
  late TextEditingController _initialUsageUnitController;
  late TextEditingController _currentUnitController;
  bool _initialUnitCreated = false;

  final List<String> assetGroups = [
    '1 - Nhà cửa, công trình gắn liền với đất',
    '2 - Máy móc, thiết bị',
    '3 - Phương tiện vận tải',
    '4 - Công cụ, dụng cụ',
  ];
  final List<String> depreciationMethods = [
    'Đường thẳng',
    'Số dư giảm dần',
    'Sản lượng',
  ];

  @override
  void initState() {
    super.initState();
    _assetIdController = TextEditingController(
      text: widget.asset?.assetId ?? '',
    );
    _originalPriceController = TextEditingController(
      text: widget.asset?.originalPrice ?? '',
    );
    _initialDepreciationValueController = TextEditingController(
      text: widget.asset?.initialDepreciationValue ?? '',
    );
    _initialDepreciationPeriodController = TextEditingController(
      text: widget.asset?.initialDepreciationPeriod ?? '',
    );
    _liquidationValueController = TextEditingController(
      text: widget.asset?.liquidationValue ?? '',
    );
    _assetModelController = TextEditingController(
      text: widget.asset?.assetModel ?? '',
    );
    _depreciationMethodController = TextEditingController(
      text: widget.asset?.depreciationMethod ?? '',
    );
    _depreciationPeriodsController = TextEditingController(
      text: widget.asset?.depreciationPeriods ?? '',
    );
    _assetAccountController = TextEditingController(
      text: widget.asset?.assetAccount ?? '',
    );
    _depreciationAccountController = TextEditingController(
      text: widget.asset?.depreciationAccount ?? '',
    );
    _costAccountController = TextEditingController(
      text: widget.asset?.costAccount ?? '',
    );
    _assetGroupController = TextEditingController(
      text: widget.asset?.assetGroup ?? '',
    );
    _entryDateController = TextEditingController(
      text: widget.asset?.entryDate ?? '',
    );
    _usageDateController = TextEditingController(
      text: widget.asset?.usageDate ?? '',
    );
    _projectController = TextEditingController(
      text: widget.asset?.project ?? '',
    );
    _fundingSourceController = TextEditingController(
      text: widget.asset?.fundingSource ?? '',
    );
    _symbolController = TextEditingController(text: widget.asset?.symbol ?? '');
    _symbolNumberController = TextEditingController(
      text: widget.asset?.symbolNumber ?? '',
    );
    _capacityController = TextEditingController(
      text: widget.asset?.capacity ?? '',
    );
    _countryOfOriginController = TextEditingController(
      text: widget.asset?.countryOfOrigin ?? '',
    );
    _yearOfManufactureController = TextEditingController(
      text: widget.asset?.yearOfManufacture ?? '',
    );
    _reasonForIncreaseController = TextEditingController(
      text: widget.asset?.reasonForIncrease ?? '',
    );
    _statusController = TextEditingController(text: widget.asset?.status ?? '');
    _quantityController = TextEditingController(
      text: widget.asset?.quantity ?? '',
    );
    _unitController = TextEditingController(text: widget.asset?.unit ?? '');
    _noteController = TextEditingController(text: widget.asset?.note ?? '');
    _initialUsageUnitController = TextEditingController(
      text: widget.asset?.initialUsageUnit ?? '',
    );
    _currentUnitController = TextEditingController(
      text: widget.asset?.currentUnit ?? '',
    );
    _initialUnitCreated = widget.asset?.initialUnitCreated ?? false;
  }

  @override
  void dispose() {
    _assetIdController.dispose();
    _originalPriceController.dispose();
    _initialDepreciationValueController.dispose();
    _initialDepreciationPeriodController.dispose();
    _liquidationValueController.dispose();
    _assetModelController.dispose();
    _depreciationMethodController.dispose();
    _depreciationPeriodsController.dispose();
    _assetAccountController.dispose();
    _depreciationAccountController.dispose();
    _costAccountController.dispose();
    _assetGroupController.dispose();
    _entryDateController.dispose();
    _usageDateController.dispose();
    _projectController.dispose();
    _fundingSourceController.dispose();
    _symbolController.dispose();
    _symbolNumberController.dispose();
    _capacityController.dispose();
    _countryOfOriginController.dispose();
    _yearOfManufactureController.dispose();
    _reasonForIncreaseController.dispose();
    _statusController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _noteController.dispose();
    _initialUsageUnitController.dispose();
    _currentUnitController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(
    String label, {
    bool required = false,
    String? hint,
  }) {
    return InputDecoration(
      labelText: required ? '$label *' : label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _sectionTitle(IconData icon, String title, [String? desc]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 12, top: 2),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF1FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF7B8EC8), size: 24),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            if (desc != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  desc,
                  style: const TextStyle(
                    color: Color(0xFF687082),
                    fontSize: 13,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6EAF3)),
      ),
      child: child,
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final asset = AssetDTO(
        assetId: _assetIdController.text.trim(),
        originalPrice: _originalPriceController.text.trim(),
        initialDepreciationValue:
            _initialDepreciationValueController.text.trim(),
        initialDepreciationPeriod:
            _initialDepreciationPeriodController.text.trim(),
        liquidationValue: _liquidationValueController.text.trim(),
        assetModel: _assetModelController.text.trim(),
        depreciationMethod: _depreciationMethodController.text.trim(),
        depreciationPeriods: _depreciationPeriodsController.text.trim(),
        assetAccount: _assetAccountController.text.trim(),
        depreciationAccount: _depreciationAccountController.text.trim(),
        costAccount: _costAccountController.text.trim(),
        assetGroup: _assetGroupController.text.trim(),
        entryDate: _entryDateController.text.trim(),
        usageDate: _usageDateController.text.trim(),
        project: _projectController.text.trim(),
        fundingSource: _fundingSourceController.text.trim(),
        symbol: _symbolController.text.trim(),
        symbolNumber: _symbolNumberController.text.trim(),
        capacity: _capacityController.text.trim(),
        countryOfOrigin: _countryOfOriginController.text.trim(),
        yearOfManufacture: _yearOfManufactureController.text.trim(),
        reasonForIncrease: _reasonForIncreaseController.text.trim(),
        status: _statusController.text.trim(),
        quantity: _quantityController.text.trim(),
        unit: _unitController.text.trim(),
        note: _noteController.text.trim(),
        initialUnitCreated: _initialUnitCreated,
        initialUsageUnit: _initialUsageUnitController.text.trim(),
        currentUnit: _currentUnitController.text.trim(),
      );
      if (widget.asset == null) {
        context.read<AssetBloc>().add(AddAsset(asset));
      } else {
        context.read<AssetBloc>().add(UpdateAsset(asset));
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
    final isEdit = widget.asset != null;
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _sectionTitle(
                  Icons.inventory_2,
                  isEdit ? 'Cập nhật tài sản' : 'Thêm tài sản',
                  'Nhập thông tin tài sản.',
                ),
                _sectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(Icons.info_outline, 'Thông tin tài sản'),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              enabled: !isEdit, // Read-only khi update
                              controller: _assetIdController,
                              decoration: _inputDecoration(
                                'Mã tài sản',
                                required: true,
                              ),
                              validator:
                                  (v) =>
                                      v == null || v.isEmpty
                                          ? 'Nhập mã tài sản'
                                          : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _originalPriceController,
                              decoration: _inputDecoration(
                                'Nguyên giá',
                                required: true,
                              ),
                              validator:
                                  (v) =>
                                      v == null || v.isEmpty
                                          ? 'Nhập nguyên giá'
                                          : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _initialDepreciationValueController,
                              decoration: _inputDecoration(
                                'Giá trị khấu hao ban đầu',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _initialDepreciationPeriodController,
                              decoration: _inputDecoration(
                                'Kỳ khấu hao ban đầu',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _liquidationValueController,
                              decoration: _inputDecoration('Giá trị thanh lý'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _assetModelController,
                              decoration: _inputDecoration('Mô hình tài sản'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value:
                                  depreciationMethods.contains(
                                        _depreciationMethodController.text,
                                      )
                                      ? _depreciationMethodController.text
                                      : null,
                              decoration: _inputDecoration(
                                'Phương pháp khấu hao',
                              ),
                              items:
                                  depreciationMethods
                                      .map(
                                        (m) => DropdownMenuItem(
                                          value: m,
                                          child: Text(m),
                                        ),
                                      )
                                      .toList(),
                              onChanged:
                                  (v) => setState(
                                    () =>
                                        _depreciationMethodController.text =
                                            v ?? '',
                                  ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _depreciationPeriodsController,
                              decoration: _inputDecoration('Số kỳ khấu hao'),
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
                              decoration: _inputDecoration('Tài khoản tài sản'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _depreciationAccountController,
                              decoration: _inputDecoration(
                                'Tài khoản khấu hao',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _costAccountController,
                              decoration: _inputDecoration('Tài khoản chi phí'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value:
                                  assetGroups.contains(
                                        _assetGroupController.text,
                                      )
                                      ? _assetGroupController.text
                                      : null,
                              decoration: _inputDecoration('Nhóm tài sản'),
                              items:
                                  assetGroups
                                      .map(
                                        (g) => DropdownMenuItem(
                                          value: g,
                                          child: Text(g),
                                        ),
                                      )
                                      .toList(),
                              onChanged:
                                  (v) => setState(
                                    () => _assetGroupController.text = v ?? '',
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _entryDateController,
                              decoration: _inputDecoration('Ngày vào sổ'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _usageDateController,
                              decoration: _inputDecoration('Ngày sử dụng'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _projectController,
                              decoration: _inputDecoration('Dự án'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _fundingSourceController,
                              decoration: _inputDecoration('Nguồn kinh phí'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _symbolController,
                              decoration: _inputDecoration('Ký hiệu'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _symbolNumberController,
                              decoration: _inputDecoration('Số ký hiệu'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _capacityController,
                              decoration: _inputDecoration('Công suất'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _countryOfOriginController,
                              decoration: _inputDecoration('Nước sản xuất'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _yearOfManufactureController,
                              decoration: _inputDecoration('Năm sản xuất'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _reasonForIncreaseController,
                              decoration: _inputDecoration('Lý do tăng'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _statusController,
                              decoration: _inputDecoration('Hiện trạng'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _quantityController,
                              decoration: _inputDecoration('Số lượng'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _unitController,
                              decoration: _inputDecoration('Đơn vị tính'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _noteController,
                              decoration: _inputDecoration('Ghi chú'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _initialUsageUnitController,
                              decoration: _inputDecoration(
                                'Đơn vị sử dụng ban đầu',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _currentUnitController,
                              decoration: _inputDecoration('Đơn vị hiện thời'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: _initialUnitCreated,
                            onChanged: (value) {
                              setState(() {
                                _initialUnitCreated = value ?? false;
                              });
                            },
                          ),
                          const Text('Khởi tạo Đơn vị ban đầu'),
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
        ),
      ),
    );
  }
}
