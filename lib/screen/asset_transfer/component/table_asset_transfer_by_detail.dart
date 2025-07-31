// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/button/action_button_config.dart';
import 'package:quan_ly_tai_san_app/common/sg_download_file.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/web_view/web_view_common.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/property_handover_minutes.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/asset_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/asset_transfer_provider.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class TableAssetTransferByDetail extends StatefulWidget {
  final AssetTransferProvider provider;
  final List<AssetHandoverDto> listAssetHandover;
  const TableAssetTransferByDetail({
    super.key,
    required this.provider,
    required this.listAssetHandover,
  });

  @override
  State<TableAssetTransferByDetail> createState() =>
      _TableAssetTransferByDetailState();
}

class _TableAssetTransferByDetailState
    extends State<TableAssetTransferByDetail> {
  String url = '';

  Map<String, Color> listStatus = {
    'Nháp': ColorValue.silverGray,
    'Chờ xác nhận': ColorValue.lightAmber,
    'Xác nhận': ColorValue.mediumGreen,
    'Trình Duyệt': ColorValue.lightBlue,
    'Duyệt': ColorValue.cyan,
    'Từ chối': ColorValue.brightRed,
    'Hủy': ColorValue.coral,
    'Hoàn thành': ColorValue.forestGreen,
  };

  @override
  Widget build(BuildContext context) {
    final List<SgTableColumn<AssetTransferDto>> columns = [
      TableBaseConfig.columnTable<AssetTransferDto>(
        title: 'Phiếu ký nội sinh',
        width: 150,
        getValue: (item) => getName(item.type ?? 0),
      ),
      TableBaseConfig.columnTable<AssetTransferDto>(
        title: 'Ngày ký',
        width: 100,
        getValue: (item) => item.decisionDate ?? '',
      ),
      TableBaseConfig.columnTable<AssetTransferDto>(
        title: 'Ngày có hiệu lực',
        width: 100,
        getValue: (item) => item.effectiveDate ?? '',
      ),
      TableBaseConfig.columnTable<AssetTransferDto>(
        title: 'Trình duyệt ban giám đốc',
        width: 150,
        getValue: (item) => item.approver ?? '',
      ),
      SgTableColumn<AssetTransferDto>(
        title: 'Tài liệu duyệt',
        cellBuilder:
            (item) => SgDownloadFile(url: url, name: item.documentName ?? ''),
        sortValueGetter: (item) => item.documentFileName ?? '',
        searchValueGetter: (item) => item.documentFileName ?? '',
        cellAlignment: TextAlign.center,
        titleAlignment: TextAlign.center,
        width: 150,
        searchable: true,
      ),
      TableBaseConfig.columnTable<AssetTransferDto>(
        title: 'Ký số',
        width: 100,
        getValue: (item) => item.id ?? '',
      ),

      TableBaseConfig.columnWidgetBase<AssetTransferDto>(
        title: 'Trạng thái',
        cellBuilder: (item) => widget.provider.showStatus(item.status ?? 0),
        width: 150,
        searchable: true,
      ),
      TableBaseConfig.columnWidgetBase<AssetTransferDto>(
        title: '',
        cellBuilder: (item) => viewAction(item),
        width: 120,
        searchable: true,
      ),
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
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
                      'Danh sách phiếu cấp phát tài sản (${widget.provider.data.length})',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                buildTooltipStatus(),
              ],
            ),
          ),
          Expanded(
            child: TableBaseView<AssetTransferDto>(
              searchTerm: '',
              columns: columns,
              data: widget.provider.data,
              horizontalController: ScrollController(),
            ),
          ),
        ],
      ),
    );
  }

  Widget viewAction(AssetTransferDto item) {
    return viewActionButtons([
      ActionButtonConfig(
        icon: Icons.book_outlined,
        tooltip: 'Biên bản bản giao',
        iconColor: ColorValue.lightAmber,
        backgroundColor: Colors.red.shade50,
        borderColor: Colors.red.shade200,
        onPressed:
            () => PropertyHandoverMinutes.showPopup(
              context,
              widget.listAssetHandover
                  .where((itemAH) => itemAH.id == item.idAssetHandover)
                  .toList(),
            ),
      ),
      ActionButtonConfig(
        icon: Icons.visibility,
        tooltip: 'Xem',
        iconColor: ColorValue.cyan,
        backgroundColor: Colors.green.shade50,
        borderColor: Colors.green.shade200,
        onPressed:
            () => showWebViewPopup(
              context,
              url: url,
              title: item.documentName ?? 'Tài liệu',
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.9,
            ),
      ),
      ActionButtonConfig(
        icon: Icons.delete,
        tooltip: item.status != 0 ? null : 'Xóa',
        iconColor: item.status != 0 ? Colors.grey : Colors.red.shade700,
        backgroundColor: Colors.red.shade50,
        borderColor: Colors.red.shade200,
        onPressed:
            () => {
              if (item.status != 0) {widget.provider.deleteItem(item.id ?? '')},
            },
      ),
     
    ]);
  }

  Widget buildTooltipStatus() {
    return Row(
      children:
          listStatus.entries
              .map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(4),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: entry.value,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(width: 4),
                      SGText(
                        text: '${entry.key} (${getCountByState(entry.key)})',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }

  int getCountByState(String key) {
    int status;
    switch (key) {
      case 'Nháp':
        status = 0;
        break;
      case 'Chờ xác nhận':
        status = 1;
        break;
      case 'Xác nhận':
        status = 2;
        break;
      case 'Trình Duyệt':
        status = 3;
        break;
      case 'Duyệt':
        status = 4;
        break;
      case 'Từ chối':
        status = 5;
        break;
      case 'Hủy':
        status = 6;
        break;
      case 'Hoàn thành':
        status = 7;
      default:
        status = 0;
    }
    final count =
        widget.provider.data.where((item) => item.status == status).length;
    return count;
  }

  String getName(int type) {
    switch (type) {
      case 1:
        return 'Phiếu duyệt cấp phát tài sản';
      case 2:
        return 'Phiếu duyệt thu hồi tài sản';
      case 3:
        return 'Phiếu duyệt chuyển tài sản';
    }
    return '';
  }
}
