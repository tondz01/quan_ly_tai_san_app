import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/table/sg_editable_table.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_movement_dto.dart';

class TableAssetMovementDetail extends StatefulWidget {
  final List<AssetHandoverMovementDto>? item;
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
                  child: SgEditableTable<AssetHandoverMovementDto>(
                    initialData: widget.item ?? [],
                    createEmptyItem: AssetHandoverMovementDto.empty,
                    rowHeight: 40.0,
                    headerBackgroundColor: Colors.grey.shade50,
                    oddRowBackgroundColor: Colors.white,
                    evenRowBackgroundColor: Colors.white,
                    showVerticalLines: false,
                    showHorizontalLines: true,
                    addRowText: 'Thêm một dòng',
                    isEditing: false, // Pass the editing state
                    rowEditableDecider: (item, index) => item.quantity != null,
                    onDataChanged: (data) {
                      log('Asset movement data changed: ${data.length} items');
                    },
                    columns: [
                      SgEditableColumn<AssetHandoverMovementDto>(
                        field: 'asset',
                        title: 'Tài sản',
                        titleAlignment: TextAlign.center,
                        width: 250,
                        getValue: (item) => item.name,
                        setValue: (item, value) => item.name = value,
                        sortValueGetter: (item) => item.name,
                      ),
                      SgEditableColumn<AssetHandoverMovementDto>(
                        field: 'unit',
                        title: 'Đơn vị tính',
                        titleAlignment: TextAlign.center,
                        width: 100,
                        getValue: (item) => item.measurementUnit,
                        setValue: (item, value) => item.measurementUnit = value,
                        sortValueGetter: (item) => item.measurementUnit,
                      ),
                      SgEditableColumn<AssetHandoverMovementDto>(
                        field: 'quantity',
                        title: 'Số lượng',
                        titleAlignment: TextAlign.center,
                        width: 100,
                        getValue: (item) => item.quantity,
                        setValue: (item, value) => item.quantity = value,
                        sortValueGetter:
                            (item) => int.tryParse(item.quantity ?? '0') ?? 0,
                      ),
                      SgEditableColumn<AssetHandoverMovementDto>(
                        field: 'condition',
                        title: 'Tình trạng kỹ thuật',
                        titleAlignment: TextAlign.center,
                        width: 150,
                        getValue: (item) => item.setCondition,
                        setValue: (item, value) => item.setCondition = value,
                        sortValueGetter: (item) => item.setCondition,
                      ),
                      SgEditableColumn<AssetHandoverMovementDto>(
                        field: 'countryOfOrigin',
                        title: 'Nước sản xuất',
                        titleAlignment: TextAlign.center,
                        width: 150,
                        getValue: (item) => item.countryOfOrigin,
                        setValue: (item, value) => item.countryOfOrigin = value,
                        sortValueGetter: (item) => item.countryOfOrigin,
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
