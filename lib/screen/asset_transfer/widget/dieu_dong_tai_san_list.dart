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
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/dieu_dong_tai_san_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/dieu_dong_tai_san_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/config_view_asset_transfer.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/preview_document_asset_transfer.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/property_handover_minutes.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/row_find_by_status.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/dieu_dong_tai_san_provider.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

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
  List<DieuDongTaiSanDto> selectedItems = [];
  UserInfoDTO? userInfo;

  final List<AssetHandoverDto> listAssetHandover = [];
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
    userInfo = AccountHelper.instance.getUserInfo();
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

  List<SgTableColumn<DieuDongTaiSanDto>> _buildColumns() {
    final List<SgTableColumn<DieuDongTaiSanDto>> columns = [];

    // Thêm cột dựa trên visibleColumnIds
    for (String columnId in visibleColumnIds) {
      switch (columnId) {
        case 'type':
          columns.add(
            TableBaseConfig.columnTable<DieuDongTaiSanDto>(
              title: 'Phiếu ký nội sinh',
              width: 150,
              getValue: (item) => getName(item.loai ?? 0),
            ),
          );
          break;
        case 'decision_date':
          columns.add(
            TableBaseConfig.columnTable<DieuDongTaiSanDto>(
              title: 'Ngày ký',
              width: 100,
              getValue: (item) => item.ngayKy ?? '',
            ),
          );
          break;
        case 'effective_date':
          columns.add(
            TableBaseConfig.columnTable<DieuDongTaiSanDto>(
              title: 'Ngày có hiệu lực',
              width: 100,
              getValue: (item) => item.tggnTuNgay ?? '',
            ),
          );
          break;
        case 'approver':
          columns.add(
            TableBaseConfig.columnTable<DieuDongTaiSanDto>(
              title: 'Trình duyệt ban giám đốc',
              width: 150,
              getValue: (item) => item.tenTrinhDuyetGiamDoc ?? '',
            ),
          );
          break;
        case 'document':
          columns.add(
            SgTableColumn<DieuDongTaiSanDto>(
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
            TableBaseConfig.columnTable<DieuDongTaiSanDto>(
              title: 'Ký số',
              width: 120,
              getValue: (item) => item.id ?? '',
            ),
          );
          break;
        case 'status':
          columns.add(
            TableBaseConfig.columnWidgetBase<DieuDongTaiSanDto>(
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
            TableBaseConfig.columnWidgetBase<DieuDongTaiSanDto>(
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
    final List<SgTableColumn<DieuDongTaiSanDto>> columns = _buildColumns();
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
              child: TableBaseView<DieuDongTaiSanDto>(
                searchTerm: '',
                columns: columns,
                data: widget.provider.dataPage ?? [],
                horizontalController: ScrollController(),
                onRowTap: (item) {
                  widget.provider.onChangeDetailDieuDongTaiSan(item);
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
                SizedBox(width: 8),
                Visibility(
                  visible: selectedItems.isNotEmpty && selectedItems.length < 2,
                  child: GestureDetector(
                    onTap: () {
                      if (selectedItems.isNotEmpty) {
                        DieuDongTaiSanDto? item = selectedItems.first;
                        _handleSignDocument(item, userInfo!, widget.provider);
                      }
                    },
                    child: Row(
                      spacing: 8,
                      children: [
                        Tooltip(
                          message: 'Ký biên bản',
                          child: Icon(
                            Icons.edit,
                            color: Colors.green,
                            size: 18,
                          ),
                        ),
                        SGText(
                          text:
                              'Số lượng biên bản đã chọn: ${selectedItems.length}',
                          color: Colors.blue,
                          size: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            RowFindByStatus(provider: widget.provider),
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
                Visibility(
                  visible: selectedItems.isNotEmpty && selectedItems.length < 2,
                  child: GestureDetector(
                    onTap: () {
                      if (selectedItems.isNotEmpty) {
                        DieuDongTaiSanDto? item = selectedItems.first;
                        _handleSignDocument(item, userInfo!, widget.provider);
                      }
                    },
                    child: Row(
                      spacing: 8,
                      children: [
                        Tooltip(
                          message: 'Ký biên bản',
                          child: Icon(
                            Icons.edit,
                            color: Colors.green,
                            size: 18,
                          ),
                        ),
                        SGText(
                          text:
                              'Số lượng biên bản đã chọn: ${selectedItems.length}',
                          color: Colors.blue,
                          size: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(child: RowFindByStatus(provider: widget.provider)),
          ],
        );
  }

  Widget viewAction(DieuDongTaiSanDto item) {
    return viewActionButtons([
      ActionButtonConfig(
        icon: Icons.book_outlined,
        tooltip: 'Biên bản bản giao',
        iconColor: ColorValue.lightAmber,
        backgroundColor: Colors.red.shade50,
        borderColor: Colors.red.shade200,
        onPressed: () {
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
            listAssetHandover.where((itemAH) => itemAH.id == item.id).toList(),
          );
        },
      ),
      ActionButtonConfig(
        icon: Icons.visibility,
        tooltip: 'Xem',
        iconColor: ColorValue.cyan,
        backgroundColor: Colors.green.shade50,
        borderColor: Colors.green.shade200,
        onPressed: () async {
          if (item.tenFile == null || item.tenFile!.isEmpty) {
            previewDocument(
              context: context,
              item: item,
              provider: widget.provider,
              isShowKy: false,
              document: _document,
            );
          } else {
            await _loadPdfNetwork(item.tenFile!);
            if (mounted) {
              previewDocument(
                context: context,
                item: item,
                provider: widget.provider,
                isShowKy: false,
                document: _document,
              );
            }
          }
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

  // Check show popup sign document
  void _handleSignDocument(
    DieuDongTaiSanDto item,
    UserInfoDTO userInfo,
    DieuDongTaiSanProvider provider,
  ) async {
    // Định nghĩa luồng ký theo thứ tự
    final signatureFlow =
        [
              {"id": item.nguoiTao, "signed": true, "label": "Người tạo"},
              {
                "id": item.idTruongPhongDonViGiao,
                "signed": item.truongPhongDonViGiaoXacNhan == true,
                "label": "Trưởng phòng Đơn vị giao",
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
    if (item.trangThai == 6 || item.trangThai == 5) {
      String title = widget.provider.getScreenTitle();
      String message = item.trangThai == 5 ? 'Đã bị hủy' : 'Đã hoàn thành';
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
    if (item.tenFile == null || item.tenFile!.isEmpty) {
      previewDocument(
        context: context,
        item: item,
        provider: widget.provider,
        isShowKy: false,
        document: _document,
      );
    } else {
      await _loadPdfNetwork(item.tenFile!);
      if (mounted) {
        previewDocument(
          context: context,
          item: item,
          provider: widget.provider,
          isShowKy: false,
          document: _document,
        );
      }
    }
  }
}
