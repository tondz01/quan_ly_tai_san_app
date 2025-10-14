// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/sg_download_file.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/config_view_asset_transfer.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';

class TableAssetTransferByHandoverConfig {
  static List<ColumnDefinition> getColumns(UserInfoDTO userInfo) {
    return [
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Phiếu ký nội sinh',
          key: 'type',
          width: 150,
          flex: 1,
        ),
        builder: (item) => TableCellData(widget: Text(item.tenPhieu ?? '')),
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Ngày ký',
          key: 'decision_date',
          width: 100,
          flex: 1,
        ),
        builder: (item) => TableCellData(widget: Text(item.ngayKy ?? '')),
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Ngày có hiệu lực',
          key: 'effective_date',
          width: 100,
          flex: 1,
        ),
        builder: (item) => TableCellData(widget: Text(item.tggnTuNgay ?? '')),
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Trình duyệt ban giám đốc',
          key: 'approver',
          width: 150,
          flex: 1,
        ),
        builder: (item) => TableCellData(widget: Text(item.tenTrinhDuyetGiamDoc ?? '')),
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Tài liệu duyệt',
          key: 'document',
          width: 150,
          flex: 1,
        ),
        builder: (item) => TableCellData(
          widget: SgDownloadFile(
            url: item.duongDanFile.toString(),
            name: item.tenFile ?? '',
          ),
        ),
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Ký số',
          key: 'id',
          width: 120,
          flex: 1,
        ),
        builder: (item) => TableCellData(widget: Text(item.id ?? '')),
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Trạng thái',
          key: 'status',
          width: 150,
          flex: 1,
        ),
        builder: (item) => TableCellData(
          widget: ConfigViewAT.showStatus(item.trangThai ?? 0),
        ),
      ),
    ];
  }

  static String getName(int type) {
    switch (type) {
      case 1:
        return 'Phiếu duyệt cấp phát tài sản';
      case 2:
        return 'Phiếu duyệt chuyển tài sản';
      case 3:
        return 'Phiếu duyệt thu hồi tài sản';
    }
    return '';
  }
}
