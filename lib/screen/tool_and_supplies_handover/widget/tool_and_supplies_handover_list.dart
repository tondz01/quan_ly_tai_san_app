import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:quan_ly_tai_san_app/common/button/action_button_config.dart';
import 'package:quan_ly_tai_san_app/common/diagram/thread_lines.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
// import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/theme/app_icon_svg_path.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/main.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/bloc/tool_and_supplies_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/bloc/tool_and_supplies_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/component/find_by_state_asset_handover.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/component/preview_document_ccdc_handover.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/tool_and_supplies_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/provider/tool_and_supplies_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/component/department_tree_demo.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_text.dart';
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
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/component/table_tool_and_supplies_handover_config.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/provider/table_tool_and_supplies_handover_provider.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class ToolAndSuppliesHandoverList extends StatefulWidget {
  final ToolAndSuppliesHandoverProvider provider;
  final List<ToolAndMaterialTransferDto> listAssetTransfer;
  const ToolAndSuppliesHandoverList({
    super.key,
    required this.provider,
    required this.listAssetTransfer,
  });

  @override
  State<ToolAndSuppliesHandoverList> createState() =>
      _ToolAndSuppliesHandoverListState();
}

class _ToolAndSuppliesHandoverListState
    extends State<ToolAndSuppliesHandoverList> {
  final ScrollController horizontalController = ScrollController();
  String searchTerm = "";
  String urlPreview = '';
  String nameBenBan = "";

  UserInfoDTO? userInfo;

  bool isShowDetailDepartmentTree = false;

  bool isShowPreview = false;
  bool isShowSigning = false;

  ToolAndSuppliesHandoverDto? selected;
  List<ThreadNode> listSignatoryDetail = [];
  // Column display options
  late List<ColumnDisplayOption> columnOptions;
  List<ToolAndSuppliesHandoverDto> selectedItems = [];

  late final List<TableColumnData> _allColumns;
  List<String> _hiddenKeys = [];
  List<TableColumnData> _columns = [];
  late final List<ColumnDefinition> _definitions;
  late final Map<String, TableCellBuilder> _buildersByKey;

  final bool _showCheckboxColumn = true;
  final bool _showActionsColumn = true;

  PdfDocument? pdfDocument;

  @override
  void initState() {
    super.initState();
    userInfo = widget.provider.userInfo;
    _initializeTableConfig();
  }

  void _initializeTableConfig() {
    _definitions = TableToolAndSuppliesHandoverConfig.getColumns(
      userInfo ?? UserInfoDTO.empty(),
    );
    _columns = _definitions.map((d) => d.config).toList(growable: true);
    _allColumns = List<TableColumnData>.from(_columns);
    _buildersByKey = {for (final d in _definitions) d.config.key: d.builder};
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
      // ignore
    }
  }

  dynamic getValueForColumn(ToolAndSuppliesHandoverDto item, int columnIndex) {
    final int offset = _showCheckboxColumn ? 1 : 0;
    final int adjustedIndex = columnIndex - offset;
    if (adjustedIndex < 0 || adjustedIndex >= _columns.length) return null;
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
        return item.nguoiTao;
      case 'trang_thai_ky':
        int status = TableToolAndSuppliesHandoverConfig.getPermissionSigning(
          item,
          userInfo!,
        );
        return TableToolAndSuppliesHandoverConfig.getPermissionSigningText(
          status,
        );
      case 'trang_thai_phieu':
        return TableToolAndSuppliesHandoverConfig.getStatusHandoverText(
          item.trangThaiPhieu ?? 0,
        );
      case 'document':
        return item.tenFile;
      case 'trang_thai':
        return TableToolAndSuppliesHandoverConfig.getStatusText(
          item.trangThai ?? 0,
        );
      case 'share':
        return item.share == true ? 'Đã chia sẻ' : 'Chưa chia sẻ';
      default:
        return null;
    }
  }

  @override
  void didUpdateWidget(covariant ToolAndSuppliesHandoverList oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      if (selected != null && widget.provider.dataPage != null) {
        selected = widget.provider.dataPage?.firstWhere(
          (element) => element.id == selected?.id,
          orElse: () => ToolAndSuppliesHandoverDto(),
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
        pdfDocument = document;
      });
    } catch (e) {
      setState(() {
        pdfDocument = null;
      });
      SGLog.error("Error loading PDF", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // if (url.isNotEmpty && isShowPreview) displayPreview(),
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

                            FindByStateToolHandover(provider: widget.provider),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: SGAppColors.colorBorderGray.withValues(
                          alpha: 0.3,
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
                                              tableToolAndSuppliesHandoverProvider
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
                                        tableToolAndSuppliesHandoverProvider
                                            .select(
                                              (s) =>
                                                  s
                                                      .filterState
                                                      .hasActiveFilters,
                                            ),
                                      );
                                      final tableState = ref.watch(
                                        tableToolAndSuppliesHandoverProvider,
                                      );
                                      final selectedCount =
                                          tableState.selectedItems.length;
                                      selectedItems =
                                          tableState.selectedItems
                                              .cast<
                                                ToolAndSuppliesHandoverDto
                                              >();
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
                                                        tableToolAndSuppliesHandoverProvider
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
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ref
                                  .read(
                                    tableToolAndSuppliesHandoverProvider
                                        .notifier,
                                  )
                                  .setData(data);
                            });
                            return RiverpodTable<ToolAndSuppliesHandoverDto>(
                              tableProvider:
                                  tableToolAndSuppliesHandoverProvider,
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
                              onRowTap: (item) async {
                                isShowPreview = true;
                                widget.provider.onChangeDetail(
                                  context,
                                  item,
                                  isFindNewItem: false,
                                );
                                setState(() {
                                  nameBenBan =
                                      'trạng thái ký " Biên bản bàn giao ${item.id} "';
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
                                  onPressed: (item) async {
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

  Widget viewAction(ToolAndSuppliesHandoverDto item) {
    return viewActionButtons([
      ActionButtonConfig(
        icon: Icons.visibility,
        tooltip: 'Xem',
        iconColor: ColorValue.cyan,
        backgroundColor: Colors.green.shade50,
        borderColor: Colors.green.shade200,
        onPressed: () async {
          SGLog.info(
            "viewAction",
            "View action pressed for item: ${item.tenFile}",
          );
          isShowPreview = true;
          var dieuDongCcdc = widget.provider.dataAssetTransfer
              ?.where((element) => element.trangThai == 3)
              .toList()
              .firstWhere(
                (element) => element.id == item.lenhDieuDong,
                orElse: () => ToolAndMaterialTransferDto(),
              );

          _loadPdfNetwork(item.tenFile!).then((_) {
            if (mounted) {
              prevDocumentCcdcHandover(
                context: context,
                item: dieuDongCcdc!,
                provider: widget.provider,
                isShowKy: false,
                dieuDongCcdc: item,
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
                    message: 'Bạn có chắc muốn xóa ${item.banGiaoCCDCVatTu}',
                    highlight: item.banGiaoCCDCVatTu!,
                    cancelText: 'Không',
                    confirmText: 'Xóa',
                    onConfirm: () {
                      widget.provider.isLoading = true;
                      context.read<ToolAndSuppliesHandoverBloc>().add(
                        DeleteToolAndSuppliesHandoverEvent(context, item.id!),
                      );
                    },
                  ),
                },
            },
      ),
    ]);
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

  // Widget showSigningStatus(ToolAndSuppliesHandoverDto item) {
  //   return Container(
  //     constraints: const BoxConstraints(maxHeight: 48.0),
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
  //       margin: const EdgeInsets.only(bottom: 2),
  //       decoration: BoxDecoration(
  //         color:
  //             widget.provider.isCheckSigningStatus(item) == 1
  //                 ? Colors.green
  //                 : widget.provider.isCheckSigningStatus(item) == 0
  //                 ? Colors.red
  //                 : widget.provider.isCheckSigningStatus(item) == 3
  //                 ? Colors.green
  //                 : widget.provider.isCheckSigningStatus(item) == 5
  //                 ? Colors.purple
  //                 : Colors.blue,
  //         borderRadius: BorderRadius.circular(4),
  //       ),
  //       child: SGText(
  //         text:
  //             widget.provider.isCheckSigningStatus(item) == 1
  //                 ? 'Đã ký'
  //                 : widget.provider.isCheckSigningStatus(item) == 0
  //                 ? 'Chưa ký'
  //                 : widget.provider.isCheckSigningStatus(item) == 3
  //                 ? 'Đã ký & tạo'
  //                 : widget.provider.isCheckSigningStatus(item) == 5
  //                 ? 'Chưa ký & tạo'
  //                 : "Người tạo phiếu",
  //         size: 12,
  //         style: TextStyle(
  //           fontWeight: FontWeight.w500,
  //           color: Colors.white,
  //           fontSize: 12,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  //  all('Tất cả', ColorValue.darkGrey),
  //   draft('Nháp', ColorValue.silverGray),
  //   ready('Sẵn sàng', ColorValue.lightAmber),
  //   confirm('Xác nhận', ColorValue.mediumGreen),
  //   browser('Trình duyệt', ColorValue.lightBlue),
  //   complete('Hoàn thành', ColorValue.forestGreen),
  //   cancel('Hủy', ColorValue.coral);
  onViewDocument(ToolAndSuppliesHandoverDto item) async {
    isShowPreview = true;
    var dieuDongCcdc = widget.provider.dataAssetTransfer
        ?.where((element) => element.trangThai == 3)
        .toList()
        .firstWhere(
          (element) => element.id == item.lenhDieuDong,
          orElse: () => ToolAndMaterialTransferDto(),
        );

    _loadPdfNetwork(item.tenFile!).then((_) {
      if (mounted) {
        prevDocumentCcdcHandover(
          context: context,
          item: dieuDongCcdc!,
          provider: widget.provider,
          isShowKy: false,
          dieuDongCcdc: item,
        );
      }
    });
  }

  onDelete(ToolAndSuppliesHandoverDto item) {
    userInfo?.tenDangNhap == 'admin'
        ? showConfirmDialog(
          context,
          type: ConfirmType.delete,
          title: 'Xóa biên bản bàn giao',
          message: 'Bạn có chắc muốn xóa ${item.banGiaoCCDCVatTu}',
          highlight: item.banGiaoCCDCVatTu!,
          cancelText: 'Không',
          confirmText: 'Xóa',
          onConfirm: () {
            widget.provider.isLoading = true;
            context.read<ToolAndSuppliesHandoverBloc>().add(
              DeleteToolAndSuppliesHandoverEvent(context, item.id!),
            );
          },
        )
        : item.trangThai == 0
        ? showConfirmDialog(
          context,
          type: ConfirmType.delete,
          title: 'Xóa biên bản bàn giao',
          message: 'Bạn có chắc muốn xóa ${item.banGiaoCCDCVatTu}',
          highlight: item.banGiaoCCDCVatTu!,
          cancelText: 'Không',
          confirmText: 'Xóa',
          onConfirm: () {
            widget.provider.isLoading = true;
            context.read<ToolAndSuppliesHandoverBloc>().add(
              DeleteToolAndSuppliesHandoverEvent(context, item.id!),
            );
          },
        )
        : AppUtility.showSnackBar(
          context,
          'Bạn không thể xóa biên bản bàn giao này',
          isError: true,
        );
  }

  List<ResponsiveButtonData> _buildButtonList(int itemCount) {
    return [
      ResponsiveButtonData.fromButtonIcon(
        text: 'table.config_column'.tr,
        iconPath: 'assets/icons/settings.svg',
        backgroundColor: AppColor.white,
        iconColor: AppColor.textDark,
        textColor: AppColor.textDark,
        width: 130,
        onPressed: _openColumnConfigDialog,
      ),
      if (selectedItems.isNotEmpty &&
          selectedItems.length < 2 &&
          getPermissionSigning(selectedItems.first) != 0)
        ResponsiveButtonData.fromButtonIcon(
          text: 'table.signing'.tr,
          iconPath: AppIconSvgPath.iconPenLine,
          backgroundColor: AppColor.white,
          iconColor: ColorValue.coral,
          textColor: AppColor.textDark,
          width: 120,
          onPressed: () {
            if (selectedItems.isNotEmpty) {
              UserInfoDTO? userInfo = AccountHelper.instance.getUserInfo();
              ToolAndSuppliesHandoverDto? item =
                  selectedItems.isNotEmpty ? selectedItems.first : null;
              _handleSignDocument(item!, userInfo!, widget.provider);
            }
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
            TableToolAndSuppliesHandoverConfig.handleSendToSigner(
              selectedItems,
              context,
            );
          },
        ),
    ];
  }

  void _handleSignDocument(
    ToolAndSuppliesHandoverDto item,
    UserInfoDTO userInfo,
    ToolAndSuppliesHandoverProvider provider,
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

      var dieuDongCcdc = widget.provider.dataAssetTransfer
          ?.where((element) => element.trangThai == 3)
          .toList()
          .firstWhere(
            (element) => element.id == item.lenhDieuDong,
            orElse: () => ToolAndMaterialTransferDto(),
          );

      _loadPdfNetwork(item.tenFile!).then((_) {
        if (mounted) {
          prevDocumentCcdcHandover(
            context: context,
            item: dieuDongCcdc!,
            provider: widget.provider,
            isShowKy: true,
            dieuDongCcdc: item,
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

  // build detail department tree
  void _buildDetailDepartmentTree(ToolAndSuppliesHandoverDto item) {
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

  int getPermissionSigning(ToolAndSuppliesHandoverDto item) {
    final flow =
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
                      (e) => {"id": e.idNguoiKy, "signed": e.trangThai == 1},
                    )
                    .toList() ??
                []),
        ].where((s) => (s["id"] as String?)?.isNotEmpty == true).toList();
    final current = flow.indexWhere((s) => s["id"] == userInfo?.tenDangNhap);
    if (current == -1) return 2;
    if (item.idDaiDiendonviBanHanhQD == userInfo?.tenDangNhap &&
        flow[current]["signed"] != -1) {
      return flow[current]["signed"] == true ? 4 : 5;
    }
    if (flow[current]["signed"] == true) return 3;
    final prevNotSigned = flow
        .take(current)
        .firstWhere((s) => s["signed"] == false, orElse: () => {});
    if (prevNotSigned.isNotEmpty) return 1;
    return 0;
  }
}
