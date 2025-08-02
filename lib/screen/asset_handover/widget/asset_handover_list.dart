// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/component/find_by_state_asset_handover.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_movement_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/asset_handover_provider.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class AssetHandoverList extends StatefulWidget {
  final AssetHandoverProvider provider;
  const AssetHandoverList({
    super.key,
    required this.provider,
  });

  @override
  State<AssetHandoverList> createState() => _AssetHandoverListState();
}

class _AssetHandoverListState extends State<AssetHandoverList> {
  final ScrollController horizontalController = ScrollController();
  String searchTerm = "";

  @override
  Widget build(BuildContext context) {
    final List<SgTableColumn<AssetHandoverDto>> columns = [
      TableBaseConfig.columnTable<AssetHandoverDto>(
        title: 'Bàn giao tài sản',
        getValue: (item) => item.name ?? '',
        width: 170,
      ),
      TableBaseConfig.columnTable<AssetHandoverDto>(
        title: 'Quyết định điều động',
        getValue: (item) => item.decisionNumber ?? '',
        width: 120,
      ),
      TableBaseConfig.columnTable<AssetHandoverDto>(
        title: 'Lệnh điều động',
        getValue: (item) => item.transferDate ?? '',
        width: 120,
      ),
      TableBaseConfig.columnTable<AssetHandoverDto>(
        title: 'Ngày bàn giao',
        getValue: (item) => item.transferDate ?? '',
        width: 150,
      ),
      SgTableColumn<AssetHandoverDto>(
        title: 'Chi tiết bàn giao',
        cellBuilder:
            (item) => showMovementDetails(item.assetHandoverMovements ?? []),
        cellAlignment: TextAlign.center,
        titleAlignment: TextAlign.center,
        width: 120,
        searchable: true,
      ),
      TableBaseConfig.columnTable<AssetHandoverDto>(
        title: 'Đơn vị giao',
        getValue: (item) => item.senderUnit ?? '',
        width: 120,
      ),
      TableBaseConfig.columnTable<AssetHandoverDto>(
        title: 'Đơn vị nhận',
        getValue: (item) => item.receiverUnit ?? '',
        width: 120,
      ),
      TableBaseConfig.columnTable<AssetHandoverDto>(
        title: 'Người lập phiếu',
        getValue: (item) => item.createdBy ?? '',
        width: 120,
      ),
      TableBaseConfig.columnWidgetBase<AssetHandoverDto>(
        title: 'Trạng thái',
        cellBuilder: (item) => showStatus(item.state ?? 0),
        width: 150,
        searchable: true,
      ),
    ];

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
                  children: [
                    Icon(
                      Icons.table_chart,
                      color: Colors.grey.shade600,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Biên bản bàn giao tài sản (${widget.provider.data.length})',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                FindByStateAssetHandover(provider: widget.provider),
              ],
            ),
          ),
          Expanded(
            child: TableBaseView<AssetHandoverDto>(
              searchTerm: '',
              columns: columns,
              data: widget.provider.dataPage ?? [],
              horizontalController: ScrollController(),
              onRowTap: (item) {
                widget.provider.onChangeDetail(context, item);
              },
            ),
          ),
        ],
      ),
    );
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

  Widget showMovementDetails(List<AssetHandoverMovementDto> movementDetails) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 48.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children:
                movementDetails
                    .map(
                      (detail) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        margin: const EdgeInsets.only(bottom: 2),
                        decoration: BoxDecoration(
                          color: ColorValue.paleRose,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: SGText(
                          text: detail.name ?? '',
                          size: 12,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    )
                    .toList(),
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
        return ColorValue.lightBlue;
      case 4:
        return ColorValue.forestGreen;
      case 5:
        return ColorValue.coral;
      default:
        return ColorValue.darkGrey;
    }
  }

  //  all('Tất cả', ColorValue.darkGrey),
  //   draft('Nháp', ColorValue.silverGray),
  //   ready('Sẵn sàng', ColorValue.lightAmber),
  //   confirm('Xác nhận', ColorValue.mediumGreen),
  //   browser('Trình duyệt', ColorValue.lightBlue),
  //   complete('Hoàn thành', ColorValue.forestGreen),
  //   cancel('Hủy', ColorValue.coral);
  String getStatus(int status) {
    switch (status) {
      case 0:
        return 'Nháp';
      case 1:
        return 'Sẵn sàng';
      case 2:
        return 'Xác nhận';
      case 3:
        return 'Trình Duyệt';
      case 4:
        return 'Hoàn thành';
      case 5:
        return 'Hủy';
      default:
        return '';
    }
  }

  Widget _buildPaginationControls(AssetHandoverProvider provider) {
    // Check if pagination is disabled or controller is null
    if (provider.controllerDropdownPage == null) {
      return const SizedBox(); // Return empty widget
    }
    return Visibility(
      visible: (provider.data?.length ?? 0) >= 5,
      child: SGPaginationControls(
        totalPages: provider.totalPages,
        currentPage: provider.currentPage,
        rowsPerPage: provider.rowsPerPage,
        controllerDropdownPage: provider.controllerDropdownPage!,
        items: provider.items,
        onPageChanged: provider.onPageChanged,
        onRowsPerPageChanged: provider.onRowsPerPageChanged,
      ),
    );
  }
}
