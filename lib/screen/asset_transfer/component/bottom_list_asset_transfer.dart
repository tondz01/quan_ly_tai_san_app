// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/download_file.dart';
import 'package:quan_ly_tai_san_app/common/web_view/web_view_common.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/popup_show_detail.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/property_handover_minutes.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/asset_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/asset_transfer_provider.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class BottomListAssetTransfer extends StatefulWidget {
  final AssetTransferProvider provider;
  final List<AssetHandoverDto> listAssetHandover;
  const BottomListAssetTransfer({
    super.key,
    required this.provider,
    required this.listAssetHandover,
  });

  @override
  State<BottomListAssetTransfer> createState() =>
      _BottomListAssetTransferState();
}

class _BottomListAssetTransferState extends State<BottomListAssetTransfer> {
  String url =
      'https://firebasestorage.googleapis.com/v0/b/shopifyappdata.appspot.com/o/document%2FQuy%E1%BA%BFt%20%C4%91%E1%BB%8Bnh%20C%E1%BA%A5p%20ph%C3%A1t%20t%C3%A0i%20s%E1%BA%A3n%20t%C3%A0i%20s%E1%BA%A3n.pdf?alt=media&token=cddb7a63-4c00-4954-99a8-afc27deb1996';

final ScrollController scrollController = ScrollController();
  bool isShowPhieuCapPhat = false;

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
    return onShowPhieuCapPhat();
  }

  Widget onShowPhieuCapPhat() {
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth - 50; // Trừ padding và margin

    // Tính toán width cho từng cột dựa trên tỷ lệ
    final columnWidths = {
      'Phiếu ký nội sinh': availableWidth * 0.15, // 20%
      'Ngày ký': availableWidth * 0.1, // 12%
      'Ngày có hiệu lực': availableWidth * 0.1, // 12%
      'Trình duyệt Ban giám đốc': availableWidth * 0.15, // 15%
      'Tài liệu duyệt': availableWidth * 0.15, // 20%
      'Ký số': availableWidth * 0.1, // 8%
      'Trạng thái': availableWidth * 0.15, // 12%
      'Actions': availableWidth * 0.12, // 1%
    };

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
          // Table Header
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
          // Table Content
          Expanded(
            child: Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              thickness: 4,
              notificationPredicate:
                  (notification) =>
                      notification.metrics.axis == Axis.horizontal,
              child: SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: movementDetailTable(
                    data: widget.provider.data,
                    columns: [
                      TableColumnBuilder.createTextColumn<AssetTransferDto>(
                        title: 'Phiếu ký nội sinh',
                        textColor: Colors.black87,
                        getValue: (item) => getName(item.type ?? 0),
                        fontSize: 12,
                        width: columnWidths['Phiếu ký nội sinh']!,
                      ),
                      TableColumnBuilder.createTextColumn<AssetTransferDto>(
                        title: 'Ngày ký',
                        textColor: Colors.black87,
                        fontSize: 12,
                        getValue: (item) => item.decisionDate ?? '',
                        width: columnWidths['Ngày ký']!,
                      ),
                      TableColumnBuilder.createTextColumn<AssetTransferDto>(
                        title: 'Ngày có hiệu lực',
                        textColor: Colors.black87,
                        fontSize: 12,
                        getValue: (item) => item.effectiveDate ?? '',
                        width: columnWidths['Ngày có hiệu lực']!,
                      ),
                      TableColumnBuilder.createTextColumn<AssetTransferDto>(
                        title: 'Trình duyệt Ban giám đốc',
                        textColor: Colors.black87,
                        fontSize: 12,
                        getValue: (item) => item.approver ?? '',
                        width: columnWidths['Trình duyệt Ban giám đốc']!,
                      ),
                      SgTableColumn<AssetTransferDto>(
                        title: 'Tài liệu duyệt',
                        cellBuilder:
                            (item) => showFile(url, item.documentName ?? ''),
                        sortValueGetter: (item) => item.documentFileName ?? '',
                        searchValueGetter:
                            (item) => item.documentFileName ?? '',
                        cellAlignment: TextAlign.center,
                        titleAlignment: TextAlign.center,
                        width: columnWidths['Tài liệu duyệt']!,
                        searchable: true,
                      ),
                      TableColumnBuilder.createTextColumn<AssetTransferDto>(
                        title: 'Ký số',
                        textColor: Colors.black87,
                        fontSize: 12,
                        getValue: (item) => item.id ?? '',
                        width: columnWidths['Ký số']!,
                      ),
                      SgTableColumn<AssetTransferDto>(
                        title: 'Trạng thái',
                        cellBuilder:
                            (item) =>
                                widget.provider.showStatus(item.status ?? 0),
                        cellAlignment: TextAlign.center,
                        titleAlignment: TextAlign.center,
                        width: columnWidths['Trạng thái']!,
                      ),
                      SgTableColumn<AssetTransferDto>(
                        title: '',
                        cellBuilder: (item) => viewAction(item),
                        cellAlignment: TextAlign.center,
                        titleAlignment: TextAlign.center,
                        width: columnWidths['Actions']!,
                        searchable: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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

  Widget showFile(String url, String name) {
    return url.isNotEmpty
        ? InkWell(
          onTap: () {
            downloadFile(url, name, context);
          },
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.blue.shade200, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.file_download_outlined,
                  size: 14,
                  color: Colors.blue.shade700,
                ),
                SizedBox(width: 4),
                Flexible(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        )
        : SizedBox.shrink();
  }

  Widget viewAction(AssetTransferDto item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: Icon(
              Icons.book_outlined,
              size: 16,
              color: ColorValue.lightAmber,
            ),
            tooltip: 'Biên bản bản giao',
            color: Colors.green.shade700,
            onPressed:
                () => PropertyHandoverMinutes.showPopup(
                  context,
                  widget.listAssetHandover
                      .where((itemAH) => itemAH.id == item.idAssetHandover)
                      .toList(),
                ),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: const EdgeInsets.all(4),
          ),
        ),
        SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: Icon(Icons.visibility, size: 16, color: ColorValue.cyan),
            tooltip: 'Xem',
            color: Colors.green.shade700,
            onPressed:
                () => showWebViewPopup(
                  context,
                  url: url,
                  title: item.documentName ?? 'Tài liệu',
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.9,
                ),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: const EdgeInsets.all(4),
          ),
        ),

        SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: Icon(Icons.delete, size: 16),
            tooltip: item.status != 0 ? null : 'Xóa',
            color: item.status != 0 ? Colors.grey : Colors.red.shade700,
            onPressed:
                () =>
                    item.status != 0
                        ? null
                        : widget.provider.deleteItem(item.id ?? ''),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: const EdgeInsets.all(4),
          ),
        ),
      ],
    );
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
}
