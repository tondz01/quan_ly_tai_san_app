import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/table/sg_editable_table.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/detai_asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';

class TableAssetMovementDetail extends StatefulWidget {
  final List<ChiTietDieuDongTaiSan>? listDetailAssetMobilization;
  final List<DetailAssetHandoverDto>? listDetailAssetHandover;
  final bool isDetail;
  final bool isEditing;
  final Function(List<ChiTietDieuDongTaiSan>)? onDataChanged;
  const TableAssetMovementDetail({
    super.key,
    this.listDetailAssetMobilization,
    this.listDetailAssetHandover,
    this.isEditing = false,
    this.isDetail = false,
    this.onDataChanged,
  });

  @override
  State<TableAssetMovementDetail> createState() =>
      _TableAssetMovementDetailState();
}

class _TableAssetMovementDetailState extends State<TableAssetMovementDetail> {
  List<DropdownMenuItem<ChiTietDieuDongTaiSan>> items = [];
  List<ChiTietDieuDongTaiSan> listDetailAssetMobilization = [];
  bool isExpanded = true;

  @override
  void initState() {
    super.initState();
    _syncDetailAssets();
  }

  @override
  void didUpdateWidget(covariant TableAssetMovementDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.listDetailAssetHandover != oldWidget.listDetailAssetHandover ||
        widget.listDetailAssetMobilization !=
            oldWidget.listDetailAssetMobilization) {
      _syncDetailAssets();
    }
  }

  void _syncDetailAssets() {
    List<ChiTietDieuDongTaiSan> list = [];
    items = [
      ...widget.listDetailAssetMobilization
              ?.map(
                (e) => DropdownMenuItem<ChiTietDieuDongTaiSan>(
                  value: e,
                  child: Text(e.tenTaiSan),
                ),
              )
              .toList() ??
          [],
    ];
    for (final d in widget.listDetailAssetHandover ?? []) {
      ChiTietDieuDongTaiSan chiTietDieuDongTaiSan =
          widget.listDetailAssetMobilization?.firstWhere(
            (e) => e.idTaiSan == d.idTaiSan,
            orElse: () => ChiTietDieuDongTaiSan.empty(),
          ) ??
          ChiTietDieuDongTaiSan.empty();
      list.add(chiTietDieuDongTaiSan);
    }
    if (widget.isDetail) {
      listDetailAssetMobilization = list;
    } else {
      listDetailAssetMobilization = widget.listDetailAssetMobilization ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                'Chi tiết tài sản điều chuyển',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Text(
                  isExpanded ? 'Thu gọn' : 'Mở rộng',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: isExpanded ? Colors.grey[600] : Colors.green,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedCrossFade(
            firstChild: SizedBox.shrink(),
            secondChild: SgEditableTable<ChiTietDieuDongTaiSan>(
              initialData: listDetailAssetMobilization,
              createEmptyItem: ChiTietDieuDongTaiSan.empty,
              rowHeight: 40.0,
              headerBackgroundColor: Colors.grey.shade50,
              oddRowBackgroundColor: Colors.white,
              evenRowBackgroundColor: Colors.white,
              showVerticalLines: false,
              showHorizontalLines: true,
              addRowText: 'Thêm một dòng',
              isEditing: widget.isEditing, // Pass the editing state
              subtractedSize: 150,
              onDataChanged: (data) {
                widget.onDataChanged?.call(data);
              },
              columns: [
                SgEditableColumn<ChiTietDieuDongTaiSan>(
                  field: 'asset',
                  title: 'Tên tài sản',
                  titleAlignment: TextAlign.center,
                  width: 120,
                  getValue: (item) => item,
                  setValue: (item, value) {
                    item.idDieuDongTaiSan = value.tenTaiSan ?? '';
                    item.soQuyetDinh = value.soQuyetDinh ?? '';
                    item.tenPhieu = value.tenPhieu ?? '';
                    item.idTaiSan = value.idTaiSan ?? '';
                    item.tenTaiSan = value.tenTaiSan ?? '';
                    item.donViTinh = value.donViTinh;
                    item.hienTrang = value.hienTrang ?? 0;
                    item.soLuong = value.soLuong ?? 0;
                    item.ghiChu = value.ghiChu ?? '';
                  },
                  sortValueGetter: (item) => item.tenTaiSan,
                  editor: EditableCellEditor.dropdown,
                  dropdownItems: items,
                ),
                SgEditableColumn<ChiTietDieuDongTaiSan>(
                  field: 'unit',
                  title: 'Đơn vị tính',
                  titleAlignment: TextAlign.center,
                  width: 50,
                  getValue: (item) => item.donViTinh,
                  setValue: (item, value) {},
                  sortValueGetter: (item) => item.donViTinh,
                  isEditable: false,
                ),
                SgEditableColumn<ChiTietDieuDongTaiSan>(
                  field: 'quantity',
                  title: 'Số lượng',
                  titleAlignment: TextAlign.center,
                  width: 50,
                  getValue: (item) => item.soLuong,
                  setValue: (item, value) {},
                  sortValueGetter: (item) => item.soLuong,
                  isEditable: false,
                ),
                SgEditableColumn<ChiTietDieuDongTaiSan>(
                  field: 'condition',
                  title: 'Tình trạng kỹ thuật',
                  titleAlignment: TextAlign.center,
                  isEditable: false,
                  width: 50,
                  getValue: (item) => AppUtility.getHienTrang(item.hienTrang),
                  setValue: (item, value) {},
                  sortValueGetter:
                      (item) => AppUtility.getHienTrang(item.hienTrang),
                ),
                SgEditableColumn<ChiTietDieuDongTaiSan>(
                  field: 'node',
                  title: 'Ghi chú',
                  titleAlignment: TextAlign.center,
                  width: 100,
                  getValue: (item) => item.ghiChu,
                  setValue: (item, value) {},
                  sortValueGetter: (item) => item.ghiChu,
                  isEditable: false,
                ),
              ],
            ),
            crossFadeState:
                isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
