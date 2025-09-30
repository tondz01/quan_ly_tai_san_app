import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_depreciation_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:intl/intl.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class AssetDepreciationList extends StatefulWidget {
  const AssetDepreciationList({super.key, required this.provider});
  final AssetManagementProvider provider;

  @override
  State<AssetDepreciationList> createState() => _AssetDepreciationListState();
}

class _AssetDepreciationListState extends State<AssetDepreciationList> {
  late List<ColumnDisplayOption> columnOptions;
  final NumberFormat _vnNumber = NumberFormat('#,##0', 'vi_VN');

  String _fmtNum(double? v) {
    if (v == null) return '';
    try {
      return "${_vnNumber.format(v)}đ";
    } catch (_) {
      return v.toString();
    }
  }

  String _fmtDate(DateTime? d) {
    if (d == null) return '';
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd/$mm/$yyyy';
  }

  List<String> visibleColumnIds = [
    'soThe',
    'tenTaiSan',
    'nguonVon',
    'maTk',
    'ngayTinhKhao',
    'thangKh',
    'nguyenGia',
    'khauHaoBanDau',
    'khauHaoPsdk',
    'gtclBanDau',
    'khauHaoPsck',
    'gtclHienTai',
    'khauHaoBinhQuan',
    'soTien',
    'chenhLech',
    'khKyTruoc',
    'clKyTruoc',
    'hsdCkh',
    'tkNo',
    'tkCo',
    'dtgt',
    'dtth',
    'kmcp',
    'ghiChuKhao',
    'userId',
  ];
  @override
  void initState() {
    super.initState();
    _initializeColumnOptions();
  }

  void _initializeColumnOptions() {
    columnOptions = [
      ColumnDisplayOption(
        id: 'soThe',
        label: 'Số thẻ',
        isChecked: visibleColumnIds.contains('soThe'),
      ),
      ColumnDisplayOption(
        id: 'tenTaiSan',
        label: 'Tên tài sản',
        isChecked: visibleColumnIds.contains('tenTaiSan'),
      ),
      ColumnDisplayOption(
        id: 'nguonVon',
        label: 'Nguồn vốn',
        isChecked: visibleColumnIds.contains('nguonVon'),
      ),
      ColumnDisplayOption(
        id: 'maTk',
        label: 'Mã tài khoản',
        isChecked: visibleColumnIds.contains('maTk'),
      ),
      ColumnDisplayOption(
        id: 'ngayTinhKhao',
        label: 'Ngày tính khấu hao',
        isChecked: visibleColumnIds.contains('ngayTinhKhao'),
      ),
      ColumnDisplayOption(
        id: 'thangKh',
        label: 'Tháng khấu hao',
        isChecked: visibleColumnIds.contains('thangKh'),
      ),
      ColumnDisplayOption(
        id: 'nguyenGia',
        label: 'Nguyên giá',
        isChecked: visibleColumnIds.contains('nguyenGia'),
      ),
      ColumnDisplayOption(
        id: 'khauHaoBanDau',
        label: 'Khấu hao ban đầu',
        isChecked: visibleColumnIds.contains('khauHaoBanDau'),
      ),
      ColumnDisplayOption(
        id: 'khauHaoPsdk',
        label: 'Khấu hao PSDK',
        isChecked: visibleColumnIds.contains('khauHaoPsdk'),
      ),
      ColumnDisplayOption(
        id: 'gtclBanDau',
        label: 'GTCL ban đầu',
        isChecked: visibleColumnIds.contains('gtclBanDau'),
      ),
      ColumnDisplayOption(
        id: 'khauHaoPsck',
        label: 'Khấu hao PSCK',
        isChecked: visibleColumnIds.contains('khauHaoPsck'),
      ),
      ColumnDisplayOption(
        id: 'gtclHienTai',
        label: 'GTCL hiện tại',
        isChecked: visibleColumnIds.contains('gtclHienTai'),
      ),
      ColumnDisplayOption(
        id: 'khauHaoBinhQuan',
        label: 'Khấu hao bình quân',
        isChecked: visibleColumnIds.contains('khauHaoBinhQuan'),
      ),
      ColumnDisplayOption(
        id: 'soTien',
        label: 'Số tiền',
        isChecked: visibleColumnIds.contains('soTien'),
      ),
      ColumnDisplayOption(
        id: 'chenhLech',
        label: 'Chênh lệch',
        isChecked: visibleColumnIds.contains('chenhLech'),
      ),
      ColumnDisplayOption(
        id: 'khKyTruoc',
        label: 'Khấu hao kỳ trước',
        isChecked: visibleColumnIds.contains('khKyTruoc'),
      ),
      ColumnDisplayOption(
        id: 'clKyTruoc',
        label: 'Chênh lệch kỳ trước',
        isChecked: visibleColumnIds.contains('clKyTruoc'),
      ),
      ColumnDisplayOption(
        id: 'hsdCkh',
        label: 'HSDCKH',
        isChecked: visibleColumnIds.contains('hsdCkh'),
      ),
      ColumnDisplayOption(
        id: 'tkNo',
        label: 'Tài khoản nợ',
        isChecked: visibleColumnIds.contains('tkNo'),
      ),
      ColumnDisplayOption(
        id: 'tkCo',
        label: 'Tài khoản có',
        isChecked: visibleColumnIds.contains('tkCo'),
      ),
      ColumnDisplayOption(
        id: 'dtgt',
        label: 'DTGT',
        isChecked: visibleColumnIds.contains('dtgt'),
      ),
      ColumnDisplayOption(
        id: 'dtth',
        label: 'DTTH',
        isChecked: visibleColumnIds.contains('dtth'),
      ),
      ColumnDisplayOption(
        id: 'kmcp',
        label: 'KMCP',
        isChecked: visibleColumnIds.contains('kmcp'),
      ),
      ColumnDisplayOption(
        id: 'ghiChuKhao',
        label: 'Ghi chú khấu hao',
        isChecked: visibleColumnIds.contains('ghiChuKhao'),
      ),
      ColumnDisplayOption(
        id: 'userId',
        label: 'Người tạo',
        isChecked: visibleColumnIds.contains('userId'),
      ),
    ];
  }

  List<SgTableColumn<AssetDepreciationDto>> _buildColumns() {
    final List<SgTableColumn<AssetDepreciationDto>> columns = [];

    // Thêm cột dựa trên visibleColumnIds
    for (String columnId in visibleColumnIds) {
      switch (columnId) {
        case 'soThe':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Số thẻ',
              getValue: (item) => item.soThe ?? '',
              width: 120,
              searchValueGetter: (item) => item.soThe ?? '',
              filterable: true,
            ),
          );
          break;
        case 'tenTaiSan':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Tên tài sản',
              getValue: (item) => item.tenTaiSan ?? '',
              width: 220,
              searchValueGetter: (item) => item.tenTaiSan ?? '',
              filterable: true,
            ),
          );
          break;
        case 'nguonVon':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Nguồn vốn',
              getValue: (item) => item.nguonVon ?? '',
              width: 140,
              searchValueGetter: (item) => item.nguonVon ?? '',
              filterable: true,
            ),
          );
          break;
        case 'maTk':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Mã tài khoản',
              getValue: (item) => item.maTk ?? '',
              width: 140,
              searchValueGetter: (item) => item.maTk ?? '',
              filterable: true,
            ),
          );
          break;
        case 'ngayTinhKhao':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Ngày tính khấu hao',
              getValue: (item) => _fmtDate(item.ngayTinhKhao),
              width: 160,
              searchValueGetter: (item) => _fmtDate(item.ngayTinhKhao),
              filterable: true,
            ),
          );
          break;
        case 'thangKh':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Tháng khấu hao',
              getValue: (item) => item.thangKh?.toString() ?? '',
              width: 100,
              searchValueGetter: (item) => item.thangKh?.toString() ?? '',
              filterable: true,
            ),
          );
          break;
        case 'nguyenGia':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Nguyên giá',
              getValue: (item) => _fmtNum(item.nguyenGia),
              width: 140,
              searchValueGetter: (item) => _fmtNum(item.nguyenGia),
              filterable: true,
            ),
          );
          break;
        case 'khauHaoBanDau':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Khấu hao ban đầu',
              getValue: (item) => _fmtNum(item.khauHaoBanDau),
              width: 140,
              searchValueGetter: (item) => _fmtNum(item.khauHaoBanDau),
              filterable: true,
            ),
          );
          break;
        case 'khauHaoPsdk':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Khấu hao PSDK',
              getValue: (item) => _fmtNum(item.khauHaoPsdk),
              width: 140,
              searchValueGetter: (item) => _fmtNum(item.khauHaoPsdk),
              filterable: true,
            ),
          );
          break;
        case 'gtclBanDau':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'GTCL ban đầu',
              getValue: (item) => _fmtNum(item.gtclBanDau),
              width: 140,
              searchValueGetter: (item) => _fmtNum(item.gtclBanDau),
              filterable: true,
            ),
          );
          break;
        case 'khauHaoPsck':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Khấu hao PSCK',
              getValue: (item) => _fmtNum(item.khauHaoPsck),
              width: 140,
              searchValueGetter: (item) => _fmtNum(item.khauHaoPsck),
              filterable: true,
            ),
          );
          break;
        case 'gtclHienTai':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'GTCL hiện tại',
              getValue: (item) => _fmtNum(item.gtclHienTai),
              width: 140,
              searchValueGetter: (item) => _fmtNum(item.gtclHienTai),
              filterable: true,
            ),
          );
          break;
        case 'khauHaoBinhQuan':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Khấu hao bình quân',
              getValue: (item) => _fmtNum(item.khauHaoBinhQuan),
              width: 140,
              searchValueGetter: (item) => _fmtNum(item.khauHaoBinhQuan),
              filterable: true,
            ),
          );
          break;
        case 'soTien':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Số tiền',
              getValue: (item) => _fmtNum(item.soTien),
              width: 120,
              searchValueGetter: (item) => _fmtNum(item.soTien),
              filterable: true,
            ),
          );
          break;
        case 'chenhLech':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Chênh lệch',
              getValue: (item) => _fmtNum(item.chenhLech),
              width: 120,
              searchValueGetter: (item) => _fmtNum(item.chenhLech),
              filterable: true,
            ),
          );
          break;
        case 'khKyTruoc':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Khấu hao kỳ trước',
              getValue: (item) => _fmtNum(item.khKyTruoc),
              width: 140,
              searchValueGetter: (item) => _fmtNum(item.khKyTruoc),
              filterable: true,
            ),
          );
          break;
        case 'clKyTruoc':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Chênh lệch kỳ trước',
              getValue: (item) => _fmtNum(item.clKyTruoc),
              width: 140,
              searchValueGetter: (item) => _fmtNum(item.clKyTruoc),
              filterable: true,
            ),
          );
          break;
        case 'hsdCkh':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'HSDCKH',
              getValue: (item) => _fmtNum(item.hsdCkh),
              width: 120,
              searchValueGetter: (item) => _fmtNum(item.hsdCkh),
              filterable: true,
            ),
          );
          break;
        case 'tkNo':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Tài khoản nợ',
              getValue: (item) => item.tkNo ?? '',
              width: 140,
              searchValueGetter: (item) => item.tkNo ?? '',
              filterable: true,
            ),
          );
          break;
        case 'tkCo':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Tài khoản có',
              getValue: (item) => item.tkCo ?? '',
              width: 140,
              searchValueGetter: (item) => item.tkCo ?? '',
              filterable: true,
            ),
          );
          break;
        case 'dtgt':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'DTGT',
              getValue: (item) => item.dtgt ?? '',
              width: 100,
              searchValueGetter: (item) => item.dtgt ?? '',
              filterable: true,
            ),
          );
          break;
        case 'dtth':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'DTTH',
              getValue: (item) => item.dtth ?? '',
              width: 100,
              searchValueGetter: (item) => item.dtth ?? '',
              filterable: true,
            ),
          );
          break;
        case 'kmcp':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'KMCP',
              getValue: (item) => item.kmcp ?? '',
              width: 100,
              searchValueGetter: (item) => item.kmcp ?? '',
              filterable: true,
            ),
          );
          break;
        case 'ghiChuKhao':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Ghi chú khấu hao',
              getValue: (item) => item.ghiChuKhao ?? '',
              width: 220,
              searchValueGetter: (item) => item.ghiChuKhao ?? '',
              filterable: true,
            ),
          );
          break;
        case 'userId':
          columns.add(
            TableBaseConfig.columnTable<AssetDepreciationDto>(
              title: 'Người tạo',
              getValue: (item) => item.userId ?? '',
              width: 120,
              searchValueGetter: (item) => item.userId ?? '',
              filterable: true,
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
                Tooltip(
                  message: 'Chuyển sang trang quản lý tài sản',
                  child: InkWell(
                    onTap: () {
                      widget.provider.onChangeBody(ShowBody.taiSan);
                    },
                    child: SGText(
                      size: 14,
                      text: "Quản lý tài sản",
                      color: ColorValue.link,
                    ),
                  ),
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
