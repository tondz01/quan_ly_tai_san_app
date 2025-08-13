import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/table/sg_editable_table.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/movement_detail_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';

Widget assetTransferMovementTable(
  BuildContext context,
  List<ChiTietDieuDongTaiSan> movementDetails,
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
  List<ChiTietDieuDongTaiSan> movementDetails,
  bool isEditing,
) {
  return Container(
    decoration: BoxDecoration(
      // border: hasError ? Border.all(color: Colors.red) : null,
      borderRadius: BorderRadius.circular(4),
    ),
    padding: const EdgeInsets.only(left: 10, top: 15),
    child: SgEditableTable<ChiTietDieuDongTaiSan>(
      initialData: movementDetails,
      createEmptyItem: ChiTietDieuDongTaiSan.empty,
      rowHeight: 40.0,
      headerBackgroundColor: Colors.grey.shade50,
      oddRowBackgroundColor: Colors.white,
      evenRowBackgroundColor: Colors.white,
      showVerticalLines: false,
      showHorizontalLines: true,
      addRowText: 'Thêm một dòng',
      isEditing: isEditing,
      // Pass the editing state
      onDataChanged: (data) {},
      columns: [
        SgEditableColumn<ChiTietDieuDongTaiSan>(
          field: 'asset',
          title: 'Tài sản',
          titleAlignment: TextAlign.center,
          width: 350,
          getValue: (item) => item.tenTaiSan,
          setValue: (item, value) => item.tenTaiSan = value,
          sortValueGetter: (item) => item.tenTaiSan,
          isCellEditableDecider: (item, rowIndex) => false,
        ),
        SgEditableColumn<ChiTietDieuDongTaiSan>(
          field: 'unit',
          title: 'Đơn vị tính',
          titleAlignment: TextAlign.center,
          width: 130,
          getValue: (item) => item.donViTinh,
          setValue: (item, value) => item.donViTinh = value,
          sortValueGetter: (item) => item.donViTinh,
        ),
        SgEditableColumn<ChiTietDieuDongTaiSan>(
          field: 'quantity',
          title: 'Số lượng',
          titleAlignment: TextAlign.center,
          width: 120,
          getValue: (item) => item.soLuong,
          setValue: (item, value) => item.soLuong = value,
          sortValueGetter: (item) => int.tryParse(item.soLuong.toString()) ?? 0,
        ),
        SgEditableColumn<ChiTietDieuDongTaiSan>(
          field: 'condition',
          title: 'Tình trạng kỹ thuật',
          titleAlignment: TextAlign.center,
          width: 190,
          getValue: (item) => item.hienTrang,
          setValue: (item, value) => item.hienTrang = value,
          sortValueGetter: (item) => item.hienTrang,
        ),
        SgEditableColumn<ChiTietDieuDongTaiSan>(
          field: 'note',
          title: 'Ghi chú',
          titleAlignment: TextAlign.center,
          width: 150,
          getValue: (item) => item.ghiChu,
          setValue: (item, value) => item.ghiChu = value,
          sortValueGetter: (item) => item.ghiChu,
        ),
      ],
    ),
  );
}
