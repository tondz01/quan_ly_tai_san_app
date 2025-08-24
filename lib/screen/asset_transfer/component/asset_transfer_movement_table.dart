import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/table/sg_editable_table.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:se_gay_components/common/sg_text.dart';

import '../repository/chi_tiet_dieu_dong_tai_san_repository.dart';

class AssetTransferMovementTable extends StatefulWidget {
  final bool isEditing;
  final List<ChiTietDieuDongTaiSan> initialDetails;
  final List<AssetManagementDto> allAssets;
  final Function(List<AssetManagementDto>)? onDataChanged;

  const AssetTransferMovementTable(
    BuildContext context, {
    super.key,
    required this.isEditing,
    required this.initialDetails,
    required this.allAssets,
    required this.onDataChanged,
  });

  @override
  State<AssetTransferMovementTable> createState() =>
      _AssetTransferMovementTableState();
}

class _AssetTransferMovementTableState
    extends State<AssetTransferMovementTable> {
  late List<ChiTietDieuDongTaiSan> movementDetails;
  late List<AssetManagementDto> listAsset;
  final repo = ChiTietDieuDongTaiSanRepository();
  final GlobalKey<SgEditableTableState<AssetManagementDto>> _tableKey =
      GlobalKey();

  void _forceNotifyDataChanged() {
    widget.onDataChanged?.call(List.from(listAsset));
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialDetails.isNotEmpty) {
      listAsset = getAssetsByChildAssets(
        widget.allAssets,
        widget.initialDetails,
      );
    } else {
      listAsset = [];
    }
    movementDetails = List.from(widget.initialDetails);
  }

  @override
  void didUpdateWidget(AssetTransferMovementTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Chỉ cập nhật khi initialDetails thực sự thay đổi và khác với dữ liệu hiện tại
    if (oldWidget.initialDetails != widget.initialDetails &&
        widget.initialDetails.isNotEmpty) {
      movementDetails = List.from(widget.initialDetails);
      listAsset = getAssetsByChildAssets(widget.allAssets, movementDetails);
    }
    if (oldWidget.initialDetails.isNotEmpty && widget.initialDetails.isEmpty) {
      listAsset = [];
    }
  }

  List<AssetManagementDto> getAssetsByChildAssets(
    List<AssetManagementDto> allAssets,
    List<ChiTietDieuDongTaiSan> chiTietDieuDong,
  ) {
    // Map nhanh id -> Asset
    final Map<String, AssetManagementDto> idToAsset = {
      for (final a in allAssets)
        if (a.id != null) a.id!: a,
    };

    // Duyệt theo thứ tự child, cho phép trùng lặp để có thể thêm nhiều dòng
    final result = <AssetManagementDto>[];
    for (final c in chiTietDieuDong) {
      final id = c.idTaiSan;
      final asset = idToAsset[id];
      if (asset != null) {
        // Tạo bản sao để tránh tham chiếu chung
        result.add(asset);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    log('listAsset length: ${listAsset.length}');
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
            key: _tableKey,
            initialData: listAsset,
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
            onDataChanged: (data) {
              // Cập nhật local state
              setState(() {
                listAsset = List.from(data);
              });

              // Thông báo thay đổi lên parent
              widget.onDataChanged?.call(data);
            },
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
                    item.tenTaiSan = value.tenTaiSan;
                    item.donViTinh = value.donViTinh;
                    item.soLuong = value.soLuong;
                    item.hienTrang = value.hienTrang;
                    item.ghiChu = value.ghiChu ?? '';
                    item.idDonViHienThoi = value.idDonViHienThoi;
                  }
                  log('setValue: ${item.tenTaiSan}');
                },
                sortValueGetter: (item) => item.tenTaiSan,
                isCellEditableDecider: (item, rowIndex) => true,
                editor: EditableCellEditor.dropdown,
                dropdownItems: [
                  for (var element in widget.allAssets)
                    DropdownMenuItem<AssetManagementDto>(
                      value: element,
                      child: Text(element.tenTaiSan ?? ''),
                    ),
                ],
                onValueChanged: (item, rowIndex, newValue, updateRow) {
                  if (newValue is AssetManagementDto) {
                    log('onValueChanged: ${newValue.tenTaiSan}, rowIndex: $rowIndex');
                    
                    // Cập nhật đầy đủ thông tin của item trong listAsset
                    if (rowIndex < listAsset.length) {
                      final updatedItem = listAsset[rowIndex];
                      updatedItem.id = newValue.id;
                      updatedItem.tenTaiSan = '${newValue.id} - ${newValue.tenTaiSan}';
                      updatedItem.donViTinh = newValue.donViTinh;
                      updatedItem.soLuong = newValue.soLuong;
                      updatedItem.hienTrang = newValue.hienTrang;
                      updatedItem.ghiChu = newValue.ghiChu ?? '';
                      updatedItem.idDonViHienThoi = newValue.idDonViHienThoi;
                      
                      log('Updated item in listAsset: ${updatedItem.id} - ${updatedItem.tenTaiSan}');
                    }
                    
                    // Cập nhật các cột khác
                    updateRow('don_vi_tinh', newValue.donViTinh);
                    updateRow('so_luong', newValue.soLuong);
                    updateRow('tinh_trang', newValue.hienTrang);
                    updateRow('ghi_chu', newValue.ghiChu ?? '');
                    
                    // Force rebuild để hiển thị đúng item đã chọn
                    setState(() {});
                    
                    // Force trigger onDataChanged để parent nhận được thay đổi
                    Future.microtask(() => _forceNotifyDataChanged());
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
