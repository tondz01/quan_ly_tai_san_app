import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/input/common_checkbox_input.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_date.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/common/page/common_contract.dart';
import 'package:quan_ly_tai_san_app/common/page/contract_page.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/component/table_asset_movement_detail.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/asset_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:se_gay_components/common/sg_indicator.dart';
import 'package:se_gay_components/common/sg_text.dart';

class AssetHandoverDetail extends StatefulWidget {
  final AssetHandoverProvider provider;
  final bool isEditing;
  final bool isNew;

  const AssetHandoverDetail({super.key, this.isEditing = false, this.isNew = false, required this.provider});

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
  late TextEditingController controllerIssuingUnitRepresentative = TextEditingController();
  late TextEditingController controllerDelivererRepresentative = TextEditingController();
  late TextEditingController controllerReceiverRepresentative = TextEditingController();
  late TextEditingController controllerRepresentativeUnit = TextEditingController();

  bool isEditing = false;

  bool isUnitConfirm = false;
  bool isDelivererConfirm = false;
  bool isReceiverConfirm = false;
  bool isRepresentativeUnitConfirm = false;
  bool isExpanded = false;

  String? proposingUnit;

  AssetHandoverDto? item;

  List<PhongBan> listPhongBan = [];
  List<NhanVien> listNhanVien = [];
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

  @override
  void initState() {
    _initData();

    super.initState();
  }

  @override
  void didUpdateWidget(AssetHandoverDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Kiểm tra nếu có thay đổi trong item hoặc isEditing
    if (oldWidget.provider.item != item || oldWidget.isEditing != widget.isEditing) {
      // Cập nhật lại trạng thái editing
      if (mounted) {
        _initData();
        setState(() {});
      }
    }
  }

  void _initData() {
    if (!mounted) return; // Kiểm tra nếu widget đã bị dispose

    item = widget.provider.item;
    isEditing = widget.isEditing;
    if (item != null) {
      if (item!.trangThai == 0) {
        isEditing = true;
      }
    } else {
      isEditing = true;
    }

    isUnitConfirm = item?.daXacNhan ?? false;
    isDelivererConfirm = item?.daiDienBenGiaoXacNhan ?? false;
    isReceiverConfirm = item?.daiDienBenNhanXacNhan ?? false;
    isRepresentativeUnitConfirm = item?.donViDaiDienXacNhan == "0" ? true : false;

    listNhanVien = widget.provider.dataStaff ?? [];
    listPhongBan = widget.provider.dataDepartment ?? [];
    listAssetTransfer = widget.provider.dataAssetTransfer ?? [];

    itemsNhanVien =
        listNhanVien.isNotEmpty
            ? listNhanVien
                .map((user) => DropdownMenuItem<NhanVien>(value: user, child: Text(user.hoTen ?? '')))
                .toList()
            : <DropdownMenuItem<NhanVien>>[];

    itemsPhongBan =
        listPhongBan.isNotEmpty
            ? listPhongBan
                .map((user) => DropdownMenuItem<PhongBan>(value: user, child: Text(user.tenPhongBan ?? '')))
                .toList()
            : <DropdownMenuItem<PhongBan>>[];
    itemsAssetTransfer =
        listAssetTransfer.isNotEmpty
            ? listAssetTransfer
                .map(
                  (assetTransfer) => DropdownMenuItem<DieuDongTaiSanDto>(
                    value: assetTransfer,
                    child: Text(assetTransfer.tenPhieu ?? ''),
                  ),
                )
                .toList()
            : <DropdownMenuItem<DieuDongTaiSanDto>>[];

    // Cập nhật controllers với dữ liệu mới
    _updateControllers();

    // Lưu giá trị ban đầu để so sánh
    // _saveOriginalValues();
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
      setState(() {
        _validationErrors = newValidationErrors;
      });
    }

    return newValidationErrors.isEmpty;
  }

  void _updateControllers() {
    if (!mounted) return; // Kiểm tra nếu widget đã bị dispose

    controllerHandoverNumber.text = item?.id ?? '';
    controllerDocumentName.text = item?.banGiaoTaiSan ?? '';
    controllerOrder.text = item?.lenhDieuDong ?? '';
    controllerSenderUnit.text = item?.tenDonViGiao ?? '';
    controllerReceiverUnit.text = item?.tenDonViNhan ?? '';
    controllerTransferDate.text = item?.ngayBanGiao ?? '';
    controllerLeader.text = item?.tenLanhDao ?? '';
    controllerIssuingUnitRepresentative.text = item?.tenDaiDienBanHanhQD ?? '';
    controllerDelivererRepresentative.text = item?.tenDaiDienBenGiao ?? '';
    controllerReceiverRepresentative.text = item?.tenDaiDienBenNhan ?? '';
    controllerRepresentativeUnit.text = item?.tenDonViDaiDien ?? '';
  }

  void _saveOriginalValues() {
    UserInfoDTO? currentUser = AccountHelper.instance.getUserInfo();

    String ngayBanGiao = "";
    try {
      if (controllerTransferDate.text.isNotEmpty) {
        // Nếu đã có định dạng ISO 8601 thì giữ nguyên
        if (controllerTransferDate.text.contains("T")) {
          ngayBanGiao = controllerTransferDate.text;
        } else {
          // Nếu là định dạng dd/MM/yyyy thì chuyển sang ISO 8601
          List<String> dateParts = controllerTransferDate.text.split('/');
          if (dateParts.length == 3) {
            DateTime date = DateTime(
              int.parse(dateParts[2]), // năm
              int.parse(dateParts[1]), // tháng
              int.parse(dateParts[0]), // ngày
            );
            ngayBanGiao = date.toIso8601String();
          } else {
            // Nếu không phải định dạng dd/MM/yyyy thì thử parse trực tiếp
            DateTime? parsedDate = DateTime.tryParse(controllerTransferDate.text);
            if (parsedDate != null) {
              ngayBanGiao = parsedDate.toIso8601String();
            }
          }
        }
      }
    } catch (e) {
      // Nếu có lỗi khi parse ngày thì sử dụng ngày hiện tại
      ngayBanGiao = DateTime.now().toIso8601String();
    }

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
      "trangThai": 0,
      "note": "",
      "ngayTao": DateTime.now().toIso8601String(),
      "ngayCapNhat": DateTime.now().toIso8601String(),
      "nguoiTao": currentUser?.hoTen ?? '',
      "nguoiCapNhat": currentUser?.hoTen ?? '',
      "isActive": true,
    };

    context.read<AssetHandoverBloc>().add(CreateAssetHandoverEvent(context, request));

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Vui lòng điền đầy đủ thông tin bắt buộc'), backgroundColor: Colors.red));
      return;
    }
    _saveOriginalValues();
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

  PhongBan getPhongBan({required List<PhongBan> listPhongBan, required String idPhongBan}) {
    final found = listPhongBan.where((item) => item.id == idPhongBan);
    if (found.isEmpty) {
      return PhongBan();
    }
    return found.first;
  }

  NhanVien getNhanVien({required List<NhanVien> listNhanVien, required String idNhanVien}) {
    final found = listNhanVien.where((item) => item.id == idNhanVien);
    if (found.isEmpty) {
      return NhanVien();
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
    return BlocListener<AssetHandoverBloc, AssetHandoverState>(
      listener: (context, state) {
        if (state is CreateAssetHandoverSuccessState) {
          // Hiển thị thông báo thành công
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Tạo biên bản bàn giao thành công'), backgroundColor: Colors.green));

          // Cập nhật lại danh sách dữ liệu
          context.read<AssetHandoverBloc>().add(GetListAssetHandoverEvent(context));

          // Đóng form chi tiết và quay lại danh sách
          widget.provider.isShowInput = false;
        } else if (state is CreateAssetHandoverFailedState) {
          // Hiển thị thông báo lỗi
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Lỗi: ${state.message}'), backgroundColor: Colors.red));
        }
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(padding: const EdgeInsets.only(top: 10.0), child: _buildTableDetail()),
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
            if (isEditing)
              Row(
                children: [
                  if (widget.provider.hasUnsavedChanges)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(4)),
                      child: const Text('Có thay đổi chưa lưu', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    child: const Text('Lưu'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _cancelChanges,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey, foregroundColor: Colors.white),
                    child: const Text('Hủy'),
                  ),
                ],
              ),
            SgIndicator(
              steps: ['Nháp', 'Sẵn sàng', 'Xác nhận', 'Trình duyệt', 'Hoàn thành', 'Hủy'],
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
              if (!isEditing)
                Padding(padding: const EdgeInsets.only(bottom: 20), child: TableAssetMovementDetail(item: null)),
              previewDocumentAssetTransfer(item),
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
      return Column(children: [_buildInfoAssetHandover(), _buildAssetHandoverDetail()]);
    }
  }

  Widget _buildInfoAssetHandover() {
    DateTime? ngayBanGiao;
    return Column(
      children: [
        CommonFormInput(
          label: 'Số phiếu bàn giao',
          controller: controllerHandoverNumber,
          isEditing: isEditing,
          textContent: '',
          onChanged: (value) {},
          validationErrors: _validationErrors,
        ),
        CommonFormInput(
          label: 'Bàn giao tài sản',
          controller: controllerDocumentName,
          isEditing: isEditing,
          textContent: item?.banGiaoTaiSan ?? '',
          onChanged: (value) {},
          validationErrors: _validationErrors,
        ),

        CmFormDropdownObject<DieuDongTaiSanDto>(
          label: 'Lệnh điều động',
          controller: controllerOrder,
          isEditing: isEditing,
          defaultValue:
              controllerOrder.text.isNotEmpty
                  ? getAssetTransfer(listAssetTransfer: listAssetTransfer, idAssetTransfer: controllerOrder.text)
                  : null,
          fieldName: 'order',
          items: itemsAssetTransfer,
          onChanged: (value) {
            dieuDongTaiSan = value;
          },
          validationErrors: _validationErrors,
        ),
        CmFormDropdownObject<PhongBan>(
          label: 'Đơn vị giao',
          controller: controllerSenderUnit,
          isEditing: isEditing,
          defaultValue:
              controllerSenderUnit.text.isNotEmpty
                  ? getPhongBan(listPhongBan: listPhongBan, idPhongBan: controllerSenderUnit.text)
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
          isEditing: isEditing,
          defaultValue:
              controllerReceiverUnit.text.isNotEmpty
                  ? getPhongBan(listPhongBan: listPhongBan, idPhongBan: controllerReceiverUnit.text)
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
        ),
        CmFormDropdownObject<NhanVien>(
          label: 'Lãnh đạo',
          controller: controllerLeader,
          isEditing: isEditing,
          defaultValue:
              controllerLeader.text.isNotEmpty
                  ? getNhanVien(listNhanVien: listNhanVien, idNhanVien: controllerLeader.text)
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
              controllerIssuingUnitRepresentative.text.isNotEmpty
                  ? getNhanVien(listNhanVien: listNhanVien, idNhanVien: controllerIssuingUnitRepresentative.text)
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
          isEditing: isEditing,
          onChanged: (newValue) {
            setState(() {
              isUnitConfirm = newValue;
            });
          },
          isDisabled: !isEditing,
        ),
        CmFormDropdownObject<NhanVien>(
          label: 'Đại diện bên giao',
          controller: controllerDelivererRepresentative,
          isEditing: isEditing,
          defaultValue:
              controllerDelivererRepresentative.text.isNotEmpty
                  ? getNhanVien(listNhanVien: listNhanVien, idNhanVien: controllerDelivererRepresentative.text)
                  : null,
          fieldName: 'delivererRepresentative',
          items: itemsNhanVien,
          onChanged: (value) {
            nguoiDaiDienBenGiao = value;
          },
          validationErrors: _validationErrors,
        ),
        CommonCheckboxInput(
          label: 'Đại diện bên giao Đã xác nhận',
          value: isDelivererConfirm,
          isEditing: isEditing,
          isDisabled: !isEditing,
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
              controllerReceiverRepresentative.text.isNotEmpty
                  ? getNhanVien(listNhanVien: listNhanVien, idNhanVien: controllerReceiverRepresentative.text)
                  : null,
          fieldName: 'receiverRepresentative',
          items: itemsNhanVien,
          onChanged: (value) {
            nguoiDaiDienBenNhan = value;
          },
          validationErrors: _validationErrors,
        ),
        CommonCheckboxInput(
          label: 'Đại diện bên nhận Đã xác nhận',
          value: isReceiverConfirm,
          isEditing: isEditing,
          isDisabled: !isEditing,
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
              controllerRepresentativeUnit.text.isNotEmpty
                  ? getNhanVien(listNhanVien: listNhanVien, idNhanVien: controllerRepresentativeUnit.text)
                  : null,
          fieldName: 'representativeUnit',
          items: itemsNhanVien,
          onChanged: (value) {
            nguoiDaiDienDonViDaiDien = value;
          },
          validationErrors: _validationErrors,
        ),
        CommonCheckboxInput(
          label: 'Đơn vị Đại diện Đã xác nhận',
          value: isRepresentativeUnitConfirm,
          isEditing: isEditing,
          isDisabled: !isEditing,
          onChanged: (newValue) {
            setState(() {
              isRepresentativeUnitConfirm = newValue;
            });
          },
        ),
      ],
    );
  }

  Widget previewDocumentAssetTransfer(AssetHandoverDto? item) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder:
              (context) => CommonContract(
                contractType: ContractPage.assetHandoverPage(item!),
                signatureList: [
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTe8wBK0d0QukghPwb_8QvKjEzjtEjIszRwbA&s',
                ],
                idTaiLieu: item.id.toString(),
                idNguoiKy: 'admin',
                tenNguoiKy: "Do Thanh Ton",
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
