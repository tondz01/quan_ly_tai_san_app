// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/button/action_button_config.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_event.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/provider/login_provider.dart';
import 'package:quan_ly_tai_san_app/screen/login/widget/account_edit_popup.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/switch/sg_checkbox.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class AccountList extends StatefulWidget {
  final LoginProvider provider;
  const AccountList({super.key, required this.provider});

  @override
  State<AccountList> createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  final ScrollController horizontalController = ScrollController();
  String searchTerm = "";

  List<UserInfoDTO> selectedItems = [];

  // Column display options
  late List<ColumnDisplayOption> columnOptions;

  List<String> visibleColumnIds = [
    'tenDangNhap',
    'hoTen',
    'email',
    'soDienThoai',
    'ngayTao',
    'ngayCapNhat',
    'nguoiTao',
    'nguoiCapNhat',
    'idCongTy',
    'rule',
    'actions',
    // 'created_at',
    // 'updated_at',
    // 'created_by',
    // 'updated_by',
  ];

  @override
  void initState() {
    super.initState();
    _initializeColumnOptions();
  }

  void _initializeColumnOptions() {
    columnOptions = [
      ColumnDisplayOption(
        id: 'tenDangNhap',
        label: 'Tên đăng nhập',
        isChecked: visibleColumnIds.contains('tenDangNhap'),
      ),
      ColumnDisplayOption(
        id: 'hoTen',
        label: 'Họ tên',
        isChecked: visibleColumnIds.contains('hoTen'),
      ),
      ColumnDisplayOption(
        id: 'email',
        label: 'Email',
        isChecked: visibleColumnIds.contains('email'),
      ),
      ColumnDisplayOption(
        id: 'soDienThoai',
        label: 'Số điện thoại',
        isChecked: visibleColumnIds.contains('soDienThoai'),
      ),
      ColumnDisplayOption(
        id: 'ngayTao',
        label: 'Ngày tạo',
        isChecked: visibleColumnIds.contains('ngayTao'),
      ),
      ColumnDisplayOption(
        id: 'ngayCapNhat',
        label: 'Ngày cập nhật',
        isChecked: visibleColumnIds.contains('ngayCapNhat'),
      ),
      ColumnDisplayOption(
        id: 'nguoiTao',
        label: 'Người tạo',
        isChecked: visibleColumnIds.contains('nguoiTao'),
      ),
      ColumnDisplayOption(
        id: 'nguoiCapNhat',
        label: 'Người cập nhật',
        isChecked: visibleColumnIds.contains('nguoiCapNhat'),
      ),
      ColumnDisplayOption(
        id: 'idCongTy',
        label: 'ID công ty',
        isChecked: visibleColumnIds.contains('idCongTy'),
      ),
      ColumnDisplayOption(
        id: 'rule',
        label: 'Quyền',
        isChecked: visibleColumnIds.contains('rule'),
      ),
      ColumnDisplayOption(
        id: 'actions',
        label: 'Thao tác',
        isChecked: visibleColumnIds.contains('actions'),
      ),
    ];
  }

  List<SgTableColumn<UserInfoDTO>> _buildColumns() {
    final List<SgTableColumn<UserInfoDTO>> columns = [];

    // Thêm cột dựa trên visibleColumnIds
    for (String columnId in visibleColumnIds) {
      switch (columnId) {
        case 'tenDangNhap':
          columns.add(
            TableBaseConfig.columnTable<UserInfoDTO>(
              title: 'Tên đăng nhập',
              getValue: (item) => item.username ?? '',
              width: 170,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'hoTen':
          columns.add(
            TableBaseConfig.columnTable<UserInfoDTO>(
              title: 'Họ tên',
              getValue: (item) => item.hoTen,
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'email':
          columns.add(
            TableBaseConfig.columnTable<UserInfoDTO>(
              title: 'Email',
              getValue: (item) => item.email ?? '',
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'soDienThoai':
          columns.add(
            TableBaseConfig.columnTable<UserInfoDTO>(
              title: 'Số điện thoại',
              width: 100,
              getValue: (item) => item.soDienThoai ?? '',
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'ngayTao':
          columns.add(
            TableBaseConfig.columnTable<UserInfoDTO>(
              title: 'Ngày tạo',
              getValue: (item) => item.ngayTao.toString(),
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'ngayCapNhat':
          columns.add(
            TableBaseConfig.columnTable<UserInfoDTO>(
              title: 'Ngày cập nhật',
              getValue: (item) => item.ngayCapNhat.toString(),
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'nguoiTao':
          columns.add(
            TableBaseConfig.columnTable<UserInfoDTO>(
              title: 'Người tạo',
              getValue: (item) => widget.provider.getNameUser(item.nguoiTao),
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'nguoiCapNhat':
          columns.add(
            TableBaseConfig.columnTable<UserInfoDTO>(
              title: 'Người cập nhật',
              getValue: (item) => item.nguoiCapNhat.toString(),
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'idCongTy':
          columns.add(
            TableBaseConfig.columnTable<UserInfoDTO>(
              title: 'Công ty',
              getValue: (item) => item.idCongTy.toString(),
              width: 120,
              searchable: true,
            ),
          );
          break;
        case 'actions':
          columns.add(
            TableBaseConfig.columnWidgetBase<UserInfoDTO>(
              title: 'Thao tác',
              cellBuilder: (item) => viewAction(item),
              width: 180,
              searchable: true,
            ),
          );
          break;
      }
    }

    return columns;
  }

  void _showColumnDisplayPopup() async {
    await showColumnDisplayPopup(
      context: context,
      columns: columnOptions,
      onSave: (selectedColumns) {
        setState(() {
          visibleColumnIds = selectedColumns;
          _updateColumnOptions();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã cập nhật hiển thị cột'),
            backgroundColor: Colors.green,
          ),
        );
      },
      onCancel: () {
        // Reset về trạng thái ban đầu
        _updateColumnOptions();
      },
    );
  }

  void _updateColumnOptions() {
    for (var option in columnOptions) {
      option.isChecked = visibleColumnIds.contains(option.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<SgTableColumn<UserInfoDTO>> columns = _buildColumns();

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    Icon(
                      Icons.table_chart,
                      color: Colors.grey.shade600,
                      size: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.5),
                      child: Text(
                        'Danh sách account hiện có (${widget.provider.users?.length})',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _showColumnDisplayPopup,
                      child: Icon(
                        Icons.settings,
                        color: const Color(0xFF21A366),
                        size: 18,
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible:
                      selectedItems.isNotEmpty &&
                      AccountHelper.instance.getUserInfo()?.tenDangNhap ==
                          "admin",
                  child: Row(
                    children: [
                      SGText(
                        text:
                            'Danh sách tài khoản đã chọn: ${selectedItems.length}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(width: 16),

                      MaterialTextButton(
                        text: 'Xóa đã chọn',
                        icon: Icons.delete,
                        backgroundColor: ColorValue.error,
                        foregroundColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            List<String> data =
                                selectedItems.map((e) => e.id).toList();
                            showConfirmDialog(
                              context,
                              type: ConfirmType.delete,
                              title: 'Xóa tài khoản',
                              message:
                                  'Bạn có chắc muốn xóa ${selectedItems.length} tài khoản',
                              highlight: selectedItems.length.toString(),
                              cancelText: 'Không',
                              confirmText: 'Xóa',
                              onConfirm: () {
                                context.read<LoginBloc>().add(
                                  DeleteUserBatchEvent(data),
                                );
                              },
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TableBaseView<UserInfoDTO>(
              searchTerm: '',
              columns: columns,
              data: widget.provider.filteredData ?? [],
              horizontalController: ScrollController(),
              onRowTap: (item) {
                // widget.provider.onChangeDetail(item);
                // showPermissionExample(context, item);
              },
              onSelectionChanged: (items) {
                setState(() {
                  selectedItems = items;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget showCheckBoxActive(bool isActive) {
    return SgCheckbox(value: isActive);
  }

  Widget viewAction(UserInfoDTO item) {
    UserInfoDTO? currentUser = AccountHelper.instance.getUserInfo();
    return viewActionButtons([
      ActionButtonConfig(
        icon: Icons.edit,
        tooltip: 'Sửa',
        iconColor: Colors.blue,
        backgroundColor: Colors.green.shade50,
        borderColor: Colors.green.shade200,
        onPressed: () {
          List<RoleDto> roles = AppUtility.listRoles;
          // showPermissionExample(context, item);
          if (currentUser?.tenDangNhap == "admin" ||
              currentUser?.tenDangNhap == item.tenDangNhap) {
            showAccountEditPopup(
              context: context,
              userInfo: item,
              roles: roles,
              onSave: (updatedUser) {
                context.read<LoginBloc>().add(
                  UpdateUserEvent(updatedUser.id, updatedUser),
                );
              },
            );
          } else {
            AppUtility.showSnackBar(
              context,
              'Bạn chỉ có thể sửa thông tin của chính mình',
              isError: true,
            );
          }
        },
      ),
      ActionButtonConfig(
        icon: Icons.delete,
        tooltip: 'Xóa',
        iconColor:
            currentUser!.tenDangNhap != "admin" ? Colors.grey : Colors.red,
        backgroundColor: Colors.red.shade50,
        borderColor: Colors.red.shade200,
        onPressed:
            currentUser.tenDangNhap != "admin"
                ? null
                : () => {
                  showConfirmDialog(
                    context,
                    type: ConfirmType.delete,
                    title: 'Xóa account',
                    message:
                        'Bạn có chắc muốn xóa tài khoản ${item.tenDangNhap}',
                    highlight: item.tenDangNhap,
                    cancelText: 'Không',
                    confirmText: 'Xóa',
                    onConfirm: () {
                      context.read<LoginBloc>().add(DeleteUserEvent(item.id));
                    },
                  ),
                },
      ),
      if (currentUser.tenDangNhap == "admin")
        ActionButtonConfig(
          icon: Icons.security,
          tooltip: 'Phân quyền',
          iconColor: Colors.orange,
          backgroundColor: Colors.orange.shade50,
          borderColor: Colors.orange.shade200,
          onPressed: () {
            widget.provider.showPermission(context, item);
          },
        ),
    ]);
  }
}
