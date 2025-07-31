// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/common/table/sg_editable_table.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/component/bottom_table_asset_handover.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_detail_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_movement_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/asset_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/user.dart';
import 'package:quan_ly_tai_san_app/screen/note/widget/note_view.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_dropdown_input_button.dart';
import 'package:se_gay_components/common/sg_indicator.dart';
import 'package:se_gay_components/common/sg_input_text.dart';

class AssetHandoverDetail extends StatefulWidget {
  final AssetHandoverProvider provider;
  final AssetHandoverDto? item;
  final bool isEditing;
  final bool isNew;

  const AssetHandoverDetail({
    super.key,
    this.item,
    this.isEditing = false,
    this.isNew = false,
    required this.provider,
  });

  @override
  State<AssetHandoverDetail> createState() => _AssetHandoverDetailState();
}

class _AssetHandoverDetailState extends State<AssetHandoverDetail> {
  late TextEditingController controllerHandoverNumber = TextEditingController();
  late TextEditingController controllerDocumentName = TextEditingController();
  late TextEditingController controllerOrder = TextEditingController();
  late TextEditingController controllerSenderUnit = TextEditingController();
  late TextEditingController controllerReceiverUnit = TextEditingController();
  late TextEditingController controllerTransferDate = TextEditingController();
  late TextEditingController controllerLeader = TextEditingController();
  late TextEditingController controllerIssuingUnitRepresentative =
      TextEditingController();
  late TextEditingController controllerDelivererRepresentative =
      TextEditingController();
  late TextEditingController controllerReceiverRepresentative =
      TextEditingController();
  late TextEditingController controllerRepresentativeUnit =
      TextEditingController();

  bool isEditing = false;

  bool isUnitConfirm = false;
  bool isDelivererConfirm = false;
  bool isReceiverConfirm = false;
  bool isRepresentativeUnitConfirm = false;

  String? proposingUnit;

  final Map<String, TextEditingController> contractTermsControllers = {};

  AssetHandoverDetailDto? itemDetail;

  @override
  void initState() {
    isEditing = widget.isEditing;
    if (widget.item != null) {
      if (widget.item!.state == 1) {
        isEditing = true;
      }
      itemDetail = widget.item!.assetHandoverDetails;
    } else if (widget.isNew) {
      isEditing = true;
    }
    isUnitConfirm = itemDetail?.isUnitConfirm ?? false;
    isDelivererConfirm = itemDetail?.isDelivererConfirm ?? false;
    isReceiverConfirm = itemDetail?.isReceiverConfirm ?? false;
    isRepresentativeUnitConfirm =
        itemDetail?.isRepresentativeUnitConfirm ?? false;

    for (final term in contractTerms) {
      contractTermsControllers[term] = TextEditingController();
    }

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
    controllerHandoverNumber.dispose();
    controllerDocumentName.dispose();
    controllerOrder.dispose();
    controllerSenderUnit.dispose();
    controllerReceiverUnit.dispose();

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
                'Sẵn sàng',
                'Xác nhận',
                'Trình duyệt',
                'Hoàn thành',
                'Hủy',
              ],
              currentStep: widget.item?.state ?? 0,
              fontSize: 10,
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
                label: 'ah.handover_number'.tr,
                controller: controllerHandoverNumber,
                isEditing: isEditing,
                textContent: '',
                isShowHint: false,
              ),
              _buildDetailRow(
                label: 'ah.document_name'.tr,
                controller: controllerDocumentName,
                isEditing: isEditing,
                textContent: widget.item?.name ?? '',
              ),
              _buildDetailRow(
                label: 'ah.order'.tr,
                controller: controllerOrder,
                isEditing: isEditing,
                textContent: widget.item?.order ?? '',
              ),
              _buildDetailRow(
                label: 'ah.sender_unit'.tr,
                controller: controllerSenderUnit,
                isEditing: isEditing,
                textContent: widget.item?.senderUnit ?? '',
                isDropdown: true,
                items: itemsrReceivingUnit,
              ),
              _buildDetailRow(
                label: 'ah.receiver_unit'.tr,
                controller: controllerReceiverUnit,
                isEditing: isEditing,
                textContent: widget.item?.receiverUnit ?? '',
                isDropdown: true,
                items: itemsrReceivingUnit,
              ),
              _buildDetailRow(
                label: 'ah.transfer_date'.tr,
                controller: controllerTransferDate,
                isEditing: isEditing,
                textContent: widget.item?.transferDate ?? '',
              ),
              _buildDetailRow(
                label: 'ah.leader'.tr,
                controller: controllerLeader,
                isEditing: isEditing,
                textContent: itemDetail?.leader ?? '',
                isDropdown: true,
                items: itemsRequester,
              ),
              // detail
              _buildAssetHandoverDetail(),
              const SizedBox(height: 20),
              _buildAssetMovementTable(),
              const SizedBox(height: 20),
              if (widget.item != null)
                BottomTableAssetHandover(
                  data: [widget.item!],
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAssetMovementTable() {
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
        SgEditableTable<AssetHandoverMovementDto>(
          initialData: widget.item?.assetHandoverMovements ?? [],
          createEmptyItem: AssetHandoverMovementDto.empty,
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
            SgEditableColumn<AssetHandoverMovementDto>(
              field: 'asset',
              title: 'Tài sản',
              titleAlignment: TextAlign.center,
              width: 350,
              getValue: (item) => item.name,
              setValue: (item, value) => item.name = value,
              sortValueGetter: (item) => item.name,
            ),
            SgEditableColumn<AssetHandoverMovementDto>(
              field: 'unit',
              title: 'Đơn vị tính',
              titleAlignment: TextAlign.center,
              width: 130,
              getValue: (item) => item.measurementUnit,
              setValue: (item, value) => item.measurementUnit = value,
              sortValueGetter: (item) => item.measurementUnit,
            ),
            SgEditableColumn<AssetHandoverMovementDto>(
              field: 'quantity',
              title: 'Số lượng',
              titleAlignment: TextAlign.center,
              width: 120,
              getValue: (item) => item.quantity,
              setValue: (item, value) => item.quantity = value,
              sortValueGetter:
                  (item) => int.tryParse(item.quantity ?? '0') ?? 0,
            ),
            SgEditableColumn<AssetHandoverMovementDto>(
              field: 'condition',
              title: 'Tình trạng kỹ thuật',
              titleAlignment: TextAlign.center,
              width: 190,
              getValue: (item) => item.setCondition,
              setValue: (item, value) => item.setCondition = value,
              sortValueGetter: (item) => item.setCondition,
            ),
            SgEditableColumn<AssetHandoverMovementDto>(
              field: 'countryOfOrigin',
              title: 'Nước sản xuất',
              titleAlignment: TextAlign.center,
              width: 150,
              getValue: (item) => item.countryOfOrigin,
              setValue: (item, value) => item.countryOfOrigin = value,
              sortValueGetter: (item) => item.countryOfOrigin,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAssetHandoverDetail() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Kiểm tra nếu màn hình đủ rộng để hiển thị 2 cột
        bool isWideScreen = constraints.maxWidth > 800;

        if (isWideScreen) {
          // Layout 2 cột
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cột trái
              Expanded(
                child: Column(
                  children: [
                    _buildDetailRow(
                      label: 'ah.issuing_unit_representative'.tr,
                      controller: controllerIssuingUnitRepresentative,
                      isEditing: isEditing,
                      textContent: itemDetail?.issuingUnitRepresentative ?? '',
                      isDropdown: true,
                      items: itemsRequester,
                    ),
                    _buildDetailCheckBox(
                      label: 'ah.unit_confirm'.tr,
                      valueBoolean: isUnitConfirm,
                      isEditing: isEditing,
                      isEnable: true,
                    ),
                    _buildDetailRow(
                      label: 'ah.deliverer_representative'.tr,
                      controller: controllerDelivererRepresentative,
                      isEditing: isEditing,
                      textContent: itemDetail?.delivererRepresentative ?? '',
                      isDropdown: true,
                      items: itemsRequester,
                    ),
                    _buildDetailCheckBox(
                      label: 'ah.deliverer_confirm'.tr,
                      valueBoolean: isDelivererConfirm,
                      isEditing: isEditing,
                      isEnable: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // Cột phải
              Expanded(
                child: Column(
                  children: [
                    _buildDetailRow(
                      label: 'ah.receiver_representative'.tr,
                      controller: controllerReceiverRepresentative,
                      isEditing: isEditing,
                      textContent: itemDetail?.receiverRepresentative ?? '',
                      isDropdown: true,
                      items: itemsRequester,
                    ),
                    _buildDetailCheckBox(
                      label: 'ah.receiver_confirm'.tr,
                      valueBoolean: isReceiverConfirm,
                      isEditing: isEditing,
                      isEnable: true,
                    ),
                    _buildDetailRow(
                      label: 'ah.representative_unit'.tr,
                      controller: controllerRepresentativeUnit,
                      isEditing: isEditing,
                      textContent: itemDetail?.representativeUnit ?? '',
                      isDropdown: true,
                      items: itemsRequester,
                    ),
                    _buildDetailCheckBox(
                      label: 'ah.representative_unit_confirm'.tr,
                      valueBoolean: isRepresentativeUnitConfirm,
                      isEditing: isEditing,
                      isEnable: true,
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          // Layout 1 cột cho màn hình nhỏ
          return Column(
            children: [
              _buildDetailRow(
                label: 'ah.issuing_unit_representative'.tr,
                controller: controllerIssuingUnitRepresentative,
                isEditing: isEditing,
                textContent: itemDetail?.issuingUnitRepresentative ?? '',
                isDropdown: true,
                items: itemsRequester,
              ),
              _buildDetailCheckBox(
                label: 'ah.unit_confirm'.tr,
                valueBoolean: isUnitConfirm,
                isEditing: isEditing,
                isEnable: true,
              ),
              _buildDetailRow(
                label: 'ah.deliverer_representative'.tr,
                controller: controllerDelivererRepresentative,
                isEditing: isEditing,
                textContent: itemDetail?.delivererRepresentative ?? '',
                isDropdown: true,
                items: itemsRequester,
              ),
              _buildDetailCheckBox(
                label: 'ah.deliverer_confirm'.tr,
                valueBoolean: isDelivererConfirm,
                isEditing: isEditing,
                isEnable: true,
              ),
              _buildDetailRow(
                label: 'ah.receiver_representative'.tr,
                controller: controllerReceiverRepresentative,
                isEditing: isEditing,
                textContent: itemDetail?.receiverRepresentative ?? '',
                isDropdown: true,
                items: itemsRequester,
              ),
              _buildDetailCheckBox(
                label: 'ah.receiver_confirm'.tr,
                valueBoolean: isReceiverConfirm,
                isEditing: isEditing,
                isEnable: true,
              ),
              _buildDetailRow(
                label: 'ah.representative_unit'.tr,
                controller: controllerRepresentativeUnit,
                isEditing: isEditing,
                textContent: itemDetail?.representativeUnit ?? '',
                isDropdown: true,
                items: itemsRequester,
              ),
              _buildDetailCheckBox(
                label: 'ah.representative_unit_confirm'.tr,
                valueBoolean: isRepresentativeUnitConfirm,
                isEditing: isEditing,
                isEnable: true,
              ),
            ],
          );
        }
      },
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
    bool isShowHint = true,
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
                      hintText: isShowHint ? 'Chọn ${label.toLowerCase()}' : '',
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
                      hintText:
                          !isEditing
                              ? ''
                              : isShowHint
                              ? '${'common.hint'.tr} $label'
                              : '',
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
    if (label == 'ah.preparer_initialed'.tr) {
      currentValue = isUnitConfirm;
    } else if (label == 'ah.require_manager_approval'.tr) {
      currentValue = isDelivererConfirm;
    } else if (label == 'ah.deputy_confirmed'.tr) {
      currentValue = isReceiverConfirm;
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
                          if (label == 'ah.preparer_initialed'.tr) {
                            isUnitConfirm = newValue ?? false;
                            log(
                              'isPreparerInitialed cambiado a: $isUnitConfirm',
                            );
                          } else if (label ==
                              'ah.require_manager_approval'.tr) {
                            isDelivererConfirm = newValue ?? false;
                            log(
                              'isRequireManagerApproval cambiado a: $isDelivererConfirm',
                            );
                          } else if (label == 'ah.deputy_confirmed'.tr) {
                            isReceiverConfirm = newValue ?? false;
                            log(
                              'isDeputyConfirmed cambiado a: $isReceiverConfirm',
                            );
                          } else if (label == 'ah.representative_unit'.tr) {
                            isRepresentativeUnitConfirm = newValue ?? false;
                            log(
                              'isRepresentativeUnitConfirm cambiado a: $isRepresentativeUnitConfirm',
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
