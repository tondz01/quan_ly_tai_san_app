// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:quan_ly_tai_san_app/common/components/convert_pdf.dart';
import 'package:quan_ly_tai_san_app/common/components/update_signer_data.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_date.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/widgets/document_upload_widget.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/constants/function_type.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/core/utils/uuid_generator.dart';
import 'package:quan_ly_tai_san_app/main.dart';
import 'package:quan_ly_tai_san_app/message/message_service_realtime.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/component/preview_document_asset_handover.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/component/table_asset_movement_detail.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/detai_asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/asset_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/repository/asset_handover_repository.dart';
// import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/dieu_dong_tai_san_provider.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:se_gay_components/common/sg_indicator.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import 'package:quan_ly_tai_san_app/common/widgets/additional_signers_selector.dart';

class AssetHandoverDetail extends StatefulWidget {
  final AssetHandoverProvider provider;
  final bool isFindNew;
  final bool isEditing;
  final int type;

  const AssetHandoverDetail({
    super.key,
    required this.provider,
    this.isEditing = false,
    this.isFindNew = false,
    this.type = 0,
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
  late TextEditingController controllerDecisionDate = TextEditingController();
  late TextEditingController controllerDecisionNumber = TextEditingController();
  late TextEditingController controllerDecisionLocation =
      TextEditingController();
  late TextEditingController controllerDocumentCreationDate =
      TextEditingController();
  // late TextEditingController controllerLeader = TextEditingController();
  // late TextEditingController controllerIssuingUnitRepresentative =
  //     TextEditingController();
  late TextEditingController controllerDelivererRepresentative =
      TextEditingController();
  late TextEditingController controllerReceiverRepresentative =
      TextEditingController();
  late TextEditingController controllerGiamDocKy = TextEditingController();
  // late TextEditingController controllerRepresentativeUnit =
  //     TextEditingController();

  bool isEditing = false;
  bool isNew = false;
  UserInfoDTO? currentUser;

  bool isUnitConfirm = false;
  bool isDelivererConfirm = false;
  bool isReceiverConfirm = false;
  bool isRepresentativeUnitConfirm = false;
  bool isGiamDocConfirm = false;
  bool isExpanded = false;
  bool isByStep = false;
  bool isDetail = false;

  String? proposingUnit;
  String? _selectedFileName;
  String? _selectedFilePath;
  Uint8List? _selectedFileBytes;

  AssetHandoverDto? item;

  List<PhongBan> listPhongBan = [];
  List<NhanVien> listNhanVien = [];
  List<NhanVien> listNhanVienDonViNhan = [];
  List<NhanVien> listNhanVienDonViGiao = [];
  List<DieuDongTaiSanDto> listAssetTransfer = [];
  List<DetailAssetHandoverDto> listDetailAssetHandover = [];
  List<DetailAssetHandoverDto> _originalListDetailAssetHandover = [];

  List<DropdownMenuItem<NhanVien>> itemsNhanVien = [];
  List<DropdownMenuItem<PhongBan>> itemsPhongBan = [];
  List<DropdownMenuItem<DieuDongTaiSanDto>> itemsAssetTransfer = [];

  PhongBan? donViNhan;
  PhongBan? donViGiao;
  NhanVien? nguoiBanGiao;
  NhanVien? nguoiNhan;
  NhanVien? nguoiLanhDao;
  NhanVien? nguoiDaiDienBanHanhQD;
  NhanVien? nguoiDaiDienBenGiao;
  NhanVien? nguoiDaiDienBenNhan;
  NhanVien? nguoiDaiDienDonViDaiDien;
  NhanVien? nguoiKyGiamDoc;
  DieuDongTaiSanDto? dieuDongTaiSan;

  PdfDocument? _document;
  // Danh sách người ký bổ sung và controller tương ứng
  final List<NhanVien?> _additionalSigners = [];
  final List<TextEditingController> _additionalSignerControllers = [];
  List<AdditionalSignerData> _additionalSignersDetailed = [];
  List<AdditionalSignerData> _initialSignersDetailed = [];

  DateTime? ngayBanGiao;
  DateTime? ngayTaoChungTu;
  DateTime? ngayQuyetDinh;
  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _loadPdf(String path) async {
    final document = await PdfDocument.openFile(path);
    setState(() {
      _document = document;
    });
  }

  Future<void> _loadPdfFromBytes(Uint8List bytes) async {
    final document = await PdfDocument.openData(bytes);
    setState(() {
      _document = document;
    });
  }

  Future<void> _loadPdfNetwork(String nameFile) async {
    SGLog.info("LoadPdfNetwork", "Loading PDF from network: $nameFile");
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
  void didUpdateWidget(AssetHandoverDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Kiểm tra nếu có thay đổi trong item hoặc isEditing
    if (oldWidget.provider.item != item ||
        oldWidget.isEditing != widget.isEditing) {
      // Cập nhật lại dữ liệu khi provider/item thay đổi
      if (mounted) {
        _initData();
      }
    }
  }

  bool editable() {
    return (item != null &&
        (item!.trangThai == 0 || item!.trangThai == 2) &&
        item!.nguoiTao == currentUser?.tenDangNhap);
  }

  void _initData() {
    if (!mounted) return; // Kiểm tra nếu widget đã bị dispose

    setState(() {
      isNew = widget.isFindNew;
      currentUser = AccountHelper.instance.getUserInfo();
      item = widget.provider.item;
      isEditing = widget.isEditing;

      // Nếu phiếu ở trạng thái cho phép sửa và là người tạo thì cho phép edit
      if (editable()) {
        isEditing = true;
      } else {
        isEditing = false;
      }

      listNhanVien = widget.provider.dataStaff ?? [];
      listPhongBan = widget.provider.dataDepartment ?? [];
      listAssetTransfer = widget.provider.getFilteredAssetTransfer(
        isEditing: item != null || widget.isFindNew,
      );


      if (item != null) {
        isDetail = true;
        if (widget.isFindNew) {
          isEditing = widget.isFindNew;
          isDetail = false;
          dieuDongTaiSan = listAssetTransfer.firstWhere(
            (element) => element.id == item?.lenhDieuDong,
            orElse: () => DieuDongTaiSanDto(),
          );
          controllerOrder.text = dieuDongTaiSan?.id ?? '';
          listDetailAssetHandover =
              (widget.provider.dataDetailAssetMobilization != null
                  ? widget.provider.dataDetailAssetMobilization!
                      .map(
                        (e) => DetailAssetHandoverDto(
                          id: UUIDGenerator.generateWithFormat(
                            'CTBGCCDC-******',
                          ),
                          idBanGiaoTaiSan: item?.id ?? '',
                          banGiaoTaiSan: item?.banGiaoTaiSan ?? '',
                          quyetDinhDieuDongSo:
                              dieuDongTaiSan?.soQuyetDinh ?? '',
                          idTaiSan: e.idTaiSan,
                          tenTaiSan: e.tenTaiSan,
                          donViTinh: e.donViTinh,
                          hienTrang: e.hienTrang,
                          soLuong: e.soLuong,
                          ngayTao: AppUtility.formatDateString(DateTime.now()),
                          ngayCapNhat: AppUtility.formatDateString(
                            DateTime.now(),
                          ),
                          nguoiTao: currentUser?.tenDangNhap ?? '',
                          nguoiCapNhat: '',
                          isActive: true,
                        ),
                      )
                      .toList()
                  : <DetailAssetHandoverDto>[]);
        } else {
          listDetailAssetHandover = item?.chiTietBanGiaoTaiSan ?? [];
        }

        // Lưu giá trị ban đầu để so sánh thay đổi
        _originalListDetailAssetHandover =
            listDetailAssetHandover
                .map(
                  (e) => DetailAssetHandoverDto(
                    id: e.id,
                    idBanGiaoTaiSan: e.idBanGiaoTaiSan,
                    banGiaoTaiSan: e.banGiaoTaiSan,
                    quyetDinhDieuDongSo: e.quyetDinhDieuDongSo,
                    idTaiSan: e.idTaiSan,
                    tenTaiSan: e.tenTaiSan,
                    donViTinh: e.donViTinh,
                    kyHieu: e.kyHieu,
                    soKyHieu: e.soKyHieu,
                    hienTrang: e.hienTrang,
                    moTa: e.moTa,
                    soLuong: e.soLuong,
                    ngayTao: e.ngayTao,
                    ngayCapNhat: e.ngayCapNhat,
                    nguoiTao: e.nguoiTao,
                    nguoiCapNhat: e.nguoiCapNhat,
                    isActive: e.isActive,
                  ),
                )
                .toList();

        isByStep = item?.byStep ?? false;
        nguoiKyGiamDoc = AccountHelper.instance.getNhanVienById(
          item?.idGiamDoc ?? '',
        );
        isUnitConfirm = item?.daXacNhan ?? false;
        isDelivererConfirm = item?.daiDienBenGiaoXacNhan ?? false;
        isReceiverConfirm = item?.daiDienBenNhanXacNhan ?? false;
        isGiamDocConfirm = item?.giamDocKy ?? false;
        _selectedFileName = item?.tenFile ?? '';
        _selectedFilePath = item?.duongDanFile ?? '';

        ngayBanGiao = AppUtility.parseDate(item?.ngayBanGiao ?? '');
        ngayTaoChungTu = AppUtility.parseDate(item?.ngayTaoChungTu ?? '');
        ngayQuyetDinh = AppUtility.parseDate(item?.ngayQuyetDinh ?? '');
        isRepresentativeUnitConfirm =
            item?.donViDaiDienXacNhan == "0" ? false : true;
        getStaffDonViGiaoAndNhan(item!.idDonViNhan!, item!.idDonViGiao!);
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

        // Snapshot ban đầu để so sánh thay đổi người ký
        _initialSignersDetailed = List<AdditionalSignerData>.from(
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
                    ),
                  )
                  .toList() ??
              [],
        );
      } else {
        isDetail = false;
        isByStep = false;
        isUnitConfirm = false;
        isDelivererConfirm = false;
        isReceiverConfirm = false;
        isRepresentativeUnitConfirm = false;
        _selectedFileName = null;
        _selectedFilePath = null;
      }

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
                    (assetTransfer) => DropdownMenuItem<DieuDongTaiSanDto>(
                      value: assetTransfer,
                      child: Text(assetTransfer.id ?? ''),
                    ),
                  )
                  .toList()
              : <DropdownMenuItem<DieuDongTaiSanDto>>[];
      dieuDongTaiSan = null;
      _initialSignersDetailed.clear();

      _updateControllers();
    });

    // Tải file PDF ở ngoài setState để tránh block build
    if (item != null && !widget.isFindNew) {
      _loadPdfNetwork(item?.tenFile ?? '');
    }

    // Lưu giá trị ban đầu để so sánh
    // _saveOriginalValues();
  }

  void getStaffDonViGiaoAndNhan(String idDonViNhan, String idDonViGiao) {
    // listNhanVienDonViNhan =
    //     widget.provider.dataStaff
    //         ?.where((element) => element.phongBanId == idDonViNhan)
    //         .toList() ??
    //     [];
    final departments = widget.provider.dataDepartment ?? [];
    final donViGiao = departments.where((e) => e.id == idDonViGiao).firstOrNull;
    final donViNhan = departments.where((e) => e.id == idDonViNhan).firstOrNull;

    if (donViNhan?.isKho == true) {
      final idPhongBanKho =
          departments
              .where((element) => element.isKho == true)
              .map((element) => element.id)
              .toSet();
      listNhanVienDonViNhan =
          listNhanVien
              .where((element) => idPhongBanKho.contains(element.phongBanId))
              .toList();
    } else {
      listNhanVienDonViNhan =
          listNhanVien
              .where((element) => element.phongBanId == idDonViGiao)
              .toList();
    }
    if (donViGiao?.isKho == true) {
      final idPhongBanKho =
          departments
              .where((element) => element.isKho == true)
              .map((element) => element.id)
              .toSet();
      listNhanVienDonViGiao =
          listNhanVien
              .where((element) => idPhongBanKho.contains(element.phongBanId))
              .toList();
    } else {
      listNhanVienDonViGiao =
          listNhanVien
              .where((element) => element.phongBanId == idDonViGiao)
              .toList();
    }
  }

  Map<String, bool> _validationErrors = {};

  bool _validateForm() {
    Map<String, bool> newValidationErrors = {};
    if (nguoiKyGiamDoc == null || controllerGiamDocKy.text.isEmpty) {
      newValidationErrors['giamDocXacNhan'] = true;
    }
    if (controllerHandoverNumber.text.isEmpty) {
      newValidationErrors['handoverNumber'] = true;
    }
    if (controllerDocumentName.text.isEmpty) {
      newValidationErrors['documentName'] = true;
    }
    if (controllerOrder.text.isEmpty) {
      newValidationErrors['order'] = true;
    }
    if (controllerSenderUnit.text.isEmpty) {
      newValidationErrors['senderUnit'] = true;
    }
    if (controllerReceiverUnit.text.isEmpty) {
      newValidationErrors['receiverUnit'] = true;
    }
    if (controllerTransferDate.text.isEmpty) {
      newValidationErrors['transferDate'] = true;
    }
    if (controllerDocumentCreationDate.text.isEmpty) {
      newValidationErrors['documentCreationDate'] = true;
    }
    if (controllerDecisionNumber.text.isEmpty) {
      newValidationErrors['decisionNumber'] = true;
    }
    if (controllerDecisionLocation.text.isEmpty) {
      newValidationErrors['decisionLocation'] = true;
    }
    if (controllerDecisionDate.text.isEmpty) {
      newValidationErrors['decisionDate'] = true;
    }
    // if (controllerLeader.text.isEmpty) {
    //   newValidationErrors['leader'] = true;
    // }
    // if (controllerIssuingUnitRepresentative.text.isEmpty) {
    //   newValidationErrors['issuingUnitRepresentative'] = true;
    // }
    if (controllerDelivererRepresentative.text.isEmpty) {
      newValidationErrors['delivererRepresentative'] = true;
    }
    if (controllerReceiverRepresentative.text.isEmpty) {
      newValidationErrors['receiverRepresentative'] = true;
    }
    if (controllerReceiverRepresentative.text.isEmpty) {
      newValidationErrors['receiverRepresentative'] = true;
    }

    // if (controllerRepresentativeUnit.text.isEmpty) {
    //   newValidationErrors['representativeUnit'] = true;
    // }
    if ((_selectedFileName ?? '').isEmpty ||
        (_selectedFilePath ?? '').isEmpty) {
      newValidationErrors['document'] = true;
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
      controllerDocumentName.text = item?.banGiaoTaiSan ?? '';
      dieuDongTaiSan = listAssetTransfer.firstWhere(
        (element) => element.id == item?.lenhDieuDong,
        orElse: () => DieuDongTaiSanDto(),
      );
      controllerOrder.text = dieuDongTaiSan?.id ?? '';
      // widget.provider.getListDetailAssetMobilization(dieuDongTaiSan?.id ?? '');
      controllerSenderUnit.text = item?.tenDonViGiao ?? '';
      controllerReceiverUnit.text = item?.tenDonViNhan ?? '';
      // controllerTransferDate.text = item?.ngayBanGiao ?? '';
      // controllerDocumentCreationDate.text = item?.ngayTaoChungTu ?? '';
      // controllerLeader.text = item?.tenLanhDao ?? '';

      controllerDelivererRepresentative.text = item?.tenDaiDienBenGiao ?? '';
      controllerReceiverRepresentative.text = item?.tenDaiDienBenNhan ?? '';
      // controllerRepresentativeUnit.text = item?.tenDonViDaiDien ?? '';
    } else {
      isEditing = true;
      controllerHandoverNumber.text = widget.provider.genID();
      controllerDocumentName.text = '';
    }
  }

  bool _signatoriesChanged() {
    if (item == null) return _additionalSignersDetailed.isNotEmpty;
    final beforeJson = jsonEncode(
      UpdateSignerData().normalizeSignatories(_initialSignersDetailed),
    );
    final afterJson = jsonEncode(
      UpdateSignerData().normalizeSignatories(_additionalSignersDetailed),
    );
    return beforeJson != afterJson;
  }

  Future<void> _saveAssetHandover() async {
    if (!mounted) return;
    final assetHandoverProvider = context.read<AssetHandoverProvider>();
    final dieuDongProvider = context.read<DieuDongTaiSanProvider>();
    final assetHandoverBloc = context.read<AssetHandoverBloc>();

    assetHandoverProvider.isLoading = true;

    final Map<String, dynamic> request = {
      "id": controllerHandoverNumber.text,
      "idCongTy": currentUser?.idCongTy ?? "CT001",
      "banGiaoTaiSan": controllerDocumentName.text,
      "quyetDinhDieuDongSo": dieuDongTaiSan?.soQuyetDinh ?? '',
      "lenhDieuDong": dieuDongTaiSan?.id ?? '',
      "idDonViGiao": donViGiao?.id ?? '',
      "idDonViNhan": donViNhan?.id ?? '',
      "idLanhDao": nguoiLanhDao?.id ?? '',
      "idDaiDiendonviBanHanhQD": nguoiDaiDienBanHanhQD?.id ?? '',
      "daXacNhan": isUnitConfirm,
      "idDaiDienBenGiao": nguoiDaiDienBenGiao?.id ?? '',
      "daiDienBenGiaoXacNhan": isDelivererConfirm,
      "idDaiDienBenNhan": nguoiDaiDienBenNhan?.id ?? '',
      "daiDienBenNhanXacNhan": isReceiverConfirm,
      "ngayTaoChungTu": AppUtility.formatFromISOString(
        controllerDocumentCreationDate.text,
      ),
      "ngayBanGiao": AppUtility.formatFromISOString(
        controllerTransferDate.text,
      ),
      "ngayTao": AppUtility.formatDateString(DateTime.now()),
      "ngayCapNhat": AppUtility.formatDateString(DateTime.now()),
      "idGiamDoc": nguoiKyGiamDoc?.id ?? '',
      "giamDocXacNhan": isGiamDocConfirm,
      "tenGiamDoc": nguoiKyGiamDoc?.hoTen ?? '',
      "trangThai": 0,
      "note": "",
      "nguoiTao": currentUser?.tenDangNhap ?? '',
      "isActive": true,
      "share": false,
      "byStep": isByStep,
      "soQuyetDinh": controllerDecisionNumber.text,
      "ngayQuyetDinh": AppUtility.formatDateString(
        ngayQuyetDinh ?? DateTime.now(),
      ),
      "diaDiemQuyetDinh": controllerDecisionLocation.text,
    };

    if (listDetailAssetHandover.isEmpty) {
      onInitListDetailAssetHandover(request);
    }

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

    if (item == null || isNew) {
      Map<String, dynamic>? result = await dieuDongProvider.uploadWordDocument(
        context,
        _selectedFileName ?? '',
        _selectedFilePath ?? '',
        _selectedFileBytes ?? Uint8List(0),
      );
      final newRequest = request;
      newRequest['duongDanFile'] = result!['filePath'] ?? '';
      newRequest['tenFile'] = result['fileName'] ?? '';
      SGLog.error(
        'tag check listSignatory',
        'message: ${jsonEncode(listSignatory)}',
      );
      SGLog.error(
        'tag check listDetailAssetHandover',
        'message: ${jsonEncode(listDetailAssetHandover)}',
      );
      assetHandoverBloc.add(
        CreateAssetHandoverEvent(
          newRequest,
          listSignatory,
          listDetailAssetHandover,
        ),
      );
    } else {
      // Kiểm tra và cập nhật listDetailAssetHandover nếu có thay đổi
      await _checkAndUpdateDetailAssetHandover();

      int trangThai = item!.trangThai == 2 ? 0 : item!.trangThai!;
      // Thêm dòng này - Cập nhật người ký nếu có thay đổi
      if (_signatoriesChanged()) {
        await UpdateSignerData().syncSignatories(
          item!.id!,
          _additionalSignersDetailed,
        );
      }
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
      assetHandoverBloc.add(UpdateAssetHandoverEvent(request, item!.id!));

      String newSignatory = listSignatory.map((e) => e.idNguoiKy).join(',');
      //Gửi message đến server để cập nhật trạng thái phiếu ký nội sinh
      String idNeedToDo =
          "${nguoiDaiDienBenGiao?.id},${nguoiDaiDienBenNhan?.id},${nguoiKyGiamDoc?.id},$newSignatory, admin,${currentUser?.tenDangNhap}";
      Future.delayed(const Duration(milliseconds: 200)).then((_) {
        MessageServiceRealtime().pushJsonMessage(
          typeFunc: FunctionType.ASSET_HANDOVER,
          typeAction: ActionType.CREATE,
          idNeedToDo: idNeedToDo,
        );
      });
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

    _saveAssetHandover();
  }

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
    controllerDocumentCreationDate.dispose();
    // controllerLeader.dispose();
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
            // Hiển thị indicator unsaved changes và nút Save/Cancel
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
                          final assetHandoverBloc =
                              BlocProvider.of<AssetHandoverBloc>(context);
                          assetHandoverBloc.add(
                            CancelAssetHandoverEvent(
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
              _buildInfoAssetHandoverMobile(isWideScreen),
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
                      if (fileBytes != null) {
                        _loadPdfFromBytes(fileBytes);
                      } else if (filePath != null) {
                        _loadPdf(filePath);
                      }
                    }
                    if (_validationErrors.containsKey('document')) {
                      _validationErrors.remove('document');
                    }
                  });
                },
                convertDocToPdf: (bytes, fileName) async {
                  return await convertDocxBytesToPdf(
                    fileName: fileName,
                    fileBytes: bytes,
                    jsessionId: 'F81793FE9E6699D567ACE0E80A441F9A',
                  );
                },
                // onUpload: _uploadWordDocument,
                isUploading: true,
                label: 'Tài liệu Quyết định',
                errorMessage: 'Tài liệu quyết định là bắt buộc',
                hintText: 'Định dạng hỗ trợ: .pdf, .docx ',
                allowedExtensions: ['pdf', 'docx'],
                document: previewDocumentDecisionAssetHandover(
                  context: context,
                  document: _document,
                ),
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: dieuDongTaiSan != null,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: TableAssetMovementDetail(
                    listDetailAssetMobilization:
                        widget.provider.dataDetailAssetMobilization,
                    listDetailAssetHandover: item?.chiTietBanGiaoTaiSan,
                    isDetail: isDetail,
                    isEditing: isEditing,
                    onDataChanged: (data) {
                      setState(() {
                        listDetailAssetHandover =
                            data
                                .map(
                                  (e) => DetailAssetHandoverDto(
                                    id: UUIDGenerator.generateWithFormat(
                                      'CTBGCCDC-******',
                                    ),
                                    idBanGiaoTaiSan: item?.id ?? '',
                                    banGiaoTaiSan: item?.banGiaoTaiSan ?? '',
                                    quyetDinhDieuDongSo:
                                        item?.quyetDinhDieuDongSo ?? '',
                                    idTaiSan: e.idTaiSan,
                                    tenTaiSan: e.tenTaiSan,
                                    donViTinh: e.donViTinh,
                                    hienTrang: e.hienTrang,
                                    soLuong: e.soLuong,
                                    moTa: e.ghiChu,
                                    ngayTao: AppUtility.formatDateString(
                                      DateTime.now(),
                                    ),
                                    ngayCapNhat: AppUtility.formatDateString(
                                      DateTime.now(),
                                    ),
                                    nguoiTao: currentUser?.tenDangNhap ?? '',
                                    nguoiCapNhat: '',
                                    isActive: true,
                                  ),
                                )
                                .toList();
                        widget.provider.dataDetailAssetHandover =
                            listDetailAssetHandover;
                        print(
                          'listDetailAssetHandover: ${jsonEncode(listDetailAssetHandover)}',
                        );
                        getAssetHandoverPreview();
                      });
                    },
                  ),
                ),
              ),
              previewDocumentAssetHandover(
                context: context,
                item: getAssetHandoverPreview(),
                itemsDetail:
                    widget.provider.dataDetailAssetHandover ??
                    listDetailAssetHandover,
                provider: widget.provider,
                isShowKy: false,
              ),
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
      spacing: 10,
      children: [
        CommonFormInput(
          label: 'Số phiếu bàn giao',
          controller: controllerHandoverNumber,
          isEditing: (isEditing && item == null),
          fieldName: 'handoverNumber',
          textContent: item?.id ?? '',
          validationErrors: _validationErrors,
          isRequired: true,
        ),
        CommonFormInput(
          label: 'Tên biên bản bàn giao tài sản',
          controller: controllerDocumentName,
          isEditing: isEditing,
          textContent: item?.banGiaoTaiSan ?? '',
          fieldName: 'documentName',
          validationErrors: _validationErrors,
          isRequired: true,
        ),

        CmFormDropdownObject<DieuDongTaiSanDto>(
          label: 'Lệnh điều động',
          controller: controllerOrder,
          isEditing: isEditing,
          value: dieuDongTaiSan,
          defaultValue:
              item?.lenhDieuDong != null
                  ? getAssetTransfer(
                    listAssetTransfer: listAssetTransfer,
                    idAssetTransfer: item!.quyetDinhDieuDongSo!,
                  )
                  : null,
          fieldName: 'order',
          items: itemsAssetTransfer,
          onChanged: (value) {
            setState(() {
              dieuDongTaiSan = value;
              // if (dieuDongTaiSan?.tenFile!.isNotEmpty ?? true) {
              //   _loadPdfNetwork(dieuDongTaiSan?.tenFile ?? '');
              // }

              //change Đơn vị giao
              donViGiao = getPhongBan(
                listPhongBan: listPhongBan,
                idPhongBan: dieuDongTaiSan?.idDonViGiao ?? '',
              );
              // controllerSenderUnit.text = donViGiao?.tenPhongBan ?? '';

              //change Đơn vị nhận
              donViNhan = getPhongBan(
                listPhongBan: listPhongBan,
                idPhongBan: dieuDongTaiSan?.idDonViNhan ?? '',
              );
              // controllerReceiverUnit.text = donViNhan?.tenPhongBan ?? '';
              getStaffDonViGiaoAndNhan(
                dieuDongTaiSan?.idDonViNhan ?? '',
                dieuDongTaiSan?.idDonViGiao ?? '',
              );
              widget.provider.getListDetailAssetMobilization(value.id ?? '');
              getAssetHandoverPreview();
            });
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
        ),
        CommonFormInput(
          label: 'Số quyết định',
          controller: controllerDecisionNumber,
          isEditing: isEditing,
          textContent: item?.soQuyetDinh ?? '',
          fieldName: 'decisionNumber',
          validationErrors: _validationErrors,
          isRequired: true,
        ),
        CommonFormInput(
          label: 'Địa điểm quyết định',
          controller: controllerDecisionLocation,
          isEditing: isEditing,
          textContent: item?.diaDiemQuyetDinh ?? '',
          fieldName: 'decisionLocation',
          validationErrors: _validationErrors,
          isRequired: true,
        ),
        CmFormDate(
          label: 'Ngày quyết định',
          controller: controllerDecisionDate,
          isEditing: isEditing,
          value: ngayQuyetDinh,
          onChanged: (dt) {
            setState(() {
              ngayQuyetDinh = dt;
            });
            if (dt != null) {
              controllerDecisionDate.text = AppUtility.formatDateString(dt);
            }
          },
          validationErrors: _validationErrors,
          fieldName: 'decisionDate',
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
        CmFormDate(
          label: 'Ngày tạo chứng từ',
          controller: controllerDocumentCreationDate,
          isEditing: isEditing,
          value: ngayTaoChungTu,
          onChanged: (dt) {},
          validationErrors: _validationErrors,
          fieldName: 'documentCreationDate',
          isRequired: true,
        ),
      ],
    );
  }

  Widget _buildAssetHandoverDetail() {
    return Column(
      spacing: 10,
      children: [
        // CmFormDropdownObject<NhanVien>(
        //   label: 'Đại diện đơn vị đề nghị',
        //   controller: controllerIssuingUnitRepresentative,
        //   isEditing: isEditing,
        //   defaultValue:
        //       item?.idDaiDiendonviBanHanhQD != null
        //           ? widget.provider.getNhanVien(
        //             idNhanVien: item!.idDaiDiendonviBanHanhQD!,
        //           )
        //           : null,
        //   fieldName: 'issuingUnitRepresentative',
        //   items: itemsNhanVien,
        //   onChanged: (value) {
        //     nguoiDaiDienBanHanhQD = value;
        //   },
        //   validationErrors: _validationErrors,
        //   isRequired: true,
        // ),
        // SizedBox(height: 1),
        // CommonCheckboxInput(
        //   label: 'Đã xác nhận',
        //   value: isUnitConfirm,
        //   isEditing: false,
        //   isDisabled: true,
        //   onChanged: (newValue) {
        //     setState(() {
        //       isUnitConfirm = newValue;
        //     });
        //   },
        // ),
        // SizedBox(height: 1),
        CmFormDropdownObject<NhanVien>(
          label: 'Đơn vị giao',
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
                child: Text('${e.hoTen ?? ''} - ${e.id ?? ''}'),
              ),
            ),
          ],
          onChanged: (value) {
            nguoiDaiDienBenGiao = value;
          },
          validationErrors: _validationErrors,
          isRequired: true,
        ),
        // CommonCheckboxInput(
        //   label: 'Đại diện bên giao đã xác nhận',
        //   value: isDelivererConfirm,
        //   isEditing: isEditing,
        //   isDisabled: true,
        //   onChanged: (newValue) {
        //     setState(() {
        //       isDelivererConfirm = newValue;
        //     });
        //   },
        // ),
        CmFormDropdownObject<NhanVien>(
          label: 'Đơn vị bên nhận',
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
                child: Text('${e.hoTen ?? ''} - ${e.id ?? ''}'),
              ),
            ),
          ],
          onChanged: (value) {
            nguoiDaiDienBenNhan = value;
          },
          validationErrors: _validationErrors,
          isRequired: true,
        ),
        // CommonCheckboxInput(
        //   label: 'Đại diện bên nhận đã xác nhận',
        //   value: isReceiverConfirm,
        //   isEditing: isEditing,
        //   isDisabled: true,
        //   onChanged: (newValue) {
        //     setState(() {
        //       isReceiverConfirm = newValue;
        //     });
        //   },
        // ),
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
        CmFormDropdownObject<NhanVien>(
          label: 'Giám đốc ký xác nhận',
          controller: controllerGiamDocKy,
          isEditing: isEditing,
          value: nguoiKyGiamDoc,
          defaultValue:
              item?.idGiamDoc != null
                  ? widget.provider.getNhanVien(idNhanVien: item!.idGiamDoc!)
                  : null,
          fieldName: 'giamDocXacNhan',
          items: [
            ...listNhanVien
                .where(
                  (e) =>
                      e.phongBanId == 'GD' ||
                      e.boPhan == 'GD' ||
                      e.phongBanId == 'P21' ||
                      e.boPhan == 'P21',
                )
                .map(
                  (e) => DropdownMenuItem<NhanVien>(
                    value: e,
                    child: Text('${e.hoTen ?? ''} - ${e.id ?? ''}'),
                  ),
                ),
          ],
          onChanged: (value) {
            setState(() {
              nguoiKyGiamDoc = value;
            });
          },
          validationErrors: _validationErrors,
          isRequired: true,
        ),
        // CommonCheckboxInput(
        //   label: 'Giám đốc xác nhận',
        //   value: isGiamDocConfirm,
        //   isEditing: isEditing,
        //   isDisabled: true,
        //   onChanged: (newValue) {
        //     setState(() {
        //       isGiamDocConfirm = newValue;
        //     });
        //   },
        // ),
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

  AssetHandoverDto? getAssetHandoverPreview() {
    return AssetHandoverDto(
      id: controllerHandoverNumber.text,
      idCongTy: currentUser?.idCongTy ?? '',
      banGiaoTaiSan: controllerDocumentName.text,
      quyetDinhDieuDongSo: dieuDongTaiSan?.soQuyetDinh ?? '',
      lenhDieuDong: dieuDongTaiSan?.id ?? '',
      idDonViGiao: donViGiao?.id ?? '',
      tenDonViGiao: donViGiao?.tenPhongBan ?? '',
      idDonViNhan: donViNhan?.id ?? '',
      tenDonViNhan: donViNhan?.tenPhongBan ?? '',
      idDonViDaiDien: nguoiDaiDienBanHanhQD?.id ?? '',
      tenDonViDaiDien: nguoiDaiDienBanHanhQD?.hoTen ?? '',
      ngayBanGiao: AppUtility.formatDateString(ngayBanGiao ?? DateTime.now()),
      ngayTaoChungTu: AppUtility.formatDateString(
        ngayTaoChungTu ?? DateTime.now(),
      ),
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
      donViDaiDienXacNhan: nguoiDaiDienDonViDaiDien?.id ?? '',
      trangThai: 1,
      note: '',
      ngayTao: AppUtility.formatDateString(DateTime.now()),
      ngayCapNhat: AppUtility.formatDateString(DateTime.now()),
      nguoiTao: currentUser?.id ?? '',
      nguoiCapNhat: currentUser?.id ?? '',
      isActive: true,
      idGiamDoc: nguoiKyGiamDoc?.id ?? '',
      tenGiamDoc: nguoiKyGiamDoc?.hoTen ?? '',
      giamDocKy: isGiamDocConfirm,
      soQuyetDinh: controllerDecisionNumber.text,
      ngayQuyetDinh: AppUtility.formatDateString(
        ngayQuyetDinh ?? DateTime.now(),
      ),
      diaDiemQuyetDinh: controllerDecisionLocation.text,
      ngayChungTu: AppUtility.formatDateString(
        ngayTaoChungTu ?? DateTime.now(),
      ),
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
      tenFile: _selectedFileName ?? '',
      duongDanFile: _selectedFilePath ?? '',
    );
  }

  /// Kiểm tra xem listDetailAssetHandover có bị thay đổi không
  bool _hasDetailAssetHandoverChanged() {
    if (_originalListDetailAssetHandover.length !=
        listDetailAssetHandover.length) {
      return true;
    }

    // So sánh từng phần tử dựa trên JSON để phát hiện thay đổi
    for (int i = 0; i < listDetailAssetHandover.length; i++) {
      final current = listDetailAssetHandover[i];
      final original = _originalListDetailAssetHandover.firstWhere(
        (e) => e.id == current.id,
        orElse: () => DetailAssetHandoverDto(),
      );

      // Nếu không tìm thấy trong danh sách gốc hoặc có sự khác biệt
      if (original.id == null ||
          jsonEncode(current.toJson()) != jsonEncode(original.toJson())) {
        return true;
      }
    }

    return false;
  }

  /// Cập nhật listDetailAssetHandover nếu có thay đổi
  Future<void> _checkAndUpdateDetailAssetHandover() async {
    if (!_hasDetailAssetHandoverChanged()) {
      return;
    }

    final repository = AssetHandoverRepository();
    final result = await repository.updateDetailAssetHandover(
      listDetailAssetHandover,
    );

    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      // Cập nhật giá trị gốc sau khi update thành công
      _originalListDetailAssetHandover =
          listDetailAssetHandover
              .map(
                (e) => DetailAssetHandoverDto(
                  id: e.id,
                  idBanGiaoTaiSan: e.idBanGiaoTaiSan,
                  banGiaoTaiSan: e.banGiaoTaiSan,
                  quyetDinhDieuDongSo: e.quyetDinhDieuDongSo,
                  idTaiSan: e.idTaiSan,
                  tenTaiSan: e.tenTaiSan,
                  donViTinh: e.donViTinh,
                  kyHieu: e.kyHieu,
                  soKyHieu: e.soKyHieu,
                  hienTrang: e.hienTrang,
                  moTa: e.moTa,
                  soLuong: e.soLuong,
                  ngayTao: e.ngayTao,
                  ngayCapNhat: e.ngayCapNhat,
                  nguoiTao: e.nguoiTao,
                  nguoiCapNhat: e.nguoiCapNhat,
                  isActive: e.isActive,
                ),
              )
              .toList();
    } else {
      SGLog.error(
        "AssetHandoverDetail",
        "Error updating detail asset handover: ${result['status_code']}",
      );
    }
  }

  // void _updateDetailAssetHandover(List<ChiTietDieuDongTaiSan> newData) {
  //   final currentList = item?.chiTietBanGiaoTaiSan ?? [];
  //   final repository = AssetHandoverRepository();
  //   final newList =
  //       newData.map((newItem) {
  //         final existing = currentList.firstWhere(
  //           (h) => h.tenTaiSan == newItem.tenTaiSan,
  //           orElse: () => DetailAssetHandoverDto(),
  //         );
  //         return DetailAssetHandoverDto(
  //           id:
  //               existing.id ??
  //               UUIDGenerator.generateWithFormat('CTBGCCDC-******'),
  //           idBanGiaoTaiSan: item?.id ?? '',
  //           banGiaoTaiSan: item?.banGiaoTaiSan ?? '',
  //           quyetDinhDieuDongSo: item?.quyetDinhDieuDongSo ?? '',
  //           idTaiSan: newItem.idTaiSan,
  //           tenTaiSan: newItem.tenTaiSan,
  //           donViTinh: newItem.donViTinh,
  //           kyHieu: existing.kyHieu,
  //           soKyHieu: existing.soKyHieu,
  //           hienTrang: newItem.hienTrang,
  //           moTa: newItem.ghiChu,
  //           soLuong: newItem.soLuong,
  //           ngayTao:
  //               existing.ngayTao ?? AppUtility.formatDateString(DateTime.now()),
  //           ngayCapNhat: AppUtility.formatDateString(DateTime.now()),
  //           nguoiTao: existing.nguoiTao ?? currentUser?.tenDangNhap ?? '',
  //           nguoiCapNhat: currentUser?.tenDangNhap ?? '',
  //           isActive: newItem.isActive,
  //         );
  //       }).toList();

  //   _performCRUDOperations(repository, currentList, newList);

  //   listDetailAssetHandover = newList;
  //   if (item != null) {
  //     item!.chiTietBanGiaoTaiSan = newList;
  //   }

  //   // Cập nhật giá trị gốc sau khi thay đổi
  //   _originalListDetailAssetHandover = newList
  //       .map((e) => DetailAssetHandoverDto(
  //             id: e.id,
  //             idBanGiaoTaiSan: e.idBanGiaoTaiSan,
  //             banGiaoTaiSan: e.banGiaoTaiSan,
  //             quyetDinhDieuDongSo: e.quyetDinhDieuDongSo,
  //             idTaiSan: e.idTaiSan,
  //             tenTaiSan: e.tenTaiSan,
  //             donViTinh: e.donViTinh,
  //             kyHieu: e.kyHieu,
  //             soKyHieu: e.soKyHieu,
  //             hienTrang: e.hienTrang,
  //             moTa: e.moTa,
  //             soLuong: e.soLuong,
  //             ngayTao: e.ngayTao,
  //             ngayCapNhat: e.ngayCapNhat,
  //             nguoiTao: e.nguoiTao,
  //             nguoiCapNhat: e.nguoiCapNhat,
  //             isActive: e.isActive,
  //           ))
  //       .toList();
  // }

  // void _performCRUDOperations(
  //   AssetHandoverRepository repository,
  //   List<DetailAssetHandoverDto> currentList,
  //   List<DetailAssetHandoverDto> newList,
  // ) {
  //   final itemsToAdd =
  //       newList
  //           .where(
  //             (newItem) =>
  //                 !currentList.any(
  //                   (currentItem) => currentItem.id == newItem.id,
  //                 ),
  //           )
  //           .toList();

  //   final itemsToDelete =
  //       currentList
  //           .where(
  //             (currentItem) =>
  //                 !newList.any((newItem) => newItem.id == currentItem.id),
  //           )
  //           .toList();

  //   // Thực hiện thêm mới
  //   if (itemsToAdd.isNotEmpty) {
  //     repository.createDetailHandoverAsset(itemsToAdd);
  //   }

  //   // Thực hiện xóa
  //   for (final item in itemsToDelete) {
  //     if (item.id != null) {
  //       repository.deleteDetailHandoverCCDC(item.id!);
  //     }
  //   }
  // }

  onInitListDetailAssetHandover(Map<String, dynamic> request) {
    if (item != null) {
      listDetailAssetHandover = item?.chiTietBanGiaoTaiSan ?? [];
    } else {
      listDetailAssetHandover =
          (widget.provider.dataDetailAssetMobilization != null
              ? widget.provider.dataDetailAssetMobilization!
                  .map(
                    (e) => DetailAssetHandoverDto(
                      id: UUIDGenerator.generateWithFormat('CTBGCCDC-******'),
                      idBanGiaoTaiSan: request['id'] ?? '',
                      banGiaoTaiSan: request['banGiaoTaiSan'] ?? '',
                      quyetDinhDieuDongSo: request['quyetDinhDieuDongSo'] ?? '',
                      idTaiSan: e.idTaiSan,
                      tenTaiSan: e.tenTaiSan,
                      donViTinh: e.donViTinh,
                      hienTrang: e.hienTrang,
                      soLuong: e.soLuong,
                      ngayTao: AppUtility.formatDateString(DateTime.now()),
                      ngayCapNhat: AppUtility.formatDateString(DateTime.now()),
                      nguoiTao: currentUser?.tenDangNhap ?? '',
                      nguoiCapNhat: '',
                      isActive: true,
                    ),
                  )
                  .toList()
              : <DetailAssetHandoverDto>[]);
    }
  }
}
