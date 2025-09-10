// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/button/action_button_config.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/uuid_generator.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/provider/login_provider.dart';
import 'package:quan_ly_tai_san_app/screen/login/widget/account_detail.dart';
import 'package:se_gay_components/common/switch/sg_checkbox.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class StaffListByAccount extends StatefulWidget {
  final LoginProvider provider;
  const StaffListByAccount({super.key, required this.provider});

  @override
  State<StaffListByAccount> createState() => _StaffListByAccountState();
}

class _StaffListByAccountState extends State<StaffListByAccount> {
  final ScrollController horizontalController = ScrollController();
  String searchTerm = "";
  String lableTitle = '';

  // Column display options
  late List<ColumnDisplayOption> columnOptions;

  Widget? body;

  List<String> visibleColumnIds = [
    'actions',
    'id',
    'hoTen',
    'emailCongViec',
    'diDong',
    'boPhan',
    'chucVu',
    'tenQuanLy',
    'tenPhongBan',
    'trangThaiTaiKhoan',
    'nguoiTao',
  ];

  @override
  void initState() {
    super.initState();
    _initializeColumnOptions();
    lableTitle =
        'Danh sách nhân viên hiện có (${widget.provider.nhanViens?.length})';
    // body = _buildTableStaff(_buildColumns());
  }

  void _initializeColumnOptions() {
    columnOptions = [
      ColumnDisplayOption(
        id: 'actions',
        label: 'Thao tác',
        isChecked: visibleColumnIds.contains('actions'),
      ),
      ColumnDisplayOption(
        id: 'id',
        label: 'Mã nhân viên',
        isChecked: visibleColumnIds.contains('id'),
      ),
      ColumnDisplayOption(
        id: 'hoTen',
        label: 'Họ tên',
        isChecked: visibleColumnIds.contains('hoTen'),
      ),
      ColumnDisplayOption(
        id: 'emailCongViec',
        label: 'Email công việc',
        isChecked: visibleColumnIds.contains('emailCongViec'),
      ),
      ColumnDisplayOption(
        id: 'diDong',
        label: 'Số điện thoại',
        isChecked: visibleColumnIds.contains('diDong'),
      ),
      ColumnDisplayOption(
        id: 'boPhan',
        label: 'Bộ phận',
        isChecked: visibleColumnIds.contains('boPhan'),
      ),
      ColumnDisplayOption(
        id: 'chucVu',
        label: 'Chức vụ',
        isChecked: visibleColumnIds.contains('chucVu'),
      ),
      ColumnDisplayOption(
        id: 'tenQuanLy',
        label: 'Người quản lý',
        isChecked: visibleColumnIds.contains('tenQuanLy'),
      ),
      ColumnDisplayOption(
        id: 'tenPhongBan',
        label: 'Phòng ban',
        isChecked: visibleColumnIds.contains('tenPhongBan'),
      ),
      ColumnDisplayOption(
        id: 'trangThaiTaiKhoan',
        label: 'Trạng thái tài khoản',
        isChecked: visibleColumnIds.contains('trangThaiTaiKhoan'),
      ),
      ColumnDisplayOption(
        id: 'nguoiTao',
        label: 'Người tạo',
        isChecked: visibleColumnIds.contains('nguoiTao'),
      ),
    ];
  }

  List<SgTableColumn<NhanVien>> _buildColumns() {
    final List<SgTableColumn<NhanVien>> columns = [];

    // Thêm cột dựa trên visibleColumnIds
    for (String columnId in visibleColumnIds) {
      switch (columnId) {
        case 'actions':
          columns.add(
            TableBaseConfig.columnWidgetBase<NhanVien>(
              title: '',
              cellBuilder: (item) => viewAction(item),
              width: 120,
              searchable: true,
            ),
          );
          break;
        case 'id':
          columns.add(
            TableBaseConfig.columnTable<NhanVien>(
              title: 'Mã nhân viên',
              getValue: (item) => item.id ?? '',
              width: 170,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'hoTen':
          columns.add(
            TableBaseConfig.columnTable<NhanVien>(
              title: 'Họ tên',
              getValue: (item) => item.hoTen ?? '',
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'emailCongViec':
          columns.add(
            TableBaseConfig.columnTable<NhanVien>(
              title: 'Email',
              getValue: (item) => item.emailCongViec ?? '',
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'diDong':
          columns.add(
            TableBaseConfig.columnTable<NhanVien>(
              title: 'Số điện thoại',
              width: 100,
              getValue: (item) => item.diDong ?? '',
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'boPhan':
          columns.add(
            TableBaseConfig.columnTable<NhanVien>(
              title: 'Bộ phận',
              getValue: (item) => item.boPhan ?? '',
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'chucVu':
          columns.add(
            TableBaseConfig.columnTable<NhanVien>(
              title: 'Chức vụ',
              getValue: (item) => item.tenChucVu ?? '',
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'tenQuanLy':
          columns.add(
            TableBaseConfig.columnTable<NhanVien>(
              title: 'Người quản lý',
              getValue: (item) => item.tenQuanLy ?? '',
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'tenPhongBan':
          columns.add(
            TableBaseConfig.columnTable<NhanVien>(
              title: 'Phòng ban',
              getValue: (item) => item.tenPhongBan ?? '',
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'trangThaiTaiKhoan':
          columns.add(
            TableBaseConfig.columnTable<NhanVien>(
              title: 'Trạng thái tài khoản',
              getValue: (item) => _getTrangThaiTaiKhoan(item),
              width: 150,
              titleAlignment: TextAlign.center,
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
    final List<SgTableColumn<NhanVien>> columns = _buildColumns();

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
                        lableTitle,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    Tooltip(
                      message: 'Hiển thị cột',
                      child: GestureDetector(
                        onTap: _showColumnDisplayPopup,
                        child: Icon(
                          Icons.settings,
                          color: ColorValue.link,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body ?? _buildTableStaff(columns),
        ],
      ),
    );
  }

  Expanded _buildTableStaff(List<SgTableColumn<NhanVien>> columns) {
    return Expanded(
      child: TableBaseView<NhanVien>(
        searchTerm: '',
        isShowCheckboxes: false,
        columns: columns,
        data: widget.provider.nhanViens ?? [],
        horizontalController: ScrollController(),
        onRowTap: (item) {
          // widget.provider.onChangeDetail(item);
        },
      ),
    );
  }

  Widget showCheckBoxActive(bool isActive) {
    return SgCheckbox(value: isActive);
  }

  String getUuIdAccount() {
    final users = widget.provider.users;
    if (users == null || users.isEmpty) {
      return 'TK001';
    }

    final existingIds = users.map((u) => u.id).toSet();
    final reg = RegExp(r'^TK(\d+)$');
    int maxNum = 0;
    for (final id in existingIds) {
      final m = reg.firstMatch(id);
      if (m != null) {
        final n = int.tryParse(m.group(1) ?? '') ?? 0;
        if (n > maxNum) maxNum = n;
      }
    }

    int nextNum = maxNum + 1;
    String candidate = 'TK${nextNum.toString().padLeft(3, '0')}';
    while (existingIds.contains(candidate)) {
      nextNum += 1;
      candidate = 'TK${nextNum.toString().padLeft(3, '0')}';
    }

    return candidate.isNotEmpty
        ? candidate
        : UUIDGenerator.generateWithFormat('TK***');
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
            id: getUuIdAccount(),
            tenDangNhap: item.id ?? '',
            matKhau: '${item.id}${item.idCongTy}',
            hoTen: item.hoTen ?? '',
            email: item.emailCongViec,
            soDienThoai: item.diDong,
            hinhAnh: item.avatar,
            nguoiTao: widget.provider.userInfo.id,
            nguoiCapNhat: widget.provider.userInfo.id,
            idCongTy: item.idCongTy ?? 'CT001',
            rule: 0,
            isActive: true,
            ngayTao: getDateNow(),
            ngayCapNhat: getDateNow(),
          );
          setState(() {
            lableTitle = 'Tạo account cho nhân viên ${item.hoTen}';
            // showDialog(
            //   context: context,
            //   builder:
            //       (context) => AccountDetail(
            //         userInfo: userInfo,
            //         onPressedCancel: () {
            //           setState(() {
            //             body = null;
            //             lableTitle =
            //                 'Danh sách nhân viên hiện có (${widget.provider.nhanViens?.length})';
            //           });
            //         },
            //       ),
            // );
            body = Expanded(
              child: AccountDetail(
                userInfo: userInfo,
                onPressedCancel: () {
                  setState(() {
                    body = null;
                    lableTitle =
                        'Danh sách nhân viên hiện có (${widget.provider.nhanViens?.length})';
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
    if (widget.provider.users == null || widget.provider.users!.isEmpty) {
      return false;
    }

    // So sánh tenDangNhap của user với id của nhân viên
    return widget.provider.users!.any(
      (user) =>
          user.tenDangNhap.trim().toLowerCase() ==
          (item.id ?? '').trim().toLowerCase(),
    );
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
