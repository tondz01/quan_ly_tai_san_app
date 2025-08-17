import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_tai_san_app/common/page/contract_page.dart';
import 'package:se_gay_components/common/sg_text.dart' show SGText;

Widget tableHeader(String text) {
  return Padding(padding: EdgeInsets.all(6), child: Text(text, style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center));
}

Widget _buildThanhPhan() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SGText(text: "A. THÀNH PHẦN", style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold)),
      Padding(
        padding: EdgeInsets.only(left: 2.0 * SettingPage.scale),
        child: SGText(text: "I. Hội đồng kiểm kê", style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold)),
      ),
      _buildThanhVien("1"),
      _buildThanhVien("2"),
      _buildThanhVien("3"),
      const SizedBox(height: 4),
      Padding(
        padding: EdgeInsets.only(left: 2.0 * SettingPage.scale),
        child: SGText(text: "II. Đơn vị được kiểm kê", style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold)),
      ),
      _buildThanhVien("1"),
      _buildThanhVien("2"),
      _buildThanhVien("3"),
    ],
  );
}

Widget _buildThanhVien(String so) {
  return Padding(
    padding: EdgeInsets.only(left: 2.0 * SettingPage.scale),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SGText(text: "$so. Ông (bà): ", style: SettingPage.textStyle),
        Expanded(child: Divider(color: Colors.black)),
        SGText(text: "Chức vụ: ", style: SettingPage.textStyle),
        Expanded(child: Divider(color: Colors.black)),
      ],
    ),
  );
}

Widget _buildBangNoiDung() {
  const headers = [
    "Số TT",
    "Tên tài sản, CCDC (Ký mã hiệu)",
    "Nước sản xuất",
    "Đơn vị tính",
    "Số lượng đầu kỳ",
    "Số tăng trong năm",
    "Số giảm trong năm",
    "Số TS trên sổ sách",
    "Số lượng TS thực tế kiểm kê",
    "Tăng",
    "Giảm",
    "Tài sản trên sổ sách",
    "Số lượng thực tế TS tại đơn vị",
    "Chênh lệch thừa (+) thiếu (-)",
    "Tình trạng kỹ thuật",
    "Ghi chú",
  ];

  // Tách làm 2 bảng
  final firstPart = headers.sublist(0, 9);
  final secondPart = [headers[0]] + headers.sublist(9); // thêm cột Số TT vào bảng 2

  Widget buildTable(List<String> tableHeaders) {
    return Table(
      border: TableBorder.all(color: Colors.black),
      defaultColumnWidth: const FlexColumnWidth(), // co giãn vừa khung
      columnWidths: const {
        0: FixedColumnWidth(50), // cột STT luôn nhỏ
      },
      children: [
        // Header
        TableRow(
          children:
              tableHeaders
                  .map(
                    (header) => Padding(
                      padding: const EdgeInsets.all(4),
                      child: SGText(
                        text: header,
                        textAlign: TextAlign.center,
                        style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 11 * SettingPage.scale),
                      ),
                    ),
                  )
                  .toList(),
        ),
        // Các dòng nhập liệu
        ...List.generate(3, (_) {
          return TableRow(
            children: List.generate(tableHeaders.length, (_) {
              return Padding(padding: EdgeInsets.all(4 * SettingPage.scale), child: SGText(text: "", style: SettingPage.textStyle.copyWith(fontSize: 11 * SettingPage.scale)));
            }),
          );
        }),
      ],
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SGText(text: "Bảng 1", style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold)),
      buildTable(firstPart),
      const SizedBox(height: 12),
      SGText(text: "Bảng 2", style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold)),
      buildTable(secondPart),
    ],
  );
}

class BienBanDoiChieuKiemKePage extends StatefulWidget {
  const BienBanDoiChieuKiemKePage({super.key});

  @override
  State<BienBanDoiChieuKiemKePage> createState() => _BienBanDoiChieuKiemKePageState();
}

class _BienBanDoiChieuKiemKePageState extends State<BienBanDoiChieuKiemKePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SGText(text: "TẬP ĐOÀN CÔNG NGHIỆP\nTHAN - KHOÁNG SẢN VIỆT NAM", style: SettingPage.textStyle, textAlign: TextAlign.center),
                      SGText(text: "CÔNG TY THAN UÔNG BÍ - TKV", style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SGText(text: "Mẫu số 03b -ĐC TSCĐ", style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      SGText(text: "Ban hành kèm theo QĐ số           /QĐ-TUB", style: SettingPage.textStyle, textAlign: TextAlign.center),
                      SGText(text: "${SettingPage.formatted('')} của Giám đốc Công ty", style: SettingPage.textStyle, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24 * SettingPage.scale),
          Center(
            child: SGText(
              text: "BIÊN BẢN ĐỐI CHIẾU KIỂM KÊ TÀI SẢN, CÔNG CỤ DỤNG CỤ",
              style: SettingPage.textStyle.copyWith(fontSize: 14 * SettingPage.scale, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: SGText(text: "Có đến thời điểm 0h ngày 01 tháng 01 năm ……", style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ),
          SizedBox(height: 12 * SettingPage.scale),
          SGText(text: "Đơn vị: ………………………", style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 12 * SettingPage.scale),
          _buildThanhPhan(),
          SizedBox(height: 12 * SettingPage.scale),
          _buildBangNoiDung(),
          SizedBox(height: 12 * SettingPage.scale),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SGText(text: "ỦY VIÊN HỘI ĐỒNG KIỂM KÊ", style: SettingPage.textStyle.copyWith(fontSize: 14 * SettingPage.scale, fontWeight: FontWeight.bold)),
              SGText(text: "ĐƠN VỊ ĐƯỢC KIỂM KÊ", style: SettingPage.textStyle.copyWith(fontSize: 14 * SettingPage.scale, fontWeight: FontWeight.bold)),
              SGText(
                text: "CHỦ TỊCH HỘI ĐỒNG\nGIÁM ĐỐC",
                style: SettingPage.textStyle.copyWith(fontSize: 14 * SettingPage.scale, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
