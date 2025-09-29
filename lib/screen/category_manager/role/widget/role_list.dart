// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/button/action_button_config.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/index.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/bloc/role_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/bloc/role_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/model/chuc_vu.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/provider/role_provide.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/switch/sg_checkbox.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class RoleList extends StatefulWidget {
  final RoleProvider provider;
  const RoleList({super.key, required this.provider});

  @override
  State<RoleList> createState() => _RoleListState();
}

class _RoleListState extends State<RoleList> {
  final ScrollController horizontalController = ScrollController();
  String searchTerm = "";
  List<ChucVu> listSelected = [];

  // Column display options
  late List<ColumnDisplayOption> columnOptions;
  List<String> visibleColumnIds = [
    'id',
    'name',
    'quanLyNhanVien',
    'quanLyPhongBan',
    'quanLyDuAn',
    'quanLyNguonVon',
    'quanLyMoHinhTaiSan',
    'quanLyTaiSan',
    'quanLyCCDCVatTu',
    'dieuDongTaiSan',
    'dieuDongCCDCVatTu',
    'banGiaoTaiSan',
    'banGiaoCCDCVatTu',
    'baoCao',
    'actions',
  ];
  @override
  void initState() {
    super.initState();
    _initializeColumnOptions();
  }

  void _initializeColumnOptions() {
    columnOptions = [
      ColumnDisplayOption(
        id: 'id',
        label: 'Mã chức vụ',
        isChecked: visibleColumnIds.contains('id'),
      ),
      ColumnDisplayOption(
        id: 'name',
        label: 'Tên chức vụ',
        isChecked: visibleColumnIds.contains('name'),
      ),
      ColumnDisplayOption(
        id: 'quanLyNhanVien',
        label: 'Quản lý nhân viên',
        isChecked: visibleColumnIds.contains('quanLyNhanVien'),
      ),
      ColumnDisplayOption(
        id: 'quanLyPhongBan',
        label: 'Quản lý phòng ban',
        isChecked: visibleColumnIds.contains('quanLyPhongBan'),
      ),
      ColumnDisplayOption(
        id: 'quanLyDuAn',
        label: 'Quản lý dự án',
        isChecked: visibleColumnIds.contains('quanLyDuAn'),
      ),
      ColumnDisplayOption(
        id: 'quanLyNguonVon',
        label: 'Quản lý nguồn vốn',
        isChecked: visibleColumnIds.contains('quanLyNguonVon'),
      ),
      ColumnDisplayOption(
        id: 'quanLyMoHinhTaiSan',
        label: 'Quản lý mô hình tài sản',
        isChecked: visibleColumnIds.contains('quanLyMoHinhTaiSan'),
      ),
      ColumnDisplayOption(
        id: 'quanLyTaiSan',
        label: 'Quản lý tài sản',
        isChecked: visibleColumnIds.contains('quanLyTaiSan'),
      ),
      ColumnDisplayOption(
        id: 'quanLyCCDCVatTu',
        label: 'Quản lý CCDC - Vật tư',
        isChecked: visibleColumnIds.contains('quanLyCCDCVatTu'),
      ),
      ColumnDisplayOption(
        id: 'dieuDongTaiSan',
        label: 'Điều động tài sản',
        isChecked: visibleColumnIds.contains('dieuDongTaiSan'),
      ),
      ColumnDisplayOption(
        id: 'dieuDongCCDCVatTu',
        label: 'Điều động CCDC - Vật tư',
        isChecked: visibleColumnIds.contains('dieuDongCCDCVatTu'),
      ),
      ColumnDisplayOption(
        id: 'banGiaoTaiSan',
        label: 'Bán giao tài sản',
        isChecked: visibleColumnIds.contains('banGiaoTaiSan'),
      ),
      ColumnDisplayOption(
        id: 'banGiaoCCDCVatTu',
        label: 'Bán giao CCDC - Vật tư',
        isChecked: visibleColumnIds.contains('banGiaoCCDCVatTu'),
      ),
      ColumnDisplayOption(
        id: 'baoCao',
        label: 'Báo cáo',
        isChecked: visibleColumnIds.contains('baoCao'),
      ),
      ColumnDisplayOption(
        id: 'actions',
        label: 'Thao tác',
        isChecked: visibleColumnIds.contains('actions'),
      ),
    ];
  }

  List<SgTableColumn<ChucVu>> _buildColumns() {
    final List<SgTableColumn<ChucVu>> columns = [];

    // Thêm cột dựa trên visibleColumnIds
    for (String columnId in visibleColumnIds) {
      switch (columnId) {
        case 'id':
          columns.add(
            TableBaseConfig.columnTable<ChucVu>(
              title: 'Id chức vụ',
              width: 150,
              getValue: (item) => item.id,
            ),
          );
          break;
        case 'name':
          columns.add(
            TableBaseConfig.columnTable<ChucVu>(
              title: 'Tên chức vụ',
              width: 100,
              getValue: (item) => item.tenChucVu,
            ),
          );
          break;
        case 'quanLyNhanVien':
          columns.add(
            TableBaseConfig.columnWidgetBase<ChucVu>(
              title: 'Quản lý nhân viên',
              cellBuilder:
                  (item) =>
                      _buildShowRole(item.quanLyNhanVien, 'quản lý nhân viên'),
              width: 120,
              searchable: true,
            ),
          );
          break;
        case 'quanLyPhongBan':
          columns.add(
            TableBaseConfig.columnWidgetBase<ChucVu>(
              title: 'Quản lý phòng ban',
              cellBuilder:
                  (item) =>
                      _buildShowRole(item.quanLyPhongBan, 'quản lý phòng ban'),
              width: 120,
              searchable: true,
            ),
          );
          break;
        case 'quanLyDuAn':
          columns.add(
            TableBaseConfig.columnWidgetBase<ChucVu>(
              title: 'Quản lý dự án',
              cellBuilder:
                  (item) => _buildShowRole(item.quanLyDuAn, 'quản lý dự án'),
              width: 120,
              searchable: true,
            ),
          );
          break;
        case 'quanLyNguonVon':
          columns.add(
            TableBaseConfig.columnWidgetBase<ChucVu>(
              title: 'Quản lý nguồn vốn',
              cellBuilder:
                  (item) =>
                      _buildShowRole(item.quanLyNguonVon, 'quản lý nguồn vốn'),
              width: 120,
              searchable: true,
            ),
          );
          break;
        case 'quanLyMoHinhTaiSan':
          columns.add(
            TableBaseConfig.columnWidgetBase<ChucVu>(
              title: 'Quản lý mô hình tài sản',
              cellBuilder:
                  (item) => _buildShowRole(
                    item.quanLyMoHinhTaiSan,
                    'quản lý mô hình tài sản',
                  ),
              width: 120,
              searchable: true,
            ),
          );
          break;
        case 'quanLyNhomTaiSan':
          columns.add(
            TableBaseConfig.columnWidgetBase<ChucVu>(
              title: 'Quản lý nhóm tài sản',
              cellBuilder:
                  (item) => _buildShowRole(
                    item.quanLyNhomTaiSan,
                    'quản lý nhóm tài sản',
                  ),
              width: 120,
              searchable: true,
            ),
          );
          break;
        case 'quanLyTaiSan':
          columns.add(
            TableBaseConfig.columnWidgetBase<ChucVu>(
              title: 'Quản lý tài sản',
              cellBuilder:
                  (item) =>
                      _buildShowRole(item.quanLyTaiSan, 'quản lý tài sản'),
              width: 120,
              searchable: true,
            ),
          );
          break;
        case 'quanLyCCDCVatTu':
          columns.add(
            TableBaseConfig.columnWidgetBase<ChucVu>(
              title: 'Quản lý CCDC vật tư',
              cellBuilder:
                  (item) => _buildShowRole(
                    item.quanLyCCDCVatTu,
                    'quản lý CCDC vật tư',
                  ),
              width: 120,
              searchable: true,
            ),
          );
          break;
        case 'dieuDongTaiSan':
          columns.add(
            TableBaseConfig.columnWidgetBase<ChucVu>(
              title: 'Điều động tài sản',
              cellBuilder:
                  (item) =>
                      _buildShowRole(item.dieuDongTaiSan, 'điều động tài sản'),
              width: 120,
              searchable: true,
            ),
          );
          break;
        case 'dieuDongCCDCVatTu':
          columns.add(
            TableBaseConfig.columnWidgetBase<ChucVu>(
              title: 'Điều động CCDC vật tư',
              cellBuilder:
                  (item) => _buildShowRole(
                    item.dieuDongCCDCVatTu,
                    'điều động CCDC vật tư',
                  ),
              width: 120,
              searchable: true,
            ),
          );
          break;
        case 'banGiaoTaiSan':
          columns.add(
            TableBaseConfig.columnWidgetBase<ChucVu>(
              title: 'Bán giao tài sản',
              cellBuilder:
                  (item) =>
                      _buildShowRole(item.banGiaoTaiSan, 'ban giao tài sản'),
              width: 120,
              searchable: true,
            ),
          );
          break;
        case 'banGiaoCCDCVatTu':
          columns.add(
            TableBaseConfig.columnWidgetBase<ChucVu>(
              title: 'Bán giao CCDC vật tư',
              cellBuilder:
                  (item) => _buildShowRole(
                    item.banGiaoCCDCVatTu,
                    'ban giao CCDC vật tư',
                  ),
              width: 120,
              searchable: true,
            ),
          );
          break;
        case 'baoCao':
          columns.add(
            TableBaseConfig.columnWidgetBase<ChucVu>(
              title: 'Báo cáo',
              cellBuilder: (item) => _buildShowRole(item.baoCao, 'bao cáo'),
              width: 120,
              searchable: true,
            ),
          );
          break;
        case 'actions':
          columns.add(
            TableBaseConfig.columnWidgetBase<ChucVu>(
              title: 'Thao tác',
              cellBuilder: (item) => viewAction(item),
              width: 120,
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
                    SizedBox(width: 8),
                    Text(
                      'Quản lý chức vụ (${widget.provider.filteredData?.length ?? 0})',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
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
                Visibility(
                  visible: listSelected.isNotEmpty,
                  child: Row(
                    children: [
                      SGText(
                        text:
                            'Danh sách chức vụ đã chọn: ${listSelected.length}',
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
                                listSelected.map((e) => e.id).toList();
                            showConfirmDialog(
                              context,
                              type: ConfirmType.delete,
                              title: 'Xóa chức vụ',
                              message:
                                  'Bạn có chắc muốn xóa ${listSelected.length} chức vụ',
                              highlight: listSelected.length.toString(),
                              cancelText: 'Không',
                              confirmText: 'Xóa',
                              onConfirm: () {
                                final roleBloc = context.read<RoleBloc>();
                                roleBloc.add(DeleteRoleBatchEvent(data));
                              },
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),
                // FindByStateAssetHandover(provider: widget.provider),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: SGAppColors.colorBorderGray.withValues(alpha: 0.3),
          ),
          Expanded(
            child: TableBaseView<ChucVu>(
              searchTerm: '',
              columns: _buildColumns(),
              data: widget.provider.dataPage,
              horizontalController: ScrollController(),
              onRowTap: (item) {
                widget.provider.onChangeDetail(context, item);
              },
              onSelectionChanged: (data) {
                setState(() {
                  listSelected = data;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShowRole(bool isTrue, String text) {
    return SgCheckbox(
      value: isTrue,
      isDisabled: true,
      // onChanged: (value) {},
    );
  }

  Widget viewAction(ChucVu item) {
    return viewActionButtons([
      ActionButtonConfig(
        icon: Icons.delete,
        tooltip: 'Xóa',
        iconColor: Colors.red.shade700,
        backgroundColor: Colors.red.shade50,
        borderColor: Colors.red.shade200,
        onPressed:
            () => {
              showConfirmDialog(
                context,
                type: ConfirmType.delete,
                title: 'Xóa chức vụ',
                message: 'Bạn có chắc muốn xóa ${item.tenChucVu}',
                highlight: item.tenChucVu,
                cancelText: 'Không',
                confirmText: 'Xóa',
                onConfirm: () {
                  context.read<RoleBloc>().add(DeleteRoleEvent(item.id));
                },
              ),
            },
      ),
    ]);
  }
}
