import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:quan_ly_tai_san_app/common/button/action_button_config.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/web_view/web_view_common.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/component/columns_asset_handover_component.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/component/find_by_state_asset_handover.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/component/preview_document_asset_handover.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/asset_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class AssetHandoverList extends StatefulWidget {
  final AssetHandoverProvider provider;
  const AssetHandoverList({super.key, required this.provider});

  @override
  State<AssetHandoverList> createState() => _AssetHandoverListState();
}

class _AssetHandoverListState extends State<AssetHandoverList> {
  final ScrollController horizontalController = ScrollController();
  String searchTerm = "";
  String urlPreview = '';

  bool isShowPreview = false;
  // Column display options
  late List<ColumnDisplayOption> columnOptions;
  List<AssetHandoverDto> selectedItems = [];
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
  List<DieuDongTaiSanDto> listAssetTransfer = [];

  PdfDocument? _document;
  DieuDongTaiSanDto? _selectedAssetTransfer;

  @override
  void initState() {
    super.initState();
    _initializeColumnOptions();

    listAssetTransfer =
        widget.provider.dataAssetTransfer
            ?.where((element) => element.trangThai == 6)
            .toList() ??
        [];
  }

  Future<void> _loadPdfNetwork(String url) async {
    try {
      final document = await PdfDocument.openUri(Uri.parse(url));
      setState(() {
        _document = document;
      });
    } catch (e) {
      setState(() {
        _document = null;
      });
      SGLog.error("Error loading PDF", e.toString());
    }
  }

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
        id: 'movement_details',
        label: 'Chi tiết bàn giao',
        isChecked: visibleColumnIds.contains('movement_details'),
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
        case 'movement_details':
          columns.add(
            SgTableColumn<AssetHandoverDto>(
              title: 'Chi tiết bàn giao',
              cellBuilder: (item) => showMovementDetails([]),
              cellAlignment: TextAlign.center,
              titleAlignment: TextAlign.center,
              width: 120,
              searchable: true,
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

  @override
  Widget build(BuildContext context) {
    final List<SgTableColumn<AssetHandoverDto>> columns = _buildColumns();
    log('message filteredData ${widget.provider.dataPage}');
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
                              'Biên bản bàn giao tài sản (${widget.provider.data?.length ?? 0})',
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
                              color: ColorValue.link,
                              size: 18,
                            ),
                          ),
                          _buildActionKy(),
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
                      isShowPreview = true;
                      widget.provider.onChangeDetail(context, item);
                    },
                    onSelectionChanged: (items) {
                      setState(() {
                        selectedItems = items;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget displayPreview() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      height: MediaQuery.of(context).size.height,
      color: Colors.amber,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: WebViewContainer(
        url: url,
        title: "Preview Document",
        onPressed: () {
          setState(() {
            isShowPreview = !isShowPreview;
          });
        },
      ),
    );
  }

  Visibility _buildActionKy() {
    return Visibility(
      visible: selectedItems.isNotEmpty && selectedItems.length < 2,
      child: GestureDetector(
        onTap: () {
          if (selectedItems.isNotEmpty) {
            UserInfoDTO? userInfo = AccountHelper.instance.getUserInfo();
            AssetHandoverDto? item =
                selectedItems.isNotEmpty ? selectedItems.first : null;
            final idSignature =
                [
                  item?.idDaiDiendonviBanHanhQD,
                  item?.idDaiDienBenGiao,
                  item?.idDaiDienBenNhan,
                  item?.idDonViDaiDien,
                ].whereType<String>().toList();

            if (idSignature.contains(userInfo?.tenDangNhap)) {
              
              final matchingTransfers = listAssetTransfer
                  .where((x) => x.soQuyetDinh == item!.quyetDinhDieuDongSo);
              
              _selectedAssetTransfer = matchingTransfers.isNotEmpty 
                  ? matchingTransfers.first
                  : null;

              if (_selectedAssetTransfer == null ||
                  _selectedAssetTransfer!.tenFile!.isEmpty) {
                if (mounted) {
                  previewDocumentHandover(
                    context: context,
                    item: item!,
                    itemsDetail:
                        widget.provider.dataDetailAssetMobilization ?? [],
                    provider: widget.provider,
                  );
                }
                return;
              }
              _loadPdfNetwork(_selectedAssetTransfer!.tenFile!).then((_) {
                if (mounted) {
                  previewDocumentHandover(
                    context: context,
                    item: item!,
                    itemsDetail:
                        widget.provider.dataDetailAssetMobilization ?? [],
                    provider: widget.provider,
                    document: _document,
                  );
                }
              });
            } else {
              AppUtility.showSnackBar(
                context,
                'Bạn không có quyền ký biên bản này',
                isError: true,
              );
            }
          }
        },
        child: Row(
          spacing: 8,
          children: [
            Tooltip(
              message: 'Ký biên bản',
              child: Icon(Icons.edit, color: Colors.green, size: 18),
            ),
            SGText(
              text: 'Số lượng biên bản đã chọn: ${selectedItems.length}',
              color: Colors.blue,
              size: 14,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  Widget viewAction(AssetHandoverDto item) {
    return viewActionButtons([
      ActionButtonConfig(
        icon: Icons.visibility,
        tooltip: 'Xem',
        iconColor: ColorValue.cyan,
        backgroundColor: Colors.green.shade50,
        borderColor: Colors.green.shade200,
        onPressed: () async {
          isShowPreview = true;
          await widget.provider.getListDetailAssetMobilization(
            item.quyetDinhDieuDongSo ?? '',
          );

          final matchingTransfers = listAssetTransfer
              .where((x) => x.soQuyetDinh == item.quyetDinhDieuDongSo);
          
          _selectedAssetTransfer = matchingTransfers.isNotEmpty 
              ? matchingTransfers.first
              : null;

          if (_selectedAssetTransfer == null ||
              _selectedAssetTransfer!.tenFile!.isEmpty) {
            if (mounted) {
              SGLog.debug(
                "AssetHandoverList",
                "No document found for item: ${item.id}",
              );
              previewDocumentHandover(
                context: context,
                item: item,
                itemsDetail: widget.provider.dataDetailAssetMobilization ?? [],
                provider: widget.provider,
                isShowKy: false,
              );
            }
            return;
          }
          _loadPdfNetwork(_selectedAssetTransfer!.tenFile!).then((_) {
            if (mounted) {
              previewDocumentHandover(
                context: context,
                item: item,
                itemsDetail: widget.provider.dataDetailAssetMobilization ?? [],
                provider: widget.provider,
                isShowKy: false,
                document: _document,
              );
            }
          });
        },
      ),
      ActionButtonConfig(
        icon: Icons.delete,
        tooltip: item.trangThai != 0 ? null : 'Xóa',
        iconColor: item.trangThai != 0 ? Colors.grey : Colors.red.shade700,
        backgroundColor: Colors.red.shade50,
        borderColor: Colors.red.shade200,
        onPressed:
            () => {
              if (item.trangThai == 0)
                {
                  showConfirmDialog(
                    context,
                    type: ConfirmType.delete,
                    title: 'Xóa biên bản bàn giao',
                    message: 'Bạn có chắc muốn xóa ${item.banGiaoTaiSan}',
                    highlight: item.banGiaoTaiSan!,
                    cancelText: 'Không',
                    confirmText: 'Xóa',
                    onConfirm: () {
                      widget.provider.isLoading = true;
                      context.read<AssetHandoverBloc>().add(
                        DeleteAssetHandoverEvent(context, item.id!),
                      );
                    },
                  ),
                },
            },
      ),
    ]);
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

  Widget showMovementDetails(List<ChiTietDieuDongTaiSan> movementDetails) {
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
                          text: detail.tenPhieu,
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
        return ColorValue.lightBlue;
      case 3:
        return ColorValue.coral;
      case 4:
        return ColorValue.forestGreen;
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
        return 'Chờ xác nhận';
      case 2:
        return 'Chờ duyệt';
      case 3:
        return 'Hủy';
      case 4:
        return 'Hoàn thành';
      default:
        return '';
    }
  }
}
