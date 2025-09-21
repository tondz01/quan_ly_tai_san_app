import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';

class AccountEditPopup extends StatefulWidget {
  final UserInfoDTO userInfo;
  final List<RoleDto> roles;
  final void Function(UserInfoDTO)? onSave;
  final VoidCallback? onCancel;

  const AccountEditPopup({
    super.key,
    required this.userInfo,
    required this.roles,
    this.onSave,
    this.onCancel,
  });

  @override
  State<AccountEditPopup> createState() => _AccountEditPopupState();
}

class _AccountEditPopupState extends State<AccountEditPopup> {
  late TextEditingController ctrlIdAccount;
  late TextEditingController ctrlTenTk;
  late TextEditingController ctrlMatKhau;
  late TextEditingController ctrlHoTen;
  late TextEditingController ctrlEmail;
  late TextEditingController ctrlPhone;
  late TextEditingController ctrlRole;
  late TextEditingController ctrlNguoiTao;
  late TextEditingController ctrlNguoiCapNhat;
  late TextEditingController ctrlCongTy;
  RoleDto? roleSelected;
  late List<DropdownMenuItem<RoleDto>> roleItems;

  @override
  void initState() {
    super.initState();
    final u = widget.userInfo;
    ctrlIdAccount = TextEditingController(text: u.id);
    ctrlTenTk = TextEditingController(text: u.username ?? '');
    ctrlMatKhau = TextEditingController(text: u.matKhau);
    ctrlHoTen = TextEditingController(text: u.hoTen);
    ctrlEmail = TextEditingController(text: u.email ?? '');
    ctrlPhone = TextEditingController(text: u.soDienThoai ?? '');
    ctrlRole = TextEditingController(text: u.rule.toString());
    ctrlNguoiTao = TextEditingController(text: u.nguoiTao);
    ctrlNguoiCapNhat = TextEditingController(text: u.nguoiCapNhat ?? '');
    ctrlCongTy = TextEditingController(text: u.idCongTy);
    roleSelected = widget.roles.firstWhere(
      (r) => r.id == u.rule.toString(),
      orElse: () => widget.roles[0],
    );
    roleItems = [
      for (var item in widget.roles)
        DropdownMenuItem(value: item, child: Text(item.name)),
    ];
  }

  @override
  void dispose() {
    ctrlIdAccount.dispose();
    ctrlTenTk.dispose();
    ctrlMatKhau.dispose();
    ctrlHoTen.dispose();
    ctrlEmail.dispose();
    ctrlPhone.dispose();
    ctrlRole.dispose();
    ctrlNguoiTao.dispose();
    ctrlNguoiCapNhat.dispose();
    ctrlCongTy.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        constraints: BoxConstraints(
          minWidth: 450,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle('Sửa thông tin tài khoản'),
            SizedBox(width: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: Column(
                    children: [
                      _buildTitle('Thông tin tài khoản'),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CommonFormInput(
                              label: 'Tên đăng nhập',
                              controller: ctrlTenTk,
                              isEditing: true,
                              textContent: ctrlTenTk.text,
                              isRequired: true,
                            ),
                          ),
                          Expanded(
                            child: CommonFormInput(
                              label: 'Mật khẩu',
                              controller: ctrlMatKhau,
                              isEditing: true,
                              textContent: ctrlMatKhau.text,
                            ),
                          ),
                        ],
                      ),
                      CmFormDropdownObject<RoleDto>(
                        label: 'Vai trò',
                        controller: ctrlRole,
                        isEditing: true,
                        items: roleItems,
                        value: roleSelected,
                        defaultValue: roleSelected,
                        onChanged: (value) {
                          setState(() {
                            roleSelected = value;
                            ctrlRole.text = value.id;
                          });
                        },
                      ),
                      _buildTitle('Thông tin nhân viên'),
                      SizedBox(height: 16),
                      CommonFormInput(
                        label: 'Mã tài khoản',
                        controller: ctrlIdAccount,
                        isEditing: false,
                        textContent: ctrlIdAccount.text,
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
                        label: 'Người tạo',
                        controller: ctrlNguoiTao,
                        isEditing: false,
                        textContent: ctrlNguoiTao.text,
                      ),
                      CommonFormInput(
                        label: 'Công ty',
                        controller: ctrlCongTy,
                        isEditing: false,
                        textContent: ctrlCongTy.text,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialTextButton(
                  text: 'Lưu',
                  icon: Icons.save,
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    final updatedUser = widget.userInfo.copyWith(
                      username: ctrlTenTk.text,
                      matKhau: ctrlMatKhau.text,
                      rule: int.tryParse(ctrlRole.text) ?? widget.userInfo.rule,
                    );
                    widget.onSave?.call(updatedUser);
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 8),
                MaterialTextButton(
                  text: 'Hủy',
                  icon: Icons.cancel,
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    widget.onCancel?.call();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildTitle(String title) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SGText(
        text: title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ColorValue.oceanBlue,
        ),
      ),
      Divider(color: Colors.grey.shade300),
    ],
  );
}

// Helper function để show popup
void showAccountEditPopup({
  required BuildContext context,
  required UserInfoDTO userInfo,
  required List<RoleDto> roles,
  void Function(UserInfoDTO)? onSave,
  VoidCallback? onCancel,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => AccountEditPopup(
          userInfo: userInfo,
          roles: roles,
          onSave: onSave,
          onCancel: onCancel,
        ),
  );
}
