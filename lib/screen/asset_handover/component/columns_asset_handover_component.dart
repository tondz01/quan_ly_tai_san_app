import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/common/download_file.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/popup/columns_asset_handover.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

String url =
    'https://firebasestorage.googleapis.com/v0/b/shopifyappdata.appspot.com/o/document%2FB%C3%A0n%20giao%20t%C3%A0i%20s%E1%BA%A3n.pdf?alt=media&token=497ba34e-891b-45b0-b228-704ca958760b';

List<SgTableColumn<AssetHandoverDto>> createColumns(
  BuildContext context,
  Map<String, double> columnWidths,
) {
  return [
    TableColumnBuilder.createTextColumn<AssetHandoverDto>(
      title: 'Phiếu ký nội sinh',
      textColor: Colors.black87,
      getValue: (item) => 'Biên bản bàn giao tài sản',
      fontSize: 12,
      width: columnWidths['Phiếu ký nội sinh']!,
    ),
    TableColumnBuilder.createTextColumn<AssetHandoverDto>(
      title: 'Ngày ký',
      textColor: Colors.black87,
      fontSize: 12,
      getValue: (item) => getDateOfSigning(item.transferDate ?? ''),
      width: columnWidths['Ngày ký']!,
    ),
    TableColumnBuilder.createTextColumn<AssetHandoverDto>(
      title: 'Ngày hiệu lực',
      textColor: Colors.black87,
      fontSize: 12,
      getValue: (item) => item.transferDate ?? '',
      width: columnWidths['Ngày hiệu lực']!,
    ),
    TableColumnBuilder.createTextColumn<AssetHandoverDto>(
      title: 'Trình duyệt ban giám đốc',
      textColor: Colors.black87,
      fontSize: 12,
      getValue: (item) => item.assetHandoverDetails!.leader ?? '',
      width: columnWidths['Trình duyệt ban giám đốc']!,
    ),
    SgTableColumn<AssetHandoverDto>(
      title: 'Tài liệu duyệt',
      cellBuilder: (item) => showFile(url, context),
      cellAlignment: TextAlign.center,
      titleAlignment: TextAlign.center,
      width: columnWidths['Tài liệu duyệt']!,
      searchable: true,
    ),
    SgTableColumn<AssetHandoverDto>(
      title: 'Có hiệu lực',
      cellBuilder: (item) => buildIsEffective(item),
      cellAlignment: TextAlign.center,
      titleAlignment: TextAlign.center,
      width: columnWidths['Có hiệu lực']!,
    ),

    TableColumnBuilder.createTextColumn<AssetHandoverDto>(
      title: 'Ký số',
      textColor: Colors.black87,
      fontSize: 12,
      getValue: (item) => item.id ?? '',
      width: columnWidths['Ký số']!,
    ),
    SgTableColumn<AssetHandoverDto>(
      title: '',
      cellBuilder: (item) => buildActions(context, item),
      cellAlignment: TextAlign.center,
      titleAlignment: TextAlign.center,
      width: columnWidths['Actions']!,
      searchable: true,
    ),
  ];
}

Widget showFile(String url, BuildContext context) {
  return url.isNotEmpty
      ? InkWell(
        onTap: () {
          downloadFile(url, 'Bàn giao tài sản', context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.blue.shade200, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.file_download_outlined,
                size: 14,
                color: Colors.blue.shade700,
              ),
              SizedBox(width: 4),
              Flexible(
                child: Text(
                  'Bàn giao tài sản',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      )
      : SizedBox.shrink();
}

bool onCheckIsEffective(AssetHandoverDto item) {
  bool isUnitConfirm = item.assetHandoverDetails!.isUnitConfirm ?? false;
  bool isDelivererConfirm =
      item.assetHandoverDetails!.isDelivererConfirm ?? false;
  bool isReceiverConfirm =
      item.assetHandoverDetails!.isReceiverConfirm ?? false;
  bool isRepresentativeUnitConfirm =
      item.assetHandoverDetails!.isRepresentativeUnitConfirm ?? false;
  return isUnitConfirm &&
      isDelivererConfirm &&
      isReceiverConfirm &&
      isRepresentativeUnitConfirm;
}

Widget buildIsEffective(AssetHandoverDto item) {
  return SizedBox(
    width: 24,
    height: 24,
    child: Checkbox(
      value: onCheckIsEffective(item),
      onChanged: (newValue) {},
      activeColor: ColorValue.lightBlue,
      checkColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    ),
  );
}

Widget buildActions(BuildContext context, AssetHandoverDto item) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      AssetHandoverColumns.buildActionButton(
        icon: Icons.visibility,
        color: Colors.green,
        tooltip: 'Xem',
        onPressed: () => _showDocument(context, item),
      ),
      const SizedBox(width: 8),
      AssetHandoverColumns.buildActionButton(
        icon: Icons.delete,
        color: Colors.red,
        tooltip: item.state != 0 ? null : 'Xóa',
        onPressed: null,
        disabled: item.state != 0,
      ),
    ],
  );
}

String getDateOfSigning(String dateStr) {
  DateTime date;

  // Kiểm tra định dạng đầu vào
  if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dateStr)) {
    // Định dạng yyyy-MM-dd
    date = DateFormat('yyyy-MM-dd').parse(dateStr);
  } else if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(dateStr)) {
    // Định dạng dd/MM/yyyy
    date = DateFormat('dd/MM/yyyy').parse(dateStr);
  } else {
    throw FormatException('Unsupported date format: $dateStr');
  }

  DateTime newDate = date.add(Duration(days: 3));

  String newDateStr = DateFormat('yyyy-MM-dd').format(newDate);
  return newDateStr;
}

void _showDocument(BuildContext context, AssetHandoverDto item) {
  // Tạo data với thông tin menu selection
  // Map<String, dynamic> navigationData = {
  //   'AssetHandoverDto': item,
  //   'menuSelection': {
  //     'selectedIndex': 8, // Index của "Bàn giao tài sản"
  //     'selectedSubIndex': 0, // Index của "Biên bản bàn giao tài sản"
  //   },
  // };

  // context.go(AppRoute.assetHandover.path, extra: navigationData);
  // Navigator.of(context).pop();
}
