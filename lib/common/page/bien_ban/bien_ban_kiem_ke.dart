import 'package:flutter/material.dart';

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

Widget bienBanKiemKe() {
  return Padding(
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
                    "Mẫu số 01a-TS  ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text("Ban hành kèm theo QĐ số           /QĐ-TUB"),
                ),
                Center(
                  child: Text("ngày        /11/2024 của Giám đốc Công ty "),
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
        Text(
          "Đơn vị: .............................................................",
        ),
        Text(
          "Hôm nay, ngày ..... tháng ..... năm .... tại .....................",
        ),
        SizedBox(height: 10),
        Text("A. THÀNH PHẦN", style: sectionTitleStyle),
        SizedBox(height: 4),
        Text("I. Tiểu ban kiểm kê"),
        ...List.generate(3, (index) {
          return Text(
            "  ${index + 1}. Ông/bà: .............................    Chức vụ: ........................",
          );
        }),
        SizedBox(height: 6),
        Text("II. Đơn vị được kiểm kê"),
        ...List.generate(3, (index) {
          return Text(
            "  ${index + 1}. Ông/bà: .............................    Chức vụ: ........................",
          );
        }),
        SizedBox(height: 10),
        Text("B. NỘI DUNG", style: sectionTitleStyle),
        SizedBox(height: 6),
        Text(
          "Tiến hành kiểm kê TSCĐ, CCDC tại đơn vị đến ngày ..... tháng ..... năm ...... như sau:",
        ),
        SizedBox(height: 10),
        Table(
          border: TableBorder.all(color: Colors.black),
          columnWidths: {
            0: FixedColumnWidth(50),
            1: FixedColumnWidth(120),
            2: FixedColumnWidth(50),
            3: FixedColumnWidth(80),
            4: FixedColumnWidth(80),
            5: FixedColumnWidth(80),
            6: FixedColumnWidth(60),
            7: FixedColumnWidth(60),
            8: FixedColumnWidth(60),
            9: FixedColumnWidth(60),
            10: FixedColumnWidth(60),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey[300]),
              children: [
                tableHeader("STT"),
                tableHeader("Tên tài sản, công cụ (ký mã hiệu)"),
                tableHeader("ĐVT"),
                tableHeader("Nước SX"),
                tableHeader("Phương thức KK"),
                tableHeader("Số lượng thực tế"),
                tableHeader("Đang sử dụng"),
                tableHeader("Không dùng"),
                tableHeader("Hỏng"),
                tableHeader("Tình trạng kỹ thuật"),
                tableHeader("Ghi chú"),
              ],
            ),
            ...List.generate(3, (index) {
              return TableRow(
                children: List.generate(11, (_) {
                  return Padding(
                    padding: EdgeInsets.all(6),
                    child: TextFormField(
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(4),
                        border: InputBorder.none,
                      ),
                    ),
                  );
                }),
              );
            }),
          ],
        ),
        SizedBox(height: 12),
        Text(
          "Biên bản được lập xong hồi ....... giờ cùng ngày, các thành viên thống nhất thông qua.",
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

        ...List.generate(
          3,
          (i) => Text("  ${i + 1}. Phòng: ........................"),
        ),
        SizedBox(height: 10),
        Text("II. Đơn vị được kiểm kê", style: sectionTitleStyle),
        ...List.generate(
          3,
          (i) => Text("  ${i + 1}. Ông/bà: ........................"),
        ),
        SizedBox(height: 30),
      ],
    ),
  );
}
