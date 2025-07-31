import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/asset_transfer_dto.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class TableAssetTransferByDetail extends StatefulWidget {
  const TableAssetTransferByDetail({super.key});

  @override
  State<TableAssetTransferByDetail> createState() =>
      _TableAssetTransferByDetailState();
}

class _TableAssetTransferByDetailState
    extends State<TableAssetTransferByDetail> {
  //
  final List<SgTableColumn<AssetTransferDto>> columns = [
    TableBaseConfig.columnTable(
      title: 'Phiếu ký nội sinh',
      width: 150,
      getValue: (item) => getName(item.type ?? 0),
    ),
    TableBaseConfig.columnTable(
      title: 'Ngày ký',
      width: 100,
      getValue: (item) => getName(item.type ?? 0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Replace with your actual data source
    final List<AssetTransferDto> data = [];

    return TableBaseConfig.tableBase<AssetTransferDto>(columns: columns, data: data);
  }
}

String getName(int type) {
  switch (type) {
    case 1:
      return 'Phiếu duyệt cấp phát tài sản';
    case 2:
      return 'Phiếu duyệt thu hồi tài sản';
    case 3:
      return 'Phiếu duyệt chuyển tài sản';
  }
  return '';
}
