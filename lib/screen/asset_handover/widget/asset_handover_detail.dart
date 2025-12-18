// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/components/convert_pdf.dart';
import 'package:quan_ly_tai_san_app/common/components/update_signer_data.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/widgets/document_upload_widget.dart';
import 'package:quan_ly_tai_san_app/core/constants/function_type.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/core/utils/uuid_generator.dart';
import 'package:quan_ly_tai_san_app/message/message_service_realtime.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/component/preview_document_asset_handover.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/component/table_asset_movement_detail.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/detai_asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/asset_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/repository/asset_handover_repository.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/widget/asset_handover_form_controllers.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/widget/asset_handover_form_validator.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/widget/asset_handover_pdf_manager.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/widget/asset_handover_info_section.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/widget/asset_handover_detail_section.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/widget/asset_handover_action_buttons.dart';
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
  late final AssetHandoverFormControllers _controllers;
  late final AssetHandoverFormValidator _validator;
  late final AssetHandoverPdfManager _pdfManager;

  bool _isEditing = false;
  bool _isNew = false;
  bool _isDetail = false;
  UserInfoDTO? _currentUser;
  AssetHandoverDto? _item;

  // Data lists
  List<PhongBan> _listPhongBan = [];
  List<NhanVien> _listNhanVien = [];
  List<NhanVien> _listNhanVienDonViNhan = [];
  List<NhanVien> _listNhanVienDonViGiao = [];
  List<DieuDongTaiSanDto> _listAssetTransfer = [];
  List<DetailAssetHandoverDto> _listDetailAssetHandover = [];
  List<DetailAssetHandoverDto> _originalListDetailAssetHandover = [];

  // Dropdown items
  List<DropdownMenuItem<NhanVien>> _itemsNhanVien = [];
  List<DropdownMenuItem<PhongBan>> _itemsPhongBan = [];
  List<DropdownMenuItem<DieuDongTaiSanDto>> _itemsAssetTransfer = [];

  // Selected values
  PhongBan? _donViNhan;
  PhongBan? _donViGiao;
  NhanVien? _nguoiDaiDienBenGiao;
  NhanVien? _nguoiDaiDienBenNhan;
  NhanVien? _nguoiKyGiamDoc;
  DieuDongTaiSanDto? _dieuDongTaiSan;

  // Signatories
  List<AdditionalSignerData> _additionalSignersDetailed = [];
  List<AdditionalSignerData> _initialSignersDetailed = [];

  // File
  String? _selectedFileName;
  String? _selectedFilePath;
  Uint8List? _selectedFileBytes;

  @override
  void initState() {
    super.initState();
    _controllers = AssetHandoverFormControllers();
    _validator = AssetHandoverFormValidator();
    _pdfManager = AssetHandoverPdfManager(
      onDocumentChanged: (document) {
        if (mounted) setState(() {});
      },
    );
    _initData();
  }

  @override
  void didUpdateWidget(AssetHandoverDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    final itemChanged = oldWidget.provider.item != _item;
    final isEditingChanged = oldWidget.isEditing != widget.isEditing;
    final dataDetailAssetMobilizationChanged =
        oldWidget.provider.dataDetailAssetMobilization !=
            widget.provider.dataDetailAssetMobilization;
    final chiTietBanGiaoTaiSanChanged =
        (oldWidget.provider.item?.chiTietBanGiaoTaiSan?.length ?? 0) !=
            (widget.provider.item?.chiTietBanGiaoTaiSan?.length ?? 0);

    if (itemChanged ||
        isEditingChanged ||
        dataDetailAssetMobilizationChanged ||
        chiTietBanGiaoTaiSanChanged) {
      if (mounted) {
        _initData();
      }
    }
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }

  bool _editable() {
    return (_item != null &&
        (_item!.trangThai == 0 || _item!.trangThai == 2) &&
        _item!.nguoiTao == _currentUser?.tenDangNhap);
  }

  void _initData() {
    if (!mounted) return;

    setState(() {
      _isNew = widget.isFindNew;
      _currentUser = AccountHelper.instance.getUserInfo();
      _item = widget.provider.item;
      _isEditing = widget.isEditing;

      if (_editable()) {
        _isEditing = true;
      } else {
        _isEditing = false;
      }

      _listNhanVien = widget.provider.dataStaff ?? [];
      _listPhongBan = widget.provider.dataDepartment ?? [];
      _listAssetTransfer = widget.provider.getFilteredAssetTransfer(
        isEditing: _item != null || widget.isFindNew,
      );

      if (_item != null) {
        _isDetail = true;
        if (widget.isFindNew) {
          _isEditing = widget.isFindNew;
          _isDetail = false;
          _dieuDongTaiSan = _listAssetTransfer.firstWhere(
            (element) => element.id == _item?.lenhDieuDong,
            orElse: () => DieuDongTaiSanDto(),
          );

          _controllers.order.text = _dieuDongTaiSan?.id ?? '';
          _listDetailAssetHandover = _buildDetailAssetHandoverFromMobilization();
        } else {
          _listDetailAssetHandover = _item?.chiTietBanGiaoTaiSan ?? [];
        }

        _originalListDetailAssetHandover =
            _listDetailAssetHandover.map((e) => _copyDetailDto(e)).toList();

        _nguoiKyGiamDoc = AccountHelper.instance.getNhanVienById(
          _item?.idGiamDoc ?? '',
        );
        _selectedFileName = _item?.tenFile ?? '';
        _selectedFilePath = _item?.duongDanFile ?? '';

        _controllers.setDates(
          ngayBanGiao: AppUtility.parseDate(_item?.ngayBanGiao ?? ''),
          ngayTaoChungTu: AppUtility.parseDate(_item?.ngayTaoChungTu ?? ''),
          ngayQuyetDinh: AppUtility.parseDate(_item?.ngayQuyetDinh ?? ''),
        );

        _getStaffDonViGiaoAndNhan(
          _item!.idDonViNhan!,
          _item!.idDonViGiao!,
        );

        _additionalSignersDetailed = _buildAdditionalSignersFromItem();
        _initialSignersDetailed = List<AdditionalSignerData>.from(
          _item?.listSignatory
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
        _isDetail = false;
        _selectedFileName = null;
        _selectedFilePath = null;
      }

      _buildDropdownItems();
      _updateControllers();
    });

    if (_item != null && !widget.isFindNew) {
      _pdfManager.loadPdfNetwork(_item?.tenFile ?? '');
    }
  }

  List<DetailAssetHandoverDto> _buildDetailAssetHandoverFromMobilization() {
    if (widget.provider.dataDetailAssetMobilization == null) {
      return <DetailAssetHandoverDto>[];
    }

    return widget.provider.dataDetailAssetMobilization!.map((e) {
      return DetailAssetHandoverDto(
        id: UUIDGenerator.generateWithFormat('CTBGCCDC-******'),
        idBanGiaoTaiSan: _item?.id ?? '',
        banGiaoTaiSan: _item?.banGiaoTaiSan ?? '',
        quyetDinhDieuDongSo: _dieuDongTaiSan?.soQuyetDinh ?? '',
        idTaiSan: e.idTaiSan,
        tenTaiSan: e.tenTaiSan,
        donViTinh: e.donViTinh,
        hienTrang: e.hienTrang,
        kyHieu: e.kyHieu,
        soKyHieu: e.soKyHieu,
        ghiChu: e.ghiChu,
        moTa: e.moTa,
        soLuong: e.soLuong,
        ngayTao: AppUtility.formatDateString(DateTime.now()),
        ngayCapNhat: AppUtility.formatDateString(DateTime.now()),
        nguoiTao: _currentUser?.tenDangNhap ?? '',
        nguoiCapNhat: '',
        isActive: true,
      );
    }).toList();
  }

  List<AdditionalSignerData> _buildAdditionalSignersFromItem() {
    return _item?.listSignatory
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
  }

  DetailAssetHandoverDto _copyDetailDto(DetailAssetHandoverDto e) {
    return DetailAssetHandoverDto(
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
      ghiChu: e.ghiChu,
      soLuong: e.soLuong,
      moTa: e.moTa,
      ngayTao: e.ngayTao,
      ngayCapNhat: e.ngayCapNhat,
      nguoiTao: e.nguoiTao,
      nguoiCapNhat: e.nguoiCapNhat,
      isActive: e.isActive,
    );
  }

  void _getStaffDonViGiaoAndNhan(String idDonViNhan, String idDonViGiao) {
    final departments = widget.provider.dataDepartment ?? [];
    final donViGiao = departments.where((e) => e.id == idDonViGiao).firstOrNull;
    final donViNhan = departments.where((e) => e.id == idDonViNhan).firstOrNull;

    if (donViNhan?.isKho == true) {
      final idPhongBanKho = departments
          .where((element) => element.isKho == true)
          .map((element) => element.id)
          .toSet();
      _listNhanVienDonViNhan = _listNhanVien
          .where((element) => idPhongBanKho.contains(element.phongBanId))
          .toList();
    } else {
      _listNhanVienDonViNhan = _listNhanVien
          .where((element) => element.phongBanId == idDonViNhan)
          .toList();
    }

    if (donViGiao?.isKho == true) {
      final idPhongBanKho = departments
          .where((element) => element.isKho == true)
          .map((element) => element.id)
          .toSet();
      _listNhanVienDonViGiao = _listNhanVien
          .where((element) => idPhongBanKho.contains(element.phongBanId))
          .toList();
    } else {
      _listNhanVienDonViGiao = _listNhanVien
          .where((element) => element.phongBanId == idDonViGiao)
          .toList();
    }
  }

  void _buildDropdownItems() {
    _itemsNhanVien = _listNhanVien.isNotEmpty
        ? _listNhanVien
            .map(
              (user) => DropdownMenuItem<NhanVien>(
                value: user,
                child: Text(user.hoTen ?? ''),
              ),
            )
            .toList()
        : <DropdownMenuItem<NhanVien>>[];

    _itemsPhongBan = _listPhongBan.isNotEmpty
        ? _listPhongBan
            .map(
              (user) => DropdownMenuItem<PhongBan>(
                value: user,
                child: Text(user.tenPhongBan ?? ''),
              ),
            )
            .toList()
        : <DropdownMenuItem<PhongBan>>[];

    _itemsAssetTransfer = _listAssetTransfer.isNotEmpty
        ? _listAssetTransfer
            .map(
              (assetTransfer) => DropdownMenuItem<DieuDongTaiSanDto>(
                value: assetTransfer,
                child: Text(assetTransfer.id ?? ''),
              ),
            )
            .toList()
        : <DropdownMenuItem<DieuDongTaiSanDto>>[];

    _dieuDongTaiSan = null;
    _initialSignersDetailed.clear();
  }

  void _updateControllers() {
    if (!mounted) return;
    if (_item != null) {
      _controllers.handoverNumber.text = _item?.id ?? '';
      _controllers.documentName.text = _item?.banGiaoTaiSan ?? '';
      _dieuDongTaiSan = _listAssetTransfer.firstWhere(
        (element) => element.id == _item?.lenhDieuDong,
        orElse: () => DieuDongTaiSanDto(),
      );
      _controllers.order.text = _dieuDongTaiSan?.id ?? '';
      _controllers.senderUnit.text = _item?.tenDonViGiao ?? '';
      _controllers.receiverUnit.text = _item?.tenDonViNhan ?? '';
      _controllers.delivererRepresentative.text =
          _item?.tenDaiDienBenGiao ?? '';
      _controllers.receiverRepresentative.text = _item?.tenDaiDienBenNhan ?? '';
      _controllers.decisionNumber.text = _item?.soQuyetDinh ?? '';
      _controllers.decisionLocation.text = _item?.diaDiemQuyetDinh ?? '';
    } else {
      _isEditing = true;
      _controllers.handoverNumber.text = widget.provider.genID();
      _controllers.documentName.text = '';
    }
  }

  bool _signatoriesChanged() {
    if (_item == null) return _additionalSignersDetailed.isNotEmpty;
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

    final request = _buildSaveRequest();

    if (_listDetailAssetHandover.isEmpty) {
      _initListDetailAssetHandover(request);
      return;
    }

    final listSignatory = _buildSignatoryList();

    if (_item == null || _isNew) {
      await _createAssetHandover(
        dieuDongProvider,
        assetHandoverBloc,
        request,
        listSignatory,
      );
    } else {
      await _updateAssetHandover(
        dieuDongProvider,
        assetHandoverBloc,
        request,
        listSignatory,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.provider.hasUnsavedChanges = false;
      }
    });
  }

  Map<String, dynamic> _buildSaveRequest() {
    return {
      "idCongTy": _currentUser?.idCongTy ?? "CT001",
      "banGiaoTaiSan": _controllers.documentName.text,
      "quyetDinhDieuDongSo": _dieuDongTaiSan?.soQuyetDinh ?? '',
      "lenhDieuDong": _dieuDongTaiSan?.id ?? '',
      "idDonViGiao": _donViGiao?.id ?? '',
      "idDonViNhan": _donViNhan?.id ?? '',
      "idDaiDienBenGiao": _nguoiDaiDienBenGiao?.id ?? '',
      "idDaiDienBenNhan": _nguoiDaiDienBenNhan?.id ?? '',
      "ngayTaoChungTu": AppUtility.formatFromISOString(
        _controllers.documentCreationDate.text,
      ),
      "ngayBanGiao": AppUtility.formatFromISOString(
        _controllers.transferDate.text,
      ),
      "ngayTao": AppUtility.formatDateString(DateTime.now()),
      "ngayCapNhat": AppUtility.formatDateString(DateTime.now()),
      "idGiamDoc": _nguoiKyGiamDoc?.id ?? '',
      "tenGiamDoc": _nguoiKyGiamDoc?.hoTen ?? '',
      "trangThai": 0,
      "note": "",
      "nguoiTao": _currentUser?.tenDangNhap ?? '',
      "isActive": true,
      "share": false,
      "soQuyetDinh": _controllers.decisionNumber.text,
      "ngayQuyetDinh": AppUtility.formatDateString(
        _controllers.ngayQuyetDinh ?? DateTime.now(),
      ),
      "diaDiemQuyetDinh": _controllers.decisionLocation.text,
    };
  }

  List<SignatoryDto> _buildSignatoryList() {
    return _additionalSignersDetailed.map((e) {
      return SignatoryDto(
        id: UUIDGenerator.generateWithFormat("SIG-******"),
        idTaiLieu: _item?.id ?? '',
        idPhongBan: e.department?.id ?? '',
        idNguoiKy: e.employee?.id ?? '',
        tenNguoiKy: e.employee?.hoTen ?? '',
        trangThai: 1,
      );
    }).toList();
  }

  Future<void> _createAssetHandover(
    DieuDongTaiSanProvider dieuDongProvider,
    AssetHandoverBloc assetHandoverBloc,
    Map<String, dynamic> request,
    List<SignatoryDto> listSignatory,
  ) async {
    final result = await dieuDongProvider.uploadWordDocument(
      context,
      _selectedFileName ?? '',
      _selectedFilePath ?? '',
      _selectedFileBytes ?? Uint8List(0),
    );
    request['duongDanFile'] = result!['filePath'] ?? '';
    request['tenFile'] = result['fileName'] ?? '';

    assetHandoverBloc.add(
      CreateAssetHandoverEvent(
        request,
        listSignatory,
        _listDetailAssetHandover,
      ),
    );
  }

  Future<void> _updateAssetHandover(
    DieuDongTaiSanProvider dieuDongProvider,
    AssetHandoverBloc assetHandoverBloc,
    Map<String, dynamic> request,
    List<SignatoryDto> listSignatory,
  ) async {
    await _checkAndUpdateDetailAssetHandover();

    final trangThai = _item!.trangThai == 2 ? 0 : _item!.trangThai!;

    if (_signatoriesChanged()) {
      await UpdateSignerData().syncSignatories(
        _item!.id!,
        _additionalSignersDetailed,
      );
    }

    if (_item!.tenFile != _selectedFileName ||
        _item!.duongDanFile != _selectedFilePath) {
      final result = await dieuDongProvider.uploadWordDocument(
        context,
        _selectedFileName ?? '',
        _selectedFilePath ?? '',
        _selectedFileBytes ?? Uint8List(0),
      );
      request['duongDanFile'] = result!['filePath'] ?? '';
      request['tenFile'] = result['fileName'] ?? '';
    } else {
      request['duongDanFile'] = _item!.duongDanFile ?? '';
      request['tenFile'] = _item!.tenFile ?? '';
    }

    request['trangThai'] = trangThai;
    request['share'] = _item!.share ?? false;
    request['nguoiCapNhat'] = _currentUser?.tenDangNhap ?? '';

    assetHandoverBloc.add(UpdateAssetHandoverEvent(request, _item!.id!));

    final newSignatory = listSignatory.map((e) => e.idNguoiKy).join(',');
    final idNeedToDo =
        "${_nguoiDaiDienBenGiao?.id},${_nguoiDaiDienBenNhan?.id},${_nguoiKyGiamDoc?.id},$newSignatory, admin,${_currentUser?.tenDangNhap}";

    Future.delayed(const Duration(milliseconds: 200)).then((_) {
      MessageServiceRealtime().pushJsonMessage(
        typeFunc: FunctionType.ASSET_HANDOVER,
        typeAction: ActionType.CREATE,
        idNeedToDo: idNeedToDo,
      );
    });
  }

  void _saveChanges() {
    if (!_isEditing) return;
    if (!_validator.validate(_controllers, _nguoiKyGiamDoc, _selectedFileName,
        _selectedFilePath, setState)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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

  PhongBan _getPhongBan(String idPhongBan) {
    return _listPhongBan.where((item) => item.id == idPhongBan).firstOrNull ??
        PhongBan();
  }

  bool _hasDetailAssetHandoverChanged() {
    if (_originalListDetailAssetHandover.length !=
        _listDetailAssetHandover.length) {
      return true;
    }

    for (int i = 0; i < _listDetailAssetHandover.length; i++) {
      final current = _listDetailAssetHandover[i];
      final original = _originalListDetailAssetHandover.firstWhere(
        (e) => e.id == current.id,
        orElse: () => DetailAssetHandoverDto(),
      );

      if (original.id == null ||
          jsonEncode(current.toJson()) != jsonEncode(original.toJson())) {
        return true;
      }
    }

    return false;
  }

  Future<void> _checkAndUpdateDetailAssetHandover() async {
    if (!_hasDetailAssetHandoverChanged()) {
      return;
    }

    final repository = AssetHandoverRepository();
    final result =
        await repository.updateDetailAssetHandover(_listDetailAssetHandover);

    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      _originalListDetailAssetHandover =
          _listDetailAssetHandover.map((e) => _copyDetailDto(e)).toList();
    } else {
      SGLog.error(
        "AssetHandoverDetail",
        "Error updating detail asset handover: ${result['status_code']}",
      );
    }
  }

  void _initListDetailAssetHandover(Map<String, dynamic> request) {
    if (_item != null) {
      _listDetailAssetHandover = _item?.chiTietBanGiaoTaiSan ?? [];
    } else {
      _listDetailAssetHandover = widget.provider.dataDetailAssetMobilization !=
              null
          ? widget.provider.dataDetailAssetMobilization!.map((e) {
              return DetailAssetHandoverDto(
                id: UUIDGenerator.generateWithFormat('CTBGCCDC-******'),
                idBanGiaoTaiSan: request['id'] ?? '',
                banGiaoTaiSan: request['banGiaoTaiSan'] ?? '',
                quyetDinhDieuDongSo: request['quyetDinhDieuDongSo'] ?? '',
                idTaiSan: e.idTaiSan,
                tenTaiSan: e.tenTaiSan,
                donViTinh: e.donViTinh,
                hienTrang: e.hienTrang,
                kyHieu: e.kyHieu,
                soKyHieu: e.soKyHieu,
                moTa: e.moTa,
                ghiChu: e.ghiChu,
                soLuong: e.soLuong,
                ngayTao: AppUtility.formatDateString(DateTime.now()),
                ngayCapNhat: AppUtility.formatDateString(DateTime.now()),
                nguoiTao: _currentUser?.tenDangNhap ?? '',
                nguoiCapNhat: '',
                isActive: true,
              );
            }).toList()
          : <DetailAssetHandoverDto>[];
    }

    log("_listDetailAssetHandover: ${jsonEncode(_listDetailAssetHandover)}");
  }

  AssetHandoverDto? _getAssetHandoverPreview() {
    return AssetHandoverDto(
      idCongTy: _currentUser?.idCongTy ?? '',
      banGiaoTaiSan: _controllers.documentName.text,
      quyetDinhDieuDongSo: _dieuDongTaiSan?.soQuyetDinh ?? '',
      lenhDieuDong: _dieuDongTaiSan?.id ?? '',
      idDonViGiao: _donViGiao?.id ?? '',
      tenDonViGiao: _donViGiao?.tenPhongBan ?? '',
      idDonViNhan: _donViNhan?.id ?? '',
      tenDonViNhan: _donViNhan?.tenPhongBan ?? '',
      ngayBanGiao: AppUtility.formatDateString(
        _controllers.ngayBanGiao ?? DateTime.now(),
      ),
      ngayTaoChungTu: AppUtility.formatDateString(
        _controllers.ngayTaoChungTu ?? DateTime.now(),
      ),
      idDaiDienBenGiao: _nguoiDaiDienBenGiao?.id ?? '',
      tenDaiDienBenGiao: _nguoiDaiDienBenGiao?.hoTen ?? '',
      idDaiDienBenNhan: _nguoiDaiDienBenNhan?.id ?? '',
      tenDaiDienBenNhan: _nguoiDaiDienBenNhan?.hoTen ?? '',
      trangThai: 1,
      note: '',
      ngayTao: AppUtility.formatDateString(DateTime.now()),
      ngayCapNhat: AppUtility.formatDateString(DateTime.now()),
      nguoiTao: _currentUser?.id ?? '',
      nguoiCapNhat: _currentUser?.id ?? '',
      isActive: true,
      idGiamDoc: _nguoiKyGiamDoc?.id ?? '',
      tenGiamDoc: _nguoiKyGiamDoc?.hoTen ?? '',
      soQuyetDinh: _controllers.decisionNumber.text,
      ngayQuyetDinh: AppUtility.formatDateString(
        _controllers.ngayQuyetDinh ?? DateTime.now(),
      ),
      diaDiemQuyetDinh: _controllers.decisionLocation.text,
      ngayChungTu: AppUtility.formatDateString(
        _controllers.ngayTaoChungTu ?? DateTime.now(),
      ),
      listSignatory: _additionalSignersDetailed.map((e) {
        return SignatoryDto(
          id: UUIDGenerator.generateWithFormat("SIG-******"),
          idTaiLieu: _item?.id ?? '',
          idPhongBan: e.department?.id ?? '',
          idNguoiKy: e.employee?.id ?? '',
          tenNguoiKy: e.employee?.hoTen ?? '',
          trangThai: 1,
        );
      }).toList(),
      tenFile: _selectedFileName ?? '',
      duongDanFile: _selectedFilePath ?? '',
    );
  }

  void _onFileSelected(String? fileName, String? filePath, Uint8List? fileBytes) {
    setState(() {
      _selectedFileName = fileName;
      _selectedFilePath = filePath;
      _selectedFileBytes = fileBytes;
      if (fileName != null) {
        if (fileBytes != null) {
          _pdfManager.loadPdfFromBytes(fileBytes);
        } else if (filePath != null) {
          _pdfManager.loadPdf(filePath);
        }
      }
      _validator.removeError('document', setState);
    });
  }

  void _onOrderChanged(DieuDongTaiSanDto? value) {
    setState(() {
      _dieuDongTaiSan = value;
      _donViGiao = _getPhongBan(_dieuDongTaiSan?.idDonViGiao ?? '');
      _donViNhan = _getPhongBan(_dieuDongTaiSan?.idDonViNhan ?? '');
      _getStaffDonViGiaoAndNhan(
        _dieuDongTaiSan?.idDonViNhan ?? '',
        _dieuDongTaiSan?.idDonViGiao ?? '',
      );
      widget.provider.getListDetailAssetMobilization(value?.id ?? '');
    });
  }

  void _onDetailDataChanged(List<dynamic> data) {
    setState(() {
      _listDetailAssetHandover = data.map((e) {
        return DetailAssetHandoverDto(
          id: UUIDGenerator.generateWithFormat('CTBGCCDC-******'),
          idBanGiaoTaiSan: _item?.id ?? '',
          banGiaoTaiSan: _item?.banGiaoTaiSan ?? '',
          quyetDinhDieuDongSo: _item?.quyetDinhDieuDongSo ?? '',
          idTaiSan: e.idTaiSan,
          tenTaiSan: e.tenTaiSan,
          donViTinh: e.donViTinh,
          hienTrang: e.hienTrang,
          kyHieu: e.kyHieu,
          soKyHieu: e.soKyHieu,
          moTa: e.moTa,
          soLuong: e.soLuong,
          ghiChu: e.ghiChu,
          ngayTao: AppUtility.formatDateString(DateTime.now()),
          ngayCapNhat: AppUtility.formatDateString(DateTime.now()),
          nguoiTao: _currentUser?.tenDangNhap ?? '',
          nguoiCapNhat: '',
          isActive: true,
        );
      }).toList();
      widget.provider.dataDetailAssetHandover = _listDetailAssetHandover;
    });
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
    final isWideScreen = screenWidth > 800;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AssetHandoverActionButtons(
              isEditing: _isEditing,
              item: _item,
              isFindNew: widget.isFindNew,
              onSave: _saveChanges,
              onCancel: () {
                showConfirmDialog(
                  context,
                  type: ConfirmType.delete,
                  title: 'Xác nhận hủy tạo phiếu Bàn giao',
                  cancelText: 'Không',
                  confirmText: 'Có',
                  message:
                      'Bạn có chắc chắn muốn hủy? Các thay đổi chưa được lưu sẽ bị mất.',
                  onCancel: () {},
                  onConfirm: () {
                    widget.provider.isShowInput = false;
                  },
                );
              },
              onCancelHandover: () {
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
                        _item!.id.toString(),
                      ),
                    );
                  },
                );
              },
            ),
            SgIndicator(
              steps: const ['Nháp', 'Duyệt', 'Hủy', 'Hoàn thành'],
              currentStep: _item?.trangThai ?? 0,
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
                isEditing: _isEditing,
                selectedFileName: _selectedFileName,
                selectedFilePath: _selectedFilePath,
                validationErrors: _validator.errors,
                onFileSelected: _onFileSelected,
                convertDocToPdf: (bytes, fileName) async {
                  return await convertDocxBytesToPdf(
                    fileName: fileName,
                    fileBytes: bytes,
                    jsessionId: 'F81793FE9E6699D567ACE0E80A441F9A',
                  );
                },
                isUploading: true,
                label: 'Tài liệu Quyết định',
                errorMessage: 'Tài liệu quyết định là bắt buộc',
                hintText: 'Định dạng hỗ trợ: .pdf, .docx ',
                allowedExtensions: const ['pdf', 'docx'],
                document: previewDocumentDecisionAssetHandover(
                  context: context,
                  document: _pdfManager.document,
                ),
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: _dieuDongTaiSan != null,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: TableAssetMovementDetail(
                    listDetailAssetMobilization:
                        widget.provider.dataDetailAssetMobilization,
                    listDetailAssetHandover: _item?.chiTietBanGiaoTaiSan,
                    isDetail: _isDetail,
                    isEditing: _isEditing,
                    onDataChanged: _onDetailDataChanged,
                  ),
                ),
              ),
              previewDocumentAssetHandover(
                context: context,
                item: _getAssetHandoverPreview(),
                itemsDetail:
                    widget.provider.dataDetailAssetHandover ??
                        _listDetailAssetHandover,
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
          Expanded(
            child: AssetHandoverInfoSection(
              controllers: _controllers,
              isEditing: _isEditing,
              item: _item,
              isFindNew: widget.isFindNew,
              listAssetTransfer: _listAssetTransfer,
              itemsAssetTransfer: _itemsAssetTransfer,
              listPhongBan: _listPhongBan,
              itemsPhongBan: _itemsPhongBan,
              dieuDongTaiSan: _dieuDongTaiSan,
              donViGiao: _donViGiao,
              donViNhan: _donViNhan,
              validationErrors: _validator.errors,
              onOrderChanged: _onOrderChanged,
              onDonViGiaoChanged: (value) => setState(() => _donViGiao = value),
              onDonViNhanChanged: (value) => setState(() => _donViNhan = value),
              onDateChanged: (type, date) {
                setState(() {
                  _controllers.setDate(type, date);
                });
              },
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: AssetHandoverDetailSection(
              controllers: _controllers,
              isEditing: _isEditing,
              item: _item,
              provider: widget.provider,
              listNhanVienDonViGiao: _listNhanVienDonViGiao,
              listNhanVienDonViNhan: _listNhanVienDonViNhan,
              itemsNhanVien: _itemsNhanVien,
              listNhanVien: _listNhanVien,
              listPhongBan: _listPhongBan,
              nguoiDaiDienBenGiao: _nguoiDaiDienBenGiao,
              nguoiDaiDienBenNhan: _nguoiDaiDienBenNhan,
              nguoiKyGiamDoc: _nguoiKyGiamDoc,
              additionalSignersDetailed: _additionalSignersDetailed,
              validationErrors: _validator.errors,
              onDelivererChanged: (value) =>
                  setState(() => _nguoiDaiDienBenGiao = value),
              onReceiverChanged: (value) =>
                  setState(() => _nguoiDaiDienBenNhan = value),
              onGiamDocChanged: (value) =>
                  setState(() => _nguoiKyGiamDoc = value),
              onAdditionalSignersChanged: (list) =>
                  setState(() => _additionalSignersDetailed = list),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          AssetHandoverInfoSection(
            controllers: _controllers,
            isEditing: _isEditing,
            item: _item,
            isFindNew: widget.isFindNew,
            listAssetTransfer: _listAssetTransfer,
            itemsAssetTransfer: _itemsAssetTransfer,
            listPhongBan: _listPhongBan,
            itemsPhongBan: _itemsPhongBan,
            dieuDongTaiSan: _dieuDongTaiSan,
            donViGiao: _donViGiao,
            donViNhan: _donViNhan,
            validationErrors: _validator.errors,
            onOrderChanged: _onOrderChanged,
            onDonViGiaoChanged: (value) => setState(() => _donViGiao = value),
            onDonViNhanChanged: (value) => setState(() => _donViNhan = value),
            onDateChanged: (type, date) {
              setState(() {
                _controllers.setDate(type, date);
              });
            },
          ),
          AssetHandoverDetailSection(
            controllers: _controllers,
            isEditing: _isEditing,
            item: _item,
            provider: widget.provider,
            listNhanVienDonViGiao: _listNhanVienDonViGiao,
            listNhanVienDonViNhan: _listNhanVienDonViNhan,
            itemsNhanVien: _itemsNhanVien,
            listNhanVien: _listNhanVien,
            listPhongBan: _listPhongBan,
            nguoiDaiDienBenGiao: _nguoiDaiDienBenGiao,
            nguoiDaiDienBenNhan: _nguoiDaiDienBenNhan,
            nguoiKyGiamDoc: _nguoiKyGiamDoc,
            additionalSignersDetailed: _additionalSignersDetailed,
            validationErrors: _validator.errors,
            onDelivererChanged: (value) =>
                setState(() => _nguoiDaiDienBenGiao = value),
            onReceiverChanged: (value) =>
                setState(() => _nguoiDaiDienBenNhan = value),
            onGiamDocChanged: (value) =>
                setState(() => _nguoiKyGiamDoc = value),
            onAdditionalSignersChanged: (list) =>
                setState(() => _additionalSignersDetailed = list),
          ),
        ],
      );
    }
  }
}
