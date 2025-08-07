import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/common/input/common_checkbox_input.dart';
import 'package:quan_ly_tai_san_app/common/web_view/web_view_common.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/asset_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/asset_transfer_provider.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/nhan_vien.dart';
import 'package:se_gay_components/common/sg_indicator.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/common/widgets/document_upload_widget.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/models/department.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class AssetTransferDetail extends StatefulWidget {
  final bool isEditing;
  final bool? isNew;
  final AssetTransferProvider provider;

  const AssetTransferDetail({super.key, this.isEditing = false, this.isNew = false, required this.provider});

  @override
  State<AssetTransferDetail> createState() => _AssetTransferDetailState();
}

// GlobalKey để truy cập widget từ bên ngoài
final assetTransferDetailKey = GlobalKey<_AssetTransferDetailState>();

class _AssetTransferDetailState extends State<AssetTransferDetail> {
  String url =
      'https://firebasestorage.googleapis.com/v0/b/shopifyappdata.appspot.com/o/document%2FB%C3%A0n%20giao%20t%C3%A0i%20s%E1%BA%A3n.pdf?alt=media&token=497ba34e-891b-45b0-b228-704ca958760b';

  late TextEditingController controllerSubject = TextEditingController();
  late TextEditingController controllerDocumentName = TextEditingController();
  late TextEditingController controllerDeliveringUnit = TextEditingController();
  late TextEditingController controllerReceivingUnit = TextEditingController();
  late TextEditingController controllerRequester = TextEditingController();
  late TextEditingController controllerProposingUnit = TextEditingController();
  late TextEditingController controllerQuantity = TextEditingController();
  late TextEditingController controllerDepartmentApproval = TextEditingController();
  late TextEditingController controllerEffectiveDate = TextEditingController();
  late TextEditingController controllerEffectiveDateTo = TextEditingController();
  late TextEditingController controllerApprover = TextEditingController();
  late TextEditingController controllerDeliveryLocation = TextEditingController();
  late TextEditingController controllerViewerDepartments = TextEditingController();
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
  bool _isUploading = false;
  bool isRefreshing = false;
  bool isNew = false;

  String? proposingUnit;
  bool _controllersInitialized = false;
  String? _selectedFileName;
  String? _selectedFilePath;

  late AssetTransferDto? item;

  final Map<String, TextEditingController> contractTermsControllers = {};

  final List<AssetHandoverDto> listAssetHandover = [];
  List<NhanVien> listNhanVien = [];
  List<PhongBan> listPhongBan = [];

  Map<String, bool> _validationErrors = {};

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

    // Check movement details
    // if (item?.movementDetails == null ||
    //     (item?.movementDetails?.isEmpty ?? true)) {
    //   newValidationErrors['movementDetails'] = true;
    // }

    // Only update state if validation errors have changed
    bool hasChanges = !mapEquals(_validationErrors, newValidationErrors);
    if (hasChanges) {
      setState(() {
        _validationErrors = newValidationErrors;
      });
    }

    return newValidationErrors.isEmpty;
  }

  @override
  void initState() {
    super.initState();
    item = widget.provider.item;
    _callGetListAssetHandover();
    isEditing = widget.isEditing;

    if (item != null && item!.trangThai == 0) {
      isEditing = true;
    }
    if (widget.isNew == true) {
      onReload();
    }

    // Initialize controllers with existing values if available (only once)
    if (item != null && !_controllersInitialized) {
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

      // Initialize selected file if available
      _selectedFileName = item?.tenFile;
      _selectedFilePath = item?.duongDanFile;
      isPreparerInitialed = item?.nguoiLapPhieuKyNhay ?? false;
      isRequireManagerApproval = item?.quanTrongCanXacNhan ?? false;
      isDeputyConfirmed = item?.phoPhongXacNhan ?? false;
      proposingUnit = item?.tenDonViDeNghi;

      _controllersInitialized = true;
    } else if (item == null && !_controllersInitialized) {
      // Initialize controllers for new items (empty strings)
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

      _controllersInitialized = false;
      _selectedFileName = null;
      _selectedFilePath = null;
      isPreparerInitialed = false;
      isRequireManagerApproval = false;
      isDeputyConfirmed = false;
    }

    if (proposingUnit != null && proposingUnit!.isNotEmpty && !_controllersInitialized) {
      controllerProposingUnit.text = proposingUnit!;
    }

    listNhanVien = widget.provider.listNhanVien;
    listPhongBan = widget.provider.listPhongBan;

    itemsDepartmentManager =
        listPhongBan
            .map(
              (phongBan) => DropdownMenuItem<String>(value: phongBan.id ?? '', child: Text(phongBan.tenPhongBan ?? '')),
            )
            .toList();

    itemsRequester =
        listNhanVien
            .map((nhanVien) => DropdownMenuItem<String>(value: nhanVien.id ?? '', child: Text(nhanVien.hoTen ?? '')))
            .toList();
    itemsDepartmentApproval =
        listNhanVien
            .map((nhanVien) => DropdownMenuItem<String>(value: nhanVien.id ?? '', child: Text(nhanVien.hoTen ?? '')))
            .toList();
    itemsApprover =
        listNhanVien
            .map((nhanVien) => DropdownMenuItem<String>(value: nhanVien.id ?? '', child: Text(nhanVien.hoTen ?? '')))
            .toList();
  }

  @override
  void didUpdateWidget(AssetTransferDetail oldWidget) {
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

    // Kiểm tra nếu listNhanVien thay đổi
    if (widget.provider.listNhanVien != oldWidget.provider.listNhanVien) {
      setState(() {
        listNhanVien = widget.provider.listNhanVien;
        listPhongBan = widget.provider.listPhongBan;

        itemsDepartmentManager =
            listPhongBan
                .map(
                  (phongBan) =>
                      DropdownMenuItem<String>(value: phongBan.id ?? '', child: Text(phongBan.tenPhongBan ?? '')),
                )
                .toList();

        itemsRequester =
            listNhanVien
                .map(
                  (nhanVien) => DropdownMenuItem<String>(value: nhanVien.id ?? '', child: Text(nhanVien.hoTen ?? '')),
                )
                .toList();
        itemsDepartmentApproval =
            listNhanVien
                .map(
                  (nhanVien) => DropdownMenuItem<String>(value: nhanVien.id ?? '', child: Text(nhanVien.hoTen ?? '')),
                )
                .toList();
        itemsApprover =
            listNhanVien
                .map(
                  (nhanVien) => DropdownMenuItem<String>(value: nhanVien.id ?? '', child: Text(nhanVien.hoTen ?? '')),
                )
                .toList();
      });
    }
  }

  // Method để làm mới widget
  void _refreshWidget() {
    SGLog.info("AssetTransferDetail", ' _refreshWidget');
    setState(() {
      // Reset item từ provider
      item = widget.provider.item;
      SGLog.debug("AssetTransferDetail", ' message item: $item');
      isNew = item == null;

      // Reset editing state
      isEditing = widget.isEditing;
      if (item != null && item!.trangThai == 0) {
        isEditing = true;
      }

      // Reset các biến trạng thái
      isPreparerInitialed = item?.nguoiLapPhieuKyNhay ?? false;
      isRequireManagerApproval = item?.quanTrongCanXacNhan ?? false;
      isDeputyConfirmed = item?.phoPhongXacNhan ?? false;
      proposingUnit = item?.tenDonViDeNghi;

      // Reset file upload
      _selectedFileName = item?.tenFile;
      _selectedFilePath = item?.duongDanFile;

      _validationErrors.clear();

      _controllersInitialized = false;

      _isUploading = false;
      isRefreshing = false;

      // Refresh staff data
      listNhanVien = widget.provider.listNhanVien;
      listPhongBan = widget.provider.listPhongBan;

      itemsDepartmentManager =
          listPhongBan
              .map(
                (phongBan) =>
                    DropdownMenuItem<String>(value: phongBan.id ?? '', child: Text(phongBan.tenPhongBan ?? '')),
              )
              .toList();

      itemsRequester =
          listNhanVien
              .map((nhanVien) => DropdownMenuItem<String>(value: nhanVien.id ?? '', child: Text(nhanVien.hoTen ?? '')))
              .toList();
      itemsDepartmentApproval =
          listNhanVien
              .map((nhanVien) => DropdownMenuItem<String>(value: nhanVien.id ?? '', child: Text(nhanVien.hoTen ?? '')))
              .toList();
      itemsApprover =
          listNhanVien
              .map((nhanVien) => DropdownMenuItem<String>(value: nhanVien.id ?? '', child: Text(nhanVien.hoTen ?? '')))
              .toList();
    });
  }

  late List<DropdownMenuItem<String>> itemsRequester;
  late List<DropdownMenuItem<String>> itemsDepartmentApproval;
  late List<DropdownMenuItem<String>> itemsApprover;
  late List<DropdownMenuItem<String>> itemsDepartmentManager;

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
    _controllersInitialized = false;

    super.dispose();
  }

  void findPhongBan(String? value) {
    SGLog.debug("AssetTransferDetail", ' message');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    SGLog.debug("AssetTransferDetail", ' screenWidth: $screenWidth');

    _checkAndRefreshWidget();

    if (item == null && !isRefreshing) {
      SGLog.debug("AssetTransferDetail", ' item == null');
      onReload();
      isEditing = true;
      isRefreshing = true;
    }

    return MultiBlocListener(
      listeners: [
        // Lắng nghe từ AssetHandoverBloc
        BlocListener<AssetHandoverBloc, AssetHandoverState>(
          listener: (context, state) {
            if (state is GetListAssetHandoverSuccessState) {
              // Handle successful data loading
              listAssetHandover.clear();
              listAssetHandover.addAll(state.data);
              SGLog.debug("AssetTransferDetail", ' Asset handover data loaded successfully');
            } else if (state is GetListAssetHandoverFailedState) {
            } else if (state is AssetHandoverLoadingState) {
              // Show loading indicator
              setState(() {
                _isUploading = true;
              });
            } else if (state is AssetHandoverLoadingDismissState) {
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
        child: Padding(padding: const EdgeInsets.only(top: 10.0), child: _buildTableDetail()),
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
            if (isEditing)
              Row(
                children: [
                  MaterialTextButton(
                    text: 'Lưu',
                    icon: Icons.save,
                    backgroundColor: ColorValue.success,
                    foregroundColor: Colors.white,
                    onPressed: () {
                      // _saveAssetTransfer(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  MaterialTextButton(
                    text: 'Hủy',
                    icon: Icons.cancel,
                    backgroundColor: ColorValue.error,
                    foregroundColor: Colors.white,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text('Xác nhận hủy'),
                              content: Text('Bạn có chắc chắn muốn hủy? Các thay đổi chưa được lưu sẽ bị mất.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context), // Close dialog
                                  child: Text('Không'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.read<AssetTransferProvider>().isShowCollapse = false;
                                    context.read<AssetTransferProvider>().isShowInput = false;
                                    Navigator.pop(context); // Close dialog
                                  },
                                  child: Text('Có'),
                                ),
                              ],
                            ),
                      );
                    },
                  ),
                ],
              ),
            const SizedBox(width: 5),
            SgIndicator(
              steps: ['Nháp', 'Chờ xác nhận', 'Xác nhận', 'Trình duyệt', 'Duyệt', 'Từ chối', 'Hủy', 'Hoàn thành'],
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
              CommonFormInput(
                label: 'at.document_name'.tr,
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
              CommonFormInput(
                label: 'at.delivering_unit'.tr,
                controller: controllerDeliveringUnit,
                isEditing: isEditing,
                textContent: item?.tenDonViGiao ?? '',
                fieldName: 'deliveringUnit',
                validationErrors: _validationErrors,
              ),
              CommonFormInput(
                label: 'at.receiving_unit'.tr,
                controller: controllerReceivingUnit,
                isEditing: isEditing,
                textContent: item?.tenDonViNhan ?? '',
                isDropdown: true,
                items: itemsDepartmentManager,
                fieldName: 'receivingUnit',
                validationErrors: _validationErrors,
              ),
              CommonFormInput(
                label: 'at.requester'.tr,
                controller: controllerRequester,
                isEditing: isEditing,
                textContent: item?.tenNguoiDeNghi ?? '',
                isDropdown: true,
                items: itemsRequester,
                onChanged: (value) {
                  SGLog.debug("AssetTransferDetail", 'Requester selected: $value');
                  var selectedUser = listNhanVien.firstWhere((user) => user.id == value);
                  setState(() {
                    proposingUnit = selectedUser.boPhan;
                    controllerRequester.text = selectedUser.hoTen ?? '';
                    SGLog.debug("AssetTransferDetail", ' proposingUnit set to: $proposingUnit');
                  });
                },
                fieldName: 'requester',
                validationErrors: _validationErrors,
              ),
              CommonCheckboxInput(
                label: 'at.preparer_initialed'.tr,
                value: isPreparerInitialed,
                isEditing: isEditing,
                isEnable: false,
                onChanged: (newValue) {
                  setState(() {
                    isPreparerInitialed = newValue;
                  });
                },
              ),
              CommonCheckboxInput(
                label: 'at.require_manager_approval'.tr,
                value: isRequireManagerApproval,
                isEditing: isEditing,
                isEnable: false,
                onChanged: (newValue) {
                  setState(() {
                    isRequireManagerApproval = newValue;
                  });
                },
              ),
              if (isRequireManagerApproval)
                CommonCheckboxInput(
                  label: 'at.deputy_confirmed'.tr,
                  value: isDeputyConfirmed,
                  isEditing: isEditing,
                  isEnable: false,
                  onChanged: (newValue) {
                    setState(() {
                      isDeputyConfirmed = newValue;
                    });
                  },
                ),
              CommonFormInput(
                label: 'at.proposing_unit'.tr,
                controller: controllerProposingUnit,
                isEditing: false,
                textContent: proposingUnit ?? '',
                inputType: TextInputType.number,
                validationErrors: _validationErrors,
              ),
              CommonFormInput(
                label: 'at.department_approval'.tr,
                controller: controllerDepartmentApproval,
                isEditing: isEditing,
                textContent: item?.tenTrinhDuyetCapPhong ?? '',
                fieldName: 'departmentApproval',
                isDropdown: true,
                items: itemsDepartmentApproval,
                onChanged: (value) {
                  SGLog.debug("AssetTransferDetail", ' Department approval selected: $value');
                  var selectedUser = listNhanVien.firstWhere((user) => user.id == value);
                  controllerDepartmentApproval.text = selectedUser.hoTen ?? '';
                },
                validationErrors: _validationErrors,
              ),
              CommonFormInput(
                label: 'at.effective_date'.tr,
                controller: controllerEffectiveDate,
                isEditing: isEditing,
                textContent:
                    isEditing
                        ? AppUtility.formatDateDdMmYyyy(DateTime.now())
                        : item?.tggnTuNgay.toString() ??
                            (isEditing ? AppUtility.formatDateDdMmYyyy(DateTime.now()) : ''),
                fieldName: 'effectiveDate',
                validationErrors: _validationErrors,
              ),
              CommonFormInput(
                label: 'at.effective_date_to'.tr,
                controller: controllerEffectiveDateTo,
                isEditing: isEditing,
                textContent: item?.tggnDenNgay.toString() ?? '',
                fieldName: 'effectiveDateTo',
                validationErrors: _validationErrors,
              ),
              CommonFormInput(
                label: 'at.approver'.tr,
                controller: controllerApprover,
                isEditing: isEditing,
                textContent: item?.tenTrinhDuyetGiamDoc ?? '',
                isDropdown: true,
                items: itemsApprover,
                onChanged: (value) {
                  var selectedUser = listNhanVien.firstWhere((user) => user.id == value);
                  controllerApprover.text = selectedUser.hoTen ?? '';
                },
                fieldName: 'approver',
                validationErrors: _validationErrors,
              ),
              DocumentUploadWidget(
                isEditing: isEditing,
                selectedFileName: _selectedFileName,
                selectedFilePath: _selectedFilePath,
                validationErrors: _validationErrors,
                onFileSelected: (fileName, filePath) {
                  setState(() {
                    _selectedFileName = fileName;
                    _selectedFilePath = filePath;

                    if (_validationErrors.containsKey('document')) {
                      _validationErrors.remove('document');
                    }
                  });
                },
                onUpload: _uploadWordDocument,
                isUploading: _isUploading,
                label: 'Tài liệu Quyết định',
                errorMessage: 'Tài liệu quyết định là bắt buộc',
                hintText: 'Định dạng hỗ trợ: .doc, .docx (Microsoft Word)',
                allowedExtensions: ['doc', 'docx'],
              ),

              // const SizedBox(height: 20),
              // assetTransferMovementTable(
              //   context,
              //   item?.movementDetails ?? [],
              //   isEditing,
              // ),
              SizedBox(height: 10),
              previewDocumentAssetTransfer(item),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _uploadWordDocument() async {
    if (_selectedFilePath == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _validationErrors.remove('document');
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tệp "$_selectedFileName" đã được tải lên thành công'),
            backgroundColor: Colors.green.shade600,
          ),
        );
      }
    } catch (e) {
      SGLog.debug("AssetTransferDetail", ' Error uploading file: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tải lên tệp: ${e.toString()}'), backgroundColor: Colors.red.shade600),
        );
      }
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  // Future<void> _saveAssetTransfer(BuildContext context) async {
  //   if (!isEditing) return;

  //   // Validate form first
  //   if (!_validateForm()) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Vui lòng điền đầy đủ thông tin bắt buộc'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }

  //   setState(() {
  //     _isUploading = true;
  //   });

  //   try {
  //     final currentDocumentName = controllerDocumentName.text;
  //     final currentSubject = controllerSubject.text;
  //     final currentDeliveringUnit = controllerDeliveringUnit.text;
  //     final currentReceivingUnit = controllerReceivingUnit.text;
  //     final currentRequester = controllerRequester.text;
  //     final currentDepartmentApproval = controllerDepartmentApproval.text;
  //     final currentEffectiveDate = controllerEffectiveDate.text;
  //     final currentEffectiveDateTo = controllerEffectiveDateTo.text;
  //     final currentApprover = controllerApprover.text;
  //     final currentDeliveryLocation = controllerDeliveryLocation.text;

  //     // Create an AssetTransferDto with the form data
  //     final AssetTransferDto savedItem = AssetTransferDto(
  //       id: item?.id, // Keep original ID if editing an existing item
  //       documentName: currentDocumentName,
  //       subject: currentSubject,
  //       deliveringUnit: currentDeliveringUnit,
  //       receivingUnit: currentReceivingUnit,
  //       requester: currentRequester,
  //       preparerInitialed: isPreparerInitialed,
  //       requireManagerApproval: isRequireManagerApproval,
  //       deputyConfirmed: isDeputyConfirmed,
  //       departmentApproval: currentDepartmentApproval,
  //       effectiveDate: currentEffectiveDate,
  //       effectiveDateTo: currentEffectiveDateTo,
  //       approver: currentApprover,
  //       status: item?.status ?? 1, // Keep status or set to draft (0)
  //       // Keep the existing movement details or use an empty list
  //       movementDetails: item?.movementDetails ?? [],
  //       deliveryLocation: currentDeliveryLocation,
  //       // Include document file information
  //       documentFilePath: _selectedFilePath,
  //       documentFileName: _selectedFileName,
  //       proposingUnit: proposingUnit,
  //     );

  //     final provider = Provider.of<AssetTransferProvider>(
  //       context,
  //       listen: false,
  //     );

  //     if (item == null) {
  //       await provider.createAssetTransfer(savedItem);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Tạo phiếu điều chuyển thành công'),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //     } else {
  //       await provider.updateAssetTransfer(savedItem);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Cập nhật phiếu điều chuyển thành công'),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //     }

  //     // provider.onChangeScreen(item: null, isMainScreen: true, isEdit: false);
  //   } catch (e) {
  //       SGLog.debug("AssetTransferDetail",' Error saving asset transfer: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Lỗi: ${e.toString()}'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _isUploading = false;
  //       });
  //     }
  //   }
  // }

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
      final assetHandoverBloc = BlocProvider.of<AssetHandoverBloc>(context);
      assetHandoverBloc.add(GetListAssetHandoverEvent(context));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi lấy danh sách: ${e.toString()}'), backgroundColor: Colors.red));
    }
  }

  Widget previewDocumentAssetTransfer(AssetTransferDto? item) {
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
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: ColorValue.link),
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.visibility, color: ColorValue.link, size: 18),
        ],
      ),
    );
  }
}
