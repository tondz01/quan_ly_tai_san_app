import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/Category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_depreciation_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class AssetDepreciationList extends StatefulWidget {
  const AssetDepreciationList({super.key, required this.provider});
  final AssetManagementProvider provider;

  @override
  State<AssetDepreciationList> createState() => _AssetDepreciationListState();
}

class _AssetDepreciationListState extends State<AssetDepreciationList> {
  late List<ColumnDisplayOption> columnOptions;
  List<String> visibleColumnIds = [
    'ngayCuoiKyKh',
    'namCuaKy',
    'thangCuaKy',
    'butToanKhauHao',
    'boPhanSuDung',
    'taiSanKhauHao',
    'taiSanChiPhi',
    'giaTriKhauHao',
    'kyKhauHao',
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
        id: 'ngayCuoiKyKh',
        label: 'Ngày cuối kỳ Kh',
        isChecked: visibleColumnIds.contains('ngayCuoiKyKh'),
      ),
      ColumnDisplayOption(
        id: 'namCuaKy',
        label: 'Năm của kỳ',
        isChecked: visibleColumnIds.contains('namCuaKy'),
      ),
      ColumnDisplayOption(
        id: 'thangCuaKy',
        label: 'Tháng của kỳ',
        isChecked: visibleColumnIds.contains('thangCuaKy'),
      ),
      ColumnDisplayOption(
        id: 'butToanKhauHao',
        label: 'Bút toán khấu hao',
        isChecked: visibleColumnIds.contains('butToanKhauHao'),
      ),
      ColumnDisplayOption(
        id: 'name_asset',
        label: 'Tài sản',
        isChecked: visibleColumnIds.contains('name_asset'),
      ),
      ColumnDisplayOption(
        id: 'boPhanSuDung',
        label: 'Bộ phận sử dụng',
        isChecked: visibleColumnIds.contains('boPhanSuDung'),
      ),
      ColumnDisplayOption(
        id: 'taiSanKhauHao',
        label: 'Tài sản khấu hao',
        isChecked: visibleColumnIds.contains('taiSanKhauHao'),
      ),
      ColumnDisplayOption(
        id: 'taiSanChiPhi',
        label: 'Tài sản chi phí',
        isChecked: visibleColumnIds.contains('taiSanChiPhi'),
      ),
      ColumnDisplayOption(
        id: 'giaTriKhauHao',
        label: 'Giá trị khấu hao',
        isChecked: visibleColumnIds.contains('giaTriKhauHao'),
      ),
      ColumnDisplayOption(
        id: 'kyKhauHao',
        label: 'Kỳ khấu hao',
        isChecked: visibleColumnIds.contains('kyKhauHao'),
      ),
    ];
  }

  List<SgTableColumn<AssetDepreciationDto>> _buildColumns() {
    final List<SgTableColumn<AssetDepreciationDto>> columns = [];

    // Thêm cột dựa trên visibleColumnIds
    for (String columnId in visibleColumnIds) {
      switch (columnId) {
        case 'ngayCuoiKyKh':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Ngày cuối kỳ Kh',
              getValue: (item) => item.ngayTinhKhao.toString(),
              width: 120,
            ),
          );
          break;
        case 'namCuaKy':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Năm của kỳ',
              getValue: (item) => item.ngayTinhKhao?.year.toString() ?? '',
              width: 80,
            ),
          );
          break;
        case 'thangCuaKy':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Tháng của kỳ',
              getValue: (item) => item.thangKh.toString(),
              width: 80,
            ),
          );
          break;
        case 'butToanKhauHao':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Mã tài sản',
              getValue:
                  (item) =>
                      'Khấu hao ${item.soThe} - ${item.tenTaiSan}',
              width: 120,
            ),
          );
          break;
        case 'name_asset':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Tên tài sản',
              getValue: (item) => '${item.soThe} - ${item.tenTaiSan}',
              width: 200,
            ),
          );
          break;
        case 'boPhanSuDung':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Khấu hao Psdk',
              getValue: (item) => item.khauHaoPsdk.toString(),
              width: 120,
            ),
          );
          break;
        case 'taiSanKhauHao':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Tài sản khấu hao',
              getValue: (item) => item.maTk.toString(),
              width: 120,
            ),
          );
          break;
        case 'taiSanChiPhi':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Nguyên giá',
              getValue: (item) => item.khauHaoBanDau?.toString() ?? '',
              width: 150,
            ),
          );
          break;
        case 'giaTriKhauHao':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Khấu hao ban đầu',
              getValue: (item) => item.khauHaoBanDau?.toString() ?? '',
              width: 120,
            ),
          );
          break;
        case 'kyKhauHao':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Khấu hao kỳ trước',
              getValue: (item) => item.khKyTruoc.toString(),
              width: 120,
            ),
          );
          break;
      }
    }

    return columns;
  }

  String getBoPhanSuDung(String idTaisan) {
    AssetManagementDto data =
        widget.provider.data.where((item) => item.id == idTaisan).first;
    final departments = widget.provider.dataDepartment ?? [];
    final phongBan = departments.firstWhere(
      (dept) => dept.id == data.idDonViHienThoi,
      orElse: () => const PhongBan(),
    );
    return phongBan.tenPhongBan ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildAssetManagementTable()],
    );
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
    final List<SgTableColumn<AssetDepreciationDto>> columns = _buildColumns();
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
                  children: [
                    Icon(
                      Icons.table_chart,
                      color: Colors.grey.shade600,
                      size: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.5),
                      child: Text(
                        'Danh sách khấu hao(${widget.provider.dataKhauHao.length})',
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
              ],
            ),
          ),
          Expanded(
            child: TableBaseView<AssetDepreciationDto>(
              searchTerm: '',
              columns: columns,
              data: widget.provider.dataKhauHao ?? [],
              horizontalController: ScrollController(),
              onRowTap: (item) {
                widget.provider.onChangeDepreciationDetail(item);
              },
            ),
          ),
        ],
      ),
    );
  }
}
