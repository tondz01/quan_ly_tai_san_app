// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/input/common_checkbox_input.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/bloc/role_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/bloc/role_event.dart';
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
    log('isQuanLyNhanVien: $isEditing');
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle(Icons.info_outline, 'Thông tin chức vụ'),
              const SizedBox(height: 16),
              // detail
              Row(
                spacing: 32,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controllerIdChucVu,
                      decoration: inputDecoration('Mã chức vụ', required: true),
                      enabled: isEditing, // Read-only khi update
                      validator:
                          (v) =>
                              v == null || v.isEmpty
                                  ? 'Nhập mã nhân viên'
                                  : null,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: controllerNameChucVu,
                      decoration: inputDecoration(
                        'Tên chức vụ',
                        required: true,
                      ),
                      enabled: isEditing, // Read-only khi update
                      validator:
                          (v) =>
                              v == null || v.isEmpty
                                  ? 'Nhập tên chức vụ'
                                  : null,
                    ),
                  ),
                ],
              ),
            ],
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
              sectionTitle(Icons.info_outline, 'Phân quyên quản lý'),
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
          label: "Quản lý CCDC vật tư",
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
          label: "Điều động tài sản",
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
          label: "Điều động CCDC vật tư",
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
          label: "Bán giao tài sản",
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
          label: "Bán giao CCDC vật tư",
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
          label: "Báo cáo",
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
          label: "Quản lý nhân viên",
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
          label: "Quản lý phòng ban",
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
          label: "Quản lý dự án",
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
          label: "Quản lý nguồn vốn",
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
          label: "Quản lý mô hình tài sản",
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
          label: "Quản lý nhóm tài sản",
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
          label: "Quản lý tài sản",
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

  InputDecoration inputDecoration(
    String label, {
    bool required = false,
    String? hint,
  }) {
    return InputDecoration(
      labelText: required ? '$label *' : label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _buildHeaderDetail() {
    return isEditing
        ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MaterialTextButton(
              text: 'Lưu',
              icon: Icons.save,
              backgroundColor: ColorValue.success,
              foregroundColor: Colors.white,
              onPressed: () {
                _saveChanges();
              },
            ),
            const SizedBox(width: 8),
            MaterialTextButton(
              text: 'Hủy',
              icon: Icons.cancel,
              backgroundColor: ColorValue.error,
              foregroundColor: Colors.white,
              onPressed: () {
                setState(() {
                  isEditing = false;
                });
              },
            ),
          ],
        )
        : MaterialTextButton(
          text: 'Chỉnh sửa nhóm tài sản',
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
      crossAxisAlignment: CrossAxisAlignment.start,
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

    log('ngayTao type: ${ngayTao.runtimeType}, value: $ngayTao');
    log('ngayCapNhat type: ${ngayCapNhat.runtimeType}, value: $ngayCapNhat');

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
    if (!_validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin bắt buộc'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final bloc = context.read<RoleBloc>();
    if (data == null) {
      final request = chucVuRequest();
      log('CreateRoleEvent request: ${request.toJson()}');
      bloc.add(CreateRoleEvent(request));
    } else {
      final request = chucVuRequest();
      ChucVu newRequest = data!.copyWith(
        idCongTy: data!.idCongTy,
        nguoiTao: data!.nguoiTao,
        ngayTao: data!.ngayTao,
        ngayCapNhat: DateTime.now().toString(),
        nguoiCapNhat: widget.provider.userInfo?.id ?? '',
      );
      log('UpdateRoleEvent request: ${request.toJson()}');
      bloc.add(UpdateRoleEvent(newRequest));
    }
  }

  bool _validateForm() {
    if (controllerIdChucVu.text.isEmpty) {
      return false;
    }
    if (controllerNameChucVu.text.isEmpty) {
      return false;
    }
    return true;
  }
}
