import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/page/contract_page.dart';
import 'package:quan_ly_tai_san_app/common/widgets/editable_text.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/tai_san_co_dinh_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';

class BienBanKiemKeTaiSanCoDinhPage extends StatelessWidget {
  final List<TaiSanCoDinhDto> taiSanCoDinhList;
  final String denNgay;
  final String tenDonVi;

  const BienBanKiemKeTaiSanCoDinhPage({
    super.key,
    required this.taiSanCoDinhList,
    required this.denNgay,
    required this.tenDonVi,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderBienBanKiemKe(tenDonVi: tenDonVi, denNgay: denNgay),
        BodyBienBanKiemKe(taiSanCoDinhList: taiSanCoDinhList),
        FooterBienBanKiemKe(),
      ],
    );
  }
}

Widget buildRichHeader(String text) {
  final regex = RegExp(r'^(.*?)(\s*\(.*\))?$');
  final match = regex.firstMatch(text);

  final main = match?.group(1)?.trim() ?? text;
  final boldPart = match?.group(2);

  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      style: SettingPage.textStyle.copyWith(
        fontSize: 8 * SettingPage.scale,
        color: Colors.black,
      ),
      children: [
        TextSpan(text: main),
        if (boldPart != null)
          TextSpan(
            text: ' $boldPart',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
      ],
    ),
  );
}

class BodyBienBanKiemKe extends StatefulWidget {
  const BodyBienBanKiemKe({
    super.key,
    required this.taiSanCoDinhList,
    this.startIndex = 0,
  });
  final List<TaiSanCoDinhDto> taiSanCoDinhList;
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

      // Auto copy từ Kế toán sang Kiểm kê
      _autoCopyKeToanToKiemKe(index, field, value);

      // Auto tính chênh lệch
      _autoCalculateChenhLech(index);
    });
  }

  // Method để tự động copy từ Kế toán sang Kiểm kê
  void _autoCopyKeToanToKiemKe(int index, String field, String value) {
    if (field == 'soLuongKeToan') {
      _editedData[index]!['soLuongKiemKe'] = value;
    } else if (field == 'nguyenGiaKeToan') {
      _editedData[index]!['nguyenGiaKiemKe'] = value;
    } else if (field == 'giaTriConLaiKeToan') {
      _editedData[index]!['giaTriConLaiKiemKe'] = value;
    }
  }

  // Method để tự động tính chênh lệch
  void _autoCalculateChenhLech(int index) {
    // Tính chênh lệch số lượng
    final soLuongKeToan =
        double.tryParse(
          _getValue(
            index,
            'soLuongKeToan',
            widget.taiSanCoDinhList[index].soLuong.toString(),
          ),
        ) ??
        0;
    final soLuongKiemKe =
        double.tryParse(
          _getValue(
            index,
            'soLuongKiemKe',
            widget.taiSanCoDinhList[index].soLuong.toString(),
          ),
        ) ??
        0;
    final soLuongChenhLech = soLuongKiemKe - soLuongKeToan;
    _editedData[index]!['soLuongChenhLech'] = soLuongChenhLech.toString();

    // Tính chênh lệch nguyên giá
    final nguyenGiaKeToan =
        double.tryParse(
          _getValue(
            index,
            'nguyenGiaKeToan',
            _formatCurrency(widget.taiSanCoDinhList[index].nguyenGia),
          ),
        ) ??
        0;
    final nguyenGiaKiemKe =
        double.tryParse(
          _getValue(
            index,
            'nguyenGiaKiemKe',
            _formatCurrency(widget.taiSanCoDinhList[index].nguyenGia),
          ),
        ) ??
        0;
    final nguyenGiaChenhLech = nguyenGiaKiemKe - nguyenGiaKeToan;
    _editedData[index]!['nguyenGiaChenhLech'] = _formatCurrency(
      nguyenGiaChenhLech,
    );

    // Tính chênh lệch giá trị còn lại
    final giaTriConLaiKeToan =
        double.tryParse(
          _getValue(
            index,
            'giaTriConLaiKeToan',
            _formatCurrency(widget.taiSanCoDinhList[index].giaTriKhauHaoBanDau),
          ),
        ) ??
        0;
    final giaTriConLaiKiemKe =
        double.tryParse(
          _getValue(
            index,
            'giaTriConLaiKiemKe',
            _formatCurrency(widget.taiSanCoDinhList[index].giaTriKhauHaoBanDau),
          ),
        ) ??
        0;
    final giaTriConLaiChenhLech = giaTriConLaiKiemKe - giaTriConLaiKeToan;
    _editedData[index]!['giaTriConLaiChenhLech'] = _formatCurrency(
      giaTriConLaiChenhLech,
    );
  }

  TableCell buildHeaderCell(String text) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.top,
      child: Container(
        height: 60,
        padding: EdgeInsets.all(2.0 * SettingPage.scale),
        child: Center(child: buildRichHeader(text)),
      ),
    );
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
            fontSize: 8 * SettingPage.scale,
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
    for (int i = 0; i < widget.taiSanCoDinhList.length; i++) {
      Map<String, String> itemData = {
        'tenTaiSan': _getValue(
          i,
          'tenTaiSan',
          widget.taiSanCoDinhList[i].tenTaiSan,
        ),
        'maSo': _getValue(i, 'maSo', widget.taiSanCoDinhList[i].id),
        'noiSuDung': _getValue(
          i,
          'noiSuDung',
          widget.taiSanCoDinhList[i].idDonViHienThoi,
        ),
        'soLuongKeToan': _getValue(
          i,
          'soLuongKeToan',
          widget.taiSanCoDinhList[i].soLuong.toString(),
        ),
        'nguyenGiaKeToan': _getValue(
          i,
          'nguyenGiaKeToan',
          _formatCurrency(widget.taiSanCoDinhList[i].nguyenGia),
        ),
        'giaTriConLaiKeToan': _getValue(
          i,
          'giaTriConLaiKeToan',
          _formatCurrency(widget.taiSanCoDinhList[i].giaTriKhauHaoBanDau),
        ),
        'soLuongKiemKe': _getValue(
          i,
          'soLuongKiemKe',
          widget.taiSanCoDinhList[i].soLuong.toString(),
        ),
        'nguyenGiaKiemKe': _getValue(
          i,
          'nguyenGiaKiemKe',
          _formatCurrency(widget.taiSanCoDinhList[i].nguyenGia),
        ),
        'giaTriConLaiKiemKe': _getValue(
          i,
          'giaTriConLaiKiemKe',
          _formatCurrency(widget.taiSanCoDinhList[i].giaTriKhauHaoBanDau),
        ),
        'soLuongChenhLech': _getValue(i, 'soLuongChenhLech', '0'),
        'nguyenGiaChenhLech': _getValue(i, 'nguyenGiaChenhLech', '0'),
        'giaTriConLaiChenhLech': _getValue(i, 'giaTriConLaiChenhLech', '0'),
        'ghiChu': _getValue(i, 'ghiChu', widget.taiSanCoDinhList[i].ghiChu),
      };
      finalData.add(itemData);
    }
    return finalData;
  }

  // Method để format số tiền
  String _formatCurrency(double value) {
    if (value == 0) return '0';
    return value.toStringAsFixed(0);
  }

  // Method để khởi tạo dữ liệu ban đầu
  void _initializeData() {
    for (int i = 0; i < widget.taiSanCoDinhList.length; i++) {
      if (_editedData[i] == null) {
        _editedData[i] = {};
        // Copy dữ liệu từ Kế toán sang Kiểm kê
        _editedData[i]!['soLuongKiemKe'] =
            widget.taiSanCoDinhList[i].soLuong.toString();
        _editedData[i]!['nguyenGiaKiemKe'] = _formatCurrency(
          widget.taiSanCoDinhList[i].nguyenGia,
        );
        _editedData[i]!['giaTriConLaiKiemKe'] = _formatCurrency(
          widget.taiSanCoDinhList[i].giaTriKhauHaoBanDau,
        );
        // Tính chênh lệch ban đầu
        _autoCalculateChenhLech(i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Khởi tạo dữ liệu ban đầu
    _initializeData();

    return Table(
      border: TableBorder.all(),
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      columnWidths: const {
        0: FixedColumnWidth(40),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
        5: FlexColumnWidth(1),
        6: FlexColumnWidth(1),
        7: FlexColumnWidth(1),
        8: FlexColumnWidth(1),
        9: FlexColumnWidth(1),
        10: FlexColumnWidth(1),
        11: FlexColumnWidth(1),
        12: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          children: [
            buildHeaderCell("STT"),
            buildHeaderCell("Tên TSCĐ"),
            buildHeaderCell("Mã số"),
            buildHeaderCell("Nơi sử dụng"),
            buildHeaderCell("Số lượng (Kế toán)"),
            buildHeaderCell("Nguyên giá (Kế toán)"),
            buildHeaderCell("Giá trị còn lại (Kế toán)"),
            buildHeaderCell("Số lượng (Kiểm kê)"),
            buildHeaderCell("Nguyên giá (Kiểm kê)"),
            buildHeaderCell("Giá trị còn lại (Kiểm kê)"),
            buildHeaderCell("Số lượng (Chênh lệch)"),
            buildHeaderCell("Số lượng (Chênh lệch)"),
            buildHeaderCell("Giá trị còn lại (Chênh lệch)"),
            buildHeaderCell("Ghi chú"),
          ],
        ),

        // Dữ liệu chi tiết với khả năng chỉnh sửa
        for (int i = 0; i < (widget.taiSanCoDinhList.length); i++)
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
                        fontSize: 8 * SettingPage.scale,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              // Tên TSCĐ - có thể chỉnh sửa
              _buildEditableCell(
                i,
                'tenTaiSan',
                widget.taiSanCoDinhList[i].tenTaiSan,
                200,
              ),
              // Mã số - có thể chỉnh sửa
              _buildEditableCell(i, 'maSo', widget.taiSanCoDinhList[i].id, 100),
              // Nơi sử dụng - có thể chỉnh sửa
              _buildEditableCell(
                i,
                'noiSuDung',
                widget.taiSanCoDinhList[i].idDonViHienThoi,
                100,
              ),
              // Số lượng (Kế toán) - có thể chỉnh sửa
              _buildEditableCell(
                i,
                'soLuongKeToan',
                widget.taiSanCoDinhList[i].soLuong.toString(),
                100,
              ),
              // Nguyên giá (Kế toán) - có thể chỉnh sửa
              _buildEditableCell(
                i,
                'nguyenGiaKeToan',
                _formatCurrency(widget.taiSanCoDinhList[i].nguyenGia),
                100,
              ),
              // Giá trị còn lại (Kế toán) - có thể chỉnh sửa
              _buildEditableCell(
                i,
                'giaTriConLaiKeToan',
                _formatCurrency(widget.taiSanCoDinhList[i].giaTriKhauHaoBanDau),
                100,
              ),
              // Số lượng (Kiểm kê) - có thể chỉnh sửa
              _buildEditableCell(
                i,
                'soLuongKiemKe',
                widget.taiSanCoDinhList[i].soLuong.toString(),
                100,
              ),
              // Nguyên giá (Kiểm kê) - có thể chỉnh sửa
              _buildEditableCell(
                i,
                'nguyenGiaKiemKe',
                _formatCurrency(widget.taiSanCoDinhList[i].nguyenGia),
                100,
              ),
              // Giá trị còn lại (Kiểm kê) - có thể chỉnh sửa
              _buildEditableCell(
                i,
                'giaTriConLaiKiemKe',
                _formatCurrency(widget.taiSanCoDinhList[i].giaTriKhauHaoBanDau),
                100,
              ),
              // Số lượng (Chênh lệch) - tự động tính toán
              _buildEditableCell(
                i,
                'soLuongChenhLech',
                _getValue(i, 'soLuongChenhLech', '0'),
                100,
              ),
              _buildEditableCell(
                i,
                'nguyenGiaChenhLech',
                _getValue(i, 'nguyenGiaChenhLech', '0'),
                100,
              ),
              // Giá trị còn lại (Chênh lệch) - tự động tính toán
              _buildEditableCell(
                i,
                'giaTriConLaiChenhLech',
                _getValue(i, 'giaTriConLaiChenhLech', '0'),
                100,
              ),
              // Ghi chú - có thể chỉnh sửa
              _buildEditableCell(
                i,
                'ghiChu',
                widget.taiSanCoDinhList[i].ghiChu,
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
  // String _phong1 = '';
  // String _phong2 = '';
  // String _phong3 = '';
  // String _ongBa1 = '';
  // String _ongBa2 = '';
  // String _ongBa3 = '';

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SGText(
                    text: "  Giám đốc",
                    style: SettingPage.textStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "   (Ghi ý kiến giải quyết số chênh lệch)",
                          style: SettingPage.textStyle.copyWith(
                            fontWeight: FontWeight.w200,
                            fontSize: 10 * SettingPage.scale,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "  (Ký, họ tên, đóng dấu)",
                          style: SettingPage.textStyle.copyWith(
                            fontWeight: FontWeight.w200,
                            fontSize: 10 * SettingPage.scale,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SGText(
                    text: "  Kế toán",
                    style: SettingPage.textStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "  (Ký, họ tên,)",
                          style: SettingPage.textStyle.copyWith(
                            fontWeight: FontWeight.w200,
                            fontSize: 10 * SettingPage.scale,
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
  // String _donViOngBa1 = '';
  // String _donViOngBa2 = '';
  // String _donViOngBa3 = '';
  // String _donViChucVu1 = '';
  // String _donViChucVu2 = '';
  // String _donViChucVu3 = '';

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
                    text: "Mẫu số 05 - TSCĐ",
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
            text: "BIÊN BẢN KIỂM KÊ TÀI SẢN CỐ ĐỊNH",
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
                TextSpan(
                  text: "Thời điểm kiểm kê, ngày ",
                  style: SettingPage.textStyle,
                ),
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
                  text: " Ban kiểm kê gồm:",
                  style: SettingPage.textStyle,
                ),
              ],
            ),
          ),
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
                                "...............................................",
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
                                "...............................................",
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
                                "...............................................",
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
                                "...............................................",
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
                                "...............................................",
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
                                "...............................................",
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
            SizedBox(width: 12 * SettingPage.scale),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Đại diện",
                          style: SettingPage.textStyle,
                        ),
                        WidgetSpan(
                          child: CustomEditableText(
                            placeholder:
                                "...............................................",
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
                          text: "Đại diện",
                          style: SettingPage.textStyle,
                        ),
                        WidgetSpan(
                          child: CustomEditableText(
                            placeholder:
                                "...............................................",
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
                          text: "Đại diện",

                          style: SettingPage.textStyle,
                        ),
                        WidgetSpan(
                          child: CustomEditableText(
                            placeholder:
                                "...............................................",
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
          text: "      Đã kiểm kê TSCĐ, kết quả như sau",
          style: SettingPage.textStyle,
        ),
        SGText(text: "", style: SettingPage.textStyle),
      ],
    );
  }
}
