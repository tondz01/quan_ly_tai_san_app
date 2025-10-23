import 'dart:async';
import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_text.dart';

import '../../../common/page/contract_page.dart' show SettingPage;

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: KiemKeTaiSanCoDinhPage(),
    ),
  );
}

class KiemKeTaiSanCoDinhPage extends StatefulWidget {
  const KiemKeTaiSanCoDinhPage({super.key});

  @override
  State<KiemKeTaiSanCoDinhPage> createState() => _KiemKeTaiSanCoDinhPageState();
}

class _KiemKeTaiSanCoDinhPageState extends State<KiemKeTaiSanCoDinhPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = Theme.of(context).textTheme;
    return Scaffold(
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HeaderBienBanKiemKe(),
              KiemKeTSCDTable(),
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
  final TextEditingController boPhanController = TextEditingController();
  final TextEditingController ngayThamChieuController = TextEditingController();
  final TextEditingController thangThamChieuController =
  TextEditingController();
  final TextEditingController namThamChieuController = TextEditingController();

  final TextEditingController gioKiemKeController = TextEditingController();
  final TextEditingController ngayKiemKeController = TextEditingController();
  final TextEditingController thangKiemKeController = TextEditingController();
  final TextEditingController namKiemKeController = TextEditingController();

  final TextEditingController diaDiemController = TextEditingController();

  final TextEditingController tenController1 = TextEditingController();
  final TextEditingController tenController2 = TextEditingController();
  final TextEditingController tenController3 = TextEditingController();
  final TextEditingController chucVuController1 = TextEditingController();
  final TextEditingController chucVuController2 = TextEditingController();
  final TextEditingController chucVuController3 = TextEditingController();
  final TextEditingController daiDienController1 = TextEditingController();
  final TextEditingController daiDienController2 = TextEditingController();
  final TextEditingController daiDienController3 = TextEditingController();

  final TextEditingController gioNoiDungController = TextEditingController();
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
                    // Đơn vị:........
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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

                    // Đơn vị:........
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SGText(
                          text: "Bộ phận: ",
                          style: SettingPage.textStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        EditablePlaceholder(
                          controller: boPhanController,
                          placeholder: "...........",
                          textStyle: SettingPage.textStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
                        text: "Mẫu số 05-ĐC TSCĐ",
                        style: SettingPage.textStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      SGText(
                        text: "(Ban hành theo Thông tư số 24/2017/TT-BTC ",
                        style: SettingPage.textStyle,
                        textAlign: TextAlign.center,
                      ),

                      SGText(
                        text: "ngày 28/3/2017 của Bộ Tài chính)",
                        style: SettingPage.textStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // BIÊN BẢN KIỂM KÊ TÀI SẢN CỐ ĐỊNH
          Center(
            child: SGText(
              text: "BIÊN BẢN KIỂM KÊ TÀI SẢN CỐ ĐỊNH",
              textAlign: TextAlign.center,
              style: SettingPage.textStyle.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          // Thời điểm kiểm kê 0h ngày  01  tháng  01  năm…….
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SGText(
                text: "Thời điểm kiểm kê ",
                style: SettingPage.textStyle.copyWith(
                ),
              ),
              EditablePlaceholder(
                controller: gioKiemKeController,
                placeholder: "......",
              ),
              SGText(text: " ngày ", style: SettingPage.textStyle),
              EditablePlaceholder(
                controller: ngayKiemKeController,
                placeholder: "......",
              ),
              SGText(text: " tháng ", style: SettingPage.textStyle),
              EditablePlaceholder(
                controller: thangKiemKeController,
                placeholder: "......",
              ),
              SGText(text: " năm ", style: SettingPage.textStyle),
              EditablePlaceholder(
                controller: namKiemKeController,
                placeholder: "......",
              ),
              SGText(text: " Ban kiểm kê gồm: ", style: SettingPage.textStyle),
            ],
          ),

          StartingQuantityWidget( tenController: tenController1, chucVuController: chucVuController1, daiDienController: daiDienController1, chucDanh: "Trưởng ban"),
          StartingQuantityWidget( tenController: tenController2, chucVuController: chucVuController2, daiDienController: daiDienController2, chucDanh: "Ủy viên"),
          StartingQuantityWidget( tenController: tenController3, chucVuController: chucVuController3, daiDienController: daiDienController3, chucDanh: "Ủy viên"),

        ],
      ),
    );
  }
}

class StartingQuantityWidget extends StatefulWidget {
  final TextEditingController tenController;
  final TextEditingController chucVuController;
  final TextEditingController daiDienController;
  final String chucDanh;

  const StartingQuantityWidget({
    super.key,
    required this.tenController,
    required this.chucVuController,
    required this.daiDienController,
    required this.chucDanh,
  });

  @override
  State<StartingQuantityWidget> createState() => _StartingQuantityWidgetState();
}

class _StartingQuantityWidgetState extends State<StartingQuantityWidget> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SGText(
          text: "- Ông/Bà ",
          style: SettingPage.textStyle,
        ),
        EditablePlaceholder(
          controller: widget.tenController,
          placeholder: ".................................................",
        ),
        SGText(text: " Chức vụ: ", style: SettingPage.textStyle),
        EditablePlaceholder(
          controller: widget.chucVuController,
          placeholder: "...............................",
        ),
        SGText(text: " Đại diện ", style: SettingPage.textStyle),
        EditablePlaceholder(
          controller: widget.daiDienController,
          placeholder: "............................................",
        ),
        SGText(text: "${widget.chucDanh}", style: SettingPage.textStyle),
      ],
    );
  }
}

/// 1. Data Model để giữ controller cho 1 hàng
class KiemKeRowData {
  final TextEditingController stt;
  final TextEditingController tenTscd;
  final TextEditingController maSo;
  final TextEditingController noiSd;
  // Theo sổ kế toán
  final TextEditingController soKtSl;
  final TextEditingController soKtNguyenGia;
  final TextEditingController soKtGtConLai;
  // Theo kiểm kê
  final TextEditingController kiemKeSl;
  final TextEditingController kiemKeNguyenGia;
  final TextEditingController kiemKeGtConLai;
  // Chênh lệch
  final TextEditingController chenhLechSl;
  final TextEditingController chenhLechNguyenGia;
  final TextEditingController chenhLechGtConLai;
  final TextEditingController ghiChu;

  KiemKeRowData({
    String stt = '',
    String tenTscd = '',
    String maSo = '',
    String noiSd = '',
    String soKtSl = '',
    String soKtNguyenGia = '',
    String soKtGtConLai = '',
    String kiemKeSl = '',
    String kiemKeNguyenGia = '',
    String kiemKeGtConLai = '',
    String chenhLechSl = '',
    String chenhLechNguyenGia = '',
    String chenhLechGtConLai = '',
    String ghiChu = '',
  })  : stt = TextEditingController(text: stt),
        tenTscd = TextEditingController(text: tenTscd),
        maSo = TextEditingController(text: maSo),
        noiSd = TextEditingController(text: noiSd),
        soKtSl = TextEditingController(text: soKtSl),
        soKtNguyenGia = TextEditingController(text: soKtNguyenGia),
        soKtGtConLai = TextEditingController(text: soKtGtConLai),
        kiemKeSl = TextEditingController(text: kiemKeSl),
        kiemKeNguyenGia = TextEditingController(text: kiemKeNguyenGia),
        kiemKeGtConLai = TextEditingController(text: kiemKeGtConLai),
        chenhLechSl = TextEditingController(text: chenhLechSl),
        chenhLechNguyenGia = TextEditingController(text: chenhLechNguyenGia),
        chenhLechGtConLai = TextEditingController(text: chenhLechGtConLai),
        ghiChu = TextEditingController(text: ghiChu);

  void dispose() {
    // Hủy tất cả controller
    stt.dispose();
    tenTscd.dispose();
    maSo.dispose();
    noiSd.dispose();
    soKtSl.dispose();
    soKtNguyenGia.dispose();
    soKtGtConLai.dispose();
    kiemKeSl.dispose();
    kiemKeNguyenGia.dispose();
    kiemKeGtConLai.dispose();
    chenhLechSl.dispose();
    chenhLechNguyenGia.dispose();
    chenhLechGtConLai.dispose();
    ghiChu.dispose();
  }
}

/// 2. Widget Bảng (Stateful)
class KiemKeTSCDTable extends StatefulWidget {
  const KiemKeTSCDTable({super.key});

  @override
  State<KiemKeTSCDTable> createState() => _KiemKeTSCDTableState();
}

class _KiemKeTSCDTableState extends State<KiemKeTSCDTable> {
  final List<KiemKeRowData> _dataRows = [];

  late final KiemKeRowData _headerRow3Data;
  late final KiemKeRowData _totalRowData;

  // Định nghĩa flex
  final int _flexStt = 1;
  final int _flexTen = 4;
  final int _flexMa = 2;
  final int _flexNoiSd = 2;
  final int _flexSoLieuSub = 2;
  final int _flexGhiChu = 3;
  int get _flexSoKt => _flexSoLieuSub * 3;
  int get _flexKiemKe => _flexSoLieuSub * 3;
  int get _flexChenhLech => _flexSoLieuSub * 3;

  @override
  void initState() {
    super.initState();

    _headerRow3Data = KiemKeRowData(
      stt: 'A',
      tenTscd: 'B',
      maSo: 'C',
      noiSd: 'D',
      soKtSl: '1',
      soKtNguyenGia: '2',
      soKtGtConLai: '3',
      kiemKeSl: '4',
      kiemKeNguyenGia: '5',
      kiemKeGtConLai: '6',
      chenhLechSl: '7',
      chenhLechNguyenGia: '8',
      chenhLechGtConLai: '9',
      ghiChu: '10',
    );

    _totalRowData = KiemKeRowData(
      stt: 'Cộng',
      tenTscd: 'x',
      maSo: 'x',
      noiSd: 'x',
      // Để trống các ô tính toán
      kiemKeSl: 'x',
      chenhLechSl: 'x',
      ghiChu: 'x',
    );

    // Tạo 2 hàng dữ liệu mẫu
    _dataRows.add(KiemKeRowData(
      stt: '1',
      tenTscd: 'Máy vi tính Dell',
      maSo: 'TSCĐ-001',
      noiSd: 'Phòng Kế toán',
      soKtSl: '1',
      soKtNguyenGia: '20000000',
    ));
    _dataRows.add(KiemKeRowData(stt: '2'));
  }

  @override
  void dispose() {
    // 5. THAY ĐỔI: Hủy controller cho 2 hàng mới
    _headerRow3Data.dispose();
    _totalRowData.dispose();

    for (var row in _dataRows) {
      row.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1600,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),

          _buildInputHeaderRow3(),

          ..._dataRows.map((rowData) => _buildDataRow(rowData)).toList(),

          _buildInputTotalRow(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    const headerStyle = TextStyle(fontWeight: FontWeight.bold);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderCell(const Text('Số TT', style: headerStyle), _flexStt, rowSpan: 2),
          _buildHeaderCell(const Text('Tên TSCĐ', style: headerStyle), _flexTen, rowSpan: 2),
          _buildHeaderCell(const Text('Mã số', style: headerStyle), _flexMa, rowSpan: 2),
          _buildHeaderCell(const Text('Nơi sử dụng', style: headerStyle), _flexNoiSd, rowSpan: 2),
          _buildMergedHeaderCell(
            'Theo sổ kế toán',
            _flexSoKt,
            [
              _buildHeaderCell(const Text('Số lượng', style: headerStyle), _flexSoLieuSub, isSubHeader: true),
              _buildHeaderCell(const Text('Nguyên giá', style: headerStyle), _flexSoLieuSub, isSubHeader: true),
              _buildHeaderCell(const Text('Giá trị còn lại', style: headerStyle), _flexSoLieuSub, isSubHeader: true),
            ],
          ),
          _buildMergedHeaderCell(
            'Theo kiểm kê',
            _flexKiemKe,
            [
              _buildHeaderCell(const Text('Số lượng', style: headerStyle), _flexSoLieuSub, isSubHeader: true),
              _buildHeaderCell(const Text('Nguyên giá', style: headerStyle), _flexSoLieuSub, isSubHeader: true),
              _buildHeaderCell(const Text('Giá trị còn lại', style: headerStyle), _flexSoLieuSub, isSubHeader: true),
            ],
          ),
          _buildMergedHeaderCell(
            'Chênh lệch',
            _flexChenhLech,
            [
              _buildHeaderCell(const Text('Số lượng', style: headerStyle), _flexSoLieuSub, isSubHeader: true),
              _buildHeaderCell(const Text('Nguyên giá', style: headerStyle), _flexSoLieuSub, isSubHeader: true),
              _buildHeaderCell(const Text('Giá trị còn lại', style: headerStyle), _flexSoLieuSub, isSubHeader: true),
            ],
          ),
          _buildHeaderCell(const Text('Ghi chú', style: headerStyle), _flexGhiChu, rowSpan: 2, isLast: true),
        ],
      ),
    );
  }

  Widget _buildInputHeaderRow3() {
    const style = TextStyle(fontWeight: FontWeight.bold, color: Colors.black);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextFieldCell(_headerRow3Data.stt, _flexStt, align: TextAlign.center, style: style),
          _buildTextFieldCell(_headerRow3Data.tenTscd, _flexTen, align: TextAlign.center, style: style),
          _buildTextFieldCell(_headerRow3Data.maSo, _flexMa, align: TextAlign.center, style: style),
          _buildTextFieldCell(_headerRow3Data.noiSd, _flexNoiSd, align: TextAlign.center, style: style),
          _buildTextFieldCell(_headerRow3Data.soKtSl, _flexSoLieuSub, align: TextAlign.center, style: style),
          _buildTextFieldCell(_headerRow3Data.soKtNguyenGia, _flexSoLieuSub, align: TextAlign.center, style: style),
          _buildTextFieldCell(_headerRow3Data.soKtGtConLai, _flexSoLieuSub, align: TextAlign.center, style: style),
          _buildTextFieldCell(_headerRow3Data.kiemKeSl, _flexSoLieuSub, align: TextAlign.center, style: style),
          _buildTextFieldCell(_headerRow3Data.kiemKeNguyenGia, _flexSoLieuSub, align: TextAlign.center, style: style),
          _buildTextFieldCell(_headerRow3Data.kiemKeGtConLai, _flexSoLieuSub, align: TextAlign.center, style: style),
          _buildTextFieldCell(_headerRow3Data.chenhLechSl, _flexSoLieuSub, align: TextAlign.center, style: style),
          _buildTextFieldCell(_headerRow3Data.chenhLechNguyenGia, _flexSoLieuSub, align: TextAlign.center, style: style),
          _buildTextFieldCell(_headerRow3Data.chenhLechGtConLai, _flexSoLieuSub, align: TextAlign.center, style: style),
          _buildTextFieldCell(_headerRow3Data.ghiChu, _flexGhiChu, align: TextAlign.center, style: style, isLast: true),
        ],
      ),
    );
  }

  Widget _buildDataRow(KiemKeRowData rowData) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextFieldCell(rowData.stt, _flexStt, align: TextAlign.center),
          _buildTextFieldCell(rowData.tenTscd, _flexTen, align: TextAlign.left),
          _buildTextFieldCell(rowData.maSo, _flexMa, align: TextAlign.left),
          _buildTextFieldCell(rowData.noiSd, _flexNoiSd, align: TextAlign.left),
          _buildTextFieldCell(rowData.soKtSl, _flexSoLieuSub, align: TextAlign.right, keyboardType: TextInputType.number),
          _buildTextFieldCell(rowData.soKtNguyenGia, _flexSoLieuSub, align: TextAlign.right, keyboardType: TextInputType.number),
          _buildTextFieldCell(rowData.soKtGtConLai, _flexSoLieuSub, align: TextAlign.right, keyboardType: TextInputType.number),
          _buildTextFieldCell(rowData.kiemKeSl, _flexSoLieuSub, align: TextAlign.right, keyboardType: TextInputType.number),
          _buildTextFieldCell(rowData.kiemKeNguyenGia, _flexSoLieuSub, align: TextAlign.right, keyboardType: TextInputType.number),
          _buildTextFieldCell(rowData.kiemKeGtConLai, _flexSoLieuSub, align: TextAlign.right, keyboardType: TextInputType.number),
          _buildTextFieldCell(rowData.chenhLechSl, _flexSoLieuSub, align: TextAlign.right, keyboardType: TextInputType.number),
          _buildTextFieldCell(rowData.chenhLechNguyenGia, _flexSoLieuSub, align: TextAlign.right, keyboardType: TextInputType.number),
          _buildTextFieldCell(rowData.chenhLechGtConLai, _flexSoLieuSub, align: TextAlign.right, keyboardType: TextInputType.number),
          _buildTextFieldCell(rowData.ghiChu, _flexGhiChu, align: TextAlign.left, isLast: true),
        ],
      ),
    );
  }

  Widget _buildInputTotalRow() {
    const style = TextStyle(fontWeight: FontWeight.bold);
    final backgroundColor = Colors.grey[100]; // Nền xám nhạt

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextFieldCell(_totalRowData.stt, _flexStt, align: TextAlign.center, style: style, backgroundColor: backgroundColor),
          _buildTextFieldCell(_totalRowData.tenTscd, _flexTen, align: TextAlign.center, style: style, backgroundColor: backgroundColor),
          _buildTextFieldCell(_totalRowData.maSo, _flexMa, align: TextAlign.center, style: style, backgroundColor: backgroundColor),
          _buildTextFieldCell(_totalRowData.noiSd, _flexNoiSd, align: TextAlign.center, style: style, backgroundColor: backgroundColor),
          // Các ô tính tổng (cần nhập)
          _buildTextFieldCell(_totalRowData.soKtSl, _flexSoLieuSub, align: TextAlign.right, style: style, backgroundColor: backgroundColor, keyboardType: TextInputType.number),
          _buildTextFieldCell(_totalRowData.soKtNguyenGia, _flexSoLieuSub, align: TextAlign.right, style: style, backgroundColor: backgroundColor, keyboardType: TextInputType.number),
          _buildTextFieldCell(_totalRowData.soKtGtConLai, _flexSoLieuSub, align: TextAlign.right, style: style, backgroundColor: backgroundColor, keyboardType: TextInputType.number),
          _buildTextFieldCell(_totalRowData.kiemKeSl, _flexSoLieuSub, align: TextAlign.right, style: style, backgroundColor: backgroundColor, keyboardType: TextInputType.number),
          _buildTextFieldCell(_totalRowData.kiemKeNguyenGia, _flexSoLieuSub, align: TextAlign.right, style: style, backgroundColor: backgroundColor, keyboardType: TextInputType.number),
          _buildTextFieldCell(_totalRowData.kiemKeGtConLai, _flexSoLieuSub, align: TextAlign.right, style: style, backgroundColor: backgroundColor, keyboardType: TextInputType.number),
          _buildTextFieldCell(_totalRowData.chenhLechSl, _flexSoLieuSub, align: TextAlign.right, style: style, backgroundColor: backgroundColor, keyboardType: TextInputType.number),
          _buildTextFieldCell(_totalRowData.chenhLechNguyenGia, _flexSoLieuSub, align: TextAlign.right, style: style, backgroundColor: backgroundColor, keyboardType: TextInputType.number),
          _buildTextFieldCell(_totalRowData.chenhLechGtConLai, _flexSoLieuSub, align: TextAlign.right, style: style, backgroundColor: backgroundColor, keyboardType: TextInputType.number),
          _buildTextFieldCell(_totalRowData.ghiChu, _flexGhiChu, align: TextAlign.center, style: style, backgroundColor: backgroundColor, isLast: true),
        ],
      ),
    );
  }

  Widget _buildMergedHeaderCell(String title, int flex, List<Widget> children) {
    const headerStyle = TextStyle(fontWeight: FontWeight.bold);
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: const BorderSide(color: Colors.black, width: 1.0),
                right: const BorderSide(color: Colors.black, width: 1.0),
              ),
              color: Colors.grey[200],
            ),
            child: Center(
              child: Text(title, style: headerStyle, textAlign: TextAlign.center),
            ),
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeaderCell(Widget child, int flex, {int rowSpan = 1, bool isSubHeader = false, bool isLast = false}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: const BorderSide(color: Colors.black, width: 1.0),
            right: isLast ? BorderSide.none : const BorderSide(color: Colors.black, width: 1.0),
            top: isSubHeader ? const BorderSide(color: Colors.black, width: 1.0) : BorderSide.none,
          ),
          color: Colors.grey[200],
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  Widget _buildTextFieldCell(
      TextEditingController controller,
      int flex, {
        bool isLast = false,
        TextAlign align = TextAlign.center,
        TextInputType keyboardType = TextInputType.text,
        TextStyle? style, // Thêm style
        Color? backgroundColor, // Thêm màu nền
      }) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor, // Gán màu nền
          border: Border(
            bottom: const BorderSide(color: Colors.black, width: 1.0),
            right: isLast ? BorderSide.none : const BorderSide(color: Colors.black, width: 1.0),
          ),
        ),
        child: TextField(
          controller: controller,
          style: style, // Gán style
          textAlign: align,
          keyboardType: keyboardType,
          decoration: const InputDecoration(
            isDense: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(8.0),
          ),
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

  final TextEditingController ngayController = TextEditingController();
  final TextEditingController thangController = TextEditingController();
  final TextEditingController namController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SGText(text: '',),
                    SGText(
                      text: "Giám đốc",
                      style: SettingPage.textStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SGText(
                      text: "(Ghi ý kiến giải quyết số chênh lệch)",
                      style: SettingPage.textStyle,
                      textAlign: TextAlign.center,
                    ),
                    SGText(
                      text: "(Ký, họ tên, đóng dấu)",
                      style: SettingPage.textStyle.copyWith(
                        fontStyle: FontStyle.italic,
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
                    SGText(text: '',),
                    SGText(
                      text: "Kế toán trưởng",
                      style: SettingPage.textStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SGText(
                      text: "(Ký, họ tên)",
                      style: SettingPage.textStyle.copyWith(
                        fontStyle: FontStyle.italic,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SGText(
                          text: "Ngày",
                          style: SettingPage.textStyle.copyWith(
                          ),
                        ),
                        EditablePlaceholder(
                          controller: ngayController,
                          placeholder: "......",
                        ),
                        SGText(text: "tháng", style: SettingPage.textStyle),
                        EditablePlaceholder(
                          controller: thangController,
                          placeholder: "......",
                        ),
                        SGText(text: " năm ", style: SettingPage.textStyle),
                        EditablePlaceholder(
                          controller: namController,
                          placeholder: "......",
                        ),
                      ],
                    ),
                    SGText(
                      text: "Trưởng Ban kiểm kê",
                      style: SettingPage.textStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SGText(
                      text: "(Ký, họ tên)",
                      style: SettingPage.textStyle.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),

        ],
      ),
    );
  }
}


