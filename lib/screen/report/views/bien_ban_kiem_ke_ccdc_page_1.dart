import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_text.dart';

import '../../../common/page/contract_page.dart' show SettingPage;

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: KiemKeCCDCPage(),
    ),
  );
}

class KiemKeCCDCPage extends StatefulWidget {
  const KiemKeCCDCPage({super.key});

  @override
  State<KiemKeCCDCPage> createState() => _KiemKeCCDCPageState();
}

class _KiemKeCCDCPageState extends State<KiemKeCCDCPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final h = Theme.of(context).textTheme;
    return Scaffold(
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HeaderBienBanKiemKe(),
              AssetInventoryTable(),
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
  final TextEditingController ngayThamChieuController = TextEditingController();
  final TextEditingController thangThamChieuController =
      TextEditingController();
  final TextEditingController namThamChieuController = TextEditingController();

  final TextEditingController gioKiemKeController = TextEditingController();
  final TextEditingController ngayKiemKeController = TextEditingController();
  final TextEditingController thangKiemKeController = TextEditingController();
  final TextEditingController namKiemKeController = TextEditingController();

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
                        text: "Mẫu số 03b-ĐC TSCĐ",
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
                          SGText(
                            text: " /QĐ-TUB",
                            style: SettingPage.textStyle,
                          ),
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
          // BIÊN BẢN ĐỐI CHIẾU KIỂM KÊ TÀI SẢN, CÔNG CỤ DỤNG CỤ
          Center(
            child: SGText(
              text: "BIÊN BẢN ĐỐI CHIẾU KIỂM KÊ TÀI SẢN, CÔNG CỤ DỤNG CỤ",
              textAlign: TextAlign.center,
              style: SettingPage.textStyle.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          // Có đến thời điểm 0h ngày  01  tháng  01  năm…….
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SGText(
                text: "Có đến thời điểm ",
                style: SettingPage.textStyle.copyWith(
                  fontWeight: FontWeight.bold,
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
            ],
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

          // Thời điểm đối chiếu,  ngày …… tháng ….. năm …..
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SGText(text: "Hôm nay, ngày ", style: SettingPage.textStyle),
              EditablePlaceholder(
                controller: ngayThamChieuController,
                placeholder: "......",
              ),
              SGText(text: " tháng ", style: SettingPage.textStyle),
              EditablePlaceholder(
                controller: thangThamChieuController,
                placeholder: "......",
              ),
              SGText(text: " năm ", style: SettingPage.textStyle),
              EditablePlaceholder(
                controller: namThamChieuController,
                placeholder: "......",
              ),
            ],
          ),
          SGText(
            text: "   A. THÀNH PHẦN",
            style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          SGText(
            text: "   I. Hội đồng kiểm kê",
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
          Wrap(
            children: [
              SGText(
                text:
                    "Hội đồng tiến hành  đối chiếu số lượng kiểm kê so với sổ sách theo dõi tài sản, công cụ dụng cụ có đến thời điểm ",
                style: SettingPage.textStyle,
              ),
              EditablePlaceholder(
                controller: gioNoiDungController,
                placeholder: "...",
                textStyle: SettingPage.textStyle,
              ),
              SGText(text: "tháng", style: SettingPage.textStyle),
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
              SGText(
                text: "kết quả cụ thể như sau:",
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
/// 1. Data Model - Đã cập nhật
class AssetRowData {
  final TextEditingController stt;
  final TextEditingController tenTs;
  final TextEditingController nuocSx;
  final TextEditingController dvt;
  final TextEditingController slDauKy;
  final TextEditingController slTang;
  final TextEditingController slGiam;
  final TextEditingController slSoSach;
  final TextEditingController slThucTe;
  final TextEditingController psTang;
  final TextEditingController psGiam;
  final TextEditingController slSoSach0h;
  final TextEditingController slThucTe0h;

  // BỎ 2 TRƯỜNG "thua" VÀ "thieu"
  // final TextEditingController chechLechThua;
  // final TextEditingController chechLechThieu;
  // THÊM TRƯỜNG "chechLech"
  final TextEditingController chechLech;
  final TextEditingController tinhTrangKt;
  final TextEditingController ghiChu;

  AssetRowData({
    String stt = '',
    String tenTs = '',
    String nuocSx = '',
    String dvt = '',
    String slDauKy = '',
    String slTang = '',
    String slGiam = '',
    String slSoSach = '',
    String slThucTe = '',
    String psTang = '',
    String psGiam = '',
    String slSoSach0h = '',
    String slThucTe0h = '',
    String chechLech = '', // Thêm giá trị mặc định
    String tinhTrangKt = '',
    String ghiChu = '',
  }) : stt = TextEditingController(text: stt),
       tenTs = TextEditingController(text: tenTs),
       nuocSx = TextEditingController(text: nuocSx),
       dvt = TextEditingController(text: dvt),
       slDauKy = TextEditingController(text: slDauKy),
       slTang = TextEditingController(text: slTang),
       slGiam = TextEditingController(text: slGiam),
       slSoSach = TextEditingController(text: slSoSach),
       slThucTe = TextEditingController(text: slThucTe),
       psTang = TextEditingController(text: psTang),
       psGiam = TextEditingController(text: psGiam),
       slSoSach0h = TextEditingController(text: slSoSach0h),
       slThucTe0h = TextEditingController(text: slThucTe0h),
       // Gán controller mới
       chechLech = TextEditingController(text: chechLech),
       tinhTrangKt = TextEditingController(text: tinhTrangKt),
       ghiChu = TextEditingController(text: ghiChu);

  void dispose() {
    stt.dispose();
    tenTs.dispose();
    nuocSx.dispose();
    dvt.dispose();
    slDauKy.dispose();
    slTang.dispose();
    slGiam.dispose();
    slSoSach.dispose();
    slThucTe.dispose();
    psTang.dispose();
    psGiam.dispose();
    slSoSach0h.dispose();
    slThucTe0h.dispose();
    chechLech.dispose(); // Hủy controller mới
    tinhTrangKt.dispose();
    ghiChu.dispose();
  }
}

class AssetInventoryTable extends StatefulWidget {
  const AssetInventoryTable({super.key});

  @override
  State<AssetInventoryTable> createState() => _AssetInventoryTableState();
}

class _AssetInventoryTableState extends State<AssetInventoryTable> {
  final List<AssetRowData> _dataRows = [];

  final int _flexStt = 1;
  final int _flexTenTs = 5;
  final int _flexNuocSx = 2;
  final int _flexDvt = 2;
  final int _flexSoLuong = 3;
  final int _flexPhatSinhTangGiamSub = 2;

  int get _flexPhatSinhTangGiam => _flexPhatSinhTangGiamSub * 2;

  // flex "Chênh lệch" giờ bằng tổng 2 flex con
  int get _flexChechLech => _flexPhatSinhTangGiamSub * 2;

  @override
  void initState() {
    super.initState();
    _dataRows.add(
      AssetRowData(
        stt: '1',
        tenTs: 'Máy tính Dell XPS',
        nuocSx: 'USA',
        dvt: 'Chiếc',
        slDauKy: '10',
        slTang: '2',
        slGiam: '0',
        slSoSach: '12',
        slThucTe: '12',
        psTang: '0',
        psGiam: '0',
        slSoSach0h: '12',
        slThucTe0h: '12',
        chechLech: '0',
        // Cập nhật data mẫu
        tinhTrangKt: 'Tốt',
      ),
    );
    _dataRows.add(AssetRowData(stt: '2'));
    _dataRows.add(AssetRowData(stt: '3'));
  }

  @override
  void dispose() {
    for (var row in _dataRows) {
      row.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1800,
      decoration: BoxDecoration(
        // Border ngoài cùng
        border: Border.all(color: Colors.black, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          _buildSubHeader(),
          ..._dataRows.map((rowData) => _buildDataRow(rowData)).toList(),
          // _buildAddRowButton(),
        ],
      ),
    );
  }

  /// Xây dựng hàng header chính (cấp 1) - ĐÃ CẬP NHẬT
  Widget _buildHeader() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderCell(
            Text(
              'Số TT',
              style: SettingPage.textStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            _flexStt,
            rowSpan: 2,
          ),
          _buildHeaderCell(
            Text(
              'Tên tài sản, công cụ dụng cụ (Ký mã hiệu)',
              textAlign: TextAlign.center,
              style: SettingPage.textStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            _flexTenTs,
            rowSpan: 2,
          ),
          _buildHeaderCell(
            Text(
              'Nước sản xuất',
              style: SettingPage.textStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            _flexNuocSx,
            rowSpan: 2,
          ),
          _buildHeaderCell(
            Text(
              'Đơn vị tính',
              style: SettingPage.textStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            _flexDvt,
            rowSpan: 2,
          ),
          _buildHeaderCell(
            HeaderDateWidget(text: 'Số lượng đầu kỳ'),
            _flexSoLuong,
            rowSpan: 2,
          ),
          _buildHeaderCell(
            Text(
              'Số tăng trong năm đến ngày kiểm kê',
              textAlign: TextAlign.center,
              style: SettingPage.textStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            _flexSoLuong,
            rowSpan: 2,
          ),
          _buildHeaderCell(
            Text(
              'Số giảm trong năm đến ngày kiểm kê',
              textAlign: TextAlign.center,
              style: SettingPage.textStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            _flexSoLuong,
            rowSpan: 2,
          ),
          _buildHeaderCell(
            Text(
              'Số TS trên sổ sách đến ngày kiểm kê',
              textAlign: TextAlign.center,
              style: SettingPage.textStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            _flexSoLuong,
            rowSpan: 2,
          ),

          _buildHeaderCell(
            Text(
              'Số lượng TS theo kiểm kê thực tế đến ngày kiểm kê',
              textAlign: TextAlign.center,
              style: SettingPage.textStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            _flexSoLuong,
            rowSpan: 2,
          ),

          Expanded(
            flex: _flexPhatSinhTangGiam,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: const BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ), // 1.0
                ),
                color: Colors.grey[200],
              ),
              child: Center(
                child: Text(
                  'Phát sinh tăng giảm sau ngày kiểm kê',
                  textAlign: TextAlign.center,
                  style: SettingPage.textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          _buildHeaderCell(
            HeaderDateWidget(text: 'Tài sản trên sổ sách có đến 0h ngày '),
            _flexSoLuong,
            rowSpan: 2,
          ),
          _buildHeaderCell(
            HeaderDateWidget(
              text: 'Số lượng thực tế TS tại đơn vị có đến 0h ngày ',
            ),
            _flexSoLuong,
            rowSpan: 2,
          ),
          _buildHeaderCell(
            HeaderDateWidget(
              text: 'Chênh lệch thừa (+) thiếu (-) thời điểm 0h ngày ',
            ),
            _flexChechLech,
            rowSpan: 2,
          ),
          _buildHeaderCell(
            Text(
              'Tình trạng kỹ thuật',
              style: SettingPage.textStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            _flexSoLuong,
            rowSpan: 2,
          ),
          _buildHeaderCell(
            Text(
              'Ghi chú',
              style: SettingPage.textStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            _flexSoLuong,
            rowSpan: 2,
            isLast: true,
          ),
        ],
      ),
    );
  }

  /// Xây dựng hàng header phụ (cấp 2) - ĐÃ CẬP NHẬT
  Widget _buildSubHeader() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildEmptyFlex(_flexStt),
          _buildEmptyFlex(_flexTenTs),
          _buildEmptyFlex(_flexNuocSx),
          _buildEmptyFlex(_flexDvt),
          _buildEmptyFlex(_flexSoLuong),
          _buildEmptyFlex(_flexSoLuong),
          _buildEmptyFlex(_flexSoLuong),
          _buildEmptyFlex(_flexSoLuong),
          _buildEmptyFlex(_flexSoLuong),
          // Cột con của "Phát sinh"
          _buildHeaderCell(
            Text(
              'Tăng',
              style: SettingPage.textStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            _flexPhatSinhTangGiamSub,
            isSubHeader: true,
          ),
          _buildHeaderCell(
            Text(
              'Giảm',
              style: SettingPage.textStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            _flexPhatSinhTangGiamSub,
            isSubHeader: true,
          ),
          _buildEmptyFlex(_flexSoLuong),
          _buildEmptyFlex(_flexSoLuong),
          _buildEmptyFlex(_flexChechLech),
          _buildEmptyFlex(_flexSoLuong),
          _buildEmptyFlex(_flexSoLuong, isLast: true),
        ],
      ),
    );
  }

  /// Xây dựng hàng dữ liệu - ĐÃ CẬP NHẬT
  Widget _buildDataRow(AssetRowData rowData) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextFieldCell(
            rowData.stt,
            _flexStt,
            align: TextAlign.center,
            keyboardType: TextInputType.number,
          ),
          _buildTextFieldCell(rowData.tenTs, _flexTenTs, align: TextAlign.left),
          _buildTextFieldCell(rowData.nuocSx, _flexNuocSx),
          _buildTextFieldCell(rowData.dvt, _flexDvt),
          _buildTextFieldCell(
            rowData.slDauKy,
            _flexSoLuong,
            align: TextAlign.right,
            keyboardType: TextInputType.number,
          ),
          _buildTextFieldCell(
            rowData.slTang,
            _flexSoLuong,
            align: TextAlign.right,
            keyboardType: TextInputType.number,
          ),
          _buildTextFieldCell(
            rowData.slGiam,
            _flexSoLuong,
            align: TextAlign.right,
            keyboardType: TextInputType.number,
          ),
          _buildTextFieldCell(
            rowData.slSoSach,
            _flexSoLuong,
            align: TextAlign.right,
            keyboardType: TextInputType.number,
          ),
          _buildTextFieldCell(
            rowData.slThucTe,
            _flexSoLuong,
            align: TextAlign.right,
            keyboardType: TextInputType.number,
          ),
          _buildTextFieldCell(
            rowData.psTang,
            _flexPhatSinhTangGiamSub,
            align: TextAlign.right,
            keyboardType: TextInputType.number,
          ),
          _buildTextFieldCell(
            rowData.psGiam,
            _flexPhatSinhTangGiamSub,
            align: TextAlign.right,
            keyboardType: TextInputType.number,
          ),
          _buildTextFieldCell(
            rowData.slSoSach0h,
            _flexSoLuong,
            align: TextAlign.right,
            keyboardType: TextInputType.number,
          ),
          _buildTextFieldCell(
            rowData.slThucTe0h,
            _flexSoLuong,
            align: TextAlign.right,
            keyboardType: TextInputType.number,
          ),
          _buildTextFieldCell(
            rowData.chechLech,
            _flexChechLech,
            align: TextAlign.right,
            keyboardType: TextInputType.number,
          ),

          _buildTextFieldCell(rowData.tinhTrangKt, _flexSoLuong),
          _buildTextFieldCell(rowData.ghiChu, _flexSoLuong, isLast: true),
        ],
      ),
    );
  }

  /// Widget tùy chỉnh cho Ô TextField - ĐÃ CẬP NHẬT (border width)
  Widget _buildTextFieldCell(
    TextEditingController controller,
    int flex, {
    bool isLast = false,
    TextAlign align = TextAlign.center,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            // Đổi width thành 1.0
            bottom: const BorderSide(color: Colors.black, width: 1.0),
            right:
                isLast
                    ? BorderSide.none
                    : const BorderSide(color: Colors.black, width: 1.0),
          ),
        ),
        child: TextField(
          controller: controller,
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

  // Widget _buildAddRowButton() {
  //   return TextButton.icon(
  //     icon: const Icon(Icons.add_circle_outline),
  //     label: const Text('Thêm hàng mới'),
  //     onPressed: () {
  //       setState(() {
  //         _dataRows.add(AssetRowData(stt: (_dataRows.length + 1).toString()));
  //       });
  //     },
  //   );
  // }

  /// Helper cho Ô Header
  Widget _buildHeaderCell(
    Widget child,
    int flex, {
    int rowSpan = 1,
    bool isSubHeader = false,
    bool isLast = false,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border(
            bottom:
                rowSpan == 1 || isSubHeader
                    ? const BorderSide(color: Colors.black, width: 1.0)
                    : BorderSide.none,
            right:
                isLast
                    ? BorderSide.none
                    : const BorderSide(color: Colors.black, width: 1.0),
            top:
                isSubHeader
                    ? const BorderSide(color: Colors.black, width: 1.0)
                    : BorderSide.none,
          ),
          color: Colors.grey[200],
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  Widget _buildEmptyFlex(int flex, {bool isLast = false}) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border(
            // Đổi width thành 1.0
            right:
                isLast
                    ? BorderSide.none
                    : const BorderSide(color: Colors.black, width: 1.0),
            bottom: const BorderSide(color: Colors.black, width: 1.0),
          ),
        ),
      ),
    );
  }
}

class HeaderDateWidget extends StatelessWidget {
  final String text;
  final TextEditingController dayController;
  final TextEditingController monthController;
  final TextEditingController yearController;

  HeaderDateWidget({
    super.key,
    required this.text,
    TextEditingController? dayController,
    TextEditingController? monthController,
    TextEditingController? yearController,
  }) : dayController = dayController ?? TextEditingController(),
       monthController = monthController ?? TextEditingController(),
       yearController = yearController ?? TextEditingController();

  @override
  Widget build(BuildContext context) {
    final style = SettingPage.textStyle.copyWith(
      fontWeight: FontWeight.bold,
    );
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 4,
      children: [
        SGText(
          text: "Số lượng đầu kỳ",
          style: style.copyWith(fontWeight: FontWeight.bold),
        ),

        // keep the date placeholders together so they wrap as a unit
        Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            EditablePlaceholder(
              controller: dayController,
              placeholder: "..",
              textStyle: style,
            ),
            SGText(text: "/", style: style),
            EditablePlaceholder(
              controller: monthController,
              placeholder: "..",
              textStyle: style,
            ),
            SGText(text: "/", style: style),
            EditablePlaceholder(
              controller: yearController,
              placeholder: "....",
              textStyle: style,
            ),
          ],
        ),
      ],
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
                    SGText(
                      text: "ỦY VIÊN HỘI ĐỒNG KIỂM",
                      style: SettingPage.textStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // Không đặt SizedBox(height: 50) ở đây
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SGText(
                      text: "ĐƠN VỊ ĐƯỢC KIỂM KÊ",
                      style: SettingPage.textStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // Không đặt SizedBox(height: 50) ở đây
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SGText(
                      text: "CHỦ TỊCH HỘI ĐỒNG",
                      style: SettingPage.textStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SGText(
                      text: "GIÁM ĐỐC",
                      style: SettingPage.textStyle.copyWith(
                        fontWeight: FontWeight.bold,
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


