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
import 'package:quan_ly_tai_san_app/main.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/asset_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/widget/asset_transfer_controll.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/dieu_dong_tai_san_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/dieu_dong_tai_san_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/config_view_asset_transfer.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/preview_document_asset_transfer.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/property_handover_minutes.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class AssetTransferList extends StatefulWidget {
  final AssetHandoverProvider provider;
  final List<DieuDongTaiSanDto> data;

  const AssetTransferList({
    super.key,
    required this.provider,
    required this.data,
  });

  @override
  State<AssetTransferList> createState() => _AssetTransferListState();
}

class _AssetTransferListState extends State<AssetTransferList> {
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
    AssetTransferControl().initializeColumnOptions();
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
              getValue: (item) => item.tenPhieu ?? '',
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
    return Expanded(
      child: TableBaseView<DieuDongTaiSanDto>(
        searchTerm: '',
        columns: columns,
        data:
            widget.provider.dataAssetTransfer
                ?.where((item) => item.trangThai == 6)
                .toList() ??
            [],
        horizontalController: ScrollController(),
        onRowTap: (item) {
          // widget.data.onChangeDetailDieuDongTaiSan(item);
        },
        onSelectionChanged: (items) {
          setState(() {
            selectedItems = items;
          });
        },
      ),
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
          NhanVien nhanVien =
              widget.provider.dataStaff
                  ?.where((item) => item.id == userInfo?.tenDangNhap)
                  .first ??
              NhanVien();
          if (item.tenFile == null || item.tenFile!.isEmpty) {
            previewDocumentView(
              context: context,
              item: item,
              isShowKy: false,
              document: _document,
              userInfo: widget.provider.userInfo!,
              nhanVien: nhanVien,
            );
          } else {
            await _loadPdfNetwork(item.tenFile!);
            if (mounted) {
              previewDocumentView(
                context: context,
                item: item,
                isShowKy: false,
                document: _document,
                userInfo: widget.provider.userInfo!,
                nhanVien: nhanVien,
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
}
