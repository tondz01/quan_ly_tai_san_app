import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/table/sg_editable_table.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:se_gay_components/common/sg_text.dart';

import '../repository/chi_tiet_dieu_dong_tai_san_repository.dart';

class AssetTransferMovementTable extends StatefulWidget {
  final bool isEditing;
  final List<ChiTietDieuDongTaiSan> initialDetails;
  final List<String> assetsList; // Danh sách tên tài sản cho dropdown

  const AssetTransferMovementTable(
    BuildContext context, {
    super.key,
    required this.isEditing,
    required this.initialDetails,
    required this.assetsList,
  });

  @override
  State<AssetTransferMovementTable> createState() =>
      _AssetTransferMovementTableState();
}

class _AssetTransferMovementTableState
    extends State<AssetTransferMovementTable> {
  late List<ChiTietDieuDongTaiSan> movementDetails;
  final repo = ChiTietDieuDongTaiSanRepository();

  @override
  void initState() {
    super.initState();
    movementDetails = List.from(widget.initialDetails);
  }

  void _addRow() {
    setState(() {
      movementDetails.add(ChiTietDieuDongTaiSan.empty());
    });
  }

  Future<void> _saveRow(ChiTietDieuDongTaiSan item) async {
    try {
      if (item.id == null || item.id!.isEmpty) {
        // Gọi API tạo mới
        final newId = await repo.create(item);
        setState(() {
          item.id = newId.toString();
        });
      } else {
        // Gọi API cập nhật
        await repo.update(item.id!, item);
      }
    } catch (e) {
      debugPrint('Lỗi khi lưu dữ liệu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssetManagementProvider>(context);

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
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: widget.isEditing ? _addRow : null,
              icon: const Icon(Icons.add),
              label: const Text("Thêm một dòng"),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
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
            isEditing: widget.isEditing,
            onDataChanged: (data) {
              setState(() {
                movementDetails = data;
              });

              // Lưu API cho từng item vừa thay đổi
              // Ở đây giả sử SgEditableTable bắn ra list mới mỗi khi cell thay đổi
              if (data.isNotEmpty) {
                _saveRow(data.last);
              }
            },
            columns: [
              SgEditableColumn<ChiTietDieuDongTaiSan>(
                field: 'asset',
                title: 'Tài sản',
                titleAlignment: TextAlign.center,
                width: 350,
                getValue: (item) => item.tenTaiSan,
                setValue: (item, value) => item.tenTaiSan = value,
                sortValueGetter: (item) => item.tenTaiSan,
                isCellEditableDecider: (item, rowIndex) => widget.isEditing,
                editor: EditableCellEditor.dropdown,

                onValueChanged: (item, rowIndex, newValue, updateRow) async {
                  item.tenTaiSan = newValue; // gán giá trị mới
                  await _saveRow(item);
                },
              ),

              SgEditableColumn<ChiTietDieuDongTaiSan>(
                field: 'unit',
                title: 'Đơn vị tính',
                titleAlignment: TextAlign.center,
                width: 130,
                getValue: (item) => item.donViTinh,
                setValue: (item, value) => item.donViTinh = value,
                sortValueGetter: (item) => item.donViTinh,
                onValueChanged: (item, rowIndex, newValue, updateRow) async {
                  await _saveRow(item);
                },
              ),
              SgEditableColumn<ChiTietDieuDongTaiSan>(
                field: 'quantity',
                title: 'Số lượng',
                titleAlignment: TextAlign.center,
                width: 120,
                getValue: (item) => item.soLuong,
                setValue: (item, value) => item.soLuong = value,
                sortValueGetter:
                    (item) => int.tryParse(item.soLuong.toString()) ?? 0,
                onValueChanged: (item, rowIndex, newValue, updateRow) async {
                  await _saveRow(item);
                },
              ),
              SgEditableColumn<ChiTietDieuDongTaiSan>(
                field: 'condition',
                title: 'Tình trạng kỹ thuật',
                titleAlignment: TextAlign.center,
                width: 190,
                getValue: (item) => item.hienTrang,
                setValue: (item, value) => item.hienTrang = value,
                sortValueGetter: (item) => item.hienTrang,
                onValueChanged: (item, rowIndex, newValue, updateRow) async {
                  await _saveRow(item);
                },
              ),
              SgEditableColumn<ChiTietDieuDongTaiSan>(
                field: 'note',
                title: 'Ghi chú',
                titleAlignment: TextAlign.center,
                width: 150,
                getValue: (item) => item.ghiChu,
                setValue: (item, value) => item.ghiChu = value,
                sortValueGetter: (item) => item.ghiChu,
                onValueChanged: (item, rowIndex, newValue, updateRow) async {
                  await _saveRow(item);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
