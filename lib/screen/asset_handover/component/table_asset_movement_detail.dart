import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/table/sg_editable_table.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/chi_tiet_dieu_dong_tai_san.dart';

class TableAssetMovementDetail extends StatefulWidget {
  final List<ChiTietDieuDongTaiSan>? item;
  const TableAssetMovementDetail({super.key, this.item});

  @override
  State<TableAssetMovementDetail> createState() => _TableAssetMovementDetailState();
}

class _TableAssetMovementDetailState extends State<TableAssetMovementDetail> {
  final ScrollController _scrollController = ScrollController();
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
          log('isExpanded: $isExpanded');
        });
        // Gọi callback nếu có
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
                Text(
                  isExpanded ? 'Thu gọn' : 'Mở rộng',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
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
                    initialData: widget.item ?? [],
                    createEmptyItem: ChiTietDieuDongTaiSan.empty,
                    rowHeight: 40.0,
                    headerBackgroundColor: Colors.grey.shade50,
                    oddRowBackgroundColor: Colors.white,
                    evenRowBackgroundColor: Colors.white,
                    showVerticalLines: false,
                    showHorizontalLines: true,
                    addRowText: 'Thêm một dòng',
                    isEditing: false, // Pass the editing state
                    rowEditableDecider: (item, index) => item.soLuong != null,
                    onDataChanged: (data) {
                      log('Asset movement data changed: ${data.length} items');
                    },
                    columns: [
                      SgEditableColumn<ChiTietDieuDongTaiSan>(
                        field: 'asset',
                        title: 'Tài sản',
                        titleAlignment: TextAlign.center,
                        width: 250,
                        getValue: (item) => item.tenTaiSan,
                        setValue: (item, value) => item.tenTaiSan = value,
                        sortValueGetter: (item) => item.tenTaiSan,
                      ),
                      SgEditableColumn<ChiTietDieuDongTaiSan>(
                        field: 'unit',
                        title: 'Đơn vị tính',
                        titleAlignment: TextAlign.center,
                        width: 100,
                        getValue: (item) => item.donViTinh,
                        setValue: (item, value) => item.donViTinh = value,
                        sortValueGetter: (item) => item.donViTinh,
                      ),
                      SgEditableColumn<ChiTietDieuDongTaiSan>(
                        field: 'quantity',
                        title: 'Số lượng',
                        titleAlignment: TextAlign.center,
                        width: 100,
                        getValue: (item) => item.soLuong,
                        setValue: (item, value) => item.soLuong = value,
                        sortValueGetter:
                            (item) => int.tryParse(item.soLuong.toString() ?? '0') ?? 0,
                      ),
                      SgEditableColumn<ChiTietDieuDongTaiSan>(
                        field: 'condition',
                        title: 'Tình trạng kỹ thuật',
                        titleAlignment: TextAlign.center,
                        width: 150,
                        getValue: (item) => item.hienTrang,
                        setValue: (item, value) => item.hienTrang = value,
                        sortValueGetter: (item) => item.hienTrang,
                      ),

                    ],
                  ),
                ),
              ),
              crossFadeState:
                  isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }
}
