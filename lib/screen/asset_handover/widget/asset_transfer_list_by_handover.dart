// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/theme/app_icon_svg_path.dart';
import 'package:quan_ly_tai_san_app/core/constants/function_type.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
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
import 'package:quan_ly_tai_san_app/message/message_providers.dart';
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

class AssetTransferListByHandover extends riverpod.ConsumerStatefulWidget {
  final List<DieuDongTaiSanDto> data;
  final AssetHandoverProvider provider;

  const AssetTransferListByHandover({
    super.key,
    required this.data,
    required this.provider,
  });

  @override
  riverpod.ConsumerState<AssetTransferListByHandover> createState() =>
      _AssetTransferListByHandoverState();
}

class _AssetTransferListByHandoverState
    extends riverpod.ConsumerState<AssetTransferListByHandover> {
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

  // Realtime listener
  riverpod.ProviderSubscription<Map<String, dynamic>?>? _messageSub;
  Timer? _debounceTimer;

  // Cache constants
  static const int _assetHandoverType = FunctionType.ASSET_HANDOVER;
  static const int _allFunctionType = FunctionType.ALL_FUNCTION;

  // Cache timestamp để tránh xử lý trùng message
  int? _lastProcessedMessageTime;

  // Cache username hiện tại để tối ưu so khớp id_need_to_do
  String _currentUsername = '';

  // RiverpodTable configuration
  late List<ColumnDefinition> _definitions;
  late List<TableColumnData> _columns;
  late List<TableColumnData> _allColumns;
  final Set<String> _hiddenKeys = <String>{};
  late final Map<String, TableCellBuilder> _buildersByKey;
  final bool _showCheckboxColumn = true;
  final bool _showActionsColumn = true;

  // Lưu type filter hiện tại để reload đúng filter khi realtime
  int _currentTypeFilter = -1;

  @override
  void initState() {
    super.initState();
    userInfo = AccountHelper.instance.getUserInfo();
    _currentUsername =
        userInfo?.tenDangNhap ??
        AccountHelper.instance.getUserInfo()?.tenDangNhap ??
        '';
    dataAssetTransfer = widget.data;
    dataAssetTransferFilter =
        dataAssetTransfer.where((item) => item.daBanGiao == false).toList();
    _initializeTableConfig();

    // Listen Firebase realtime để tự động reload table
    _messageSub = ref.listenManual<
      Map<String, dynamic>?
    >(messageLatestJsonProvider, (previous, next) {
      // Log raw message để kiểm tra realtime
      SGLog.info(
        'ASSET_HANDOVER',
        'ASSET_HANDOVER realtime raw message: $next',
      );

      // Early return: kiểm tra null/empty trước
      if (next == null || next.isEmpty || !mounted) return;

      // Lấy typeFunc và check nhanh
      final typeFunc = next['type_func'];
      SGLog.info('ASSET_HANDOVER', 'ASSET_HANDOVER type_func: $typeFunc');
      if (typeFunc is! int) return;

      // Chỉ xử lý message liên quan đến bàn giao tài sản hoặc all
      if (typeFunc != _assetHandoverType && typeFunc != _allFunctionType) {
        SGLog.info(
          'ASSET_HANDOVER',
          'ASSET_HANDOVER skip: type_func not match',
        );
        return;
      }

      // Nếu message có danh sách id_need_to_do thì chỉ reload
      // khi user hiện tại nằm trong danh sách cần xử lý
      final idNeedToDo = next['id_need_to_do'];
      if (_currentUsername.isNotEmpty && idNeedToDo is String) {
        final inList = AppUtility.userInList(_currentUsername, idNeedToDo);
        SGLog.info(
          'ASSET_HANDOVER',
          'ASSET_HANDOVER check id_need_to_do, user=$_currentUsername, inList=$inList',
        );
        if (!inList) {
          return;
        }
      }

      // Tránh xử lý duplicate message theo timestamp
      final messageTime = next['time'];
      if (messageTime is int && _lastProcessedMessageTime != null) {
        if (messageTime <= _lastProcessedMessageTime!) {
          SGLog.info(
            'ASSET_HANDOVER',
            'ASSET_HANDOVER skip duplicate message, time=$messageTime, last=$_lastProcessedMessageTime',
          );
          return;
        }
        _lastProcessedMessageTime = messageTime;
      } else if (messageTime is int) {
        _lastProcessedMessageTime = messageTime;
      }

      SGLog.info(
        'ASSET_HANDOVER',
        'ASSET_HANDOVER trigger debounce reload, currentTypeFilter=$_currentTypeFilter',
      );

      // Debounce để tránh reload quá nhiều lần
      _debouncedReloadTable();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Delay refreshData để tránh lỗi "modify provider while widget tree is building"
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final container = riverpod.ProviderScope.containerOf(context);
      container
          .read(tableAssetTransferByHandoverProvider.notifier)
          .refreshData(-1);
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _messageSub?.close();
    super.dispose();
  }

  void _debouncedReloadTable() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      // Reload lại table với type filter hiện tại, giữ nguyên page
      ref
          .read(tableAssetTransferByHandoverProvider.notifier)
          .refreshData(_currentTypeFilter);
    });
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Giảm nhẹ để tránh tràn do margin/padding xung quanh
                  final tableMaxHeight =
                      (constraints.maxHeight - 65)
                          .clamp(0.0, constraints.maxHeight)
                          .toDouble();

                  return riverpod.Consumer(
                    builder: (context, ref, child) {
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
                        rowDividerColor: Colors.white.withAlpha(
                          (0.7 * 255).toInt(),
                        ),
                        rowDividerThickness: 1,
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
                            block:
                                (item) =>
                                    (item.chiTietDieuDongTaiSans?.length ??
                                        0) <=
                                    0,
                            blockTooltip: 'Đã hoàn thành bàn giao tài sản',
                            onPressed: (item) {
                              DateTime now = DateTime.now();
                              widget.provider.onChangeDetail(
                                context,
                                AssetHandoverDto(
                                  idCongTy: item.idCongTy,
                                  banGiaoTaiSan:
                                      'Biên bản bàn giao ngày ${DateFormat('dd/MM/yyyy').format(now)}',
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
                        maxHeight: tableMaxHeight,
                      );
                    },
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
        riverpod.Consumer(
          builder: (context, ref, _) {
            ref.watch(tableAssetTransferByHandoverProvider);
            final isLoading = ref.read(
              tableAssetTransferByHandoverProvider.select((s) => s.isLoading),
            );
            final totals =
                ref
                    .read(tableAssetTransferByHandoverProvider.notifier)
                    .getTotals();
            return FindByType(
              isCapPhat: isCapPhat,
              isDieuChuyen: isDieuChuyen,
              isThuHoi: isThuHoi,
              allCount: isLoading ? 0 : totals['totalAll'] ?? 0,
              capPhatCount: isLoading ? 0 : totals['totalCP'] ?? 0,
              dieuChuyenCount: isLoading ? 0 : totals['totalDC'] ?? 0,
              thuHoiCount: isLoading ? 0 : totals['totalTH'] ?? 0,
              onFilterChanged: (status, value) {
                setState(() {
                  setFilterStatus(status, value);
                });
              },
            );
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

    int type = -1;
    if (isCapPhat) {
      type = 1;
    } else if (isDieuChuyen) {
      type = 2;
    } else if (isThuHoi) {
      type = 3;
    }

    // Cập nhật type filter hiện tại để realtime reload đúng trạng thái
    _currentTypeFilter = type;

    final container = ProviderScope.containerOf(context);
    container
        .read(tableAssetTransferByHandoverProvider.notifier)
        .refreshData(type);
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
