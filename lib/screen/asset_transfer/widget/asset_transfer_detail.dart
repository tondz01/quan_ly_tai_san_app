// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/common/table/sg_asset_movement_table.dart';
import 'package:quan_ly_tai_san_app/common/table/sg_editable_table.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/asset_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/movement_detail_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/user.dart';
import 'package:quan_ly_tai_san_app/screen/note/widget/note_view.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_dropdown_input_button.dart';
import 'package:se_gay_components/common/sg_indicator.dart';
import 'package:se_gay_components/common/sg_input_text.dart';

class AssetTransferDetail extends StatefulWidget {
  final AssetTransferDto? item;
  final bool isEditing;

  const AssetTransferDetail({super.key, this.item, this.isEditing = false});

  @override
  State<AssetTransferDetail> createState() => _AssetTransferDetailState();
}

class _AssetTransferDetailState extends State<AssetTransferDetail> {
  // Các controller để quản lý dữ liệu nhập liệu
  late TextEditingController controllerDecisionNumber = TextEditingController();
  late TextEditingController controllerDocumentName = TextEditingController();
  late TextEditingController controllerDeliveringUnit = TextEditingController();
  late TextEditingController controllerReceivingUnit = TextEditingController();
  late TextEditingController controllerRequester = TextEditingController();
  late TextEditingController controllerProposingUnit = TextEditingController();
  late TextEditingController controllerQuantity = TextEditingController();
  late TextEditingController controllerDepartmentApproval =
      TextEditingController();
  late TextEditingController controllerEffectiveDate = TextEditingController();
  late TextEditingController controllerEffectiveDateTo =
      TextEditingController();
  late TextEditingController controllerApprover = TextEditingController();
  late TextEditingController controllerDeliveryLocation =
      TextEditingController();
  late TextEditingController controllerViewerDepartments =
      TextEditingController();
  late TextEditingController controllerViewerUsers = TextEditingController();
  late TextEditingController controllerReason = TextEditingController();
  late TextEditingController controllerBase = TextEditingController();
  late TextEditingController controllerArticle1 = TextEditingController();
  late TextEditingController controllerArticle2 = TextEditingController();
  late TextEditingController controllerArticle3 = TextEditingController();
  late TextEditingController controllerDestination = TextEditingController();

  bool isEditing = false;

  bool isPreparerInitialed = false;
  bool isRequireManagerApproval = false;
  bool isDeputyConfirmed = false;

  String? proposingUnit;

  // Lista de controladores y etiquetas para los términos del contrato
  final Map<String, TextEditingController> contractTermsControllers = {};

  @override
  void initState() {
    isEditing = widget.isEditing;
    if (widget.item != null && widget.item!.status == 0) {
      isEditing = true;
    }
    isPreparerInitialed = widget.item?.preparerInitialed ?? false;
    isRequireManagerApproval = widget.item?.requireManagerApproval ?? false;
    isDeputyConfirmed = widget.item?.deputyConfirmed ?? false;

    // Inicializar controladores de términos del contrato
    for (final term in contractTerms) {
      contractTermsControllers[term] = TextEditingController();
    }

    // Crear directamente DropdownMenuItem<String>
    itemsRequester =
        users
            .map(
              (user) => DropdownMenuItem<String>(
                value: user.id ?? '',
                child: Text(user.name ?? ''),
              ),
            )
            .toList();
    super.initState();
  }

  final List<DropdownMenuItem<String>> itemsrReceivingUnit = [
    const DropdownMenuItem(value: 'Ban giám đốc', child: Text('Ban giám đốc')),
    const DropdownMenuItem(
      value: 'Chưa xác định / C.Ty TNHH MTV Môi trường - Vinacomin',
      child: Text('Chưa xác định / C.Ty TNHH MTV Môi trường - Vinacomin'),
    ),
    const DropdownMenuItem(
      value: 'Chưa xác định',
      child: Text('Chưa xác định'),
    ),
    const DropdownMenuItem(
      value: 'Công ty CP Cơ điện Uông bí - Vinacomin',
      child: Text('Công ty CP Cơ điện Uông bí - Vinacomin'),
    ),
    const DropdownMenuItem(
      value: 'Công ty TNHH Nam Hưng',
      child: Text('Công ty TNHH Nam Hưng'),
    ),
    const DropdownMenuItem(value: 'Công đoàn', child: Text('Công đoàn')),
    const DropdownMenuItem(value: 'Kho Công ty', child: Text('Kho Công ty')),
    const DropdownMenuItem(
      value: 'Phân xưởng KT1',
      child: Text('Phân xưởng KT1'),
    ),
    const DropdownMenuItem(
      value: 'P.xưởng Thông gió - thoát nước mỏ 1',
      child: Text('P.xưởng Thông gió - thoát nước mỏ 1'),
    ),
  ];

  late final List<DropdownMenuItem<String>> itemsRequester;

  // Lista de términos del contrato
  final List<String> contractTerms = [
    'Về việc',
    'Căn cứ',
    'Điều 1',
    'Điều 2',
    'Điều 3',
    'Nơi nhận',
  ];

  @override
  void dispose() {
    // Giải phóng các controller
    controllerDecisionNumber.dispose();
    controllerDocumentName.dispose();
    controllerDeliveringUnit.dispose();
    controllerReceivingUnit.dispose();
    controllerRequester.dispose();
    controllerProposingUnit.dispose();
    controllerQuantity.dispose();
    controllerDepartmentApproval.dispose();
    controllerEffectiveDate.dispose();
    controllerEffectiveDateTo.dispose();
    controllerApprover.dispose();
    controllerDeliveryLocation.dispose();
    controllerViewerDepartments.dispose();
    controllerViewerUsers.dispose();

    // Dispose de los controladores de términos del contrato
    for (final controller in contractTermsControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  void findPhongBan(String? value) {
    log('message');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    log('screenWidth: $screenWidth');
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: _showResponsive(),
      ),
    );
  }

  Widget _showResponsive() {
    final size = MediaQuery.of(context).size;
    if (size.width < 1444) {
      return Column(
        children: [
          _buildTableDetail(),
          const SizedBox(height: 10),
          _buildNoteSection(),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 4, child: _buildTableDetail()),
          const SizedBox(width: 10),
          Expanded(flex: 2, child: _buildNoteSection()),
        ],
      );
    }
  }

  Widget _buildNoteSection() {
    return SizedBox(
      height: 400,
      // padding: const EdgeInsets.all(8),
      // decoration: BoxDecoration(
      //   // color: Colors.white,
      //   borderRadius: BorderRadius.circular(8),
      //   border: Border.all(color: Colors.grey.shade300),
      // ),
      child: IgnorePointer(
        ignoring: false,
        child: AbsorbPointer(
          absorbing: false,
          child: RepaintBoundary(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return const NoteView();
              },
            ),
          ),
        ),
      ),
    );
  }

  // String _formatCurrency(double value) {
  //   return value
  //       .toStringAsFixed(2)
  //       .replaceAll('.00', '')
  //       .replaceAllMapped(
  //         RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
  //         (Match m) => '${m[1]}.',
  //       );
  // }
  Widget _buildTableDetail() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SgIndicator(
              steps: [
                'Nháp',
                'Chờ xác nhận',
                'Xác nhận',
                'Trình duyệt',
                'Duyệt',
                'Từ chối',
                'Hủy',
                'Hoàn thành',
              ],
              currentStep: widget.item?.status ?? 0,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(
                label: 'at.decision_number'.tr,
                controller: controllerDecisionNumber,
                isEditing: false,
                textContent: widget.item?.decisionNumber ?? '',
              ),
              _buildDetailRow(
                label: 'at.document_name'.tr,
                controller: controllerDocumentName,
                isEditing: false,
                textContent: widget.item?.documentName ?? '',
              ),
              _buildDetailRow(
                label: 'at.delivering_unit'.tr,
                controller: controllerDeliveringUnit,
                isEditing: isEditing,
                textContent: widget.item?.deliveringUnit ?? '',
                isDropdown: true,
                items: itemsrReceivingUnit,
              ),
              _buildDetailRow(
                label: 'at.receiving_unit'.tr,
                controller: controllerReceivingUnit,
                isEditing: isEditing,
                textContent: widget.item?.receivingUnit ?? '',
                isDropdown: true,
              ),
              _buildDetailRow(
                label: 'at.requester'.tr,
                controller: controllerRequester,
                isEditing: isEditing,
                textContent: widget.item?.requester ?? '',
                isDropdown: true,
                items: itemsRequester,
                onChanged: (value) {
                  setState(() {
                    proposingUnit =
                        users.firstWhere((user) => user.id == value).department;
                    log('proposingUnit: $proposingUnit');
                  });
                  log('value: $value');
                },
              ),
              _buildDetailCheckBox(
                label: 'at.preparer_initialed'.tr,
                valueBoolean: isPreparerInitialed,
                isEditing: isEditing,
                isEnable: false,
              ),
              _buildDetailCheckBox(
                label: 'at.require_manager_approval'.tr,
                valueBoolean: isRequireManagerApproval,
                isEditing: isEditing,
                isEnable: false,
              ),
              if (isRequireManagerApproval)
                _buildDetailCheckBox(
                  label: 'at.deputy_confirmed'.tr,
                  valueBoolean: isDeputyConfirmed,
                  isEditing: isEditing,
                  isEnable: false,
                ),
              _buildDetailRow(
                label: 'at.proposing_unit'.tr,
                controller: controllerProposingUnit,
                isEditing: false,
                textContent: proposingUnit ?? '',
                inputType: TextInputType.number,
              ),
              _buildDetailRow(
                label: 'at.department_approval'.tr,
                controller: controllerDepartmentApproval,
                isEditing: isEditing,
                textContent: widget.item?.departmentApproval ?? '',
              ),
              _buildDetailRow(
                label: 'at.effective_date'.tr,
                controller: controllerEffectiveDate,
                isEditing: isEditing,
                textContent: widget.item?.effectiveDate ?? '',
              ),
              _buildDetailRow(
                label: 'at.effective_date_to'.tr,
                controller: controllerEffectiveDateTo,
                isEditing: isEditing,
                textContent: widget.item?.effectiveDateTo ?? '',
              ),
              _buildDetailRow(
                label: 'at.approver'.tr,
                controller: controllerApprover,
                isEditing: isEditing,
                textContent: widget.item?.approver ?? '',
              ),
              _buildDetailRow(
                label: 'at.delivery_location'.tr,
                controller: controllerDeliveryLocation,
                isEditing: isEditing,
                textContent: widget.item?.deliveryLocation ?? '',
              ),
              _buildDetailRow(
                label: 'at.viewer_departments'.tr,
                controller: controllerViewerDepartments,
                isEditing: isEditing,
                textContent: '',
              ),
              _buildDetailRow(
                label: 'at.viewerUsers'.tr,
                controller: controllerViewerUsers,
                isEditing: isEditing,
                textContent: '',
              ),
              _buildContracterms(),
              const SizedBox(height: 20),
              _buildAssetMovementTable(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAssetMovementTable() {
    log('_buildAssetMovementTable: ${widget.item?.movementDetails!.length}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: const Text(
            'Chi tiết tài sản điều chuyển',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SgEditableTable<MovementDetailDto>(
          initialData: widget.item?.movementDetails ?? [],
          createEmptyItem: MovementDetailDto.empty,
          rowHeight: 40.0,
          headerBackgroundColor: Colors.grey.shade50,
          oddRowBackgroundColor: Colors.white,
          evenRowBackgroundColor: Colors.white,
          showVerticalLines: false,
          showHorizontalLines: true,
          addRowText: 'Thêm một dòng',
          isEditing: isEditing, // Pass the editing state
          onDataChanged: (data) {
            log('Asset movement data changed: ${data.length} items');
          },
          columns: [
            SgEditableColumn<MovementDetailDto>(
              field: 'asset',
              title: 'Tài sản',
              titleAlignment: TextAlign.center,
              width: 350,
              getValue: (item) => item.name,
              setValue: (item, value) => item.name = value,
              sortValueGetter: (item) => item.name,
            ),
            SgEditableColumn<MovementDetailDto>(
              field: 'unit',
              title: 'Đơn vị tính',
              titleAlignment: TextAlign.center,
              width: 130,
              getValue: (item) => item.measurementUnit,
              setValue: (item, value) => item.measurementUnit = value,
              sortValueGetter: (item) => item.measurementUnit,
            ),
            SgEditableColumn<MovementDetailDto>(
              field: 'quantity',
              title: 'Số lượng',
              titleAlignment: TextAlign.center,
              width: 120,
              getValue: (item) => item.quantity,
              setValue: (item, value) => item.quantity = value,
              sortValueGetter:
                  (item) => int.tryParse(item.quantity ?? '0') ?? 0,
            ),
            SgEditableColumn<MovementDetailDto>(
              field: 'condition',
              title: 'Tình trạng kỹ thuật',
              titleAlignment: TextAlign.center,
              width: 190,
              getValue: (item) => item.setCondition,
              setValue: (item, value) => item.setCondition = value,
              sortValueGetter: (item) => item.setCondition,
            ),
            SgEditableColumn<MovementDetailDto>(
              field: 'note',
              title: 'Ghi chú',
              titleAlignment: TextAlign.center,
              width: 150,
              getValue: (item) => item.note,
              setValue: (item, value) => item.note = value,
              sortValueGetter: (item) => item.note,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContracterms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...contractTerms.map(
          (term) => _buildDetailRow(
            label: term,
            controller: contractTermsControllers[term]!,
            isEditing: isEditing,
            textContent: '',
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String textContent,
    required TextEditingController controller,
    required bool isEditing,
    bool isDropdown = false,
    bool isValidate = false,
    bool isEnable = true,
    TextInputType? inputType,
    List<DropdownMenuItem<String>>? items,
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              '$label :',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color:
                    !isEditing ? Colors.black87.withOpacity(0.6) : Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isDropdown && isEditing
                    ? SGDropdownInputButton<String>(
                      height: 35,
                      controller: controller,
                      textOverflow: TextOverflow.ellipsis,
                      // Use value directly rather than setting controller.text
                      value: textContent,
                      defaultValue: textContent,
                      items: items ?? [],
                      colorBorder: SGAppColors.neutral400,
                      showUnderlineBorderOnly: true,
                      enableSearch: false,
                      isClearController: false,
                      fontSize: 16,
                      inputType: inputType,
                      isShowSuffixIcon: true,
                      hintText: 'Chọn ${label.toLowerCase()}',
                      textAlign: TextAlign.left,
                      textAlignItem: TextAlign.left,
                      sizeBorderCircular: 10,
                      contentPadding: const EdgeInsets.only(top: 8, bottom: 8),
                      onChanged: (value) {
                        if (value != null) {
                          log('value: $value');
                          // controller.text = value;
                          onChanged?.call(value);
                        }
                      },
                    )
                    : SGInputText(
                      height: 35,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      controller: controller..text = textContent,
                      borderRadius: 10,
                      enabled: isEnable ? isEditing : false,
                      textAlign: TextAlign.left,
                      readOnly: !isEditing,
                      inputFormatters:
                          inputType == TextInputType.number
                              ? [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.,]'),
                                ),
                              ]
                              : null,
                      onlyLine: true,
                      color: Colors.black,
                      showBorder: isEditing,
                      hintText: !isEditing ? '' : '${'common.hint'.tr} $label',
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                    ),
                if (isValidate) const Divider(height: 1, color: Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCheckBox({
    required String label,
    required bool valueBoolean,
    required bool isEditing,
    required bool isEnable,
  }) {
    // Primero, obtener el valor actual para este checkbox
    bool currentValue = valueBoolean;
    if (label == 'at.preparer_initialed'.tr) {
      currentValue = isPreparerInitialed;
    } else if (label == 'at.require_manager_approval'.tr) {
      currentValue = isRequireManagerApproval;
    } else if (label == 'at.deputy_confirmed'.tr) {
      currentValue = isDeputyConfirmed;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: Text(
              '$label :',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color:
                    !isEnable ? Colors.black : Colors.black87.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(width: 18),
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: currentValue,
              onChanged:
                  !isEnable
                      ? (newValue) {
                        setState(() {
                          // Actualizar el estado correcto según el label
                          if (label == 'at.preparer_initialed'.tr) {
                            isPreparerInitialed = newValue ?? false;
                            log(
                              'isPreparerInitialed cambiado a: $isPreparerInitialed',
                            );
                          } else if (label ==
                              'at.require_manager_approval'.tr) {
                            isRequireManagerApproval = newValue ?? false;
                            log(
                              'isRequireManagerApproval cambiado a: $isRequireManagerApproval',
                            );
                          } else if (label == 'at.deputy_confirmed'.tr) {
                            isDeputyConfirmed = newValue ?? false;
                            log(
                              'isDeputyConfirmed cambiado a: $isDeputyConfirmed',
                            );
                          }
                        });
                      }
                      : null,
              activeColor: const Color(0xFF80C9CB),
              checkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
    );
  }
}
