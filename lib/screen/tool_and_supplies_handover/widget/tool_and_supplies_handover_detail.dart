import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:quan_ly_tai_san_app/common/components/update_signer_data.dart';
import 'package:quan_ly_tai_san_app/common/input/common_checkbox_input.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_date.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/widgets/document_upload_widget.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/core/utils/uuid_generator.dart';
import 'package:quan_ly_tai_san_app/main.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/dieu_dong_tai_san_provider.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/bloc/tool_and_supplies_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/bloc/tool_and_supplies_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/component/detail_ccdc_transfer_table.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/component/preview_document_ccdc_handover.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/detail_subpplies_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/tool_and_supplies_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/provider/tool_and_supplies_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/repository/tool_and_supplies_handover_repository.dart';
import 'package:se_gay_components/common/sg_indicator.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import 'package:quan_ly_tai_san_app/common/widgets/additional_signers_selector.dart';

class ToolAndSuppliesHandoverDetail extends StatefulWidget {
  final ToolAndSuppliesHandoverProvider provider;
  final bool isFindNew;
  final bool isEditing;
  final int type;

  const ToolAndSuppliesHandoverDetail({
    super.key,
    required this.provider,
    this.isEditing = false,
    this.isFindNew = false,
    this.type = 0,
  });

  @override
  State<ToolAndSuppliesHandoverDetail> createState() =>
      _ToolAndSuppliesHandoverDetailState();
}

class _ToolAndSuppliesHandoverDetailState
    extends State<ToolAndSuppliesHandoverDetail> {
  late TextEditingController controllerHandoverNumber = TextEditingController();
  late TextEditingController controllerDocumentName = TextEditingController();
  late TextEditingController controllerOrder = TextEditingController();
  late TextEditingController controllerSenderUnit = TextEditingController();
  late TextEditingController controllerReceiverUnit = TextEditingController();
  late TextEditingController controllerTransferDate = TextEditingController();
  late TextEditingController controllerIssuingUnitRepresentative =
      TextEditingController();
  late TextEditingController controllerDelivererRepresentative =
      TextEditingController();
  late TextEditingController controllerReceiverRepresentative =
      TextEditingController();

  bool isEditing = false;
  UserInfoDTO? currentUser;

  bool isUnitConfirm = false;
  bool isDelivererConfirm = false;
  bool isReceiverConfirm = false;
  bool isRepresentativeUnitConfirm = false;
  bool isExpanded = false;
  bool isByStep = false;

  String? proposingUnit;
  String? _selectedFileName;
  String? _selectedFilePath;
  Uint8List? _selectedFileBytes;

  ToolAndSuppliesHandoverDto? item;
  late ToolAndMaterialTransferDto? selectedDieuDongCcdc;

  List<PhongBan> listPhongBan = [];
  List<NhanVien> listNhanVien = [];
  List<NhanVien> listNhanVienDonViNhan = [];
  List<NhanVien> listNhanVienDonViGiao = [];
  List<ToolAndMaterialTransferDto> listAssetTransfer = [];
  List<ChiTietDieuDongTaiSan> listDetailAssetMobilization = [];
  List<DetailSubppliesHandoverDto> listDetailSubppliesHandover = [];
  List<DetailSubppliesHandoverDto> initialDetails = [];

  List<DropdownMenuItem<NhanVien>> itemsNhanVien = [];
  List<DropdownMenuItem<PhongBan>> itemsPhongBan = [];
  List<DropdownMenuItem<ToolAndMaterialTransferDto>> itemsAssetTransfer = [];

  PhongBan? donViNhan;
  PhongBan? donViGiao;
  NhanVien? nguoiBanGiao;
  NhanVien? nguoiNhan;
  NhanVien? nguoiLanhDao;
  NhanVien? nguoiDaiDienBanHanhQD;
  NhanVien? nguoiDaiDienBenGiao;
  NhanVien? nguoiDaiDienBenNhan;
  NhanVien? nguoiDaiDienDonViDaiDien;
  ToolAndMaterialTransferDto? dieuDongCcdc;

  PdfDocument? _document;
  // Danh sách người ký bổ sung và controller tương ứng
  final List<NhanVien?> _additionalSigners = [];
  final List<TextEditingController> _additionalSignerControllers = [];
  List<AdditionalSignerData> _additionalSignersDetailed = [];
  List<AdditionalSignerData> initialSignersDetailed = [];
  DateTime? ngayBanGiao;

  @override
  void initState() {
    setState(() {
      _initData();
      _updateControllers();
    });
    super.initState();
  }

  Future<void> _loadPdf(String path) async {
    try {
      final document = await PdfDocument.openFile(path);
      setState(() {
        _document = document;
      });
    } catch (e) {
      setState(() {
        _document = null;
      });
      SGLog.error("Error loading PDF from path", e.toString());
    }
  }

  Future<void> _loadPdfFromBytes(Uint8List bytes) async {
    try {
      final document = await PdfDocument.openData(bytes);
      setState(() {
        _document = document;
      });
    } catch (e) {
      setState(() {
        _document = null;
      });
      SGLog.error("Error loading PDF from bytes", e.toString());
    }
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
  void didUpdateWidget(ToolAndSuppliesHandoverDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Kiểm tra nếu có thay đổi trong item hoặc isEditing
    if (oldWidget.provider.item != item ||
        oldWidget.isEditing != widget.isEditing) {
      // Cập nhật lại trạng thái editing
      if (mounted) {
        setState(() {
          _initData();
        });
      }
    }
  }

  bool editable() {
    return (item != null &&
        (item!.trangThai == 0 || item!.trangThai == 2) &&
        item!.nguoiTao == currentUser?.tenDangNhap);
  }

  void _initData() async {
    if (!mounted) return; // Kiểm tra nếu widget đã bị dispose
    // _clearData();
    currentUser = AccountHelper.instance.getUserInfo();
    item = widget.provider.item;
    isEditing = widget.isEditing;
    dieuDongCcdc = null;

    if (editable()) {
      isEditing = true;
    } else {
      isEditing = false;
    }

    listNhanVien = widget.provider.dataStaff ?? [];
    listPhongBan = widget.provider.dataDepartment ?? [];
    listAssetTransfer =
        widget.provider.dataAssetTransfer
            ?.where((element) => element.trangThai == 3)
            .toList() ??
        [];

    itemsNhanVien =
        listNhanVien.isNotEmpty
            ? listNhanVien
                .map(
                  (user) => DropdownMenuItem<NhanVien>(
                    value: user,
                    child: Text(user.hoTen ?? ''),
                  ),
                )
                .toList()
            : <DropdownMenuItem<NhanVien>>[];

    itemsPhongBan =
        listPhongBan.isNotEmpty
            ? listPhongBan
                .map(
                  (user) => DropdownMenuItem<PhongBan>(
                    value: user,
                    child: Text(user.tenPhongBan ?? ''),
                  ),
                )
                .toList()
            : <DropdownMenuItem<PhongBan>>[];

    itemsAssetTransfer =
        listAssetTransfer.isNotEmpty
            ? listAssetTransfer
                .map(
                  (assetTransfer) =>
                      DropdownMenuItem<ToolAndMaterialTransferDto>(
                        value: assetTransfer,
                        child: Text(assetTransfer.id ?? ''),
                      ),
                )
                .toList()
            : <DropdownMenuItem<ToolAndMaterialTransferDto>>[];

    if (item != null) {
      if (widget.isFindNew) {
        isEditing = widget.isFindNew;

        await widget.provider.getListOwnership(donViGiao!.id.toString());
      }
      dieuDongCcdc = listAssetTransfer.firstWhere(
        (element) => element.id == item?.lenhDieuDong,
        orElse: () => ToolAndMaterialTransferDto(),
      );
      donViGiao = getPhongBan(
        listPhongBan: listPhongBan,
        idPhongBan: dieuDongCcdc?.idDonViGiao ?? '',
      );
      donViNhan = getPhongBan(
        listPhongBan: listPhongBan,
        idPhongBan: dieuDongCcdc?.idDonViNhan ?? '',
      );
      isUnitConfirm = item?.daXacNhan ?? false;
      isDelivererConfirm = item?.daiDienBenGiaoXacNhan ?? false;
      isReceiverConfirm = item?.daiDienBenNhanXacNhan ?? false;
      isByStep = item?.byStep ?? false;
      _selectedFileName = item?.tenFile ?? '';
      _selectedFilePath = item?.duongDanFile ?? '';

      ngayBanGiao = AppUtility.parseDate(item?.ngayBanGiao ?? '');
      isRepresentativeUnitConfirm = item?.daiDienBenGiaoXacNhan ?? false;
      initialSignersDetailed =
          item?.listSignatory
              ?.map(
                (e) => AdditionalSignerData(
                  department: widget.provider.dataDepartment?.firstWhere(
                    (element) => element.id == e.idPhongBan,
                    orElse: () => PhongBan(),
                  ),
                  employee: widget.provider.dataStaff?.firstWhere(
                    (element) => element.id == e.idNguoiKy,
                    orElse: () => NhanVien(),
                  ),
                  signed: e.trangThai == 1,
                ),
              )
              .toList() ??
          [];
      _additionalSignersDetailed =
          item?.listSignatory
              ?.map(
                (e) => AdditionalSignerData(
                  department: widget.provider.dataDepartment?.firstWhere(
                    (element) => element.id == e.idPhongBan,
                    orElse: () => PhongBan(),
                  ),
                  employee: widget.provider.dataStaff?.firstWhere(
                    (element) => element.id == e.idNguoiKy,
                    orElse: () => NhanVien(),
                  ),
                  signed: e.trangThai == 1,
                ),
              )
              .toList() ??
          [];
      getStaffDonViGiaoAndNhan(item!.idDonViNhan!, item!.idDonViGiao!);
      if (!widget.isFindNew) {
        _loadPdfNetwork(item?.tenFile ?? '');
      }
    } else {
      isUnitConfirm = false;
      isDelivererConfirm = false;
      isReceiverConfirm = false;
      isRepresentativeUnitConfirm = false;
      _selectedFileName = null;
      _selectedFilePath = null;
      isByStep = false;
    }

    setState(() {
      _updateControllers();
    });

    // Lưu giá trị ban đầu để so sánh
    // _saveOriginalValues();
  }

  void getStaffDonViGiaoAndNhan(String idDonViNhan, String idDonViGiao) {
    listNhanVienDonViNhan =
        widget.provider.dataStaff
            ?.where((element) => element.phongBanId == idDonViNhan)
            .toList() ??
        [];

    listNhanVienDonViGiao =
        widget.provider.dataStaff
            ?.where((element) => element.phongBanId == idDonViGiao)
            .toList() ??
        [];
  }

  Map<String, bool> _validationErrors = {};

  bool _validateForm() {
    Map<String, bool> newValidationErrors = {};
    if (controllerHandoverNumber.text.isEmpty) {
      newValidationErrors['handoverNumber'] = true;
    }
    if (controllerDocumentName.text.isEmpty) {
      newValidationErrors['documentName'] = true;
    }
    if (dieuDongCcdc == null || controllerOrder.text.isEmpty) {
      newValidationErrors['order'] = true;
    }
    if (donViGiao == null || controllerSenderUnit.text.isEmpty) {
      newValidationErrors['senderUnit'] = true;
    }
    if (donViNhan == null || controllerReceiverUnit.text.isEmpty) {
      newValidationErrors['receiverUnit'] = true;
    }
    if (controllerTransferDate.text.isEmpty) {
      newValidationErrors['transferDate'] = true;
    }
    // if (controllerLeader.text.isEmpty) {
    //   newValidationErrors['leader'] = true;
    // }
    if (controllerIssuingUnitRepresentative.text.isEmpty) {
      newValidationErrors['issuingUnitRepresentative'] = true;
    }
    if (controllerDelivererRepresentative.text.isEmpty) {
      newValidationErrors['delivererRepresentative'] = true;
    }
    if (controllerReceiverRepresentative.text.isEmpty) {
      newValidationErrors['receiverRepresentative'] = true;
    }
    if (nguoiDaiDienBanHanhQD == null ||
        controllerIssuingUnitRepresentative.text.isEmpty) {
      newValidationErrors['issuingUnitRepresentative'] = true;
    }
    if (nguoiDaiDienBenGiao == null ||
        controllerDelivererRepresentative.text.isEmpty) {
      newValidationErrors['delivererRepresentative'] = true;
    }
    if (nguoiDaiDienBenNhan == null ||
        controllerReceiverRepresentative.text.isEmpty) {
      newValidationErrors['receiverRepresentative'] = true;
    }

    bool hasChanges = !mapEquals(_validationErrors, newValidationErrors);
    if (hasChanges) {
      setState(() {
        _validationErrors = newValidationErrors;
      });
    }

    return newValidationErrors.isEmpty;
  }

  void _updateControllers() {
    if (!mounted) return; // Kiểm tra nếu widget đã bị dispose
    if (item != null) {
      controllerHandoverNumber.text = item?.id ?? '';
      controllerDocumentName.text = item?.banGiaoCCDCVatTu ?? '';
      controllerOrder.text = item?.lenhDieuDong ?? '';
      controllerSenderUnit.text = item?.tenDonViGiao ?? '';
      controllerReceiverUnit.text = item?.tenDonViNhan ?? '';
      controllerTransferDate.text = AppUtility.formatDateDdMmYyyy(
        ngayBanGiao ?? DateTime.now(),
      );
      // controllerLeader.text = item?.tenLanhDao ?? '';
      controllerIssuingUnitRepresentative.text =
          item?.tenDaiDienBanHanhQD ?? '';
      controllerDelivererRepresentative.text = item?.tenDaiDienBenGiao ?? '';
      controllerReceiverRepresentative.text = item?.tenDaiDienBenNhan ?? '';
      // controllerRepresentativeUnit.text = item?.tenDonViDaiDien ?? '';
    } else {
      isEditing = true;
      controllerHandoverNumber.text = '';
      controllerDocumentName.text = '';
    }
  }

  Future<void> _saveToolAndSuppliesHandover() async {
    if (!mounted) return;
    final provider = context.read<ToolAndSuppliesHandoverProvider>();
    final dieuDongProvider = context.read<DieuDongTaiSanProvider>();
    final bloc = context.read<ToolAndSuppliesHandoverBloc>();

    provider.isLoading = true;

    DateTime ngaybangiao = AppUtility.parseDate(controllerTransferDate.text) ?? DateTime.now();

    final Map<String, dynamic> request = {
      "id": controllerHandoverNumber.text,
      "idCongTy": currentUser?.idCongTy ?? "CT001",
      "banGiaoCCDCVatTu": controllerDocumentName.text,
      "quyetDinhDieuDongSo": dieuDongCcdc?.soQuyetDinh ?? '',
      "lenhDieuDong": dieuDongCcdc?.id ?? '',
      "idDonViGiao": donViGiao?.id ?? '',
      "idDonViNhan": donViNhan?.id ?? '',
      "idLanhDao": nguoiLanhDao?.id ?? '',
      "idDaiDiendonviBanHanhQD": nguoiDaiDienBanHanhQD?.id ?? '',
      "daXacNhan": isUnitConfirm,
      "idDaiDienBenGiao": nguoiDaiDienBenGiao?.id ?? '',
      "daiDienBenGiaoXacNhan": isDelivererConfirm,
      "idDaiDienBenNhan": nguoiDaiDienBenNhan?.id ?? '',
      "daiDienBenNhanXacNhan": isReceiverConfirm,
      "trangThai": 0,
      "note": "",
      "nguoiTao": currentUser?.tenDangNhap ?? '',
      "nguoiCapNhat": currentUser?.tenDangNhap ?? '',
      "isActive": true,
      "share": false,
      "ngayBanGiao": ngaybangiao.toIso8601String(),
      "ngayTao": DateTime.now().toIso8601String(),
      "ngayCapNhat": DateTime.now().toIso8601String(),
      "byStep": isByStep,
    };

    final List<SignatoryDto> listSignatory =
        _additionalSignersDetailed
            .map(
              (e) => SignatoryDto(
                id: UUIDGenerator.generateWithFormat("SIG-******"),
                idTaiLieu: request['id'].toString(),
                idPhongBan: e.department?.id ?? '',
                idNguoiKy: e.employee?.id ?? '',
                tenNguoiKy: e.employee?.hoTen ?? '',
                trangThai: 1,
              ),
            )
            .toList();
    if (provider.isFindNewItem ? true : item == null) {
      Map<String, dynamic>? result = await dieuDongProvider.uploadWordDocument(
        context,
        _selectedFileName ?? '',
        _selectedFilePath ?? '',
        _selectedFileBytes ?? Uint8List(0),
      );

      request['duongDanFile'] = result!['filePath'] ?? '';
      request['tenFile'] = result['fileName'] ?? '';
      List<Map<String, dynamic>> requestDetail =
          listDetailSubppliesHandover
              .map(
                (e) => {
                  "id": e.id,
                  "idBanGiaoCCDCVatTu": e.idBanGiaoCCDCVatTu,
                  "idCCDCVatTu": e.idCCDCVatTu,
                  "soLuong": e.soLuong,
                  "idChiTietCCDCVatTu": e.idChiTietCCDCVatTu,
                  "idChiTietDieuDong": e.iddieudongccdcvattu,
                  "ngayTao": e.ngayTao,
                  "ngayCapNhat": e.ngayCapNhat,
                  "nguoiTao": e.nguoiTao,
                  "nguoiCapNhat": e.nguoiCapNhat,
                  "isActive": e.isActive,
                },
              )
              .toList();
      bloc.add(
        CreateToolAndSuppliesHandoverEvent(
          request,
          listSignatory,
          requestDetail,
        ),
      );
    } else {
      int trangThai = item!.trangThai == 2 ? 1 : item!.trangThai!;
      if (item!.tenFile != _selectedFileName ||
          item!.duongDanFile != _selectedFilePath) {
        Map<String, dynamic>? result = await dieuDongProvider
            .uploadWordDocument(
              context,
              _selectedFileName ?? '',
              _selectedFilePath ?? '',
              _selectedFileBytes ?? Uint8List(0),
            );
        request['duongDanFile'] = result!['filePath'] ?? '';
        request['tenFile'] = result['fileName'] ?? '';
      } else {
        request['duongDanFile'] = item!.duongDanFile ?? '';
        request['tenFile'] = item!.tenFile ?? '';
      }
      request['trangThai'] = trangThai;
      request['share'] = item!.share ?? false;
      request['nguoiCapNhat'] = currentUser?.tenDangNhap ?? '';

      if (_detailsChanged()) {
        await _syncDetails(item!.id!);
      }
      if (_signatoriesChanged()) {
        await UpdateSignerData().syncSignatories(
          item!.id!,
          _additionalSignersDetailed,
        );
      }
      if (mounted) {
        bloc.add(UpdateToolAndSuppliesHandoverEvent(context, request));
      }
    }

    // Sử dụng addPostFrameCallback để tránh gọi trong quá trình build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.provider.hasUnsavedChanges = false;
      }
    });
  }

  void _saveChanges() {
    if (!isEditing) return;
    if (listDetailSubppliesHandover.isEmpty) {
      AppUtility.showSnackBar(
        context,
        "Vui lòng chọn CCDC vật tư bàn giao",
        isError: true,
      );
      return;
    }

    if (!_validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin bắt buộc'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if ((_selectedFileName ?? '').isEmpty ||
        (_selectedFilePath ?? '').isEmpty) {
      AppUtility.showSnackBar(
        context,
        "Vui lòng chon file trước khi lưu",
        isError: true,
      );
      return;
    }

    _saveToolAndSuppliesHandover();
  }

  // void _cancelChanges() {
  //   _updateControllers();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (mounted) {
  //       widget.provider.hasUnsavedChanges = false;
  //     }
  //   });
  // }

  DieuDongTaiSanDto getAssetTransfer({
    required List<DieuDongTaiSanDto> listAssetTransfer,
    required String idAssetTransfer,
  }) {
    final found = listAssetTransfer.where((item) => item.id == idAssetTransfer);
    if (found.isEmpty) {
      return DieuDongTaiSanDto();
    }
    return found.first;
  }

  PhongBan getPhongBan({
    required List<PhongBan> listPhongBan,
    required String idPhongBan,
  }) {
    final found = listPhongBan.where((item) => item.id == idPhongBan);
    if (found.isEmpty) {
      return PhongBan();
    }
    return found.first;
  }

  @override
  void dispose() {
    for (final c in _additionalSignerControllers) {
      c.dispose();
    }
    // Giải phóng các controller
    controllerHandoverNumber.dispose();
    controllerDocumentName.dispose();
    controllerOrder.dispose();
    controllerSenderUnit.dispose();
    controllerReceiverUnit.dispose();
    controllerTransferDate.dispose();
    // controllerLeader.dispose();
    controllerIssuingUnitRepresentative.dispose();
    controllerDelivererRepresentative.dispose();
    controllerReceiverRepresentative.dispose();
    // controllerRepresentativeUnit.dispose();
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
                      _saveChanges();
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
                        title: 'Xác nhận hủy tạo phiếu Bàn giao',
                        cancelText: 'Không',
                        confirmText: 'Có',
                        message:
                            'Bạn có chắc chắn muốn hủy? Các thay đổi chưa được lưu sẽ bị mất.',
                        onCancel: () {
                          // Navigator.pop(context); // Close dialog
                        },
                        onConfirm: () {
                          widget.provider.isShowInput = false;
                          // Navigator.pop(context); // Close dialog
                        },
                      );
                    },
                  ),
                ),
                Visibility(
                  visible:
                      item != null &&
                      ![0, 2, 3].contains(item!.trangThai) &&
                      !widget.isFindNew,
                  child: MaterialTextButton(
                    text: 'Hủy phiếu bàn giao',
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
                            'Bạn có chắc chắn muốn hủy phiếu bàn giao này không?',
                        onCancel: () {},
                        onConfirm: () {
                          widget.provider.isShowInput = false;
                          final bloc =
                              BlocProvider.of<ToolAndSuppliesHandoverBloc>(
                                context,
                              );
                          bloc.add(
                            CancelToolAndSuppliesHandoverEvent(
                              context,
                              item!.id.toString(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            SgIndicator(
              steps: ['Nháp', 'Duyệt', 'Hủy', 'Hoàn thành'],
              currentStep: item?.trangThai ?? 0,
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
              _buildInfoToolAndSuppliesHandoverMobile(isWideScreen),
              const SizedBox(height: 20),
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
                      // Ưu tiên load từ bytes nếu có (web), fallback sang path (mobile/desktop)
                      if (fileBytes != null) {
                        _loadPdfFromBytes(fileBytes);
                      } else if (filePath != null &&
                          !filePath.startsWith('data:')) {
                        _loadPdf(filePath);
                      }
                    }
                    if (_validationErrors.containsKey('document')) {
                      _validationErrors.remove('document');
                    }
                  });
                },
                // onUpload: _uploadWordDocument,
                isUploading: true,
                label: 'Tài liệu Quyết định',
                errorMessage: 'Tài liệu quyết định là bắt buộc',
                hintText: 'Định dạng hỗ trợ: .pdf',
                allowedExtensions: ['pdf'],
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: dieuDongCcdc != null,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: DetailCcdcTransferTable(
                    context,
                    isEditing: isEditing,
                    initialDetails:
                        dieuDongCcdc?.detailToolAndMaterialTransfers ?? [],
                    initialDetailsSuppliesHandover:
                        item?.listDetailSubppliesHandover ?? [],
                    listOwnershipUnit: widget.provider.listOwnershipUnit,
                    allAssets: widget.provider.dataCcdc,
                    onDataChanged: (data) {
                      setState(() {
                        listDetailSubppliesHandover =
                            data
                                .map(
                                  (e) => DetailSubppliesHandoverDto(
                                    id: UUIDGenerator.generateWithFormat(
                                      "CTBGCCDC-******",
                                    ),
                                    idBanGiaoCCDCVatTu:
                                        controllerHandoverNumber.text,
                                    idCCDCVatTu: e.idCCDCVatTu,
                                    soLuong: e.soLuongXuat,
                                    idChiTietCCDCVatTu: e.idDetaiAsset,
                                    iddieudongccdcvattu: e.id,
                                    ngayTao: DateTime.now().toIso8601String(),
                                    ngayCapNhat: '',
                                    nguoiTao: currentUser!.tenDangNhap,
                                    nguoiCapNhat: '',
                                    isActive: true,
                                  ),
                                )
                                .toList();
                      });
                    },
                  ),
                ),
              ),
              previewDocumentCcdcHandover(
                context: context,
                item: dieuDongCcdc,
                dieuDongCcdc: getToolAndSuppliesHandoverPreview(),
                provider: widget.provider,
                isShowKy: false,
                document: _document,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoToolAndSuppliesHandoverMobile(bool isWideScreen) {
    if (isWideScreen) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildInfoToolAndSuppliesHandover()),
          const SizedBox(width: 20),
          Expanded(child: _buildToolAndSuppliesHandoverDetail()),
        ],
      );
    } else {
      return Column(
        children: [
          _buildInfoToolAndSuppliesHandover(),
          _buildToolAndSuppliesHandoverDetail(),
        ],
      );
    }
  }

  Widget _buildInfoToolAndSuppliesHandover() {
    return Column(
      spacing: 10,
      children: [
        CommonFormInput(
          label: 'Số phiếu bàn giao',
          controller: controllerHandoverNumber,
          isEditing:
              widget.provider.isFindNewItem
                  ? true
                  : (isEditing && item == null),
          fieldName: 'handoverNumber',
          textContent: item?.id ?? '',
          validationErrors: _validationErrors,
          isRequired: true,
        ),
        CommonFormInput(
          label: 'Bàn giao ccdc-vật tư',
          controller: controllerDocumentName,
          isEditing: isEditing,
          textContent: item?.banGiaoCCDCVatTu ?? '',
          fieldName: 'documentName',
          validationErrors: _validationErrors,
          isRequired: true,
        ),

        CmFormDropdownObject<ToolAndMaterialTransferDto>(
          label: 'Lệnh điều động',
          controller: controllerOrder,
          isEditing: isEditing,
          value: dieuDongCcdc,
          fieldName: 'order',
          items: itemsAssetTransfer,
          onChanged: (value) async {
            setState(() {
              dieuDongCcdc = value;
              //change Đơn vị giao
              donViGiao = getPhongBan(
                listPhongBan: listPhongBan,
                idPhongBan: dieuDongCcdc?.idDonViGiao ?? '',
              );
              //change Đơn vị nhận
              donViNhan = getPhongBan(
                listPhongBan: listPhongBan,
                idPhongBan: dieuDongCcdc?.idDonViNhan ?? '',
              );

              // controllerReceiverUnit.text = donViNhan?.tenPhongBan ?? '';
              getStaffDonViGiaoAndNhan(
                dieuDongCcdc?.idDonViNhan ?? '',
                dieuDongCcdc?.idDonViGiao ?? '',
              );
            });
            await widget.provider.getListOwnership(donViGiao!.id.toString());
          },
          validationErrors: _validationErrors,
          isRequired: true,
        ),
        CmFormDropdownObject<PhongBan>(
          label: 'Đơn vị giao',
          controller: controllerSenderUnit,
          isEditing: false,
          value: donViGiao,
          defaultValue:
              item?.idDonViGiao != null
                  ? getPhongBan(
                    listPhongBan: listPhongBan,
                    idPhongBan: item!.idDonViGiao!,
                  )
                  : null,
          fieldName: 'senderUnit',
          items: itemsPhongBan,
          onChanged: (value) {
            donViGiao = value;
          },
          validationErrors: _validationErrors,
          isRequired: true,
        ),
        CmFormDropdownObject<PhongBan>(
          label: 'Đơn vị nhận',
          controller: controllerReceiverUnit,
          isEditing: false,
          value: donViNhan,
          defaultValue:
              item?.idDonViNhan != null
                  ? getPhongBan(
                    listPhongBan: listPhongBan,
                    idPhongBan: item!.idDonViNhan!,
                  )
                  : null,
          fieldName: 'receiverUnit',
          items: itemsPhongBan,
          onChanged: (value) {
            donViNhan = value;
          },
          validationErrors: _validationErrors,
          isRequired: true,
        ),
        CmFormDate(
          label: 'Ngày bàn giao',
          controller: controllerTransferDate,
          isEditing: isEditing,
          value: ngayBanGiao,
          onChanged: (dt) {},
          validationErrors: _validationErrors,
          fieldName: 'transferDate',
          isRequired: true,
        ),
      ],
    );
  }

  Widget _buildToolAndSuppliesHandoverDetail() {
    return Column(
      spacing: 10,
      children: [
        CmFormDropdownObject<NhanVien>(
          label: 'Đại diện đơn vị đề nghị',
          controller: controllerIssuingUnitRepresentative,
          isEditing: isEditing,
          defaultValue:
              item?.idDaiDiendonviBanHanhQD != null
                  ? widget.provider.getNhanVien(
                    idNhanVien: item!.idDaiDiendonviBanHanhQD!,
                  )
                  : null,
          fieldName: 'issuingUnitRepresentative',
          items: itemsNhanVien,
          onChanged: (value) {
            nguoiDaiDienBanHanhQD = value;
          },
          validationErrors: _validationErrors,
          isRequired: true,
        ),
        SizedBox(height: 1),
        CommonCheckboxInput(
          label: 'Đã xác nhận',
          value: isUnitConfirm,
          isEditing: false,
          isDisabled: true,
          onChanged: (newValue) {
            setState(() {
              isUnitConfirm = newValue;
            });
          },
        ),
        SizedBox(height: 1),
        CmFormDropdownObject<NhanVien>(
          label: 'Đại diện đơn vị giao',
          controller: controllerDelivererRepresentative,
          isEditing: isEditing,
          defaultValue:
              item?.idDaiDienBenGiao != null
                  ? widget.provider.getNhanVien(
                    idNhanVien: item!.idDaiDienBenGiao!,
                  )
                  : null,
          fieldName: 'delivererRepresentative',
          items: [
            ...listNhanVienDonViGiao.map(
              (e) => DropdownMenuItem<NhanVien>(
                value: e,
                child: Text(e.hoTen ?? ''),
              ),
            ),
          ],
          onChanged: (value) {
            nguoiDaiDienBenGiao = value;
          },
          validationErrors: _validationErrors,
          isRequired: true,
        ),
        CommonCheckboxInput(
          label: 'Đại diện bên giao đã xác nhận',
          value: isDelivererConfirm,
          isEditing: isEditing,
          isDisabled: true,
          onChanged: (newValue) {
            setState(() {
              isDelivererConfirm = newValue;
            });
          },
        ),
        CmFormDropdownObject<NhanVien>(
          label: 'Đại diện đơn vị bên nhận',
          controller: controllerReceiverRepresentative,
          isEditing: isEditing,
          defaultValue:
              item?.idDaiDienBenNhan != null
                  ? widget.provider.getNhanVien(
                    idNhanVien: item!.idDaiDienBenNhan!,
                  )
                  : null,
          fieldName: 'receiverRepresentative',
          items: [
            ...listNhanVienDonViNhan.map(
              (e) => DropdownMenuItem<NhanVien>(
                value: e,
                child: Text(e.hoTen ?? ''),
              ),
            ),
          ],
          onChanged: (value) {
            nguoiDaiDienBenNhan = value;
          },
          validationErrors: _validationErrors,
          isRequired: true,
        ),
        CommonCheckboxInput(
          label: 'Đại diện bên nhận đã xác nhận',
          value: isReceiverConfirm,
          isEditing: isEditing,
          isDisabled: true,
          onChanged: (newValue) {
            setState(() {
              isReceiverConfirm = newValue;
            });
          },
        ),
        AdditionalSignersSelector(
          addButtonText: "Thêm người đại diện",
          labelDepartment: "Người đại diện",
          isEditing: isEditing,
          itemsNhanVien: itemsNhanVien,
          phongBan: widget.provider.dataDepartment,
          listNhanVien: listNhanVien,
          initialSigners: _additionalSigners,
          onChanged: (list) {
            setState(() {
              _additionalSigners
                ..clear()
                ..addAll(list);
            });
          },
          initialSignerData: _additionalSignersDetailed,
          onChangedDetailed: (list) {
            setState(() {
              _additionalSignersDetailed = list;
            });
          },
        ),
        const SizedBox(height: 10),
        // CommonCheckboxInput(
        //   label: 'Ký theo lượt',
        //   value: isByStep,
        //   isEditing: isEditing,
        //   isDisabled: !isEditing,
        //   onChanged: (newValue) {
        //     setState(() {
        //       isByStep = newValue;
        //     });
        //   },
        // ),
      ],
    );
  }

  ToolAndSuppliesHandoverDto? getToolAndSuppliesHandoverPreview() {
    return ToolAndSuppliesHandoverDto(
      id: controllerHandoverNumber.text,
      banGiaoCCDCVatTu: controllerDocumentName.text,
      quyetDinhDieuDongSo: dieuDongCcdc?.soQuyetDinh ?? '',
      lenhDieuDong: dieuDongCcdc?.id ?? '',
      idDonViGiao: donViGiao?.id ?? '',
      tenDonViGiao: donViGiao?.tenPhongBan ?? '',
      idDonViNhan: donViNhan?.id ?? '',
      tenDonViNhan: donViNhan?.tenPhongBan ?? '',
      ngayBanGiao: controllerTransferDate.text,
      idLanhDao: nguoiLanhDao?.id ?? '',
      tenLanhDao: nguoiLanhDao?.hoTen ?? '',
      idDaiDiendonviBanHanhQD: nguoiDaiDienBanHanhQD?.id ?? '',
      tenDaiDienBanHanhQD: nguoiDaiDienBanHanhQD?.hoTen ?? '',
      daXacNhan: isUnitConfirm,
      idDaiDienBenGiao: nguoiDaiDienBenGiao?.id ?? '',
      tenDaiDienBenGiao: nguoiDaiDienBenGiao?.hoTen ?? '',
      daiDienBenGiaoXacNhan: isDelivererConfirm,
      idDaiDienBenNhan: nguoiDaiDienBenNhan?.id ?? '',
      tenDaiDienBenNhan: nguoiDaiDienBenNhan?.hoTen ?? '',
      daiDienBenNhanXacNhan: isReceiverConfirm,
      trangThai: 1,
      note: '',
      ngayTao: DateTime.now().toString(),
      ngayCapNhat: DateTime.now().toString(),
      nguoiTao: currentUser?.id ?? '',
      nguoiCapNhat: currentUser?.id ?? '',
      active: true,
      listSignatory:
          _additionalSignersDetailed
              .map(
                (e) => SignatoryDto(
                  id: UUIDGenerator.generateWithFormat("SIG-******"),
                  idTaiLieu: item?.id ?? '',
                  idPhongBan: e.department?.id ?? '',
                  idNguoiKy: e.employee?.id ?? '',
                  tenNguoiKy: e.employee?.hoTen ?? '',
                  trangThai: 1,
                ),
              )
              .toList(),
    );
  }

  List<Map<String, dynamic>> _normalizeDetails(
    List<DetailSubppliesHandoverDto> list,
  ) {
    final data =
        list
            .map(
              (d) => {
                'idCCDCVatTu': d.idCCDCVatTu,
                'soLuong': d.soLuong,
                'idChiTietCCDCVatTu': d.idChiTietCCDCVatTu,
                'idBanGiaoCCDCVatTu': d.idBanGiaoCCDCVatTu,
                "ngayTao": d.ngayTao,
                "ngayCapNhat": d.ngayCapNhat,
                "nguoiTao": d.nguoiTao,
                "nguoiCapNhat": d.nguoiCapNhat,
              },
            )
            .toList();
    data.sort(
      (a, b) =>
          (a['idCCDCVatTu'] as String).compareTo(b['idCCDCVatTu'] as String),
    );
    return data;
  }

  bool _signatoriesChanged() {
    if (item == null) return _additionalSignersDetailed.isNotEmpty;
    final beforeJson = jsonEncode(
      UpdateSignerData().normalizeSignatories(initialSignersDetailed),
    );
    final afterJson = jsonEncode(
      UpdateSignerData().normalizeSignatories(_additionalSignersDetailed),
    );
    return beforeJson != afterJson;
  }

  bool _detailsChanged() {
    if (item == null) return listDetailSubppliesHandover.isNotEmpty;
    final beforeJson = jsonEncode(
      _normalizeDetails(listDetailSubppliesHandover),
    );
    final afterJson = jsonEncode(_normalizeDetails(initialDetails));
    return beforeJson != afterJson;
  }

  Future<void> _syncDetails(String idDieuDongTaiSan) async {
    try {
      final repo = ToolAndSuppliesHandoverRepository();

      String keyOf(String idCCDCVatTu, String idChiTietCCDCVatTu) =>
          '$idCCDCVatTu|$idChiTietCCDCVatTu';

      final initialByKey = {
        for (final d in initialDetails)
          keyOf(d.idCCDCVatTu, d.idChiTietCCDCVatTu): d,
      };
      final newByKey = {
        for (final d in listDetailSubppliesHandover)
          keyOf(d.idCCDCVatTu, d.idChiTietCCDCVatTu): d,
      };

      bool changed(
        DetailSubppliesHandoverDto a,
        DetailSubppliesHandoverDto b,
      ) =>
          a.soLuong != b.soLuong ||
          a.idCCDCVatTu != b.idCCDCVatTu ||
          a.idChiTietCCDCVatTu != b.idChiTietCCDCVatTu;
      // Delete
      for (final k in initialByKey.keys.where(
        (k) => !newByKey.containsKey(k),
      )) {
        final id = initialByKey[k]!.id;
        if (id.isEmpty) continue;
        try {
          await repo.deleteDetailHandoverCCDC(id);
        } catch (e) {
          if (!e.toString().contains('404')) rethrow;
        }
      }

      // Update
      for (final k in newByKey.keys.where(initialByKey.containsKey)) {
        final oldVal = initialByKey[k]!;
        final newVal = newByKey[k]!;
        if (!changed(oldVal, newVal)) {
          continue;
        }

        if (oldVal.id.isEmpty) {
          continue;
        }
        Map<String, dynamic> request = {
          "id": oldVal.id,
          "idBanGiaoCCDCVatTu": newVal.idBanGiaoCCDCVatTu,
          "idCCDCVatTu": newVal.idCCDCVatTu,
          "soLuong": newVal.soLuong,
          "idChiTietCCDCVatTu": newVal.idChiTietCCDCVatTu,
          "ngayTao": newVal.ngayTao,
          "ngayCapNhat": DateTime.now().toIso8601String(),
          "nguoiTao": newVal.nguoiTao,
          "nguoiCapNhat": widget.provider.userInfo?.tenDangNhap ?? '',
          "isActive": true,
        };
        log('request: $request');
        await repo.updateDetailHandoverCCDC(request);
      }
      // Create
      final creates =
          newByKey.keys
              .where((k) => !initialByKey.containsKey(k))
              .map((k) => newByKey[k]!)
              .map(
                (d) => {
                  "id": UUIDGenerator.generateWithFormat("CTBG-************"),
                  "idBanGiaoCCDCVatTu": d.idBanGiaoCCDCVatTu,
                  "idCCDCVatTu": d.idCCDCVatTu,
                  "soLuong": d.soLuong,
                  "idChiTietCCDCVatTu": d.idChiTietCCDCVatTu,
                  "iddieudongccdcvattu": d.iddieudongccdcvattu,
                  "ngayTao": d.ngayTao,
                  "ngayCapNhat": d.ngayCapNhat,
                  "nguoiTao": d.nguoiTao,
                  "nguoiCapNhat": d.nguoiCapNhat,
                  "isActive": d.isActive,
                },
              )
              .toList();
      log('creates: $creates');
      if (creates.isNotEmpty) await repo.createDetailHandoverCCDC(creates);
    } catch (e) {
      log('Sync details error: $e');
    }
  }
}
