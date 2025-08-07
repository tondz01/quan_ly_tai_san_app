// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/common/input/common_checkbox_input.dart';
import 'package:quan_ly_tai_san_app/common/web_view/web_view_common.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/component/columns_asset_handover_component.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/component/table_asset_movement_detail.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_detail_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/asset_handover_provider.dart';
import 'package:se_gay_components/common/sg_indicator.dart';
import 'package:se_gay_components/common/sg_text.dart';

class AssetHandoverDetail extends StatefulWidget {
  final AssetHandoverProvider provider;
  final bool isEditing;
  final bool isNew;

  const AssetHandoverDetail({
    super.key,
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
  bool isExpanded = false;

  String? proposingUnit;

  AssetHandoverDto? item;
  AssetHandoverDetailDto? itemDetail;

  // Lưu trữ giá trị ban đầu để so sánh
  Map<String, dynamic> _originalValues = {};

  @override
  void initState() {
    _initData();

    super.initState();
  }

  @override
  void didUpdateWidget(AssetHandoverDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Kiểm tra nếu có thay đổi trong item hoặc isEditing
    if (oldWidget.provider.item != item ||
        oldWidget.isEditing != widget.isEditing) {
      // Cập nhật lại trạng thái editing
      if (mounted) {
        _initData();
        setState(() {});
      }
    }
  }

  void _initData() {
    if (!mounted) return; // Kiểm tra nếu widget đã bị dispose

    item = widget.provider.item;
    isEditing = widget.isEditing;
    if (item != null) {
      if (item!.state == 0) {
        isEditing = true;
      }
      itemDetail = item!.assetHandoverDetails;
    } else {
      isEditing = true;
    }
    isUnitConfirm = itemDetail?.isUnitConfirm ?? false;
    isDelivererConfirm = itemDetail?.isDelivererConfirm ?? false;
    isReceiverConfirm = itemDetail?.isReceiverConfirm ?? false;
    isRepresentativeUnitConfirm =
        itemDetail?.isRepresentativeUnitConfirm ?? false;

    // itemsRequester =
    //     users.isNotEmpty
    //         ? users
    //             .map(
    //               (user) => DropdownMenuItem<String>(
    //                 value: user.id ?? '',
    //                 child: Text(user.name ?? ''),
    //               ),
    //             )
    //             .toList()
    //         : <DropdownMenuItem<String>>[];

    // Cập nhật controllers với dữ liệu mới
    _updateControllers();

    // Lưu giá trị ban đầu để so sánh
    _saveOriginalValues();
  }

  void _updateControllers() {
    if (!mounted) return; // Kiểm tra nếu widget đã bị dispose

    // Cập nhật các controller với dữ liệu mới
    controllerHandoverNumber.text = item?.decisionNumber ?? '';
    controllerDocumentName.text = item?.name ?? '';
    controllerOrder.text = item?.order ?? '';
    controllerSenderUnit.text = item?.senderUnit ?? '';
    controllerReceiverUnit.text = item?.receiverUnit ?? '';
    controllerTransferDate.text = item?.transferDate ?? '';
    controllerLeader.text = itemDetail?.leader ?? '';
    controllerIssuingUnitRepresentative.text =
        itemDetail?.issuingUnitRepresentative ?? '';
    controllerDelivererRepresentative.text =
        itemDetail?.delivererRepresentative ?? '';
    controllerReceiverRepresentative.text =
        itemDetail?.receiverRepresentative ?? '';
    controllerRepresentativeUnit.text = itemDetail?.representativeUnit ?? '';

    // Thêm listener cho các controller để theo dõi thay đổi
    _addControllerListeners();
  }

  void _addControllerListeners() {
    // Xóa listener cũ nếu có
    controllerHandoverNumber.removeListener(_checkForChanges);
    controllerDocumentName.removeListener(_checkForChanges);
    controllerOrder.removeListener(_checkForChanges);
    controllerSenderUnit.removeListener(_checkForChanges);
    controllerReceiverUnit.removeListener(_checkForChanges);
    controllerTransferDate.removeListener(_checkForChanges);
    controllerLeader.removeListener(_checkForChanges);
    controllerIssuingUnitRepresentative.removeListener(_checkForChanges);
    controllerDelivererRepresentative.removeListener(_checkForChanges);
    controllerReceiverRepresentative.removeListener(_checkForChanges);
    controllerRepresentativeUnit.removeListener(_checkForChanges);

    // Thêm listener mới
    controllerHandoverNumber.addListener(_checkForChanges);
    controllerDocumentName.addListener(_checkForChanges);
    controllerOrder.addListener(_checkForChanges);
    controllerSenderUnit.addListener(_checkForChanges);
    controllerReceiverUnit.addListener(_checkForChanges);
    controllerTransferDate.addListener(_checkForChanges);
    controllerLeader.addListener(_checkForChanges);
    controllerIssuingUnitRepresentative.addListener(_checkForChanges);
    controllerDelivererRepresentative.addListener(_checkForChanges);
    controllerReceiverRepresentative.addListener(_checkForChanges);
    controllerRepresentativeUnit.addListener(_checkForChanges);
  }

  void _saveOriginalValues() {
    _originalValues = {
      'decisionNumber': item?.decisionNumber ?? '',
      'name': item?.name ?? '',
      'order': item?.order ?? '',
      'senderUnit': item?.senderUnit ?? '',
      'receiverUnit': item?.receiverUnit ?? '',
      'transferDate': item?.transferDate ?? '',
      'leader': itemDetail?.leader ?? '',
      'issuingUnitRepresentative': itemDetail?.issuingUnitRepresentative ?? '',
      'delivererRepresentative': itemDetail?.delivererRepresentative ?? '',
      'receiverRepresentative': itemDetail?.receiverRepresentative ?? '',
      'representativeUnit': itemDetail?.representativeUnit ?? '',
      'isUnitConfirm': itemDetail?.isUnitConfirm ?? false,
      'isDelivererConfirm': itemDetail?.isDelivererConfirm ?? false,
      'isReceiverConfirm': itemDetail?.isReceiverConfirm ?? false,
      'isRepresentativeUnitConfirm':
          itemDetail?.isRepresentativeUnitConfirm ?? false,
    };
    // Sử dụng addPostFrameCallback để tránh gọi trong quá trình build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.provider.hasUnsavedChanges = false;
      }
    });
  }

  void _checkForChanges() {
    if (!isEditing) return;

    bool hasChanges = false;
    // Kiểm tra thay đổi trong các controller
    hasChanges =
        hasChanges ||
        controllerHandoverNumber.text != _originalValues['decisionNumber'] ||
        controllerDocumentName.text != _originalValues['name'] ||
        controllerOrder.text != _originalValues['order'] ||
        controllerSenderUnit.text != _originalValues['senderUnit'] ||
        controllerReceiverUnit.text != _originalValues['receiverUnit'] ||
        controllerTransferDate.text != _originalValues['transferDate'] ||
        controllerLeader.text != _originalValues['leader'] ||
        controllerIssuingUnitRepresentative.text !=
            _originalValues['issuingUnitRepresentative'] ||
        controllerDelivererRepresentative.text !=
            _originalValues['delivererRepresentative'] ||
        controllerReceiverRepresentative.text !=
            _originalValues['receiverRepresentative'] ||
        controllerRepresentativeUnit.text !=
            _originalValues['representativeUnit'];
    log('message hasChanges1: $hasChanges');
    // Kiểm tra thay đổi trong các checkbox
    hasChanges =
        hasChanges ||
        isUnitConfirm != _originalValues['isUnitConfirm'] ||
        isDelivererConfirm != _originalValues['isDelivererConfirm'] ||
        isReceiverConfirm != _originalValues['isReceiverConfirm'] ||
        isRepresentativeUnitConfirm !=
            _originalValues['isRepresentativeUnitConfirm'];
    log('message hasChanges2: $hasChanges');
    if (hasChanges != widget.provider.hasUnsavedChanges) {
      // Sử dụng addPostFrameCallback để tránh gọi setState trong quá trình build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.provider.hasUnsavedChanges = hasChanges;
        }
      });
    }
    log('message hasUnsavedChanges: ${widget.provider.hasUnsavedChanges}');
  }

  // Phương thức để lưu thay đổi
  void _saveChanges() {
    // Sau khi lưu thành công, reset trạng thái unsaved changes
    _saveOriginalValues();
    // Không cần gọi lại vì _saveOriginalValues đã xử lý
  }

  // Phương thức để hủy thay đổi
  void _cancelChanges() {
    // Reset về giá trị ban đầu
    _updateControllers();
    setState(() {
      isUnitConfirm = _originalValues['isUnitConfirm'] ?? false;
      isDelivererConfirm = _originalValues['isDelivererConfirm'] ?? false;
      isReceiverConfirm = _originalValues['isReceiverConfirm'] ?? false;
      isRepresentativeUnitConfirm =
          _originalValues['isRepresentativeUnitConfirm'] ?? false;
    });
    // Sử dụng addPostFrameCallback để tránh gọi trong quá trình build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.provider.hasUnsavedChanges = false;
      }
    });
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

  List<DropdownMenuItem<String>> itemsRequester = [];

  @override
  void dispose() {
    // Giải phóng các controller
    controllerHandoverNumber.dispose();
    controllerDocumentName.dispose();
    controllerOrder.dispose();
    controllerSenderUnit.dispose();
    controllerReceiverUnit.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: _buildTableDetail(),
      ),
    );
  }

  Widget _buildTableDetail() {
    final screenWidth = MediaQuery.of(context).size.width;
    bool isWideScreen = screenWidth > 800;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Hiển thị indicator unsaved changes và nút Save/Cancel
            if (isEditing)
              Row(
                children: [
                  if (widget.provider.hasUnsavedChanges)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Có thay đổi chưa lưu',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Lưu'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _cancelChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Hủy'),
                  ),
                ],
              ),
            SgIndicator(
              steps: [
                'Nháp',
                'Sẵn sàng',
                'Xác nhận',
                'Trình duyệt',
                'Hoàn thành',
                'Hủy',
              ],
              currentStep: item?.state ?? 0,
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
              // detail
              // _buildInfoAssetHandoverMobile(isWideScreen),
              _buildInfoAssetHandoverMobile(isWideScreen),
              const SizedBox(height: 20),
              if (!isEditing)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: TableAssetMovementDetail(
                    item: item?.assetHandoverMovements,
                  ),
                ),
              previewDocumentAssetTransfer(item),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoAssetHandoverMobile(bool isWideScreen) {
    if (isWideScreen) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildInfoAssetHandover()),
          const SizedBox(width: 20),
          Expanded(child: _buildAssetHandoverDetail()),
        ],
      );
    } else {
      return Column(
        children: [_buildInfoAssetHandover(), _buildAssetHandoverDetail()],
      );
    }
  }

  Widget _buildInfoAssetHandover() {
    return Column(
      children: [
        CommonFormInput(
          label: 'ah.handover_number'.tr,
          controller: controllerHandoverNumber,
          isEditing: isEditing,
          textContent: '',
          onChanged: (value) {
            _checkForChanges();
          },
        ),
        CommonFormInput(
          label: 'ah.document_name'.tr,
          controller: controllerDocumentName,
          isEditing: isEditing,
          textContent: item?.name ?? '',
          onChanged: (value) {
            _checkForChanges();
          },
        ),
        CommonFormInput(
          label: 'ah.order'.tr,
          controller: controllerOrder,
          isEditing: isEditing,
          textContent: item?.order ?? '',
          onChanged: (value) {
            _checkForChanges();
          },
        ),
        CommonFormInput(
          label: 'ah.sender_unit'.tr,
          controller: controllerSenderUnit,
          isEditing: isEditing,
          textContent: item?.senderUnit ?? '',
          isDropdown: true,
          items: itemsrReceivingUnit,
          onChanged: (value) {
            _checkForChanges();
          },
        ),
        CommonFormInput(
          label: 'ah.receiver_unit'.tr,
          controller: controllerReceiverUnit,
          isEditing: isEditing,
          textContent: item?.receiverUnit ?? '',
          isDropdown: true,
          items: itemsrReceivingUnit,
          onChanged: (value) {
            _checkForChanges();
          },
        ),
        CommonFormInput(
          label: 'ah.transfer_date'.tr,
          controller: controllerTransferDate,
          isEditing: isEditing,
          textContent: item?.transferDate ?? '',
          onChanged: (value) {
            _checkForChanges();
          },
        ),
        CommonFormInput(
          label: 'ah.leader'.tr,
          controller: controllerLeader,
          isEditing: isEditing,
          textContent: itemDetail?.leader ?? '',
          isDropdown: true,
          items: itemsRequester,
          onChanged: (value) {
            _checkForChanges();
          },
        ),
      ],
    );
  }

  Widget _buildAssetHandoverDetail() {
    return Column(
      children: [
        CommonFormInput(
          label: 'ah.issuing_unit_representative'.tr,
          controller: controllerIssuingUnitRepresentative,
          isEditing: isEditing,
          textContent: itemDetail?.issuingUnitRepresentative ?? '',
          isDropdown: true,
          items: itemsRequester,
          onChanged: (value) {
            _checkForChanges();
          },
        ),
        CommonCheckboxInput(
          label: 'ah.unit_confirm'.tr,
          value: isUnitConfirm,
          isEditing: isEditing,
          isEnable: true,
          onChanged: (newValue) {
            setState(() {
              isUnitConfirm = newValue;
            });
            _checkForChanges();
          },
        ),
        CommonFormInput(
          label: 'ah.deliverer_representative'.tr,
          controller: controllerDelivererRepresentative,
          isEditing: isEditing,
          textContent: itemDetail?.delivererRepresentative ?? '',
          isDropdown: true,
          items: itemsRequester,
          onChanged: (value) {
            _checkForChanges();
          },
        ),
        CommonCheckboxInput(
          label: 'ah.deliverer_confirm'.tr,
          value: isDelivererConfirm,
          isEditing: isEditing,
          isEnable: true,
          onChanged: (newValue) {
            setState(() {
              isDelivererConfirm = newValue;
            });
            _checkForChanges();
          },
        ),
        CommonFormInput(
          label: 'ah.receiver_representative'.tr,
          controller: controllerReceiverRepresentative,
          isEditing: isEditing,
          textContent: itemDetail?.receiverRepresentative ?? '',
          isDropdown: true,
          items: itemsRequester,
          onChanged: (value) {
            _checkForChanges();
          },
        ),
        CommonCheckboxInput(
          label: 'ah.receiver_confirm'.tr,
          value: isReceiverConfirm,
          isEditing: isEditing,
          isEnable: true,
          onChanged: (newValue) {
            setState(() {
              isReceiverConfirm = newValue;
            });
            _checkForChanges();
          },
        ),
        CommonFormInput(
          label: 'ah.representative_unit'.tr,
          controller: controllerRepresentativeUnit,
          isEditing: isEditing,
          textContent: itemDetail?.representativeUnit ?? '',
          isDropdown: true,
          items: itemsRequester,
          onChanged: (value) {
            _checkForChanges();
          },
        ),
        CommonCheckboxInput(
          label: 'ah.representative_unit_confirm'.tr,
          value: isRepresentativeUnitConfirm,
          isEditing: isEditing,
          isEnable: true,
          onChanged: (newValue) {
            setState(() {
              isRepresentativeUnitConfirm = newValue;
            });
            _checkForChanges();
          },
        ),
      ],
    );
  }

  Widget previewDocumentAssetTransfer(AssetHandoverDto? item) {
    return InkWell(
      onTap: () {
        showWebViewPopup(context, url: url, title: 'Preview Document');
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2.5),
            child: SGText(
              text: "Xem trước tài liệu",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ColorValue.link,
              ),
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.visibility, color: ColorValue.link, size: 18),
        ],
      ),
    );
  }
}
