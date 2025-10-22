import 'dart:async';
import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_text.dart';

import '../../../common/page/contract_page.dart' show SettingPage;

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: KiemKePage()),
  );
}

class AssetRow {
  int stt;
  String ten;
  String dvt;
  String nuoc;
  String ptKiemKe;
  int soLuong;
  String hienTrang;
  String tinhTrang;
  String ghiChu;

  AssetRow({
    required this.stt,
    this.ten = '',
    this.dvt = '',
    this.nuoc = '',
    this.ptKiemKe = '',
    this.soLuong = 0,
    this.hienTrang = 'Đang sử dụng',
    this.tinhTrang = 'Tốt',
    this.ghiChu = '',
  });

  Map<String, dynamic> toJson() => {
    'stt': stt,
    'ten': ten,
    'dvt': dvt,
    'nuoc': nuoc,
    'pt_kiemke': ptKiemKe,
    'so_luong': soLuong,
    'hien_trang': hienTrang,
    'tinh_trang': tinhTrang,
    'ghi_chu': ghiChu,
  };
}

class KiemKePage extends StatefulWidget {
  const KiemKePage({super.key});

  @override
  State<KiemKePage> createState() => _KiemKePageState();
}

class _KiemKePageState extends State<KiemKePage> {
  final _rows = <AssetRow>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFromServer();
  }

  Future<void> _loadFromServer() async {
    // Giả lập API
    await Future.delayed(const Duration(milliseconds: 400));
    _rows
      ..clear()
      ..addAll([
        AssetRow(
          stt: 1,
          ten: 'Máy in HP 1020 (HP1020)',
          dvt: 'Cái',
          nuoc: 'VN',
          ptKiemKe: 'Đếm',
          soLuong: 2,
          hienTrang: 'Đang sử dụng',
          tinhTrang: 'Tốt',
        ),
        AssetRow(
          stt: 2,
          ten: 'Laptop Dell (DL-5402)',
          dvt: 'Chiếc',
          nuoc: 'CN',
          ptKiemKe: 'Đếm',
          soLuong: 5,
          hienTrang: 'Đang sử dụng',
          tinhTrang: 'Bình thường',
          ghiChu: 'Phòng KT',
        ),
        AssetRow(
          stt: 3,
          ten: 'Bàn làm việc (B-120)',
          dvt: 'Cái',
          nuoc: 'VN',
          ptKiemKe: 'Đếm',
          soLuong: 10,
          hienTrang: 'Không dùng',
          tinhTrang: 'Cần sửa',
        ),
      ]);
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = Theme.of(context).textTheme;
    return Scaffold(
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Scrollbar(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      HeaderBienBanKiemKe(),
                      AssetTable(rows: this._rows),
                      FoooterBienBanKiemKe(),
                    ],
                  ),
                ),
              ),
    );
  }
}

/// Widget: hiển thị placeholder (ví dụ '....' hoặc '......') như text; khi tap => TextField.
/// - controller: TextEditingController được binding để lấy giá trị.
/// - placeholder: text hiển thị khi rỗng.
/// - textStyle: style khi hiển thị value.
class EditablePlaceholder extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;
  final TextStyle? textStyle;

  const EditablePlaceholder({
    super.key,
    required this.controller,
    this.placeholder = '...',
    this.textStyle,
  });

  @override
  State<EditablePlaceholder> createState() => _EditablePlaceholderState();
}

class _EditablePlaceholderState extends State<EditablePlaceholder> {
  late TextEditingController _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller;
  }

  double _measurePlaceholderWidth() {
    final textStyle = widget.textStyle ?? const TextStyle(fontSize: 14);
    final painter = TextPainter(
      text: TextSpan(text: widget.placeholder, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    return painter.width + 8; // +8 để chừa khoảng padding nhỏ
  }

  @override
  Widget build(BuildContext context) {
    final width = _measurePlaceholderWidth();

    return SizedBox(
      width: width,
      child: TextField(
        controller: _internalController,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: widget.placeholder,
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
        ),
        style: widget.textStyle,
        onChanged: (_) => setState(() {}),
      ),
    );
  }
}

class HeaderBienBanKiemKe extends StatefulWidget {
  const HeaderBienBanKiemKe({super.key});

  @override
  State<HeaderBienBanKiemKe> createState() => _HeaderBienBanKiemKeState();
}

class _HeaderBienBanKiemKeState extends State<HeaderBienBanKiemKe> {
  final TextEditingController quyetDinhController = TextEditingController();
  final TextEditingController ngayQDController = TextEditingController();
  final TextEditingController thangQDController = TextEditingController();
  final TextEditingController namQDController = TextEditingController();
  final TextEditingController donViController = TextEditingController();
  final TextEditingController ngayController = TextEditingController();
  final TextEditingController thangController = TextEditingController();
  final TextEditingController namController = TextEditingController();
  final TextEditingController diaDiemController = TextEditingController();
  final TextEditingController tenTieuBanKiemKeController1 =
      TextEditingController();
  final TextEditingController tenTieuBanKiemKeController2 =
      TextEditingController();
  final TextEditingController tenTieuBanKiemKeController3 =
      TextEditingController();
  final TextEditingController chucVuTieuBanKiemKeController1 =
      TextEditingController();
  final TextEditingController chucVuTieuBanKiemKeController2 =
      TextEditingController();
  final TextEditingController chucVuTieuBanKiemKeController3 =
      TextEditingController();

  final TextEditingController tenDonViKiemKeController1 =
      TextEditingController();
  final TextEditingController tenDonViKiemKeController2 =
      TextEditingController();
  final TextEditingController tenDonViKiemKeController3 =
      TextEditingController();
  final TextEditingController chucVuDonViKiemKeController1 =
      TextEditingController();
  final TextEditingController chucVuDonViKiemKeController2 =
      TextEditingController();
  final TextEditingController chucVuDonViKiemKeController3 =
      TextEditingController();

  final TextEditingController ngayNoiDungController = TextEditingController();
  final TextEditingController thangNoiDungController = TextEditingController();
  final TextEditingController namNoiDungController = TextEditingController();
  final TextEditingController gioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // left block
              Flexible(
                flex: 6,
                fit: FlexFit.loose,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SGText(
                      text: "TẬP ĐOÀN CÔNG NGHIỆP",
                      textAlign: TextAlign.center,
                      style: SettingPage.textStyle,
                    ),
                    const SizedBox(height: 6),
                    SGText(
                      text: "THAN - KHOÁNG SẢN VIỆT NAM",
                      textAlign: TextAlign.center,
                      style: SettingPage.textStyle,
                    ),
                    const SizedBox(height: 8),
                    SGText(
                      text: "CÔNG TY THAN UÔNG BÍ - TKV",
                      textAlign: TextAlign.center,
                      style: SettingPage.textStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // small underline centered (like in image)
                    Container(
                      width: 160,
                      height: 2,
                      color: Colors.black,
                      margin: const EdgeInsets.only(top: 2),
                    ),
                  ],
                ),
              ),

              // right block
              Flexible(
                flex: 4,
                fit: FlexFit.loose,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // small title on top
                      SGText(
                        text: "Mẫu số 01a-TS",
                        style: SettingPage.textStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                  
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: SGText(
                              text: "Ban hành kèm theo QĐ số ",
                              style: SettingPage.textStyle,
                            ),
                          ),
                          EditablePlaceholder(
                            controller: quyetDinhController,
                            placeholder: "   ",
                          ),
                          SGText(text: " /QĐ-TUB", style: SettingPage.textStyle),
                        ],
                      ),
                  
                      // date line
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SGText(text: "ngày ", style: SettingPage.textStyle),
                          EditablePlaceholder(
                            controller: quyetDinhController,
                            placeholder: "   ",
                          ),
                          SGText(text: "/", style: SettingPage.textStyle),
                          EditablePlaceholder(
                            controller: thangQDController,
                            placeholder: "  ",
                          ),
                          SGText(text: "/", style: SettingPage.textStyle),
                          EditablePlaceholder(
                            controller: namQDController,
                            placeholder: "    ",
                          ),
                          SGText(
                            text: "của Giám đốc Công ty",
                            style: SettingPage.textStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // BIÊN BẢN KIỂM KÊ TSCĐ, CCDC TẠI HIỆN TRƯỜNG
          Center(
            child: SGText(
              text: "BIÊN BẢN KIỂM KÊ TSCĐ, CCDC TẠI HIỆN TRƯỜNG",
              textAlign: TextAlign.center,
              style: SettingPage.textStyle.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          // Đơn vị:........
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SGText(
                text: "Đơn vị: ",
                style: SettingPage.textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              EditablePlaceholder(
                controller: donViController,
                placeholder: "...........",
                textStyle: SettingPage.textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Hôm nay,  ngày …… tháng ….. năm ….. tại …….... Thành phần kiểm kê chúng tôi gồm:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SGText(text: "Hôm nay, ngày ", style: SettingPage.textStyle),
              EditablePlaceholder(
                controller: ngayController,
                placeholder: "......",
              ),
              SGText(text: " tháng ", style: SettingPage.textStyle),
              EditablePlaceholder(
                controller: thangController,
                placeholder: "......",
              ),
              SGText(text: " năm ", style: SettingPage.textStyle),
              EditablePlaceholder(
                controller: namController,
                placeholder: "......",
              ),
              SGText(text: " tại ", style: SettingPage.textStyle),
              EditablePlaceholder(
                controller: diaDiemController,
                placeholder: "...........",
              ),
              SGText(
                text: ". Thành phần kiểm kê chúng tôi gồm:",
                style: SettingPage.textStyle,
              ),
            ],
          ),
          SGText(
            text: "   A. THÀNH PHẦN",
            style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          SGText(
            text: "   I. Tiểu ban kiểm kê",
            style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          InputRoleWidget(
            position: 1,
            tenController: tenTieuBanKiemKeController1,
            chucVuController: chucVuTieuBanKiemKeController1,
          ),
          InputRoleWidget(
            position: 2,
            tenController: tenTieuBanKiemKeController2,
            chucVuController: chucVuTieuBanKiemKeController2,
          ),
          InputRoleWidget(
            position: 3,
            tenController: tenTieuBanKiemKeController3,
            chucVuController: chucVuTieuBanKiemKeController3,
          ),
          SGText(
            text: "   II. Đơn vị được kiểm kê",
            style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          InputRoleWidget(
            position: 1,
            tenController: tenDonViKiemKeController1,
            chucVuController: chucVuDonViKiemKeController1,
          ),
          InputRoleWidget(
            position: 2,
            tenController: tenDonViKiemKeController2,
            chucVuController: chucVuDonViKiemKeController2,
          ),
          InputRoleWidget(
            position: 3,
            tenController: tenDonViKiemKeController3,
            chucVuController: chucVuDonViKiemKeController3,
          ),

          //   B. NỘI DUNG
          SGText(
            text: "   B. NỘI DUNG",
            style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold),
          ),

          //Tiến hành kiểm kê TSCĐ, CCDC hiện có tại đơn vị đến ngày…..tháng…..năm….. cụ thể như sau:
          Row(
            children: [
              SGText(
                text:
                    "       Tiến hành kiểm kê TSCĐ, CCDC hiện có tại đơn vị đến ngày",
                style: SettingPage.textStyle,
              ),
              EditablePlaceholder(
                controller: ngayNoiDungController,
                placeholder: "...",
                textStyle: SettingPage.textStyle,
              ),
              SGText(text: "tháng", style: SettingPage.textStyle),
              EditablePlaceholder(
                controller: thangNoiDungController,
                placeholder: "...",
                textStyle: SettingPage.textStyle,
              ),
              SGText(text: "năm", style: SettingPage.textStyle),
              EditablePlaceholder(
                controller: namNoiDungController,
                placeholder: "...",
                textStyle: SettingPage.textStyle,
              ),
              SGText(text: "cụ thể như sau:", style: SettingPage.textStyle),
            ],
          ),

          //Biên bản được lập xong hồi……..giờ cùng ngày, các thành viên thống nhất thông qua.
          Row(
            children: [
              SGText(
                text: "       Biên bản được lập xong hồi ",
                style: SettingPage.textStyle,
              ),
              EditablePlaceholder(
                controller: gioController,
                placeholder: "...",
                textStyle: SettingPage.textStyle,
              ),
              SGText(
                text: " giờ cùng ngày, các thành viên thống nhất thông qua.",
                style: SettingPage.textStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InputRoleWidget extends StatefulWidget {
  final int position;
  final TextEditingController tenController;
  final TextEditingController chucVuController;

  const InputRoleWidget({
    super.key,
    required this.position,
    required this.tenController,
    required this.chucVuController,
  });

  @override
  State<InputRoleWidget> createState() => _InputRoleWidgetState();
}

class _InputRoleWidgetState extends State<InputRoleWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SGText(
          text: "   ${widget.position} Ông (bà) ",
          style: SettingPage.textStyle,
        ),
        EditablePlaceholder(
          controller: widget.tenController,
          placeholder: "                                         ",
        ),
        SGText(text: "Chức vụ: ", style: SettingPage.textStyle),
        EditablePlaceholder(
          controller: widget.chucVuController,
          placeholder: ".........................................",
        ),
      ],
    );
  }
}

//table asset
class AssetTable extends StatelessWidget {
  final List<AssetRow> rows;

  const AssetTable({super.key, this.rows = const <AssetRow>[]});

  // Tỷ lệ flex cho các cột
  final int _flexStt = 1;
  final int _flexTenTs = 5;
  final int _flexDvt = 2;
  final int _flexNuocSx = 3;
  final int _flexPtKiemKe = 3;
  final int _flexSlKiemKe = 3;
  final int _flexHienTrangSub = 2; // Mỗi cột con trong "Hiện trạng"
  final int _flexTinhTrangKt = 3;
  final int _flexGhiChu = 3;

  // Tính tổng flex cho cột "Hiện trạng"
  int get _flexHienTrang => _flexHienTrangSub * 3;

  @override
  Widget build(BuildContext context) {
    // Dùng Column để xếp header và các dòng dữ liệu
    return Container(
      width: 1200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          _buildDataRow(rows.elementAtOrNull(0)),
          _buildDataRow(rows.elementAtOrNull(1)),
          _buildDataRow(rows.elementAtOrNull(2)),
          _buildDataRow(rows.elementAtOrNull(3)),
          _buildDataRow(rows.elementAtOrNull(4)),
        ],
      ),
    );
  }

  /// Xây dựng phần Header của bảng
  Widget _buildHeader() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderCell('STT', _flexStt),
          _buildHeaderCell(
            'Tên tài sản, công cụ dụng cụ ( ký mã hiệu )',
            _flexTenTs,
          ),
          _buildHeaderCell('Đơn vị tính', _flexDvt),
          _buildHeaderCell('Nước sản xuất', _flexNuocSx),
          _buildHeaderCell('Phương thức kiểm kê', _flexPtKiemKe),
          _buildHeaderCell('Số lượng kiểm kê', _flexSlKiemKe),

          // Cột "Hiện trạng" gộp
          Expanded(
            flex: _flexHienTrang,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeaderCell('Hiện trạng', 1, isComplexHeaderTop: true),
                // '1' ở đây không quan trọng
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeaderCell(
                        'Đang sử dụng',
                        _flexHienTrangSub,
                        isSubHeader: true,
                      ),
                      _buildHeaderCell(
                        'Không dùng',
                        _flexHienTrangSub,
                        isSubHeader: true,
                      ),
                      _buildHeaderCell(
                        'Hỏng',
                        _flexHienTrangSub,
                        isSubHeader: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          _buildHeaderCell('Tình trạng kỹ thuật', _flexTinhTrangKt),
          _buildHeaderCell('Ghi chú', _flexGhiChu, isLast: true),
        ],
      ),
    );
  }

  void updateData(int dataIndex, String value) {
    debugPrint('Updated cell $dataIndex: $value');
  }

  /// Xây dựng một dòng dữ liệu
  Widget _buildDataRow(AssetRow? data) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DataCell(
            text: data?.stt.toString() ?? '',
            flex: _flexStt,
            isLast: false,
            updateData: (value) => updateData(0, value),
          ),
          DataCell(
            text: data?.ten ?? '',
            flex: _flexTenTs,
            isLast: false,
            updateData: (value) => updateData(1, value),
          ),
          DataCell(
            text: data?.dvt ?? '',
            flex: _flexDvt,
            isLast: false,
            updateData: (value) => updateData(2, value),
          ),
          DataCell(
            text: data?.nuoc ?? '',
            flex: _flexNuocSx,
            isLast: false,
            updateData: (value) => updateData(3, value),
          ),
          DataCell(
            text: data?.ptKiemKe ?? '',
            flex: _flexPtKiemKe,
            isLast: false,
            updateData: (value) => updateData(4, value),
          ),
          DataCell(
            text: data?.soLuong.toString() ?? '',
            flex: _flexSlKiemKe,
            isLast: false,
            updateData: (value) => updateData(5, value),
          ),

          // 3 cột con của "Hiện trạng"
          DataCell(
            text: '',
            flex: _flexHienTrangSub,
            isLast: false,
            updateData: (value) => updateData(6, value),
          ),
          DataCell(
            text: '',
            flex: _flexHienTrangSub,
            isLast: false,
            updateData: (value) => updateData(7, value),
          ),
          DataCell(
            text: '',
            flex: _flexHienTrangSub,
            isLast: false,
            updateData: (value) => updateData(8, value),
          ),

          DataCell(
            text: '',
            flex: _flexTinhTrangKt,
            isLast: false,
            updateData: (value) => updateData(9, value),
          ),
          DataCell(
            text: '',
            flex: _flexGhiChu,
            isLast: true,
            updateData: (value) => updateData(10, value),
          ),
        ],
      ),
    );
  }

  /// Widget tùy chỉnh cho Ô Header
  Widget _buildHeaderCell(
    String text,
    int flex, {
    bool isSubHeader = false,
    bool isLast = false,
    bool isComplexHeaderTop = false,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: const BorderSide(color: Colors.black, width: 1.0),
            // Chỉ vẽ border bên phải, trừ ô cuối cùng
            right:
                isLast
                    ? BorderSide.none
                    : const BorderSide(color: Colors.black, width: 0.5),
            // Border bên trái cho ô con đầu tiên
            left:
                (isSubHeader)
                    ? const BorderSide(color: Colors.black, width: 0.5)
                    : BorderSide.none,
            // Xóa top border cho ô con
            top:
                (isSubHeader || isComplexHeaderTop)
                    ? BorderSide.none
                    : const BorderSide(color: Colors.black, width: 0.5),
          ),
          color: Colors.grey[200],
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class DataCell extends StatefulWidget {
  final ValueSetter<String> updateData;
  final String text;
  final bool isLast;
  final int flex;

  const DataCell({
    super.key,
    required this.updateData,
    required String this.text,
    required bool this.isLast,
    required int this.flex,
  });

  @override
  State<DataCell> createState() => _DataCellState();
}

class _DataCellState extends State<DataCell> {
  late TextEditingController textController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textController = TextEditingController(text: widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border(
            // Các dòng dữ liệu chỉ cần border
            bottom: const BorderSide(color: Colors.black, width: 0.5),
            right:
                widget.isLast
                    ? BorderSide.none
                    : const BorderSide(color: Colors.black, width: 0.5),
          ),
        ),
        child: TextField(
          controller: textController,
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 4),
          ),
          onChanged: (text) {
            widget.updateData(text);
          },
        ),
      ),
    );
  }
}

// footer
class FoooterBienBanKiemKe extends StatefulWidget {
  const FoooterBienBanKiemKe({super.key});

  @override
  State<FoooterBienBanKiemKe> createState() => _FoooterBienBanKiemKeState();
}

class _FoooterBienBanKiemKeState extends State<FoooterBienBanKiemKe> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // left block
              Flexible(
                flex: 6,
                fit: FlexFit.loose,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SGText(
                        text: "   I  Tiểu ban kiểm kê",
                        textAlign: TextAlign.center,
                        style: SettingPage.textStyle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FooterRowPhongWidget(stt: "1"),
                      FooterRowPhongWidget(stt: "2"),
                      FooterRowPhongWidget(stt: "3"),
                      SGText(text: ""),
                      SGText(
                        text: "   II  Tiểu ban kiểm kê",
                        textAlign: TextAlign.center,
                        style: SettingPage.textStyle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FooterRowOngBaWidget(stt: "1"),
                      FooterRowOngBaWidget(stt: "2"),
                      FooterRowOngBaWidget(stt: "3"),
                    ],
                  ),
                ),
              ),

              // right block
              Flexible(
                flex: 4,
                fit: FlexFit.loose,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // small title on top
                    Center(
                      child: SGText(
                        text: "TRƯỞNG TIỂU BAN KIỂM KÊ",
                        style: SettingPage.textStyle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FooterRowPhongWidget extends StatelessWidget {
  final String stt;
  final TextEditingController phongController;
  final TextEditingController phongDescriptionController;

  FooterRowPhongWidget({
    super.key,
    required this.stt,
    TextEditingController? phongController,
    TextEditingController? phongDescriptionController,
  }) : this.phongController = phongController ?? TextEditingController(),
       this.phongDescriptionController =
           phongDescriptionController ?? TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SGText(text: "  $stt. Phòng ", style: SettingPage.textStyle),
        EditablePlaceholder(
          controller: phongController,
          placeholder: "....",
          textStyle: SettingPage.textStyle,
        ),
        SGText(text: ": ", style: SettingPage.textStyle),
        EditablePlaceholder(
          controller: phongDescriptionController,
          placeholder: ".............................................",
          textStyle: SettingPage.textStyle,
        ),
      ],
    );
  }
}

class FooterRowOngBaWidget extends StatelessWidget {
  final String stt;
  final TextEditingController nameController;

  FooterRowOngBaWidget({
    super.key,
    required this.stt,
    TextEditingController? nameController,
  }) : this.nameController = nameController ?? TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SGText(
          text: "  $stt. Ông (bà): ",
          style: SettingPage.textStyle,
        ),
        EditablePlaceholder(
          controller: nameController,
          placeholder: "...............................................",
          textStyle: SettingPage.textStyle,
        ),
      ],
    );
  }
}


