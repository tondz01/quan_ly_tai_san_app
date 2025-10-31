import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/ccdc_inventory_report.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/inventory_minutes.dart';
import 'package:quan_ly_tai_san_app/screen/report/utils/data_converter_mau01.dart';
import 'package:se_gay_components/common/sg_text.dart';

import '../../../common/components/loading_overlay.dart';
import '../../../common/page/contract_page.dart' show SettingPage;

class MauSo01Page extends StatefulWidget {
  final List<CCDCInventoryReport> listCcdc;
  final List<InventoryMinutes> listTaiSan;
  const MauSo01Page({super.key, required this.listCcdc, required this.listTaiSan});

  @override
  State<MauSo01Page> createState() => _MauSo01PageState();
}

class _MauSo01PageState extends State<MauSo01Page> {
  bool _isExporting = false;
  final GlobalKey _repaintKey = GlobalKey();
  List<AssetRowData> _allAssetRows = [];

  @override
  void initState() {
    super.initState();
    _parseDataToAssetRows();
  }

  @override
  void didUpdateWidget(MauSo01Page oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload khi data thay đổi
    if (oldWidget.listTaiSan != widget.listTaiSan ||
        oldWidget.listCcdc != widget.listCcdc) {
      _parseDataToAssetRows();
    }
  }

  /// Parse InventoryMinutes và CCDCInventoryReport sang AssetRowData
  void _parseDataToAssetRows() {
    final List<AssetRowData> result = [];

    // 1. Thêm header "A - Tài sản cố định"
    result.add(AssetRowData(
      stt: 'A',
      tenNhanHieu: 'Tài sản cố định',
    ));

    // 2. Convert InventoryMinutes → DataMap → AssetRowData
    final assetDataMaps = DataConverterMau01.convertInventoryMinutesToDataMap(
      widget.listTaiSan,
    );

    int assetIndex = 1;
    for (final asset in assetDataMaps) {
      result.add(AssetRowData(
        stt: assetIndex.toString(),
        tenNhanHieu: asset.tenTaiSan ?? '',
        dvt: asset.donViTinh ?? '',
        nuocSx: '',
        soDuDauKy: asset.soLuong?.toString() ?? '',
        tangSoLuong: '',
        tangLyDo: asset.lyDo ?? '',
        giamSoLuong: '',
        giamLyDo: '',
        soDuCuoiKy: '',
        tinhTrang: '',
        ghiChu: asset.ghiChu ?? '',
      ));
      assetIndex++;
    }

    // 3. Thêm header "B - Công cụ dụng cụ"
    result.add(AssetRowData(
      stt: 'B',
      tenNhanHieu: 'Công cụ dụng cụ',
    ));

    // 4. Convert CCDCInventoryReport → DataMap → AssetRowData
    final ccdcDataMaps = DataConverterMau01.convertCCDCInventoryReportToDataMap(
      widget.listCcdc,
    );

    int ccdcIndex = 1;
    for (final ccdc in ccdcDataMaps) {
      result.add(AssetRowData(
        stt: ccdcIndex.toString(),
        tenNhanHieu: ccdc.tenTaiSan ?? '',
        dvt: ccdc.donViTinh ?? '',
        nuocSx: '',
        soDuDauKy: ccdc.soLuong?.toString() ?? '',
        tangSoLuong: '',
        tangLyDo: ccdc.lyDo ?? '',
        giamSoLuong: '',
        giamLyDo: '',
        soDuCuoiKy: '',
        tinhTrang: '',
        ghiChu: ccdc.ghiChu ?? '',
      ));
      ccdcIndex++;
    }

    setState(() {
      _allAssetRows = result;
    });
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var row in _allAssetRows) {
      row.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingOverlay(
        isLoading: _isExporting,
        message: 'Đang xuất PDF...',
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Divider(color: Colors.black, thickness: 1),
                const SizedBox(height: 16),
                RepaintBoundary(
                  key: _repaintKey,
                  child: Column(
                    children: [
                      HeaderMauSo01(
                      ),
                      BodyMauSo01(
                        assetRows: _allAssetRows,
                      ),
                      FoooterMauSo01(),
                    ],
                  ),
                ),
              ],
            ),
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

class HeaderMauSo01 extends StatefulWidget {


  const HeaderMauSo01({
    super.key,
  });

  @override
  State<HeaderMauSo01> createState() => _HeaderMauSo01KeState();
}

class _HeaderMauSo01KeState extends State<HeaderMauSo01> {
  final TextEditingController quyetDinhController = TextEditingController();
  final TextEditingController ngayQDController = TextEditingController();
  final TextEditingController thangQDController = TextEditingController();
  final TextEditingController namQDController = TextEditingController();
  final TextEditingController donViController = TextEditingController();
  final TextEditingController diaChiController = TextEditingController();
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

  final TextEditingController ctrlSelectDate = TextEditingController();

  PhongBan? donVi;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
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
                  // TẬP ĐOÀN CÔNG NGHIỆP
                  SGText(
                    text: "TẬP ĐOÀN CÔNG NGHIỆP",
                    style: SettingPage.textStyle,
                  ),
                  SGText(
                    text: "THAN – KHOÁNG SẢN VIỆT NAM",
                    style: SettingPage.textStyle,
                  ),
                  SGText(
                    text: "CÔNG TY THAN UÔNG BÍ - TKV",
                    style: SettingPage.textStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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
                      text: "Mẫu số 01",
                      style: SettingPage.textStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SGText(text: "ngày ", style: SettingPage.textStyle),
                        EditablePlaceholder(
                          controller: ngayQDController,
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

        Center(
          child: SGText(
            text: "SỔ THEO DÕI ",
            textAlign: TextAlign.center,
            style: SettingPage.textStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),

        Center(
          child: SGText(
            text: "TÀI SẢN CỐ ĐỊNH VÀ CÔNG CỤ DỤNG CỤ TẠI NƠI SỬ DỤNG ",
            textAlign: TextAlign.center,
            style: SettingPage.textStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SGText(
              text: " Tháng ",
              style: SettingPage.textStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            EditablePlaceholder(
              controller: thangKiemKeController,
              placeholder: "......",
            ),
            SGText(
              text: " năm ",
              style: SettingPage.textStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            EditablePlaceholder(
              controller: namKiemKeController,
              placeholder: "......",
            ),
          ],
        ),

        Center(
          child: SGText(
            text: "(Áp dụng cho các phân xưởng)",
            style: SettingPage.textStyle.copyWith(
              fontStyle: FontStyle.italic
            ),
          ),
        )
      ],
    );
  }
}

/// 1. Data Model để giữ controller cho 1 hàng
/// (Tương ứng với các cột 1, 2, 3... 9, A, B, C)
class AssetRowData {
  final TextEditingController stt; // A
  final TextEditingController tenNhanHieu; // B
  final TextEditingController dvt; // C
  final TextEditingController nuocSx; // 1
  final TextEditingController soDuDauKy; // 2
  final TextEditingController tangSoLuong; // 3
  final TextEditingController tangLyDo; // 4
  final TextEditingController giamSoLuong; // 5
  final TextEditingController giamLyDo; // 6
  final TextEditingController soDuCuoiKy; // 7
  final TextEditingController tinhTrang; // 8
  final TextEditingController ghiChu; // 9

  AssetRowData({
    String stt = '',
    String tenNhanHieu = '',
    String dvt = '',
    String nuocSx = '',
    String soDuDauKy = '',
    String tangSoLuong = '',
    String tangLyDo = '',
    String giamSoLuong = '',
    String giamLyDo = '',
    String soDuCuoiKy = '',
    String tinhTrang = '',
    String ghiChu = '',
  })  : stt = TextEditingController(text: stt),
        tenNhanHieu = TextEditingController(text: tenNhanHieu),
        dvt = TextEditingController(text: dvt),
        nuocSx = TextEditingController(text: nuocSx),
        soDuDauKy = TextEditingController(text: soDuDauKy),
        tangSoLuong = TextEditingController(text: tangSoLuong),
        tangLyDo = TextEditingController(text: tangLyDo),
        giamSoLuong = TextEditingController(text: giamSoLuong),
        giamLyDo = TextEditingController(text: giamLyDo),
        soDuCuoiKy = TextEditingController(text: soDuCuoiKy),
        tinhTrang = TextEditingController(text: tinhTrang),
        ghiChu = TextEditingController(text: ghiChu);

  void dispose() {
    stt.dispose();
    tenNhanHieu.dispose();
    dvt.dispose();
    nuocSx.dispose();
    soDuDauKy.dispose();
    tangSoLuong.dispose();
    tangLyDo.dispose();
    giamSoLuong.dispose();
    giamLyDo.dispose();
    soDuCuoiKy.dispose();
    tinhTrang.dispose();
    ghiChu.dispose();
  }
}

/// 2. Widget Bảng (Stateful)
class BodyMauSo01 extends StatefulWidget {
  final List<AssetRowData> assetRows; // Dữ liệu đã parse sẵn

  const BodyMauSo01({
    super.key,
    required this.assetRows,
  });

  @override
  State<BodyMauSo01> createState() => _BodyMauSo01State();
}

class _BodyMauSo01State extends State<BodyMauSo01> {
  // Không cần list riêng nữa, sẽ dùng trực tiếp widget.assetRows

  // Định nghĩa flex cho các cột
  final int _flexStt = 1; // A
  final int _flexTen = 5; // B
  final int _flexDvt = 2; // C
  final int _flexNuocSx = 2; // 1
  final int _flexSoDuDauKy = 3; // 2
  final int _flexTangSl = 2; // 3
  final int _flexTangLyDo = 3; // 4
  final int _flexGiamSl = 2; // 5
  final int _flexGiamLyDo = 3; // 6
  final int _flexSoDuCuoiKy = 3; // 7
  final int _flexTinhTrang = 3; // 8
  final int _flexGhiChu = 3; // 9

  // Flex cho các nhóm gộp
  int get _flexTang => _flexTangSl + _flexTangLyDo;
  int get _flexGiam => _flexGiamSl + _flexGiamLyDo;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2000, // Đặt width cố định để cuộn ngang
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderRow1(),
          _buildHeaderRow2(),
          _buildHeaderRow3(),

          // Render tất cả rows từ widget.assetRows
          ...widget.assetRows.map((rowData) => _buildDataRow(rowData)),
        ],
      ),
    );
  }

  /// Hàng header 1: STT, Tên... (rowspan 2) và Tăng/Giảm (colspan 2)
  Widget _buildHeaderRow1() {
    const style = TextStyle(fontWeight: FontWeight.bold);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderCell(Text('STT', style: style), _flexStt, rowSpan: 2),
          _buildHeaderCell(Text('Tên nhãn hiệu, quy cách tài sản cố định, công cụ dụng cụ', style: style, textAlign: TextAlign.center), _flexTen, rowSpan: 2),
          _buildHeaderCell(Text('Đơn vị tính', style: style), _flexDvt, rowSpan: 2),
          _buildHeaderCell(Text('Nước sản xuất', style: style), _flexNuocSx, rowSpan: 2),
          _buildHeaderCell(Text('Số dư đầu kỳ', style: style), _flexSoDuDauKy, rowSpan: 2),
          
          // "Tăng trong kỳ" (colspan 2)
          _buildHeaderCell(Text('Tăng trong kỳ', style: style), _flexTang),
          
          // "Giảm trong kỳ" (colspan 2)
          _buildHeaderCell(Text('Giảm trong kỳ', style: style), _flexGiam),
          
          _buildHeaderCell(Text('Số dư cuối kỳ', style: style), _flexSoDuCuoiKy, rowSpan: 2),
          _buildHeaderCell(Text('Tình trạng kỹ thuật', style: style), _flexTinhTrang, rowSpan: 2),
          _buildHeaderCell(Text('Ghi chú', style: style), _flexGhiChu, rowSpan: 2, isLast: true),
        ],
      ),
    );
  }

  /// Hàng header 2: Các ô con của Tăng/Giảm
  Widget _buildHeaderRow2() {
    const style = TextStyle(fontWeight: FontWeight.bold);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildEmptyFlex(_flexStt), // Ô rỗng cho STT
          _buildEmptyFlex(_flexTen), // Ô rỗng cho Tên
          _buildEmptyFlex(_flexDvt), // Ô rỗng cho ĐVT
          _buildEmptyFlex(_flexNuocSx), // Ô rỗng cho Nước SX
          _buildEmptyFlex(_flexSoDuDauKy), // Ô rỗng cho Số dư đầu
          
          // Con của "Tăng"
          _buildHeaderCell(Text('Số lượng', style: style), _flexTangSl, isSubHeader: true),
          _buildHeaderCell(Text('Lý do tăng', style: style), _flexTangLyDo, isSubHeader: true),
          
          // Con của "Giảm"
          _buildHeaderCell(Text('Số lượng', style: style), _flexGiamSl, isSubHeader: true),
          _buildHeaderCell(Text('Lý do giảm', style: style), _flexGiamLyDo, isSubHeader: true),
          
          _buildEmptyFlex(_flexSoDuCuoiKy), // Ô rỗng cho Số dư cuối
          _buildEmptyFlex(_flexTinhTrang), // Ô rỗng cho Tình trạng
          _buildEmptyFlex(_flexGhiChu, isLast: true), // Ô rỗng cho Ghi chú
        ],
      ),
    );
  }

  /// Hàng header 3: A, B, C...
  Widget _buildHeaderRow3() {
    const style = TextStyle(fontWeight: FontWeight.bold);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderCell(Text('A', style: style), _flexStt),
          _buildHeaderCell(Text('B', style: style), _flexTen),
          _buildHeaderCell(Text('C', style: style), _flexDvt),
          _buildHeaderCell(Text('1', style: style), _flexNuocSx),
          _buildHeaderCell(Text('2', style: style), _flexSoDuDauKy),
          _buildHeaderCell(Text('3', style: style), _flexTangSl),
          _buildHeaderCell(Text('4', style: style), _flexTangLyDo),
          _buildHeaderCell(Text('5', style: style), _flexGiamSl),
          _buildHeaderCell(Text('6', style: style), _flexGiamLyDo),
          _buildHeaderCell(Text('7=2+3-5', style: style.copyWith(fontSize: 12)), _flexSoDuCuoiKy),
          _buildHeaderCell(Text('8', style: style), _flexTinhTrang),
          _buildHeaderCell(Text('9', style: style), _flexGhiChu, isLast: true),
        ],
      ),
    );
  }

  /// 9. Xây dựng hàng dữ liệu (Tất cả đều là TextField)
  Widget _buildDataRow(AssetRowData rowData) {
    // Style cho hàng group (A, B)
    final bool isGroupHeader = rowData.stt.text == 'A' || rowData.stt.text == 'B';
    final style = isGroupHeader ? const TextStyle(fontWeight: FontWeight.bold) : null;
    final bgColor = isGroupHeader ? Colors.grey[200] : null;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextFieldCell(rowData.stt, _flexStt, align: TextAlign.center, style: style, backgroundColor: bgColor),
          _buildTextFieldCell(rowData.tenNhanHieu, _flexTen, align: TextAlign.left, style: style, backgroundColor: bgColor),
          _buildTextFieldCell(rowData.dvt, _flexDvt, align: TextAlign.center, style: style, backgroundColor: bgColor),
          _buildTextFieldCell(rowData.nuocSx, _flexNuocSx, align: TextAlign.center, style: style, backgroundColor: bgColor),
          _buildTextFieldCell(rowData.soDuDauKy, _flexSoDuDauKy, align: TextAlign.right, style: style, backgroundColor: bgColor, keyboardType: TextInputType.number),
          _buildTextFieldCell(rowData.tangSoLuong, _flexTangSl, align: TextAlign.right, style: style, backgroundColor: bgColor, keyboardType: TextInputType.number),
          _buildTextFieldCell(rowData.tangLyDo, _flexTangLyDo, align: TextAlign.left, style: style, backgroundColor: bgColor),
          _buildTextFieldCell(rowData.giamSoLuong, _flexGiamSl, align: TextAlign.right, style: style, backgroundColor: bgColor, keyboardType: TextInputType.number),
          _buildTextFieldCell(rowData.giamLyDo, _flexGiamLyDo, align: TextAlign.left, style: style, backgroundColor: bgColor),
          _buildTextFieldCell(rowData.soDuCuoiKy, _flexSoDuCuoiKy, align: TextAlign.right, style: style, backgroundColor: bgColor, keyboardType: TextInputType.number),
          _buildTextFieldCell(rowData.tinhTrang, _flexTinhTrang, align: TextAlign.left, style: style, backgroundColor: bgColor),
          _buildTextFieldCell(rowData.ghiChu, _flexGhiChu, align: TextAlign.left, style: style, backgroundColor: bgColor, isLast: true),
        ],
      ),
    );
  }

  //--- CÁC HÀM TRỢ GIÚP (HELPER) ---

  /// Helper cho ô Header
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
  
  /// Helper cho ô TextField
  Widget _buildTextFieldCell(
    TextEditingController controller,
    int flex, {
    bool isLast = false,
    TextAlign align = TextAlign.center,
    TextInputType keyboardType = TextInputType.text,
    TextStyle? style,
    Color? backgroundColor,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            bottom: const BorderSide(color: Colors.black, width: 1.0),
            right: isLast ? BorderSide.none : const BorderSide(color: Colors.black, width: 1.0),
          ),
        ),
        child: TextField(
          controller: controller,
          style: style,
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

  /// Helper cho ô rỗng (do rowSpan)
  Widget _buildEmptyFlex(int flex, {bool isLast = false}) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            // Vẽ border dưới cho hàng 2
            bottom: const BorderSide(color: Colors.black, width: 1.0),
            right: isLast ? BorderSide.none : const BorderSide(color: Colors.black, width: 1.0),
          ),
          color: Colors.grey[200], // Thêm màu nền cho đồng bộ
        ),
      ),
    );
  }
}

// footer
class FoooterMauSo01 extends StatefulWidget {
  const FoooterMauSo01({super.key});

  @override
  State<FoooterMauSo01> createState() => _FoooterMauSo01State();
}

class _FoooterMauSo01State extends State<FoooterMauSo01> {
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SGText(
                text: '     Gửi kèm theo các Quyết định, biên bản giao nhận tăng giảm tài sản, công cụ dụng cụ trong kỳ báo cáo',
                style: SettingPage.textStyle.copyWith(
                  fontStyle: FontStyle.italic
                ),
              ),
              SGText(
                text: '     Lưu ý: Báo cáo tháng trước vào ngày 15 hàng tháng ',
                style: SettingPage.textStyle
              ),
              SGText(
                text: '     (tháng sau)',
                style: SettingPage.textStyle
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SGText(
                      text: "Thống kê phân xưởng",
                      style: SettingPage.textStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SGText(
                      text: "(Ký, ghi rõ họ tên)",
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
                    SGText(
                      text: "Phó quản đốc cơ điện",
                      style: SettingPage.textStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SGText(
                      text: "(Ký, ghi rõ họ tên)",
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
                    SGText(
                      text: "Quản đốc phân xưởng",
                      style: SettingPage.textStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SGText(
                      text: "(Ký, ghi rõ họ tên)",
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