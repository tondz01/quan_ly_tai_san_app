// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/dieu_dong_tai_san_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/table/sg_table.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

import 'popup/columns_asset_handover.dart';

class PropertyHandoverMinutes {
  static void showPopup(BuildContext context, List<DieuDongTaiSanDto> data) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final popupWidth =
        screenWidth < 1100 ? screenWidth * 0.95 : screenWidth * 0.9;
    final popupHeight =
        screenHeight < 800 ? screenHeight * 0.9 : screenHeight * 0.8;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: popupWidth,
            height: popupHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: _PropertyHandoverMinutesContent(data: data),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.description, color: Colors.blue.shade700, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: SGText(
              text: 'Biên bản Bàn giao',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade800,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close, color: Colors.blue.shade700),
          ),
        ],
      ),
    );
  }
}

class _PropertyHandoverMinutesContent extends StatefulWidget {
  final List<DieuDongTaiSanDto> data;

  const _PropertyHandoverMinutesContent({required this.data});

  @override
  State<_PropertyHandoverMinutesContent> createState() =>
      _PropertyHandoverMinutesContentState();
}

class _PropertyHandoverMinutesContentState
    extends State<_PropertyHandoverMinutesContent> {
  final verticalScrollController = ScrollController();
  final horizontalScrollController = ScrollController();

  static const Map<String, Color> _statusColors = {
    'Nháp': ColorValue.silverGray,
    'Sẵn sàng': ColorValue.lightAmber,
    'Xác nhận': ColorValue.mediumGreen,
    'Trình Duyệt': ColorValue.lightBlue,
    'Hoàn thành': ColorValue.forestGreen,
    'Hủy': ColorValue.brightRed,
  };

  static const Map<String, int> _statusValues = {
    'Nháp': 0,
    'Sẵn sàng': 1,
    'Xác nhận': 2,
    'Trình Duyệt': 3,
    'Hoàn thành': 4,
    'Hủy': 5,
  };

  bool get _isSmallScreen => MediaQuery.of(context).size.width < 1100;

  @override
  Widget build(BuildContext context) {
    log(MediaQuery.of(context).size.width.toString());
    return Container(
      decoration: _buildContainerDecoration(),
      child: Column(
        children: [
          _buildTableHeader(),
          if (_isSmallScreen) _buildScrollIndicator(),
          Expanded(child: _buildTable()),
        ],
      ),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildTitleSection(), _buildStatusSummary()],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Row(
      children: [
        Icon(Icons.table_chart, color: Colors.grey.shade600, size: 18),
        const SizedBox(width: 8),
        Text(
          'Danh sách biên bản bàn giao (${widget.data.length})',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusSummary() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: _statusColors.entries.map(_buildStatusItem).toList(),
    );
  }

  Widget _buildStatusItem(MapEntry<String, Color> entry) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: entry.value,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '${entry.key} (${_getCountByState(entry.key)})',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildScrollIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Icon(Icons.swap_horiz, size: 16, color: Colors.blue.shade700),
          const SizedBox(width: 8),
          Text(
            'Có thể scroll ngang để xem thêm cột',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue.shade700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return Scrollbar(
      thumbVisibility: true,
      controller: verticalScrollController,
      child: SingleChildScrollView(
        controller: verticalScrollController,
        scrollDirection: Axis.vertical,
        child: Scrollbar(
          thumbVisibility: true,
          controller: horizontalScrollController,
          notificationPredicate:
              (notif) => notif.metrics.axis == Axis.horizontal,
          child: SingleChildScrollView(
            controller: horizontalScrollController,
            scrollDirection: Axis.horizontal,
            child: _buildTableWidget(),
          ),
        ),
      ),
    );
  }

  Widget _buildTableWidget() {
    final columns = _buildColumns();
    final table = SgTable<DieuDongTaiSanDto>(
      rowHeight: 45.0,
      data: widget.data,
      titleStyleHeader: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 13,
        color: Colors.black87,
      ),
      headerBackgroundColor: Colors.grey.shade100,
      oddRowBackgroundColor: Colors.white,
      evenRowBackgroundColor: Colors.grey.shade50,
      showVerticalLines: false,
      showHorizontalLines: true,
      columns: columns,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child:
          _isSmallScreen
              ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: columns.fold<double>(
                    0,
                    (sum, column) => sum + (column.width ?? 0),
                  ),
                  child: table,
                ),
              )
              : table,
    );
  }

  List<SgTableColumn<DieuDongTaiSanDto>> _buildColumns() {
    if (_isSmallScreen) {
      return _buildSmallScreenColumns();
    } else {
      return _buildLargeScreenColumns();
    }
  }

  List<SgTableColumn<DieuDongTaiSanDto>> _buildSmallScreenColumns() {
    const columnWidths = {
      'Quyết định điều động': 150.0,
      'Lệnh điều động': 200.0,
      'Ngày bàn giao': 120.0,
      'Chi tiết bàn giao': 200.0,
      'Đơn vị giao': 150.0,
      'Đơn vị nhận': 150.0,
      'Trạng thái': 120.0,
      'Actions': 100.0,
    };

    return _createColumns(context, columnWidths);
  }

  List<SgTableColumn<DieuDongTaiSanDto>> _buildLargeScreenColumns() {
    final screenWidth = MediaQuery.of(context).size.width * 0.9;
    final availableWidth = screenWidth - 40;

    final columnWidths = {
      'Quyết định điều động': availableWidth * 0.12,
      'Lệnh điều động': availableWidth * 0.17,
      'Ngày bàn giao': availableWidth * 0.1,
      'Chi tiết bàn giao': availableWidth * 0.17,
      'Đơn vị giao': availableWidth * 0.11,
      'Đơn vị nhận': availableWidth * 0.11,
      'Trạng thái': availableWidth * 0.12,
      'Actions': availableWidth * 0.1,
    };

    return _createColumns(context, columnWidths);
  }

  int _getCountByState(String key) {
    final status = _statusValues[key] ?? 0;
    return widget.data.where((item) => item.trangThai == status).length;
  }

  List<SgTableColumn<DieuDongTaiSanDto>> _createColumns(
    BuildContext context,
    Map<String, double> columnWidths,
  ) {
    return [
      TableColumnBuilder.createTextColumn<DieuDongTaiSanDto>(
        title: 'Quyết định điều động',
        textColor: Colors.black87,
        getValue: (item) => item.soQuyetDinh ?? '',
        fontSize: 12,
        width: columnWidths['Quyết định điều động']!,
      ),
      TableColumnBuilder.createTextColumn<DieuDongTaiSanDto>(
        title: 'Lệnh điều động',
        textColor: Colors.black87,
        fontSize: 12,
        getValue: (item) => item.tenPhieu ?? '',
        width: columnWidths['Lệnh điều động']!,
      ),
      TableColumnBuilder.createTextColumn<DieuDongTaiSanDto>(
        title: 'Ngày bàn giao',
        textColor: Colors.black87,
        fontSize: 12,
        getValue: (item) => item.ngayCapNhat ?? '',
        width: columnWidths['Ngày bàn giao']!,
      ),
      SgTableColumn<DieuDongTaiSanDto>(
        title: 'Chi tiết bàn giao',
        cellBuilder:
            (item) => AssetHandoverColumns.buildMovementDetails(
              item.chiTietDieuDongTaiSan ?? [],
            ),
        cellAlignment: TextAlign.center,
        titleAlignment: TextAlign.center,
        width: columnWidths['Chi tiết bàn giao']!,
      ),
      TableColumnBuilder.createTextColumn<DieuDongTaiSanDto>(
        title: 'Đơn vị giao',
        textColor: Colors.black87,
        fontSize: 12,
        getValue: (item) => item.tenDonViGiao ?? '',
        width: columnWidths['Đơn vị giao']!,
      ),
      TableColumnBuilder.createTextColumn<DieuDongTaiSanDto>(
        title: 'Đơn vị nhận',
        textColor: Colors.black87,
        fontSize: 12,
        getValue: (item) => item.tenDonViNhan ?? '',
        width: columnWidths['Đơn vị nhận']!,
      ),
      SgTableColumn<DieuDongTaiSanDto>(
        title: 'Trạng thái',
        cellBuilder:
            (item) => AssetHandoverColumns.buildStatus(item.trangThai ?? 0),
        cellAlignment: TextAlign.center,
        titleAlignment: TextAlign.center,
        width: columnWidths['Trạng thái']!,
      ),
      SgTableColumn<DieuDongTaiSanDto>(
        title: '',
        cellBuilder: (item) => AssetHandoverColumns.buildActions(context, item),
        cellAlignment: TextAlign.center,
        titleAlignment: TextAlign.center,
        width: columnWidths['Actions']!,
        searchable: true,
      ),
    ];
  }
}
