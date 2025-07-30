import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/web_view/web_view_common.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_movement_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

Color _getStatusColor(int status) {
  switch (status) {
    case 0:
      return ColorValue.silverGray;
    case 1:
      return ColorValue.lightAmber;
    case 2:
      return ColorValue.mediumGreen;
    case 3:
      return ColorValue.lightBlue;
    case 4:
      return ColorValue.forestGreen;
    case 5:
      return ColorValue.brightRed;
    default:
      return ColorValue.paleRose;
  }
}

String _getStatusText(int status) {
  switch (status) {
    case 0:
      return 'Nháp';
    case 1:
      return 'Sẵn sàng';
    case 2:
      return 'Xác nhận';
    case 3:
      return 'Trình Duyệt';
    case 4:
      return 'Hoàn thành';
    case 5:
      return 'Hủy';
    default:
      return '';
  }
}

List<SgTableColumn<AssetHandoverDto>> createColumns(
  BuildContext context,
  Map<String, double> columnWidths,
) {
  return [
    TableColumnBuilder.createTextColumn<AssetHandoverDto>(
      title: 'Quyết định điều động',
      textColor: Colors.black87,
      getValue: (item) => item.decisionNumber ?? '',
      fontSize: 12,
      width: columnWidths['Quyết định điều động']!,
    ),
    TableColumnBuilder.createTextColumn<AssetHandoverDto>(
      title: 'Lệnh điều động',
      textColor: Colors.black87,
      fontSize: 12,
      getValue: (item) => item.order ?? '',
      width: columnWidths['Lệnh điều động']!,
    ),
    TableColumnBuilder.createTextColumn<AssetHandoverDto>(
      title: 'Ngày bàn giao',
      textColor: Colors.black87,
      fontSize: 12,
      getValue: (item) => item.transferDate ?? '',
      width: columnWidths['Ngày bàn giao']!,
    ),
    SgTableColumn<AssetHandoverDto>(
      title: 'Chi tiết bàn giao',
      cellBuilder:
          (item) => _buildMovementDetails(item.assetHandoverMovements ?? []),
      cellAlignment: TextAlign.center,
      titleAlignment: TextAlign.center,
      width: columnWidths['Chi tiết bàn giao']!,
    ),
    TableColumnBuilder.createTextColumn<AssetHandoverDto>(
      title: 'Đơn vị giao',
      textColor: Colors.black87,
      fontSize: 12,
      getValue: (item) => item.senderUnit ?? '',
      width: columnWidths['Đơn vị giao']!,
    ),
    TableColumnBuilder.createTextColumn<AssetHandoverDto>(
      title: 'Đơn vị nhận',
      textColor: Colors.black87,
      fontSize: 12,
      getValue: (item) => item.receiverUnit ?? '',
      width: columnWidths['Đơn vị nhận']!,
    ),
    SgTableColumn<AssetHandoverDto>(
      title: 'Trạng thái',
      cellBuilder: (item) => _buildStatus(item.state ?? 0),
      cellAlignment: TextAlign.center,
      titleAlignment: TextAlign.center,
      width: columnWidths['Trạng thái']!,
    ),
    SgTableColumn<AssetHandoverDto>(
      title: '',
      cellBuilder: (item) => _buildActions(context,   item),
      cellAlignment: TextAlign.center,
      titleAlignment: TextAlign.center,
      width: columnWidths['Actions']!,
      searchable: true,
    ),
  ];
}

Widget _buildMovementDetails(List<AssetHandoverMovementDto> movementDetails) {
  return Container(
    constraints: const BoxConstraints(maxHeight: 48.0),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: movementDetails.map(_buildMovementDetailItem).toList(),
        ),
      ),
    ),
  );
}

Widget _buildMovementDetailItem(AssetHandoverMovementDto detail) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
    margin: const EdgeInsets.only(bottom: 2),
    decoration: BoxDecoration(
      color: ColorValue.paleRose,
      borderRadius: BorderRadius.circular(4),
    ),
    child: SGText(
      text: detail.name ?? '',
      size: 12,
      fontWeight: FontWeight.w500,
      textAlign: TextAlign.left,
    ),
  );
}

Widget _buildActions(BuildContext context, AssetHandoverDto item) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _buildActionButton(
        icon: Icons.visibility,
        color: Colors.green,
        tooltip: 'Xem',
        onPressed: () => _showDocument(context, item),
      ),
      const SizedBox(width: 8),
      _buildActionButton(
        icon: Icons.delete,
        color: Colors.red,
        tooltip: item.state != 0 ? null : 'Xóa',
        onPressed: null,
        disabled: item.state != 0,
      ),
    ],
  );
}

Widget _buildActionButton({
  required IconData icon,
  required MaterialColor color,
  String? tooltip,
  VoidCallback? onPressed,
  bool disabled = false,
}) {
  return Container(
    decoration: BoxDecoration(
      color: disabled ? Colors.grey.shade50 : color.shade50,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: disabled ? Colors.grey.shade200 : color.shade200,
        width: 1,
      ),
    ),
    child: IconButton(
      icon: Icon(icon, size: 16),
      tooltip: tooltip,
      color: disabled ? Colors.grey : color.shade700,
      onPressed: onPressed,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      padding: const EdgeInsets.all(4),
    ),
  );
}

Widget _buildStatus(int status) {
  return Container(
    constraints: const BoxConstraints(maxHeight: 48.0),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(4),
      ),
      child: SGText(
        text: _getStatusText(status),
        size: 12,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    ),
  );
}

void _showDocument(BuildContext context, AssetHandoverDto item) {
  // showDialog(
  //   context: context,
  //   builder:
  //       (context) => WebViewCommon(
  //         url: 'https://ams.sscdx.com.vn/web#',
  //         title: item.name ?? 'Tài liệu',
  //         showAppBar: true,
  //       ),
  // );
}
