import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/table/sg_editable_table.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/movement_detail_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';

Widget assetTransferMovementTable(
  BuildContext context,
  List<MovementDetailDto> movementDetails,
  bool isEditing,
  bool isNew, {
  bool isLoading = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: const SGText(
          text: 'Chi tiết tài sản điều chuyển: ',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
        ),
      ),
      if (isLoading && !isNew)
        _buildLoadingIndicator()
      else if (movementDetails.isEmpty && !isNew)
        _buildEmptyDataMessage()
      else
        movementDetailTable(movementDetails, isEditing),
    ],
  );
}

Widget _buildLoadingIndicator() {
  return Container(
    height: 100,
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(strokeWidth: 2),
        const SizedBox(height: 10),
        SGText(text: 'Đang tải dữ liệu...', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    ),
  );
}

Widget _buildEmptyDataMessage() {
  return Container(
    height: 100,
    alignment: Alignment.center,
    child: SGText(
      text: 'Không có thông tin tài sản điều chuyển',
      style: TextStyle(fontSize: 14, color: Colors.grey[600], fontStyle: FontStyle.italic),
    ),
  );
}

Widget movementDetailTable(List<MovementDetailDto> movementDetails, bool isEditing) {
  return Container(
    decoration: BoxDecoration(
      // border: hasError ? Border.all(color: Colors.red) : null,
      borderRadius: BorderRadius.circular(4),
    ),
    padding: const EdgeInsets.only(left: 10, top: 15),
    child: SgEditableTable<MovementDetailDto>(
      initialData: movementDetails,
      createEmptyItem: MovementDetailDto.empty,
      rowHeight: 40.0,
      headerBackgroundColor: Colors.grey.shade50,
      oddRowBackgroundColor: Colors.white,
      evenRowBackgroundColor: Colors.white,
      showVerticalLines: false,
      showHorizontalLines: true,
      addRowText: 'Thêm một dòng',
      isEditing: isEditing, // Pass the editing state
      onDataChanged: (data) {},
      columns: [
        SgEditableColumn<MovementDetailDto>(
          field: 'asset',
          title: 'Tài sản',
          titleAlignment: TextAlign.center,
          width: 350,
          getValue: (item) => item.tenTaiSan,
          setValue: (item, value) => MovementDetailDto.copy(item, tenTaiSan: value),
          sortValueGetter: (item) => item.tenTaiSan,
        ),
        SgEditableColumn<MovementDetailDto>(
          field: 'unit',
          title: 'Đơn vị tính',
          titleAlignment: TextAlign.center,
          width: 130,
          getValue: (item) => item.donViTinh,
          setValue: (item, value) => MovementDetailDto.copy(item, donViTinh: value),
          sortValueGetter: (item) => item.donViTinh,
        ),
        SgEditableColumn<MovementDetailDto>(
          field: 'quantity',
          title: 'Số lượng',
          titleAlignment: TextAlign.center,
          width: 120,
          getValue: (item) => item.soLuong,
          setValue: (item, value) => MovementDetailDto.copy(item, soLuong: int.tryParse(value?.toString() ?? '0')),
          sortValueGetter: (item) => item.soLuong ?? 0,
        ),
        SgEditableColumn<MovementDetailDto>(
          field: 'condition',
          title: 'Tình trạng kỹ thuật',
          titleAlignment: TextAlign.center,
          width: 190,
          getValue: (item) => item.hienTrang,
          setValue: (item, value) => MovementDetailDto.copy(item, hienTrang: value),
          sortValueGetter: (item) => item.hienTrang,
        ),
        SgEditableColumn<MovementDetailDto>(
          field: 'note',
          title: 'Ghi chú',
          titleAlignment: TextAlign.center,
          width: 150,
          getValue: (item) => item.ghiChu,
          setValue: (item, value) => MovementDetailDto.copy(item, ghiChu: value),
          sortValueGetter: (item) => item.ghiChu,
        ),
      ],
    ),
  );
}
