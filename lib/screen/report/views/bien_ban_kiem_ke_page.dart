import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/page/contract_page.dart';
import 'package:quan_ly_tai_san_app/common/widgets/editable_text.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/inventory_minutes.dart';
import 'package:se_gay_components/common/sg_text.dart';

class BienBanKiemKePage extends StatelessWidget {
  final List<InventoryMinutes> inventoryMinutes;
  final String denNgay;
  final String tenDonVi;

  const BienBanKiemKePage({
    super.key,
    required this.inventoryMinutes,
    required this.denNgay,
    required this.tenDonVi,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderBienBanKiemKe(tenDonVi: tenDonVi, denNgay: denNgay),
        BodyBienBanKiemKe(inventoryMinutes: inventoryMinutes),
        FooterBienBanKiemKe(),
      ],
    );
  }
}

class BodyBienBanKiemKe extends StatefulWidget {
  const BodyBienBanKiemKe({
    super.key,
    required this.inventoryMinutes,
    this.startIndex = 0,
  });
  final List<InventoryMinutes> inventoryMinutes;
  final int startIndex;

  @override
  State<BodyBienBanKiemKe> createState() => _BodyBienBanKiemKeState();
}

class _BodyBienBanKiemKeState extends State<BodyBienBanKiemKe> {
  // Map để lưu trữ dữ liệu đã chỉnh sửa cho từng item
  Map<int, Map<String, String>> _editedData = {};

  // Method để lấy giá trị đã chỉnh sửa hoặc giá trị gốc
  String _getValue(int index, String field, String originalValue) {
    return _editedData[index]?[field] ?? originalValue;
  }

  // Method để cập nhật giá trị đã chỉnh sửa
  void _updateValue(int index, String field, String value) {
    setState(() {
      if (_editedData[index] == null) {
        _editedData[index] = {};
      }
      _editedData[index]![field] = value;
    });
  }

  // Method để tạo editable cell
  Widget _buildEditableCell(
    int index,
    String field,
    String originalValue,
    double width, {
    TextAlign textAlign = TextAlign.center,
  }) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.top,
      child: Container(
        height: 60, // Tăng chiều cao của mỗi cell
        padding: EdgeInsets.all(2.0 * SettingPage.scale),
        child: CustomEditableText(
          placeholder: originalValue.isEmpty ? "" : originalValue,
          initialValue: _getValue(index, field, originalValue),
          style: SettingPage.textStyle.copyWith(
            fontSize: 10 * SettingPage.scale,
          ),
          width: width,
          maxLines: null, // Cho phép xuống dòng
          textAlign: textAlign,
          onChanged: (value) {
            _updateValue(index, field, value);
          },
        ),
      ),
    );
  }

  // Method để lấy dữ liệu đã chỉnh sửa
  Map<int, Map<String, String>> getEditedData() {
    return _editedData;
  }

  // Method để lấy dữ liệu cuối cùng (đã chỉnh sửa hoặc gốc)
  List<Map<String, String>> getFinalData() {
    List<Map<String, String>> finalData = [];
    for (int i = 0; i < widget.inventoryMinutes.length; i++) {
      Map<String, String> itemData = {
        'tenTaiSan': _getValue(
          i,
          'tenTaiSan',
          widget.inventoryMinutes[i].tenTaiSan ?? '',
        ),
        'donViTinh': _getValue(
          i,
          'donViTinh',
          widget.inventoryMinutes[i].donViTinh,
        ),
        'nuocSanXuat': _getValue(
          i,
          'nuocSanXuat',
          widget.inventoryMinutes[i].nuocSanXuat ?? '',
        ),
        'phuongThucKiemKe': _getValue(i, 'phuongThucKiemKe', ''),
        'soLuongKiemKe': _getValue(i, 'soLuongKiemKe', ''),
        'hienTrang': _getValue(
          i,
          'hienTrang',
          widget.inventoryMinutes[i].hienTrang?.toString() ?? '',
        ),
        'ghiChu': _getValue(
          i,
          'ghiChu',
          widget.inventoryMinutes[i].ghiChu ?? '',
        ),
      };
      finalData.add(itemData);
    }
    return finalData;
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
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
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Container(
                height: 60, // Cùng chiều cao với data cells
                padding: EdgeInsets.all(2.0 * SettingPage.scale),
                child: Center(
                  child: Text(
                    "STT",
                    style: SettingPage.textStyle.copyWith(
                      fontSize: 12 * SettingPage.scale,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Container(
                height: 60,
                padding: EdgeInsets.all(2.0 * SettingPage.scale),
                child: Center(
                  child: Text(
                    "Tên tài sản, công cụ dụng cụ ( ký mã hiệu )",
                    style: SettingPage.textStyle.copyWith(
                      fontSize: 12 * SettingPage.scale,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Container(
                height: 60,
                padding: EdgeInsets.all(2.0 * SettingPage.scale),
                child: Center(
                  child: Text(
                    "Đơn vị tính",
                    style: SettingPage.textStyle.copyWith(
                      fontSize: 12 * SettingPage.scale,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Container(
                height: 60,
                padding: EdgeInsets.all(2.0 * SettingPage.scale),
                child: Center(
                  child: Text(
                    "Nước sản xuất",
                    style: SettingPage.textStyle.copyWith(
                      fontSize: 12 * SettingPage.scale,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Container(
                height: 60,
                padding: EdgeInsets.all(2.0 * SettingPage.scale),
                child: Center(
                  child: Text(
                    "Phương thức kiểm kê",
                    style: SettingPage.textStyle.copyWith(
                      fontSize: 12 * SettingPage.scale,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Container(
                height: 60,
                padding: EdgeInsets.all(2.0 * SettingPage.scale),
                child: Center(
                  child: Text(
                    "Số lượng kiểm kê thực tế",
                    style: SettingPage.textStyle.copyWith(
                      fontSize: 12 * SettingPage.scale,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Container(
                height: 60,
                padding: EdgeInsets.all(2.0 * SettingPage.scale),
                child: Center(
                  child: Text(
                    "Hiện trạng",
                    style: SettingPage.textStyle.copyWith(
                      fontSize: 12 * SettingPage.scale,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Container(
                height: 60,
                padding: EdgeInsets.all(2.0 * SettingPage.scale),
                child: Center(
                  child: Text(
                    "Ghi chú",
                    style: SettingPage.textStyle.copyWith(
                      fontSize: 12 * SettingPage.scale,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),

        // Dữ liệu chi tiết với khả năng chỉnh sửa
        for (int i = 0; i < (widget.inventoryMinutes.length); i++)
          TableRow(
            children: [
              // STT - không chỉnh sửa được
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.top,
                child: Container(
                  height: 60, // Cùng chiều cao với editable cells
                  padding: EdgeInsets.all(2.0 * SettingPage.scale),
                  child: Center(
                    child: Text(
                      (widget.startIndex + i + 1).toString(),
                      style: SettingPage.textStyle.copyWith(
                        fontSize: 12 * SettingPage.scale,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              // Tên tài sản - có thể chỉnh sửa
              _buildEditableCell(
                i,
                'tenTaiSan',
                widget.inventoryMinutes[i].tenTaiSan ?? '',
                200,
              ),
              // Đơn vị tính - có thể chỉnh sửa
              _buildEditableCell(
                i,
                'donViTinh',
                widget.inventoryMinutes[i].donViTinh,
                100,
              ),
              // Nước sản xuất - có thể chỉnh sửa
              _buildEditableCell(
                i,
                'nuocSanXuat',
                widget.inventoryMinutes[i].nuocSanXuat ?? '',
                100,
              ),
              // Phương thức kiểm kê - có thể chỉnh sửa
              _buildEditableCell(i, 'phuongThucKiemKe', '', 100),
              // Số lượng kiểm kê thực tế - có thể chỉnh sửa
              _buildEditableCell(i, 'soLuongKiemKe', '', 100),
              // Hiện trạng - có thể chỉnh sửa
              _buildEditableCell(
                i,
                'hienTrang',
                widget.inventoryMinutes[i].hienTrang?.toString() ?? '',
                150,
              ),
              // Ghi chú - có thể chỉnh sửa
              _buildEditableCell(
                i,
                'ghiChu',
                widget.inventoryMinutes[i].ghiChu ?? '',
                150,
              ),
            ],
          ),
      ],
    );
  }
}

class FooterBienBanKiemKe extends StatefulWidget {
  const FooterBienBanKiemKe({super.key});

  @override
  State<FooterBienBanKiemKe> createState() => _FooterBienBanKiemKeState();
}

class _FooterBienBanKiemKeState extends State<FooterBienBanKiemKe> {
  String _gio = '';
  String _phong1 = '';
  String _phong2 = '';
  String _phong3 = '';
  String _ongBa1 = '';
  String _ongBa2 = '';
  String _ongBa3 = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "      Biên bản được lập xong hồi ",
                style: SettingPage.textStyle,
              ),
              WidgetSpan(
                child: CustomEditableText(
                  placeholder: ".......",
                  initialValue: _gio,
                  style: SettingPage.textStyle,
                  width: 100,
                  onChanged: (value) {
                    setState(() {
                      _gio = value;
                    });
                  },
                ),
              ),
              TextSpan(
                text: " giờ cùng ngày, các thành viên thống nhất thông qua.",
                style: SettingPage.textStyle,
              ),
            ],
          ),
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
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "   1. Phòng ",
                          style: SettingPage.textStyle,
                        ),
                        WidgetSpan(
                          child: CustomEditableText(
                            placeholder: "..........",
                            initialValue: _phong1,
                            style: SettingPage.textStyle,
                            width: 300,
                            onChanged: (value) {
                              setState(() {
                                _phong1 = value;
                              });
                            },
                          ),
                        ),
                        TextSpan(text: ": ", style: SettingPage.textStyle),
                        WidgetSpan(
                          child: CustomEditableText(
                            placeholder:
                                "................................................................................................",
                            initialValue: '',
                            style: SettingPage.textStyle,
                            width: 300,
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "   2. Phòng ",
                          style: SettingPage.textStyle,
                        ),
                        WidgetSpan(
                          child: CustomEditableText(
                            placeholder: "..........",
                            initialValue: _phong2,
                            style: SettingPage.textStyle,
                            width: 300,
                            onChanged: (value) {
                              setState(() {
                                _phong2 = value;
                              });
                            },
                          ),
                        ),
                        TextSpan(text: ": ", style: SettingPage.textStyle),
                        WidgetSpan(
                          child: CustomEditableText(
                            placeholder:
                                "................................................................................................",
                            initialValue: '',
                            style: SettingPage.textStyle,
                            width: 300,
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "   3. Phòng ",
                          style: SettingPage.textStyle,
                        ),
                        WidgetSpan(
                          child: CustomEditableText(
                            placeholder: "..........",
                            initialValue: _phong3,
                            style: SettingPage.textStyle,
                            width: 300,
                            onChanged: (value) {
                              setState(() {
                                _phong3 = value;
                              });
                            },
                          ),
                        ),
                        TextSpan(text: ": ", style: SettingPage.textStyle),
                        WidgetSpan(
                          child: CustomEditableText(
                            placeholder:
                                "................................................................................................",
                            initialValue: '',
                            style: SettingPage.textStyle,
                            width: 300,
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SGText(
                    text: "   II. Đơn vị được kiểm kê",
                    style: SettingPage.textStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "   1. Ông (bà): ",
                          style: SettingPage.textStyle,
                        ),
                        WidgetSpan(
                          child: CustomEditableText(
                            placeholder:
                                "................................................................................................",
                            initialValue: _ongBa1,
                            style: SettingPage.textStyle,
                            width: 300,
                            onChanged: (value) {
                              setState(() {
                                _ongBa1 = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "   2. Ông (bà): ",
                          style: SettingPage.textStyle,
                        ),
                        WidgetSpan(
                          child: CustomEditableText(
                            placeholder:
                                "................................................................................................",
                            initialValue: _ongBa2,
                            style: SettingPage.textStyle,
                            width: 300,
                            onChanged: (value) {
                              setState(() {
                                _ongBa2 = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "   3. Ông (bà): ",
                          style: SettingPage.textStyle,
                        ),
                        WidgetSpan(
                          child: CustomEditableText(
                            placeholder:
                                "................................................................................................",
                            initialValue: _ongBa3,
                            style: SettingPage.textStyle,
                            width: 300,
                            onChanged: (value) {
                              setState(() {
                                _ongBa3 = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
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

class HeaderBienBanKiemKe extends StatefulWidget {
  const HeaderBienBanKiemKe({
    super.key,
    required this.tenDonVi,
    required this.denNgay,
  });

  final String tenDonVi;
  final String denNgay;

  @override
  State<HeaderBienBanKiemKe> createState() => _HeaderBienBanKiemKeState();
}

class _HeaderBienBanKiemKeState extends State<HeaderBienBanKiemKe> {
  String _ngay = '';
  String _thang = '';
  String _nam = '';
  String _diaDiem = '';
  String _ongBa1 = '';
  String _ongBa2 = '';
  String _ongBa3 = '';
  String _chucVu1 = '';
  String _chucVu2 = '';
  String _chucVu3 = '';
  String _donViOngBa1 = '';
  String _donViOngBa2 = '';
  String _donViOngBa3 = '';
  String _donViChucVu1 = '';
  String _donViChucVu2 = '';
  String _donViChucVu3 = '';

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
                    text: "TẬP ĐOÀN CÔNG NGHIỆP\nTHAN - KHOÁNG SẢN VIỆT NAM",
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
            text: "Đơn vị: ${widget.tenDonVi}",
            style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SGText(text: "", style: SettingPage.textStyle),
        Center(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: "Hôm nay, ngày ", style: SettingPage.textStyle),
                WidgetSpan(
                  child: CustomEditableText(
                    placeholder: "....",
                    initialValue: _ngay,
                    style: SettingPage.textStyle,
                    width: 50,
                    onChanged: (value) {
                      setState(() {
                        _ngay = value;
                      });
                    },
                  ),
                ),
                TextSpan(text: " tháng ", style: SettingPage.textStyle),
                WidgetSpan(
                  child: CustomEditableText(
                    placeholder: "....",
                    initialValue: _thang,
                    style: SettingPage.textStyle,
                    width: 50,
                    onChanged: (value) {
                      setState(() {
                        _thang = value;
                      });
                    },
                  ),
                ),
                TextSpan(text: " năm ", style: SettingPage.textStyle),
                WidgetSpan(
                  child: CustomEditableText(
                    placeholder: ".......",
                    initialValue: _nam,
                    style: SettingPage.textStyle,
                    width: 80,
                    onChanged: (value) {
                      setState(() {
                        _nam = value;
                      });
                    },
                  ),
                ),
                TextSpan(text: " tại ", style: SettingPage.textStyle),
                WidgetSpan(
                  child: CustomEditableText(
                    placeholder: "..........",
                    initialValue: _diaDiem,
                    style: SettingPage.textStyle,
                    width: 150,
                    onChanged: (value) {
                      setState(() {
                        _diaDiem = value;
                      });
                    },
                  ),
                ),
                TextSpan(
                  text: " Thành phần kiểm kê chúng tôi gồm:",
                  style: SettingPage.textStyle,
                ),
              ],
            ),
          ),
        ),
        SGText(text: "", style: SettingPage.textStyle),
        SGText(
          text: "   A. THÀNH PHẦN",
          style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold),
        ),
        SGText(
          text: "   I. Tiểu ban kiểm kê",
          style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "   1. Ông (bà):",
                          style: SettingPage.textStyle,
                        ),
                        WidgetSpan(
                          child: CustomEditableText(
                            placeholder:
                                "................................................................................................",
                            initialValue: _ongBa1,
                            style: SettingPage.textStyle,
                            width: 300,
                            onChanged: (value) {
                              setState(() {
                                _ongBa1 = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "   2. Ông (bà):",
                          style: SettingPage.textStyle,
                        ),
                        WidgetSpan(
                          child: CustomEditableText(
                            placeholder:
                                "................................................................................................",
                            initialValue: _ongBa2,
                            style: SettingPage.textStyle,
                            width: 300,
                            onChanged: (value) {
                              setState(() {
                                _ongBa2 = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "   3. Ông (bà):",
                          style: SettingPage.textStyle,
                        ),
                        WidgetSpan(
                          child: CustomEditableText(
                            placeholder:
                                "................................................................................................",
                            initialValue: _ongBa3,
                            style: SettingPage.textStyle,
                            width: 300,
                            onChanged: (value) {
                              setState(() {
                                _ongBa3 = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12 * SettingPage.scale),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Chức vụ:",
                          style: SettingPage.textStyle,
                        ),
                        WidgetSpan(
                          child: CustomEditableText(
                            placeholder:
                                "................................................................................................",
                            initialValue: _chucVu1,
                            style: SettingPage.textStyle,
                            width: 300,
                            onChanged: (value) {
                              setState(() {
                                _chucVu1 = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Chức vụ:",
                          style: SettingPage.textStyle,
                        ),
                        WidgetSpan(
                          child: CustomEditableText(
                            placeholder:
                                "................................................................................................",
                            initialValue: _chucVu2,
                            style: SettingPage.textStyle,
                            width: 300,
                            onChanged: (value) {
                              setState(() {
                                _chucVu2 = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Chức vụ:",
                          style: SettingPage.textStyle,
                        ),
                        WidgetSpan(
                          child: CustomEditableText(
                            placeholder:
                                "................................................................................................",
                            initialValue: _chucVu3,
                            style: SettingPage.textStyle,
                            width: 300,
                            onChanged: (value) {
                              setState(() {
                                _chucVu3 = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SGText(
          text: "   II. Đơn vị được kiểm kê",
          style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "   1. Ông (bà): ",
                          style: SettingPage.textStyle,
                        ),
                        WidgetSpan(
                          child: CustomEditableText(
                            placeholder:
                                "................................................................................................",
                            initialValue: _donViOngBa1,
                            style: SettingPage.textStyle,
                            width: 300,
                            onChanged: (value) {
                              setState(() {
                                _donViOngBa1 = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "   2. Ông (bà): ",
                          style: SettingPage.textStyle,
                        ),
                        WidgetSpan(
                          child: CustomEditableText(
                            placeholder:
                                "................................................................................................",
                            initialValue: _donViOngBa2,
                            style: SettingPage.textStyle,
                            width: 300,
                            onChanged: (value) {
                              setState(() {
                                _donViOngBa2 = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "   3. Ông (bà): ",
                          style: SettingPage.textStyle,
                        ),
                        WidgetSpan(
                          child: CustomEditableText(
                            placeholder:
                                "................................................................................................",
                            initialValue: _donViOngBa3,
                            style: SettingPage.textStyle,
                            width: 300,
                            onChanged: (value) {
                              setState(() {
                                _donViOngBa3 = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12 * SettingPage.scale),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Chức vụ: ",
                          style: SettingPage.textStyle,
                        ),
                        WidgetSpan(
                          child: CustomEditableText(
                            placeholder:
                                "................................................................................................",
                            initialValue: _donViChucVu1,
                            style: SettingPage.textStyle,
                            width: 300,
                            onChanged: (value) {
                              setState(() {
                                _donViChucVu1 = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Chức vụ: ",
                          style: SettingPage.textStyle,
                        ),
                        WidgetSpan(
                          child: CustomEditableText(
                            placeholder:
                                "................................................................................................",
                            initialValue: _donViChucVu2,
                            style: SettingPage.textStyle,
                            width: 300,
                            onChanged: (value) {
                              setState(() {
                                _donViChucVu2 = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Chức vụ: ",
                          style: SettingPage.textStyle,
                        ),
                        WidgetSpan(
                          child: CustomEditableText(
                            placeholder:
                                "................................................................................................",
                            initialValue: _donViChucVu3,
                            style: SettingPage.textStyle,
                            width: 300,
                            onChanged: (value) {
                              setState(() {
                                _donViChucVu3 = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SGText(
          text: "   B. NỘI DUNG",
          style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold),
        ),
        SGText(
          text:
              "      Tiến hành kiểm kê TSCĐ, CCDC hiện có tại đơn vị đến ngày ${widget.denNgay} cụ thể như sau:",
          style: SettingPage.textStyle,
        ),
        SGText(text: "", style: SettingPage.textStyle),
      ],
    );
  }
}
