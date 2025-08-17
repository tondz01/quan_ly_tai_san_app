import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/table/sg_editable_table.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/child_assets_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';

class TableChildAssets extends StatefulWidget {
  final bool isEditing;
  final List<ChildAssetDto> initialDetails;
  final List<AssetManagementDto> allAssets;
  final Function(List<AssetManagementDto>)? onDataChanged;

  const TableChildAssets(
    BuildContext context, {
    super.key,
    required this.isEditing,
    required this.initialDetails,
    required this.allAssets,
    required this.onDataChanged,
  });

  @override
  State<TableChildAssets> createState() => _TableChildAssetsState();
}

class _TableChildAssetsState extends State<TableChildAssets> {
  late List<ChildAssetDto> movementDetails;

  @override
  void initState() {
    super.initState();
    movementDetails = List.from(widget.initialDetails);
  }

  @override
  void didUpdateWidget(TableChildAssets oldWidget) {
    super.didUpdateWidget(oldWidget);
    movementDetails = List.from(widget.initialDetails);
  }

  List<AssetManagementDto> getAssetsByChildAssets(
    List<AssetManagementDto> allAssets,
    List<ChildAssetDto> chiTietDieuDong,
  ) {
    // Map nhanh id -> Asset
    final Map<String, AssetManagementDto> idToAsset = {
      for (final a in allAssets)
        if (a.id != null) a.id!: a,
    };

    // Duyệt theo thứ tự child, loại trùng idTaiSan
    final result = <AssetManagementDto>[];
    final seen = <String>{};
    for (final c in chiTietDieuDong) {
      final id = c.idTaiSanCon;
      if (seen.add(id ?? '')) {
        final asset = idToAsset[id];
        if (asset != null) result.add(asset);
      }
    }
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
            text: 'Chi tiết tài sản điều chuyển:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
        ),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.only(left: 10, top: 15),
          child: SgEditableTable<AssetManagementDto>(
            initialData: getAssetsByChildAssets(
              widget.allAssets,
              movementDetails,
            ),
            createEmptyItem: AssetManagementDto.empty,
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
              SgEditableColumn<AssetManagementDto>(
                field: 'asset',
                title: 'Tài sản',
                titleAlignment: TextAlign.center,
                width: 120,
                getValue: (item) => item,
                setValue: (item, value) {
                  if (value is AssetManagementDto) {
                    item.id = value.id;
                    item.tenTaiSan = '${value.id} - ${value.tenTaiSan}';
                    item.idDonViHienThoi = value.idDonViHienThoi;
                  }
                },
                sortValueGetter: (item) => item.tenTaiSan,
                isCellEditableDecider: (item, rowIndex) => true,
                editor: EditableCellEditor.dropdown,
                dropdownItems: [
                  for (var element in widget.allAssets)
                    DropdownMenuItem<AssetManagementDto>(
                      value: element,
                      child: Text('${element.id} - ${element.tenTaiSan}'),
                    ),
                ],
                // displayStringForOption: (item) => item.tenTaiSan ?? '',
                onValueChanged: (item, rowIndex, newValue, updateRow) {
                  if (newValue is AssetManagementDto) {
                    updateRow('don_vi_tinh', newValue.donViTinh);
                    updateRow('so_luong', newValue.soLuong);
                    updateRow('tinh_trang', newValue.hienTrang);
                    updateRow('ghi_chu', newValue.ghiChu ?? '');
                  }
                },
              ),
              SgEditableColumn<AssetManagementDto>(
                field: 'don_vi_tinh',
                title: 'Đơn vị tính',
                titleAlignment: TextAlign.center,
                width: 100,
                getValue: (item) => item.donViTinh,
                setValue: (item, value) => item.donViTinh = value,
                sortValueGetter: (item) => item.donViTinh,
                isEditable: false,
              ),
              SgEditableColumn<AssetManagementDto>(
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
              SgEditableColumn<AssetManagementDto>(
                field: 'tinh_trang',
                title: 'Tình trạng kỹ thuật',
                titleAlignment: TextAlign.center,
                width: 100,
                getValue: (item) => getHienTrang(item.hienTrang ?? -1),
                setValue: (item, value) => item.hienTrang = value,
                sortValueGetter: (item) => getHienTrang(item.hienTrang ?? -1),
                isEditable: false,
              ),
              SgEditableColumn<AssetManagementDto>(
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
