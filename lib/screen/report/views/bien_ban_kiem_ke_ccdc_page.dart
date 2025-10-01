import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/page/contract_page.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/ccdc_inventory_report.dart';
import 'package:se_gay_components/common/sg_text.dart';

class BienBanKiemKeCcdcPage extends StatelessWidget {
  final List<CCDCInventoryReport> ccdcInventory;
  final String denNgay;
  final String tenDonVi;

  const BienBanKiemKeCcdcPage({
    super.key,
    required this.ccdcInventory,
    required this.denNgay,
    required this.tenDonVi,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SGText(
                    text:
                        "TẬP ĐOÀN CÔNG NGHIỆP\nTHAN - KHOÁNG SẢN VIỆT NAM",
                    style: SettingPage.textStyle,
                    textAlign: TextAlign.center,
                  ),
                  SGText(
                    text: "CÔNG TY THAN UÔNG BÍ - TKV",
                    style: SettingPage.textStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SGText(
                    text: "Mẫu số 01a-TS",
                    style: SettingPage.textStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SGText(
                    text: "Ban hành kèm theo QĐ số           /QĐ-TUB",
                    style: SettingPage.textStyle,
                    textAlign: TextAlign.center,
                  ),
                  SGText(
                    text: "ngày    /   /       của Giám đốc Công ty",
                    style: SettingPage.textStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
        SGText(text: "", style: SettingPage.textStyle),
        SGText(text: "", style: SettingPage.textStyle),
        Center(
          child: SGText(
            text: "BIÊN BẢN KIỂM KÊ TSCĐ, CCDC TẠI HIỆN TRƯỜNG",
            style: SettingPage.textStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14 * SettingPage.scale,
            ),
          ),
        ),
        Center(
          child: SGText(
            text: "Đơn vị: $tenDonVi",
            style: SettingPage.textStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SGText(text: "", style: SettingPage.textStyle),
        Center(
          child: SGText(
            text:
                "Hôm nay, ngày .... tháng .... năm ....... tại .......... Thành phần kiểm kê chúng tôi gồm:",
            style: SettingPage.textStyle,
          ),
        ),
        SGText(text: "", style: SettingPage.textStyle),
        SGText(
          text: "   A. THÀNH PHẦN",
          style: SettingPage.textStyle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SGText(
          text: "   I. Tiểu ban kiểm kê",
          style: SettingPage.textStyle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SGText(
                    text:
                        "   1. Ông (bà):................................................................................................",
                    style: SettingPage.textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SGText(
                    text:
                        "   2. Ông (bà):................................................................................................",
                    style: SettingPage.textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SGText(
                    text:
                        "   3. Ông (bà):................................................................................................",
                    style: SettingPage.textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12 * SettingPage.scale),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SGText(
                    text:
                        "Chức vụ:................................................................................................",
                    style: SettingPage.textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SGText(
                    text:
                        "Chức vụ:................................................................................................",
                    style: SettingPage.textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SGText(
                    text:
                        "Chức vụ:................................................................................................",
                    style: SettingPage.textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        SGText(
          text: "   II. Đơn vị được kiểm kê",
          style: SettingPage.textStyle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SGText(
                    text:
                        "   1. Ông (bà): ................................................................................................",
                    style: SettingPage.textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SGText(
                    text:
                        "   2. Ông (bà): ................................................................................................",
                    style: SettingPage.textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SGText(
                    text:
                        "   3. Ông (bà): ................................................................................................",
                    style: SettingPage.textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12 * SettingPage.scale),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SGText(
                    text:
                        "Chức vụ: ................................................................................................",
                    style: SettingPage.textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SGText(
                    text:
                        "Chức vụ: ................................................................................................",
                    style: SettingPage.textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SGText(
                    text:
                        "Chức vụ: ................................................................................................",
                    style: SettingPage.textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        SGText(
          text: "   B. NỘI DUNG",
          style: SettingPage.textStyle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SGText(
          text:
              "      Tiến hành kiểm kê TSCĐ, CCDC hiện có tại đơn vị đến ngày $denNgay cụ thể như sau:",
          style: SettingPage.textStyle,
        ),
        SGText(text: "", style: SettingPage.textStyle),
    
        Table(
          border: TableBorder.all(),
          columnWidths: const {
            0: FixedColumnWidth(40),
            1: FlexColumnWidth(3),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
            5: FlexColumnWidth(1),
            6: FlexColumnWidth(1.5),
            7: FlexColumnWidth(1.5),
            8: FlexColumnWidth(1.5),
          },
          children: [
            TableRow(
              children: [
                ContractPage.tableHeader(
                  "STT",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                ContractPage.tableHeader(
                  "Tên tài sản, công cụ dụng cụ ( ký mã hiệu )",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                ContractPage.tableHeader(
                  "Đơn vị tính",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                ContractPage.tableHeader(
                  "Nước sản xuất",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                ContractPage.tableHeader(
                  "Phương thức kiểm kê",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                ContractPage.tableHeader(
                  "Số lượng kiểm kê thực tế",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                ContractPage.tableHeader(
                  "Ghi chú",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
              ],
            ),
    
            // Dữ liệu chi tiết chưa được cung cấp trong AssetHandoverDto
            for (int i = 0; i < (ccdcInventory.length); i++)
              TableRow(
                children: [
                  ContractPage.tableCell(
                    (i + 1).toString(),
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  ContractPage.tableCell(
                    ccdcInventory[i].tenTaiSan ?? '',
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  ContractPage.tableCell(
                    ccdcInventory[i].donViTinh ?? '',
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  ContractPage.tableCell(
                    ccdcInventory[i].nuocSanXuat ?? '',
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  ContractPage.tableCell(
                    "",
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  ContractPage.tableCell(
                    "",
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  ContractPage.tableCell(
                    ccdcInventory[i].ghiChu ?? '',
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                ],
              ),
          ],
        ),
        SGText(
          text:
              "      Biên bản được lập xong hồi ....... giờ cùng ngày, các thành viên thống nhất thông qua.",
          style: SettingPage.textStyle,
        ),
        SGText(text: "", style: SettingPage.textStyle),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SGText(
                    text: "   I. Tiểu ban kiểm kê",
                    style: SettingPage.textStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SGText(
                    text:
                        "   1. Phòng ..........: ................................................................................................",
                    style: SettingPage.textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SGText(
                    text:
                        "   2. Phòng ..........: ................................................................................................",
                    style: SettingPage.textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SGText(
                    text:
                        "   3. Phòng ..........: ................................................................................................",
                    style: SettingPage.textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SGText(
                    text: "   II. Đơn vị được kiểm kê",
                    style: SettingPage.textStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SGText(
                    text:
                        "   1. Ông (bà): ................................................................................................",
                    style: SettingPage.textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SGText(
                    text:
                        "   2. Ông (bà): ................................................................................................",
                    style: SettingPage.textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SGText(
                    text:
                        "   3. Ông (bà): ................................................................................................",
                    style: SettingPage.textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12 * SettingPage.scale),
            Expanded(
              child: Center(
                child: SGText(
                  text: "TRƯỞNG TIỂU BAN KIỂM KÊ",
                  style: SettingPage.textStyle.copyWith(
                    fontSize: 12 * SettingPage.scale,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
