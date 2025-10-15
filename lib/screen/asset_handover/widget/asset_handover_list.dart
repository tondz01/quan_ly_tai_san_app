import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:quan_ly_tai_san_app/common/diagram/thread_lines.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/theme/app_icon_svg_path.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/main.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/component/find_by_state_asset_handover.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/component/preview_document_asset_handover.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/component/table_asset_handover_config.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/asset_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/table_asset_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
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

class AssetHandoverList extends StatefulWidget {
  final AssetHandoverProvider provider;
  final List<DieuDongTaiSanDto> listAssetTransfer;
  const AssetHandoverList({
    super.key,
    required this.provider,
    required this.listAssetTransfer,
  });

  @override
  State<AssetHandoverList> createState() => _AssetHandoverListState();
}

class _AssetHandoverListState extends State<AssetHandoverList> {
  String urlPreview = '';
  String nameBenBan = "";

  bool isShowDetailDepartmentTree = false;
  bool isShowPreview = false;
  AssetHandoverDto? selected;
  UserInfoDTO? userInfo;
  DieuDongTaiSanDto? _selectedAssetTransfer;

  List<ThreadNode> listSignatoryDetail = [];
  List<AssetHandoverDto> selectedItems = [];

  late final List<TableColumnData> _allColumns;
  List<String> _hiddenKeys = [];
  List<TableColumnData> _columns = [];
  late final List<ColumnDefinition> _definitions;
  late final Map<String, TableCellBuilder> _buildersByKey;

  // Track previous filtered data for comparison
  List<AssetHandoverDto> _previousFilteredData = [];

  final bool _showCheckboxColumn = true;
  final bool _showActionsColumn = true;

  PdfDocument? pdfDocument;

  @override
  void initState() {
    super.initState();
    userInfo = AccountHelper.instance.getUserInfo();
    _initializeTableConfig();
  }

  void _initializeTableConfig() {
    _definitions = TableAssetHandoverConfig.getColumns(
      userInfo ?? UserInfoDTO.empty(),
    );
    _columns = _definitions.map((d) => d.config).toList(growable: true);
    _allColumns = List<TableColumnData>.from(_columns);
    _buildersByKey = {for (final d in _definitions) d.config.key: d.builder};
  }

  dynamic getValueForColumn(AssetHandoverDto item, int columnIndex) {
    final int offset = _showCheckboxColumn ? 1 : 0;
    final int adjustedIndex = columnIndex - offset;

    if (adjustedIndex < 0 || adjustedIndex >= _columns.length) {
      return null;
    }

    final String key = _columns[adjustedIndex].key;
    switch (key) {
      case 'quyet_dinh':
        return item.quyetDinhDieuDongSo;
      case 'lenh_dieu_dong':
        return item.lenhDieuDong;
      case 'ngay_ban_giao':
        return item.ngayBanGiao;
      case 'ngay_tao_chung_tu':
        return item.ngayTaoChungTu;
      case 'don_vi_giao':
        return AccountHelper.instance
                .getDepartmentById(item.idDonViGiao ?? '')
                ?.tenPhongBan ??
            item.tenDonViGiao ??
            '';
      case 'don_vi_nhan':
        return AccountHelper.instance
                .getDepartmentById(item.idDonViNhan ?? '')
                ?.tenPhongBan ??
            item.tenDonViNhan ??
            '';
      case 'nguoi_lap_phieu':
        return AccountHelper.instance.getNhanVienById(item.nguoiTao ?? '')?.hoTen ?? '';
      case 'trang_thai_ky':
        return 'Trạng thái ký'; // Sẽ được xử lý bởi cellBuilder
      case 'trang_thai_phieu':
        return TableAssetHandoverConfig.getStatusHandoverText(
          item.trangThaiPhieu ?? 0,
        );
      case 'document':
        return item.tenFile;
      case 'trang_thai':
        return TableAssetHandoverConfig.getStatusText(item.trangThai ?? 0);
      case 'share':
        return item.share == true ? 'Đã chia sẻ' : 'Chưa chia sẻ';
      default:
        return null;
    }
  }

  @override
  void didUpdateWidget(covariant AssetHandoverList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldData = oldWidget.provider.filteredData ?? [];
    final newData = widget.provider.filteredData ?? [];
    if (oldData.length != newData.length || !_areListsEqual(oldData, newData)) {
      _onFilteredDataChanged(oldData, newData);
    }
    setState(() {
      if (selected != null && widget.provider.dataPage != null) {
        selected = widget.provider.dataPage?.firstWhere(
          (element) => element.id == selected?.id,
          orElse: () => AssetHandoverDto(),
        );
        if (selected!.id != null) {
          _buildDetailDepartmentTree(selected!);
        }
      }
    });
  }

  bool _areListsEqual(
    List<AssetHandoverDto> list1,
    List<AssetHandoverDto> list2,
  ) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      int statusSign1 = TableAssetHandoverConfig.getPermissionSigning(
        list1[i],
        userInfo!,
      );
      int statusSign2 = TableAssetHandoverConfig.getPermissionSigning(
        list2[i],
        userInfo!,
      );
      if (list1[i].id != list2[i].id) return false;
      if (list1[i].trangThai != list2[i].trangThai) return false;
      if (list1[i].share != list2[i].share) return false;
      if (list1[i].trangThaiPhieu != list2[i].trangThaiPhieu) return false;
      if (statusSign1 != statusSign2) return false;
    }
    return true;
  }

  // Callback khi filtered data thay đổi
  void _onFilteredDataChanged(
    List<AssetHandoverDto> oldData,
    List<AssetHandoverDto> newData,
  ) {
    // Reset selection nếu item đã chọn không còn trong filtered data
    if (selected != null && !newData.any((item) => item.id == selected?.id)) {
      setState(() {
        selected = null;
        isShowDetailDepartmentTree = false;
      });
    }
  }

  Future<void> _loadPdfNetwork(String nameFile) async {
    try {
      final document = await PdfDocument.openUri(
        Uri.parse("${Config.baseUrl}/api/upload/preview/$nameFile"),
      );
      setState(() {
        pdfDocument = document;
      });
    } catch (e) {
      setState(() {
        pdfDocument = null;
      });
      SGLog.error("Error loading PDF", e.toString());
    }
  }

  void _buildDetailDepartmentTree(AssetHandoverDto item) {
    listSignatoryDetail.clear();
    selected = item;
    listSignatoryDetail = [
      ThreadNode(header: 'Trạng thái ký', depth: 0),
      ThreadNode(
        header: 'Đại diện đơn vị để nghị:',
        depth: 1,
        child: viewSignatoryStatus(
          item.daXacNhan == true,
          widget.provider
              .getNhanVienByID(item.idDaiDiendonviBanHanhQD ?? '')
              .hoTen
              .toString(),
        ),
      ),
      ThreadNode(
        header: 'Đại diện đơn vị giao:',
        depth: 1,
        child: viewSignatoryStatus(
          item.daiDienBenGiaoXacNhan ?? false,
          widget.provider
              .getNhanVienByID(item.idDaiDienBenGiao ?? '')
              .hoTen
              .toString(),
        ),
      ),
      ThreadNode(
        header: 'Đại diện đơn vị nhận:',
        depth: 1,
        child: viewSignatoryStatus(
          item.daiDienBenNhanXacNhan ?? false,
          widget.provider
              .getNhanVienByID(item.idDaiDienBenNhan ?? '')
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
      if (selectedItems.isNotEmpty &&
          selectedItems.length < 2 &&
          _getPermissionSigning(selectedItems.first) == 0)
        ResponsiveButtonData.fromButtonIcon(
          text: 'table.signing'.tr,
          iconPath: AppIconSvgPath.iconPenLine,
          backgroundColor: AppColor.white,
          iconColor: ColorValue.amber,
          textColor: AppColor.textDark,
          width: 130,
          onPressed: () {
            AssetHandoverDto? item = selectedItems.first;
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
            TableAssetHandoverConfig.handleSendToSigner(selectedItems, context);
          },
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              border: Border.all(color: Colors.grey.shade300, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .05),
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
                              ],
                            ),
                            FindByStateAssetHandover(provider: widget.provider),
                          ],
                        ),
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
                                      width: (availableWidth * 0.35).toDouble(),
                                      onSearch: (value) {
                                        ref
                                            .read(
                                              tableAssetHandoverProvider
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
                                        tableAssetHandoverProvider.select(
                                          (s) => s.filterState.hasActiveFilters,
                                        ),
                                      );
                                      final tableState = ref.watch(
                                        tableAssetHandoverProvider,
                                      );
                                      final selectedCount =
                                          tableState.selectedItems.length;
                                      selectedItems = tableState.selectedItems;
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
                                                iconColor: button.iconColor!,
                                                textColor: button.textColor!,
                                                width: button.width,
                                                onPressed: () {
                                                  ref
                                                      .read(
                                                        tableAssetHandoverProvider
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
                                        popupPosition: PopupMenuPosition.under,
                                        popupOffset: const Offset(0, 8),
                                        popupShape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                        ),
                        child: riverpod.Consumer(
                          builder: (context, ref, child) {
                            final data = widget.provider.filteredData ?? [];
                            // Defer provider mutation until after the current frame
                            if (!_areListsEqual(_previousFilteredData, data)) {
                              _previousFilteredData = List.from(data);
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                ref
                                    .read(tableAssetHandoverProvider.notifier)
                                    .setData(data);
                              });
                            }
                            return RiverpodTable<AssetHandoverDto>(
                              tableProvider: tableAssetHandoverProvider,
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
                                widget.provider.onChangeDetail(context, item);
                                setState(() {
                                  nameBenBan =
                                      'Trạng thái ký " Biên bản ${item.id} "';
                                  isShowDetailDepartmentTree = true;
                                  _buildDetailDepartmentTree(item);
                                });
                              },
                              showActionsColumn: _showActionsColumn,
                              customActions: [
                                CustomAction(
                                  tooltip: 'Xem',
                                  iconPath: 'assets/icons/eye.svg',
                                  color: Colors.green,
                                  onPressed: (item) {
                                    onViewDocument(item);
                                  },
                                ),
                                CustomAction(
                                  tooltip: 'Xóa',
                                  iconPath: AppIconSvg.iconTrash2,
                                  color: Colors.red,
                                  onPressed: onDelete,
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
                        left: BorderSide(color: Colors.grey.shade600, width: 1),
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
        ),
      ],
    );
  }

  onViewDocument(AssetHandoverDto item) async {
    isShowPreview = true;
    await widget.provider.getListDetailAssetMobilization(
      item.quyetDinhDieuDongSo ?? '',
    );

    final matchingTransfers = widget.listAssetTransfer.where(
      (x) => x.soQuyetDinh == item.quyetDinhDieuDongSo,
    );

    _selectedAssetTransfer =
        matchingTransfers.isNotEmpty ? matchingTransfers.first : null;

    _loadPdfNetwork(item.tenFile!).then((_) {
      if (mounted) {
        previewDocumentHandover(
          context: context,
          item: item,
          itemsDetail: item.chiTietBanGiaoTaiSan ?? [],
          provider: widget.provider,
          isShowKy: false,
        );
      }
    });
  }

  onDelete(AssetHandoverDto item) {
    userInfo?.tenDangNhap == 'admin'
        ? showConfirmDialog(
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
        )
        : item.trangThai == 0
        ? showConfirmDialog(
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
        )
        : AppUtility.showSnackBar(
          context,
          'Bạn không thể xóa biên bản bàn giao này',
          isError: true,
        );
  }

  void _handleSignDocument(
    AssetHandoverDto item,
    UserInfoDTO userInfo,
    AssetHandoverProvider provider,
  ) async {
    final signatureFlow =
        [
              {
                "id": item.idDaiDiendonviBanHanhQD,
                "signed": item.daXacNhan == true,
                "label": "Đại diện đơn vị đề nghị: ${item.tenDaiDienBanHanhQD}",
              },
              {
                "id": item.idDaiDienBenGiao,
                "signed": item.daiDienBenGiaoXacNhan == true,
                "label": "Đại diện đơn vị giao: ${item.tenDaiDienBenGiao}",
              },
              {
                "id": item.idDaiDienBenNhan,
                "signed": item.daiDienBenNhanXacNhan == true,
                "label": "Đại diện đơn vị nhận: ${item.tenDaiDienBenNhan}",
              },
              if (item.listSignatory?.isNotEmpty ?? false)
                ...(item.listSignatory
                        ?.map(
                          (e) => {
                            "id": e.idNguoiKy,
                            "signed": e.trangThai == 1,
                            "label": "Người ký: ${e.tenNguoiKy ?? ''}",
                          },
                        )
                        .toList() ??
                    []),
            ]
            .where(
              (step) => step["id"] != null && (step["id"] as String).isNotEmpty,
            )
            .toList();

    if (signatureFlow.isNotEmpty) {
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

      final matchingTransfers = widget.listAssetTransfer.where(
        (x) => x.soQuyetDinh == item.quyetDinhDieuDongSo,
      );

      _selectedAssetTransfer =
          matchingTransfers.isNotEmpty ? matchingTransfers.first : null;

      final tenFile = _selectedAssetTransfer?.tenFile;
      if (tenFile == null || tenFile.isEmpty) {
        AppUtility.showSnackBar(
          context,
          'Không tìm thấy tệp để xem/ ký',
          isError: true,
        );
        return;
      }

      _loadPdfNetwork(tenFile).then((_) {
        if (mounted) {
          previewDocumentHandover(
            context: context,
            item: item,
            itemsDetail: item.chiTietBanGiaoTaiSan ?? [],
            provider: widget.provider,
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

  int _getPermissionSigning(AssetHandoverDto item) {
    final signatureFlow =
        [
              {
                "id": item.idDaiDiendonviBanHanhQD,
                "signed": item.daXacNhan == true,
              },
              {
                "id": item.idDaiDienBenGiao,
                "signed": item.daiDienBenGiaoXacNhan == true,
              },
              {
                "id": item.idDaiDienBenNhan,
                "signed": item.daiDienBenNhanXacNhan == true,
              },
              if (item.listSignatory?.isNotEmpty ?? false)
                ...(item.listSignatory
                        ?.map(
                          (e) => {
                            "id": e.idNguoiKy,
                            "signed": e.trangThai == 1,
                          },
                        )
                        .toList() ??
                    []),
            ]
            .where(
              (step) => step["id"] != null && (step["id"] as String).isNotEmpty,
            )
            .toList();
    final currentIndex = signatureFlow.indexWhere(
      (s) => s["id"] == userInfo?.tenDangNhap,
    );
    if (currentIndex == -1) return 2;
    if (item.idDaiDiendonviBanHanhQD == userInfo?.tenDangNhap &&
        signatureFlow[currentIndex]["signed"] != -1) {
      return signatureFlow[currentIndex]["signed"] == true ? 4 : 5;
    }
    if (signatureFlow[currentIndex]["signed"] == true) return 3;
    final previousNotSigned = signatureFlow
        .take(currentIndex)
        .firstWhere((s) => s["signed"] == false, orElse: () => {});

    if (previousNotSigned.isNotEmpty) return 1;
    return 0;
  }
}
