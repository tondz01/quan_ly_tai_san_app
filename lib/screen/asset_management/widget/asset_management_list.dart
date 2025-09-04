// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/button/action_button_config.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/routes/routes.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/component/item_asset_group.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class AssetManagementList extends StatefulWidget {
  const AssetManagementList({super.key, required this.provider});
  final AssetManagementProvider provider;

  @override
  State<AssetManagementList> createState() => _AssetManagementListState();
}

class _AssetManagementListState extends State<AssetManagementList> {
  late List<ColumnDisplayOption> columnOptions;
  ScrollController horizontalController = ScrollController();
  List<String> visibleColumnIds = [
    'code_asset',
    'name_asset',
    'book_entry_date',
    'usage_tart_date',
    'using_unit',
    'so_luong_ts_con',
    'nhom_tai_san',
    'hien_trang',
    'so_luong',
    'don_vi_tinh',
    'ky_hieu',
    'so_ky_hieu',
    'actions',
    // 'created_at',
    // 'updated_at',
    // 'created_by',
    // 'updated_by',
  ];

  List<Map<String, DateTime Function(AssetManagementDto)>> getters = [
    {
      'Ngày tạo':
          (item) => DateTime.tryParse(item.ngayTao ?? '') ?? DateTime.now(),
    },
    {
      'Ngày cập nhật':
          (item) => DateTime.tryParse(item.ngayCapNhat ?? '') ?? DateTime.now(),
    },
    {'Ngày vào sổ': (item) => item.ngayVaoSo ?? DateTime.now()},
    {'Ngày sử dụng': (item) => item.ngaySuDung ?? DateTime.now()},
  ];

  @override
  void initState() {
    super.initState();
    _initializeColumnOptions();
  }

  void _initializeColumnOptions() {
    columnOptions = [
      ColumnDisplayOption(
        id: 'code_asset',
        label: 'Mã tài sản',
        isChecked: visibleColumnIds.contains('code_asset'),
      ),
      ColumnDisplayOption(
        id: 'name_asset',
        label: 'Tên tài sản',
        isChecked: visibleColumnIds.contains('name_asset'),
      ),
      ColumnDisplayOption(
        id: 'book_entry_date',
        label: 'Ngày vào sổ',
        isChecked: visibleColumnIds.contains('book_entry_date'),
      ),
      ColumnDisplayOption(
        id: 'usage_start_date',
        label: 'Ngày bàn giao',
        isChecked: visibleColumnIds.contains('usage_tart_date'),
      ),
      ColumnDisplayOption(
        id: 'using_unit',
        label: 'Đơn vị sử dụng',
        isChecked: visibleColumnIds.contains('using_unit'),
      ),
      ColumnDisplayOption(
        id: 'updated_at',
        label: 'Ngày cập nhật',
        isChecked: visibleColumnIds.contains('updated_at'),
      ),
      ColumnDisplayOption(
        id: 'so_luong_ts_con',
        label: 'Số lượng TS con',
        isChecked: visibleColumnIds.contains('so_luong_ts_con'),
      ),
      ColumnDisplayOption(
        id: 'nhom_tai_san',
        label: 'Nhóm tài sản',
        isChecked: visibleColumnIds.contains('nhom_tai_san'),
      ),
      ColumnDisplayOption(
        id: 'hien_trang',
        label: 'Hiện trạng',
        isChecked: visibleColumnIds.contains('hien_trang'),
      ),
      ColumnDisplayOption(
        id: 'so_luong',
        label: 'Số lượng',
        isChecked: visibleColumnIds.contains('so_luong'),
      ),
      ColumnDisplayOption(
        id: 'don_vi_tinh',
        label: 'Đơn vị tính',
        isChecked: visibleColumnIds.contains('don_vi_tinh'),
      ),
      ColumnDisplayOption(
        id: 'ky_hieu',
        label: 'Ký hiệu',
        isChecked: visibleColumnIds.contains('ky_hieu'),
      ),
      ColumnDisplayOption(
        id: 'so_ky_hieu',
        label: 'Số kys hieeu',
        isChecked: visibleColumnIds.contains('so_ky_hieu'),
      ),
      ColumnDisplayOption(
        id: 'nuoc_san_xuat',
        label: 'Nước sản xuất',
        isChecked: visibleColumnIds.contains('nuoc_san_xuat'),
      ),
      ColumnDisplayOption(
        id: 'nam_san_xuat',
        label: 'Năm sản xuất',
        isChecked: visibleColumnIds.contains('nam_san_xuat'),
      ),
      ColumnDisplayOption(
        id: 'actions',
        label: 'Thao tác',
        isChecked: visibleColumnIds.contains('actions'),
      ),
    ];
  }

  List<SgTableColumn<AssetManagementDto>> _buildColumns() {
    final List<SgTableColumn<AssetManagementDto>> columns = [];

    // Thêm cột dựa trên visibleColumnIds
    for (String columnId in visibleColumnIds) {
      switch (columnId) {
        case 'code_asset':
          columns.add(
            TableBaseConfig.columnTable<AssetManagementDto>(
              title: 'Mã tài sản',
              getValue: (item) => item.id ?? '',
              width: 120,
            ),
          );
          break;
        case 'name_asset':
          columns.add(
            TableBaseConfig.columnTable<AssetManagementDto>(
              title: 'Tên tài sản',
              getValue: (item) => item.tenTaiSan ?? '',
              width: 200,
            ),
          );
          break;
        case 'book_entry_date':
          columns.add(
            TableBaseConfig.columnTable<AssetManagementDto>(
              title: 'Ngày vào sổ',
              getValue: (item) => item.ngayVaoSo?.toString() ?? '',
              width: 120,
            ),
          );
          break;
        case 'usage_start_date':
          columns.add(
            TableBaseConfig.columnTable<AssetManagementDto>(
              title: 'Ngày bàn giao',
              getValue: (item) => item.ngaySuDung?.toString() ?? '',
              width: 120,
            ),
          );
          break;
        case 'using_unit':
          columns.add(
            TableBaseConfig.columnTable<AssetManagementDto>(
              title: 'Đơn vị sử dụng',
              getValue: (item) => item.idDonViHienThoi ?? '',
              width: 150,
            ),
          );
          break;
        case 'updated_at':
          columns.add(
            TableBaseConfig.columnTable<AssetManagementDto>(
              title: 'Ngày cập nhật',
              getValue: (item) => item.ngayCapNhat?.toString() ?? '',
              width: 120,
            ),
          );
          break;
        case 'so_luong_ts_con':
          columns.add(
            TableBaseConfig.columnTable<AssetManagementDto>(
              title: 'Số lượng TS con',
              getValue:
                  (item) =>
                      widget.provider
                          .getListChildAssetsByIdAsset(item.id ?? '')
                          .length
                          .toString(),
              width: 120,
            ),
          );
          break;
        case 'nhom_tai_san':
          columns.add(
            TableBaseConfig.columnTable<AssetManagementDto>(
              title: 'Nhóm tài sản',
              getValue: (item) => item.tenNhom ?? '',
              width: 150,
            ),
          );
          break;
        case 'hien_trang':
          columns.add(
            TableBaseConfig.columnTable<AssetManagementDto>(
              title: 'Hiện trạng',
              getValue: (item) => item.hienTrang?.toString() ?? '',
              width: 100,
            ),
          );
          break;
        case 'so_luong':
          columns.add(
            TableBaseConfig.columnTable<AssetManagementDto>(
              title: 'Số lượng',
              getValue: (item) => item.soLuong?.toString() ?? '',
              width: 100,
            ),
          );
          break;
        case 'don_vi_tinh':
          columns.add(
            TableBaseConfig.columnTable<AssetManagementDto>(
              title: 'Đơn vị tính',
              getValue: (item) => item.donViTinh ?? '',
              width: 100,
            ),
          );
          break;
        case 'ky_hieu':
          columns.add(
            TableBaseConfig.columnTable<AssetManagementDto>(
              title: 'Ký hiệu',
              getValue: (item) => item.kyHieu ?? '',
              width: 100,
            ),
          );
          break;
        case 'so_ky_hieu':
          columns.add(
            TableBaseConfig.columnTable<AssetManagementDto>(
              title: 'Số ký hiệu',
              getValue: (item) => item.soKyHieu ?? '',
              width: 120,
            ),
          );
          break;
        case 'nuoc_san_xuat':
          columns.add(
            TableBaseConfig.columnTable<AssetManagementDto>(
              title: 'Nước sản xuất',
              getValue: (item) => item.nuocSanXuat ?? '',
              width: 120,
            ),
          );
          break;
        case 'nam_san_xuat':
          columns.add(
            TableBaseConfig.columnTable<AssetManagementDto>(
              title: 'Năm sản xuất',
              getValue: (item) => item.namSanXuat?.toString() ?? '',
              width: 100,
            ),
          );
          break;
        case 'actions':
          columns.add(
            TableBaseConfig.columnWidgetBase<AssetManagementDto>(
              title: '',
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: ColorValue.accentCyan.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            // border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              SGText(
                text: 'Danh sách loại tài sản',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
              Divider(),
              Scrollbar(
                controller: horizontalController,
                thumbVisibility: true,
                thickness: 4,
                notificationPredicate:
                    (notification) =>
                        notification.metrics.axis == Axis.horizontal,
                child: SingleChildScrollView(
                  controller: horizontalController,
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 13.0),
                    child: Row(
                      spacing: 16,
                      children: [
                        ...widget.provider.dataGroup!.map(
                          (item) => ItemAssetGroup(
                            titleName: item.tenNhom,
                            numberAsset: getCountAssetByAssetManagement(
                              widget.provider.data!,
                              '${item.id}',
                            ),
                            image: "assets/images/assets.png",
                            onTap: () {
                              context.go(AppRoute.staffManager.path);
                            },
                            valueCheckBox: widget.provider.getCheckBoxStatus(
                              item.id,
                            ),
                            onChange: (value) {
                              widget.provider.updateCheckBoxStatus(
                                item.id,
                                value,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),

        _buildAssetManagementTable(),
      ],
    );
  }

  String getCountAssetByAssetManagement(
    List<AssetManagementDto> data,
    String idNhomTaiSan,
  ) {
    return data.where((i) => i.idNhomTaiSan == idNhomTaiSan).length.toString();
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

  Widget _buildAssetManagementTable() {
    final List<SgTableColumn<AssetManagementDto>> columns = _buildColumns();
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.table_chart,
                      color: Colors.grey.shade600,
                      size: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.5),
                      child: Text(
                        'Danh sách tài sản (${widget.provider.data.length})',
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
                        color: ColorValue.link,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                Tooltip(
                  message: 'Chuyển sang trang khấu hao tài sản',
                  child: InkWell(
                    onTap: () {
                      widget.provider.onChangeBody(ShowBody.khauHao);
                    },
                    child: SGText(
                      size: 14,
                      text: "Khấu hao tài sản",
                      color: ColorValue.link,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TableBaseView<AssetManagementDto>(
              searchTerm: '',
              columns: columns,
              data: widget.provider.filteredData ?? [],
              horizontalController: ScrollController(),
              getters: getters,
              startDate: DateTime.tryParse(
                widget.provider.filteredData?.first.ngayTao ?? '',
              ),
              onRowTap: (item) {
                widget.provider.onChangeDetail(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget viewAction(AssetManagementDto item) {
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
                title: 'Xóa nhóm tài sản',
                message: 'Bạn có chắc muốn xóa ${item.tenNhom}',
                highlight: item.tenNhom ?? '',
                cancelText: 'Không',
                confirmText: 'Xóa',
                onConfirm: () {
                  context.read<AssetManagementBloc>().add(
                    DeleteAssetEvent(context, item.id!),
                  );
                },
              ),
            },
      ),
    ]);
  }
}
