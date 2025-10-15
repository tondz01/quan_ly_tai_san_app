// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:quan_ly_tai_san_app/common/diagram/thread_lines.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/theme/app_icon_svg_path.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/main.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/dieu_dong_tai_san_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/dieu_dong_tai_san_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/dieu_dong_tai_san_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/preview_document_asset_transfer.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/property_handover_minutes.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/row_find_by_status.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/tabel_asset_transfer_config.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/dieu_dong_tai_san_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/table_asset_transfer_provider.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/component/department_tree_demo.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:table_base/core/themes/app_color.dart';
import 'package:table_base/core/themes/app_icon_svg.dart';
import 'package:table_base/widgets/box_search.dart';
import 'package:table_base/widgets/responsive_button_bar/responsive_button_bar.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';
import 'package:table_base/widgets/table/widgets/column_config_dialog.dart';
import 'package:table_base/widgets/table/widgets/riverpod_table.dart';
import 'package:table_base/widgets/table/widgets/table_actions_widget.dart';

class DieuDongTaiSanList extends StatefulWidget {
  final DieuDongTaiSanProvider provider;
  final int typeAssetTransfer;
  final String idCongTy;

  const DieuDongTaiSanList({
    super.key,
    required this.provider,
    required this.typeAssetTransfer,
    required this.idCongTy,
  });

  @override
  State<DieuDongTaiSanList> createState() => _DieuDongTaiSanListState();
}

class _DieuDongTaiSanListState extends State<DieuDongTaiSanList> {
  bool isUploading = false;
  bool isShowDetailDepartmentTree = false;
  bool isLoading = true; // Thêm state loading

  String nameBenBan = "";

  List<DieuDongTaiSanDto> selectedItems = [];
  DieuDongTaiSanDto? selected;
  List<ThreadNode> listSignatoryDetail = [];
  UserInfoDTO? userInfo;

  late final List<TableColumnData> _allColumns;
  List<String> _hiddenKeys = [];
  List<TableColumnData> _columns = [];
  late final List<ColumnDefinition> _definitions;
  late final Map<String, TableCellBuilder> _buildersByKey;

  final bool _showCheckboxColumn = true;
  final bool _showActionsColumn = true;

  final List<AssetHandoverDto> listAssetHandover = [];
  PdfDocument? _document;
  // Column display options
  late List<ColumnDisplayOption> columnOptions;

  List<Map<String, DateTime Function(DieuDongTaiSanDto)>> getters = [];
  @override
  void initState() {
    super.initState();
    userInfo = AccountHelper.instance.getUserInfo();
    isShowDetailDepartmentTree = false;
    isLoading = true; // Đặt loading = true khi khởi tạo
    if (selected != null) {
      _buildDetailDepartmentTree(selected!);
    }
    _callGetListAssetHandover();
    _definitions = TabelAssetTransferConfig.getColumns(
      userInfo ?? UserInfoDTO.empty(),
    );
    _columns = _definitions.map((d) => d.config).toList(growable: true);
    _allColumns = List<TableColumnData>.from(_columns);
    _buildersByKey = {for (final d in _definitions) d.config.key: d.builder};
  }

  @override
  void didUpdateWidget(covariant DieuDongTaiSanList oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      if (selected != null && widget.provider.dataPage != null) {
        selected = widget.provider.dataPage?.firstWhere(
          (element) => element.id == selected?.id,
          orElse: () => DieuDongTaiSanDto(),
        );
        if (selected!.id != null) {
          _buildDetailDepartmentTree(selected!);
        }
      }
    });
  }

  Future<void> _loadPdfNetwork(String nameFile) async {
    try {
      final document = await PdfDocument.openUri(
        Uri.parse("${Config.baseUrl}/api/upload/preview/$nameFile"),
      );
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

  dynamic getValueForColumn(DieuDongTaiSanDto item, int columnIndex) {
    final int offset = _showCheckboxColumn ? 1 : 0;
    final int adjustedIndex = columnIndex - offset;

    if (adjustedIndex < 0 || adjustedIndex >= _columns.length) {
      return null;
    }

    final String key = _columns[adjustedIndex].key;
    switch (key) {
      case 'type':
        // Return human-readable name for searching/sorting consistency
        return item.tenPhieu;
      case 'effective_date':
        return item.tggnTuNgay;
      case 'approver':
        return item.tenTrinhDuyetGiamDoc;
      case 'document':
        return item.tenFile;
      case 'id':
        return item.id;
      case 'decision_date':
        return item.tggnTuNgay;
      case 'to_date':
        return item.tggnDenNgay;
      case 'don_vi_giao':
        return AccountHelper.instance
                .getDepartmentById(item.idDonViGiao ?? '')
                ?.tenPhongBan ??
            '';
      case 'don_vi_nhan':
        return AccountHelper.instance
                .getDepartmentById(item.idDonViNhan ?? '')
                ?.tenPhongBan ??
            '';
      case 'status':
        return TabelAssetTransferConfig.getStatus(item.trangThai ?? 0);
      case 'permission_signing':
        return TabelAssetTransferConfig.getStatusSigningName(item);
      case 'status_document':
        return TabelAssetTransferConfig.getStatusDocumentName(item);
      case 'share':
        return item.share == true ? 'Đã chia sẻ' : 'Chưa chia sẻ';
      default:
        return null;
    }
  }

  // void _showColumnDisplayPopup() async {
  //   await showColumnDisplayPopup(
  //     context: context,
  //     columns: columnOptions,
  //     onSave: (selectedColumns) {
  //       setState(() {
  //         visibleColumnIds = selectedColumns;
  //         _updateColumnOptions();
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Đã cập nhật hiển thị cột'),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //     },
  //     onCancel: () {
  //       // Reset về trạng thái ban đầu
  //       _updateColumnOptions();
  //     },
  //   );
  // }

  // void _updateColumnOptions() {
  //   for (var option in columnOptions) {
  //     option.isChecked = visibleColumnIds.contains(option.id);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AssetHandoverBloc, AssetHandoverState>(
          listener: (context, state) {
            if (state is GetListAssetHandoverSuccessState) {
              listAssetHandover.clear();
              listAssetHandover.addAll(state.data);
            } else if (state is ErrorState) {}
          },
        ),
        BlocListener<DieuDongTaiSanBloc, DieuDongTaiSanState>(
          listener: (context, state) {
            if (state is GetListDieuDongTaiSanSuccessState) {
              setState(() {
                isLoading = false; // Đánh dấu đã load xong dữ liệu
              });
            } else if (state is DieuDongTaiSanLoadingState) {
              setState(() {
                isLoading = true; // Đánh dấu đang loading
              });
            } else if (state is GetListDieuDongTaiSanFailedState) {
              setState(() {
                isLoading = false; // Dừng loading khi có lỗi
              });
            }
          },
        ),
      ],
      child:
          isLoading
              ? Container(
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
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Đang tải dữ liệu...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : Container(
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
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: headerList(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final availableWidth = constraints.maxWidth;
                                return Row(
                                  children: [
                                    riverpod.Consumer(
                                      builder: (context, ref, _) {
                                        return BoxSearch(
                                          width:
                                              (availableWidth * 0.35)
                                                  .toDouble(),
                                          onSearch: (value) {
                                            ref
                                                .read(
                                                  tableAssetTransferProvider
                                                      .notifier,
                                                )
                                                .searchTerm = value;
                                          },
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      width: (availableWidth * 0.65).toDouble(),
                                      child: riverpod.Consumer(
                                        builder: (context, ref, _) {
                                          final hasFilters = ref.watch(
                                            tableAssetTransferProvider.select(
                                              (s) =>
                                                  s
                                                      .filterState
                                                      .hasActiveFilters,
                                            ),
                                          );
                                          final tableState = ref.watch(
                                            tableAssetTransferProvider,
                                          );
                                          final selectedCount =
                                              tableState.selectedItems.length;
                                          selectedItems =
                                              tableState.selectedItems;
                                          final buttons = _buildButtonList(
                                            selectedCount,
                                          );
                                          final processedButtons =
                                              buttons.map((button) {
                                                if (button.text ==
                                                    'table.clear_filters'.tr) {
                                                  return ResponsiveButtonData.fromButtonIcon(
                                                    text: button.text,
                                                    iconPath: button.iconPath!,
                                                    backgroundColor:
                                                        button.backgroundColor!,
                                                    iconColor:
                                                        button.iconColor!,
                                                    textColor:
                                                        button.textColor!,
                                                    width: button.width,
                                                    onPressed: () {
                                                      ref
                                                          .read(
                                                            tableAssetTransferProvider
                                                                .notifier,
                                                          )
                                                          .clearAllFilters();
                                                    },
                                                  );
                                                }
                                                return button;
                                              }).toList();

                                          final filteredButtons =
                                              hasFilters
                                                  ? processedButtons
                                                  : processedButtons
                                                      .where(
                                                        (button) =>
                                                            button.text !=
                                                            'table.clear_filters'
                                                                .tr,
                                                      )
                                                      .toList();

                                          return ResponsiveButtonBar(
                                            buttons: filteredButtons,
                                            spacing: 12,
                                            overflowSide: OverflowSide.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            popupPosition:
                                                PopupMenuPosition.under,
                                            popupOffset: const Offset(0, 8),
                                            popupShape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            popupElevation: 6,
                                            moreLabel: 'Khác',
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          // bộ lọc
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0),
                            ),
                            child: riverpod.Consumer(
                              builder: (context, ref, child) {
                                final data = widget.provider.filteredData ?? [];
                                // Defer provider mutation until after the current frame
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  ref
                                      .read(tableAssetTransferProvider.notifier)
                                      .setData(data);
                                });

                                return RiverpodTable<DieuDongTaiSanDto>(
                                  tableProvider: tableAssetTransferProvider,
                                  columns: _columns,
                                  showCheckboxColumn: _showCheckboxColumn,
                                  enableRowSelection: true,
                                  enableRowHover: true,
                                  showAlternatingRowColors: true,
                                  valueGetter: getValueForColumn,
                                  cellsBuilder: (_) => [],
                                  cellBuilderByKey: (item, key) {
                                    final builder = _buildersByKey[key];
                                    if (builder != null) return builder(item);
                                    return null;
                                  },
                                  onRowTap: (item) {
                                    widget.provider
                                        .onChangeDetailDieuDongTaiSan(item);
                                    setState(() {
                                      nameBenBan =
                                          'Trạng thái ký " Biên bản ${item.id} "';
                                      isShowDetailDepartmentTree = true;
                                      _buildDetailDepartmentTree(item);
                                    });
                                  },
                                  // onEdit: (item) {},
                                  onDelete: (item) {
                                    showConfirmDialog(
                                      context,
                                      type: ConfirmType.delete,
                                      title: 'Xóa nhóm tài sản',
                                      message:
                                          'Bạn có chắc muốn xóa ${item.tenPhieu}',
                                      highlight: item.tenPhieu ?? '',
                                      cancelText: 'Không',
                                      confirmText: 'Xóa',
                                      onConfirm: () {
                                        if (item.trangThai == 0 ||
                                            item.trangThai == 2) {
                                          showConfirmDialog(
                                            context,
                                            type: ConfirmType.delete,
                                            title: 'Xóa nhóm tài sản',
                                            message:
                                                'Bạn có chắc muốn xóa ${item.tenPhieu}',
                                            highlight: item.tenPhieu!,
                                            cancelText: 'Không',
                                            confirmText: 'Xóa',
                                            onConfirm: () {
                                              context
                                                  .read<DieuDongTaiSanBloc>()
                                                  .add(
                                                    DeleteDieuDongEvent(
                                                      context,
                                                      item.id!,
                                                    ),
                                                  );
                                            },
                                          );
                                        }
                                      },
                                    );
                                  },
                                  showActionsColumn: _showActionsColumn,
                                  customActions: [
                                    CustomAction(
                                      tooltip: 'Xem',
                                      iconPath: 'assets/icons/building.svg',
                                      color: Colors.blue,
                                      onPressed: (item) async {
                                        if (listAssetHandover.isEmpty) {
                                          AppUtility.showSnackBar(
                                            context,
                                            'Không có biên bản bàn giao tài sản nào cho phiếu này',
                                            isError: true,
                                          );
                                          return;
                                        }
                                        PropertyHandoverMinutes.showPopup(
                                          context,
                                          listAssetHandover
                                              .where(
                                                (itemAH) =>
                                                    itemAH.id == item.id,
                                              )
                                              .toList(),
                                        );
                                      },
                                    ),
                                    CustomAction(
                                      tooltip: 'Xem',
                                      iconPath: 'assets/icons/eye.svg',
                                      color: Colors.blue,
                                      onPressed: (item) async {
                                        await _loadPdfNetwork(item.tenFile!);
                                        if (!context.mounted) return;
                                        previewDocument(
                                          context: context,
                                          item: item,
                                          provider: widget.provider,
                                          isShowKy: false,
                                          document: _document,
                                        );
                                      },
                                    ),
                                  ],
                                  actionsColumnWidth: 120,
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.8,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Department tree sidebar
                    Visibility(
                      visible: isShowDetailDepartmentTree,
                      child: Container(
                        width: 300,
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Colors.grey.shade600,
                              width: 1,
                            ),
                          ),
                        ),
                        child: DetailedDiagram(
                          title: nameBenBan,
                          sample: listSignatoryDetail,
                          onHiden: () {
                            setState(() {
                              isShowDetailDepartmentTree = false;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  void _buildDetailDepartmentTree(DieuDongTaiSanDto item) {
    listSignatoryDetail.clear();
    selected = item;
    listSignatoryDetail = [
      ThreadNode(header: 'Trạng thái ký', depth: 0),
      if (item.nguoiLapPhieuKyNhay == true)
        ThreadNode(
          header: 'Người ký nháy:',
          depth: 1,
          child: viewSignatoryStatus(
            item.trangThaiKyNhay ?? false,
            widget.provider
                .getNhanVienByID(item.idNguoiKyNhay ?? '')
                .hoTen
                .toString(),
          ),
        ),
      if (item.quanTrongCanXacNhan == true)
        ThreadNode(
          header: 'Trưởng phòng xác nhận:',
          depth: 1,
          child: viewSignatoryStatus(
            item.truongPhongDonViGiaoXacNhan ?? false,
            widget.provider
                .getNhanVienByID(item.idTruongPhongDonViGiao ?? '')
                .hoTen
                .toString(),
          ),
        ),
      if (item.phoPhongDonViGiaoXacNhan == true)
        ThreadNode(
          header: 'Phó phòng xác nhận:',
          depth: 1,
          child: viewSignatoryStatus(
            item.phoPhongDonViGiaoXacNhan ?? false,
            widget.provider
                .getNhanVienByID(item.idPhoPhongDonViGiao ?? '')
                .hoTen
                .toString(),
          ),
        ),
      ThreadNode(
        header: 'Trình duyệt cấp phòng:',
        depth: 1,
        child: viewSignatoryStatus(
          item.trinhDuyetCapPhongXacNhan ?? false,
          widget.provider
              .getNhanVienByID(item.idTrinhDuyetCapPhong ?? '')
              .hoTen
              .toString(),
        ),
      ),
      ThreadNode(
        header: 'Trình duyệt ban giám đốc:',
        depth: 1,
        child: viewSignatoryStatus(
          item.trinhDuyetGiamDocXacNhan ?? false,
          widget.provider
              .getNhanVienByID(item.idTrinhDuyetGiamDoc ?? '')
              .hoTen
              .toString(),
        ),
      ),

      if (item.listSignatory != null)
        ...item.listSignatory!.map(
          (e) => ThreadNode(
            header: "Người đại diện",
            depth: 1,
            child: viewSignatoryStatus(e.trangThai == 1, e.tenNguoiKy ?? ''),
          ),
        ),
    ];
  }

  Widget viewSignatoryStatus(bool isDone, String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDone ? Colors.green : Colors.red,
          ),
        ),
        Visibility(
          visible: isDone,
          child: Tooltip(
            message: 'Đã ký',
            child: Icon(Icons.check_circle, color: Colors.green, size: 18),
          ),
        ),
      ],
    );
  }

  Widget headerList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.table_chart, color: Colors.grey.shade600, size: 18),
            SizedBox(width: 8),
            Text(
              '${TabelAssetTransferConfig.getName(widget.typeAssetTransfer)}(${widget.provider.data.length})',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        Expanded(child: RowFindByStatus(provider: widget.provider)),
      ],
    );
  }

  void _callGetListAssetHandover() {
    try {
      final assetHandoverBloc = BlocProvider.of<DieuDongTaiSanBloc>(context);
      assetHandoverBloc.add(
        GetListDieuDongTaiSanEvent(
          context,
          widget.typeAssetTransfer,
          widget.idCongTy,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi lấy danh sách: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleSignDocument(
    DieuDongTaiSanDto item,
    UserInfoDTO userInfo,
    DieuDongTaiSanProvider provider,
  ) async {
    // Định nghĩa luồng ký theo thứ tự
    final signatureFlow =
        [
              if (item.nguoiLapPhieuKyNhay == true)
                {
                  "id": item.idNguoiKyNhay,
                  "signed": item.trangThaiKyNhay == true,
                  "label": "Người lập phiếu: ${item.tenNguoiKyNhay}",
                },
              {
                "id": item.idTrinhDuyetCapPhong,
                "signed": item.trinhDuyetCapPhongXacNhan == true,
                "label": "Người duyệt: ${item.tenTrinhDuyetCapPhong}",
              },
              for (int i = 0; i < (item.listSignatory?.length ?? 0); i++)
                {
                  "id": item.listSignatory![i].idNguoiKy,
                  "signed": item.listSignatory![i].trangThai == 1,
                  "label":
                      "Người ký ${i + 1}: ${item.listSignatory![i].tenNguoiKy}",
                },
              {
                "id": item.idTrinhDuyetGiamDoc,
                "signed": item.trinhDuyetGiamDocXacNhan == true,
                "label": "Người phê duyệt: ${item.tenTrinhDuyetGiamDoc}",
              },
            ]
            .where(
              (step) => step["id"] != null && (step["id"] as String).isNotEmpty,
            )
            .toList();
    // Kiểm tra hoàn thành
    if (item.trangThai == 3 || item.trangThai == 2) {
      String title = widget.provider.getScreenTitle();
      String message = item.trangThai == 2 ? 'Đã bị hủy' : 'Đã hoàn thành';
      AppUtility.showSnackBar(
        context,
        'Phiếu $title này "$message", không thể ký.',
        isError: true,
        textAlign: TextAlign.center,
      );
      return;
    }

    // Kiểm tra user có trong flow không
    final currentIndex = signatureFlow.indexWhere(
      (s) => s["id"] == userInfo.tenDangNhap,
    );
    if (currentIndex == -1) {
      AppUtility.showSnackBar(
        context,
        'Bạn không có quyền ký văn bản này',
        isError: true,
      );
      return;
    }

    // Nếu đã ký rồi thì chặn
    if (signatureFlow[currentIndex]["signed"] == true) {
      AppUtility.showSnackBar(context, 'Bạn đã ký rồi.', isError: true);
      return;
    }
    // Kiểm tra tất cả các bước trước đã ký chưa
    final previousNotSigned = signatureFlow
        .take(currentIndex)
        .firstWhere((s) => s["signed"] == false, orElse: () => {});

    if (previousNotSigned.isNotEmpty) {
      AppUtility.showSnackBar(
        context,
        '${previousNotSigned["label"]} chưa ký xác nhận, bạn chưa thể ký.',
        isError: true,
      );
      return;
    }
    // Nếu vượt qua tất cả check → mở preview để ký

    await _loadPdfNetwork(item.tenFile!);
    if (mounted) {
      previewDocument(
        context: context,
        item: item,
        provider: widget.provider,
        isShowKy: true,
        document: _document,
      );
    }
  }

  Future<void> _openColumnConfigDialog() async {
    try {
      final apply = await showColumnConfigAndApply(
        context: context,
        allColumns: _allColumns,
        currentColumns: _columns,
        initialHiddenKeys: _hiddenKeys,
        title: 'table.config_column'.tr,
      );
      if (apply != null) {
        setState(() {
          _hiddenKeys = apply.hiddenKeys;
          _columns = apply.updatedColumns;
        });
      }
    } catch (e) {
      SGLog.error('ColumnConfigDialog', 'Error at _openColumnConfigDialog: $e');
    }
  }

  List<ResponsiveButtonData> _buildButtonList(int itemCount) {
    return [
      // Configure columns button
      ResponsiveButtonData.fromButtonIcon(
        text: 'table.config_column'.tr,
        iconPath: AppIconSvg.iconSetting,
        backgroundColor: AppColor.white,
        iconColor: AppColor.textDark,
        textColor: AppColor.textDark,
        width: 130,
        onPressed: () {
          _openColumnConfigDialog();
        },
      ),
      if (selectedItems.isNotEmpty && selectedItems.length < 2)
        ResponsiveButtonData.fromButtonIcon(
          text: 'table.signing'.tr,
          iconPath: AppIconSvgPath.iconPenLine,
          backgroundColor: AppColor.white,
          iconColor: ColorValue.limeYellow,
          textColor: AppColor.textDark,
          width: 130,
          onPressed: () {
            DieuDongTaiSanDto? item = selectedItems.first;
            _handleSignDocument(item, userInfo!, widget.provider);
          },
        ),
      if (selectedItems.isNotEmpty)
        ResponsiveButtonData.fromButtonIcon(
          text: "${'table.send'.tr} (${selectedItems.length})",
          iconPath: AppIconSvgPath.iconSend,
          backgroundColor: Colors.redAccent,
          iconColor: AppColor.textWhite,
          textColor: AppColor.textWhite,
          width: 200,
          onPressed: () {
            TabelAssetTransferConfig.handleSendToSigner(context, selectedItems);
          },
        ),
    ];
  }
}
