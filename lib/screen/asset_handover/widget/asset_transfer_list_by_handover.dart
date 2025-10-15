// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/theme/app_icon_svg_path.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/core/utils/uuid_generator.dart';
import 'package:quan_ly_tai_san_app/main.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/component/table_asset_transfer_by_handover_config.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/asset_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/table_asset_transfer_by_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/widget/controller/find_by_type.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/preview_document_asset_transfer.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:get/get.dart';
import 'package:table_base/core/themes/app_color.dart';
import 'package:table_base/widgets/box_search.dart';
import 'package:table_base/widgets/responsive_button_bar/responsive_button_bar.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';
import 'package:table_base/widgets/table/widgets/column_config_dialog.dart';
import 'package:table_base/widgets/table/widgets/riverpod_table.dart';
import 'package:table_base/widgets/table/widgets/table_actions_widget.dart';

enum FilterType {
  all('Tất cả', ColorValue.darkGrey),
  capPhat('Cấp phát', ColorValue.mediumGreen),
  dieuChuyen('Điều chuyển', ColorValue.lightBlue),
  thuHoi('Thu hồi', ColorValue.coral);

  final String label;
  final Color activeColor;
  const FilterType(this.label, this.activeColor);
}

class AssetTransferListByHandover extends StatefulWidget {
  final List<DieuDongTaiSanDto> data;
  final AssetHandoverProvider provider;

  const AssetTransferListByHandover({
    super.key,
    required this.data,
    required this.provider,
  });

  @override
  State<AssetTransferListByHandover> createState() =>
      _AssetTransferListByHandoverState();
}

class _AssetTransferListByHandoverState
    extends State<AssetTransferListByHandover> {
  bool isUploading = false;
  List<DieuDongTaiSanDto> dataAssetTransfer = [];
  List<DieuDongTaiSanDto> dataAssetTransferFilter = [];
  List<DieuDongTaiSanDto> selectedItems = [];
  UserInfoDTO? userInfo;

  final Map<FilterType, bool> _filterStatus = {
    FilterType.capPhat: false,
    FilterType.dieuChuyen: false,
    FilterType.thuHoi: false,
  };

  bool get isCapPhat => _filterStatus[FilterType.capPhat] ?? false;
  bool get isDieuChuyen => _filterStatus[FilterType.dieuChuyen] ?? false;
  bool get isThuHoi => _filterStatus[FilterType.thuHoi] ?? false;

  int get allCount => dataAssetTransfer.length;
  int get capPhatCount =>
      dataAssetTransfer.where((item) => (item.loai) == 1).length;
  int get dieuChuyenCount =>
      dataAssetTransfer.where((item) => (item.loai) == 2).length;
  int get thuHoiCount =>
      dataAssetTransfer.where((item) => (item.loai) == 3).length;

  PdfDocument? _document;

  // RiverpodTable configuration
  late List<ColumnDefinition> _definitions;
  late List<TableColumnData> _columns;
  late List<TableColumnData> _allColumns;
  final Set<String> _hiddenKeys = <String>{};
  late final Map<String, TableCellBuilder> _buildersByKey;
  final bool _showCheckboxColumn = true;
  final bool _showActionsColumn = true;

  @override
  void initState() {
    super.initState();
    userInfo = AccountHelper.instance.getUserInfo();
    dataAssetTransfer = widget.data;
    dataAssetTransferFilter =
        dataAssetTransfer.where((item) => item.daBanGiao == false).toList();
    _initializeTableConfig();
  }

  void _initializeTableConfig() {
    _definitions = TableAssetTransferByHandoverConfig.getColumns(
      userInfo ?? UserInfoDTO.empty(),
    );
    _columns = _definitions.map((d) => d.config).toList(growable: true);
    _allColumns = List<TableColumnData>.from(_columns);
    _buildersByKey = {for (final d in _definitions) d.config.key: d.builder};
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

  Future<void> _openColumnConfigDialog() async {
    try {
      final apply = await showColumnConfigAndApply(
        context: context,
        allColumns: _allColumns,
        currentColumns: _columns,
        initialHiddenKeys: _hiddenKeys.toList(),
        title: 'table.config_column'.tr,
      );
      if (apply != null) {
        setState(() {
          _hiddenKeys.clear();
          _hiddenKeys.addAll(apply.hiddenKeys);
          _columns = apply.updatedColumns;
        });
      }
    } catch (e) {
      // ignore
    }
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
      ResponsiveButtonData.fromButtonIcon(
        text: 'table.clear_filters'.tr,
        iconPath: 'assets/icons/refresh-ccw.svg',
        backgroundColor: AppColor.white,
        iconColor: AppColor.textDark,
        textColor: AppColor.textDark,
        width: 150,
        onPressed: () {
          // clear all filters
          // needs riverpod ref in build; handled where invoked
        },
      ),
    ];
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
        return TableAssetTransferByHandoverConfig.getName(item.loai ?? 0);
      case 'decision_date':
        return item.ngayKy;
      case 'effective_date':
        return item.tggnTuNgay;
      case 'approver':
        return item.tenTrinhDuyetGiamDoc;
      case 'document':
        return item.tenFile;
      case 'id':
        return item.id;
      case 'status':
        return 'Trạng thái'; // Will be handled by cellBuilder
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Divider(
            height: 1,
            thickness: 1,
            color: SGAppColors.colorBorderGray.withValues(alpha: 0.3),
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
                                  tableAssetTransferByHandoverProvider.notifier,
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
                            tableAssetTransferByHandoverProvider.select(
                              (s) => s.filterState.hasActiveFilters,
                            ),
                          );
                          final tableState = ref.watch(
                            tableAssetTransferByHandoverProvider,
                          );
                          final selectedCount = tableState.selectedItems.length;
                          selectedItems =
                              tableState.selectedItems
                                  .cast<DieuDongTaiSanDto>();
                          final buttons = _buildButtonList(selectedCount);
                          final processedButtons =
                              buttons.map((button) {
                                if (button.text == 'table.clear_filters'.tr) {
                                  return ResponsiveButtonData.fromButtonIcon(
                                    text: button.text,
                                    iconPath: button.iconPath!,
                                    backgroundColor: button.backgroundColor!,
                                    iconColor: button.iconColor!,
                                    textColor: button.textColor!,
                                    width: button.width,
                                    onPressed: () {
                                      ref
                                          .read(
                                            tableAssetTransferByHandoverProvider
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
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
              child: riverpod.Consumer(
                builder: (context, ref, child) {
                  final data = dataAssetTransferFilter;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ref
                        .read(tableAssetTransferByHandoverProvider.notifier)
                        .setData(data);
                  });
                  return RiverpodTable<DieuDongTaiSanDto>(
                    tableProvider: tableAssetTransferByHandoverProvider,
                    columns: _columns,
                    valueGetter: getValueForColumn,
                    cellsBuilder: (_) => [],
                    cellBuilderByKey: (item, key) {
                      final builder = _buildersByKey[key];
                      if (builder != null) return builder(item);
                      return null;
                    },
                    showCheckboxColumn: _showCheckboxColumn,
                    showActionsColumn: _showActionsColumn,
                    actionsColumnWidth: 120,
                    customActions: [
                      CustomAction(
                        tooltip: 'Xem',
                        iconPath: AppIconSvgPath.iconEye,
                        color: Colors.green,
                        onPressed: (item) {
                          onViewDocument(item);
                        },
                      ),
                      CustomAction(
                        tooltip: 'Tạo biên bản bàn giao tài sản',
                        iconPath: AppIconSvgPath.iconNextDocument,
                        color: ColorValue.mediumGreen,
                        onPressed: (item) {
                          widget.provider.onChangeDetail(
                            context,
                            AssetHandoverDto(
                              id: UUIDGenerator.generateWithFormat(
                                'BG-************',
                              ),
                              idCongTy: item.idCongTy,
                              banGiaoTaiSan: 'Biên bản bàn giao ${item.id}',
                              quyetDinhDieuDongSo: '',
                              lenhDieuDong: item.id,
                              idDonViGiao: item.idDonViGiao,
                              tenDonViGiao: item.tenDonViGiao,
                              idDonViNhan: item.idDonViNhan,
                              tenDonViNhan: item.tenDonViNhan,
                              ngayBanGiao: '',
                              idLanhDao: '',
                              tenLanhDao: '',
                              tenDaiDienBanHanhQD: '',
                              tenDaiDienBenGiao: '',
                              tenDaiDienBenNhan: '',
                              tenDonViDaiDien: '',
                              daXacNhan: false,
                              daiDienBenGiaoXacNhan: false,
                              daiDienBenNhanXacNhan: false,
                              donViDaiDienXacNhan: '0',
                            ),
                            isFindNew: true,
                          );
                        },
                      ),
                    ],
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                  );
                },
              ),
            ),
          ),
        ],
      ),
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
              'Biên bản điều động',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        FindByType(
          isCapPhat: isCapPhat,
          isDieuChuyen: isDieuChuyen,
          isThuHoi: isThuHoi,
          allCount: allCount,
          capPhatCount: capPhatCount,
          dieuChuyenCount: dieuChuyenCount,
          thuHoiCount: thuHoiCount,
          onFilterChanged: (status, value) {
            setState(() {
              setFilterStatus(status, value);
            });
          },
        ),
      ],
    );
  }

  void setFilterStatus(FilterType status, bool? value) {
    _filterStatus[status] = value ?? false;

    if (status == FilterType.all && value == true) {
      for (var key in _filterStatus.keys) {
        if (key != FilterType.all) {
          _filterStatus[key] = false;
        }
      }
    } else if (status != FilterType.all && value == true) {
      _filterStatus[FilterType.all] = false;
    }

    _applyFilters();
  }

  void _applyFilters() {
    bool hasActiveFilter = _filterStatus.entries
        .where((entry) => entry.key != FilterType.capPhat)
        .any((entry) => entry.value == true);

    // Lọc theo trạng thái
    List<DieuDongTaiSanDto> statusFiltered;
    if (_filterStatus[FilterType.all] == true || !hasActiveFilter) {
      statusFiltered = List.from(dataAssetTransfer);
    } else {
      statusFiltered =
          dataAssetTransfer.where((item) {
            int itemStatus = item.loai ?? -1;

            if (_filterStatus[FilterType.capPhat] == true &&
                (itemStatus == 1)) {
              return true;
            }

            if (_filterStatus[FilterType.dieuChuyen] == true &&
                (itemStatus == 2)) {
              return true;
            }

            if (_filterStatus[FilterType.thuHoi] == true && (itemStatus == 3)) {
              return true;
            }

            return false;
          }).toList();
    }

    setState(() {
      dataAssetTransferFilter = statusFiltered;
    });
  }

  void onViewDocument(DieuDongTaiSanDto item) async {
    NhanVien nhanVien =
        widget.provider.dataStaff?.firstWhere(
          (element) => element.id == widget.provider.userInfo?.tenDangNhap,
          orElse: () => NhanVien(),
        ) ??
        NhanVien();
    if (nhanVien.id == null) {
      AppUtility.showSnackBar(
        context,
        'Bạn không có quyền xem tài liệu',
        isError: true,
      );
      return;
    }

    if (item.tenFile == null || item.tenFile!.isEmpty) {
      previewDocumentView(
        context: context,
        item: item,
        userInfo: userInfo!,
        nhanVien: nhanVien,
        isShowKy: false,
        document: _document,
      );
    } else {
      await _loadPdfNetwork(item.tenFile!);
      if (mounted) {
        previewDocumentView(
          context: context,
          item: item,
          userInfo: userInfo!,
          nhanVien: nhanVien,
          isShowKy: false,
          document: _document,
        );
      }
    }
  }
}
