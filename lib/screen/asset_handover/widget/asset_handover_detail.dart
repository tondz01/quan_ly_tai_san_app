import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/component/preview_document_asset_handover.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/component/table_asset_movement_detail.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/asset_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/dieu_dong_tai_san_provider.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
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
  // late TextEditingController controllerLeader = TextEditingController();
  late TextEditingController controllerIssuingUnitRepresentative =
      TextEditingController();
  late TextEditingController controllerDelivererRepresentative =
      TextEditingController();
  late TextEditingController controllerReceiverRepresentative =
      TextEditingController();
  // late TextEditingController controllerRepresentativeUnit =
  //     TextEditingController();

  bool isEditing = false;
  bool isNew = false;
  UserInfoDTO? currentUser;

  bool isUnitConfirm = false;
  bool isDelivererConfirm = false;
  bool isReceiverConfirm = false;
  bool isRepresentativeUnitConfirm = false;
  bool isExpanded = false;

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
  // Danh sách người ký bổ sung và controller tương ứng
  final List<NhanVien?> _additionalSigners = [];
  final List<TextEditingController> _additionalSignerControllers = [];
  List<AdditionalSignerData> _additionalSignersDetailed = [];

  @override
  void initState() {
    setState(() {
      _initData();
      _updateControllers();
    });
    super.initState();
  }

  Future<void> _loadPdf(String path) async {
    final document = await PdfDocument.openFile(path);
    setState(() {
      _document = document;
    });
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
        (item!.trangThai == 0 || item!.trangThai == 2) &&
        item!.nguoiTao == currentUser?.tenDangNhap);
  }

  void _initData() {
    if (!mounted) return; // Kiểm tra nếu widget đã bị dispose
    isNew = widget.isFindNew;
    currentUser = AccountHelper.instance.getUserInfo();
    item = widget.provider.item;
    isEditing = widget.isEditing;

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

    if (item != null) {
      if (widget.isFindNew) {
        isEditing = widget.isFindNew;
      }
      isUnitConfirm = item?.daXacNhan ?? false;
      isDelivererConfirm = item?.daiDienBenGiaoXacNhan ?? false;
      isReceiverConfirm = item?.daiDienBenNhanXacNhan ?? false;
      _selectedFileName = item?.tenFile ?? '';
      _selectedFilePath = item?.duongDanFile ?? '';
      isRepresentativeUnitConfirm =
          item?.donViDaiDienXacNhan == "0" ? false : true;
      getStaffDonViGiaoAndNhan(item!.idDonViNhan!, item!.idDonViGiao!);
      _additionalSignersDetailed =
          item?.listSignatory
              ?.map(
                (e) => AdditionalSignerData(
                  employee: widget.provider.dataStaff?.firstWhere(
                    (element) => element.id == e.idNguoiKy,
                    orElse: () => NhanVien(),
                  ),
                ),
              )
              .toList() ??
          [];
      dieuDongTaiSan = listAssetTransfer.firstWhere(
        (element) => element.id == item?.lenhDieuDong,
        orElse: () => DieuDongTaiSanDto(),
      );
    } else {
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
    // if (controllerRepresentativeUnit.text.isEmpty) {
    //   newValidationErrors['representativeUnit'] = true;
    // }

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

  Future<void> _saveAssetHandover() async {
    if (!mounted) return;
    final assetHandoverProvider = context.read<AssetHandoverProvider>();
    final dieuDongProvider = context.read<DieuDongTaiSanProvider>();
    final assetHandoverBloc = context.read<AssetHandoverBloc>();

    assetHandoverProvider.isLoading = true;

    DateTime ngaybangiao = DateFormat(
      "dd/MM/yyyy HH:mm:ss",
    ).parse(controllerTransferDate.text);

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
      "ngayBanGiao": ngaybangiao.toIso8601String(),
      "ngayTao": DateTime.now().toIso8601String(),
      "ngayCapNhat": DateTime.now().toIso8601String(),
      "trangThai": 0,
      "note": "",
      "nguoiTao": currentUser?.tenDangNhap ?? '',
      "isActive": true,
      "share": false,
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

    if (item == null || isNew) {
      log('message test 2: Create');
      Map<String, dynamic>? result = await dieuDongProvider.uploadWordDocument(
        context,
        _selectedFileName ?? '',
        _selectedFilePath ?? '',
        _selectedFileBytes ?? Uint8List(0),
      );
      final newRequest = request;
      log('message test 2: ${result}');
      newRequest['duongDanFile'] = result!['filePath'] ?? '';
      newRequest['tenFile'] = result['fileName'] ?? '';
      assetHandoverBloc.add(
        CreateAssetHandoverEvent(newRequest, listSignatory),
      );
    } else {
      log('message test 2: update');
      int trangThai = item!.trangThai == 2 ? 0 : item!.trangThai!;
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
      assetHandoverBloc.add(
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

  // String _formatDate(String date) {
  //   String dateResult = "";
  //   try {
  //     if (date.isNotEmpty) {
  //       if (date.contains("T")) {
  //         dateResult = date;
  //       } else {
  //         List<String> dateParts = date.split('/');
  //         if (dateParts.length == 3) {
  //           DateTime date = DateTime(
  //             int.parse(dateParts[2]),
  //             int.parse(dateParts[1]),
  //             int.parse(dateParts[0]),
  //           );
  //           dateResult = date.toIso8601String();
  //         } else {
  //           DateTime? parsedDate = DateTime.tryParse(date);
  //           if (parsedDate != null) {
  //             dateResult = parsedDate.toIso8601String();
  //           }
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     dateResult = DateTime.now().toIso8601String();
  //   }
  //   return dateResult;
  // }

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
                      _loadPdf(filePath!);
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
                visible: dieuDongTaiSan != null,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: TableAssetMovementDetail(
                    listDetailAssetMobilization:
                        widget.provider.dataDetailAssetMobilization,
                  ),
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
      ],
    );
  }

  Widget _buildAssetHandoverDetail() {
    return Column(
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
        AdditionalSignersSelector(
          addButtonText: "Thêm đơn bị đại diện",
          labelDepartment: "Đơn vị đại diện",
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
      donViDaiDienXacNhan: nguoiDaiDienDonViDaiDien?.id ?? '',
      trangThai: 1,
      note: '',
      ngayTao: DateTime.now().toString(),
      ngayCapNhat: DateTime.now().toString(),
      nguoiTao: currentUser?.id ?? '',
      nguoiCapNhat: currentUser?.id ?? '',
      isActive: true,
    );
  }
}
