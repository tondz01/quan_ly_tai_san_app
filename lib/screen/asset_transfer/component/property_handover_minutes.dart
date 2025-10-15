// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/component/find_by_state_asset_handover.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/asset_handover_provider.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

import 'popup/columns_asset_handover.dart';

class PropertyHandoverMinutes {
  static void showPopup(BuildContext context, List<AssetHandoverDto> data) {
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
        color: Colors.green.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.description, color: Colors.green.shade700, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: SGText(
              text: 'Biên bản Bàn giao',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade800,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close, color: Colors.green.shade700),
          ),
        ],
      ),
    );
  }
}

class _PropertyHandoverMinutesContent extends StatefulWidget {
  final List<AssetHandoverDto> data;
  const _PropertyHandoverMinutesContent({required this.data});

  @override
  State<_PropertyHandoverMinutesContent> createState() =>
      _PropertyHandoverMinutesContentState();
}

class _PropertyHandoverMinutesContentState
    extends State<_PropertyHandoverMinutesContent> {
  late List<ColumnDisplayOption> columnOptions;

  @override
  void initState() {
    super.initState();
    _initializeColumnOptions();
  }

  List<String> visibleColumnIds = [
    'name',
    'decision_number',
    'transfer_order',
    'transfer_date',
    'movement_details',
    'sender_unit',
    'receiver_unit',
    'created_by',
    'status',
    'actions',
  ];

  void _initializeColumnOptions() {
    columnOptions = [
      ColumnDisplayOption(
        id: 'name',
        label: 'Bàn giao tài sản',
        isChecked: visibleColumnIds.contains('name'),
      ),
      ColumnDisplayOption(
        id: 'decision_number',
        label: 'Quyết định điều động',
        isChecked: visibleColumnIds.contains('decision_number'),
      ),
      ColumnDisplayOption(
        id: 'transfer_order',
        label: 'Lệnh điều động',
        isChecked: visibleColumnIds.contains('transfer_order'),
      ),
      ColumnDisplayOption(
        id: 'transfer_date',
        label: 'Ngày bàn giao',
        isChecked: visibleColumnIds.contains('transfer_date'),
      ),
      ColumnDisplayOption(
        id: 'sender_unit',
        label: 'Đơn vị giao',
        isChecked: visibleColumnIds.contains('sender_unit'),
      ),
      ColumnDisplayOption(
        id: 'receiver_unit',
        label: 'Đơn vị nhận',
        isChecked: visibleColumnIds.contains('receiver_unit'),
      ),
      ColumnDisplayOption(
        id: 'created_by',
        label: 'Người lập phiếu',
        isChecked: visibleColumnIds.contains('created_by'),
      ),
      ColumnDisplayOption(
        id: 'status',
        label: 'Trạng thái',
        isChecked: visibleColumnIds.contains('status'),
      ),
      ColumnDisplayOption(
        id: 'actions',
        label: 'Thao tác',
        isChecked: visibleColumnIds.contains('status'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    log(MediaQuery.of(context).size.width.toString());
    final List<SgTableColumn<AssetHandoverDto>> columns = _buildColumns();
    return Row(
      children: [
        // if (url.isNotEmpty && isShowPreview) displayPreview(),
        Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .05),
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
                              'Biên bản bàn giao tài sản (${widget.data.length})',
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
                              color: const Color(0xFF21A366),
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                      FindByStateAssetHandover(
                        provider: context.read<AssetHandoverProvider>(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TableBaseView<AssetHandoverDto>(
                    searchTerm: '',
                    columns: columns,
                    data: widget.data,
                    horizontalController: ScrollController(),
                    onRowTap: (item) {
                      // isShowPreview = true;
                      // widget.provider.onChangeDetail(context, item);
                    },
                    onSelectionChanged: (items) {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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

  List<SgTableColumn<AssetHandoverDto>> _buildColumns() {
    final List<SgTableColumn<AssetHandoverDto>> columns = [];

    // Thêm cột dựa trên visibleColumnIds
    for (String columnId in visibleColumnIds) {
      switch (columnId) {
        case 'name':
          columns.add(
            TableBaseConfig.columnTable<AssetHandoverDto>(
              title: 'Bàn giao tài sản',
              getValue: (item) => item.banGiaoTaiSan ?? '',
              width: 170,
            ),
          );
          break;
        case 'decision_number':
          columns.add(
            TableBaseConfig.columnTable<AssetHandoverDto>(
              title: 'Quyết định điều động',
              getValue: (item) => item.quyetDinhDieuDongSo ?? '',
              width: 120,
            ),
          );
          break;
        case 'transfer_order':
          columns.add(
            TableBaseConfig.columnTable<AssetHandoverDto>(
              title: 'Lệnh điều động',
              getValue: (item) => item.lenhDieuDong ?? '',
              width: 120,
            ),
          );
          break;
        case 'transfer_date':
          columns.add(
            TableBaseConfig.columnTable<AssetHandoverDto>(
              title: 'Ngày bàn giao',
              getValue:
                  (item) =>
                      item.ngayBanGiao != null
                          ? AppUtility.formatDateDdMmYyyy(
                            AppUtility.parseDate(item.ngayBanGiao) ??
                                DateTime.now(),
                          )
                          : '',
              width: 150,
            ),
          );
          break;
        case 'sender_unit':
          columns.add(
            TableBaseConfig.columnTable<AssetHandoverDto>(
              title: 'Đơn vị giao',
              getValue: (item) => item.tenDonViGiao ?? '',
              width: 120,
            ),
          );
          break;
        case 'receiver_unit':
          columns.add(
            TableBaseConfig.columnTable<AssetHandoverDto>(
              title: 'Đơn vị nhận',
              getValue: (item) => item.tenDonViNhan ?? '',
              width: 120,
            ),
          );
          break;
        case 'created_by':
          columns.add(
            TableBaseConfig.columnTable<AssetHandoverDto>(
              title: 'Người lập phiếu',
              getValue: (item) => item.nguoiTao ?? '',
              width: 120,
            ),
          );
          break;
        case 'status':
          columns.add(
            TableBaseConfig.columnWidgetBase<AssetHandoverDto>(
              title: 'Trạng thái',
              cellBuilder: (item) => showStatus(item.trangThai ?? 0),
              width: 150,
              searchable: true,
            ),
          );
          break;
        case 'actions':
          columns.add(
            TableBaseConfig.columnWidgetBase<AssetHandoverDto>(
              title: '',
              cellBuilder:
                  (item) => AssetHandoverColumns.buildActions(context, item),
              width: 120,
              searchable: true,
            ),
          );
          break;
      }
    }

    return columns;
  }

  Widget showStatus(int status) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 48.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: getColorStatus(status),
          borderRadius: BorderRadius.circular(4),
        ),
        child: SGText(
          text: getStatus(status),
          size: 12,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Color getColorStatus(int status) {
    switch (status) {
      case 0:
        return ColorValue.silverGray;
      case 1:
        return ColorValue.lightAmber;
      case 2:
        return ColorValue.mediumGreen;
      case 3:
        return ColorValue.forestGreen;
      case 4:
        return ColorValue.coral;
      default:
        return ColorValue.darkGrey;
    }
  }

  String getStatus(int status) {
    switch (status) {
      case 0:
        return 'Nháp';
      case 1:
        return 'Chờ xác nhận';
      case 2:
        return 'Chờ duyệt';
      case 3:
        return 'Hoàn thành';
      case 4:
        return 'Hủy';
      default:
        return '';
    }
  }
}
