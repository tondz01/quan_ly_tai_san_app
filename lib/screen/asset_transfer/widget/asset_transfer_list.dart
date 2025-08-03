// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/button/action_button_config.dart';
import 'package:quan_ly_tai_san_app/common/sg_download_file.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/web_view/web_view_common.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/property_handover_minutes.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/row_find_by_status.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/asset_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/asset_transfer_provider.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class AssetTransferList extends StatefulWidget {
  final AssetTransferProvider provider;
  final int typeAssetTransfer;
  const AssetTransferList({
    super.key,
    required this.provider,
    required this.typeAssetTransfer,
  });

  @override
  State<AssetTransferList> createState() => _AssetTransferListState();
}

class _AssetTransferListState extends State<AssetTransferList> {
  String url = '';
  bool isUploading = false;

  final List<AssetHandoverDto> listAssetHandover = [];
  @override
  void initState() {
    super.initState();
    _callGetListAssetHandover();
  }

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
        width: 120,
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
    log('message widget.provider.data: ${MediaQuery.of(context).size.width}');

    return MultiBlocListener(
      listeners: [
        BlocListener<AssetHandoverBloc, AssetHandoverState>(
          listener: (context, state) {
            if (state is GetListAssetHandoverSuccessState) {
              listAssetHandover.clear();
              listAssetHandover.addAll(state.data);
            } else if (state is GetListAssetHandoverFailedState) {
            } else if (state is AssetHandoverLoadingState) {
              // Show loading indicator
              setState(() {
                isUploading = true;
              });
            } else if (state is AssetHandoverLoadingDismissState) {
              // Hide loading indicator
              setState(() {
                isUploading = false;
              });
            }
          },
        ),
      ],
      child: Container(
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
              child: headerList(),
            ),
            Expanded(
              child: TableBaseView<AssetTransferDto>(
                searchTerm: '',
                columns: columns,
                data: widget.provider.dataPage ?? [],
                horizontalController: ScrollController(),
                onRowTap: (item) {
                  widget.provider.onChangeDetailAssetTransfer(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget headerList() {
    final screenWidth = MediaQuery.of(context).size.width;
    bool isColumn = screenWidth < 1360;
    return isColumn
        ? Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.table_chart, color: Colors.grey.shade600, size: 18),
                SizedBox(width: 8),
                Text(
                  '${getName(widget.typeAssetTransfer)}(${widget.provider.data.length})',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            RowFindByStatus(provider: widget.provider),
          ],
        )
        : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.table_chart, color: Colors.grey.shade600, size: 18),
                SizedBox(width: 8),
                Text(
                  '${getName(widget.typeAssetTransfer)}(${widget.provider.data.length})',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            RowFindByStatus(provider: widget.provider),
          ],
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
              listAssetHandover
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

  void _callGetListAssetHandover() {
    try {
      final assetHandoverBloc = BlocProvider.of<AssetHandoverBloc>(context);
      assetHandoverBloc.add(GetListAssetHandoverEvent(context));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi lấy danh sách: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
