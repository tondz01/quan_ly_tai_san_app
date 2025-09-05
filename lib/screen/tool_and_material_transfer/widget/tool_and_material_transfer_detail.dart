// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:quan_ly_tai_san_app/common/input/common_checkbox_input.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_date.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/widgets/additional_signers_selector.dart';
import 'package:quan_ly_tai_san_app/common/widgets/document_upload_widget.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/core/utils/uuid_generator.dart';
import 'package:quan_ly_tai_san_app/main.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/component/preview_document_tool_and_meterial_transfer.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/component/tool_and_material_transfer_table.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/detail_tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/provider/tool_and_material_transfer_provider.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/repository/detail_tool_and_material_transfer_repository.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/request/tool_and_material_transfer_request.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/ownership_unit_detail_dto.dart';
import 'package:se_gay_components/common/sg_indicator.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

import '../bloc/tool_and_material_transfer_bloc.dart';
import '../bloc/tool_and_material_transfer_event.dart';
import '../bloc/tool_and_material_transfer_state.dart';

class ToolAndMaterialTransferDetail extends StatefulWidget {
  final bool isEditing;
  final bool? isNew;
  final ToolAndMaterialTransferProvider provider;
  final int type;

  const ToolAndMaterialTransferDetail({
    super.key,
    this.isEditing = false,
    this.isNew = false,
    required this.provider,
    required this.type,
  });

  @override
  State<ToolAndMaterialTransferDetail> createState() =>
      _ToolAndMaterialTransferDetailState();
}

final dieuDongTaiSanDetailKey =
    GlobalKey<_ToolAndMaterialTransferDetailState>();

class _ToolAndMaterialTransferDetailState
    extends State<ToolAndMaterialTransferDetail> {
  late TextEditingController controllerSoChungTu = TextEditingController();
  late TextEditingController controllerSubject = TextEditingController();
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
  late TextEditingController controllerTPDonViGiao = TextEditingController();
  late TextEditingController controllerPPDonViNhan = TextEditingController();
  late TextEditingController controllerNguoiKyNhay = TextEditingController();

  bool isEditing = false;
  bool isNguoiLapPhieuKyNhay = false;
  bool _isUploading = false;
  bool isRefreshing = false;
  bool isNew = false;

  String? proposingUnit;
  bool controllersInitialized = false;
  String? _selectedFileName;
  String? _selectedFilePath;
  Uint8List? _selectedFileBytes;
  String idCongTy = 'CT001';
  int typeTransfer = 1;
  List<DetailToolAndMaterialTransferDto> listNewDetails = [];
  List<DetailToolAndMaterialTransferDto> _initialDetails = [];
  List<NhanVien> listStaffByDepartment = [];

  List<NhanVien?> additionalSigners = [];
  final List<TextEditingController> additionalSignerControllers = [];
  List<AdditionalSignerData> additionalSignersDetailed = [];
  List<OwnershipUnitDetailDto> listOwnershipUnit = [];

  PhongBan? donViGiao;
  PhongBan? donViNhan;
  PhongBan? donViDeNghi;
  // NhanVien? nguoiDeNghi;
  UserInfoDTO? nguoiLapPhieu;
  NhanVien? nguoiKyCapPhong;
  NhanVien? nguoiKyGiamDoc;
  NhanVien? nguoiKyNhay;
  ToolAndMaterialTransferDto? itemPreview;

  List<NhanVien> listNhanVienThamMuu = [];
  List<AdditionalSignerData> initialDataSignersNew = [];

  late ToolAndMaterialTransferDto? item;

  final Map<String, TextEditingController> contractTermsControllers = {};

  final List<ToolAndMaterialTransferDto> listAssetHandover = [];

  Map<String, bool> _validationErrors = {};
  PdfDocument? _document;

  bool _validateForm() {
    Map<String, bool> newValidationErrors = {};

    if (controllerDocumentName.text.isEmpty) {
      newValidationErrors['documentName'] = true;
    }

    if (controllerSubject.text.isEmpty) {
      newValidationErrors['subject'] = true;
    }

    if (controllerDeliveringUnit.text.isEmpty) {
      newValidationErrors['deliveringUnit'] = true;
    }

    if (controllerReceivingUnit.text.isEmpty) {
      newValidationErrors['receivingUnit'] = true;
    }

    if (controllerEffectiveDate.text.isEmpty) {
      newValidationErrors['effectiveDate'] = true;
    }

    if (controllerEffectiveDateTo.text.isEmpty) {
      newValidationErrors['effectiveDateTo'] = true;
    }

    if (controllerRequester.text.isEmpty) {
      newValidationErrors['requester'] = true;
    }

    // If it's a new item, document is required
    if (item == null && _selectedFileName == null) {
      newValidationErrors['document'] = true;
    }

    // Only update state if validation errors have changed
    bool hasChanges = !mapEquals(_validationErrors, newValidationErrors);
    if (hasChanges) {
      setState(() {
        _validationErrors = newValidationErrors;
      });
    }

    return newValidationErrors.isEmpty;
  }

  // late NhanVienProvider nhanVienProvider;

  @override
  void initState() {
    super.initState();
    item = widget.provider.item;
    _callGetListAssetHandover();
    isEditing = widget.isEditing;

    if (item != null && item!.trangThai == 0) {
      isEditing = true;
    }
    onReload();
  }

  Future<void> _loadPdf(String path) async {
    final document = await PdfDocument.openFile(path);
    setState(() {
      _document = document;
    });
  }

  Future<void> _loadPdfNetwork(String nameFile) async {
    try {
      final document = await PdfDocument.openUri(
        Uri.parse("${Config.baseUrl}/api/upload/preview/$nameFile"),
      );
      setState(() {
        _document = document;
      });
    } catch (e) {
      setState(() {
        _document = null;
      });
      SGLog.error("Error loading PDF", e.toString());
    }
  }

  @override
  void didUpdateWidget(ToolAndMaterialTransferDetail oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Kiểm tra nếu provider item thay đổi
    if (widget.provider.item != oldWidget.provider.item) {
      _refreshWidget();
    }

    // Kiểm tra nếu isNew thay đổi
    if (widget.isNew != oldWidget.isNew) {
      _refreshWidget();
    }

    // Kiểm tra nếu isEditing thay đổi
    if (widget.isEditing != oldWidget.isEditing) {
      _refreshWidget();
    }
  }

  bool editable() {
    return (item != null &&
        (item!.trangThai == 0 || item!.trangThai == 2) &&
        item!.nguoiTao == widget.provider.userInfo?.tenDangNhap);
  }

  // Method để làm mới widget
  void _refreshWidget() {
    setState(() {
      listNewDetails.clear();
      item = null;
      nguoiLapPhieu = widget.provider.userInfo;
      // Reset item từ provider
      item = widget.provider.item;
      isNew = item == null;

      // Reset editing state
      isEditing = widget.isEditing;
      if (editable()) {
        isEditing = true;
      } else {
        isEditing = false;
      }

      if (item != null) {
        log(
          'message test1 item: ${jsonEncode(item!.detailToolAndMaterialTransfers)}',
        );
        controllerSoChungTu.text = item?.id ?? '';
        controllerSubject.text = item?.trichYeu ?? '';
        controllerDocumentName.text = item?.tenPhieu ?? '';
        controllerDeliveringUnit.text = item?.tenDonViGiao ?? '';
        controllerReceivingUnit.text = item?.tenDonViNhan ?? '';
        controllerRequester.text = item?.tenNguoiDeNghi ?? '';
        controllerDepartmentApproval.text = item?.tenTrinhDuyetCapPhong ?? '';
        controllerEffectiveDate.text = item?.tggnTuNgay ?? '';
        controllerEffectiveDateTo.text = item?.tggnDenNgay ?? '';
        controllerApprover.text = item?.tenTrinhDuyetGiamDoc ?? '';
        controllerDeliveryLocation.text = item?.diaDiemGiaoNhan ?? '';

        // Initialize selected file if available
        _selectedFileName = item?.tenFile;
        _selectedFilePath = item?.duongDanFile;

        //load date value dropdown
        donViGiao = widget.provider.getPhongBanByID(item?.idDonViGiao ?? '');
        listStaffByDepartment =
            widget.provider.dataNhanVien
                .where((element) => element.phongBanId == donViGiao!.id)
                .toList();
        donViNhan = widget.provider.getPhongBanByID(item?.idDonViNhan ?? '');
        donViDeNghi = widget.provider.getPhongBanByID(
          item?.idDonViDeNghi ?? '',
        );
        listNhanVienThamMuu =
            widget.provider.dataNhanVien
                .where((element) => element.phongBanId == donViDeNghi!.id)
                .toList();
        // nguoiDeNghi = widget.provider.getNhanVienByID(
        //   item?.idNguoiDeNghi ?? '',
        // );
        nguoiKyNhay = widget.provider.getNhanVienByID(
          item?.idNguoiKyNhay ?? '',
        );
        nguoiKyCapPhong = widget.provider.getNhanVienByID(
          item?.idTrinhDuyetCapPhong ?? '',
        );
        nguoiKyGiamDoc = widget.provider.getNhanVienByID(
          item?.idTrinhDuyetGiamDoc ?? '',
        );
        controllerNguoiKyNhay.text = item?.idNguoiKyNhay ?? '';

        isNguoiLapPhieuKyNhay = item?.nguoiLapPhieuKyNhay ?? false;
        proposingUnit = item?.tenDonViDeNghi;

        // Lưu snapshot chi tiết ban đầu để so sánh
        _initialDetails = List<DetailToolAndMaterialTransferDto>.from(
          item?.detailToolAndMaterialTransfers ??
              <DetailToolAndMaterialTransferDto>[],
        );

        initialDataSignersNew =
            item?.listSignatory
                ?.map(
                  (e) => AdditionalSignerData(
                    employee: widget.provider.getNhanVienByID(
                      e.idNguoiKy ?? '',
                    ),
                    department: widget.provider.getPhongBanByID(
                      e.idNguoiKy ?? '',
                    ),
                    signed: e.trangThai == 1,
                  ),
                )
                .toList() ??
            [];
        controllersInitialized = true;

        additionalSignersDetailed =
            item?.listSignatory
                ?.map(
                  (e) => AdditionalSignerData(
                    employee: widget.provider.getNhanVienByID(
                      e.idNguoiKy ?? '',
                    ),
                  ),
                )
                .toList() ??
            [];
        log(
          'message test additionalSignersDetailed: ${jsonEncode(additionalSignersDetailed)}',
        );
        _loadPdfNetwork(item?.tenFile ?? '');
      } else {
        controllerSoChungTu.text = UUIDGenerator.generateWithFormat(
          'SCT-************',
        );
        controllerSubject.text = '';
        controllerDocumentName.text = '';
        controllerDeliveringUnit.text = '';
        controllerReceivingUnit.text = '';
        controllerRequester.text = '';
        controllerDepartmentApproval.text = '';
        controllerEffectiveDate.text = '';
        controllerEffectiveDateTo.text = '';
        controllerApprover.text = '';
        controllerDeliveryLocation.text = '';
        controllerProposingUnit.text = '';
        controllerNguoiKyNhay.text = '';

        controllersInitialized = false;
        _selectedFileName = null;
        _selectedFilePath = null;
        isNguoiLapPhieuKyNhay = false;
        donViGiao = null;
        donViNhan = null;
        NhanVien nhanVienLogin = widget.provider.getNhanVienByID(
          widget.provider.userInfo?.tenDangNhap ?? '',
        );
        donViDeNghi = widget.provider.getPhongBanByID(
          nhanVienLogin.phongBanId ?? '',
        );

        listNhanVienThamMuu =
            widget.provider.dataNhanVien
                .where((element) => element.phongBanId == donViDeNghi!.id)
                .toList();
        controllerProposingUnit.text = donViDeNghi?.tenPhongBan ?? '';
        nguoiKyNhay = nhanVienLogin;
        controllerRequester.text = nguoiKyNhay!.hoTen ?? '';
        additionalSigners.clear();
        additionalSignerControllers.clear();
        additionalSignersDetailed.clear();
      }

      // if (proposingUnit != null &&
      //     proposingUnit!.isNotEmpty &&
      //     !_controllersInitialized) {
      //   controllerProposingUnit.text = proposingUnit!;
      // }

      // Reset các biến trạng thái
      isNguoiLapPhieuKyNhay = item?.nguoiLapPhieuKyNhay ?? false;
      proposingUnit = item?.tenDonViDeNghi;

      _validationErrors.clear();

      controllersInitialized = false;

      _isUploading = false;
      isRefreshing = false;
    });

    if (donViGiao != null) {
      listStaffByDepartment =
          widget.provider.dataNhanVien
              .where((element) => element.phongBanId == donViGiao!.id)
              .toList();
    }
  }

  late List<DropdownMenuItem<String>> itemsRequester = [];

  @override
  void dispose() {
    // Giải phóng các controller
    controllerSubject.dispose();
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

    for (final controller in contractTermsControllers.values) {
      controller.dispose();
    }

    // Reset initialization flag
    controllersInitialized = false;

    super.dispose();
  }

  void findPhongBan(String? value) {
    log('message');
  }

  List<Map<String, dynamic>> _normalizeDetails(
    List<DetailToolAndMaterialTransferDto> list,
  ) {
    final data =
        list
            .map(
              (d) => {
                'idCCDCVatTu': d.idCCDCVatTu,
                'donViTinh': d.donViTinh,
                'soLuong': d.soLuong,
                'soLuongXuat': d.soLuongXuat,
                'ghiChu': d.ghiChu,
              },
            )
            .toList();
    data.sort(
      (a, b) =>
          (a['idCCDCVatTu'] as String).compareTo(b['idCCDCVatTu'] as String),
    );
    return data;
  }

  bool _detailsChanged() {
    if (item == null) return listNewDetails.isNotEmpty;
    final beforeJson = jsonEncode(_normalizeDetails(_initialDetails));
    final afterJson = jsonEncode(_normalizeDetails(listNewDetails));
    return beforeJson != afterJson;
  }

  Future<void> _syncDetails(String idDieuDongTaiSan) async {
    try {
      final repo = DetailToolAndMaterialTransferRepository();
      for (final d in _initialDetails) {
        if (d.id.isNotEmpty) {
          await repo.delete(d.id);
        }
      }
      for (final d in listNewDetails) {
        await repo.create(
          DetailToolAndMaterialTransferDto(
            id: d.id,
            tenPhieu: d.tenPhieu,
            soLuong: d.soLuong,
            ghiChu: d.ghiChu,
            ngayTao: d.ngayTao,
            ngayCapNhat: d.ngayCapNhat,
            nguoiTao: widget.provider.userInfo?.tenDangNhap ?? '',
            nguoiCapNhat: '',
            isActive: true,
            idCCDCVatTu: d.idCCDCVatTu,
            idDieuDongCCDCVatTu: d.idDieuDongCCDCVatTu,
            soLuongXuat: d.soLuongXuat,
            soQuyetDinh: '',
            namSanXuat: d.namSanXuat,
            donViTinh: d.donViTinh,
            tenCCDCVatTu: d.tenCCDCVatTu,
            congSuat: d.congSuat,
            nuocSanXuat: d.nuocSanXuat,
            soKyHieu: d.soKyHieu,
            kyHieu: d.kyHieu,
          ),
        );
      }
      log('message test1 item!.id: ${item!.id}');
    } catch (e) {
      log('Sync details error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    log('screenWidth: $screenWidth');

    _checkAndRefreshWidget();

    if (item == null && !isRefreshing) {
      log('item == null');
      onReload();
      isEditing = true;
      isRefreshing = true;
    }

    return MultiBlocListener(
      listeners: [
        // Lắng nghe từ AssetHandoverBloc
        BlocListener<ToolAndMaterialTransferBloc, ToolAndMaterialTransferState>(
          listener: (context, state) {
            if (state is GetListToolAndMaterialTransferSuccessState) {
              // Handle successful data loading
              listAssetHandover.clear();
              listAssetHandover.addAll(state.data);
              log('Asset handover data loaded successfully');
            } else if (state is GetListToolAndMaterialTransferFailedState) {
            } else if (state is ToolAndMaterialTransferLoadingState) {
              // Show loading indicator
              setState(() {
                _isUploading = true;
              });
            } else if (state is ToolAndMaterialTransferLoadingDismissState) {
              // Hide loading indicator
              setState(() {
                _isUploading = false;
              });
            }
          },
        ),
      ],
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: _buildTableDetail(),
        ),
      ),
    );
  }

  Widget _buildTableDetail() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Visibility(
                  visible: isEditing,
                  child: MaterialTextButton(
                    text: 'Lưu',
                    icon: Icons.save,
                    backgroundColor: ColorValue.success,
                    foregroundColor: Colors.white,
                    onPressed: () {
                      _handleSave();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Visibility(
                  visible: isEditing,
                  child: MaterialTextButton(
                    text: 'Hủy',
                    icon: Icons.cancel,
                    backgroundColor: ColorValue.error,
                    foregroundColor: Colors.white,
                    onPressed: () {
                      showConfirmDialog(
                        context,
                        type: ConfirmType.delete,
                        title:
                            'Xác nhận hủy tạo phiếu ${widget.provider.getScreenTitle()}',
                        cancelText: 'Không',
                        confirmText: 'Có',
                        message:
                            'Bạn có chắc chắn muốn hủy? Các thay đổi chưa được lưu sẽ bị mất.',
                        onCancel: () {
                          // Navigator.pop(context); // Close dialog
                        },
                        onConfirm: () {
                          widget.provider.onCloseDetail(context);
                          // Navigator.pop(context); // Close dialog
                        },
                      );
                    },
                  ),
                ),
                Visibility(
                  visible: item != null && ![0, 5, 6].contains(item!.trangThai),
                  child: MaterialTextButton(
                    text: 'Hủy phiếu ${widget.provider.getScreenTitle()}',
                    icon: Icons.cancel,
                    backgroundColor: ColorValue.error,
                    foregroundColor: Colors.white,
                    onPressed: () {
                      showConfirmDialog(
                        context,
                        type: ConfirmType.delete,
                        title: 'Xác nhận hủy phiếu',
                        cancelText: 'Không',
                        confirmText: 'Có, hủy phiếu',
                        message:
                            'Bạn có chắc chắn muốn hủy phiếu ${widget.provider.getScreenTitle()} này không?',
                        onCancel: () {},
                        onConfirm: () {
                          widget.provider.onCloseDetail(context);
                          final assetHandoverBloc =
                              BlocProvider.of<ToolAndMaterialTransferBloc>(
                                context,
                              );
                          assetHandoverBloc.add(
                            CancelToolAndMaterialTransferEvent(
                              context,
                              item!.id.toString(),
                            ),
                          );
                          // Navigator.pop(context); // Close dialog
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(width: 5),
            SgIndicator(
              steps: ['Nháp', 'Duyệt', 'Hủy', 'Hoàn thành'],
              fontSize: 10,
              currentStep: item?.trangThai ?? 0,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 30,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        CommonFormInput(
                          label: 'Số chứng từ',
                          controller: controllerSoChungTu,
                          isEditing: false,
                          textContent: controllerSoChungTu.text,
                          fieldName: 'soChungTu',
                          validationErrors: _validationErrors,
                        ),
                        CommonFormInput(
                          label: 'Tên phiếu',
                          controller: controllerDocumentName,
                          isEditing: isEditing,
                          textContent: item?.tenPhieu ?? '',
                          fieldName: 'documentName',
                          validationErrors: _validationErrors,
                        ),
                        CommonFormInput(
                          label: 'Trích yêu',
                          controller: controllerSubject,
                          isEditing: isEditing,
                          textContent: item?.trichYeu ?? '',
                          fieldName: 'subject',
                          validationErrors: _validationErrors,
                        ),

                        CmFormDropdownObject<PhongBan>(
                          label: 'at.delivering_unit'.tr,
                          controller: controllerDeliveringUnit,
                          isEditing: isEditing,
                          value: donViGiao,
                          items: widget.provider.itemsDDPhongBan,
                          defaultValue:
                              controllerDeliveringUnit.text.isNotEmpty
                                  ? widget.provider.getPhongBanByID(
                                    controllerDeliveringUnit.text,
                                  )
                                  : null,
                          fieldName: 'delivering_unit',
                          validationErrors: _validationErrors,
                          onChanged: (value) async {
                            log('delivering_unit selected: $value');

                            setState(() {
                              donViGiao = value;
                              listStaffByDepartment =
                                  widget.provider.dataNhanVien
                                      .where(
                                        (element) =>
                                            element.phongBanId == donViGiao!.id,
                                      )
                                      .toList();
                            });

                            await widget.provider.getListOwnership(
                              donViGiao!.id.toString(),
                            );
                            // log('message test listOwnershipUnit: $listOwnershipUnit');
                          },
                        ),
                        CmFormDropdownObject<PhongBan>(
                          label: 'at.receiving_unit'.tr,
                          controller: controllerReceivingUnit,
                          isEditing: isEditing,
                          value: donViNhan,
                          items: widget.provider.itemsDDPhongBan,
                          defaultValue:
                              controllerReceivingUnit.text.isNotEmpty
                                  ? widget.provider.getPhongBanByID(
                                    controllerReceivingUnit.text,
                                  )
                                  : null,
                          fieldName: 'receivingUnit',
                          validationErrors: _validationErrors,
                          onChanged: (value) {
                            log('receivingUnit selected: $value');
                            donViNhan = value;
                          },
                        ),
                        CmFormDate(
                          label: 'at.effective_date'.tr,
                          controller: controllerEffectiveDate,
                          isEditing: isEditing,
                          onChanged: (value) {},
                          value:
                              controllerEffectiveDate.text.isNotEmpty
                                  ? AppUtility.parseFlexibleDateTime(
                                    controllerEffectiveDate.text,
                                  )
                                  : DateTime.now(),
                        ),
                        CmFormDate(
                          label: 'at.effective_date_to'.tr,
                          controller: controllerEffectiveDateTo,
                          isEditing: isEditing,
                          onChanged: (value) {},
                          value:
                              controllerEffectiveDateTo.text.isNotEmpty
                                  ? AppUtility.parseFlexibleDateTime(
                                    controllerEffectiveDateTo.text,
                                  )
                                  : DateTime.now(),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Column(
                      children: [
                        CmFormDropdownObject<PhongBan>(
                          label: 'Đơn vị đề nghị'.tr,
                          controller: controllerProposingUnit,
                          isEditing: isEditing,
                          value: donViDeNghi,
                          items: widget.provider.itemsDDPhongBan,
                          fieldName: 'receivingUnit',
                          validationErrors: _validationErrors,
                          defaultValue:
                              controllerProposingUnit.text.isNotEmpty
                                  ? widget.provider.getPhongBanByID(
                                    controllerProposingUnit.text,
                                  )
                                  : null,
                          onChanged: (value) {
                            log('receivingUnit selected: $value');
                            setState(() {
                              donViDeNghi = value;
                              listNhanVienThamMuu =
                                  widget.provider.dataNhanVien
                                      .where(
                                        (element) =>
                                            element.phongBanId ==
                                            donViDeNghi!.id,
                                      )
                                      .toList();
                            });
                          },
                        ),
                        CmFormDropdownObject<NhanVien>(
                          label: 'at.requester'.tr,
                          controller: controllerRequester,
                          isEditing: isEditing,
                          value: nguoiKyNhay,
                          items: [
                            ...listNhanVienThamMuu.map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.hoTen ?? ''),
                              ),
                            ),
                          ],
                          defaultValue:
                              controllerRequester.text.isNotEmpty
                                  ? widget.provider.getNhanVienByID(
                                    controllerRequester.text,
                                  )
                                  : null,
                          fieldName: 'requester',
                          validationErrors: _validationErrors,
                          onChanged: (value) {
                            log('requester selected: $value');
                            setState(() {
                              nguoiKyNhay = value;
                            });
                          },
                        ),
                        CommonCheckboxInput(
                          label: 'at.preparer_initialed'.tr,
                          value: isNguoiLapPhieuKyNhay,
                          isEditing: isEditing,
                          isDisabled: !isEditing,
                          onChanged: (newValue) {
                            setState(() {
                              isNguoiLapPhieuKyNhay = newValue;
                            });
                          },
                        ),

                        CmFormDropdownObject<NhanVien>(
                          label: 'at.department_approval'.tr,
                          controller: controllerDepartmentApproval,
                          isEditing: isEditing,
                          value: nguoiKyCapPhong,
                          items: [
                            ...listNhanVienThamMuu.map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.hoTen ?? ''),
                              ),
                            ),
                          ],
                          defaultValue:
                              controllerDepartmentApproval.text.isNotEmpty
                                  ? widget.provider.getNhanVienByID(
                                    controllerDepartmentApproval.text,
                                  )
                                  : null,
                          fieldName: 'departmentApproval',
                          validationErrors: _validationErrors,
                          onChanged: (value) {
                            nguoiKyCapPhong = value;
                          },
                        ),

                        CmFormDropdownObject<NhanVien>(
                          label: 'at.approver'.tr,
                          controller: controllerApprover,
                          isEditing: isEditing,
                          value: nguoiKyGiamDoc,
                          items: [
                            ...listNhanVienThamMuu.map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.hoTen ?? ''),
                              ),
                            ),
                          ],
                          defaultValue:
                              controllerApprover.text.isNotEmpty
                                  ? widget.provider.getNhanVienByID(
                                    controllerApprover.text,
                                  )
                                  : null,
                          fieldName: 'approver',
                          validationErrors: _validationErrors,
                          onChanged: (value) {
                            nguoiKyGiamDoc = value;
                          },
                        ),
                        AdditionalSignersSelector(
                          addButtonText: "Thêm đơn bị đại diện",
                          labelDepartment: "Đơn vị đại diện",
                          labelSigned: 'Người đại diện',
                          isEditing: isEditing,
                          itemsNhanVien: [
                            ...listStaffByDepartment.map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.hoTen ?? ''),
                              ),
                            ),
                          ],
                          phongBan: widget.provider.dataPhongBan,
                          listNhanVien: listStaffByDepartment,
                          initialSigners: additionalSigners,
                          onChanged: (list) {
                            setState(() {
                              additionalSigners
                                ..clear()
                                ..addAll(list);
                            });
                          },
                          initialSignerData: initialDataSignersNew,
                          onChangedDetailed: (list) {
                            setState(() {
                              additionalSignersDetailed = list;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              DocumentUploadWidget(
                isEditing: isEditing,
                selectedFileName: _selectedFileName,
                selectedFilePath: _selectedFilePath,
                validationErrors: _validationErrors,
                onFileSelected: (fileName, filePath, fileBytes) {
                  setState(() {
                    _selectedFileName = fileName;
                    _selectedFilePath = filePath;
                    _selectedFileBytes = fileBytes;
                    if (fileName != null) {
                      _loadPdf(filePath!);
                    }
                    if (_validationErrors.containsKey('document')) {
                      _validationErrors.remove('document');
                    }
                  });
                },
                // onUpload: _uploadWordDocument,
                isUploading: _isUploading,
                label: 'Tài liệu Quyết định',
                errorMessage: 'Tài liệu quyết định là bắt buộc',
                hintText: 'Định dạng hỗ trợ: .pdf',
                allowedExtensions: ['pdf'],
              ),

              // const SizedBox(height: 20),
              DetailToolAndMaterialTransferTable(
                context,
                isEditing: isEditing,
                initialDetails: item?.detailToolAndMaterialTransfers ?? [],
                allAssets: widget.provider.dataAsset ?? [],
                listOwnershipUnit: widget.provider.listOwnershipUnit,

                onDataChanged: (data) {
                  setState(() {
                    listNewDetails =
                        data
                            .map(
                              (e) => DetailToolAndMaterialTransferDto(
                                id: UUIDGenerator.generateWithFormat(
                                  'CTDD-****',
                                ),
                                idDieuDongCCDCVatTu: controllerSoChungTu.text,
                                soQuyetDinh: item?.soQuyetDinh ?? '',
                                tenPhieu: controllerDocumentName.text,
                                tenCCDCVatTu: e.asset?.ten ?? '',
                                congSuat: e.asset?.congSuat ?? '0',
                                nuocSanXuat: e.asset?.nuocSanXuat ?? '',
                                soKyHieu: e.asset?.soKyHieu ?? '',
                                kyHieu: e.asset?.kyHieu ?? '',
                                namSanXuat: e.namSanXuat,
                                idCCDCVatTu: e.idDetaiAsset,
                                donViTinh: e.donViTinh,
                                soLuong: e.soLuong,
                                ghiChu: e.ghiChu,
                                ngayTao: DateTime.now().toIso8601String(),
                                ngayCapNhat: DateTime.now().toIso8601String(),
                                nguoiTao: widget.provider.userInfo?.id ?? '',
                                nguoiCapNhat:
                                    widget.provider.userInfo?.id ?? '',
                                isActive: true,
                                soLuongXuat: e.soLuongXuat,
                              ),
                            )
                            .toList();
                    log(
                      "message test listNewDetails: ${jsonEncode(listNewDetails)}",
                    );
                    itemPreview = _createToolAndMaterialTransPreview(
                      widget.type,
                    );
                  });
                },
              ),

              SizedBox(height: 10),
              previewDocumentToolAndMaterialTransfer(
                context: context,
                item: item ?? itemPreview,
                provider: widget.provider,
                isDisabled: listNewDetails.isEmpty,
                document: _document,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void onReload() {
    _refreshWidget();
  }

  void refreshWidget() {
    _refreshWidget();
  }

  void _checkAndRefreshWidget() {
    if (widget.provider.item != item) {
      _refreshWidget();
    }

    if (widget.isNew == true && item != null) {
      _refreshWidget();
    }
  }

  void _callGetListAssetHandover() {
    try {
      final assetHandoverBloc = BlocProvider.of<ToolAndMaterialTransferBloc>(
        context,
      );
      assetHandoverBloc.add(
        GetListToolAndMaterialTransferEvent(context, typeTransfer, idCongTy),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi lấy danh sách: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  ToolAndMaterialTransferRequest _createToolAndMaterialTransRequest(
    int type,
    int state,
  ) {
    return ToolAndMaterialTransferRequest(
      id: controllerSoChungTu.text,
      soQuyetDinh: controllerSoChungTu.text,
      tenPhieu: controllerDocumentName.text,
      idDonViGiao: donViGiao?.id ?? '',
      idDonViNhan: donViNhan?.id ?? '',
      idNguoiKyNhay: nguoiKyNhay?.id ?? '',
      trangThaiKyNhay: false,
      nguoiLapPhieuKyNhay: isNguoiLapPhieuKyNhay,
      idDonViDeNghi: donViDeNghi?.id ?? '',
      idTrinhDuyetCapPhong: nguoiKyCapPhong?.id ?? '',
      tgGnTuNgay:
          AppUtility.parseDateTimeOrNow(
            controllerEffectiveDate.text,
          ).toIso8601String(),
      tgGnDenNgay:
          AppUtility.parseDateTimeOrNow(
            controllerEffectiveDateTo.text,
          ).toIso8601String(),
      idTrinhDuyetGiamDoc: nguoiKyGiamDoc?.id ?? '',
      diaDiemGiaoNhan: controllerDeliveryLocation.text,
      idPhongBanXemPhieu: nguoiKyCapPhong?.id ?? '',
      noiNhan: '',
      trangThai: state,
      idCongTy: widget.provider.userInfo?.idCongTy ?? '',
      ngayTao: DateTime.now().toIso8601String(),
      ngayCapNhat: DateTime.now().toIso8601String(),
      nguoiTao: widget.provider.userInfo?.tenDangNhap ?? '',
      nguoiCapNhat: '',
      coHieuLuc: 1,
      loai: type,
      trinhDuyetCapPhongXacNhan: false,
      trinhDuyetGiamDocXacNhan: false,
      trichYeu: controllerSubject.text,
      duongDanFile: _selectedFilePath ?? '',
      tenFile: _selectedFileName ?? '',
      ngayKy: DateTime.now().toIso8601String(),
      share: false,
    );
  }

  // Create data preview
  ToolAndMaterialTransferDto _createToolAndMaterialTransPreview(int type) {
    return ToolAndMaterialTransferDto(
      id: controllerSoChungTu.text,
      soQuyetDinh: controllerSoChungTu.text,
      tenPhieu: controllerDocumentName.text,
      idDonViGiao: donViGiao?.id ?? '',
      idDonViNhan: donViNhan?.id ?? '',
      idNguoiKyNhay: nguoiKyNhay?.id ?? '',
      trangThaiKyNhay: false,
      nguoiLapPhieuKyNhay: isNguoiLapPhieuKyNhay,
      quanTrongCanXacNhan: false,
      phoPhongXacNhan: false,
      idDonViDeNghi: donViDeNghi?.id ?? '',
      idTrinhDuyetCapPhong: nguoiKyCapPhong?.id ?? '',
      tggnTuNgay:
          AppUtility.parseDateTimeOrNow(
            controllerEffectiveDate.text,
          ).toIso8601String(),
      tggnDenNgay:
          AppUtility.parseDateTimeOrNow(
            controllerEffectiveDateTo.text,
          ).toIso8601String(),
      idTrinhDuyetGiamDoc: nguoiKyGiamDoc?.id ?? '',
      diaDiemGiaoNhan: controllerDeliveryLocation.text,
      idPhongBanXemPhieu: nguoiKyCapPhong?.id ?? '',
      idNhanSuXemPhieu: nguoiKyGiamDoc?.id ?? '',
      noiNhan: '',
      trangThai: 0,
      idCongTy: widget.provider.userInfo?.idCongTy ?? '',
      ngayTao: DateTime.now().toIso8601String(),
      ngayCapNhat: DateTime.now().toIso8601String(),
      nguoiTao: widget.provider.userInfo?.tenDangNhap ?? '',
      nguoiCapNhat: '',
      coHieuLuc: 1,
      loai: type,
      isActive: true,
      idTruongPhongDonViGiao: '',
      idPhoPhongDonViGiao: '',
      truongPhongDonViGiaoXacNhan: false,
      phoPhongDonViGiaoXacNhan: false,
      trinhDuyetCapPhongXacNhan: false,
      trinhDuyetGiamDocXacNhan: false,
      trichYeu: controllerSubject.text,
      duongDanFile: _selectedFilePath ?? '',
      tenFile: _selectedFileName ?? '',
      ngayKy: DateTime.now().toIso8601String(),
      detailToolAndMaterialTransfers: listNewDetails,
    );
  }

  List<DetailToolAndMaterialTransferDto> _createDieuDongRequestDetail() {
    log('listNewDetails: ${jsonEncode(listNewDetails)}');
    return listNewDetails
        .map(
          (e) => DetailToolAndMaterialTransferDto(
            id: e.id,
            tenPhieu: e.tenPhieu,
            soLuong: e.soLuong,
            ghiChu: e.ghiChu,
            ngayTao: e.ngayTao,
            ngayCapNhat: e.ngayCapNhat,
            nguoiTao: widget.provider.userInfo?.tenDangNhap ?? '',
            nguoiCapNhat: '',
            isActive: true,
            idCCDCVatTu: e.idCCDCVatTu,
            idDieuDongCCDCVatTu: e.idDieuDongCCDCVatTu,
            soLuongXuat: e.soLuongXuat,
            soQuyetDinh: '',
            namSanXuat: e.namSanXuat,
            donViTinh: e.donViTinh,
            tenCCDCVatTu: e.tenCCDCVatTu,
            congSuat: e.congSuat,
            nuocSanXuat: e.nuocSanXuat,
            soKyHieu: e.soKyHieu,
            kyHieu: e.kyHieu,
          ),
        )
        .toList();
  }

  List<SignatoryDto> _createListSignatory() {
    return additionalSignersDetailed
        .map(
          (e) => SignatoryDto(
            id: UUIDGenerator.generateWithFormat('NK-************'),
            idTaiLieu: item?.id ?? '',
            idPhongBan: e.department?.id ?? '',
            idNguoiKy: e.employee?.id ?? '',
            tenNguoiKy: e.employee?.hoTen ?? '',
            trangThai: 0,
          ),
        )
        .toList();
  }

  Future<void> _handleSave() async {
    if (!isEditing) return;
    if (!_validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin bắt buộc'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    UserInfoDTO userInfo = widget.provider.userInfo!;
    // final bloc = context.read<DieuDongTaiSanBloc>();
    if (item == null) {
      final request = _createToolAndMaterialTransRequest(widget.type, 0);
      final requestDetail = _createDieuDongRequestDetail();
      final requestSignatory = _createListSignatory();
      request.copyWith(ngayTao: userInfo.tenDangNhap);

      // bloc.add(CreateDieuDongEvent(context, request));
      widget.provider.saveAssetTransfer(
        context,
        request,
        requestDetail,
        requestSignatory,
        _selectedFileName ?? '',
        _selectedFilePath ?? '',
        _selectedFileBytes ?? Uint8List(0),
      );
    } else if (item != null && isEditing) {
      final request = _createToolAndMaterialTransRequest(
        widget.type,
        item!.trangThai ?? 0,
      );
      int trangThai = item!.trangThai == 2 ? 1 : item!.trangThai!;
      // Cập nhật chi tiết nếu có thay đổi
      ToolAndMaterialTransferRequest newRequest = request.copyWith(
        trinhDuyetCapPhongXacNhan: item!.trinhDuyetCapPhongXacNhan ?? false,
        trinhDuyetGiamDocXacNhan: item!.trinhDuyetGiamDocXacNhan ?? false,
        ngayKy: item!.ngayKy ?? DateTime.now().toIso8601String(),
        nguoiCapNhat: userInfo.tenDangNhap,
        trangThai: trangThai,
        share: item!.share ?? false,
        trangThaiKyNhay: item!.trangThaiKyNhay ?? false,
      );
      if (_detailsChanged()) {
        log('message test1 item!.id: ${item!.id}');
        await _syncDetails(item!.id!);
      }
      if (mounted) {
        context.read<ToolAndMaterialTransferBloc>().add(
          UpdateToolAndMaterialTransferEvent(context, newRequest, item!.id!),
        );
      }
    }
  }
}
