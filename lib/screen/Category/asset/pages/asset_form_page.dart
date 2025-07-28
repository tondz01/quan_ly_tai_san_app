import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/asset/bloc/asset_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/asset/bloc/asset_event.dart';
import 'package:quan_ly_tai_san_app/screen/category/asset/models/asset.dart';
import 'package:se_gay_components/common/sg_button.dart';
import 'package:se_gay_components/common/sg_textfield.dart';

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
  // Tạo controller cho tất cả 30 trường
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

  @override
  void initState() {
    super.initState();
    _assetIdController = TextEditingController(text: widget.asset?.assetId ?? '');
    _originalPriceController = TextEditingController(text: widget.asset?.originalPrice ?? '');
    _initialDepreciationValueController = TextEditingController(text: widget.asset?.initialDepreciationValue ?? '');
    _initialDepreciationPeriodController = TextEditingController(text: widget.asset?.initialDepreciationPeriod ?? '');
    _liquidationValueController = TextEditingController(text: widget.asset?.liquidationValue ?? '');
    _assetModelController = TextEditingController(text: widget.asset?.assetModel ?? '');
    _depreciationMethodController = TextEditingController(text: widget.asset?.depreciationMethod ?? '');
    _depreciationPeriodsController = TextEditingController(text: widget.asset?.depreciationPeriods ?? '');
    _assetAccountController = TextEditingController(text: widget.asset?.assetAccount ?? '');
    _depreciationAccountController = TextEditingController(text: widget.asset?.depreciationAccount ?? '');
    _costAccountController = TextEditingController(text: widget.asset?.costAccount ?? '');
    _assetGroupController = TextEditingController(text: widget.asset?.assetGroup ?? '');
    _entryDateController = TextEditingController(text: widget.asset?.entryDate ?? '');
    _usageDateController = TextEditingController(text: widget.asset?.usageDate ?? '');
    _projectController = TextEditingController(text: widget.asset?.project ?? '');
    _fundingSourceController = TextEditingController(text: widget.asset?.fundingSource ?? '');
    _symbolController = TextEditingController(text: widget.asset?.symbol ?? '');
    _symbolNumberController = TextEditingController(text: widget.asset?.symbolNumber ?? '');
    _capacityController = TextEditingController(text: widget.asset?.capacity ?? '');
    _countryOfOriginController = TextEditingController(text: widget.asset?.countryOfOrigin ?? '');
    _yearOfManufactureController = TextEditingController(text: widget.asset?.yearOfManufacture ?? '');
    _reasonForIncreaseController = TextEditingController(text: widget.asset?.reasonForIncrease ?? '');
    _statusController = TextEditingController(text: widget.asset?.status ?? '');
    _quantityController = TextEditingController(text: widget.asset?.quantity ?? '');
    _unitController = TextEditingController(text: widget.asset?.unit ?? '');
    _noteController = TextEditingController(text: widget.asset?.note ?? '');
    _initialUsageUnitController = TextEditingController(text: widget.asset?.initialUsageUnit ?? '');
    _currentUnitController = TextEditingController(text: widget.asset?.currentUnit ?? '');
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

  void _save() {
    if (_formKey.currentState!.validate()) {
      final asset = AssetDTO(
        assetId: _assetIdController.text.trim(),
        originalPrice: _originalPriceController.text.trim(),
        initialDepreciationValue: _initialDepreciationValueController.text.trim(),
        initialDepreciationPeriod: _initialDepreciationPeriodController.text.trim(),
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        margin: EdgeInsets.only(top: 16),
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        isEdit ? 'Cập nhật thông tin tài sản' : 'Thêm mới tài sản',
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
                    color: Colors.grey.withOpacity(0.2),
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
                              // Tất cả 30 trường được chia thành các nhóm
                              Row(
                                children: [
                                  Expanded(child: SGTextField(controller: _assetIdController, label: 'Mã tài sản', validator: (v) => v == null || v.isEmpty ? 'Nhập mã tài sản' : null)),
                                  const SizedBox(width: 25),
                                  Expanded(child: SGTextField(controller: _originalPriceController, label: 'Nguyên giá', validator: (v) => v == null || v.isEmpty ? 'Nhập nguyên giá' : null)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: SGTextField(controller: _initialDepreciationValueController, label: 'Giá trị khấu hao ban đầu')),
                                  const SizedBox(width: 25),
                                  Expanded(child: SGTextField(controller: _initialDepreciationPeriodController, label: 'Kỳ khấu hao ban đầu')),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: SGTextField(controller: _liquidationValueController, label: 'Giá trị thanh lý')),
                                  const SizedBox(width: 25),
                                  Expanded(child: SGTextField(controller: _assetModelController, label: 'Mô hình tài sản')),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: SGTextField(controller: _depreciationMethodController, label: 'Phương pháp khấu hao')),
                                  const SizedBox(width: 25),
                                  Expanded(child: SGTextField(controller: _depreciationPeriodsController, label: 'Số kỳ khấu hao')),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: SGTextField(controller: _assetAccountController, label: 'Tài khoản tài sản')),
                                  const SizedBox(width: 25),
                                  Expanded(child: SGTextField(controller: _depreciationAccountController, label: 'Tài khoản khấu hao')),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: SGTextField(controller: _costAccountController, label: 'Tài khoản chi phí')),
                                  const SizedBox(width: 25),
                                  Expanded(child: SGTextField(controller: _assetGroupController, label: 'Nhóm tài sản')),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: SGTextField(controller: _entryDateController, label: 'Ngày vào sổ')),
                                  const SizedBox(width: 25),
                                  Expanded(child: SGTextField(controller: _usageDateController, label: 'Ngày sử dụng')),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: SGTextField(controller: _projectController, label: 'Dự án')),
                                  const SizedBox(width: 25),
                                  Expanded(child: SGTextField(controller: _fundingSourceController, label: 'Nguồn kinh phí')),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: SGTextField(controller: _symbolController, label: 'Ký hiệu')),
                                  const SizedBox(width: 25),
                                  Expanded(child: SGTextField(controller: _symbolNumberController, label: 'Số ký hiệu')),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: SGTextField(controller: _capacityController, label: 'Công suất')),
                                  const SizedBox(width: 25),
                                  Expanded(child: SGTextField(controller: _countryOfOriginController, label: 'Nước sản xuất')),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: SGTextField(controller: _yearOfManufactureController, label: 'Năm sản xuất')),
                                  const SizedBox(width: 25),
                                  Expanded(child: SGTextField(controller: _reasonForIncreaseController, label: 'Lý do tăng')),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: SGTextField(controller: _statusController, label: 'Hiện trạng')),
                                  const SizedBox(width: 25),
                                  Expanded(child: SGTextField(controller: _quantityController, label: 'Số lượng')),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: SGTextField(controller: _unitController, label: 'Đơn vị tính')),
                                  const SizedBox(width: 25),
                                  Expanded(child: SGTextField(controller: _noteController, label: 'Ghi chú')),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: SGTextField(controller: _initialUsageUnitController, label: 'Đơn vị sử dụng ban đầu')),
                                  const SizedBox(width: 25),
                                  Expanded(child: SGTextField(controller: _currentUnitController, label: 'Đơn vị hiện thời')),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
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
                          SGButton(
                            text: isEdit ? 'Cập nhật' : 'Thêm mới',
                            onPressed: _save,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 