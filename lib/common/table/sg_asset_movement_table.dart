import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/table/sg_editable_table.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/movement_detail_dto.dart';

class SgAssetMovementTable extends StatefulWidget {
  final List<MovementDetailDto> initialData;
  final Function(List<MovementDetailDto>)? onDataChanged;
  final Function(String)? onJsonExported;

  const SgAssetMovementTable({super.key, this.initialData = const [], this.onDataChanged, this.onJsonExported});

  @override
  State<SgAssetMovementTable> createState() => _SgAssetMovementTableState();
}

class _SgAssetMovementTableState extends State<SgAssetMovementTable> {
  final _tableKey = GlobalKey<SgEditableTableState<MovementDetailDto>>();
  late List<MovementDetailDto> _data;

  @override
  void initState() {
    super.initState();
    _data = List.from(widget.initialData);
  }

  String exportToJson() {
    if (_tableKey.currentState != null) {
      final jsonStr = _tableKey.currentState!.exportToJson();
      if (widget.onJsonExported != null) {
        widget.onJsonExported!(jsonStr);
      }
      return jsonStr;
    }
    return '[]';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SgEditableTable<MovementDetailDto>(
          key: _tableKey,
          initialData: _data,
          createEmptyItem: () => MovementDetailDto.empty(),
          onDataChanged: widget.onDataChanged,
          columns: [
            SgEditableColumn<MovementDetailDto>(
              field: 'asset',
              title: 'Tài sản',
              width: 250,
              getValue: (item) => item.tenTaiSan,
              setValue: (item, value) => MovementDetailDto.copy(item, tenTaiSan: value),
            ),
            SgEditableColumn<MovementDetailDto>(
              field: 'unit',
              title: 'Đơn vị tính',
              width: 100,
              getValue: (item) => item.donViTinh,
              setValue: (item, value) => MovementDetailDto.copy(item, donViTinh: value),
            ),
            SgEditableColumn<MovementDetailDto>(
              field: 'quantity',
              title: 'Số lượng',
              width: 100,
              getValue: (item) => item.soLuong,
              setValue: (item, value) => MovementDetailDto.copy(item, soLuong: value),
            ),
            SgEditableColumn<MovementDetailDto>(
              field: 'condition',
              title: 'Tình trạng kỹ thuật',
              width: 150,
              getValue: (item) => item.hienTrang,
              setValue: (item, value) => MovementDetailDto.copy(item, hienTrang: value),
            ),
            SgEditableColumn<MovementDetailDto>(
              field: 'note',
              title: 'Ghi chú',
              width: 150,
              getValue: (item) => item.ghiChu,
              setValue: (item, value) => MovementDetailDto.copy(item, ghiChu: value),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            exportToJson();
          },
          child: const Text('Xuất JSON'),
        ),
      ],
    );
  }
}
