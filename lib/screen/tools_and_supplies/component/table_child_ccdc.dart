import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/table/detail_editable_table.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/detail_assets_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';

class TableChildCcdc extends StatefulWidget {
  final bool isEditing;
  final List<DetailAssetDto> initialDetails;
  final Function(List<DetailAssetDto>)? onDataChanged;

  const TableChildCcdc(
    BuildContext context, {
    super.key,
    required this.isEditing,
    required this.initialDetails,
    required this.onDataChanged,
  });

  @override
  State<TableChildCcdc> createState() => _TableChildCcdcState();
}

class _TableChildCcdcState extends State<TableChildCcdc> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: const SGText(
            text: 'Chi tiết ccdc vật tư:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
        ),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.only(left: 10, top: 15),
          child: DetailEditableTable<DetailAssetDto>(
            initialData: widget.initialDetails,
            createEmptyItem: DetailAssetDto.empty,
            rowHeight: 40.0,
            headerBackgroundColor: Colors.grey.shade50,
            oddRowBackgroundColor: Colors.white,
            evenRowBackgroundColor: Colors.white,
            showVerticalLines: false,
            showHorizontalLines: true,
            addRowText: 'Thêm một dòng',
            isEditing: widget.isEditing,
            omittedSize: 130,
            onDataChanged: widget.onDataChanged,
            columns: [
              DetailEditableColumn<DetailAssetDto>(
                field: 'so_thu_tu',
                title: 'STT',
                titleAlignment: TextAlign.center,
                width: 50,
                getValue: (item) => '',
                getValueWithIndex: (item, index) => (index + 1).toString(),
                setValue: (item, value) {},
                sortValueGetter: (item) => widget.initialDetails.indexOf(item),
                isEditable: false,
              ),
              DetailEditableColumn<DetailAssetDto>(
                field: 'so_ky_hieu',
                title: 'Số ký hiệu',
                titleAlignment: TextAlign.center,
                width: 100,
                getValue: (item) => item.soKyHieu,
                setValue: (item, value) {
                  item.soKyHieu = value;
                },
                sortValueGetter: (item) => item.soKyHieu,
                isEditable: widget.isEditing,
              ),
              DetailEditableColumn<DetailAssetDto>(
                field: 'so_luong',
                title: 'Số lượng',
                titleAlignment: TextAlign.center,
                width: 100,
                getValue: (item) => item.soLuong.toString(),
                setValue:
                    (item, value) => item.soLuong = int.tryParse(value) ?? 0,
                sortValueGetter: (item) => item.soLuong.toString(),
                isEditable: widget.isEditing,
                inputType: TextInputType.number,
              ),
              DetailEditableColumn<DetailAssetDto>(
                field: 'cong_suat',
                title: 'Công suất',
                titleAlignment: TextAlign.center,
                width: 100,
                getValue: (item) => item.congSuat,
                setValue: (item, value) => item.congSuat = value,
                sortValueGetter: (item) => item.congSuat,
                isEditable: widget.isEditing,
              ),
              DetailEditableColumn<DetailAssetDto>(
                field: 'nuoc_sx',
                title: 'Nước sản xuất',
                titleAlignment: TextAlign.center,
                width: 100,
                getValue: (item) => item.nuocSanXuat,
                setValue: (item, value) => item.nuocSanXuat = value,
                sortValueGetter: (item) => item.nuocSanXuat,
                isEditable: widget.isEditing,
              ),
              DetailEditableColumn<DetailAssetDto>(
                field: 'nam_sx',
                title: 'Năm sản xuất',
                titleAlignment: TextAlign.center,
                width: 100,
                getValue: (item) => item.namSanXuat.toString(),
                setValue:
                    (item, value) => item.namSanXuat = int.tryParse(value) ?? 0,
                sortValueGetter: (item) => item.namSanXuat.toString(),
                isEditable: widget.isEditing,
                inputType: TextInputType.number,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
