import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_tai_san_app/screen/home/scroll_controller.dart';

TableRow headerRow(List<String> cells) {
  return TableRow(
    decoration: const BoxDecoration(color: Color(0xFFEFEFEF)),
    children:
        cells.map((text) {
          return Container(
            padding: const EdgeInsets.all(6),
            alignment: Alignment.center,
            child: Text(
              text,
              style: GoogleFonts.robotoSerif(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }).toList(),
  );
}

TableRow dataRow(List<String> cells) {
  return TableRow(
    children:
        cells.map((text) {
          return Container(
            padding: const EdgeInsets.all(6),
            height: 50,
            alignment: Alignment.center,
            child: Text(
              text,
              style: GoogleFonts.robotoSerif(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          );
        }).toList(),
  );
}

class SoTaiSanCoDinh extends StatefulWidget {
  const SoTaiSanCoDinh({super.key});

  @override
  State<SoTaiSanCoDinh> createState() => _SoTaiSanCoDinhState();
}

class _SoTaiSanCoDinhState extends State<SoTaiSanCoDinh> {
  late HomeScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = HomeScrollController();
    _scrollController.addListener((_onScrollStateChanged));
  }

  void _onScrollStateChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        return true; // Xử lý scroll event bình thường
      },
      child: SingleChildScrollView(
        physics:
            _scrollController.isParentScrolling
                ? const NeverScrollableScrollPhysics() // Parent đang cuộn => ngăn child cuộn
                : const BouncingScrollPhysics(), // Parent đã cuộn hết => cho phép child cuộn
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Đơn vị:............................         Mẫu số S21-DN",
                style: GoogleFonts.robotoSerif(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Địa chỉ:.............................",
                style: GoogleFonts.robotoSerif(fontSize: 13),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  "SỔ TÀI SẢN CỐ ĐỊNH",
                  style: GoogleFonts.robotoSerif(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Năm:.............",
                style: GoogleFonts.robotoSerif(fontSize: 13),
              ),
              Text(
                "Loại tài sản:.............",
                style: GoogleFonts.robotoSerif(fontSize: 13),
              ),
              const SizedBox(height: 16),
              Table(
                border: TableBorder.all(color: Colors.black, width: 1),
                columnWidths: const {
                  0: FixedColumnWidth(40),
                  1: FixedColumnWidth(80),
                  2: FixedColumnWidth(80),
                  3: FixedColumnWidth(120),
                  4: FixedColumnWidth(100),
                  5: FixedColumnWidth(80),
                  6: FixedColumnWidth(100),
                  7: FixedColumnWidth(100),
                  8: FixedColumnWidth(100),
                  9: FixedColumnWidth(60),
                  10: FixedColumnWidth(100),
                  11: FixedColumnWidth(100),
                  12: FixedColumnWidth(100),
                  13: FixedColumnWidth(100),
                  14: FixedColumnWidth(100),
                },
                children: [
                  headerRow([
                    'STT',
                    'Số hiệu',
                    'Ngày tháng',
                    'Tên, đặc điểm, ký hiệu TSCĐ',
                    'Nước sản xuất',
                    'Tháng năm đưa vào sử dụng',
                    'Số hiệu TSCĐ',
                    'Nguyên giá TSCĐ',
                    'Tỷ lệ (%) khấu hao',
                    'Mức khấu hao',
                    'Đã tính đến khi ghi giảm TSCĐ',
                    'Số hiệu',
                    'Ngày, tháng, năm',
                    'Lý do giảm TSCĐ',
                    '',
                  ]),
                  for (int i = 0; i < 5; i++)
                    dataRow(List.generate(15, (index) => '')),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "- Sổ này có ....... trang, đánh số từ trang 01 đến trang ....",
                style: GoogleFonts.robotoSerif(fontSize: 13),
              ),
              Text(
                "- Ngày mở sổ: ......",
                style: GoogleFonts.robotoSerif(fontSize: 13),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        "Người ghi sổ",
                        style: GoogleFonts.robotoSerif(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "(Ký, họ tên)",
                        style: GoogleFonts.robotoSerif(fontSize: 12),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Kế toán trưởng",
                        style: GoogleFonts.robotoSerif(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "(Ký, họ tên)",
                        style: GoogleFonts.robotoSerif(fontSize: 12),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Giám đốc",
                        style: GoogleFonts.robotoSerif(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "(Ký, họ tên, đóng dấu)",
                        style: GoogleFonts.robotoSerif(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Ngày......tháng......năm.........",
                style: GoogleFonts.robotoSerif(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
