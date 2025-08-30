import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:quan_ly_tai_san_app/common/input/common_checkbox_input.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_date.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/widgets/document_upload_widget.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/main.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/component/preview_document_asset_handover.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/component/table_asset_movement_detail.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/asset_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:se_gay_components/common/sg_indicator.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class AssetHandoverDetail extends StatefulWidget {
  final AssetHandoverProvider provider;
  final bool isEditing;
  final bool isNew;

  const AssetHandoverDetail({
    super.key,
    this.isEditing = false,
    this.isNew = false,
    required this.provider,
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
  late TextEditingController controllerLeader = TextEditingController();
  late TextEditingController controllerIssuingUnitRepresentative =
      TextEditingController();
  late TextEditingController controllerDelivererRepresentative =
      TextEditingController();
  late TextEditingController controllerReceiverRepresentative =
      TextEditingController();
  late TextEditingController controllerRepresentativeUnit =
      TextEditingController();

  bool isEditing = false;
  UserInfoDTO? currentUser;

  bool isUnitConfirm = false;
  bool isDelivererConfirm = false;
  bool isReceiverConfirm = false;
  bool isRepresentativeUnitConfirm = false;
  bool isExpanded = false;

  String? proposingUnit;
  String? _selectedFileName;
  String? _selectedFilePath;

  AssetHandoverDto? item;

  List<PhongBan> listPhongBan = [];
  List<NhanVien> listNhanVien = [];
  List<NhanVien> listNhanVienDonViNhan = [];
  List<NhanVien> listNhanVienDonViGiao = [];
  List<DieuDongTaiSanDto> listAssetTransfer = [];

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
  DieuDongTaiSanDto? dieuDongTaiSan;

  PdfDocument? _document;

  @override
  void initState() {
    setState(() {
      _initData();
      _updateControllers();
    });
    super.initState();
  }

  Future<void> _loadPdfNetwork(String nameFile) async {
    try {
      final document = await PdfDocument.openUri(Uri.parse("${Config.baseUrl}/api/upload/preview/$nameFile"));
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
        (item!.trangThai == 0 || item!.trangThai == 3) &&
        item!.nguoiTao == currentUser?.tenDangNhap);
  }

  void _initData() {
    if (!mounted) return; // Kiểm tra nếu widget đã bị dispose
    currentUser = AccountHelper.instance.getUserInfo();
    item = widget.provider.item;
    isEditing = widget.isEditing;

    if (editable()) {
      log('message item ${item?.trangThai}');
      isEditing = true;
    } else {
      isEditing = false;
    }

    listNhanVien = widget.provider.dataStaff ?? [];
    listPhongBan = widget.provider.dataDepartment ?? [];
    listAssetTransfer =
        widget.provider.dataAssetTransfer
            ?.where((element) => element.trangThai == 6)
            .toList() ??
        [];

    if (item != null) {
      isUnitConfirm = item?.daXacNhan ?? false;
      isDelivererConfirm = item?.daiDienBenGiaoXacNhan ?? false;
      isReceiverConfirm = item?.daiDienBenNhanXacNhan ?? false;
      isRepresentativeUnitConfirm =
          item?.donViDaiDienXacNhan == "0" ? false : true;
      getStaffDonViGiaoAndNhan(item!.idDonViNhan!, item!.idDonViGiao!);
    } else {
      isUnitConfirm = false;
      isDelivererConfirm = false;
      isReceiverConfirm = false;
      isRepresentativeUnitConfirm = false;
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

    // Cập nhật controllers với dữ liệu mới
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
    if (controllerLeader.text.isEmpty) {
      newValidationErrors['leader'] = true;
    }
    if (controllerIssuingUnitRepresentative.text.isEmpty) {
      newValidationErrors['issuingUnitRepresentative'] = true;
    }
    if (controllerDelivererRepresentative.text.isEmpty) {
      newValidationErrors['delivererRepresentative'] = true;
    }
    if (controllerReceiverRepresentative.text.isEmpty) {
      newValidationErrors['receiverRepresentative'] = true;
    }
    if (controllerRepresentativeUnit.text.isEmpty) {
      newValidationErrors['representativeUnit'] = true;
    }

    bool hasChanges = !mapEquals(_validationErrors, newValidationErrors);
    if (hasChanges) {
      SGLog.debug("AssetHandoverDetail", "hasChanges");
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
      controllerOrder.text = item?.lenhDieuDong ?? '';
      controllerSenderUnit.text = item?.tenDonViGiao ?? '';
      controllerReceiverUnit.text = item?.tenDonViNhan ?? '';
      controllerTransferDate.text = item?.ngayBanGiao ?? '';
      controllerLeader.text = item?.tenLanhDao ?? '';
      controllerIssuingUnitRepresentative.text =
          item?.tenDaiDienBanHanhQD ?? '';
      controllerDelivererRepresentative.text = item?.tenDaiDienBenGiao ?? '';
      controllerReceiverRepresentative.text = item?.tenDaiDienBenNhan ?? '';
      controllerRepresentativeUnit.text = item?.tenDonViDaiDien ?? '';
    } else {
      isEditing = true;
      controllerHandoverNumber.text = '';
      controllerDocumentName.text = '';
    }
  }

  void _saveAssetHandover() {
    context.read<AssetHandoverProvider>().isLoading = true;

    String ngayBanGiao = "";
    ngayBanGiao = _formatDate(controllerTransferDate.text);

    final Map<String, dynamic> request = {
      "id": controllerHandoverNumber.text,
      "idCongTy": currentUser?.idCongTy ?? "CT001",
      "banGiaoTaiSan": controllerDocumentName.text,
      "quyetDinhDieuDongSo": dieuDongTaiSan?.soQuyetDinh ?? '',
      "lenhDieuDong": dieuDongTaiSan?.id ?? '',
      "idDonViGiao": donViGiao?.id ?? '',
      "idDonViNhan": donViNhan?.id ?? '',
      "ngayBanGiao": ngayBanGiao,
      "idLanhDao": nguoiLanhDao?.id ?? '',
      "idDaiDiendonviBanHanhQD": nguoiDaiDienBanHanhQD?.id ?? '',
      "daXacNhan": isUnitConfirm,
      "idDaiDienBenGiao": nguoiDaiDienBenGiao?.id ?? '',
      "daiDienBenGiaoXacNhan": isDelivererConfirm,
      "idDaiDienBenNhan": nguoiDaiDienBenNhan?.id ?? '',
      "daiDienBenNhanXacNhan": isReceiverConfirm,
      "idDonViDaiDien": nguoiDaiDienDonViDaiDien?.id ?? '',
      "donViDaiDienXacNhan": isRepresentativeUnitConfirm,
      "trangThai": 1,
      "note": "",
      "ngayTao": DateTime.now().toIso8601String(),
      "ngayCapNhat": DateTime.now().toIso8601String(),
      "nguoiTao": currentUser?.tenDangNhap ?? '',
      "nguoiCapNhat": '',
      "isActive": true,
    };

    if (item == null) {
      context.read<AssetHandoverBloc>().add(
        CreateAssetHandoverEvent(context, request),
      );
    }
    {
      int trangThai = item!.trangThai == 3 ? 1 : item!.trangThai!;
      request['trangThai'] = trangThai;
      request['nguoiCapNhat'] = currentUser?.tenDangNhap ?? '';
      context.read<AssetHandoverBloc>().add(
        UpdateAssetHandoverEvent(context, request, item!.id!),
      );
    }

    // Sử dụng addPostFrameCallback để tránh gọi trong quá trình build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.provider.hasUnsavedChanges = false;
      }
    });
  }

  String _formatDate(String date) {
    String dateResult = "";
    try {
      if (date.isNotEmpty) {
        if (date.contains("T")) {
          dateResult = date;
        } else {
          List<String> dateParts = date.split('/');
          if (dateParts.length == 3) {
            DateTime date = DateTime(
              int.parse(dateParts[2]),
              int.parse(dateParts[1]),
              int.parse(dateParts[0]),
            );
            dateResult = date.toIso8601String();
          } else {
            DateTime? parsedDate = DateTime.tryParse(date);
            if (parsedDate != null) {
              dateResult = parsedDate.toIso8601String();
            }
          }
        }
      }
    } catch (e) {
      dateResult = DateTime.now().toIso8601String();
    }
    return dateResult;
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
    _saveAssetHandover();
  }

  void _cancelChanges() {
    _updateControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.provider.hasUnsavedChanges = false;
      }
    });
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
    // Giải phóng các controller
    controllerHandoverNumber.dispose();
    controllerDocumentName.dispose();
    controllerOrder.dispose();
    controllerSenderUnit.dispose();
    controllerReceiverUnit.dispose();

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
    log('message isEditing ${item?.trangThai}');
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Hiển thị indicator unsaved changes và nút Save/Cancel
            Row(
              children: [
                // if (widget.provider.hasUnsavedChanges)
                //   Container(
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 8,
                //       vertical: 4,
                //     ),
                //     decoration: BoxDecoration(
                //       color: Colors.orange,
                //       borderRadius: BorderRadius.circular(4),
                //     ),
                //     child: const Text(
                //       'Có thay đổi chưa lưu',
                //       style: TextStyle(color: Colors.white, fontSize: 12),
                //     ),
                //   ),
                // const SizedBox(width: 10),
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
                        title: 'Xác nhận hủy tạo phiếu Bàn giao}',
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
                  visible: item != null && ![0, 3, 4].contains(item!.trangThai),
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
              steps: ['Nháp', 'Chờ xác nhận', 'Chờ duyệt', 'Hủy', 'Hoàn thành'],
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
              Visibility(
                visible: _selectedFileName != null && _selectedFilePath != null,
                child: DocumentUploadWidget(
                  isEditing: false,
                  selectedFileName: _selectedFileName,
                  selectedFilePath: _selectedFilePath,
                  validationErrors: _validationErrors,
                  onFileSelected: (fileName, filePath, fileBytes) {},
                  // onUpload: _uploadWordDocument,
                  isUploading: false,
                  label: 'Tài liệu Quyết định',
                  errorMessage: 'Tài liệu quyết định là bắt buộc',
                  hintText: 'Định dạng hỗ trợ: .pdf',
                  allowedExtensions: ['pdf'],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TableAssetMovementDetail(
                  listDetailAssetMobilization:
                      widget.provider.dataDetailAssetMobilization,
                ),
              ),
              previewDocumentAssetHandover(
                context: context,
                item: item ?? getAssetHandoverPreview(),
                itemsDetail: widget.provider.dataDetailAssetMobilization ?? [],
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
    DateTime? ngayBanGiao;
    return Column(
      children: [
        CommonFormInput(
          label: 'Số phiếu bàn giao',
          controller: controllerHandoverNumber,
          isEditing: (isEditing && item == null),
          fieldName: 'handoverNumber',
          textContent: item?.id ?? '',
          validationErrors: _validationErrors,
        ),
        CommonFormInput(
          label: 'Bàn giao tài sản',
          controller: controllerDocumentName,
          isEditing: isEditing,
          textContent: item?.banGiaoTaiSan ?? '',
          fieldName: 'documentName',
          validationErrors: _validationErrors,
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
            dieuDongTaiSan = value;
            setState(() {
              _selectedFileName = dieuDongTaiSan?.tenFile;
              _selectedFilePath = dieuDongTaiSan?.duongDanFile;

              if (dieuDongTaiSan?.tenFile!.isNotEmpty ?? true) {
                _loadPdfNetwork(dieuDongTaiSan?.tenFile ?? '');
              }

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
            });
          },
          validationErrors: _validationErrors,
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
        CmFormDate(
          label: 'Ngày bàn giao',
          controller: controllerTransferDate,
          isEditing: isEditing,
          value: ngayBanGiao,
          onChanged: (dt) {},
          validationErrors: _validationErrors,
          fieldName: 'transferDate',
        ),
        CmFormDropdownObject<NhanVien>(
          label: 'Lãnh đạo',
          controller: controllerLeader,
          isEditing: isEditing,
          defaultValue:
              item?.idLanhDao != null
                  ? widget.provider.getNhanVien(idNhanVien: item!.idLanhDao!)
                  : null,
          fieldName: 'leader',
          items: itemsNhanVien,
          validationErrors: _validationErrors,
          onChanged: (value) {
            nguoiLanhDao = value;
          },
        ),
      ],
    );
  }

  Widget _buildAssetHandoverDetail() {
    return Column(
      children: [
        CmFormDropdownObject<NhanVien>(
          label: 'Đại diện Đơn vị ban hành QĐ',
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
        ),
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
        CmFormDropdownObject<NhanVien>(
          label: 'Đại diện bên giao',
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
          label: 'Đại diện bên nhận',
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
        CmFormDropdownObject<NhanVien>(
          label: 'Đơn vị Đại diện',
          controller: controllerRepresentativeUnit,
          isEditing: isEditing,
          defaultValue:
              item?.idDonViDaiDien != null
                  ? widget.provider.getNhanVien(
                    idNhanVien: item!.idDonViDaiDien!,
                  )
                  : null,
          fieldName: 'representativeUnit',
          items: itemsNhanVien,
          onChanged: (value) {
            nguoiDaiDienDonViDaiDien = value;
          },
          validationErrors: _validationErrors,
        ),
        CommonCheckboxInput(
          label: 'Đơn vị Đại diện đã xác nhận',
          value: isRepresentativeUnitConfirm,
          isEditing: isEditing,
          isDisabled: true,
          onChanged: (newValue) {
            setState(() {
              isRepresentativeUnitConfirm = newValue;
            });
          },
        ),
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
      ngayBanGiao: _formatDate(controllerTransferDate.text),
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
      ngayTao: DateTime.now().toString(),
      ngayCapNhat: DateTime.now().toString(),
      nguoiTao: currentUser?.tenDangNhap ?? '',
      nguoiCapNhat: currentUser?.tenDangNhap ?? '',
      isActive: true,
    );
  }
}
