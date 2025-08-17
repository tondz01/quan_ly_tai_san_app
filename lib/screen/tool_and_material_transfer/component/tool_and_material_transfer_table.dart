import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/table/sg_editable_table.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/detail_tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';

import '../repository/detail_tool_and_material_transfer_repository.dart';

class DetailToolAndMaterialTransferTable extends StatefulWidget {
  final bool isEditing;
  final List<DetailToolAndMaterialTransferDto> initialDetails;
  final List<ToolsAndSuppliesDto> allAssets;
  final Function(List<ToolsAndSuppliesDto>)? onDataChanged;

  const DetailToolAndMaterialTransferTable(
    BuildContext context, {
    super.key,
    required this.isEditing,
    required this.initialDetails,
    required this.allAssets,
    required this.onDataChanged,
  });

  @override
  State<DetailToolAndMaterialTransferTable> createState() =>
      _DetailToolAndMaterialTransferTableState();
}

class _DetailToolAndMaterialTransferTableState
    extends State<DetailToolAndMaterialTransferTable> {
  late List<DetailToolAndMaterialTransferDto> movementDetails;
  final repo = DetailToolAndMaterialTransferRepository();

  @override
  void initState() {
    super.initState();
    movementDetails = List.from(widget.initialDetails);
    log('message initialDetails: ${jsonEncode(movementDetails)}');
  }

  @override
  void didUpdateWidget(DetailToolAndMaterialTransferTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    movementDetails = List.from(widget.initialDetails);
    log(
      'message didUpdateWidget initialDetails: ${jsonEncode(movementDetails)}',
    );
  }

  List<ToolsAndSuppliesDto> getAssetsByChildAssets(
    List<ToolsAndSuppliesDto> allAssets,
    List<DetailToolAndMaterialTransferDto> chiTietDieuDong,
  ) {
    // Map nhanh id -> Asset
    final Map<String, ToolsAndSuppliesDto> idToAsset = {
      for (final a in allAssets) a.id: a,
    };
    log('message idToAsset: ${jsonEncode(idToAsset)}');

    // Duyệt theo thứ tự child, loại trùng idTaiSan
    final result = <ToolsAndSuppliesDto>[];
    final seen = <String>{};
    for (final c in chiTietDieuDong) {
      final id = c.idCCDCVatTu;
      if (seen.add(id)) {
        final asset = idToAsset[id];
        asset?.copyWith(soLuongXuat: c.soLuongXuat);
        if (asset != null) result.add(asset);
      }
    }
    log('result getAssetsByChildAssets: ${jsonEncode(result)}');
    return result;
  }

  @override
  Widget build(BuildContext context) {
    log('movementDetails: ${movementDetails.length}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: const SGText(
            text: 'Chi tiết Ccdc - vật tư điều chuyển:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
        ),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.only(left: 10, top: 15),
          child: SgEditableTable<ToolsAndSuppliesDto>(
            initialData: getAssetsByChildAssets(
              widget.allAssets,
              movementDetails,
            ),
            createEmptyItem: ToolsAndSuppliesDto.empty,
            rowHeight: 40.0,
            headerBackgroundColor: Colors.grey.shade50,
            oddRowBackgroundColor: Colors.white,
            evenRowBackgroundColor: Colors.white,
            showVerticalLines: false,
            showHorizontalLines: true,
            addRowText: 'Thêm một dòng',
            isEditing: widget.isEditing, // Pass the editing state
            omittedSize: 130,
            onDataChanged: widget.onDataChanged,
            columns: [
              SgEditableColumn<ToolsAndSuppliesDto>(
                field: 'asset',
                title: 'CCDC Vật tư',
                titleAlignment: TextAlign.center,
                width: 120,
                getValue: (item) => item,
                setValue: (item, value) {
                  item.id = value.id;
                  item.ten = '${value.id} - ${value.ten}';
                  item.idDonVi = value.idDonVi;
                },
                sortValueGetter: (item) => item.toJson(),
                isCellEditableDecider: (item, rowIndex) => true,
                editor: EditableCellEditor.dropdown,
                dropdownItems: [
                  for (var element in widget.allAssets)
                    DropdownMenuItem<ToolsAndSuppliesDto>(
                      value: element,
                      child: Text('${element.id} - ${element.ten}'),
                    ),
                ],
                onValueChanged: (item, rowIndex, newValue, updateRow) {
                  updateRow('don_vi_tinh', newValue.donViTinh);
                  updateRow('so_luong', newValue.soLuong);
                  updateRow('ghi_chu', newValue.ghiChu);
                },
              ),
              SgEditableColumn<ToolsAndSuppliesDto>(
                field: 'don_vi_tinh',
                title: 'Đơn vị tính',
                titleAlignment: TextAlign.center,
                width: 100,
                getValue: (item) => item.donViTinh,
                setValue: (item, value) => item.donViTinh = value as String,
                sortValueGetter: (item) => item.donViTinh,
                isEditable: false,
              ),
              SgEditableColumn<ToolsAndSuppliesDto>(
                field: 'so_luong',
                title: 'Số lượng',
                titleAlignment: TextAlign.center,
                width: 100,
                getValue: (item) => item.soLuong,
                setValue: (item, value) {
                  item.soLuong = value;
                },
                sortValueGetter: (item) => item.soLuong,
                isEditable: false,
              ),
              SgEditableColumn<ToolsAndSuppliesDto>(
                field: 'so_luong_xuat',
                title: 'Số lượng xuất',
                titleAlignment: TextAlign.center,
                width: 100,
                getValue: (item) => item.soLuongXuat,
                inputType: TextInputType.number,
                setValue: (item, value) {
                  item.soLuongXuat = int.parse(value);
                  log('message soLuongXuat: $value');
                },
                sortValueGetter: (item) => item.soLuongXuat,
                isEditable: widget.isEditing,
              ),
              SgEditableColumn<ToolsAndSuppliesDto>(
                field: 'ghi_chu',
                title: 'Ghi chú',
                titleAlignment: TextAlign.center,
                width: 100,
                getValue: (item) => item.ghiChu,
                setValue: (item, value) => item.ghiChu = value,
                sortValueGetter: (item) => item.ghiChu,
                isEditable: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String getHienTrang(int hienTrang) {
    log('hienTrang: $hienTrang');
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
}
