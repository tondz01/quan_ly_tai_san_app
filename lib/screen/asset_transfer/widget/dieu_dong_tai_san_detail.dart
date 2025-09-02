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
import 'package:quan_ly_tai_san_app/common/widgets/additional_signers_selector.dart';
import 'package:quan_ly_tai_san_app/common/widgets/document_upload_widget.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/core/utils/uuid_generator.dart';
import 'package:quan_ly_tai_san_app/main.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/preview_document_asset_transfer.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';
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
import 'package:se_gay_components/core/utils/sg_log.dart' show SGLog;

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

  Future<void> _loadPdf(String path) async {
    final document = await PdfDocument.openFile(path);
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
              steps: ['Nháp', 'Duyệt', 'Hủy', 'Hoàn thành'],
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
                          value: state.donViNhan,
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
                      ],
                    ),
                  ),

                  Expanded(
                    child: Column(
                      children: [
                        CmFormDropdownObject<PhongBan>(
                          label: 'Đơn vị đề nghị'.tr,
                          controller: controllers.controllerProposingUnit,
                          isEditing: state.isEditing,
                          value: state.donViDeNghi,
                          items: widget.provider.itemsDDPhongBan,
                          defaultValue:
                              controllers
                                      .controllerProposingUnit
                                      .text
                                      .isNotEmpty
                                  ? widget.provider.getPhongBanByID(
                                    controllers.controllerProposingUnit.text,
                                  )
                                  : null,
                          fieldName: 'receivingUnit',
                          validationErrors: validation.validationErrors,
                          onChanged: (value) {
                            setState(() {
                              state.donViDeNghi = value;
                              state.listNhanVienThamMuu =
                                  widget.provider.dataNhanVien
                                      .where(
                                        (e) =>
                                            e.phongBanId ==
                                            state.donViDeNghi?.id,
                                      )
                                      .toList();
                            });
                          },
                        ),

                        CmFormDropdownObject<NhanVien>(
                          label: 'at.requester'.tr,
                          controller: controllers.controllerRequester,
                          isEditing: state.isEditing,
                          value: state.nguoiDeNghi,
                          items: [
                            ...state.listStaffByDepartment.map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.hoTen ?? ''),
                              ),
                            ),
                          ],
                          // defaultValue:
                          //     controllers.controllerRequester.text.isNotEmpty
                          //         ? widget.provider.getNhanVienByID(
                          //           controllers.controllerRequester.text,
                          //         )
                          //         : null,
                          fieldName: 'requester',
                          validationErrors: validation.validationErrors,
                          onChanged: (value) {
                            setState(() {
                              state.nguoiDeNghi = value;
                              state.donViDeNghi = widget.provider
                                  .getPhongBanByID(value.phongBanId ?? '');
                              // controllers.controllerProposingUnit.text =
                              //     state.donViDeNghi?.tenPhongBan ?? '';
                              // state.donThamMuu = widget.provider
                              //     .getPhongBanByID(value.phongBanId ?? '');
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

                        CmFormDropdownObject<NhanVien>(
                          label: 'at.department_approval'.tr,
                          controller: controllers.controllerDepartmentApproval,
                          isEditing:
                              state.isEditing && state.donViDeNghi != null,
                          value: state.nguoiKyCapPhong,
                          items: [
                            ...state.listNhanVienThamMuu.map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.hoTen ?? ''),
                              ),
                            ),
                          ],
                          // defaultValue:
                          //     controllers
                          //             .controllerDepartmentApproval
                          //             .text
                          //             .isNotEmpty
                          //         ? widget.provider.getNhanVienByID(
                          //           controllers
                          //               .controllerDepartmentApproval
                          //               .text,
                          //         )
                          //         : null,
                          fieldName: 'departmentApproval',
                          validationErrors: validation.validationErrors,
                          onChanged: (value) {
                            state.nguoiKyCapPhong = value;
                          },
                        ),

                        CmFormDropdownObject<NhanVien>(
                          label: 'at.approver'.tr,
                          controller: controllers.controllerApprover,
                          isEditing:
                              state.isEditing && state.donViDeNghi != null,
                          value: state.nguoiKyGiamDoc,
                          items: [
                            ...state.listNhanVienThamMuu.map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.hoTen ?? ''),
                              ),
                            ),
                          ],
                          // defaultValue:
                          //     controllers.controllerApprover.text.isNotEmpty
                          //         ? widget.provider.getNhanVienByID(
                          //           controllers.controllerApprover.text,
                          //         )
                          //         : null,
                          fieldName: 'approver',
                          validationErrors: validation.validationErrors,
                          onChanged: (value) {
                            state.nguoiKyGiamDoc = value;
                          },
                        ),
                        AdditionalSignersSelector(
                          addButtonText: "Thêm đơn bị đại diện",
                          labelDepartment: "Đơn vị đại diện",
                          labelSigned: 'Người đại diện',
                          isEditing: state.isEditing,
                          itemsNhanVien: [
                            ...state.listStaffByDepartment.map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.hoTen ?? ''),
                              ),
                            ),
                          ],
                          phongBan: widget.provider.dataPhongBan,
                          listNhanVien: state.listStaffByDepartment,
                          initialSigners: state.additionalSigners,
                          onChanged: (list) {
                            setState(() {
                              state.additionalSigners
                                ..clear()
                                ..addAll(list);
                            });
                          },
                          initialSignerData: state.additionalSignersDetailed,
                          onChangedDetailed: (list) {
                            setState(() {
                              state.additionalSignersDetailed = list;
                            });
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

                    if (fileName != null) {
                      _loadPdf(filePath!);
                    }

                    if (validation.hasValidationError('document')) {
                      validation.removeValidationError('document');
                    }
                  });
                },
                isUploading: state.isUploading,
                label: 'Tài liệu Quyết định',
                errorMessage: 'Tài liệu quyết định là bắt buộc',
                hintText: 'Định dạng hỗ trợ: .pdf',
                allowedExtensions: ['pdf'],
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
      quanTrongCanXacNhan: false,
      phoPhongXacNhan: false,
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
      idTruongPhongDonViGiao: '',
      idPhoPhongDonViGiao: '',
      truongPhongDonViGiaoXacNhan: false,
      phoPhongDonViGiaoXacNhan: false,
      trinhDuyetCapPhongXacNhan: false,
      trinhDuyetGiamDocXacNhan: false,
      trichYeu: controllers.controllerSubject.text,
      duongDanFile: this.state.selectedFilePath ?? '',
      tenFile: this.state.selectedFileName ?? '',
      ngayKy: DateTime.now().toIso8601String(),
      share: false,
      idNguoiKyNhay: '',
      trangThaiKyNhay: false,
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
      quanTrongCanXacNhan: false,
      phoPhongXacNhan: false,
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

  List<SignatoryDto> _createListSignatory() {
    return state.additionalSigners
        .map(
          (e) => SignatoryDto(
            id: UUIDGenerator.generateWithFormat('NK-************'),
            idTaiLieu: state.item?.id ?? '',
            idNguoiKy: e?.id ?? '',
            tenNguoiKy: e?.hoTen ?? '',
            trangThai: 0,
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
    if (state.item == null) {
      final request = _createDieuDongRequest(widget.type, 0);
      final requestDetail = _createDieuDongRequestDetail();
      final listSignatory = _createListSignatory();
      widget.provider.saveAssetTransfer(
        context,
        request,
        requestDetail,
        listSignatory,
        state.selectedFileName ?? '',
        state.selectedFilePath ?? '',
        _selectedFileBytes ?? Uint8List(0),
      );
    } else if (state.item != null && state.isEditing) {
      final request = _createDieuDongRequest(
        widget.type,
        state.item!.trangThai ?? 0,
      );
      int trangThai = state.item!.trangThai == 2 ? 1 : state.item!.trangThai!;
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

  bool editable() {
    return (state.item != null &&
        (state.item!.trangThai == 0 || state.item!.trangThai == 2) &&
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
        state.donViDeNghi = widget.provider.getPhongBanByID(
          state.item?.idDonViDeNghi ?? '',
        );
        state.listNhanVienThamMuu =
            widget.provider.dataNhanVien
                .where((e) => e.phongBanId == state.donViDeNghi?.id)
                .toList();
        state.nguoiDeNghi = widget.provider.getNhanVienByID(
          state.item?.idNguoiDeNghi ?? '',
        );
        state.donViNhan = widget.provider.getPhongBanByID(
          state.item?.idDonViNhan ?? '',
        );
        state.nguoiKyCapPhong = widget.provider.getNhanVienByID(
          state.item?.idTrinhDuyetCapPhong ?? '',
        );
        state.nguoiKyGiamDoc = widget.provider.getNhanVienByID(
          state.item?.idTrinhDuyetGiamDoc ?? '',
        );

        // Initialize selected file if available
        state.selectedFileName = state.item?.tenFile;
        state.selectedFilePath = state.item?.duongDanFile;
        state.isNguoiLapPhieuKyNhay = state.item?.nguoiLapPhieuKyNhay ?? false;
        state.proposingUnit = state.item?.tenDonViDeNghi;

        // Lưu snapshot chi tiết ban đầu để so sánh
        state.initialDetails = List<ChiTietDieuDongTaiSan>.from(
          state.item?.chiTietDieuDongTaiSans ?? <ChiTietDieuDongTaiSan>[],
        );

        state.listNewDetails = List<ChiTietDieuDongTaiSan>.from(
          state.item?.chiTietDieuDongTaiSans ?? <ChiTietDieuDongTaiSan>[],
        );
        state.controllersInitialized = true;
        state.additionalSignersDetailed =
            state.item?.listSignatory
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
          'message test additionalSignersDetailed: ${jsonEncode(state.additionalSignersDetailed)}',
        );

        _loadPdfNetwork(state.item?.tenFile ?? '');
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
        state.donViGiao = null;
        state.donViNhan = null;
        NhanVien nhanVienLogin = widget.provider.dataNhanVien.firstWhere(
          (e) => e.id == widget.provider.userInfo?.tenDangNhap,
        );
        state.donViDeNghi = widget.provider.getPhongBanByID(
          nhanVienLogin.phongBanId ?? '',
        );
        state.listNhanVienThamMuu =
            widget.provider.dataNhanVien
                .where((e) => e.phongBanId == state.donViDeNghi?.id)
                .toList();

        state.nguoiDeNghi = nhanVienLogin;
        controllers.controllerRequester.text = state.nguoiDeNghi?.hoTen ?? '';
        state.nguoiKyCapPhong = null;
        state.nguoiKyGiamDoc = null;
      }

      if (state.proposingUnit != null &&
          state.proposingUnit!.isNotEmpty &&
          !state.controllersInitialized) {
        // controllers.controllerProposingUnit.text = state.proposingUnit!;
      }

      // Reset các biến trạng thái
      state.isNguoiLapPhieuKyNhay = state.item?.nguoiLapPhieuKyNhay ?? false;
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
