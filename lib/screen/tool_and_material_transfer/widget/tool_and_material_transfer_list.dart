// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:quan_ly_tai_san_app/common/button/action_button_config.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/sg_download_file.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/dieu_dong_tai_san_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/dieu_dong_tai_san_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/config_view_asset_transfer.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/bloc/tool_and_material_transfer_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/bloc/tool_and_material_transfer_state.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/component/preview_document_tool_and_meterial_transfer.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/component/row_find_by_status_ccdc.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/provider/tool_and_material_transfer_provider.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class ToolAndMaterialTransferList extends StatefulWidget {
  final ToolAndMaterialTransferProvider provider;
  final int typeAssetTransfer;
  final String idCongTy;

  const ToolAndMaterialTransferList({
    super.key,
    required this.provider,
    required this.typeAssetTransfer,
    required this.idCongTy,
  });

  @override
  State<ToolAndMaterialTransferList> createState() =>
      _ToolAndMaterialTransferListState();
}

class _ToolAndMaterialTransferListState
    extends State<ToolAndMaterialTransferList> {
  bool isUploading = false;

  final List<ToolAndMaterialTransferDto> listAssetHandover = [];
  List<ToolAndMaterialTransferDto> listItemSelected = [];
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

  @override
  void initState() {
    super.initState();
    _initializeColumnOptions();
    _callGetListAssetHandover();
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
    final List<SgTableColumn<ToolAndMaterialTransferDto>> columns =
        _buildColumns();
    log('message widget.provider.data: ${MediaQuery.of(context).size.width}');

    return MultiBlocListener(
      listeners: [
        BlocListener<ToolAndMaterialTransferBloc, ToolAndMaterialTransferState>(
          listener: (context, state) {
            if (state is GetListToolAndMaterialTransferSuccessState) {
              listAssetHandover.clear();
              listAssetHandover.addAll(state.data);
            } else if (state is GetListToolAndMaterialTransferFailedState) {}
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
              child: headerList(),
            ),
            Expanded(
              child: TableBaseView<ToolAndMaterialTransferDto>(
                searchTerm: '',
                columns: columns,
                data: widget.provider.dataPage ?? [],
                horizontalController: ScrollController(),
                onRowTap: (item) {
                  widget.provider.onChangeDetailToolAndMaterialTransfer(item);
                },
                onSelectionChanged: (items) {
                  setState(() {
                    listItemSelected.clear();
                    listItemSelected = items;
                  });
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
              children: [
                Icon(Icons.table_chart, color: Colors.grey.shade600, size: 18),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.5),
                  child: Text(
                    '${getName(widget.typeAssetTransfer)}(${widget.provider.data.length})',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _showColumnDisplayPopup,
                  child: Icon(Icons.settings, color: ColorValue.link, size: 18),
                ),
                _buildActionKy(),
              ],
            ),
            SizedBox(height: 20),
            RowFindByStatusCcdc(provider: widget.provider),
          ],
        )
        : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.table_chart, color: Colors.grey.shade600, size: 18),
                SizedBox(width: 8),
                Text(
                  '${getName(widget.typeAssetTransfer)}(${widget.provider.data.length})',
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
                SizedBox(width: 8),
                _buildActionKy(),
              ],
            ),
            Expanded(child: RowFindByStatusCcdc(provider: widget.provider)),
          ],
        );
  }

  Visibility _buildActionKy() {
    return Visibility(
      visible: listItemSelected.isNotEmpty && listItemSelected.length < 2,
      child: GestureDetector(
        onTap: () {
          if (listItemSelected.isNotEmpty) {
            ToolAndMaterialTransferDto? item = listItemSelected.first;
            _handleSignDocument(
              item,
              widget.provider.userInfo!,
              widget.provider,
            );
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
              text: 'Số lượng biên bản đã chọn: ${listItemSelected.length}',
              color: Colors.blue,
              size: 14,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
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
        onPressed: () {
          if (item.tenFile == null || item.tenFile!.isEmpty) {
            previewDocumentToolAndMaterial(
              context: context,
              item: item,
              provider: widget.provider,
              isShowKy: false,
            );
            return;
          }
          _loadPdfNetwork(item.tenFile!).then((_) {
            if (mounted) {
              previewDocumentToolAndMaterial(
                context: context,
                item: item,
                provider: widget.provider,
                document: _document,
                isShowKy: false,
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
                    title: 'Xóa nhóm tài sản',
                    message: 'Bạn có chắc muốn xóa ${item.tenPhieu}',
                    highlight: item.tenPhieu!,
                    cancelText: 'Không',
                    confirmText: 'Xóa',
                    onConfirm: () {
                      context.read<DieuDongTaiSanBloc>().add(
                        DeleteDieuDongEvent(context, item.id!),
                      );
                    },
                  ),
                },
            },
      ),
    ]);
  }

  String getName(int type) {
    switch (type) {
      case 1:
        return 'Phiếu duyệt cấp phát tài sản';
      case 2:
        return 'Phiếu duyệt chuyển tài sản';
      case 3:
        return 'Phiếu duyệt thu hồi tài sản';
    }
    return '';
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
    ToolAndMaterialTransferDto item,
    UserInfoDTO userInfo,
    ToolAndMaterialTransferProvider provider,
  ) {
    // Định nghĩa luồng ký theo thứ tự
    final signatureFlow =
        [
              {"id": item.nguoiTao, "signed": true, "label": "Người tạo"},
              {
                "id": item.idTruongPhongDonViGiao,
                "signed": item.truongPhongDonViGiaoXacNhan == true,
                "label": "Trưởng phòng",
              },
              {
                "id": item.idPhoPhongDonViGiao,
                "signed": item.phoPhongDonViGiaoXacNhan == true,
                "label": "Phó phòng Đơn vị giao",
              },
              {
                "id": item.idTrinhDuyetCapPhong,
                "signed": item.trangThai != null && item.trangThai! >= 3,
                "label": "Trình duyệt cấp phòng",
              },
              {
                "id": item.idTrinhDuyetGiamDoc,
                "signed": item.trangThai != null && item.trangThai! >= 3,
                "label": "Giám đốc",
              },
            ]
            .where(
              (step) => step["id"] != null && (step["id"] as String).isNotEmpty,
            )
            .toList();

    // Kiểm tra hoàn thành
    if (item.trangThai == 6) {
      AppUtility.showSnackBar(
        context,
        'Phiếu ký nội sinh này đã "Hoàn thành", không thể ký.',
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
    log('signatureFlow: ${signatureFlow.toString()}');
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
    if (item.tenFile == null || item.tenFile!.isEmpty) {
      previewDocumentToolAndMaterial(
        context: context,
        item: item,
        provider: provider,
      );
      return;
    }
    _loadPdfNetwork(item.tenFile!).then((_) {
      if (mounted) {
        previewDocumentToolAndMaterial(
          context: context,
          item: item,
          provider: widget.provider,
          document: _document,
        );
      }
    });
  }
}
