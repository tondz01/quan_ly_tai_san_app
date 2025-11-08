// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/utils.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/button/action_button_config.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_event.dart';
import 'package:quan_ly_tai_san_app/screen/login/component/account_table_config.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/provider/account_table_provider.dart';
import 'package:quan_ly_tai_san_app/screen/login/provider/login_provider.dart';
import 'package:quan_ly_tai_san_app/screen/login/widget/account_edit_popup.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import 'package:table_base/core/themes/app_color.dart';
import 'package:table_base/core/themes/app_icon_svg.dart';
import 'package:table_base/widgets/box_search.dart';
import 'package:table_base/widgets/responsive_button_bar/responsive_button_bar.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';
import 'package:table_base/widgets/table/widgets/column_config_dialog.dart';
import 'package:table_base/widgets/table/widgets/riverpod_table.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

class AccountList extends StatefulWidget {
  final LoginProvider provider;
  const AccountList({super.key, required this.provider});

  @override
  State<AccountList> createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  List<UserInfoDTO> listSelected = [];

  // Table configuration
  late List<ColumnDefinition> _definitions;
  late List<TableColumnData> _columns;
  late List<TableColumnData> _allColumns;
  late Map<String, TableCellBuilder> _buildersByKey;
  late List<String> _hiddenKeys;

  int totalItems = 0;
  bool _isProviderInitialized = false;

  ScrollController horizontalController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeTableConfig();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Khởi tạo table provider một lần sau khi dependencies thay đổi
    if (!_isProviderInitialized && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isProviderInitialized && mounted) {
          final ref = riverpod.ProviderScope.containerOf(context);
          final notifier = ref.read(accountTableProvider.notifier);
          final columnWidths = {for (final col in _columns) col.key: col.width};
          try {
            notifier.initialize(
              columnWidths: columnWidths,
              valueGetter: getValueForColumn,
              itemsPerPage: 20,
            );
            _isProviderInitialized = true;
          } catch (e) {
            // Provider đã được khởi tạo, bỏ qua
            _isProviderInitialized = true;
          }
        }
      });
    }
  }

  void _initializeTableConfig() {
    final currentUser = AccountHelper.instance.getUserInfo();
    final userInfo =
        currentUser ??
        UserInfoDTO(
          id: '',
          tenDangNhap: '',
          matKhau: '',
          hoTen: '',
          nguoiTao: '',
          idCongTy: '',
          rule: 0,
          isActive: false,
        );
    _definitions = AccountTableConfig.getColumnsWithActions(
      userInfo,
      (item) => TableCellData(widget: viewAction(item)),
    );
    _columns = _definitions.map((d) => d.config).toList(growable: true);
    _allColumns = List<TableColumnData>.from(_columns);
    _buildersByKey = {for (final d in _definitions) d.config.key: d.builder};
    _hiddenKeys = <String>[];
  }

  dynamic getValueForColumn(UserInfoDTO item, int columnIndex) {
    final int offset = 1; // showCheckboxColumn
    final int adjustedIndex = columnIndex - offset;

    if (adjustedIndex < 0 || adjustedIndex >= _columns.length) {
      return null;
    }

    final String key = _columns[adjustedIndex].key;
    switch (key) {
        case 'tenDangNhap':
        return item.username ?? '';
        case 'hoTen':
        return item.hoTen;
        case 'email':
        return item.email ?? '';
      case 'document': // Số điện thoại trong config
        return item.soDienThoai ?? '';
        case 'ngayTao':
        return item.ngayTao ?? '';
        case 'ngayCapNhat':
        return item.ngayCapNhat ?? '';
        case 'nguoiTao':
        return widget.provider.getNameUser(item.tenDangNhap);
        case 'nguoiCapNhat':
        return item.nguoiCapNhat;
      default:
        return null;
    }
  }

  Future<void> _openColumnConfigDialog() async {
    try {
      final apply = await showColumnConfigAndApply(
      context: context,
        allColumns: _allColumns,
        currentColumns: _columns,
        initialHiddenKeys: _hiddenKeys,
        title: 'table.config_column'.tr,
      );
      if (apply != null) {
        setState(() {
          _hiddenKeys = apply.hiddenKeys;
          _columns = apply.updatedColumns;
        });
      }
    } catch (e) {
      SGLog.error('ColumnConfigDialog', 'Error at _openColumnConfigDialog: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  children: [
                    Icon(
                      Icons.table_chart,
                      color: Colors.grey.shade600,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    riverpod.Consumer(
                      builder: (context, ref, _) {
                        final totalItems = ref.watch(
                          accountTableProvider.select(
                            (s) => s.paginationState.totalItems,
                          ),
                        );
                        return Text(
                          'Danh sách account ($totalItems)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                        );
                      },
                    ),
                  ],
                ),
                Visibility(
                  visible:
                      listSelected.isNotEmpty &&
                      AccountHelper.instance.getUserInfo()?.tenDangNhap ==
                          "admin",
                  child: Row(
                    children: [
                      SGText(
                        text:
                            'Danh sách tài khoản đã chọn: ${listSelected.length}',
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
                          final ids = listSelected.map((e) => e.id).toList();
                            showConfirmDialog(
                              context,
                              type: ConfirmType.delete,
                              title: 'Xóa tài khoản',
                              message:
                                'Bạn có chắc muốn xóa ${listSelected.length} tài khoản',
                            highlight: listSelected.length.toString(),
                              cancelText: 'Không',
                              confirmText: 'Xóa',
                              onConfirm: () {
                                context.read<LoginBloc>().add(
                                DeleteUserBatchEvent(ids),
                                );
                              },
                            );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth;
                return Row(
                  children: [
                    riverpod.Consumer(
                      builder: (context, ref, _) {
                        return BoxSearch(
                          width: (availableWidth * 0.35).toDouble(),
                          onSearch: (value) {
                            ref.read(accountTableProvider.notifier).searchTerm =
                                value;
                          },
                        );
                      },
                    ),
                    SizedBox(
                      width: (availableWidth * 0.65).toDouble(),
                      child: riverpod.Consumer(
                        builder: (context, ref, _) {
                          final hasFilters = ref.watch(
                            accountTableProvider.select(
                              (s) => s.filterState.hasActiveFilters,
                            ),
                          );
                          final tableState = ref.watch(accountTableProvider);
                          final selectedCount = tableState.selectedItems.length;
                          listSelected = tableState.selectedItems;
                          final buttons = _buildButtonList(selectedCount);
                          final processedButtons =
                              buttons.map((button) {
                                if (button.text == 'Xóa bộ lọc') {
                                  return ResponsiveButtonData.fromButtonIcon(
                                    text: button.text,
                                    iconPath: button.iconPath!,
                                    backgroundColor: button.backgroundColor!,
                                    iconColor: button.iconColor!,
                                    textColor: button.textColor!,
                                    width: button.width,
                                    onPressed: () {
                                      ref
                                          .read(accountTableProvider.notifier)
                                          .clearAllFilters();
                                    },
                                  );
                                }
                                return button;
                              }).toList();

                          final filteredButtons =
                              hasFilters
                                  ? processedButtons
                                  : processedButtons
                                      .where(
                                        (button) => button.text != 'Xóa bộ lọc',
                                      )
                                      .toList();

                          return ResponsiveButtonBar(
                            buttons: filteredButtons,
                            spacing: 12,
                            overflowSide: OverflowSide.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            popupPosition: PopupMenuPosition.under,
                            popupOffset: const Offset(0, 8),
                            popupShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            popupElevation: 6,
                            moreLabel: 'Khác',
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // Table
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            ),
            child: riverpod.Consumer(
              builder: (context, ref, child) {
                totalItems = ref.watch(
                  accountTableProvider.select(
                    (s) => s.paginationState.totalItems,
                  ),
                );
                log('message totalItems: $totalItems');
                return RiverpodTable<UserInfoDTO>(
                  tableProvider: accountTableProvider,
                  columns: _columns,
                  showCheckboxColumn: true,
                  enableRowSelection: true,
                  enableRowHover: true,
                  showAlternatingRowColors: true,
                  valueGetter: getValueForColumn,
                  cellsBuilder: (_) => [],
                  cellBuilderByKey: (item, key) {
                    final builder = _buildersByKey[key];
                    if (builder != null) return builder(item);
                    return null;
                  },
              onRowTap: (item) {
                // widget.provider.onChangeDetail(item);
                  },
                  onDelete: (item) {
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
                    );
                  },
                  showActionsColumn: false, // Sử dụng actions column từ config
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<ResponsiveButtonData> _buildButtonList(int itemCount) {
    return [
      // Configure columns button
      ResponsiveButtonData.fromButtonIcon(
        text: 'table.config_column'.tr,
        iconPath: AppIconSvg.iconSetting,
        backgroundColor: AppColor.white,
        iconColor: AppColor.textDark,
        textColor: AppColor.textDark,
        width: 130,
        onPressed: () {
          _openColumnConfigDialog();
        },
      ),
      if (itemCount > 0)
        ResponsiveButtonData.fromButtonIcon(
          text: '$itemCount ${'table.delete_selected'.tr}',
          iconPath: AppIconSvg.iconTrash2,
          backgroundColor: Colors.redAccent,
          iconColor: AppColor.textWhite,
          textColor: AppColor.textWhite,
          width: 130,
          onPressed: () {
            final ids = listSelected.map((e) => e.id).toList();
            showConfirmDialog(
              context,
              type: ConfirmType.delete,
              title: 'Xóa tài khoản',
              message: 'Bạn có chắc muốn xóa ${listSelected.length} tài khoản',
              highlight: listSelected.length.toString(),
              cancelText: 'Không',
              confirmText: 'Xóa',
              onConfirm: () {
                context.read<LoginBloc>().add(DeleteUserBatchEvent(ids));
              },
            );
          },
        ),
    ];
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
