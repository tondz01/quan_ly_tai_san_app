// ignore_for_file: deprecated_member_use

import 'dart:async';
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
import 'package:quan_ly_tai_san_app/common/widgets/document_upload_widget.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/core/utils/uuid_generator.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/preview_document_asset_transfer.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/widget/controllers/asset_transfer_controllers.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/widget/state/asset_transfer_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/widget/validation/asset_transfer_validation.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/asset_transfer_movement_table.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/dieu_dong_tai_san_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/request/chi_tiet_dieu_dong_request.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/request/lenh_dieu_dong_request.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/chi_tiet_dieu_dong_tai_san_repository.dart';
import 'package:se_gay_components/common/sg_indicator.dart';

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

// ignore: library_private_types_in_public_api
final GlobalKey<_DieuDongTaiSanDetailState> dieuDongTaiSanDetailKey =
    GlobalKey<_DieuDongTaiSanDetailState>();

class _DieuDongTaiSanDetailState extends State<DieuDongTaiSanDetail> {
  // Sử dụng các class mới
  late AssetTransferControllers controllers = AssetTransferControllers();
  late AssetTransferState state = AssetTransferState();
  late AssetTransferValidation validation = AssetTransferValidation();

  Uint8List? _selectedFileBytes;
  final Map<String, TextEditingController> contractTermsControllers = {};
  final List<DieuDongTaiSanDto> listAssetHandover = [];
  PdfDocument? _document;

  bool _validateForm() {
    return validation.validateForm(
      documentNameController: controllers.controllerDocumentName,
      subjectController: controllers.controllerSubject,
      deliveringUnitController: controllers.controllerDeliveringUnit,
      receivingUnitController: controllers.controllerReceivingUnit,
      effectiveDateController: controllers.controllerEffectiveDate,
      effectiveDateToController: controllers.controllerEffectiveDateTo,
      requesterController: controllers.controllerRequester,
      item: state.item,
      selectedFileName: state.selectedFileName,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadPdf();
    state.item = widget.provider.item;
    state.isEditing = widget.isEditing;
    _refreshWidget();

    // if (state.item != null && state.item!.trangThai == 0) {
    //   state.isEditing = true;
    // }
    if (widget.isNew == true) {
      onReload();
    }
  }

  Future<void> _loadPdf() async {
    final document = await PdfDocument.openAsset('assets/test_01.pdf');
    setState(() {
      _document = document;
    });
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

  late List<DropdownMenuItem<String>> itemsRequester = [];

  @override
  void dispose() {
    controllers.dispose();
    for (final controller in contractTermsControllers.values) {
      controller.dispose();
    }
    state.controllersInitialized = false;
    super.dispose();
  }

  List<Map<String, dynamic>> _normalizeDetails(
    List<ChiTietDieuDongTaiSan> list,
  ) {
    final data =
        list
            .map(
              (d) => {
                'idTaiSan': d.idTaiSan,
                'soLuong': d.soLuong,
                'hienTrang': d.hienTrang,
                'ghiChu': d.ghiChu,
              },
            )
            .toList();
    data.sort(
      (a, b) => (a['idTaiSan'] as String).compareTo(b['idTaiSan'] as String),
    );
    return data;
  }

  bool _detailsChanged() {
    if (state.item == null) return state.listNewDetails.isNotEmpty;
    final beforeJson = jsonEncode(_normalizeDetails(state.initialDetails));
    final afterJson = jsonEncode(_normalizeDetails(state.listNewDetails));
    return beforeJson != afterJson;
  }

  Future<void> _syncDetails(String idDieuDongTaiSan) async {
    try {
      final repo = ChiTietDieuDongTaiSanRepository();
      for (final d in state.initialDetails) {
        if (d.id.isNotEmpty) {
          await repo.delete(d.id);
        }
      }
      for (final d in state.listNewDetails) {
        await repo.create(
          ChiTietDieuDongTaiSan(
            id: d.id,
            idDieuDongTaiSan: idDieuDongTaiSan,
            soQuyetDinh: d.soQuyetDinh,
            tenPhieu: d.tenPhieu,
            idTaiSan: d.idTaiSan,
            tenTaiSan: d.tenTaiSan,
            donViTinh: d.donViTinh,
            hienTrang: d.hienTrang,
            soLuong: d.soLuong,
            ghiChu: d.ghiChu,
            ngayTao: d.ngayTao,
            ngayCapNhat: d.ngayCapNhat,
            nguoiTao: d.nguoiTao,
            nguoiCapNhat: d.nguoiCapNhat,
            isActive: d.isActive,
          ),
        );
      }
    } catch (e) {
      log('Sync details error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkAndRefreshWidget();
    if (state.item == null && !state.isRefreshing) {
      onReload();
      state.isEditing = true;
      state.isRefreshing = true;
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
                this.state.isUploading = true;
              });
            } else if (state is DieuDongTaiSanLoadingDismissState) {
              // Hide loading indicator
              setState(() {
                this.state.isUploading = false;
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
                  visible: state.isEditing,
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
                  visible: state.isEditing,
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
                  visible:
                      state.item != null &&
                      ![0, 5, 6].contains(state.item!.trangThai),
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
                              BlocProvider.of<DieuDongTaiSanBloc>(context);
                          assetHandoverBloc.add(
                            CancelDieuDongTaiSanEvent(
                              context,
                              state.item!.id.toString(),
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
              steps: [
                'Nháp',
                'Chờ xác nhận',
                'Xác nhận',
                'Chờ duyệt',
                'Duyệt',
                'Hủy',
                'Hoàn thành',
              ],
              fontSize: 10,
              currentStep: state.item?.trangThai ?? 0,
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
                          controller: controllers.controllerSoChungTu,
                          isEditing: false,
                          textContent: controllers.controllerSoChungTu.text,
                          fieldName: 'soChungTu',
                          validationErrors: validation.validationErrors,
                        ),
                        CommonFormInput(
                          label: 'at.document_name'.tr,
                          controller: controllers.controllerDocumentName,
                          isEditing: state.isEditing,
                          textContent: state.item?.tenPhieu ?? '',
                          fieldName: 'documentName',
                          validationErrors: validation.validationErrors,
                        ),
                        CommonFormInput(
                          label: 'Trích yêu',
                          controller: controllers.controllerSubject,
                          isEditing: state.isEditing,
                          textContent: state.item?.trichYeu ?? '',
                          fieldName: 'subject',
                          validationErrors: validation.validationErrors,
                        ),

                        CmFormDropdownObject<PhongBan>(
                          label: 'at.delivering_unit'.tr,
                          controller: controllers.controllerDeliveringUnit,
                          isEditing: state.isEditing,
                          value: state.donViGiao,
                          items: widget.provider.itemsDDPhongBan,
                          defaultValue:
                              controllers
                                      .controllerDeliveringUnit
                                      .text
                                      .isNotEmpty
                                  ? widget.provider.getPhongBanByID(
                                    controllers.controllerDeliveringUnit.text,
                                  )
                                  : null,
                          fieldName: 'delivering_unit',
                          validationErrors: validation.validationErrors,
                          onChanged: (value) {
                            log('delivering_unit selected: $value');
                            setState(() {
                              state.donViGiao = value;
                              state.listStaffByDepartment =
                                  widget.provider.dataNhanVien
                                      .where(
                                        (element) =>
                                            element.phongBanId ==
                                            state.donViGiao!.id,
                                      )
                                      .toList();
                            });
                          },
                        ),
                        CmFormDropdownObject<PhongBan>(
                          label: 'at.receiving_unit'.tr,
                          controller: controllers.controllerReceivingUnit,
                          isEditing: state.isEditing,

                          items: widget.provider.itemsDDPhongBan,
                          defaultValue:
                              controllers
                                      .controllerReceivingUnit
                                      .text
                                      .isNotEmpty
                                  ? widget.provider.getPhongBanByID(
                                    controllers.controllerReceivingUnit.text,
                                  )
                                  : null,
                          fieldName: 'receivingUnit',
                          validationErrors: validation.validationErrors,
                          onChanged: (value) {
                            log('receivingUnit selected: $value');
                            state.donViNhan = value;
                          },
                        ),
                        CmFormDropdownObject<NhanVien>(
                          label: 'at.requester'.tr,
                          controller: controllers.controllerRequester,
                          isEditing: state.isEditing,

                          items: widget.provider.itemsDDNhanVien,
                          defaultValue:
                              controllers.controllerRequester.text.isNotEmpty
                                  ? widget.provider.getNhanVienByID(
                                    controllers.controllerRequester.text,
                                  )
                                  : null,
                          fieldName: 'requester',
                          validationErrors: validation.validationErrors,
                          onChanged: (value) {
                            log('requester selected: $value');
                            setState(() {
                              state.donViDeNghi = widget.provider
                                  .getPhongBanByID(value.phongBanId ?? '');
                              controllers.controllerProposingUnit.text =
                                  state.donViDeNghi?.tenPhongBan ?? '';
                              state.nguoiDeNghi = value;
                            });
                          },
                        ),
                        CommonCheckboxInput(
                          label: 'at.preparer_initialed'.tr,
                          value: state.isNguoiLapPhieuKyNhay,
                          isEditing: state.isEditing,
                          isDisabled: !state.isEditing,
                          onChanged: (newValue) {
                            setState(() {
                              state.isNguoiLapPhieuKyNhay = newValue;
                            });
                          },
                        ),
                        CommonCheckboxInput(
                          label: 'at.require_manager_approval'.tr,
                          value: state.isQuanTrongCanXacNhan,
                          isEditing: state.isEditing,
                          isDisabled: !state.isEditing,
                          onChanged: (newValue) {
                            setState(() {
                              log('donViGiao: ${state.donViGiao}');
                              if (state.donViGiao == null) {
                                AppUtility.showSnackBar(
                                  context,
                                  'Vui lòng chọn đơn vị giao trước.',
                                  isError: true,
                                );
                                return;
                              }
                              state.isQuanTrongCanXacNhan = newValue;
                              if (!state.isQuanTrongCanXacNhan) {
                                state.isPhoPhongXacNhan = false;
                              }
                            });
                          },
                        ),
                        Visibility(
                          visible: state.isQuanTrongCanXacNhan,
                          child: CmFormDropdownObject<NhanVien>(
                            label: 'Trưởng phòng xác nhận',
                            controller: controllers.controllerTPDonViGiao,
                            isEditing: state.isEditing,

                            items: [
                              ...state.listStaffByDepartment.map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.hoTen ?? ''),
                                ),
                              ),
                            ],
                            defaultValue:
                                controllers
                                        .controllerTPDonViGiao
                                        .text
                                        .isNotEmpty
                                    ? widget.provider.getNhanVienByID(
                                      controllers.controllerTPDonViGiao.text,
                                    )
                                    : null,
                            fieldName: 'tPDonViGiao',
                            validationErrors: validation.validationErrors,
                            value: state.tPDonViGiao,
                            onChanged: (value) {
                              setState(() {
                                state.tPDonViGiao = value;
                              });
                            },
                          ),
                        ),
                        if (state.isQuanTrongCanXacNhan)
                          CommonCheckboxInput(
                            label: 'at.deputy_confirmed'.tr,
                            value: state.isPhoPhongXacNhan,
                            isEditing: state.isEditing,
                            isDisabled: !state.isEditing,
                            onChanged: (newValue) {
                              setState(() {
                                state.isPhoPhongXacNhan = newValue;
                              });
                            },
                          ),
                        Visibility(
                          visible: state.isPhoPhongXacNhan,
                          child: CmFormDropdownObject<NhanVien>(
                            label: 'Phó phòng xác nhận',
                            controller: controllers.controllerPPDonViNhan,
                            isEditing: state.isEditing,

                            items: [
                              ...state.listStaffByDepartment.map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.hoTen ?? ''),
                                ),
                              ),
                            ],
                            defaultValue:
                                controllers
                                        .controllerPPDonViNhan
                                        .text
                                        .isNotEmpty
                                    ? widget.provider.getNhanVienByID(
                                      controllers.controllerPPDonViNhan.text,
                                    )
                                    : null,
                            fieldName: 'pPDonViNhan',
                            validationErrors: validation.validationErrors,
                            onChanged: (value) {
                              setState(() {
                                state.pPDonViGiao = value;
                              });
                            },
                          ),
                        ),
                        CommonFormInput(
                          label: 'at.proposing_unit'.tr,
                          controller: controllers.controllerProposingUnit,
                          isEditing: false,
                          textContent: state.proposingUnit ?? '',
                          inputType: TextInputType.number,
                          validationErrors: validation.validationErrors,
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Column(
                      children: [
                        CmFormDropdownObject<NhanVien>(
                          label: 'at.department_approval'.tr,
                          controller: controllers.controllerDepartmentApproval,
                          isEditing: state.isEditing,
                          value: state.nguoiKyCapPhong,
                          items: widget.provider.itemsDDNhanVien,
                          defaultValue:
                              controllers
                                      .controllerDepartmentApproval
                                      .text
                                      .isNotEmpty
                                  ? widget.provider.getNhanVienByID(
                                    controllers
                                        .controllerDepartmentApproval
                                        .text,
                                  )
                                  : null,
                          fieldName: 'departmentApproval',
                          validationErrors: validation.validationErrors,
                          onChanged: (value) {
                            log('department_approval selected: $value');
                            state.nguoiKyCapPhong = value;
                          },
                        ),
                        CmFormDate(
                          label: 'at.effective_date'.tr,
                          controller: controllers.controllerEffectiveDate,
                          isEditing: state.isEditing,
                          onChanged: (value) {
                            log('Effective date selected: $value');
                          },
                          value:
                              controllers
                                      .controllerEffectiveDate
                                      .text
                                      .isNotEmpty
                                  ? AppUtility.parseFlexibleDateTime(
                                    controllers.controllerEffectiveDate.text,
                                  )
                                  : DateTime.now(),
                        ),
                        CmFormDate(
                          label: 'at.effective_date_to'.tr,
                          controller: controllers.controllerEffectiveDateTo,
                          isEditing: state.isEditing,
                          onChanged: (value) {
                            log('Effective date selected: $value');
                          },
                          value:
                              controllers
                                      .controllerEffectiveDateTo
                                      .text
                                      .isNotEmpty
                                  ? AppUtility.parseFlexibleDateTime(
                                    controllers.controllerEffectiveDateTo.text,
                                  )
                                  : DateTime.now(),
                        ),
                        CmFormDropdownObject<NhanVien>(
                          label: 'at.approver'.tr,
                          controller: controllers.controllerApprover,
                          isEditing: state.isEditing,
                          value: state.nguoiKyGiamDoc,
                          items: widget.provider.itemsDDNhanVien,
                          defaultValue:
                              controllers.controllerApprover.text.isNotEmpty
                                  ? widget.provider.getNhanVienByID(
                                    controllers.controllerApprover.text,
                                  )
                                  : null,
                          fieldName: 'approver',
                          validationErrors: validation.validationErrors,
                          onChanged: (value) {
                            state.nguoiKyGiamDoc = value;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              DocumentUploadWidget(
                isEditing: state.isEditing,
                selectedFileName: state.selectedFileName,
                selectedFilePath: state.selectedFilePath,
                validationErrors: validation.validationErrors,
                onFileSelected: (fileName, filePath, fileBytes) {
                  setState(() {
                    state.selectedFileName = fileName;
                    state.selectedFilePath = filePath;
                    _selectedFileBytes = fileBytes;

                    if (validation.hasValidationError('document')) {
                      validation.removeValidationError('document');
                    }
                  });
                },
                isUploading: state.isUploading,
                label: 'Tài liệu Quyết định',
                errorMessage: 'Tài liệu quyết định là bắt buộc',
                hintText: 'Định dạng hỗ trợ: .pdf, .docx (Microsoft Word)',
                allowedExtensions: ['pdf', 'docx'],
              ),

              AssetTransferMovementTable(
                context,
                isEditing: state.isEditing,
                initialDetails: state.item?.chiTietDieuDongTaiSans ?? [],
                allAssets: widget.provider.dataAsset ?? [],
                onDataChanged: (data) {
                  setState(() {
                    state.listNewDetails =
                        data
                            .map(
                              (e) => ChiTietDieuDongTaiSan(
                                id: UUIDGenerator.generateWithFormat(
                                  'CTDD-****',
                                ),
                                idDieuDongTaiSan:
                                    controllers.controllerSoChungTu.text,
                                soQuyetDinh: state.item?.soQuyetDinh ?? '',
                                tenPhieu:
                                    controllers.controllerDocumentName.text,
                                idTaiSan: e.id ?? '',
                                tenTaiSan: e.tenTaiSan ?? '',
                                donViTinh: e.donViTinh ?? '',
                                hienTrang: e.hienTrang ?? 0,
                                soLuong: e.soLuong ?? 0,
                                ghiChu: e.ghiChu ?? '',
                                ngayTao: e.ngayTao ?? '',
                                ngayCapNhat: e.ngayCapNhat ?? '',
                                nguoiTao: widget.provider.userInfo?.id ?? '',
                                nguoiCapNhat:
                                    widget.provider.userInfo?.id ?? '',
                                isActive: true,
                              ),
                            )
                            .toList();
                    widget.provider.changeIsShowPreview(
                      _createDieuDong(widget.type, state.listNewDetails),
                    );
                  });
                },
              ),

              SizedBox(height: 10),
              previewDocumentAssetTransfer(
                context: context,
                item: state.item ?? widget.provider.itemPreview,
                provider: widget.provider,
                isShowKy: false,
                document: _document,
                callBack: () {
                  setState(() {
                    _createDieuDong(widget.type, state.listNewDetails);
                  });
                },
                isDisabled: state.listNewDetails.isEmpty,
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
    if (widget.provider.item != state.item) {
      _refreshWidget();
    }

    if (widget.isNew == true && state.item != null) {
      _refreshWidget();
    }
  }

  LenhDieuDongRequest _createDieuDongRequest(int type, int state) {
    return LenhDieuDongRequest(
      id: controllers.controllerSoChungTu.text,
      soQuyetDinh: controllers.controllerSoChungTu.text,
      tenPhieu: controllers.controllerDocumentName.text,
      idDonViGiao: this.state.donViGiao?.id ?? '',
      idDonViNhan: this.state.donViNhan?.id ?? '',
      idNguoiDeNghi: this.state.nguoiDeNghi?.id ?? '',
      nguoiLapPhieuKyNhay: this.state.isNguoiLapPhieuKyNhay,
      quanTrongCanXacNhan: this.state.isQuanTrongCanXacNhan,
      phoPhongXacNhan: this.state.isPhoPhongXacNhan,
      idDonViDeNghi: this.state.donViDeNghi?.id ?? '',
      idTrinhDuyetCapPhong: this.state.nguoiKyCapPhong?.id ?? '',
      tggnTuNgay:
          AppUtility.parseDateTimeOrNow(
            controllers.controllerEffectiveDate.text,
          ).toIso8601String(),
      tggnDenNgay:
          AppUtility.parseDateTimeOrNow(
            controllers.controllerEffectiveDateTo.text,
          ).toIso8601String(),
      idTrinhDuyetGiamDoc: this.state.nguoiKyGiamDoc?.id ?? '',
      diaDiemGiaoNhan: controllers.controllerDeliveryLocation.text,
      idPhongBanXemPhieu: this.state.nguoiKyCapPhong?.id ?? '',
      idNhanSuXemPhieu: this.state.nguoiKyGiamDoc?.id ?? '',
      noiNhan: '',
      trangThai: state,
      idCongTy: widget.provider.userInfo?.idCongTy ?? '',
      ngayTao: DateTime.now().toIso8601String(),
      ngayCapNhat: DateTime.now().toIso8601String(),
      nguoiTao: widget.provider.userInfo?.tenDangNhap ?? '',
      nguoiCapNhat: widget.provider.userInfo?.tenDangNhap ?? '',
      coHieuLuc: true,
      loai: type,
      isActive: true,
      idTruongPhongDonViGiao: this.state.tPDonViGiao?.id ?? '',
      idPhoPhongDonViGiao: this.state.pPDonViGiao?.id ?? '',
      truongPhongDonViGiaoXacNhan: false,
      phoPhongDonViGiaoXacNhan: false,
      trinhDuyetCapPhongXacNhan: false,
      trinhDuyetGiamDocXacNhan: false,
      trichYeu: controllers.controllerSubject.text,
      duongDanFile: this.state.selectedFilePath ?? '',
      tenFile: this.state.selectedFileName ?? '',
      ngayKy: DateTime.now().toIso8601String(),
    );
  }

  DieuDongTaiSanDto? _createDieuDong(
    int type,
    List<ChiTietDieuDongTaiSan> listNewDetails,
  ) {
    return DieuDongTaiSanDto(
      id: controllers.controllerSoChungTu.text,
      soQuyetDinh: controllers.controllerSoChungTu.text,
      tenPhieu: controllers.controllerDocumentName.text,
      idDonViGiao: state.donViGiao?.id ?? '',
      idDonViNhan: state.donViNhan?.id ?? '',
      idNguoiDeNghi: state.nguoiDeNghi?.id ?? '',
      nguoiLapPhieuKyNhay: state.isNguoiLapPhieuKyNhay,
      quanTrongCanXacNhan: state.isQuanTrongCanXacNhan,
      phoPhongXacNhan: state.isPhoPhongXacNhan,
      idDonViDeNghi: state.donViDeNghi?.id ?? '',
      idTrinhDuyetCapPhong: state.nguoiKyCapPhong?.id ?? '',
      tggnTuNgay:
          AppUtility.parseDateTimeOrNow(
            controllers.controllerEffectiveDate.text,
          ).toIso8601String(),
      tggnDenNgay:
          AppUtility.parseDateTimeOrNow(
            controllers.controllerEffectiveDateTo.text,
          ).toIso8601String(),
      idTrinhDuyetGiamDoc: state.nguoiKyGiamDoc?.id ?? '',
      diaDiemGiaoNhan: controllers.controllerDeliveryLocation.text,
      idPhongBanXemPhieu: state.nguoiKyCapPhong?.id ?? '',
      idNhanSuXemPhieu: state.nguoiKyGiamDoc?.id ?? '',
      noiNhan: '',
      trangThai: 0,
      idCongTy: widget.provider.userInfo?.idCongTy ?? '',
      ngayTao: DateTime.now().toIso8601String(),
      ngayCapNhat: DateTime.now().toIso8601String(),
      nguoiTao: widget.provider.userInfo?.tenDangNhap ?? '',
      nguoiCapNhat: widget.provider.userInfo?.tenDangNhap ?? '',
      coHieuLuc: true,
      loai: type,
      isActive: true,
      trichYeu: controllers.controllerSubject.text,
      duongDanFile: state.selectedFilePath ?? '',
      tenFile: state.selectedFileName ?? '',
      ngayKy: DateTime.now().toIso8601String(),
      chiTietDieuDongTaiSans: listNewDetails,
    );
  }

  List<ChiTietDieuDongRequest> _createDieuDongRequestDetail() {
    return state.listNewDetails
        .map(
          (e) => ChiTietDieuDongRequest(
            id: e.id,
            idDieuDongTaiSan: e.idDieuDongTaiSan,
            idTaiSan: e.idTaiSan,
            soLuong: e.soLuong,
            ghiChu: e.ghiChu,
            ngayTao: e.ngayTao,
            ngayCapNhat: e.ngayCapNhat,
            nguoiTao: widget.provider.userInfo?.tenDangNhap ?? '',
            nguoiCapNhat: widget.provider.userInfo?.tenDangNhap ?? '',
            isActive: true,
          ),
        )
        .toList();
  }

  Future<void> _handleSave() async {
    if (!state.isEditing) return;
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
    if (state.item == null) {
      final request = _createDieuDongRequest(widget.type, getState());
      final requestDetail = _createDieuDongRequestDetail();
      // bloc.add(CreateDieuDongEvent(context, request));
      widget.provider.saveAssetTransfer(
        context,
        request,
        requestDetail,
        state.selectedFileName ?? '',
        state.selectedFilePath ?? '',
        _selectedFileBytes ?? Uint8List(0),
      );
    } else if (state.item != null && state.isEditing) {
      final request = _createDieuDongRequest(
        widget.type,
        state.item!.trangThai ?? 0,
      );
      int trangThai = state.item!.trangThai == 5 ? 1 : state.item!.trangThai!;
      LenhDieuDongRequest newRequest = request.copyWith(
        truongPhongDonViGiaoXacNhan:
            state.item!.truongPhongDonViGiaoXacNhan ?? false,
        phoPhongDonViGiaoXacNhan: state.item!.phoPhongDonViGiaoXacNhan ?? false,
        trinhDuyetCapPhongXacNhan:
            state.item!.trinhDuyetCapPhongXacNhan ?? false,
        trinhDuyetGiamDocXacNhan: state.item!.trinhDuyetGiamDocXacNhan ?? false,
        ngayKy: state.item!.ngayKy ?? DateTime.now().toIso8601String(),
        nguoiCapNhat: widget.provider.userInfo?.tenDangNhap ?? '',
        trangThai: trangThai,
      );
      // Cập nhật chi tiết nếu có thay đổi
      if (_detailsChanged()) {
        await _syncDetails(state.item!.id!);
      }
      if (mounted) {
        context.read<DieuDongTaiSanBloc>().add(
          UpdateDieuDongEvent(context, newRequest, state.item!.id!),
        );
      }
    }
  }

  int getState() {
    int state = 0;
    if (!this.state.isNguoiLapPhieuKyNhay &&
        !this.state.isQuanTrongCanXacNhan) {
      state = 3;
    } else if (!this.state.isNguoiLapPhieuKyNhay) {
      state = 1;
    } else if (this.state.isNguoiLapPhieuKyNhay) {
      state = 0;
    }
    return state;
  }

  bool editable() {
    return (state.item != null &&
        (state.item!.trangThai == 0 || state.item!.trangThai == 5) &&
        state.item!.nguoiTao == widget.provider.userInfo?.tenDangNhap);
  }

  // Method để làm mới widget
  void _refreshWidget() {
    setState(() {
      state.listNewDetails.clear();
      state.nguoiLapPhieu = widget.provider.userInfo;
      // Reset item từ provider
      state.item = widget.provider.item;
      state.isNew = state.item == null;
      state.messageEditing = null;

      // Reset editing state
      state.isEditing = widget.isEditing;
      if (editable()) {
        state.isEditing = true;
      } else {
        // if (state.item!.nguoiTao != widget.provider.userInfo?.tenDangNhap) {
        //   state.messageEditing = 'Bạn không có quyền chỉnh sửa phiếu này';
        // }
        state.isEditing = false;
      }
      log('message state.isEditing ${state.isEditing}');
      if (state.item != null) {
        controllers.controllerSoChungTu.text = state.item?.id ?? '';
        controllers.controllerSubject.text = state.item?.trichYeu ?? '';
        controllers.controllerDocumentName.text = state.item?.tenPhieu ?? '';
        controllers.controllerDeliveringUnit.text =
            state.item?.tenDonViGiao ?? '';
        controllers.controllerReceivingUnit.text =
            state.item?.tenDonViNhan ?? '';
        controllers.controllerRequester.text = state.item?.tenNguoiDeNghi ?? '';
        controllers.controllerDepartmentApproval.text =
            state.item?.tenTrinhDuyetCapPhong ?? '';
        controllers.controllerEffectiveDate.text = state.item?.tggnTuNgay ?? '';
        controllers.controllerEffectiveDateTo.text =
            state.item?.tggnDenNgay ?? '';
        controllers.controllerApprover.text =
            state.item?.tenTrinhDuyetGiamDoc ?? '';
        controllers.controllerDeliveryLocation.text =
            state.item?.diaDiemGiaoNhan ?? '';
        controllers.controllerTPDonViGiao.text =
            state.item?.tenTruongPhongDonViGiao ?? '';
        controllers.controllerPPDonViNhan.text =
            state.item?.tenPhoPhongDonViGiao ?? '';

        //load date value dropdown
        state.donViGiao = widget.provider.getPhongBanByID(
          state.item?.idDonViGiao ?? '',
        );

        //load list staff by department
        state.listStaffByDepartment =
            widget.provider.dataNhanVien
                .where((element) => element.phongBanId == state.donViGiao!.id)
                .toList();

        state.donViNhan = widget.provider.getPhongBanByID(
          state.item?.idDonViNhan ?? '',
        );
        state.pPDonViGiao = widget.provider.getNhanVienByID(
          state.item?.idPhoPhongDonViGiao ?? '',
        );
        state.tPDonViGiao = widget.provider.getNhanVienByID(
          state.item?.idTruongPhongDonViGiao ?? '',
        );
        state.nguoiKyCapPhong = widget.provider.getNhanVienByID(
          state.item?.idTrinhDuyetCapPhong ?? '',
        );
        state.nguoiKyGiamDoc = widget.provider.getNhanVienByID(
          state.item?.idTrinhDuyetGiamDoc ?? '',
        );
        state.donViDeNghi = widget.provider.getPhongBanByID(
          state.item?.idDonViDeNghi ?? '',
        );
        state.nguoiDeNghi = widget.provider.getNhanVienByID(
          state.item?.idNguoiDeNghi ?? '',
        );

        // Initialize selected file if available
        state.selectedFileName = state.item?.tenFile;
        state.selectedFilePath = state.item?.duongDanFile;
        state.isNguoiLapPhieuKyNhay = state.item?.nguoiLapPhieuKyNhay ?? false;
        state.isQuanTrongCanXacNhan = state.item?.quanTrongCanXacNhan ?? false;
        state.isPhoPhongXacNhan = state.item?.phoPhongXacNhan ?? false;
        state.proposingUnit = state.item?.tenDonViDeNghi;

        // Lưu snapshot chi tiết ban đầu để so sánh
        state.initialDetails = List<ChiTietDieuDongTaiSan>.from(
          state.item?.chiTietDieuDongTaiSans ?? <ChiTietDieuDongTaiSan>[],
        );

        state.listNewDetails = List<ChiTietDieuDongTaiSan>.from(
          state.item?.chiTietDieuDongTaiSans ?? <ChiTietDieuDongTaiSan>[],
        );
        state.controllersInitialized = true;
      } else {
        controllers.controllerSoChungTu.text = UUIDGenerator.generateWithFormat(
          'SCT-************',
        );
        controllers.controllerSubject.text = '';
        controllers.controllerDocumentName.text = '';
        controllers.controllerDeliveringUnit.text = '';
        controllers.controllerReceivingUnit.text = '';
        controllers.controllerRequester.text = '';
        controllers.controllerDepartmentApproval.text = '';
        controllers.controllerEffectiveDate.text = '';
        controllers.controllerEffectiveDateTo.text = '';
        controllers.controllerApprover.text = '';
        controllers.controllerDeliveryLocation.text = '';
        controllers.controllerProposingUnit.text = '';

        state.controllersInitialized = false;
        state.selectedFileName = null;
        state.selectedFilePath = null;
        state.isNguoiLapPhieuKyNhay = false;
        state.isQuanTrongCanXacNhan = false;
        state.isPhoPhongXacNhan = false;
        state.donViGiao = null;
        state.donViNhan = null;
        state.donViDeNghi = null;
        state.nguoiDeNghi = widget.provider.getNhanVienByID(
          widget.provider.userInfo?.tenDangNhap ?? '',
        );
        state.tPDonViGiao = null;
        state.pPDonViGiao = null;
        state.nguoiKyCapPhong = null;
        state.nguoiKyGiamDoc = null;
      }

      if (state.proposingUnit != null &&
          state.proposingUnit!.isNotEmpty &&
          !state.controllersInitialized) {
        controllers.controllerProposingUnit.text = state.proposingUnit!;
      }

      // Reset các biến trạng thái
      state.isNguoiLapPhieuKyNhay = state.item?.nguoiLapPhieuKyNhay ?? false;
      state.isQuanTrongCanXacNhan = state.item?.quanTrongCanXacNhan ?? false;
      state.isPhoPhongXacNhan = state.item?.phoPhongXacNhan ?? false;
      state.proposingUnit = state.item?.tenDonViDeNghi;

      // Reset file upload
      state.selectedFileName = state.item?.tenFile;
      state.selectedFilePath = state.item?.duongDanFile;

      validation.clearValidationErrors();

      state.controllersInitialized = false;

      state.isUploading = false;
      state.isRefreshing = false;
    });
  }
}
