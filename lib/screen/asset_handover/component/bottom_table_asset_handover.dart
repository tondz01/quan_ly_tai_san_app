// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:se_gay_components/common/table/sg_table.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

import 'columns_asset_handover_component.dart';

class BottomTableAssetHandover extends StatefulWidget {
  final List<AssetHandoverDto> data;
  const BottomTableAssetHandover({super.key, required this.data});

  @override
  State<BottomTableAssetHandover> createState() =>
      _BottomTableAssetHandoverState();
}

class _BottomTableAssetHandoverState extends State<BottomTableAssetHandover> {
  final ScrollController _scrollController = ScrollController();
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
    log("widget.data.length: ${widget.data.length}");
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: _buildContainerDecoration(),
      child: Column(
        children: [
          _buildTableHeader(),
          const SizedBox(height: 10),
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
    return SingleChildScrollView(child: _buildTableWidget());
  }

  Widget _buildTableWidget() {
    final columns = _buildColumns();
    final table = SgTable<AssetHandoverDto>(
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
              ? Scrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: columns.fold<double>(
                      0,
                      (sum, column) => sum + (column.width ?? 0),
                    ),
                    child: table,
                  ),
                ),
              )
              : table,
    );
  }

  List<SgTableColumn<AssetHandoverDto>> _buildColumns() {
    if (_isSmallScreen) {
      return _buildSmallScreenColumns();
    } else {
      return _buildLargeScreenColumns();
    }
  }

  List<SgTableColumn<AssetHandoverDto>> _buildSmallScreenColumns() {
    const columnWidths = {
      'Phiếu ký nội sinh': 150.0,
      'Ngày ký': 120.0,
      'Ngày hiệu lực': 120.0,
      'Trình duyệt ban giám đốc': 150.0,
      'Tài liệu duyệt': 150.0,
      'Có hiệu lực': 120.0,
      'Ký số': 150.0,
      'Actions': 150.0,
    };

    return createColumns(context, columnWidths);
  }

  List<SgTableColumn<AssetHandoverDto>> _buildLargeScreenColumns() {
    final screenWidth = MediaQuery.of(context).size.width * 0.9;
    final availableWidth = screenWidth - 40;

    final columnWidths = {
      'Phiếu ký nội sinh': availableWidth * 0.13,
      'Ngày ký': availableWidth * 0.12,
      'Ngày hiệu lực': availableWidth * 0.12,
      'Trình duyệt ban giám đốc': availableWidth * 0.12,
      'Tài liệu duyệt': availableWidth * 0.15,
      'Có hiệu lực': availableWidth * 0.1,
      'Ký số': availableWidth * 0.12,
      'Actions': availableWidth * 0.13,
    };

    return createColumns(context, columnWidths);
  }

  int _getCountByState(String key) {
    final status = _statusValues[key] ?? 0;
    return widget.data.where((item) => item.state == status).length;
  }
}
