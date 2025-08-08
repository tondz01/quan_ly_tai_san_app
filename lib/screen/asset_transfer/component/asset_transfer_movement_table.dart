import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/table/sg_editable_table.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/movement_detail_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';

Widget assetTransferMovementTable(
  BuildContext context,
  List<MovementDetailDto> movementDetails,
  bool isEditing,
) {
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
      movementDetailTable(movementDetails, isEditing),
    ],
  );
}

Widget movementDetailTable(
  List<MovementDetailDto> movementDetails,
  bool isEditing,
) {
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
          getValue: (item) => item.name,
          setValue: (item, value) => item.name = value,
          sortValueGetter: (item) => item.name,
          isCellEditableDecider: (item, rowIndex) => false,
        ),
        SgEditableColumn<MovementDetailDto>(
          field: 'unit',
          title: 'Đơn vị tính',
          titleAlignment: TextAlign.center,
          width: 130,
          getValue: (item) => item.measurementUnit,
          setValue: (item, value) => item.measurementUnit = value,
          sortValueGetter: (item) => item.measurementUnit,
        ),
        SgEditableColumn<MovementDetailDto>(
          field: 'quantity',
          title: 'Số lượng',
          titleAlignment: TextAlign.center,
          width: 120,
          getValue: (item) => item.quantity,
          setValue: (item, value) => item.quantity = value,
          sortValueGetter: (item) => int.tryParse(item.quantity ?? '0') ?? 0,
        ),
        SgEditableColumn<MovementDetailDto>(
          field: 'condition',
          title: 'Tình trạng kỹ thuật',
          titleAlignment: TextAlign.center,
          width: 190,
          getValue: (item) => item.setCondition,
          setValue: (item, value) => item.setCondition = value,
          sortValueGetter: (item) => item.setCondition,
        ),
        SgEditableColumn<MovementDetailDto>(
          field: 'note',
          title: 'Ghi chú',
          titleAlignment: TextAlign.center,
          width: 150,
          getValue: (item) => item.note,
          setValue: (item, value) => item.note = value,
          sortValueGetter: (item) => item.note,
        ),
      ],
    ),
  );
}
