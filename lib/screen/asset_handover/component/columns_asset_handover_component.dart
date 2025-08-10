import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/common/download_file.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/popup/columns_asset_handover.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

List<SgTableColumn<DieuDongTaiSan>> createColumns(
  BuildContext context,
  Map<String, double> columnWidths,
) {
  return [
    TableColumnBuilder.createTextColumn<DieuDongTaiSan>(
      title: 'Phiếu ký nội sinh',
      textColor: Colors.black87,
      getValue: (item) => 'Biên bản điều động tài sản',
      fontSize: 12,
      width: columnWidths['Phiếu ký nội sinh']!,
    ),
    TableColumnBuilder.createTextColumn<DieuDongTaiSan>(
      title: 'Ngày ký',
      textColor: Colors.black87,
      fontSize: 12,
      getValue: (item) => getDateOfSigning(item.ngayKy ?? ''),
      width: columnWidths['Ngày ký']!,
    ),
    TableColumnBuilder.createTextColumn<DieuDongTaiSan>(
      title: 'Ngày hiệu lực',
      textColor: Colors.black87,
      fontSize: 12,
      getValue: (item) => item.tggnTuNgay ?? '',
      width: columnWidths['Ngày hiệu lực']!,
    ),
    TableColumnBuilder.createTextColumn<DieuDongTaiSan>(
      title: 'Trình duyệt ban giám đốc',
      textColor: Colors.black87,
      fontSize: 12,
      getValue: (item) => item.tenTrinhDuyetGiamDoc.toString() ?? '',
      width: columnWidths['Trình duyệt ban giám đốc']!,
    ),
    SgTableColumn<DieuDongTaiSan>(
      title: 'Tài liệu duyệt',
      cellBuilder: (item) => showFile(item.duongDanFile??'', context),
      cellAlignment: TextAlign.center,
      titleAlignment: TextAlign.center,
      width: columnWidths['Tài liệu duyệt']!,
      searchable: true,
    ),
    SgTableColumn<DieuDongTaiSan>(
      title: 'Có hiệu lực',
      cellBuilder: (item) => buildIsEffective(item),
      cellAlignment: TextAlign.center,
      titleAlignment: TextAlign.center,
      width: columnWidths['Có hiệu lực']!,
    ),
    TableColumnBuilder.createTextColumn<DieuDongTaiSan>(
      title: 'Ký số',
      textColor: Colors.black87,
      fontSize: 12,
      getValue: (item) => item.id ?? '',
      width: columnWidths['Ký số']!,
    ),
    SgTableColumn<DieuDongTaiSan>(
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
            downloadFile(url, 'Điều động tài sản', context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    'Điều động tài sản',
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
      : const SizedBox.shrink();
}

bool onCheckIsEffective(DieuDongTaiSan item) {
  bool isUnitConfirm = item.coHieuLuc ?? false;
  bool isDelivererConfirm = item.nguoiLapPhieuKyNhay ?? false;
  bool isReceiverConfirm = item.phoPhongXacNhan ?? false;
  bool isRepresentativeUnitConfirm =
      item.quanTrongCanXacNhan ?? false;

  return isUnitConfirm &&
      isDelivererConfirm &&
      isReceiverConfirm &&
      isRepresentativeUnitConfirm;
}

Widget buildIsEffective(DieuDongTaiSan item) {
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

Widget buildActions(BuildContext context, DieuDongTaiSan item) {
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
        tooltip: item.isActive != 0 ? null : 'Xóa',
        onPressed: null,
        disabled: item.isActive != 0,
      ),
    ],
  );
}

String getDateOfSigning(String dateStr) {
  DateTime date;

  if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dateStr)) {
    date = DateFormat('yyyy-MM-dd').parse(dateStr);
  } else if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(dateStr)) {
    date = DateFormat('dd/MM/yyyy').parse(dateStr);
  } else {
    throw FormatException('Unsupported date format: $dateStr');
  }

  DateTime newDate = date.add(const Duration(days: 3));
  return DateFormat('yyyy-MM-dd').format(newDate);
}

void _showDocument(BuildContext context, DieuDongTaiSan item) {
  // TODO: Implement navigation or document preview
}
