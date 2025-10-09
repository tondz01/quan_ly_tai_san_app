import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_date.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_depreciation_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:intl/intl.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';
import 'package:se_gay_components/core/enum/sg_date_time_mode.dart';

class AssetDepreciationList extends StatefulWidget {
  const AssetDepreciationList({super.key, required this.provider});
  final AssetManagementProvider provider;

  @override
  State<AssetDepreciationList> createState() => _AssetDepreciationListState();
}

class _AssetDepreciationListState extends State<AssetDepreciationList> {
  late List<ColumnDisplayOption> columnOptions;
  final NumberFormat _vnNumber = NumberFormat('#,##0', 'vi_VN');

  TextEditingController ctrlSelectDate = TextEditingController();

  List<AssetDepreciationDto>? _dataKhauHao;
  List<AssetDepreciationDto>? _dataPage;
  List<AssetDepreciationDto>? _filteredData;

  late int totalEntries;
  late int totalPages = 1;
  late int startIndex;
  late int endIndex;
  int rowsPerPage = 10;
  int currentPage = 1;
  TextEditingController? controllerDropdownPage;

  // Cache cho columns để tránh tạo lại mỗi lần build
  List<SgTableColumn<AssetDepreciationDto>>? _cachedColumns;
  String? _lastVisibleColumnIdsHash;

  String _fmtNum(double? v) {
    if (v == null) return '';
    try {
      return _vnNumber.format(v);
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
    // 'nguonVon',
    'nvNS',
    'vonVay',
    'vonKhac',
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
    // 'khKyTruoc',
    // 'clKyTruoc',
    // 'hsdCkh',
    // 'tkNo',
    // 'tkCo',
    // 'dtgt',
    // 'dtth',
    // 'kmcp',
    // 'ghiChuKhao',
    // 'userId',
  ];
  @override
  void initState() {
    super.initState();
    _initializeColumnOptions();
    _initializeAllColumns(); // Khởi tạo tất cả columns
    _dataKhauHao = widget.provider.dataKhauHao ?? [];
    _filteredData = _dataKhauHao;
    controllerDropdownPage = TextEditingController(text: '10');
    ctrlSelectDate = TextEditingController(text: _fmtDate(DateTime.now()));
    _updatePagination();
    // Lắng nghe thay đổi từ provider để cập nhật UI khi dữ liệu khấu hao thay đổi
    widget.provider.addListener(_onProviderChanged);
  }

  @override
  void didUpdateWidget(covariant AssetDepreciationList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Nếu instance provider thay đổi, gỡ listener cũ và đăng ký lại
    if (oldWidget.provider != widget.provider) {
      oldWidget.provider.removeListener(_onProviderChanged);
      widget.provider.addListener(_onProviderChanged);
    }
  }

  void _onProviderChanged() {
    log(
      'providerChanged: isLoadingKhauHao=${widget.provider.isLoadingKhauHao}',
    );
    // Khi provider báo loading xong hoặc dữ liệu thay đổi, cập nhật danh sách và phân trang
    if (!widget.provider.isLoadingKhauHao) {
      setState(() {
        _dataKhauHao = widget.provider.dataKhauHao;
        _filteredData = _dataKhauHao;
        _updatePagination();
      });
      log(
        'getListKhauHaoSuccess providerChanged: ${widget.provider.dataKhauHao?.length}',
      );
    }
  }

  @override
  void dispose() {
    widget.provider.removeListener(_onProviderChanged);
    ctrlSelectDate.dispose();
    controllerDropdownPage?.dispose();
    super.dispose();
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
      // ColumnDisplayOption(
      //   id: 'nguonVon',
      //   label: 'Nguồn vốn',
      //   isChecked: visibleColumnIds.contains('nguonVon'),
      // ),
      ColumnDisplayOption(
        id: 'nvNS',
        label: 'Vốn NS',
        isChecked: visibleColumnIds.contains('nvNS'),
      ),
      ColumnDisplayOption(
        id: 'vonVay',
        label: 'Vốn vay',
        isChecked: visibleColumnIds.contains('vonVay'),
      ),
      ColumnDisplayOption(
        id: 'vonKhac',
        label: 'Vốn khác',
        isChecked: visibleColumnIds.contains('vonKhac'),
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

  // Tạo map chứa tất cả columns để tránh switch case
  late final Map<String, SgTableColumn<AssetDepreciationDto>> _allColumns;

  void _initializeAllColumns() {
    _allColumns = {
      'soThe': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'Số thẻ',
        getValue: (item) => item.soThe ?? '',
        width: 120,
        searchValueGetter: (item) => item.soThe ?? '',
      ),
      'tenTaiSan': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'Tên tài sản',
        getValue: (item) => item.tenTaiSan ?? '',
        width: 220,
        searchValueGetter: (item) => item.tenTaiSan ?? '',
      ),
      'nvNS': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'Vốn NS',
        getValue: (item) => _fmtNum(item.nvNS),
        width: 140,
        searchValueGetter: (item) => _fmtNum(item.nvNS),
      ),
      'vonVay': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'Vốn vay',
        getValue: (item) => _fmtNum(item.vonVay),
        width: 140,
        searchValueGetter: (item) => _fmtNum(item.vonVay),
      ),
      'vonKhac': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'Vốn khác',
        getValue: (item) => _fmtNum(item.vonKhac),
        width: 140,
        searchValueGetter: (item) => _fmtNum(item.vonKhac),
      ),
      'maTk': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'Mã tài khoản',
        getValue: (item) => item.maTk ?? '',
        width: 140,
        searchValueGetter: (item) => item.maTk ?? '',
      ),
      'ngayTinhKhao': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'Ngày tính khấu hao',
        getValue: (item) => _fmtDate(item.ngayTinhKhao),
        width: 160,
        searchValueGetter: (item) => _fmtDate(item.ngayTinhKhao),
      ),
      'thangKh': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'Tháng khấu hao',
        getValue: (item) => item.thangKh?.toString() ?? '',
        width: 100,
        searchValueGetter: (item) => item.thangKh?.toString() ?? '',
      ),
      'nguyenGia': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'Nguyên giá',
        getValue: (item) => _fmtNum(item.nguyenGia),
        width: 140,
        searchValueGetter: (item) => _fmtNum(item.nguyenGia),
      ),
      'khauHaoBanDau': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'Khấu hao ban đầu',
        getValue: (item) => _fmtNum(item.khauHaoBanDau),
        width: 140,
        searchValueGetter: (item) => _fmtNum(item.khauHaoBanDau),
      ),
      'khauHaoPsdk': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'Khấu hao PSDK',
        getValue: (item) => _fmtNum(item.khauHaoPsdk),
        width: 140,
        searchValueGetter: (item) => _fmtNum(item.khauHaoPsdk),
      ),
      'gtclBanDau': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'GTCL ban đầu',
        getValue: (item) => _fmtNum(item.gtclBanDau),
        width: 140,
        searchValueGetter: (item) => _fmtNum(item.gtclBanDau),
      ),
      'khauHaoPsck': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'Khấu hao PSCK',
        getValue: (item) => _fmtNum(item.khauHaoPsck),
        width: 140,
        searchValueGetter: (item) => _fmtNum(item.khauHaoPsck),
      ),
      'gtclHienTai': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'GTCL hiện tại',
        getValue: (item) => _fmtNum(item.gtclHienTai),
        width: 140,
        searchValueGetter: (item) => _fmtNum(item.gtclHienTai),
      ),
      'khauHaoBinhQuan': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'Khấu hao bình quân',
        getValue: (item) => _fmtNum(item.khauHaoBinhQuan),
        width: 140,
        searchValueGetter: (item) => _fmtNum(item.khauHaoBinhQuan),
      ),
      'soTien': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'Số tiền',
        getValue: (item) => _fmtNum(item.soTien),
        width: 120,
        searchValueGetter: (item) => _fmtNum(item.soTien),
      ),
      'chenhLech': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'Chênh lệch',
        getValue: (item) => _fmtNum(item.chenhLech),
        width: 120,
        searchValueGetter: (item) => _fmtNum(item.chenhLech),
      ),
      'khKyTruoc': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'Khấu hao kỳ trước',
        getValue: (item) => _fmtNum(item.khKyTruoc),
        width: 140,
        searchValueGetter: (item) => _fmtNum(item.khKyTruoc),
      ),
      'clKyTruoc': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'Chênh lệch kỳ trước',
        getValue: (item) => _fmtNum(item.clKyTruoc),
        width: 140,
        searchValueGetter: (item) => _fmtNum(item.clKyTruoc),
      ),
      'hsdCkh': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'HSDCKH',
        getValue: (item) => _fmtNum(item.hsdCkh),
        width: 120,
        searchValueGetter: (item) => _fmtNum(item.hsdCkh),
      ),
      'tkNo': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'Tài khoản nợ',
        getValue: (item) => item.tkNo ?? '',
        width: 140,
        searchValueGetter: (item) => item.tkNo ?? '',
      ),
      'tkCo': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'Tài khoản có',
        getValue: (item) => item.tkCo ?? '',
        width: 140,
        searchValueGetter: (item) => item.tkCo ?? '',
      ),
      'dtgt': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'DTGT',
        getValue: (item) => item.dtgt ?? '',
        width: 100,
        searchValueGetter: (item) => item.dtgt ?? '',
      ),
      'dtth': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'DTTH',
        getValue: (item) => item.dtth ?? '',
        width: 100,
        searchValueGetter: (item) => item.dtth ?? '',
      ),
      'kmcp': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'KMCP',
        getValue: (item) => item.kmcp ?? '',
        width: 100,
        searchValueGetter: (item) => item.kmcp ?? '',
      ),
      'ghiChuKhao': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'Ghi chú khấu hao',
        getValue: (item) => item.ghiChuKhao ?? '',
        width: 220,
        searchValueGetter: (item) => item.ghiChuKhao ?? '',
      ),
      'userId': TableBaseConfig.columnTable<AssetDepreciationDto>(
        title: 'Người tạo',
        getValue: (item) => item.userId ?? '',
        width: 120,
        searchValueGetter: (item) => item.userId ?? '',
      ),
    };
  }

  List<SgTableColumn<AssetDepreciationDto>> _buildColumns() {
    // Tạo hash để kiểm tra xem visibleColumnIds có thay đổi không
    final currentHash = visibleColumnIds.join(',');

    // Nếu columns đã được cache và visibleColumnIds không thay đổi, trả về cache
    if (_cachedColumns != null && _lastVisibleColumnIdsHash == currentHash) {
      return _cachedColumns!;
    }

    // Tạo columns mới dựa trên visibleColumnIds
    final columns = <SgTableColumn<AssetDepreciationDto>>[];
    for (final columnId in visibleColumnIds) {
      final column = _allColumns[columnId];
      if (column != null) {
        columns.add(column);
      }
    }

    // Cache kết quả
    _cachedColumns = columns;
    _lastVisibleColumnIdsHash = currentHash;

    return columns;
  }

  void _updatePagination() {
    totalEntries = _filteredData?.length ?? 0;
    totalPages = (totalEntries / rowsPerPage).ceil().clamp(1, 9999);
    startIndex = (currentPage - 1) * rowsPerPage;
    endIndex = (startIndex + rowsPerPage).clamp(0, totalEntries);

    if (startIndex >= totalEntries && totalEntries > 0) {
      currentPage = 1;
      startIndex = 0;
      endIndex = rowsPerPage.clamp(0, totalEntries);
    }

    _dataPage =
        _filteredData?.isNotEmpty ?? false
            ? _filteredData!.sublist(
              startIndex < totalEntries ? startIndex : 0,
              endIndex < totalEntries ? endIndex : totalEntries,
            )
            : [];
  }

  void onPageChanged(int page) {
    setState(() {
      currentPage = page;
      _updatePagination();
    });
  }

  void onRowsPerPageChanged(int? value) {
    if (value == null) return;

    setState(() {
      rowsPerPage = value;
      currentPage = 1;
      _updatePagination();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildAssetManagementTable()],
    );
  }

  // Removed duplicate dispose; consolidated cleanup in the first dispose()

  void _showColumnDisplayPopup() async {
    await showColumnDisplayPopup(
      context: context,
      columns: columnOptions,
      onSave: (selectedColumns) {
        setState(() {
          visibleColumnIds = selectedColumns;
          _updateColumnOptions();
          // Xóa cache để force rebuild columns
          _cachedColumns = null;
          _lastVisibleColumnIdsHash = null;
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
      height: MediaQuery.of(context).size.height * 0.8,

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
                        'Danh sách khấu hao(${widget.provider.dataKhauHao?.length ?? 0})',
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

                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 128,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 180),
                      child: CmFormDate(
                        sizePadding: 0,
                        label: 'Chọn thời gian khấu hao',
                        controller: ctrlSelectDate,
                        isEditing: true,
                        onChanged: (value) {
                          widget.provider.getDepreciationByDate(
                            context,
                            value ?? DateTime.now(),
                          );
                          setState(() {});
                        },
                        dateTimeMode: SGDateTimeMode.monthYear,
                        showTimeSection: false,
                        // value:
                        //     ctrlSelectDate.text.isNotEmpty
                        //         ? AppUtility.parseFlexibleDateTime(
                        //           ctrlSelectDate.text,
                        //         )
                        //         : DateTime.now(),
                      ),
                    ),
                    Tooltip(
                      message: 'Chuyển sang trang quản lý tài sản',
                      child: InkWell(
                        onTap: () {
                          widget.provider.onChangeBody(
                            ShowBody.taiSan,
                            context,
                          );
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
              ],
            ),
          ),
          Expanded(
            child:
                widget.provider.isLoadingKhauHao
                    ? Center(child: CircularProgressIndicator())
                    : widget.provider.dataKhauHao?.isEmpty ?? true
                        ? Center(child: Text('Không có dữ liệu'))
                        : TableBaseView<AssetDepreciationDto>(
                          searchTerm: '',
                          columns: columns,
                          data: _dataPage ?? [],
                          horizontalController: ScrollController(),
                          onRowTap: (item) {
                            widget.provider.onChangeDepreciationDetail(item);
                          },
                        ),
          ),

          Visibility(
            visible: (widget.provider.dataKhauHao?.length ?? 0) >= 5,
            child: SGPaginationControls(
              totalPages: totalPages,
              currentPage: currentPage,
              rowsPerPage: rowsPerPage,
              controllerDropdownPage: controllerDropdownPage!,
              items: widget.provider.items,
              onPageChanged: onPageChanged,
              onRowsPerPageChanged: onRowsPerPageChanged,
            ),
          ),
        ],
      ),
    );
  }
}
