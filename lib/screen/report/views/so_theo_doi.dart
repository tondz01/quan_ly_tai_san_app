import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget _buildTable() {
  const headers = [
    "STT",
    "Tên nhãn hiệu quy cách tài sản cố định, công cụ dụng cụ",
    "Đơn vị tính",
    "Nước sản xuất",
    "Số dư đầu kỳ",
    "Tăng trong kỳ\nSố lượng",
    "Tăng trong kỳ\nLý do tăng",
    "Giảm trong kỳ\nSố lượng",
    "Giảm trong kỳ\nLý do giảm",
    "Số dư cuối kỳ\n=",
    "Tình trạng kỹ thuật",
    "Ghi chú",
  ];

  final List<DataRow> rows = [
    _sectionHeader("A", "Tài sản cố định"),
    _emptyRow(),
    _emptyRow(),
    _emptyRow(),
    _sectionHeader("B", "Công cụ dụng cụ"),
    _emptyRow(),
    _emptyRow(),
    _emptyRow(),
  ];

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: DataTable(
      headingRowHeight: 72,
      dataRowHeight: 40,
      columnSpacing: 16,
      columns:
          headers
              .map(
                (title) => DataColumn(
                  label: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              )
              .toList(),
      rows: rows,
    ),
  );
}

DataRow _sectionHeader(String stt, String label) {
  return DataRow(
    cells: [
      DataCell(Text(stt, style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold))),
      DataCell(Text(label, style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold))),
      ...List.generate(10, (_) => DataCell(Text("", style: GoogleFonts.robotoSerif()))),
    ],
  );
}

DataRow _emptyRow() {
  return DataRow(cells: List.generate(12, (_) => DataCell(Text("", style: GoogleFonts.robotoSerif()))));
}

class SoTheoDoi extends StatelessWidget {
  const SoTheoDoi({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text("TẬP ĐOÀN CÔNG NGHIỆP", style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold)),
                  Text("THAN – KHOÁNG SẢN VIỆT NAM", style: GoogleFonts.robotoSerif()),
                  Text("CÔNG TY THAN UÔNG BÍ - TKV", style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Mẫu số 01", style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold)),
                        Text(
                          "Ban hành kèm theo QĐ số .../QĐ-TUB",
                          style: GoogleFonts.robotoSerif(fontStyle: FontStyle.italic),
                        ),
                        Text(
                          "ngày .../.../.... của Giám đốc công ty",
                          style: GoogleFonts.robotoSerif(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
      
          const SizedBox(height: 12),
      
          Text(
            "SỔ THEO DÕI\nTÀI SẢN CỐ ĐỊNH VÀ CÔNG CỤ DỤNG CỤ TẠI NƠI SỬ DỤNG",
            textAlign: TextAlign.center,
            style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text("Tháng……năm……", style: GoogleFonts.robotoSerif(fontStyle: FontStyle.italic)),
          Text("(Áp dụng cho các phân xưởng)", style: GoogleFonts.robotoSerif(fontStyle: FontStyle.italic)),
      
          const SizedBox(height: 12),
          _buildTable(),
          const SizedBox(height: 12),
      
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Gửi kèm theo các Quyết định, biên bản giao nhận tăng giảm tài sản, công cụ dụng cụ trong kỳ báo cáo",
                  style: GoogleFonts.robotoSerif(),
                ),
                Text("Lưu ý: Báo cáo tháng trước vào ngày 15 hàng tháng (tháng sau)", style: GoogleFonts.robotoSerif()),
              ],
            ),
          ),
      
          const SizedBox(height: 24),
      
          // Chữ ký
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Thống kê phân xưởng\n(Ký, ghi rõ họ tên)",
                textAlign: TextAlign.center,
                style: GoogleFonts.robotoSerif(),
              ),
              Text(
                "Phó quản đốc cơ điện\n(Ký, ghi rõ họ tên)",
                textAlign: TextAlign.center,
                style: GoogleFonts.robotoSerif(),
              ),
              Text(
                "Quản đốc phân xưởng\n(Ký, ghi rõ họ tên)",
                textAlign: TextAlign.center,
                style: GoogleFonts.robotoSerif(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
