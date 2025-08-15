import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/input/common_checkbox_input.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/bloc/asset_group_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/bloc/asset_group_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/request/asset_group_request.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_event.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';

class RoleDto {
  final String id;
  final String name;
  RoleDto({required this.id, required this.name});
}

class AccountDetail extends StatefulWidget {
  final UserInfoDTO userInfo;
  final Function()? onPressedCancel;
  const AccountDetail({
    super.key,
    required this.userInfo,
    this.onPressedCancel,
  });

  @override
  State<AccountDetail> createState() => _AccountDetailState();
}

class _AccountDetailState extends State<AccountDetail> {
  AssetGroupDto? data;
  bool isEditing = false;
  bool isActive = false;
  String? nameAssetGroup;
  String idCongTy = 'ct001';
  DateTime? createdAt;
  List<DropdownMenuItem<RoleDto>> roleItems = [];
  List<RoleDto> role = [];
  RoleDto? roleSelected;

  TextEditingController ctrlIdAccount = TextEditingController();
  TextEditingController ctrlTenTk = TextEditingController();
  TextEditingController ctrlMatKhau = TextEditingController();
  TextEditingController ctrlHoTen = TextEditingController();
  TextEditingController ctrlEmail = TextEditingController();
  TextEditingController ctrlPhone = TextEditingController();
  TextEditingController ctrlRole = TextEditingController();
  TextEditingController ctrlNguoiTao = TextEditingController();
  TextEditingController ctrlNguoiCapNhat = TextEditingController();
  TextEditingController ctrlCongTy = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didUpdateWidget(covariant AccountDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userInfo != widget.userInfo) {
      log('message didUpdateWidget: ${widget.userInfo.toJson()}');
      _initData();
    }
  }

  @override
  void dispose() {
    ctrlIdAccount.dispose();
    ctrlTenTk.dispose();
    super.dispose();
  }

  _initData() {
    role = [
      RoleDto(id: '1', name: 'Admin công ty'),
      RoleDto(id: '2', name: 'Giám đốc'),
      RoleDto(id: '3', name: 'Quản đốc'),
      RoleDto(id: '4', name: 'Phó quản đốc'),
      RoleDto(id: '5', name: 'Phó giám đốc'),
      RoleDto(id: '6', name: 'Chánh văn phòng'),
      RoleDto(id: '7', name: 'Kế toán trưởng'),
      RoleDto(id: '8', name: 'Trưởng phòng'),
      RoleDto(id: '9', name: 'Phó phòng'),
      RoleDto(id: '10', name: 'Thống kê'),
      RoleDto(id: '11', name: 'Nhân viên kỹ thuật'),
      RoleDto(id: '12', name: 'Nhân viên'),
    ];
    roleItems = [
      for (var item in role)
        DropdownMenuItem(value: item, child: Text(item.name)),
    ];
    ctrlIdAccount.text = widget.userInfo.id;
    ctrlTenTk.text = widget.userInfo.tenDangNhap;
    ctrlMatKhau.text = widget.userInfo.matKhau;
    ctrlHoTen.text = widget.userInfo.hoTen;
    ctrlEmail.text = widget.userInfo.email ?? '';
    ctrlPhone.text = widget.userInfo.soDienThoai ?? '';
    ctrlRole.text = widget.userInfo.rule.toString();
    ctrlNguoiTao.text = widget.userInfo.nguoiTao;
    ctrlNguoiCapNhat.text = widget.userInfo.nguoiCapNhat ?? '';
    ctrlCongTy.text = widget.userInfo.idCongTy;
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
              // detail
              CommonFormInput(
                label: 'Mã tài khoản',
                controller: ctrlIdAccount,
                isEditing: false,
                textContent: ctrlIdAccount.text,
                onChanged: (value) {
                  // _checkForChanges();
                },
              ),
              CommonFormInput(
                label: 'Tên đăng nhập',
                controller: ctrlTenTk,
                isEditing: false,
                textContent: ctrlTenTk.text,
                onChanged: (value) {
                  // _checkForChanges();
                },
              ),
              CommonFormInput(
                label: 'Mật khẩu',
                controller: ctrlMatKhau,
                isEditing: true,
                textContent: ctrlMatKhau.text,
              ),
              CommonFormInput(
                label: 'Họ tên',
                controller: ctrlHoTen,
                isEditing: false,
                textContent: ctrlHoTen.text,
              ),
              CommonFormInput(
                label: 'Email',
                controller: ctrlEmail,
                isEditing: false,
                textContent: ctrlEmail.text,
              ),
              CommonFormInput(
                label: 'Số điện thoại',
                controller: ctrlPhone,
                isEditing: false,
                textContent: ctrlPhone.text,
              ),
              CommonFormInput(
                label: 'Số điện thoại',
                controller: ctrlPhone,
                isEditing: false,
                textContent: ctrlPhone.text,
              ),
              CmFormDropdownObject<RoleDto>(
                label: 'Vai trò',
                controller: ctrlRole,
                isEditing: true,
                items: roleItems,
                value: roleSelected,
                defaultValue:
                    ctrlRole.text.isNotEmpty
                        ? role.firstWhere(
                          (element) => element.id == ctrlRole.text,
                          orElse: () => role[0],
                        )
                        : role[0],
                onChanged: (value) {
                  setState(() {
                    roleSelected = value;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderDetail() {
    return Row(
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
          onPressed: widget.onPressedCancel,
        ),
      ],
    );
  }

  // void _cancelChanges() {
  //   log('message: _cancelChanges');
  // }
  void _saveChanges() {
    log('message: _saveChanges');
    final userInfo = widget.userInfo.copyWith(
      rule: int.parse(roleSelected?.id ?? '0'),
    );
    log('message: userInfo: ${jsonEncode(userInfo.toJson())}');
    showConfirmDialog(
      context,
      type: ConfirmType.add,
      title: 'Tạo account',
      message:
          'Bạn có chắc muốn tạo account cho nhân viên ${widget.userInfo.hoTen}',
      highlight: widget.userInfo.hoTen,
      cancelText: 'Không',
      confirmText: 'Tạo',
      onConfirm: () {
        context.read<LoginBloc>().add(CreateAccountEvent(userInfo));
        Navigator.pop(context);
      },
    );
  }

  void getRoleName() {
    setState(() {
      ctrlRole.text =
          role.firstWhere((element) => element.id == ctrlRole.text).name;
    });
  }

  // void getNameAssetGroup() {
  //   ctrlMatKhau.text = '${ctrlIdAccount.text} - ${ctrlTenTk.text}';
  //   // return;
  // }
}
