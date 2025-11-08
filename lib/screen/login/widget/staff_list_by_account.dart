// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:quan_ly_tai_san_app/common/button/action_button_config.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/uuid_generator.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/component/staff_table_config.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/provider/login_provider.dart';
import 'package:quan_ly_tai_san_app/screen/login/provider/staff_table_provider.dart';
import 'package:quan_ly_tai_san_app/screen/login/widget/account_detail.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import 'package:table_base/widgets/box_search.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';
import 'package:table_base/widgets/table/widgets/column_config_dialog.dart';
import 'package:table_base/widgets/table/widgets/riverpod_table.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

class StaffListByAccount extends StatefulWidget {
  final LoginProvider provider;
  final Function()? onTapClose;
  const StaffListByAccount({
    super.key,
    required this.provider,
    this.onTapClose,
  });

  @override
  State<StaffListByAccount> createState() => _StaffListByAccountState();
}

class _StaffListByAccountState extends State<StaffListByAccount> {
  // Table configuration
  late List<ColumnDefinition> _definitions;
  late List<TableColumnData> _columns;
  late List<TableColumnData> _allColumns;
  late Map<String, TableCellBuilder> _buildersByKey;
  late List<String> _hiddenKeys;

  String lableTitle = '';
  Widget? body;

  ScrollController horizontalController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeTableConfig();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _initializeTableConfig() {
    _definitions = StaffTableConfig.getColumnsWithActions(
      (item) => TableCellData(widget: viewAction(item)),
      (item) => TableCellData(
        widget: Text(
          _getTrangThaiTaiKhoan(item),
          textAlign: TextAlign.center,
        ),
      ),
    );
    _columns = _definitions.map((d) => d.config).toList(growable: true);
    _allColumns = List<TableColumnData>.from(_columns);
    _buildersByKey = {for (final d in _definitions) d.config.key: d.builder};
    _hiddenKeys = <String>[];
  }

  dynamic getValueForColumn(NhanVien item, int columnIndex) {
    final int offset = 0; // Không có checkbox column
    final int adjustedIndex = columnIndex - offset;

    if (adjustedIndex < 0 || adjustedIndex >= _columns.length) {
      return null;
    }

    final String key = _columns[adjustedIndex].key;
    switch (key) {
      case 'id':
        return item.id ?? '';
      case 'hoTen':
        return item.hoTen ?? '';
      case 'emailCongViec':
        return item.emailCongViec ?? '';
      case 'diDong':
        return item.diDong ?? '';
      case 'chucVu':
        return item.tenChucVu ?? '';
      case 'tenPhongBan':
        return item.tenPhongBan ?? '';
      case 'trangThaiTaiKhoan':
        return _getTrangThaiTaiKhoan(item);
      case 'nguoiTao':
        return item.nguoiTao ?? '';
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: riverpod.Consumer(
                        builder: (context, ref, _) {
                          final totalItems = ref.watch(
                            staffTableProvider.select(
                              (s) => s.paginationState.totalItems,
                            ),
                          );
                          return Text(
                            body == null
                                ? 'Danh sách nhân viên ($totalItems)'
                                : lableTitle,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          );
                        },
                      ),
                    ),
                    Tooltip(
                      message: 'Hiển thị cột',
                      child: GestureDetector(
                        onTap: _openColumnConfigDialog,
                        child: Icon(
                          Icons.settings,
                          color: const Color(0xFF21A366),
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      body == null
                          ? riverpod.Consumer(
                              builder: (context, ref, _) {
                                return BoxSearch(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  onSearch: (value) {
                                    ref
                                        .read(staffTableProvider.notifier)
                                        .searchTerm = value;
                                  },
                                );
                              },
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: widget.onTapClose,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.close,
                      color: ColorValue.primaryDarkBlue,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body ??
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                  child: riverpod.Consumer(
                    builder: (context, ref, child) {
                      
                      return RiverpodTable<NhanVien>(
                        tableProvider: staffTableProvider,
                        columns: _columns,
                        showCheckboxColumn: false,
                        enableRowSelection: false,
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
                        showActionsColumn: false,
                        maxHeight: MediaQuery.of(context).size.height * 0.65,
                      );
                    },
                  ),
                ),
              ),
        ],
      ),
    );
  }

  /// Hàm lấy thời gian hiện tại theo định dạng ISO 8601
  String getDateNow() {
    final now = DateTime.now();
    final utc = now.toUtc();
    final year = utc.year.toString().padLeft(4, '0');
    final month = utc.month.toString().padLeft(2, '0');
    final day = utc.day.toString().padLeft(2, '0');
    final hour = utc.hour.toString().padLeft(2, '0');
    final minute = utc.minute.toString().padLeft(2, '0');
    final second = utc.second.toString().padLeft(2, '0');
    final millisecond = utc.millisecond.toString().padLeft(3, '0');

    return '$year-$month-${day}T$hour:$minute:$second.$millisecond+00:00';
  }

  Widget viewAction(NhanVien item) {
    return viewActionButtons([
      ActionButtonConfig(
        icon: Icons.add_circle,
        tooltip: _getTooltipForAction(item),
        iconColor: _getIconColorForAction(item),
        backgroundColor: Colors.transparent,
        borderColor: Colors.transparent,
        onPressed: () {
          // Kiểm tra xem đã có tài khoản của nhân viên này chưa
          if (_hasExistingAccount(item)) {
            // Đã có tài khoản, hiển thị thông báo
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Nhân viên ${item.hoTen} đã có tài khoản!'),
                backgroundColor: Colors.orange.shade600,
              ),
            );
            return;
          }

          final userInfo = UserInfoDTO(
            id: UUIDGenerator.generateTimestampId(prefix: 'USR'),
            tenDangNhap: item.id ?? '',
            username: item.id ?? '',
            matKhau: '${item.id}${item.idCongTy}',
            hoTen: item.hoTen ?? '',
            email: item.emailCongViec,
            soDienThoai: item.diDong,
            hinhAnh: item.avatar,
            nguoiTao: widget.provider.userInfo?.id ?? '',
            nguoiCapNhat: widget.provider.userInfo?.id ?? '',
            idCongTy: item.idCongTy ?? 'CT001',
            rule: 0,
            isActive: true,
            ngayTao: getDateNow(),
            ngayCapNhat: getDateNow(),
          );
          setState(() {
            lableTitle = 'Tạo account cho nhân viên ${item.hoTen}';
            body = Expanded(
              child: AccountDetail(
                userInfo: userInfo,
                onPressedCancel: () {
                  setState(() {
                    body = null;
                    lableTitle =
                        'Danh sách nhân viên hiện có (${widget.provider.nhanViens?.length ?? 0})';
                  });
                },
              ),
            );
          });
        },
      ),
    ]);
  }

  /// Kiểm tra xem nhân viên đã có tài khoản chưa
  bool _hasExistingAccount(NhanVien item) {
    final users = widget.provider.users;
    if (users == null || users.isEmpty) {
      return false;
    }

    // So sánh tenDangNhap (có thể null) với id nhân viên (có thể null)
    final target = (item.id ?? '').trim().toLowerCase();
    return users.any((user) {
      final username = (user.tenDangNhap ?? '').trim().toLowerCase();
      return username == target;
    });
  }

  /// Lấy trạng thái tài khoản của nhân viên
  String _getTrangThaiTaiKhoan(NhanVien item) {
    if (_hasExistingAccount(item)) {
      return 'Đã có tài khoản';
    }
    return 'Chưa có tài khoản';
  }

  /// Lấy tooltip cho nút action
  String _getTooltipForAction(NhanVien item) {
    if (_hasExistingAccount(item)) {
      return 'Đã có tài khoản';
    }
    return 'Tạo account';
  }

  /// Lấy màu icon cho nút action
  Color _getIconColorForAction(NhanVien item) {
    if (_hasExistingAccount(item)) {
      return Colors.grey.shade400; // Màu xám khi đã có tài khoản
    }
    return Colors.red.shade700; // Màu đỏ khi chưa có tài khoản
  }
}
