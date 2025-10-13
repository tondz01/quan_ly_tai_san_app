import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:quan_ly_tai_san_app/common/diagram/thread_lines.dart';
import 'package:quan_ly_tai_san_app/main.dart';
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

  List<ThreadNode> listSignatoryDetail = [];
  List<AssetHandoverDto> selectedItems = [];

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
        return item.nguoiTao;
      case 'trang_thai_ky':
        return 'Trạng thái ký'; // Sẽ được xử lý bởi cellBuilder
      case 'trang_thai_ban_giao':
        return item.trangThaiPhieu;
      case 'document':
        return item.tenFile;
      case 'trang_thai_phieu':
        return item.trangThai;
      case 'share':
        return item.share == true ? 'Đã chia sẻ' : 'Chưa chia sẻ';
      default:
        return null;
    }
  }

  @override
  void didUpdateWidget(covariant AssetHandoverList oldWidget) {
    super.didUpdateWidget(oldWidget);
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
        header: 'Đại diện bên giao:',
        depth: 1,
        child: viewSignatoryStatus(
          item.daiDienBenGiaoXacNhan ?? false,
          item.tenDaiDienBenGiao ?? '',
        ),
      ),
      ThreadNode(
        header: 'Đại diện bên nhận:',
        depth: 1,
        child: viewSignatoryStatus(
          item.daiDienBenNhanXacNhan ?? false,
          item.tenDaiDienBenNhan ?? '',
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

  Widget _buildActionKy() {
    return Container(
      margin: EdgeInsets.only(left: 8),
      child: ElevatedButton.icon(
        onPressed: selectedItems.isNotEmpty
            ? () {
                // Handle signing logic
              }
            : null,
        icon: Icon(Icons.edit, size: 16),
        label: Text('Ký'),
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedItems.isNotEmpty ? Colors.blue : Colors.grey,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
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
      if (selectedItems.isNotEmpty)
        ResponsiveButtonData.fromButtonIcon(
          text: "${'table.send'.tr} (${selectedItems.length})",
          iconPath: AppIconSvg.iconSetting,
          backgroundColor: Colors.redAccent,
          iconColor: AppColor.textWhite,
          textColor: AppColor.textWhite,
          width: 130,
          onPressed: () {
            // Handle send to signer logic
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
                                _buildActionKy(),
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
                                              tableAssetHandoverProvider.notifier,
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
                                                        'table.clear_filters'.tr,
                                                  )
                                                  .toList();

                                      return ResponsiveButtonBar(
                                        buttons: filteredButtons,
                                        spacing: 12,
                                        overflowSide: OverflowSide.start,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        popupPosition: PopupMenuPosition.under,
                                        popupOffset: const Offset(0, 8),
                                        popupShape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
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
                            final data = widget.provider.data ?? [];
                            ref
                                .read(tableAssetHandoverProvider.notifier)
                                .setData(data);

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
                                // widget.provider.onChangeDetailAssetHandover(item);
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
                                  color: Colors.blue,
                                  onPressed: (item) async {
                                    await _loadPdfNetwork(item.tenFile!);
                                    if (!context.mounted) return;
                                    previewDocumentAssetHandover(
                                      context: context,
                                      item: item,
                                      provider: widget.provider,
                                      isShowKy: false,
                                      itemsDetail: [],
                                    );
                                  },
                                ),
                              ],
                              actionsColumnWidth: 120,
                              maxHeight: MediaQuery.of(context).size.height * 0.8,
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
}
