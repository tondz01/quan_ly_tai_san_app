import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

Widget _buildThanhPhan() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "A. THÀNH PHẦN",
        style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold),
      ),
      Text("I. Hội đồng kiểm kê", style: GoogleFonts.robotoSerif()),
      _buildThanhVien("1"),
      _buildThanhVien("2"),
      _buildThanhVien("3"),
      const SizedBox(height: 4),
      Text("II. Đơn vị được kiểm kê", style: GoogleFonts.robotoSerif()),
      _buildThanhVien("1"),
      _buildThanhVien("2"),
      _buildThanhVien("3"),
    ],
  );
}

Widget _buildThanhVien(String so) {
  return Row(
    children: [
      Text("$so. Ông (bà): ", style: GoogleFonts.robotoSerif()),
      Expanded(child: Divider()),
      Text("Chức vụ: ", style: GoogleFonts.robotoSerif()),
      Expanded(child: Divider()),
    ],
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

  // Chia thành 2 phần
  final firstPart = headers.sublist(0, 9);
  final secondPart = [headers[0]] + headers.sublist(9); // thêm Số TT vào bảng 2

  Widget buildTable(List<String> tableHeaders) {
    return Table(
      border: TableBorder.all(color: Colors.black),
      defaultColumnWidth: const FixedColumnWidth(120),
      columnWidths: {0: const FixedColumnWidth(50)},
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[300]),
          children:
              tableHeaders
                  .map(
                    (header) => Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        header,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                        softWrap: true,
                      ),
                    ),
                  )
                  .toList(),
        ),
        ...List.generate(3, (rowIndex) {
          return TableRow(
            children: List.generate(tableHeaders.length, (colIndex) {
              return Padding(
                padding: const EdgeInsets.all(6),
                child: TextFormField(
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(4),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 13),
                ),
              );
            }),
          );
        }),
      ],
    );
  }

  return Column(
    children: [
      buildTable(firstPart),
      const SizedBox(height: 8),
      buildTable(secondPart),
    ],
  );
}

class BienBanDoiChieuKiemKe extends StatefulWidget {
  const BienBanDoiChieuKiemKe({super.key});

  @override
  State<BienBanDoiChieuKiemKe> createState() => _BienBanDoiChieuKiemKeState();
}

class _BienBanDoiChieuKiemKeState extends State<BienBanDoiChieuKiemKe> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "TẬP ĐOÀN CÔNG NGHIỆP",
                    style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "THAN - KHOÁNG SẢN VIỆT NAM",
                    style: GoogleFonts.robotoSerif(),
                  ),
                  Text(
                    "CÔNG TY THAN UÔNG BÍ - TKV",
                    style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Mẫu số 03b -ĐC TSCĐ  ",
                    style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Ban hành kèm theo QĐ số           /QĐ-TUB",
                    style: GoogleFonts.robotoSerif(),
                  ),
                  Text(
                    "ngày        /11/2024 của Giám đốc Công ty ",
                    style: GoogleFonts.robotoSerif(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "BIÊN BẢN ĐỐI CHIẾU KIỂM KÊ TÀI SẢN, CÔNG CỤ DỤNG CỤ",
            style: GoogleFonts.robotoSerif(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            "Có đến thời điểm 0h ngày 01 tháng 01 năm ……",
            style: GoogleFonts.robotoSerif(),
          ),
          const SizedBox(height: 8),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Đơn vị: ………………………",
              style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          _buildThanhPhan(),
          const SizedBox(height: 12),
          _buildBangNoiDung(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "ỦY VIÊN HỘI ĐỒNG KIỂM KÊ",
                style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold),
              ),
              Text(
                "ĐƠN VỊ ĐƯỢC KIỂM KÊ",
                style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold),
              ),
              Column(
                children: [
                  Text(
                    "CHỦ TỊCH HỘI ĐỒNG",
                    style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "GIÁM ĐỐC",
                    style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
