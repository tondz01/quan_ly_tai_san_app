// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/common/input/common_checkbox_input.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_date.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/common/page/common_contract.dart';
import 'package:quan_ly_tai_san_app/common/page/contract_page.dart';
import 'package:quan_ly_tai_san_app/common/widgets/document_upload_widget.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/providers.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/core/utils/uuid_generator.dart';
import 'package:quan_ly_tai_san_app/screen/Category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/Category/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/asset_transfer_movement_table.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/config_view_asset_transfer.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/dieu_dong_tai_san_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/request/chi_tiet_dieu_dong_request.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/request/lenh_dieu_dong_request.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:se_gay_components/common/sg_indicator.dart';
import 'package:se_gay_components/common/sg_text.dart';

import '../bloc/dieu_dong_tai_san_bloc.dart';
import '../bloc/dieu_dong_tai_san_event.dart';
import '../bloc/dieu_dong_tai_san_state.dart';

class DieuDongTaiSanDetail extends StatefulWidget {
  final bool isEditing;
  final bool? isNew;
  final DieuDongTaiSanProvider provider;
  final int type;

  const DieuDongTaiSanDetail({
    super.key,
    this.isEditing = false,
    this.isNew = false,
    required this.provider,
    required this.type,
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

  PhongBan? donViGiao;
  PhongBan? donViNhan;
  PhongBan? donViDeNghi;
  NhanVien? nguoiDeNghi;
  UserInfoDTO? nguoiLapPhieu;
  NhanVien? nguoiKyCapPhong;
  NhanVien? nguoiKyGiamDoc;

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
      nguoiLapPhieu = widget.provider.userInfo;
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
                      _handleSave();
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
                            donViGiao = value;
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
                            donViNhan = value;
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
                              donViDeNghi = widget.provider.getPhongBanByID(
                                value.phongBanId ?? '',
                              );
                              controllerProposingUnit.text =
                                  donViDeNghi?.tenPhongBan ?? '';
                              nguoiDeNghi = value;
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
                            nguoiKyCapPhong = value;
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
                            nguoiKyGiamDoc = value;
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
                // onUpload: _uploadWordDocument,
                isUploading: _isUploading,
                label: 'Tài liệu Quyết định',
                errorMessage: 'Tài liệu quyết định là bắt buộc',
                hintText: 'Định dạng hỗ trợ: .pdf, .docx (Microsoft Word)',
                allowedExtensions: ['pdf', 'docx'],
              ),

              // const SizedBox(height: 20),
              AssetTransferMovementTable(
                context,
                isEditing: isEditing,
                initialDetails: item?.chiTietDieuDongTaiSans ?? [],
                allAssets: widget.provider.dataAsset ?? [],
                onDataChanged: (data) {
                  listNewDetails =
                      data
                          .map(
                            (e) => ChiTietDieuDongTaiSan(
                              id: UUIDGenerator.generateWithFormat('CTDD-****'),
                              idDieuDongTaiSan: controllerSoChungTu.text,
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
                              nguoiTao: widget.provider.userInfo?.id ?? '',
                              nguoiCapNhat: widget.provider.userInfo?.id ?? '',
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
        if (item == null) return;

        showDialog(
          context: context,
          barrierDismissible: true,
          builder:
              (context) => CommonContract(
                contractType: ContractPage.assetMovePage(item),
                signatureList: [
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTe8wBK0d0QukghPwb_8QvKjEzjtEjIszRwbA&s",
                ],
              ),
        );
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

  LenhDieuDongRequest _createDieuDongRequest(int type, int state) {
    return LenhDieuDongRequest(
      id: controllerSoChungTu.text,
      soQuyetDinh: controllerSoChungTu.text,
      tenPhieu: controllerDocumentName.text,
      idDonViGiao: donViGiao?.id ?? '',
      idDonViNhan: donViNhan?.id ?? '',
      idNguoiDeNghi: nguoiDeNghi?.id ?? '',
      nguoiLapPhieuKyNhay: isPreparerInitialed,
      quanTrongCanXacNhan: isRequireManagerApproval,
      phoPhongXacNhan: isDeputyConfirmed,
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
      veViec: '',
      canCu: '',
      dieu1: '',
      dieu2: '',
      dieu3: '',
      noiNhan: '',
      themDongTrong: '',
      trangThai: state,
      idCongTy: widget.provider.userInfo?.idCongTy ?? '',
      ngayTao: DateTime.now().toIso8601String(),
      ngayCapNhat: DateTime.now().toIso8601String(),
      nguoiTao: widget.provider.userInfo?.id ?? '',
      nguoiCapNhat: widget.provider.userInfo?.id ?? '',
      coHieuLuc: true,
      loai: type,
      isActive: true,
      trichYeu: controllerSubject.text,
      duongDanFile: _selectedFilePath ?? '',
      tenFile: _selectedFileName ?? '',
      ngayKy: DateTime.now().toIso8601String(),
    );

  }

  List<ChiTietDieuDongRequest> _createDieuDongRequestDetail() {
    log('listNewDetails: ${jsonEncode(listNewDetails)}');
    return listNewDetails
        .map((e) => ChiTietDieuDongRequest(
          id: e.id,
          idDieuDongTaiSan: e.idDieuDongTaiSan ,
          idTaiSan: e.idTaiSan,
          soLuong: e.soLuong,
          ghiChu: e.ghiChu,
          ngayTao: e.ngayTao,
          ngayCapNhat: e.ngayCapNhat,
          nguoiTao: widget.provider.userInfo?.id ?? '',
          nguoiCapNhat: widget.provider.userInfo?.id ?? '',
          isActive: true,
        ))
        .toList();
  }

  void _handleSave() {
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
    // final bloc = context.read<DieuDongTaiSanBloc>();
    if (item == null) {
      final request = _createDieuDongRequest(widget.type, 1);
      final requestDetail = _createDieuDongRequestDetail();
      log('message request: ${jsonEncode(request)}');
      log('message requestDetail: ${jsonEncode(requestDetail)}');
      // bloc.add(CreateDieuDongEvent(context, request));
      widget.provider.saveAssetTransfer(
        context,
        request,
        requestDetail,
        _selectedFileName ?? '',
        _selectedFilePath ?? '',
        _selectedFileBytes ?? Uint8List(0),
      );
    } else {
      final request = _createDieuDongRequest(widget.type, item!.trangThai ?? 0);
      final requestDetail = _createDieuDongRequestDetail();
      log('message requestDetail: ${jsonEncode(requestDetail)}');
      log('message request: ${jsonEncode(request)}');
      // bloc.add(UpdateDieuDongEvent(context, request));
    }
  }
}
