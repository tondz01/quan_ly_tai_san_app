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
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/asset_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/asset_transfer_provider.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class TableAssetTransferByDetail extends StatefulWidget {
  final AssetTransferProvider provider;
  const TableAssetTransferByDetail({super.key, required this.provider});

  @override
  State<TableAssetTransferByDetail> createState() =>
      _TableAssetTransferByDetailState();
}

class _TableAssetTransferByDetailState
    extends State<TableAssetTransferByDetail> {
  String url = '';
  bool isUploading = false;

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

    return MultiBlocListener(
      listeners: [
        BlocListener<AssetHandoverBloc, AssetHandoverState>(
          listener: (context, state) {
            if (state is GetListAssetHandoverSuccessState) {
              listAssetHandover.clear();
              listAssetHandover.addAll(state.data);
              log('Asset handover data loaded successfully');
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
    const statusMap = {
      'Nháp': 0,
      'Chờ xác nhận': 1,
      'Xác nhận': 2,
      'Trình Duyệt': 3,
      'Duyệt': 4,
      'Từ chối': 5,
      'Hủy': 6,
      'Hoàn thành': 7,
    };
    final count =
        widget.provider.data
            .where((item) => item.status == statusMap[key])
            .length;
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
