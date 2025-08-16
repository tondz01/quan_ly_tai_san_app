import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';

final TextStyle titleStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 16,
);

final TextStyle sectionTitleStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 14,
  color: Colors.black,
);

Widget tableHeader(String text) {
  return Padding(
    padding: EdgeInsets.all(6),
    child: Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
  );
}

Widget tableCell(String text) =>
    Padding(padding: const EdgeInsets.all(6), child: Text(text));

class BienBanKiemKePage extends StatelessWidget {
  final AssetHandoverDto assetHandoverDto;
  final List<ChiTietDieuDongTaiSan> chiTietDieuDongTaiSans;

  const BienBanKiemKePage({
    super.key,
    required this.assetHandoverDto,
    required this.chiTietDieuDongTaiSans,
  });


  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final day = DateFormat('dd').format(now);
    final month = DateFormat('MM').format(now);
    final year = DateFormat('yyyy').format(now);

    final hours = DateFormat('HH').format(now);
    final minutes = DateFormat('mm').format(now);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Center(
                      child: Text(
                        "TẬP ĐOÀN CÔNG NGHIỆP THAN - KHOÁNG SẢN VIỆT NAM",
                      ),
                    ),
                    Center(
                      child: Text(
                        "CÔNG TY THAN UÔNG BÍ - TKV",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Center(
                      child: Text(
                        "Ban hành kèm theo QĐ số ${assetHandoverDto.quyetDinhDieuDongSo} /QĐ-TUB",
                      ),
                    ),
                    Center(
                      child: Text(
                        "ngày  $day/$month/$year của Giám đốc Công ty ",
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 8),
            Center(
              child: Text(
                "BIÊN BẢN KIỂM KÊ TSCĐ, CCDC TẠI HIỆN TRƯỜNG",
                style: titleStyle,
              ),
            ),
            SizedBox(height: 10),
            Text("Đơn vị: ${assetHandoverDto.tenDonViNhan}"),
            Text(
              "Hôm nay, ngày $day tháng $month năm $year tại ${assetHandoverDto.tenDonViNhan}",
            ),
            SizedBox(height: 10),
            Text("A. THÀNH PHẦN", style: sectionTitleStyle),
            SizedBox(height: 4),
            Text("I. Tiểu ban kiểm kê"),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "1. Ông/bà: ${assetHandoverDto.tenDaiDienBanHanhQD}    Chức vụ: ........................",
                ),
                Text(
                  "2. Ông/bà: ${assetHandoverDto.tenDaiDienBenGiao}    Chức vụ: ........................",
                ),
              ],
            ),
            SizedBox(height: 6),
            Text("II. Đơn vị được kiểm kê"),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "1. Ông/bà: ${assetHandoverDto.tenDaiDienBanHanhQD}    Chức vụ: ........................",
                ),
                Text(
                  "2. Ông/bà: ${assetHandoverDto.tenDaiDienBenNhan}    Chức vụ: ........................",
                ),
              ],
            ),
            SizedBox(height: 10),
            Text("B. NỘI DUNG", style: sectionTitleStyle),
            SizedBox(height: 6),
            Text(
              "Tiến hành kiểm kê TSCĐ, CCDC tại đơn vị đến ngày ${assetHandoverDto.ngayBanGiao} như sau:",
            ),
            SizedBox(height: 10),
            Table(
              border: TableBorder.all(color: Colors.black),
              columnWidths: const {
                0: FixedColumnWidth(50),
                1: FixedColumnWidth(120),
                2: FixedColumnWidth(50),
                3: FixedColumnWidth(80),
                4: FixedColumnWidth(80),
                5: FixedColumnWidth(80),
              },
              children: [
                // header
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: [
                    tableHeader("STT"),
                    tableHeader("Tên tài sản, công cụ (ký mã hiệu)"),
                    tableHeader("ĐVT"),
                    tableHeader("Số lượng thực tế"),
                    tableHeader("Tình trạng kỹ thuật"),
                    tableHeader("Ghi chú"),
                  ],
                ),
                // dữ liệu từ _list
                ...chiTietDieuDongTaiSans.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final item = entry.value;

                  return TableRow(
                    decoration: BoxDecoration(
                      color: index.isEven ? Colors.grey[50] : Colors.white,
                    ),
                    children: [
                      tableCell(index.toString()),
                      tableCell(item.tenTaiSan ?? ''),
                      tableCell(item.donViTinh ?? ''),
                      tableCell(item.soLuong.toString()),
                      tableCell(item.hienTrang == 1 ? "Tốt" : "Hỏng"),
                      tableCell(item.ghiChu), // Ghi chú
                    ],
                  );
                }),

                // thêm 3 dòng trống nhập liệu

              ],
            ),

            SizedBox(height: 12),
            Text(
              "Biên bản được lập xong hồi  ${hours}:${minutes} giờ cùng ngày, các thành viên thống nhất thông qua.",
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("I. Tiểu ban kiểm kê", style: sectionTitleStyle),
                Text("TRƯỞNG TIỂU BAN KIỂM KÊ", style: sectionTitleStyle),
              ],
            ),
            SizedBox(height: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("1. Phòng: ${assetHandoverDto.tenDonViNhan}"),
                Text("2. Phòng: ${assetHandoverDto.tenDonViGiao}"),
              ],
            ),

            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "1. Ông/bà: ${assetHandoverDto.tenDaiDienBanHanhQD}    Chức vụ: ........................",
                ),
                Text(
                  "2. Ông/bà: ${assetHandoverDto.tenDaiDienBenGiao}    Chức vụ: ........................",
                ),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
