import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/table/sg_editable_table.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';

class TableAssetMovementDetail extends StatefulWidget {
  final List<ChiTietDieuDongTaiSan>? listDetailAssetMobilization;
  const TableAssetMovementDetail({super.key, this.listDetailAssetMobilization});

  @override
  State<TableAssetMovementDetail> createState() => _TableAssetMovementDetailState();
}

class _TableAssetMovementDetailState extends State<TableAssetMovementDetail> {
  final ScrollController _scrollController = ScrollController();
  bool isExpanded = true;
  String getHienTrang(int hienTrang) {
    switch (hienTrang) {
      case 0:
        return 'Đang sử dụng';
      case 1:
        return 'Chờ sử lý';
      case 2:
        return 'Không sử dụng';
      case 3:
        return 'Hỏng';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Chi tiết tài sản điều chuyển',
                  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
                ),
                const Spacer(),
                Text(isExpanded ? 'Thu gọn' : 'Mở rộng', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
            AnimatedCrossFade(
              firstChild: SizedBox.shrink(),
              secondChild: Scrollbar(
                controller: _scrollController,
                interactive: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: SgEditableTable<ChiTietDieuDongTaiSan>(
                    initialData: widget.listDetailAssetMobilization ?? [],
                    createEmptyItem: ChiTietDieuDongTaiSan.empty,
                    rowHeight: 40.0,
                    headerBackgroundColor: Colors.grey.shade50,
                    oddRowBackgroundColor: Colors.white,
                    evenRowBackgroundColor: Colors.white,
                    showVerticalLines: false,
                    showHorizontalLines: true,
                    addRowText: 'Thêm một dòng',
                    isEditing: false, // Pass the editing state
                    onDataChanged: (data) {
                      log('Asset movement data changed: ${data.length} items');
                    },
                    columns: [
                      SgEditableColumn<ChiTietDieuDongTaiSan>(
                        field: 'asset',
                        title: 'Tên tài sản',
                        titleAlignment: TextAlign.center,
                        width: 120,
                        getValue: (item) => item.tenTaiSan,
                        setValue: (item, value) {},
                        sortValueGetter: (item) => item.tenTaiSan,
                      ),
                      SgEditableColumn<ChiTietDieuDongTaiSan>(
                        field: 'unit',
                        title: 'Đơn vị tính',
                        titleAlignment: TextAlign.center,
                        width: 100,
                        getValue: (item) => item.donViTinh,
                        setValue: (item, value) {},
                        sortValueGetter: (item) => item.donViTinh,
                      ),
                      SgEditableColumn<ChiTietDieuDongTaiSan>(
                        field: 'quantity',
                        title: 'Số lượng',
                        titleAlignment: TextAlign.center,
                        width: 100,
                        getValue: (item) => item.soLuong,
                        setValue: (item, value) {},
                        sortValueGetter: (item) => item.soLuong,
                      ),
                      SgEditableColumn<ChiTietDieuDongTaiSan>(
                        field: 'condition',
                        title: 'Tình trạng kỹ thuật',
                        titleAlignment: TextAlign.center,
                        width: 150,
                        getValue: (item) => getHienTrang(item.hienTrang),
                        setValue: (item, value) {},
                        sortValueGetter: (item) => getHienTrang(item.hienTrang),
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
                ),
              ),
              crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }
}
