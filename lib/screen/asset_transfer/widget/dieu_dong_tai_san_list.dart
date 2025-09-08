import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:quan_ly_tai_san_app/common/button/action_button_config.dart';
import 'package:quan_ly_tai_san_app/common/diagram/thread_lines.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/sg_download_file.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/main.dart';
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
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/component/department_tree_demo.dart';
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
  bool isShowDetailDepartmentTree = false;

  String nameBenBan = "";

  List<DieuDongTaiSanDto> selectedItems = [];
  DieuDongTaiSanDto? selected;
  List<ThreadNode> listSignatoryDetail = [];
  UserInfoDTO? userInfo;

  final List<AssetHandoverDto> listAssetHandover = [];
  PdfDocument? _document;
  // Column display options
  late List<ColumnDisplayOption> columnOptions;
  List<String> visibleColumnIds = [
    'signing_status',
    'share',
    'type',
    'effective_date',
    'approver',
    'document',
    'id',
    'decision_date',
    'to_date',
    'status',
    'actions',
  ];
  List<Map<String, DateTime Function(DieuDongTaiSanDto)>> getters = [];
  @override
  void initState() {
    super.initState();
    userInfo = AccountHelper.instance.getUserInfo();
    isShowDetailDepartmentTree = false;
    if (selected != null) {
      _buildDetailDepartmentTree(selected!);
    }
    _initializeColumnOptions();
    _callGetListAssetHandover();
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

  void _initializeColumnOptions() {
    columnOptions = [
      ColumnDisplayOption(
        id: 'signing_status',
        label: 'Trạng thái ký',
        isChecked: visibleColumnIds.contains('signing_status'),
      ),
      ColumnDisplayOption(
        id: 'share',
        label: 'Chia sẻ',
        isChecked: visibleColumnIds.contains('share'),
      ),
      ColumnDisplayOption(
        id: 'type',
        label: 'Phiếu ký nội sinh',
        isChecked: visibleColumnIds.contains('type'),
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
        id: 'decision_date',
        label: 'Thời gian giao nhận từ ngày',
        isChecked: visibleColumnIds.contains('decision_date'),
      ),
      ColumnDisplayOption(
        id: 'to_date',
        label: 'Thời gian giao nhận đến ngày',
        isChecked: visibleColumnIds.contains('to_date'),
      ),
      ColumnDisplayOption(
        id: 'status',
        label: 'Trạng thái phiếu',
        isChecked: visibleColumnIds.contains('status'),
      ),
      ColumnDisplayOption(
        id: 'actions',
        label: 'Thao tác',
        isChecked: visibleColumnIds.contains('actions'),
      ),
    ];

    getters = [
      {
        'Thời gian giao nhận từ ngày':
            (item) =>
                DateTime.tryParse(item.tggnTuNgay ?? '') ?? DateTime.now(),
      },
      {
        'Thời gian giao nhận đến ngày':
            (item) =>
                DateTime.tryParse(item.tggnDenNgay ?? '') ?? DateTime.now(),
      },
    ];
  }

  List<SgTableColumn<DieuDongTaiSanDto>> _buildColumns() {
    final List<SgTableColumn<DieuDongTaiSanDto>> columns = [];

    // Thêm cột dựa trên visibleColumnIds
    for (String columnId in visibleColumnIds) {
      switch (columnId) {
        case 'signing_status':
          columns.add(
            TableBaseConfig.columnWidgetBase<DieuDongTaiSanDto>(
              title: 'Trạng thái ký',
              cellBuilder: (item) => showSigningStatus(item),
              width: 150,
              searchable: true,
            ),
          );
          break;
        case 'share':
          columns.add(
            TableBaseConfig.columnWidgetBase<DieuDongTaiSanDto>(
              title: 'Chia sẻ',
              width: 150,
              cellBuilder:
                  (item) => ConfigViewAT.showShareStatus(
                    item.share ?? false,
                    item.nguoiTao == userInfo?.tenDangNhap,
                  ),
            ),
          );
          break;
        case 'type':
          columns.add(
            TableBaseConfig.columnTable<DieuDongTaiSanDto>(
              title: 'Phiếu ký nội sinh',
              width: 150,
              getValue: (item) => getName(item.loai ?? 0),
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
        case 'decision_date':
          columns.add(
            TableBaseConfig.columnTable<DieuDongTaiSanDto>(
              title: 'Thời gian giao nhận từ ngày',
              width: 150,
              getValue: (item) => item.tggnTuNgay ?? '',
            ),
          );
          break;
        case 'to_date':
          columns.add(
            TableBaseConfig.columnTable<DieuDongTaiSanDto>(
              title: 'Thời gian giao nhận đến ngày',
              width: 150,
              getValue: (item) {
                if (item.tggnDenNgay == null) {
                  return '';
                }
                return item.tggnDenNgay!;
              },
            ),
          );
          break;
        case 'status':
          columns.add(
            TableBaseConfig.columnWidgetBase<DieuDongTaiSanDto>(
              title: 'Trạng thái phiếu',
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
              title: 'Thao tác',
              cellBuilder: (item) => viewAction(item),
              width: 180,
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
        child: Row(
          children: [
            Expanded(
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
                      getters: getters,
                      startDate: DateTime.tryParse(
                        widget.provider.filteredData!.isNotEmpty
                            ? widget.provider.filteredData!.first.tggnDenNgay
                                .toString()
                            : '',
                      ),
                      onRowTap: (item) {
                        widget.provider.onChangeDetailDieuDongTaiSan(item);
                        setState(() {
                          nameBenBan = 'trạng thái ký " Biên bản ${item.id} "';
                          isShowDetailDepartmentTree = true;
                          _buildDetailDepartmentTree(item);
                        });
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
              visible: selectedItems.isNotEmpty,
              child: Row(
                spacing: 8,
                children: [
                  Visibility(
                    visible:
                        selectedItems.isNotEmpty && selectedItems.length < 2,
                    child: Tooltip(
                      message: 'Ký biên bản',
                      child: InkWell(
                        onTap: () {
                          if (selectedItems.isNotEmpty) {
                            DieuDongTaiSanDto? item = selectedItems.first;

                            _handleSignDocument(
                              item,
                              userInfo!,
                              widget.provider,
                            );
                          }
                        },
                        child: Icon(Icons.edit, color: Colors.green, size: 18),
                      ),
                    ),
                  ),
                  Tooltip(
                    message: 'Chia sẻ với người ký',
                    child: InkWell(
                      onTap: () {
                        if (selectedItems.isNotEmpty) {
                          _handleSendToSigner(selectedItems);
                        }
                      },
                      child: Icon(
                        Icons.send_sharp,
                        color: Colors.blue,
                        size: 18,
                      ),
                    ),
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
        },
      ),
      ActionButtonConfig(
        icon: Icons.delete,
        tooltip: (item.trangThai == 0 || item.trangThai == 2) ? 'Xóa' : null,
        iconColor:
            (item.trangThai == 0 || item.trangThai == 2)
                ? Colors.red.shade700
                : Colors.grey,
        backgroundColor: Colors.red.shade50,
        borderColor: Colors.red.shade200,
        onPressed:
            () => {
              if (item.trangThai == 0 || item.trangThai == 2)
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
          if (item.nguoiLapPhieuKyNhay == true)
            {
              "id": item.idNguoiKyNhay,
              "signed": item.trangThaiKyNhay == true,
              "label": "Người ký nháy",
            },
          {
            "id": item.idTrinhDuyetCapPhong,
            "signed": item.trinhDuyetCapPhongXacNhan == true,
            "label": "Trình duyệt cấp phòng",
          },
          {
            "id": item.idTrinhDuyetGiamDoc,
            "signed": item.trinhDuyetGiamDocXacNhan == true,
            "label": "Giám đốc",
          },
          if (item.listSignatory != null)
            ...item.listSignatory!.map(
              (e) => {
                "id": e.idNguoiKy,
                "signed": e.trangThai == 1,
                "label": e.tenNguoiKy,
              },
            ),
        ].toList();
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

  Widget showSigningStatus(DieuDongTaiSanDto item) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 48.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color:
              widget.provider.isCheckSigningStatus(item) == 1
                  ? Colors.green
                  : widget.provider.isCheckSigningStatus(item) == 0
                  ? Colors.red
                  : Colors.blue,
          borderRadius: BorderRadius.circular(4),
        ),
        child: SGText(
          text:
              widget.provider.isCheckSigningStatus(item) == 1
                  ? 'Đã ký'
                  : widget.provider.isCheckSigningStatus(item) == 0
                  ? 'Chưa ký'
                  : "Người tạo phiếu",
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

  void _handleSendToSigner(List<DieuDongTaiSanDto> items) {
    if (items.isEmpty) {
      AppUtility.showSnackBar(
        context,
        'Không có phiếu nào để chia sẻ',
        isError: true,
      );
      return;
    }
    // bool hasNonZero = items.any(
    //   (item) => item.trangThai != 0 && item.trangThai != 2,
    // );
    // if (hasNonZero) {
    //   AppUtility.showSnackBar(
    //     context,
    //     'Có phiếu không phải ở trạng thái "Nháp", không thể chia sẻ',
    //     isError: true,
    //   );
    //   return;
    // }

    showConfirmDialog(
      context,
      type: ConfirmType.delete,
      title: 'Chia sẻ',
      message: 'Bạn có chắc muốn chia sẻ với người ký?',
      cancelText: 'Không',
      confirmText: 'Chia sẻ',
      onConfirm: () {
        context.read<DieuDongTaiSanBloc>().add(
          SendToSignerEvent(context, items),
        );
      },
    );
  }
}
