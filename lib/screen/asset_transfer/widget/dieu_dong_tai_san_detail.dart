// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/input/common_checkbox_input.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_date.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/common/widgets/document_upload_widget.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/core/utils/uuid_generator.dart';
import 'package:quan_ly_tai_san_app/screen/Category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/Category/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/Category/staff/staf_provider.dart/nhan_vien_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/asset_transfer_movement_table.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/config_view_asset_transfer.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/dieu_dong_tai_san_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/request/lenh_dieu_dong_request.dart';
import 'package:se_gay_components/common/sg_indicator.dart';
import 'package:se_gay_components/common/sg_text.dart';

import '../bloc/dieu_dong_tai_san_bloc.dart';
import '../bloc/dieu_dong_tai_san_event.dart';
import '../bloc/dieu_dong_tai_san_state.dart';

class DieuDongTaiSanDetail extends StatefulWidget {
  final bool isEditing;
  final bool? isNew;
  final DieuDongTaiSanProvider provider;

  const DieuDongTaiSanDetail({
    super.key,
    this.isEditing = false,
    this.isNew = false,
    required this.provider,
  });

  @override
  State<DieuDongTaiSanDetail> createState() => _DieuDongTaiSanDetailState();
}

final GlobalKey<_DieuDongTaiSanDetailState> dieuDongTaiSanDetailKey =
    GlobalKey<_DieuDongTaiSanDetailState>();

class _DieuDongTaiSanDetailState extends State<DieuDongTaiSanDetail> {
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
  Uint8List? _selectedFileBytes;
  String idCongTy = 'CT001';
  int typeTransfer = 1;
  List<ChiTietDieuDongTaiSan> listNewDetails = [];

  late DieuDongTaiSanDto? item;

  final Map<String, TextEditingController> contractTermsControllers = {};

  final List<DieuDongTaiSanDto> listAssetHandover = [];

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
    if (widget.isNew == true) {
      onReload();
    }

    // Initialize controllers with existing values if available (only once)

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   nhanVienProvider = Provider.of<NhanVienProvider>(context, listen: false);
    //   final nhanViens = await nhanVienProvider.fetchNhanViens(); // Lấy list
    //   setState(() {
    //     itemsRequester =
    //         nhanViens
    //             .map(
    //               (user) => DropdownMenuItem<String>(
    //                 value: user.id ?? '',
    //                 child: Text(user.hoTen ?? ''),
    //               ),
    //             )
    //             .toList();
    //   });
    // });
  }

  @override
  void didUpdateWidget(DieuDongTaiSanDetail oldWidget) {
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

  // Method để làm mới widget
  void _refreshWidget() {
    setState(() {
      listNewDetails.clear();
      // Reset item từ provider
      item = widget.provider.item;
      log('message item: $item');
      isNew = item == null;

      // Reset editing state
      isEditing = widget.isEditing;
      if (item != null && item!.trangThai == 0) {
        isEditing = true;
      }

      if (item != null) {
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
        isPreparerInitialed = item?.nguoiLapPhieuKyNhay ?? false;
        isRequireManagerApproval = item?.quanTrongCanXacNhan ?? false;
        isDeputyConfirmed = item?.phoPhongXacNhan ?? false;
        proposingUnit = item?.tenDonViDeNghi;

        _controllersInitialized = true;
      } else {
        controllerSoChungTu.text = UUIDGenerator.generateWithFormat(
          'SCT************',
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

        _controllersInitialized = false;
        _selectedFileName = null;
        _selectedFilePath = null;
        isPreparerInitialed = false;
        isRequireManagerApproval = false;
        isDeputyConfirmed = false;
        log('controllerEffectiveDateTo: ${controllerSoChungTu.text}');
      }

      if (proposingUnit != null &&
          proposingUnit!.isNotEmpty &&
          !_controllersInitialized) {
        controllerProposingUnit.text = proposingUnit!;
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
    });
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
    _controllersInitialized = false;

    super.dispose();
  }

  void findPhongBan(String? value) {
    log('message');
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
        BlocListener<DieuDongTaiSanBloc, DieuDongTaiSanState>(
          listener: (context, state) {
            if (state is GetListDieuDongTaiSanSuccessState) {
              // Handle successful data loading
              listAssetHandover.clear();
              listAssetHandover.addAll(state.data);
              log('Asset handover data loaded successfully');
            } else if (state is GetListDieuDongTaiSanFailedState) {
            } else if (state is DieuDongTaiSanLoadingState) {
              // Show loading indicator
              setState(() {
                _isUploading = true;
              });
            } else if (state is DieuDongTaiSanLoadingDismissState) {
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
            if (isEditing)
              Row(
                children: [
                  MaterialTextButton(
                    text: 'Lưu',
                    icon: Icons.save,
                    backgroundColor: ColorValue.success,
                    foregroundColor: Colors.white,
                    onPressed: () {
                      _saveAssetTransfer(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  MaterialTextButton(
                    text: 'Hủy',
                    icon: Icons.cancel,
                    backgroundColor: ColorValue.error,
                    foregroundColor: Colors.white,
                    onPressed: () {
                      // Confirm before canceling if there are changes
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text('Xác nhận hủy'),
                              content: Text(
                                'Bạn có chắc chắn muốn hủy? Các thay đổi chưa được lưu sẽ bị mất.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.pop(
                                        context,
                                      ), // Close dialog
                                  child: Text('Không'),
                                ),
                                TextButton(
                                  onPressed: () {
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
              steps: [
                'Nháp',
                'Chờ xác nhận',
                'Xác nhận',
                'Trình duyệt',
                'Duyệt',
                'Hủy',
                'Hoàn thành',
              ],
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

                        CmFormDropdownObject<PhongBan>(
                          label: 'at.delivering_unit'.tr,
                          controller: controllerDeliveringUnit,
                          isEditing: isEditing,
                          items: widget.provider.itemsDDPhongBan,
                          defaultValue:
                              controllerDeliveringUnit.text.isNotEmpty
                                  ? widget.provider.getPhongBanByID(
                                    controllerDeliveringUnit.text,
                                  )
                                  : null,
                          fieldName: 'delivering_unit',
                          validationErrors: _validationErrors,
                          onChanged: (value) {
                            log('delivering_unit selected: $value');
                          },
                        ),
                        CmFormDropdownObject<PhongBan>(
                          label: 'at.receiving_unit'.tr,
                          controller: controllerReceivingUnit,
                          isEditing: isEditing,

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
                          },
                        ),
                        CmFormDropdownObject<NhanVien>(
                          label: 'at.requester'.tr,
                          controller: controllerRequester,
                          isEditing: isEditing,

                          items: widget.provider.itemsDDNhanVien,
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
                              controllerProposingUnit.text =
                                  widget.provider
                                      .getPhongBanByID(value.phongBanId ?? '')
                                      .tenPhongBan ??
                                  '';
                            });
                          },
                        ),
                        CommonCheckboxInput(
                          label: 'at.preparer_initialed'.tr,
                          value: isPreparerInitialed,
                          isEditing: isEditing,
                          isDisabled: false,
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
                          isDisabled: false,
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
                            isDisabled: false,
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
                      ],
                    ),
                  ),

                  Expanded(
                    child: Column(
                      children: [
                        CmFormDropdownObject<NhanVien>(
                          label: 'at.department_approval'.tr,
                          controller: controllerDepartmentApproval,
                          isEditing: isEditing,

                          items: widget.provider.itemsDDNhanVien,
                          defaultValue:
                              controllerDepartmentApproval.text.isNotEmpty
                                  ? widget.provider.getNhanVienByID(
                                    controllerDepartmentApproval.text,
                                  )
                                  : null,
                          fieldName: 'departmentApproval',
                          validationErrors: _validationErrors,
                          onChanged: (value) {
                            log('department_approval selected: $value');
                          },
                        ),
                        CmFormDate(
                          label: 'at.effective_date'.tr,
                          controller: controllerEffectiveDate,
                          isEditing: isEditing,
                          onChanged: (value) {
                            log('Effective date selected: $value');
                          },
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
                          onChanged: (value) {
                            log('Effective date selected: $value');
                          },
                          value:
                              controllerEffectiveDateTo.text.isNotEmpty
                                  ? AppUtility.parseFlexibleDateTime(
                                    controllerEffectiveDateTo.text,
                                  )
                                  : DateTime.now(),
                        ),
                        // CommonFormInput(
                        //   label: 'at.effective_date_to'.tr,
                        //   controller: controllerEffectiveDateTo,
                        //   isEditing: isEditing,
                        //   textContent: item?.tggnDenNgay ?? '',
                        //   fieldName: 'effectiveDateTo',
                        //   validationErrors: _validationErrors,
                        // ),
                        CmFormDropdownObject<NhanVien>(
                          label: 'at.approver'.tr,
                          controller: controllerApprover,
                          isEditing: isEditing,

                          items: widget.provider.itemsDDNhanVien,
                          defaultValue:
                              controllerApprover.text.isNotEmpty
                                  ? widget.provider.getNhanVienByID(
                                    controllerApprover.text,
                                  )
                                  : null,
                          fieldName: 'approver',
                          validationErrors: _validationErrors,
                          onChanged: (value) {
                            log('Approver selected: $value');
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

                    if (_validationErrors.containsKey('document')) {
                      _validationErrors.remove('document');
                    }
                  });
                },
                onUpload: _uploadWordDocument,
                isUploading: _isUploading,
                label: 'Tài liệu Quyết định',
                errorMessage: 'Tài liệu quyết định là bắt buộc',
                hintText: 'Định dạng hỗ trợ: .pdf, .docx (Microsoft Word)',
                allowedExtensions: ['pdf', 'docx'],
              ),

              // const SizedBox(height: 20),
              AssetTransferMovementTable(
                context,
                isEditing: true,
                initialDetails: item?.chiTietDieuDongTaiSans ?? [],
                allAssets: widget.provider.dataAsset ?? [],
                onDataChanged: (data) {
                  listNewDetails =
                      data
                          .map(
                            (e) => ChiTietDieuDongTaiSan(
                              id: UUIDGenerator.generateWithFormat('CTDD****'),
                              idDieuDongTaiSan: controllerSubject.text,
                              soQuyetDinh: item?.soQuyetDinh ?? '',
                              tenPhieu: controllerDocumentName.text,
                              idTaiSan: e.id ?? '',
                              tenTaiSan: e.tenTaiSan ?? '',
                              donViTinh: e.donViTinh ?? '',
                              hienTrang: e.hienTrang ?? 0,
                              soLuong: e.soLuong ?? 0,
                              ghiChu: e.ghiChu ?? '',
                              ngayTao: e.ngayTao ?? '',
                              ngayCapNhat: e.ngayCapNhat ?? '',
                              nguoiTao: item?.nguoiTao ?? '',
                              nguoiCapNhat: item?.nguoiCapNhat ?? '',
                              isActive: true,
                            ),
                          )
                          .toList();

                  log('listNewDetails: ${listNewDetails.length}');
                  log('listNewDetails data: ${jsonEncode(listNewDetails)}');
                },
              ),

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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tệp "$_selectedFileName" đã được tải lên thành công'),
          backgroundColor: Colors.green.shade600,
        ),
      );
    } catch (e) {
      log('Error uploading file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi tải lên tệp: ${e.toString()}'),
          backgroundColor: Colors.red.shade600,
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _saveAssetTransfer(BuildContext context) async {
    if (!isEditing) return;

    // Validate form first
    if (!_validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin bắt buộc'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

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
      final proposingUnit = controllerProposingUnit.text;

      // Create an AssetTransferDto with the form data
      final DieuDongTaiSanDto savedItem = DieuDongTaiSanDto(
        id: item?.id,
        // Keep original ID if editing an existing item
        tenPhieu: currentDocumentName,
        trichYeu: currentSubject,
        idDonViGiao: currentDeliveringUnit,
        idDonViNhan: currentReceivingUnit,
        idNguoiDeNghi: currentRequester,
        nguoiLapPhieuKyNhay: isPreparerInitialed,
        quanTrongCanXacNhan: isRequireManagerApproval,
        phoPhongXacNhan: isDeputyConfirmed,
        idTrinhDuyetCapPhong: currentDepartmentApproval,
        tggnTuNgay: ConfigViewAT.convertStringToIso(currentEffectiveDate),
        tggnDenNgay: ConfigViewAT.convertStringToIso(currentEffectiveDateTo),
        idTrinhDuyetGiamDoc: currentApprover,
        trangThai: item?.trangThai ?? 1,
        diaDiemGiaoNhan: currentDeliveryLocation,
        // Include document file information
        duongDanFile: _selectedFilePath,
        tenFile: _selectedFileName,
        idDonViDeNghi: proposingUnit,
      );

      final provider = Provider.of<DieuDongTaiSanProvider>(
        context,
        listen: false,
      );

      if (item == null) {
        await provider.createDieuDongTaiSan(savedItem);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tạo phiếu điều chuyển thành công'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        provider.updateItem(savedItem);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cập nhật phiếu điều chuyển thành công'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      log('Error saving asset transfer: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
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
      final assetHandoverBloc = BlocProvider.of<DieuDongTaiSanBloc>(context);
      assetHandoverBloc.add(
        GetListDieuDongTaiSanEvent(context, typeTransfer, idCongTy),
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

  Widget previewDocumentAssetTransfer(DieuDongTaiSanDto? item) {
    return InkWell(
      onTap: () {
        // showDialog(
        //   context: context,
        //   barrierDismissible: true,
        //   builder:
        //       (context) => CommonContract(
        //     contractType: ContractPage.assetMovePage(item!),
        //     signatureList: [
        //       "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTe8wBK0d0QukghPwb_8QvKjEzjtEjIszRwbA&s",
        //     ],
        //   ),
        // );
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

  LenhDieuDongRequest _createDieuDongRequest() {
    return LenhDieuDongRequest(
      soQuyetDinh: controllerSoChungTu.text,
      tenPhieu: controllerDocumentName.text,
      idDonViGiao: controllerDeliveringUnit.text,
      idDonViNhan: controllerReceivingUnit.text,
      idNguoiDeNghi: controllerRequester.text,
      nguoiLapPhieuKyNhay: isPreparerInitialed,
      quanTrongCanXacNhan: isRequireManagerApproval,
      phoPhongXacNhan: isDeputyConfirmed,
      idDonViDeNghi: proposingUnit ?? '',
      idTrinhDuyetCapPhong: controllerDepartmentApproval.text,
      tggnTuNgay: ConfigViewAT.convertStringToIso(controllerEffectiveDate.text),
      tggnDenNgay: ConfigViewAT.convertStringToIso(
        controllerEffectiveDateTo.text,
      ),
      idTrinhDuyetGiamDoc: controllerApprover.text,
      diaDiemGiaoNhan: controllerDeliveryLocation.text,
      idPhongBanXemPhieu: controllerDepartmentApproval.text,
      idNhanSuXemPhieu: controllerApprover.text,
      veViec: controllerSubject.text,
      canCu: controllerSubject.text,
      dieu1: controllerSubject.text,
      dieu2: controllerSubject.text,
      dieu3: controllerSubject.text,
      noiNhan: controllerSubject.text,
      themDongTrong: controllerSubject.text,
      trangThai: 1,
      idCongTy: idCongTy,
      ngayTao: DateTime.now().toString(),
      ngayCapNhat: DateTime.now().toString(),
      nguoiTao: '',
      nguoiCapNhat: '',
      coHieuLuc: true,
      loai: 1,
      isActive: true,
      duongDanFile: _selectedFilePath ?? '',
      tenFile: _selectedFileName ?? '',
    );
  }
}
