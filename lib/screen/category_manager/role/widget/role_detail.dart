// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/input/common_checkbox_input.dart';
import 'package:quan_ly_tai_san_app/common/widgets/input_decoration_custom.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/bloc/role_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/bloc/role_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/constants/role_constants.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/model/chuc_vu.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/provider/role_provide.dart';

class RoleDetail extends StatefulWidget {
  final RoleProvider provider;
  final bool? isEditing;

  const RoleDetail({super.key, this.isEditing = false, required this.provider});

  @override
  State<RoleDetail> createState() => _RoleDetailState();
}

class _RoleDetailState extends State<RoleDetail> {
  // Form key để validate
  final _formKey = GlobalKey<FormState>();

  // Các controller để quản lý dữ liệu nhập liệu
  late TextEditingController controllerIdChucVu = TextEditingController();
  late TextEditingController controllerNameChucVu = TextEditingController();

  bool isQuanLyNhanVien = false;
  bool isQuanLyPhongBan = false;
  bool isQuanLyDuAn = false;
  bool isQuanLyNguonVon = false;
  bool isQuanLyMoHinhTaiSan = false;
  bool isQuanLyNhomTaiSan = false;
  bool isQuanLyTaiSan = false;
  bool isQuanLyCCDCVatTu = false;
  bool isDieuDongTaiSan = false;
  bool isDieuDongCCDCVatTu = false;
  bool isBanGiaoTaiSan = false;
  bool isBanGiaoCCDCVatTu = false;
  bool isBaoCao = false;
  bool isEditing = false;

  ChucVu? data;

  @override
  void initState() {
    super.initState();
    isEditing = widget.isEditing ?? false;
    initData();
  }

  @override
  void didUpdateWidget(RoleDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.provider.data != data) {
      initData();
    }
  }

  @override
  void dispose() {
    controllerIdChucVu.dispose();
    controllerNameChucVu.dispose();
    super.dispose();
  }

  initData() {
    data = widget.provider.dataDetail;
    if (data != null) {
      isEditing = false;
      controllerIdChucVu.text = data?.id ?? '';
      controllerNameChucVu.text = data?.tenChucVu ?? '';
      isQuanLyNhanVien = data?.quanLyNhanVien ?? false;
      isQuanLyPhongBan = data?.quanLyPhongBan ?? false;
      isQuanLyDuAn = data?.quanLyDuAn ?? false;
      isQuanLyNguonVon = data?.quanLyNguonVon ?? false;
      isQuanLyMoHinhTaiSan = data?.quanLyMoHinhTaiSan ?? false;
      isQuanLyNhomTaiSan = data?.quanLyNhomTaiSan ?? false;
      isQuanLyTaiSan = data?.quanLyTaiSan ?? false;
      isQuanLyCCDCVatTu = data?.quanLyCCDCVatTu ?? false;
      isDieuDongTaiSan = data?.dieuDongTaiSan ?? false;
      isDieuDongCCDCVatTu = data?.dieuDongCCDCVatTu ?? false;
      isBanGiaoTaiSan = data?.banGiaoTaiSan ?? false;
      isBanGiaoCCDCVatTu = data?.banGiaoCCDCVatTu ?? false;
      isBaoCao = data?.baoCao ?? false;
    } else {
      // Không thay đổi isEditing khi data là null
      isEditing = true;
      controllerIdChucVu.clear();
      controllerNameChucVu.clear();
      isQuanLyNhanVien = false;
      isQuanLyPhongBan = false;
      isQuanLyDuAn = false;
      isQuanLyNguonVon = false;
      isQuanLyMoHinhTaiSan = false;
      isQuanLyNhomTaiSan = false;
      isQuanLyTaiSan = false;
      isQuanLyCCDCVatTu = false;
      isDieuDongTaiSan = false;
      isDieuDongCCDCVatTu = false;
      isBanGiaoTaiSan = false;
      isBanGiaoCCDCVatTu = false;
      isBaoCao = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: _buildHeaderDetail(),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle(Icons.info_outline, RoleConstants.sectionRoleInfo),
                const SizedBox(height: 16),
                // detail
                Row(
                  spacing: 32,
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: !isEditing,
                        controller: controllerIdChucVu,
                        decoration: inputDecoration(
                          'Mã chức vụ',
                          required: true,
                        ),
                        enabled:
                            isEditing
                                ? data == null
                                : false, // Read-only khi update
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return RoleConstants.validationRoleIdRequired;
                          }
                          return null;
                        },
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        readOnly: !isEditing,
                        controller: controllerNameChucVu,
                        decoration: inputDecoration(
                          'Tên chức vụ',
                          required: true,
                        ),
                        enabled: isEditing, // Read-only khi update
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return RoleConstants.validationRoleNameRequired;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              sectionTitle(
                Icons.info_outline,
                RoleConstants.sectionPermissions,
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 32,
                children: [
                  Expanded(child: _builEditRoleLeft()),
                  Expanded(child: _buildEditRoleRight()),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _buildEditRoleRight() {
    return Column(
      children: [
        CommonCheckboxInput(
          label: RoleConstants.permissionManageSupplies,
          value: isQuanLyCCDCVatTu,
          isEditing: isEditing,
          isDisabled: !isEditing,
          onChanged: (value) {
            setState(() {
              isQuanLyCCDCVatTu = value;
            });
          },
        ),
        const SizedBox(height: 16),
        CommonCheckboxInput(
          label: RoleConstants.permissionTransferAsset,
          value: isDieuDongTaiSan,
          isEditing: isEditing,
          isDisabled: !isEditing,
          onChanged: (value) {
            setState(() {
              isDieuDongTaiSan = value;
            });
          },
        ),
        const SizedBox(height: 16),
        CommonCheckboxInput(
          label: RoleConstants.permissionTransferSupplies,
          value: isDieuDongCCDCVatTu,
          isEditing: isEditing,
          isDisabled: !isEditing,
          onChanged: (value) {
            setState(() {
              isDieuDongCCDCVatTu = value;
            });
          },
        ),
        const SizedBox(height: 16),
        CommonCheckboxInput(
          label: RoleConstants.permissionHandoverAsset,
          value: isBanGiaoTaiSan,
          isEditing: isEditing,
          isDisabled: !isEditing,
          onChanged: (value) {
            setState(() {
              isBanGiaoTaiSan = value;
            });
          },
        ),
        const SizedBox(height: 16),
        CommonCheckboxInput(
          label: RoleConstants.permissionHandoverSupplies,
          value: isBanGiaoCCDCVatTu,
          isEditing: isEditing,
          isDisabled: !isEditing,
          onChanged: (value) {
            setState(() {
              isBanGiaoCCDCVatTu = value;
            });
          },
        ),
        const SizedBox(height: 16),
        CommonCheckboxInput(
          label: RoleConstants.permissionReport,
          value: isBaoCao,
          isEditing: isEditing,
          isDisabled: !isEditing,
          onChanged: (value) {
            setState(() {
              isBaoCao = value;
            });
          },
        ),
      ],
    );
  }

  Column _builEditRoleLeft() {
    return Column(
      children: [
        CommonCheckboxInput(
          label: RoleConstants.permissionManageStaff,
          value: isQuanLyNhanVien,
          isEditing: isEditing,
          isDisabled: !isEditing,
          onChanged: (value) {
            setState(() {
              isQuanLyNhanVien = value;
            });
          },
        ),
        const SizedBox(height: 16),
        CommonCheckboxInput(
          label: RoleConstants.permissionManageDepartment,
          value: isQuanLyPhongBan,
          isEditing: isEditing,
          isDisabled: !isEditing,
          onChanged: (value) {
            setState(() {
              isQuanLyPhongBan = value;
            });
          },
        ),
        const SizedBox(height: 16),
        CommonCheckboxInput(
          label: RoleConstants.permissionManageProject,
          value: isQuanLyDuAn,
          isEditing: isEditing,
          isDisabled: !isEditing,
          onChanged: (value) {
            setState(() {
              isQuanLyDuAn = value;
            });
          },
        ),
        const SizedBox(height: 16),
        CommonCheckboxInput(
          label: RoleConstants.permissionManageFund,
          value: isQuanLyNguonVon,
          isEditing: isEditing,
          isDisabled: !isEditing,
          onChanged: (value) {
            setState(() {
              isQuanLyNguonVon = value;
            });
          },
        ),
        const SizedBox(height: 16),
        CommonCheckboxInput(
          label: RoleConstants.permissionManageAssetModel,
          value: isQuanLyMoHinhTaiSan,
          isEditing: isEditing,
          isDisabled: !isEditing,
          onChanged: (value) {
            setState(() {
              isQuanLyMoHinhTaiSan = value;
            });
          },
        ),
        const SizedBox(height: 16),
        CommonCheckboxInput(
          label: RoleConstants.permissionManageAssetGroup,
          value: isQuanLyNhomTaiSan,
          isEditing: isEditing,
          isDisabled: !isEditing,
          onChanged: (value) {
            setState(() {
              isQuanLyNhomTaiSan = value;
            });
          },
        ),
        const SizedBox(height: 16),
        CommonCheckboxInput(
          label: RoleConstants.permissionManageAsset,
          value: isQuanLyTaiSan,
          isEditing: isEditing,
          isDisabled: !isEditing,
          onChanged: (value) {
            setState(() {
              isQuanLyTaiSan = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildHeaderDetail() {
    return isEditing
        ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MaterialTextButton(
              text: RoleConstants.saveText,
              icon: Icons.save,
              backgroundColor: ColorValue.success,
              foregroundColor: Colors.white,
              onPressed: () {
                setState(() {
                  _saveChanges();
                });
              },
            ),
            const SizedBox(width: 8),
            MaterialTextButton(
              text: RoleConstants.cancelText,
              icon: Icons.cancel,
              backgroundColor: ColorValue.error,
              foregroundColor: Colors.white,
              onPressed: () {
                setState(() {
                  isEditing = false;
                  if (widget.provider.dataDetail == null) {
                    widget.provider.onCloseDetail(context);
                  }
                });
              },
            ),
          ],
        )
        : MaterialTextButton(
          text: RoleConstants.editText,
          icon: Icons.save,
          backgroundColor: ColorValue.success,
          foregroundColor: Colors.white,
          onPressed: () {
            setState(() {
              isEditing = true;
            });
          },
        );
  }

  Widget sectionTitle(IconData icon, String title, [String? desc]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 12, top: 2),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF1FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF7B8EC8), size: 24),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            if (desc != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  desc,
                  style: const TextStyle(
                    color: Color(0xFF687082),
                    fontSize: 13,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  ChucVu chucVuRequest() {
    final ngayTao = DateTime.now().toString();
    final ngayCapNhat = DateTime.now().toString();

    return ChucVu(
      id: controllerIdChucVu.text,
      tenChucVu: controllerNameChucVu.text,
      quanLyNhanVien: isQuanLyNhanVien,
      quanLyDuAn: isQuanLyDuAn,
      quanLyNguonVon: isQuanLyNguonVon,
      quanLyMoHinhTaiSan: isQuanLyMoHinhTaiSan,
      quanLyNhomTaiSan: isQuanLyNhomTaiSan,
      quanLyTaiSan: isQuanLyTaiSan,
      quanLyCCDCVatTu: isQuanLyCCDCVatTu,
      dieuDongTaiSan: isDieuDongTaiSan,
      dieuDongCCDCVatTu: isDieuDongCCDCVatTu,
      banGiaoTaiSan: isBanGiaoTaiSan,
      banGiaoCCDCVatTu: isBanGiaoCCDCVatTu,
      baoCao: isBaoCao,
      quanLyPhongBan: isQuanLyPhongBan,
      idCongTy: widget.provider.userInfo?.idCongTy ?? '',
      ngayTao: ngayTao,
      ngayCapNhat: ngayCapNhat,
      nguoiTao: widget.provider.userInfo?.id ?? '',
      nguoiCapNhat: widget.provider.userInfo?.id ?? '',
    );
  }

  void _saveChanges() {
    // Validate form trước khi lưu
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(RoleConstants.validationFormIncomplete),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final bloc = context.read<RoleBloc>();
    if (data == null) {
      final request = chucVuRequest();
      bloc.add(CreateRoleEvent(request));
    } else {
      ChucVu newRequest = data!.copyWith(
        tenChucVu: controllerNameChucVu.text,
        quanLyNhanVien: isQuanLyNhanVien,
        quanLyPhongBan: isQuanLyPhongBan,
        quanLyDuAn: isQuanLyDuAn,
        quanLyNguonVon: isQuanLyNguonVon,
        quanLyMoHinhTaiSan: isQuanLyMoHinhTaiSan,
        quanLyNhomTaiSan: isQuanLyNhomTaiSan,
        quanLyTaiSan: isQuanLyTaiSan,
        quanLyCCDCVatTu: isQuanLyCCDCVatTu,
        dieuDongTaiSan: isDieuDongTaiSan,
        dieuDongCCDCVatTu: isDieuDongCCDCVatTu,
        banGiaoTaiSan: isBanGiaoTaiSan,
        banGiaoCCDCVatTu: isBanGiaoCCDCVatTu,
        baoCao: isBaoCao,
        idCongTy: data!.idCongTy,
        nguoiTao: data!.nguoiTao,
        ngayTao: data!.ngayTao,
        ngayCapNhat: DateTime.now().toString(),
        nguoiCapNhat: widget.provider.userInfo?.id ?? '',
      );
      bloc.add(UpdateRoleEvent(newRequest));
    }
  }
}
