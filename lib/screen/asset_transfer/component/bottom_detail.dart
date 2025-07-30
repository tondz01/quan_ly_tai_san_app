// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/web_view/web_view_common.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/popup_show_detail.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/asset_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/asset_transfer_provider.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class BottomDetail extends StatefulWidget {
  final AssetTransferProvider provider;
  const BottomDetail({super.key, required this.provider});

  @override
  State<BottomDetail> createState() => _BottomDetailState();
}

class _BottomDetailState extends State<BottomDetail> {
  bool isShowPhieuCapPhat = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Collapse Header
        InkWell(
          onTap: () {
            setState(() {
              isShowPhieuCapPhat = !isShowPhieuCapPhat;
            });
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.description, color: Colors.blue.shade700, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Phiếu duyệt cấp phát tài sản',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
                Icon(
                  isShowPhieuCapPhat ? Icons.expand_less : Icons.expand_more,
                  color: Colors.blue.shade700,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        // Collapse Content
        if (isShowPhieuCapPhat) ...[
          SizedBox(height: 8),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: onShowPhieuCapPhat(),
          ),
        ],
      ],
    );
  }

  Widget onShowPhieuCapPhat() {
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth - 42; // Trừ padding và margin

    // Tính toán width cho từng cột dựa trên tỷ lệ
    final columnWidths = {
      'Phiếu ký nội sinh': availableWidth * 0.20, // 20%
      'Ngày ký': availableWidth * 0.12, // 12%
      'Ngày có hiệu lực': availableWidth * 0.12, // 12%
      'Trình duyệt Ban giám đốc': availableWidth * 0.18, // 18%
      'Tài liệu duyệt': availableWidth * 0.20, // 20%
      'Ký số': availableWidth * 0.08, // 8%
      'Actions': availableWidth * 0.1, // 1%
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
              children: [
                Icon(Icons.table_chart, color: Colors.grey.shade600, size: 18),
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
          ),
          // Table Content
          Expanded(
            child: SingleChildScrollView(
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
                    cellBuilder: (item) => showFile(item.documentName ?? ''),
                    sortValueGetter: (item) => item.documentFileName ?? '',
                    searchValueGetter: (item) => item.documentFileName ?? '',
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

  Widget showFile(String url) {
    return url.isNotEmpty
        ? InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder:
                  (context) => WebViewCommon(
                    url: 'https://ams.sscdx.com.vn/web#',
                    title: url,
                    showAppBar: true,
                  ),
            );
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
                    url,
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
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.green.shade200, width: 1),
          ),
          child: IconButton(
            icon: Icon(Icons.visibility, size: 16),
            tooltip: 'Xem',
            color: Colors.green.shade700,
            onPressed:
                () => showDialog(
                  context: context,
                  builder:
                      (context) => WebViewCommon(
                        url: 'https://ams.sscdx.com.vn/web#',
                        title: item.documentName ?? 'Tài liệu',
                        showAppBar: true,
                      ),
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
            border: Border.all(color: Colors.red.shade200, width: 1),
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
}
