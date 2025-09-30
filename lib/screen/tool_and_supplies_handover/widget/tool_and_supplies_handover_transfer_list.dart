import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:quan_ly_tai_san_app/common/button/action_button_config.dart';
import 'package:quan_ly_tai_san_app/common/sg_download_file.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/core/utils/uuid_generator.dart';
import 'package:quan_ly_tai_san_app/main.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/config_view_asset_transfer.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/component/preview_document_tool_and_meterial_transfer.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/tool_and_supplies_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/provider/tool_and_supplies_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/widget/controller/find_by_type_tool_and_supplies.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

enum FilterType {
  all('Tất cả', ColorValue.darkGrey),
  capPhat('Cấp phát', ColorValue.mediumGreen),
  dieuChuyen('Điều chuyển', ColorValue.lightBlue),
  thuHoi('Thu hồi', ColorValue.coral);

  final String label;
  final Color activeColor;
  const FilterType(this.label, this.activeColor);
}

class ToolAndSuppliesHandoverTransferList extends StatefulWidget {
  final List<ToolAndMaterialTransferDto> data;
  final ToolAndSuppliesHandoverProvider provider;

  const ToolAndSuppliesHandoverTransferList({
    super.key,
    required this.data,
    required this.provider,
  });

  @override
  State<ToolAndSuppliesHandoverTransferList> createState() =>
      _ToolAndSuppliesHandoverTransferListState();
}

class _ToolAndSuppliesHandoverTransferListState
    extends State<ToolAndSuppliesHandoverTransferList> {
  bool isUploading = false;
  List<ToolAndMaterialTransferDto> dataAssetTransfer = [];
  List<ToolAndMaterialTransferDto> dataAssetTransferFilter = [];
  List<ToolAndMaterialTransferDto> selectedItems = [];
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
  List<Map<String, DateTime Function(ToolAndMaterialTransferDto)>> getters = [
    {
      'Ngày ngày có hiệu lực':
          (item) => DateTime.tryParse(item.tggnTuNgay ?? '') ?? DateTime.now(),
    },
    {
      'Ngày ký':
          (item) => DateTime.tryParse(item.ngayKy ?? '') ?? DateTime.now(),
    },
  ];

  @override
  void initState() {
    super.initState();
    userInfo = AccountHelper.instance.getUserInfo();
    dataAssetTransfer = widget.data;
    dataAssetTransferFilter = dataAssetTransfer;
    log('message dataAssetTransfer: ${dataAssetTransfer.length}');
    _initializeColumnOptions();
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

  void _initializeColumnOptions() {
    columnOptions = [
      ColumnDisplayOption(
        id: 'type',
        label: 'Phiếu ký nội sinh',
        isChecked: visibleColumnIds.contains('type'),
      ),
      ColumnDisplayOption(
        id: 'decision_date',
        label: 'Ngày ký',
        isChecked: visibleColumnIds.contains('decision_date'),
      ),
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
      ColumnDisplayOption(
        id: 'document',
        label: 'Tài liệu duyệt',
        isChecked: visibleColumnIds.contains('document'),
      ),
      ColumnDisplayOption(
        id: 'id',
        label: 'Ký số',
        isChecked: visibleColumnIds.contains('id'),
      ),
      ColumnDisplayOption(
        id: 'status',
        label: 'Trạng thái',
        isChecked: visibleColumnIds.contains('status'),
      ),
      ColumnDisplayOption(
        id: 'actions',
        label: 'Thao tác',
        isChecked: visibleColumnIds.contains('actions'),
      ),
    ];
  }

  List<SgTableColumn<ToolAndMaterialTransferDto>> _buildColumns() {
    final List<SgTableColumn<ToolAndMaterialTransferDto>> columns = [];

    // Thêm cột dựa trên visibleColumnIds
    for (String columnId in visibleColumnIds) {
      switch (columnId) {
        case 'type':
          columns.add(
            TableBaseConfig.columnTable<ToolAndMaterialTransferDto>(
              title: 'Phiếu ký nội sinh',
              width: 150,
              getValue: (item) => getName(item.loai ?? 0),
            ),
          );
          break;
        case 'decision_date':
          columns.add(
            TableBaseConfig.columnTable<ToolAndMaterialTransferDto>(
              title: 'Ngày ký',
              width: 100,
              getValue: (item) => item.ngayKy ?? '',
            ),
          );
          break;
        case 'effective_date':
          columns.add(
            TableBaseConfig.columnTable<ToolAndMaterialTransferDto>(
              title: 'Ngày có hiệu lực',
              width: 100,
              getValue: (item) => item.tggnTuNgay ?? '',
            ),
          );
          break;
        case 'approver':
          columns.add(
            TableBaseConfig.columnTable<ToolAndMaterialTransferDto>(
              title: 'Trình duyệt ban giám đốc',
              width: 150,
              getValue: (item) => item.tenTrinhDuyetGiamDoc ?? '',
            ),
          );
          break;
        case 'document':
          columns.add(
            SgTableColumn<ToolAndMaterialTransferDto>(
              title: 'Tài liệu duyệt',
              cellBuilder:
                  (item) => SgDownloadFile(
                    url: item.duongDanFile.toString(),
                    name: item.tenFile ?? '',
                  ),
              sortValueGetter: (item) => item.tenFile ?? '',
              searchValueGetter: (item) => item.tenFile ?? '',
              cellAlignment: TextAlign.center,
              titleAlignment: TextAlign.center,
              width: 150,
              searchable: true,
            ),
          );
          break;
        case 'id':
          columns.add(
            TableBaseConfig.columnTable<ToolAndMaterialTransferDto>(
              title: 'Ký số',
              width: 120,
              getValue: (item) => item.id ?? '',
            ),
          );
          break;
        case 'status':
          columns.add(
            TableBaseConfig.columnWidgetBase<ToolAndMaterialTransferDto>(
              title: 'Trạng thái',
              cellBuilder:
                  (item) => ConfigViewAT.showStatus(item.trangThai ?? 0),
              width: 150,
              searchable: true,
            ),
          );
          break;
        case 'actions':
          columns.add(
            TableBaseConfig.columnWidgetBase<ToolAndMaterialTransferDto>(
              title: 'Thao tác',
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
    final List<SgTableColumn<ToolAndMaterialTransferDto>> columns =
        _buildColumns();
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
          Expanded(
            child: TableBaseView<ToolAndMaterialTransferDto>(
              searchTerm: '',
              columns: columns,
              getters: getters,
              startDate: DateTime.tryParse(
                dataAssetTransferFilter.isNotEmpty
                    ? dataAssetTransferFilter.first.tggnTuNgay.toString()
                    : '',
              ),
              data: dataAssetTransferFilter,
              horizontalController: ScrollController(),
              onRowTap: (item) {},
              onSelectionChanged: (items) {
                setState(() {});
              },
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

            // Spacer(),
            GestureDetector(
              onTap: _showColumnDisplayPopup,
              child: Icon(Icons.settings, color: ColorValue.link, size: 18),
            ),
          ],
        ),
        FindByTypeToolAndSupplies(
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

  Widget viewAction(ToolAndMaterialTransferDto item) {
    return viewActionButtons([
      ActionButtonConfig(
        icon: Icons.visibility,
        tooltip: 'Xem',
        iconColor: ColorValue.cyan,
        backgroundColor: Colors.green.shade50,
        borderColor: Colors.green.shade200,
        onPressed: () async {
          NhanVien nhanVien =
              widget.provider.dataStaff?.firstWhere(
                (element) =>
                    element.id == widget.provider.userInfo?.tenDangNhap,
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

          await _loadPdfNetwork(item.tenFile!);
          if (mounted) {
            previewDocumentToolAndMaterial(
              context: context,
              item: item,
              isShowKy: false,
              document: _document,
              nhanVien: widget.provider.getNhanVienByID(
                widget.provider.userInfo?.tenDangNhap ?? '',
              ),
            );
          }
        },
      ),
      ActionButtonConfig(
        icon: Icons.navigate_next_outlined,
        tooltip: 'Tạo biên bản bàn giao ccdc-vật tư',
        iconColor: Colors.grey,
        backgroundColor: Colors.red.shade50,
        borderColor: Colors.red.shade200,
        onPressed:
            () => {
              widget.provider.onChangeDetail(
                context,
                ToolAndSuppliesHandoverDto(
                  id: UUIDGenerator.generateWithFormat('BBCCDC-******'),
                  banGiaoCCDCVatTu: '',
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
                  daXacNhan: false,
                  daiDienBenGiaoXacNhan: false,
                  daiDienBenNhanXacNhan: false,
                  tenFile: "",
                  duongDanFile: "",
                ),
                isFindNew: true,
                isFindNewItem: true,
              ),
            },
      ),
    ]);
  }

  String getName(int type) {
    switch (type) {
      case 1:
        return 'Phiếu duyệt cấp phát ccdc-vật tư';
      case 2:
        return 'Phiếu duyệt chuyển ccdc-vật tư';
      case 3:
        return 'Phiếu duyệt thu hồi ccdc-vật tư';
    }
    return '';
  }

  void setFilterStatus(FilterType status, bool? value) {
    log('message setFilterStatus: $status, $value');

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
    List<ToolAndMaterialTransferDto> statusFiltered;
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
}
