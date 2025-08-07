import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/asset_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/asset_transfer_provider.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/nhan_vien.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class AssetTransferController {
  // Core data
  AssetTransferDto? item;
  bool isEditing = false;
  bool isNew = false;
  bool isPreparerInitialed = false;
  bool isRequireManagerApproval = false;
  bool isDeputyConfirmed = false;
  bool isUploading = false;
  bool isRefreshing = false;
  String? proposingUnit;
  bool controllersInitialized = false;
  String? selectedFileName;
  String? selectedFilePath;

  PhongBan? deliveringUnit;
  PhongBan? receivingUnit;
  NhanVien? requester;
  NhanVien? departmentApproval;
  NhanVien? approver;

  // Data collections
  final List<AssetHandoverDto> listAssetHandover = [];
  List<NhanVien> listNhanVien = [];
  List<PhongBan> listPhongBan = [];

  // Dropdown items
  late List<DropdownMenuItem<NhanVien>> itemsRequester;
  late List<DropdownMenuItem<NhanVien>> itemsDepartmentApproval;
  late List<DropdownMenuItem<NhanVien>> itemsApprover;
  late List<DropdownMenuItem<PhongBan>> itemsDepartmentManager;

  // Form controllers
  final TextEditingController controllerSubject = TextEditingController();
  final TextEditingController controllerDocumentName = TextEditingController();
  final TextEditingController controllerDeliveringUnit = TextEditingController();
  final TextEditingController controllerReceivingUnit = TextEditingController();
  final TextEditingController controllerRequester = TextEditingController();
  final TextEditingController controllerProposingUnit = TextEditingController();
  final TextEditingController controllerQuantity = TextEditingController();
  final TextEditingController controllerDepartmentApproval = TextEditingController();
  final TextEditingController controllerEffectiveDate = TextEditingController();
  final TextEditingController controllerEffectiveDateTo = TextEditingController();
  final TextEditingController controllerApprover = TextEditingController();
  final TextEditingController controllerDeliveryLocation = TextEditingController();
  final TextEditingController controllerViewerDepartments = TextEditingController();
  final TextEditingController controllerViewerUsers = TextEditingController();
  final TextEditingController controllerReason = TextEditingController();
  final TextEditingController controllerBase = TextEditingController();
  final TextEditingController controllerArticle1 = TextEditingController();
  final TextEditingController controllerArticle2 = TextEditingController();
  final TextEditingController controllerArticle3 = TextEditingController();
  final TextEditingController controllerDestination = TextEditingController();

  // Additional state
  final Map<String, TextEditingController> contractTermsControllers = {};
  Map<String, bool> validationErrors = {};

  AssetTransferController();

  // Initialize controller with provider data
  void initialize(AssetTransferProvider provider, {bool isEditingParam = false, bool? isNewParam}) {
    SGLog.debug("AssetTransferController", ' initialize: $isEditingParam, $isNewParam');
    item = provider.item;
    isEditing = isEditingParam;
    isNew = isNewParam ?? false;

    // Update state if item exists
    if (item != null && item!.trangThai == 0) {
      isEditing = true;
    }

    // Initialize staff data
    listNhanVien = provider.listNhanVien;
    listPhongBan = provider.listPhongBan;

    // Initialize form data if item exists
    if (item != null && !controllersInitialized) {
      initializeControllersWithItem();
    } else if (item == null && !controllersInitialized) {
      initializeEmptyControllers();
    }

    // Initialize dropdown items
    _initializeDropdownItems();
  }

  // Initialize controllers with existing item data
  void initializeControllersWithItem() {
    controllerSubject.text = item?.ngayKy ?? '';
    controllerDocumentName.text = item?.tenPhieu ?? '';
    controllerDeliveringUnit.text = item?.tenDonViGiao ?? '';
    controllerReceivingUnit.text = item?.tenDonViNhan ?? '';
    controllerRequester.text = item?.tenNguoiDeNghi ?? '';
    controllerDepartmentApproval.text = item?.tenTrinhDuyetCapPhong ?? '';
    controllerEffectiveDate.text = item?.tggnTuNgay.toString() ?? '';
    controllerEffectiveDateTo.text = item?.tggnDenNgay.toString() ?? '';
    controllerApprover.text = item?.tenTrinhDuyetGiamDoc ?? '';
    controllerDeliveryLocation.text = item?.diaDiemGiaoNhan ?? '';

    selectedFileName = item?.tenFile;
    selectedFilePath = item?.duongDanFile;
    isPreparerInitialed = item?.nguoiLapPhieuKyNhay ?? false;
    isRequireManagerApproval = item?.quanTrongCanXacNhan ?? false;
    isDeputyConfirmed = item?.phoPhongXacNhan ?? false;
    proposingUnit = item?.tenDonViDeNghi;

    if (proposingUnit != null && proposingUnit!.isNotEmpty) {
      controllerProposingUnit.text = proposingUnit!;
    }

    controllersInitialized = true;
  }

  // Initialize empty controllers for new items
  void initializeEmptyControllers() {
    controllerSubject.text = '';
    controllerDocumentName.text = '';
    controllerDeliveringUnit.text = '';
    controllerReceivingUnit.text = '';
    controllerRequester.text = '';
    controllerDepartmentApproval.text = '';
    controllerEffectiveDate.text = AppUtility.formatDateDdMmYyyy(DateTime.now());
    controllerEffectiveDateTo.text = AppUtility.formatDateDdMmYyyy(DateTime.now());
    controllerApprover.text = '';
    controllerDeliveryLocation.text = '';
    controllerProposingUnit.text = '';
    controllersInitialized = false;
    selectedFileName = null;
    selectedFilePath = null;
    isPreparerInitialed = false;
    isRequireManagerApproval = false;
    isDeputyConfirmed = false;
  }

  // Initialize dropdown items
  void _initializeDropdownItems() {
    itemsDepartmentManager = listPhongBan.map((phongBan) => DropdownMenuItem<PhongBan>(value: phongBan, child: Text(phongBan.tenPhongBan ?? ''))).toList();

    itemsRequester = listNhanVien.map((nhanVien) => DropdownMenuItem<NhanVien>(value: nhanVien, child: Text(nhanVien.hoTen ?? ''))).toList();

    itemsDepartmentApproval = listNhanVien.map((nhanVien) => DropdownMenuItem<NhanVien>(value: nhanVien, child: Text(nhanVien.hoTen ?? ''))).toList();

    itemsApprover = listNhanVien.map((nhanVien) => DropdownMenuItem<NhanVien>(value: nhanVien, child: Text(nhanVien.hoTen ?? ''))).toList();
  }

  // Form validation
  bool validateForm() {
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
    if (item == null && selectedFileName == null) {
      newValidationErrors['document'] = true;
    }

    // Only update state if validation errors have changed
    bool hasChanges = !mapEquals(validationErrors, newValidationErrors);
    if (hasChanges) {
      validationErrors = newValidationErrors;
    }

    return newValidationErrors.isEmpty;
  }

  // Update controllers when staff data changes
  void updateStaffData(List<NhanVien> newListNhanVien, List<PhongBan> newListPhongBan) {
    listNhanVien = newListNhanVien;
    listPhongBan = newListPhongBan;
    _initializeDropdownItems();
  }

  // User selection handlers
  void onRequesterChanged(NhanVien value) {
    proposingUnit = value.boPhan;
    
    controllerRequester.text = value.hoTen ?? '';
    if (proposingUnit != null && proposingUnit!.isNotEmpty) {
      controllerProposingUnit.text = proposingUnit!;
    }
    requester = value;
  }

  void onDepartmentApprovalChanged(NhanVien value) {
    controllerDepartmentApproval.text = value.hoTen ?? '';
    departmentApproval = value;
  }

  void onApproverChanged(NhanVien value) {
    controllerApprover.text = value.hoTen ?? '';
    approver = value;
  }

  void onDeliveringUnitChanged(PhongBan value) {
    controllerDeliveringUnit.text = value.tenPhongBan ?? '';
    deliveringUnit = value;
  }

  void onReceivingUnitChanged(PhongBan value) {
    controllerReceivingUnit.text = value.tenPhongBan ?? '';
    receivingUnit = value;
  }

  // File operations
  void setSelectedFile(String? fileName, String? filePath) {
    selectedFileName = fileName;
    selectedFilePath = filePath;

    if (validationErrors.containsKey('document')) {
      validationErrors.remove('document');
    }
  }

  // State operations
  void refreshFromProvider(AssetTransferProvider provider, {bool isEditingParam = false, bool? isNewParam}) {
    item = provider.item;
    isNew = item == null;
    isEditing = isEditingParam;

    if (item != null && item!.trangThai == 0) {
      isEditing = true;
    }

    // Reset state
    isPreparerInitialed = item?.nguoiLapPhieuKyNhay ?? false;
    isRequireManagerApproval = item?.quanTrongCanXacNhan ?? false;
    isDeputyConfirmed = item?.phoPhongXacNhan ?? false;
    proposingUnit = item?.tenDonViDeNghi;
    selectedFileName = item?.tenFile;
    selectedFilePath = item?.duongDanFile;
    validationErrors.clear();
    controllersInitialized = false;
    isUploading = false;
    isRefreshing = false;

    // Update staff data
    listNhanVien = provider.listNhanVien;
    listPhongBan = provider.listPhongBan;

    // Re-initialize dropdown items
    _initializeDropdownItems();
  }

  Future<void> saveAssetTransfer(BuildContext context) async {
    if (!isEditing) return;

    // Validate form first
    if (!validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vui lòng điền đầy đủ thông tin bắt buộc'), backgroundColor: Colors.red));
      return;
    }

    try {
      final currentDocumentName = controllerDocumentName.text;
      final currentSubject = controllerSubject.text;
      final currentDeliveringUnit = controllerDeliveringUnit.text;
      final currentReceivingUnit = controllerReceivingUnit.text;
      final currentRequester = controllerRequester.text;
      final currentDepartmentApproval = controllerDepartmentApproval.text;
      final currentEffectiveDate = controllerEffectiveDate.text;
      final currentEffectiveDateTo = controllerEffectiveDateTo.text;
      final currentApprover = controllerApprover.text;
      final currentDeliveryLocation = controllerDeliveryLocation.text;

      // Create an AssetTransferDto with the form data
      final AssetTransferDto savedItem = AssetTransferDto(
        id: '',
        tenPhieu: controllerDocumentName.text,
        soQuyetDinh: '',
        idDonViGiao: '',
        idDonViNhan: '',
        idDonViDeNghi: '',
        idPhongBanXemPhieu: '',
        idNguoiDeNghi: '',
        idTrinhDuyetCapPhong: '',
        idTrinhDuyetGiamDoc: '',
        idNhanSuXemPhieu: '',
        nguoiLapPhieuKyNhay: false,
        quanTrongCanXacNhan: false,
        phoPhongXacNhan: false,
        tggnTuNgay: '',
        tggnDenNgay: '',
        diaDiemGiaoNhan: '',
        veViec: '',
        canCu: '',
        dieu1: '',
        dieu2: '',
        dieu3: '',
        noiNhan: '',
        themDongTrong: '',
        trangThai: 0,
        idCongTy: '',
        ngayTao: '',
        ngayCapNhat: '',
        nguoiTao: '',
        nguoiCapNhat: '',
        coHieuLuc: false,
        loai: 0,
        isActive: false,
        active: true,
      );

      final provider = Provider.of<AssetTransferProvider>(context, listen: false);

      if (item == null) {
        // await provider.createAssetTransfer(savedItem);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tạo phiếu điều chuyển thành công'), backgroundColor: Colors.green));
      } else {
        await provider.updateAssetTransfer(savedItem);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cập nhật phiếu điều chuyển thành công'), backgroundColor: Colors.green));
        }
      }

      // provider.onChangeScreen(item: null, isMainScreen: true, isEdit: false);
    } catch (e) {
      SGLog.error('AssetTransferController', 'Error saving asset transfer: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: ${e.toString()}'), backgroundColor: Colors.red));
      }
    } finally {
      if (context.mounted) {
        isUploading = false;
      }
    }
  }

  // Clean up resources
  void dispose() {
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
    controllerReason.dispose();
    controllerBase.dispose();
    controllerArticle1.dispose();
    controllerArticle2.dispose();
    controllerArticle3.dispose();
    controllerDestination.dispose();

    for (final controller in contractTermsControllers.values) {
      controller.dispose();
    }
  }
}
