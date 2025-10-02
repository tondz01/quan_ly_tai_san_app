// ignore_for_file: deprecated_member_use

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
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/dieu_dong_tai_san_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/dieu_dong_tai_san_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/config_view_asset_transfer.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/bloc/tool_and_material_transfer_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/bloc/tool_and_material_transfer_event.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/bloc/tool_and_material_transfer_state.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/component/preview_document_tool_and_meterial_transfer.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/component/row_find_by_status_ccdc.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/provider/tool_and_material_transfer_provider.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/component/department_tree_demo.dart';
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

  UserInfoDTO? userInfo;

  final List<ToolAndMaterialTransferDto> listAssetHandover = [];
  List<ToolAndMaterialTransferDto> listItemSelected = [];
  PdfDocument? _document;
  List<ThreadNode> listSignatoryDetail = [];
  ToolAndMaterialTransferDto? selected;

  bool isShowDetailDepartmentTree = false;
  String nameBenBan = "";

  // Column display options
  late List<ColumnDisplayOption> columnOptions;
  List<String> visibleColumnIds = [
    'permission_signing',
    'status_document',
    'signing_status',
    'share',
    'type',
    'effective_date',
    'approver',
    'document',
    'id',
    'decision_date',
    'to_date',
    'don_vi_giao',
    'don_vi_nhan',
    'status',
    'actions',
  ];

  List<Map<String, DateTime Function(ToolAndMaterialTransferDto)>> getters = [
    {
      'Thời gian giao nhận từ ngày':
          (item) => DateTime.tryParse(item.tggnTuNgay ?? '') ?? DateTime.now(),
    },
    {
      'Thời gian giao nhận đến ngày':
          (item) => DateTime.tryParse(item.tggnDenNgay ?? '') ?? DateTime.now(),
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeColumnOptions();
    _callGetListAssetHandover();
    userInfo = widget.provider.userInfo;
  }

  @override
  void didUpdateWidget(covariant ToolAndMaterialTransferList oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      if (selected != null && widget.provider.dataPage != null) {
        selected = widget.provider.dataPage?.firstWhere(
          (element) => element.id == selected?.id,
          orElse: () => ToolAndMaterialTransferDto(),
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
        id: 'permission_signing',
        label: 'Quyền ký',
        isChecked: visibleColumnIds.contains('permission_signing'),
      ),
      ColumnDisplayOption(
        id: 'status_document',
        label: 'Trạng thái phiếu',
        isChecked: visibleColumnIds.contains('status_document'),
      ),
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
        id: 'don_vi_giao',
        label: 'Đơn vị giao',
        isChecked: visibleColumnIds.contains('don_vi_giao'),
      ),
      ColumnDisplayOption(
        id: 'don_vi_nhan',
        label: 'Đơn vị nhận',
        isChecked: visibleColumnIds.contains('don_vi_nhan'),
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
  }

  List<SgTableColumn<ToolAndMaterialTransferDto>> _buildColumns() {
    final List<SgTableColumn<ToolAndMaterialTransferDto>> columns = [];

    // Thêm cột dựa trên visibleColumnIds
    for (String columnId in visibleColumnIds) {
      switch (columnId) {
        case 'permission_signing':
          columns.add(
            TableBaseConfig.columnWidgetBase<ToolAndMaterialTransferDto>(
              title: 'Quyền ký',
              cellBuilder:
                  (item) => AppUtility.showPermissionSigning(
                    getPermissionSigning(item),
                  ),
              width: 150,
              searchValueGetter: (item) {
                final status = getPermissionSigning(item);
                return status == 2
                    ? 'Không được phép ký'
                    : status == 1
                    ? 'Chưa đến lượt ký'
                    : status == 3
                    ? 'Đã ký'
                    : 'Cần ký';
              },
              searchable: true,
              filterable: true,
            ),
          );
          break;
        case 'status_document':
          columns.add(
            TableBaseConfig.columnWidgetBase<ToolAndMaterialTransferDto>(
              title: 'Trạng thái phiếu',
              cellBuilder:
                  (item) =>
                      AppUtility.showStatusDocument(item.trangThaiPhieu ?? 0),
              width: 150,
              searchValueGetter: (item) {
                final status = item.trangThaiPhieu ?? 0;
                return status == 0
                    ? 'Chưa hoàn thành'
                    : status == 1
                    ? 'Sắp hết hạn'
                    : status == 2
                    ? 'Đã hoàn thành'
                    : 'Không xác đinh';
              },
              searchable: true,
              filterable: true,
            ),
          );
          break;
        case 'signing_status':
          columns.add(
            TableBaseConfig.columnWidgetBase<ToolAndMaterialTransferDto>(
              title: 'Trạng thái ký',
              cellBuilder: (item) => showSigningStatus(item),
              width: 150,
              searchValueGetter: (item) {
                final status = widget.provider.isCheckSigningStatus(item);
                return status == 1
                    ? 'Đã ký'
                    : status == 0
                    ? 'Chưa ký'
                    : status == 2
                    ? 'Đã ký nháy'
                    : status == 3
                    ? 'Đã ký & tạo'
                    : status == 4
                    ? 'Chưa ký nháy'
                    : status == 5
                    ? 'Chưa ký & tạo'
                    : 'Người tạo phiếu';
              },
              searchable: true,
              filterable: true,
            ),
          );
          break;
        case 'share':
          columns.add(
            TableBaseConfig.columnWidgetBase<ToolAndMaterialTransferDto>(
              title: 'Chia sẻ',
              width: 150,
              cellBuilder:
                  (item) => ConfigViewAT.showShareStatus(
                    item.share ?? false,
                    item.nguoiTao == userInfo?.tenDangNhap,
                  ),
              searchValueGetter: (item) {
                return item.share == true ? 'Đã chia sẻ' : 'Chưa chia sẻ';
              },
              filterable: true,
            ),
          );
          break;
        case 'type':
          columns.add(
            TableBaseConfig.columnTable<ToolAndMaterialTransferDto>(
              title: 'Phiếu ký nội sinh',
              width: 150,
              getValue: (item) => getName(item.loai ?? 0),
              filterable: true,
            ),
          );
          break;
        case 'effective_date':
          columns.add(
            TableBaseConfig.columnTable<ToolAndMaterialTransferDto>(
              title: 'Ngày có hiệu lực',
              width: 100,
              getValue: (item) => item.tggnTuNgay ?? '',
             filterable: true,
            ),
          );
          break;
        case 'approver':
          columns.add(
            TableBaseConfig.columnTable<ToolAndMaterialTransferDto>(
              title: 'Trình duyệt ban giám đốc',
              width: 150,
              getValue: (item) => item.tenTrinhDuyetGiamDoc ?? '',
              filterable: true,
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
              filterable: true,
            ),
          );
          break;
        case 'id':
          columns.add(
            TableBaseConfig.columnTable<ToolAndMaterialTransferDto>(
              title: 'Ký số',
              width: 120,
              getValue: (item) => item.id ?? '',
              filterable: true,
            ),
          );
          break;
        case 'decision_date':
          columns.add(
            TableBaseConfig.columnTable<ToolAndMaterialTransferDto>(
              title: 'Thời gian giao nhận từ ngày',
              width: 150,
              getValue: (item) => item.tggnTuNgay ?? '',
              filterable: true,
            ),
          );
          break;
        case 'to_date':
          columns.add(
            TableBaseConfig.columnTable<ToolAndMaterialTransferDto>(
              title: 'Thời gian giao nhận đến ngày',
              width: 150,
              getValue: (item) {
                if (item.tggnDenNgay == null) {
                  return '';
                }
                return item.tggnDenNgay!;
              },
              filterable: true,
            ),
          );
          break;
        case 'don_vi_giao':
          columns.add(
            TableBaseConfig.columnTable<ToolAndMaterialTransferDto>(
              title: 'Đơn vị giao',
              width: 150,
              getValue:
                  (item) =>
                      AccountHelper.instance
                          .getDepartmentById(item.idDonViGiao ?? '')
                          ?.tenPhongBan ??
                      '',
              filterable: true,
            ),
          );
          break;
        case 'don_vi_nhan':
          columns.add(
            TableBaseConfig.columnTable<ToolAndMaterialTransferDto>(
              title: 'Đơn vị nhận',
              width: 150,
              getValue:
                  (item) =>
                      AccountHelper.instance
                          .getDepartmentById(item.idDonViNhan ?? '')
                          ?.tenPhongBan ??
                      '',
              filterable: true,
            ),
          );
          break;
        case 'status':
          columns.add(
            TableBaseConfig.columnWidgetBase<ToolAndMaterialTransferDto>(
              title: 'Trạng thái phiếu',
              cellBuilder:
                  (item) => ConfigViewAT.showStatus(item.trangThai ?? 0),
              width: 150,
              searchable: true,
              filterable: true,
            ),
          );
          break;
        case 'actions':
          columns.add(
            TableBaseConfig.columnWidgetBase<ToolAndMaterialTransferDto>(
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
    final List<SgTableColumn<ToolAndMaterialTransferDto>> columns =
        _buildColumns();
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
                    child: TableBaseView<ToolAndMaterialTransferDto>(
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
                        widget.provider.onChangeDetailToolAndMaterialTransfer(
                          item,
                        );

                        setState(() {
                          nameBenBan = 'trạng thái ký " Biên bản ${item.id} "';
                          isShowDetailDepartmentTree = true;
                          _buildDetailDepartmentTree(item);
                        });
                      },
                      onSelectionChanged: (items) {
                        setState(() {
                          listItemSelected = items;
                        });
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
            _buildActionKy(),
          ],
        ),
        Expanded(child: RowFindByStatusCcdc(provider: widget.provider)),
      ],
    );
  }

  Visibility _buildActionKy() {
    return Visibility(
      visible: listItemSelected.isNotEmpty,
      child: Row(
        spacing: 8,
        children: [
          Visibility(
            visible:
                listItemSelected.isNotEmpty &&
                listItemSelected.length < 2 &&
                getPermissionSigning(listItemSelected.first) == 0,
            child: Tooltip(
              message: 'Ký biên bản',
              child: InkWell(
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
                child: Icon(Icons.edit, color: Colors.green, size: 18),
              ),
            ),
          ),
          Tooltip(
            message: 'Chia sẻ với người ký',
            child: InkWell(
              onTap: () {
                if (listItemSelected.isNotEmpty) {
                  _handleSendToSigner(listItemSelected);
                }
              },
              child: Icon(Icons.send_sharp, color: Colors.blue, size: 18),
            ),
          ),
          SGText(
            text: 'Số lượng biên bản đã chọn: ${listItemSelected.length}',
            color: Colors.blue,
            size: 14,
            fontWeight: FontWeight.w500,
          ),
        ],
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
          _loadPdfNetwork(item.tenFile!).then((_) {
            if (mounted) {
              previewDocumentToolAndMaterial(
                context: context,
                item: item,
                nhanVien: widget.provider.getNhanVienByID(
                  widget.provider.userInfo?.tenDangNhap ?? '',
                ),
                document: _document,
                isShowKy: false,
              );
            }
          });
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
                      context.read<ToolAndMaterialTransferBloc>().add(
                        DeleteToolAndMaterialTransferEvent(context, item.id!),
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
        return 'Phiếu duyệt cấp phát CCDC - Vật tư';
      case 2:
        return 'Phiếu duyệt chuyển CCDC - Vật tư';
      case 3:
        return 'Phiếu duyệt thu hồi CCDC - Vật tư';
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
              if (item.nguoiLapPhieuKyNhay == true)
                {
                  "id": item.idNguoiKyNhay,
                  "signed": item.trangThaiKyNhay == true,
                  "label":
                      "Người lập phiếu: ${AccountHelper.instance.getNhanVienById(item.idNguoiKyNhay ?? '')?.hoTen}",
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

    _loadPdfNetwork(item.tenFile!).then((_) {
      if (mounted) {
        previewDocumentToolAndMaterial(
          context: context,
          item: item,
          nhanVien: widget.provider.getNhanVienByID(
            widget.provider.userInfo?.tenDangNhap ?? '',
          ),
          document: _document,
        );
      }
    });
  }

  Widget showSigningStatus(ToolAndMaterialTransferDto item) {
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
                  : widget.provider.isCheckSigningStatus(item) == 2
                  ? Colors.green
                  : widget.provider.isCheckSigningStatus(item) == 3
                  ? Colors.green
                  : widget.provider.isCheckSigningStatus(item) == 4
                  ? Colors.orange
                  : widget.provider.isCheckSigningStatus(item) == 5
                  ? Colors.purple
                  : Colors.blue,
          borderRadius: BorderRadius.circular(4),
        ),
        child: SGText(
          text:
              widget.provider.isCheckSigningStatus(item) == 1
                  ? 'Đã ký'
                  : widget.provider.isCheckSigningStatus(item) == 0
                  ? 'Chưa ký'
                  : widget.provider.isCheckSigningStatus(item) == 2
                  ? 'Đã ký nháy'
                  : widget.provider.isCheckSigningStatus(item) == 3
                  ? 'Đã ký & tạo'
                  : widget.provider.isCheckSigningStatus(item) == 4
                  ? 'Chưa ký nháy'
                  : widget.provider.isCheckSigningStatus(item) == 5
                  ? 'Chưa ký & tạo'
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

  void _buildDetailDepartmentTree(ToolAndMaterialTransferDto item) {
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
      ThreadNode(header: 'Chi tiết bàn giao', depth: 0),
      if (widget.provider.listSignatoryDetail.isNotEmpty)
        ...widget.provider.listSignatoryDetail,
    ];
  }

  Widget viewSignatoryStatus(bool isDone, String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.green,
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

  List<ToolAndMaterialTransferDto> _getNotSharedAndNotify(
    List<ToolAndMaterialTransferDto> items,
  ) {
    if (items.isEmpty) {
      AppUtility.showSnackBar(
        context,
        'Không có phiếu nào để chia sẻ',
        isError: true,
      );
      return const [];
    }

    final List<ToolAndMaterialTransferDto> alreadyShared =
        items.where((e) => e.share == true).toList();
    final List<ToolAndMaterialTransferDto> notShared =
        items.where((e) => e.share != true).toList();
    if (notShared.isEmpty) {
      AppUtility.showSnackBar(
        context,
        'Các phiếu này đều đã được chia sẻ',
        isError: true,
      );
      return const [];
    }
    if (alreadyShared.isNotEmpty) {
      final String names = alreadyShared
          .map(
            (e) =>
                e.tenPhieu?.trim().isNotEmpty == true
                    ? e.tenPhieu!
                    : (e.id ?? ''),
          )
          .where((s) => s.isNotEmpty)
          .join(', ');
      if (names.isNotEmpty) {
        AppUtility.showSnackBar(
          context,
          'Các phiếu đã được chia sẻ: $names',
          isError: true,
        );
      } else {
        AppUtility.showSnackBar(
          context,
          'Có phiếu đã được chia sẻ trong danh sách chọn',
          isError: true,
        );
      }
    }
    return notShared;
  }

  void _handleSendToSigner(List<ToolAndMaterialTransferDto> items) {
    if (items.isEmpty) {
      AppUtility.showSnackBar(
        context,
        'Không có phiếu nào để chia sẻ',
        isError: true,
      );
      return;
    }

    showConfirmDialog(
      context,
      type: ConfirmType.delete,
      title: 'Chia sẻ',
      message: 'Bạn có chắc muốn chia sẻ với người ký?',
      cancelText: 'Không',
      confirmText: 'Chia sẻ',
      onConfirm: () {
        final notShared = _getNotSharedAndNotify(items);
        if (notShared.isEmpty) return;
        context.read<ToolAndMaterialTransferBloc>().add(
          SendToSignerTAMTEvent(context, items),
        );
      },
    );
  }

  // Implement check permission signing
  int getPermissionSigning(ToolAndMaterialTransferDto item) {
    final signatureFlow =
        [
              if (item.nguoiLapPhieuKyNhay == true)
                {
                  "id": item.idNguoiKyNhay,
                  "signed": item.trangThaiKyNhay == true,
                  "label":
                      "Người lập phiếu: ${AccountHelper.instance.getNhanVienById(item.idNguoiKyNhay ?? '')?.hoTen}",
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
    final currentIndex = signatureFlow.indexWhere(
      (s) => s["id"] == userInfo?.tenDangNhap,
    );
    if (currentIndex == -1) return 2;
    if (signatureFlow[currentIndex]["signed"] == true) return 3;
    final previousNotSigned = signatureFlow
        .take(currentIndex)
        .firstWhere((s) => s["signed"] == false, orElse: () => {});
    if (previousNotSigned.isNotEmpty) return 1;
    return 0;
  }
}
