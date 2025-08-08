import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/button/action_button_config.dart';
import 'package:quan_ly_tai_san_app/common/sg_download_file.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/web_view/web_view_common.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/row_find_by_status.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/controller/asset_transfer_controller.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/asset_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/asset_transfer_provider.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class AssetTransferList extends StatefulWidget {
  final AssetTransferProvider provider;
  final int typeAssetTransfer;
  final AssetTransferController controller;
  const AssetTransferList({
    super.key,
    required this.provider,
    required this.typeAssetTransfer,
    required this.controller,
  });

  @override
  State<AssetTransferList> createState() => _AssetTransferListState();
}

class _AssetTransferListState extends State<AssetTransferList> {
  String url =
      'https://firebasestorage.googleapis.com/v0/b/shopifyappdata.appspot.com/o/document%2FB%C3%A0n%20giao%20t%C3%A0i%20s%E1%BA%A3n.pdf?alt=media&token=497ba34e-891b-45b0-b228-704ca958760b';

  bool isUploading = false;

  final List<AssetHandoverDto> listAssetHandover = [];

  // Column display options
  late List<ColumnDisplayOption> columnOptions;
  List<String> visibleColumnIds = [
    'type',
    'decision_date',
    'effective_date',
    'approver',
    'document',
    'id',
    'status',
    'actions',
  ];
  @override
  void initState() {
    super.initState();
    _initializeColumnOptions();
    _callGetListAssetHandover();
  }

  void _initializeColumnOptions() {
    columnOptions = [
      ColumnDisplayOption(id: 'type', label: 'Phiếu ký nội sinh', isChecked: visibleColumnIds.contains('type')),
      ColumnDisplayOption(id: 'decision_date', label: 'Ngày ký', isChecked: visibleColumnIds.contains('decision_date')),
      ColumnDisplayOption(
        id: 'effective_date',
        label: 'Ngày có hiệu lực',
        isChecked: visibleColumnIds.contains('effective_date'),
      ),
      ColumnDisplayOption(
        id: 'approver',
        label: 'Trình duyệt ban giám đốc',
        isChecked: visibleColumnIds.contains('approver'),
      ),
      ColumnDisplayOption(id: 'document', label: 'Tài liệu duyệt', isChecked: visibleColumnIds.contains('document')),
      ColumnDisplayOption(id: 'id', label: 'Ký số', isChecked: visibleColumnIds.contains('id')),
      ColumnDisplayOption(id: 'status', label: 'Trạng thái', isChecked: visibleColumnIds.contains('status')),
      ColumnDisplayOption(id: 'actions', label: 'Thao tác', isChecked: visibleColumnIds.contains('actions')),
    ];
  }

  List<SgTableColumn<AssetTransferDto>> _buildColumns() {
    final List<SgTableColumn<AssetTransferDto>> columns = [];

    // Thêm cột dựa trên visibleColumnIds
    for (String columnId in visibleColumnIds) {
      switch (columnId) {
        case 'type':
          columns.add(
            TableBaseConfig.columnTable<AssetTransferDto>(
              title: 'Phiếu ký nội sinh',
              width: 150,
              getValue: (item) => getName(item.loai ?? 0),
            ),
          );
          break;
        case 'decision_date':
          columns.add(
            TableBaseConfig.columnTable<AssetTransferDto>(
              title: 'Ngày ký',
              width: 100,
              getValue: (item) => item.ngayKy.toString(),
            ),
          );
          break;
        case 'effective_date':
          columns.add(
            TableBaseConfig.columnTable<AssetTransferDto>(
              title: 'Ngày có hiệu lực',
              width: 100,
              getValue: (item) => item.tggnTuNgay.toString(),
            ),
          );
          break;
        case 'approver':
          columns.add(
            TableBaseConfig.columnTable<AssetTransferDto>(
              title: 'Trình duyệt ban giám đốc',
              width: 150,
              getValue: (item) => item.tenTrinhDuyetGiamDoc ?? '',
            ),
          );
          break;
        case 'document':
          columns.add(
            SgTableColumn<AssetTransferDto>(
              title: 'Tài liệu duyệt',
              cellBuilder: (item) => SgDownloadFile(url: url, name: item.tenPhieu),
              sortValueGetter: (item) => "item.documentFileName",
              searchValueGetter: (item) => "item.documentFileName",
              cellAlignment: TextAlign.center,
              titleAlignment: TextAlign.center,
              width: 150,
              searchable: true,
            ),
          );
          break;
        case 'id':
          columns.add(
            TableBaseConfig.columnTable<AssetTransferDto>(title: 'Ký số', width: 120, getValue: (item) => item.id ?? ''),
          );
          break;
        case 'status':
          columns.add(
            TableBaseConfig.columnWidgetBase<AssetTransferDto>(
              title: 'Trạng thái',
              cellBuilder: (item) => widget.provider.showStatus(item.trangThai ?? 0),
              width: 150,
              searchable: true,
            ),
          );
          break;
        case 'actions':
          columns.add(
            TableBaseConfig.columnWidgetBase<AssetTransferDto>(
              title: '',
              cellBuilder: (item) => viewAction(item),
              width: 120,
              searchable: true,
            ),
          );
          break;
      }
    }

    return columns;
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Đã cập nhật hiển thị cột'), backgroundColor: Colors.green));
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

  @override
  Widget build(BuildContext context) {
    final List<SgTableColumn<AssetTransferDto>> columns = _buildColumns();

    SGLog.debug("AssetTransferList", 'message widget.provider.data: ${MediaQuery.of(context).size.width}');

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
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .05), blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
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
                  widget.controller.initialize(widget.provider, isEditingParam: false, isNewParam: false);
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
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.table_chart, color: Colors.grey.shade600, size: 18),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.5),
                  child: Text(
                    '${getName(widget.typeAssetTransfer)}(${widget.provider.data.length})',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
                  ),
                ),

                GestureDetector(
                  onTap: _showColumnDisplayPopup,
                  child: Icon(Icons.settings, color: ColorValue.link, size: 18),
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
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
                ),
                // Spacer(),
                GestureDetector(
                  onTap: _showColumnDisplayPopup,
                  child: Icon(Icons.settings, color: ColorValue.link, size: 18),
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
        onPressed: () {},
        // () => PropertyHandoverMinutes.showPopup(
        //   context,
        //   listAssetHandover.where((itemAH) => itemAH.id == item.idAssetHandover).toList(),
        // ),
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
              title: item.tenPhieu,
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.9,
            ),
      ),
      ActionButtonConfig(
        icon: Icons.delete,
        tooltip: item.trangThai != 0 ? null : 'Xóa',
        iconColor: item.trangThai != 0 ? Colors.grey : Colors.red.shade700,
        backgroundColor: Colors.red.shade50,
        borderColor: Colors.red.shade200,
        onPressed:
            () => {
              if (item.trangThai == 0) {widget.provider.deleteItem(item.id ?? '')},
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi lấy danh sách: ${e.toString()}'), backgroundColor: Colors.red));
    }
  }
}
