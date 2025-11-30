import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_date.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';

import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/models/department.dart';

import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/report/component/report_provider.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/data_map.dart';

import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/core/enum/sg_date_time_mode.dart';

import '../../../common/page/contract_page.dart' show SettingPage;
import '../../../common/components/loading_overlay.dart';
import 'package:quan_ly_tai_san_app/common/widgets/a4_canvas.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: MauS22DnPage()),
  );
}

class MauS22DnPage extends StatefulWidget {
  const MauS22DnPage({super.key});

  @override
  State<MauS22DnPage> createState() => _MauS22DnPageState();
}

class _MauS22DnPageState extends State<MauS22DnPage> {
  List<DataMap> _assetData = [];
  List<DataMap> _ccdcData = [];
  bool _isExporting = false;
  final GlobalKey _repaintKey = GlobalKey();

  // State cho phần chọn đơn vị và năm
  PhongBan? _selectedDonVi;
  DateTime _selectedDate = DateTime.now();
  List<PhongBan> _listPhongBan = [];
  final TextEditingController _donViController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // Data cache for mapping
  List<AssetManagementDto> _listAssetManagement = [];
  List<ToolsAndSuppliesDto> _listCCDC = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    _listPhongBan = AccountHelper.instance.getDepartment() ?? [];
    _listAssetManagement = await ReportProvider().getListAsset();
    _listCCDC = await ReportProvider().getListCCDC('ct001');
    setState(() {});
  }

  @override
  void dispose() {
    _donViController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _handleGetData() async {
    if (_selectedDonVi == null) {
      AppUtility.showSnackBar(context, 'Vui lòng chọn đơn vị!', isError: true);
      return;
    }

    setState(() => _isExporting = true);

    try {
      // Fetch Asset Report from new API
      final resultAsset = await ReportProvider().getS22DnReport(
        _selectedDonVi!.id ?? '',
        _selectedDate,
      );

      // Fetch CCDC Report from new API
      final resultCCDC = await ReportProvider().getS22DnReportCCDC(
        _selectedDonVi!.id ?? '',
        _selectedDate,
      );

      // Helper function to map API response to DataMap
      List<DataMap> mapToDataMap(List<dynamic> list, DataMapType type) {
        return list.map((item) {
          return DataMap(
            tenTaiSan: item['tenTaiSan'] ?? '',
            soHieu: item['idTaiSan'] ?? '',
            ngayThang: item['ngayThang'] ?? '',
            donViTinh: item['donViTinh'] ?? '',
            soLuong: (item['soLuong'] as num?)?.toInt(),
            donGia: (item['donGia'] as num?)?.toDouble(),
            soTien: (item['tongTien'] as num?)?.toDouble(),
            type: type,
          );
        }).toList();
      }

      List<DataMap> assetData = [];
      if (resultAsset['data'] != null) {
        final data = resultAsset['data'];
        final increase = mapToDataMap(
          data['data_increase'] ?? [],
          DataMapType.INCREASE,
        );
        final reduce = mapToDataMap(
          data['data_reduce'] ?? [],
          DataMapType.REDUCE,
        );
        assetData = [...increase, ...reduce];
      }

      List<DataMap> ccdcData = [];
      if (resultCCDC['data'] != null) {
        final data = resultCCDC['data'];
        final increase = mapToDataMap(
          data['data_increase'] ?? [],
          DataMapType.INCREASE,
        );
        final reduce = mapToDataMap(
          data['data_reduce'] ?? [],
          DataMapType.REDUCE,
        );
        ccdcData = [...increase, ...reduce];
      }

      setState(() {
        _assetData = assetData;
        _ccdcData = ccdcData;
        _isExporting = false;
      });
      AppUtility.showSnackBar(context, 'Lấy dữ liệu thành công!');
    } catch (e) {
      setState(() => _isExporting = false);
      AppUtility.showSnackBar(context, 'Lỗi lấy dữ liệu: $e', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: LoadingOverlay(
        isLoading: _isExporting,
        message: 'Đang xử lý...',
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: 1400,
              child: Column(
                children: [
                  // Control Panel
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          SGText(
                            text: 'Sổ Theo dõi tài sản cố định (S22-DN)',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(height: 32),
                          Row(
                            children: [
                              Expanded(
                                child: CmFormDropdownObject<PhongBan>(
                                  label: 'Chọn đơn vị',
                                  value: _selectedDonVi,
                                  controller: _donViController,
                                  isEditing: true,
                                  items: [
                                    ..._listPhongBan.map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.tenPhongBan ?? ''),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedDonVi = value;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CmFormDate(
                                  label: 'Năm',
                                  controller: _dateController,
                                  isEditing: true,
                                  value: _selectedDate,
                                  dateTimeMode: SGDateTimeMode.year,
                                  showTimeSection: false,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedDate = value ?? DateTime.now();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                onPressed: _handleGetData,
                                icon: const Icon(Icons.refresh, size: 20),
                                label: const Text('Lấy dữ liệu'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  if (_isExporting) return;
                                  setState(() {
                                    _isExporting = true;
                                  });
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) async {
                                    await ReportProvider().exportToPdf(
                                      [_repaintKey],
                                      context,
                                      () {
                                        setState(() => _isExporting = false);
                                        AppUtility.showSnackBar(
                                          context,
                                          'Xuất PDF thành công!',
                                          isError: false,
                                        );
                                      },
                                    );
                                  });
                                },
                                icon: const Icon(
                                  Icons.picture_as_pdf,
                                  size: 20,
                                ),
                                label: const Text('Xuất PDF'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              GestureDetector(
                                onTap: () {
                                  if (_isExporting) return;
                                  setState(() {
                                    _isExporting = true;
                                  });
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) async {
                                    await ReportProvider().exportToPdfAndPrint(
                                      [_repaintKey],
                                      context,
                                      () {
                                        setState(() => _isExporting = false);
                                      },
                                    );
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: const Icon(
                                    Icons.print,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Report Content
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: RepaintBoundary(
                            key: _repaintKey,
                            child: Column(
                              children: [
                                HeaderBienBanKiemKe(
                                  donVi: _selectedDonVi,
                                  date: _selectedDate,
                                ),
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.center,
                                  child: SGText(
                                    text: 'Bảng ghi tăng/giảm Tài sản cố định',
                                    style: SettingPage.textStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                AssetLedgerTable(
                                  data: _assetData,
                                  title: 'tài sản',
                                ),
                                if (_ccdcData.isNotEmpty) ...[
                                  const SizedBox(height: 24),
                                  Align(
                                    alignment: Alignment.center,
                                    child: SGText(
                                      text:
                                          'Bảng ghi tăng/giảm Công cụ, dụng cụ cố định',
                                      style: SettingPage.textStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  AssetLedgerTable(
                                    data: _ccdcData,
                                    title: 'công cụ, dụng cụ',
                                  ),
                                ],
                                FoooterBienBanKiemKe(),
                                DetailPageWidget(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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

class HeaderBienBanKiemKe extends StatefulWidget {
  final PhongBan? donVi;
  final DateTime? date;

  const HeaderBienBanKiemKe({super.key, this.donVi, this.date});

  @override
  State<HeaderBienBanKiemKe> createState() => _HeaderBienBanKiemKeState();
}

class _HeaderBienBanKiemKeState extends State<HeaderBienBanKiemKe> {
  final TextEditingController diaChiController = TextEditingController();

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
                      Expanded(
                        child: SGText(
                          text:
                              widget.donVi?.tenPhongBan ??
                              '...................',
                          style: SettingPage.textStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Đơn vị:........
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SGText(
                        text: "Địa chỉ: ",
                        style: SettingPage.textStyle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: EditablePlaceholder(
                          controller: diaChiController,
                          placeholder: "...........",
                          textStyle: SettingPage.textStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
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
                      text: "Mẫu số S22-DN",
                      style: SettingPage.textStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    SGText(
                      text: "(Ban hành theo Thông tư số 200/2014/TT-BTC",
                      style: SettingPage.textStyle,
                      textAlign: TextAlign.center,
                    ),

                    SGText(
                      text: "Ngày 22/12/2014 của Bộ Tài chính)",
                      style: SettingPage.textStyle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Center(
          child: SGText(
            text:
                "Sổ Theo dõi tài sản cố định và công cụ, dụng cụ tại nơi sử dụng",
            textAlign: TextAlign.center,
            style: SettingPage.textStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),

        // năm…….
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SGText(text: "Năm ", style: SettingPage.textStyle.copyWith()),
            SGText(
              text: widget.date?.year.toString() ?? '....',
              style: SettingPage.textStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SGText(
              text: "Tên đơn vị (phòng, ban hoặc người sử dụng) ",
              style: SettingPage.textStyle.copyWith(),
            ),
            Expanded(
              child: SGText(
                text: widget.donVi?.tenPhongBan ?? '......',
                style: SettingPage.textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 2. Data Model để giữ controller cho 1 hàng
/// Class này chứa 13 controller tương ứng với 13 cột dữ liệu
class AssetLedgerRowData {
  final TextEditingController ctTangSoHieu;
  final TextEditingController ctTangNgayThang;
  final TextEditingController tenTs;
  final TextEditingController dvt;
  final TextEditingController tangSl;
  final TextEditingController tangDonGia;
  final TextEditingController tangSoTien;
  final TextEditingController ctGiamSoHieu;
  final TextEditingController ctGiamNgayThang;
  final TextEditingController giamLyDo;
  final TextEditingController giamSl;
  final TextEditingController giamSoTien;
  final TextEditingController ghiChu;

  AssetLedgerRowData({
    String ctTangSoHieu = '',
    String ctTangNgayThang = '',
    String tenTs = '',
    String dvt = '',
    String tangSl = '',
    String tangDonGia = '',
    String tangSoTien = '',
    String ctGiamSoHieu = '',
    String ctGiamNgayThang = '',
    String giamLyDo = '',
    String giamSl = '',
    String giamSoTien = '',
    String ghiChu = '',
  }) : ctTangSoHieu = TextEditingController(text: ctTangSoHieu),
       ctTangNgayThang = TextEditingController(text: ctTangNgayThang),
       tenTs = TextEditingController(text: tenTs),
       dvt = TextEditingController(text: dvt),
       tangSl = TextEditingController(text: tangSl),
       tangDonGia = TextEditingController(text: tangDonGia),
       tangSoTien = TextEditingController(text: tangSoTien),
       ctGiamSoHieu = TextEditingController(text: ctGiamSoHieu),
       ctGiamNgayThang = TextEditingController(text: ctGiamNgayThang),
       giamLyDo = TextEditingController(text: giamLyDo),
       giamSl = TextEditingController(text: giamSl),
       giamSoTien = TextEditingController(text: giamSoTien),
       ghiChu = TextEditingController(text: ghiChu);

  // Hàm dispose để dọn dẹp controller, tránh rò rỉ bộ nhớ
  void dispose() {
    ctTangSoHieu.dispose();
    ctTangNgayThang.dispose();
    tenTs.dispose();
    dvt.dispose();
    tangSl.dispose();
    tangDonGia.dispose();
    tangSoTien.dispose();
    ctGiamSoHieu.dispose();
    ctGiamNgayThang.dispose();
    giamLyDo.dispose();
    giamSl.dispose();
    giamSoTien.dispose();
    ghiChu.dispose();
  }
}

/// 3. Widget Bảng (Stateful)
class AssetLedgerTable extends StatefulWidget {
  final List<DataMap> data;
  final String title;

  const AssetLedgerTable({super.key, required this.data, required this.title});

  @override
  State<AssetLedgerTable> createState() => _AssetLedgerTableState();
}

class _AssetLedgerTableState extends State<AssetLedgerTable> {
  // Danh sách quản lý tất cả các hàng dữ liệu
  final List<AssetLedgerRowData> _dataRows = [];

  // Định nghĩa flex cho các cột CƠ SỞ (hàng 3)
  final int _flexCtSoHieu = 2;
  final int _flexCtNgay = 2;
  final int _flexTenTs = 5; // Cột rộng
  final int _flexDvt = 2;
  final int _flexSlTang = 2;
  final int _flexDonGia = 3; // Cột tiền
  final int _flexStTang = 3; // Cột tiền
  final int _flexCtGiamSoHieu = 2;
  final int _flexCtGiamNgay = 2;
  final int _flexLyDo = 3;
  final int _flexSlGiam = 2;
  final int _flexStGiam = 3; // Cột tiền
  final int _flexGhiChu = 4; // Cột rộng

  // Tính flex cho các nhóm gộp (colspan)
  int get _flexCtTang => _flexCtSoHieu + _flexCtNgay; // 4
  int get _flexCtGiam => _flexCtGiamSoHieu + _flexCtGiamNgay; // 4
  int get _flexGhiTang =>
      _flexCtTang +
      _flexTenTs +
      _flexDvt +
      _flexSlTang +
      _flexDonGia +
      _flexStTang; // 4+5+2+2+3+3 = 19
  int get _flexGhiGiam =>
      _flexCtGiam + _flexLyDo + _flexSlGiam + _flexStGiam; // 4+3+2+3 = 12

  @override
  void initState() {
    super.initState();
    _rebuildRowsFromData(widget.data);
  }

  @override
  void didUpdateWidget(covariant AssetLedgerTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.data, widget.data)) {
      _rebuildRowsFromData(widget.data);
      setState(() {});
    }
  }

  void _rebuildRowsFromData(List<DataMap> data) {
    // Dọn các controller cũ
    for (var row in _dataRows) {
      row.dispose();
    }
    _dataRows.clear();

    if (data.isEmpty) {
      // Hiển thị 2 hàng trống nếu chưa có dữ liệu
      _dataRows.add(AssetLedgerRowData());
      _dataRows.add(AssetLedgerRowData());
      return;
    }

    for (final item in data) {
      final isIncrease = item.type == DataMapType.INCREASE;
      final isReduce = item.type == DataMapType.REDUCE;

      _dataRows.add(
        AssetLedgerRowData(
          ctTangSoHieu: isIncrease ? (item.soHieu ?? '') : '',
          ctTangNgayThang: isIncrease ? (item.ngayThang ?? '') : '',
          tenTs: item.tenTaiSan ?? '',
          dvt: item.donViTinh ?? '',
          tangSl: isIncrease ? (item.soLuong?.toString() ?? '') : '',
          tangDonGia: isIncrease ? (item.donGia?.toString() ?? '') : '',
          tangSoTien: isIncrease ? (item.soTien?.toString() ?? '') : '',
          ctGiamSoHieu: isReduce ? (item.soHieu ?? '') : '',
          ctGiamNgayThang: isReduce ? (item.ngayThang ?? '') : '',
          giamLyDo: isReduce ? (item.lyDo ?? '') : '',
          giamSl: isReduce ? (item.soLuong?.toString() ?? '') : '',
          giamSoTien: isReduce ? (item.soTien?.toString() ?? '') : '',
          ghiChu: item.ghiChu ?? '',
        ),
      );
    }
  }

  @override
  void dispose() {
    // Quan trọng: Hủy tất cả controller khi widget bị xóa
    for (var row in _dataRows) {
      row.dispose();
    }
    super.dispose();
  }

  // Hàm để thêm hàng mới
  // void _addRow() {
  //   setState(() {
  //     _dataRows.add(AssetLedgerRowData());
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // Tổng flex = 19 + 12 + 4 = 35. Đặt width đủ lớn để kích hoạt cuộn ngang.
    return Container(
      width: 1800,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderRow1(),
          _buildHeaderRow2(),
          _buildHeaderRow3(),
          // Build các hàng dữ liệu từ list
          ..._dataRows.map((rowData) => _buildDataRow(rowData)),
          // _buildAddRowButton(),
        ],
      ),
    );
  }

  /// Hàng header 1: Ghi tăng / Ghi giảm / Ghi chú
  Widget _buildHeaderRow1() {
    const style = TextStyle(fontWeight: FontWeight.bold);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderCell(
            Text(
              'Ghi tăng ${widget.title} cố định',
              style: style,
              textAlign: TextAlign.center,
            ),
            _flexGhiTang,
          ),
          _buildHeaderCell(
            Text(
              'Ghi giảm ${widget.title} cố định',
              style: style,
              textAlign: TextAlign.center,
            ),
            _flexGhiGiam,
          ),
          _buildHeaderCell(
            Text('Ghi chú', style: style),
            _flexGhiChu,
            rowSpan: 3,
            isLast: true,
          ), // Cột này chiếm 3 hàng
        ],
      ),
    );
  }

  /// Hàng header 2: Chứng từ / Tên / ... / Lý do / ...
  Widget _buildHeaderRow2() {
    const style = TextStyle(fontWeight: FontWeight.bold);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // "Ghi tăng" children
          _buildHeaderCell(Text('Chứng từ', style: style), _flexCtTang),
          _buildHeaderCell(
            Text(
              'Tên, nhãn hiệu, quy cách ${widget.title} cố định',
              style: style,
              textAlign: TextAlign.center,
            ),
            _flexTenTs,
            rowSpan: 2,
          ),
          _buildHeaderCell(
            Text('Đơn vị tính', style: style),
            _flexDvt,
            rowSpan: 2,
          ),
          _buildHeaderCell(
            Text('Số lượng', style: style),
            _flexSlTang,
            rowSpan: 2,
          ),
          _buildHeaderCell(
            Text('Đơn giá', style: style),
            _flexDonGia,
            rowSpan: 2,
          ),
          _buildHeaderCell(
            Text('Số tiền', style: style),
            _flexStTang,
            rowSpan: 2,
          ),

          // "Ghi giảm" children
          _buildHeaderCell(Text('Chứng từ', style: style), _flexCtGiam),
          _buildHeaderCell(Text('Lý do', style: style), _flexLyDo, rowSpan: 2),
          _buildHeaderCell(
            Text('Số lượng', style: style),
            _flexSlGiam,
            rowSpan: 2,
          ),
          _buildHeaderCell(
            Text('Số tiền', style: style),
            _flexStGiam,
            rowSpan: 2,
          ),

          // Ô trống cho cột Ghi chú (đã bị rowSpan)
          _buildEmptyFlex(_flexGhiChu, isLast: true),
        ],
      ),
    );
  }

  /// Hàng header 3: Số hiệu / Ngày / ...
  Widget _buildHeaderRow3() {
    const style = TextStyle(fontWeight: FontWeight.bold);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // "Chứng từ" (tăng) children
          _buildHeaderCell(
            Text('Số hiệu', style: style),
            _flexCtSoHieu,
            isSubHeader: true,
          ),
          _buildHeaderCell(
            Text('Ngày, tháng', style: style),
            _flexCtNgay,
            isSubHeader: true,
          ),

          // Ô rỗng cho các cột đã bị rowSpan
          _buildEmptyFlex(_flexTenTs),
          _buildEmptyFlex(_flexDvt),
          _buildEmptyFlex(_flexSlTang),
          _buildEmptyFlex(_flexDonGia),
          _buildEmptyFlex(_flexStTang),

          // "Chứng từ" (giảm) children
          _buildHeaderCell(
            Text('Số hiệu', style: style),
            _flexCtGiamSoHieu,
            isSubHeader: true,
          ),
          _buildHeaderCell(
            Text('Ngày, tháng', style: style),
            _flexCtGiamNgay,
            isSubHeader: true,
          ),

          // Ô rỗng cho các cột đã bị rowSpan
          _buildEmptyFlex(_flexLyDo),
          _buildEmptyFlex(_flexSlGiam),
          _buildEmptyFlex(_flexStGiam),

          // Ô trống cho cột Ghi chú
          _buildEmptyFlex(_flexGhiChu, isLast: true),
        ],
      ),
    );
  }

  /// Hàng dữ liệu (TextField)
  Widget _buildDataRow(AssetLedgerRowData rowData) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextFieldCell(
            rowData.ctTangSoHieu,
            _flexCtSoHieu,
            align: TextAlign.left,
          ),
          _buildTextFieldCell(
            rowData.ctTangNgayThang,
            _flexCtNgay,
            align: TextAlign.center,
          ),
          _buildTextFieldCell(rowData.tenTs, _flexTenTs, align: TextAlign.left),
          _buildTextFieldCell(rowData.dvt, _flexDvt, align: TextAlign.center),
          _buildTextFieldCell(
            rowData.tangSl,
            _flexSlTang,
            align: TextAlign.right,
            keyboardType: TextInputType.number,
          ),
          _buildTextFieldCell(
            rowData.tangDonGia,
            _flexDonGia,
            align: TextAlign.right,
            keyboardType: TextInputType.number,
          ),
          _buildTextFieldCell(
            rowData.tangSoTien,
            _flexStTang,
            align: TextAlign.right,
            keyboardType: TextInputType.number,
          ),
          _buildTextFieldCell(
            rowData.ctGiamSoHieu,
            _flexCtGiamSoHieu,
            align: TextAlign.left,
          ),
          _buildTextFieldCell(
            rowData.ctGiamNgayThang,
            _flexCtGiamNgay,
            align: TextAlign.center,
          ),
          _buildTextFieldCell(
            rowData.giamLyDo,
            _flexLyDo,
            align: TextAlign.left,
          ),
          _buildTextFieldCell(
            rowData.giamSl,
            _flexSlGiam,
            align: TextAlign.right,
            keyboardType: TextInputType.number,
          ),
          _buildTextFieldCell(
            rowData.giamSoTien,
            _flexStGiam,
            align: TextAlign.right,
            keyboardType: TextInputType.number,
          ),
          _buildTextFieldCell(
            rowData.ghiChu,
            _flexGhiChu,
            align: TextAlign.left,
            isLast: true,
          ),
        ],
      ),
    );
  }

  // /// Nút thêm hàng
  // Widget _buildAddRowButton() {
  //   return TextButton.icon(
  //     icon: const Icon(Icons.add_circle_outline),
  //     label: const Text('Thêm hàng mới'),
  //     onPressed: _addRow,
  //   );
  // }

  //--- CÁC HÀM TRỢ GIÚP (HELPER) ---

  /// Helper cho ô Header
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
            // Không vẽ border dưới nếu ô đó chiếm nhiều hàng
            bottom:
                rowSpan == 1 || isSubHeader
                    ? const BorderSide(color: Colors.black, width: 1.0)
                    : BorderSide.none,
            right:
                isLast
                    ? BorderSide.none
                    : const BorderSide(color: Colors.black, width: 1.0),
            // Vẽ border trên cho các ô con (sub-header)
            top:
                isSubHeader
                    ? const BorderSide(color: Colors.black, width: 1.0)
                    : BorderSide.none,
          ),
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
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
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
          // Trang trí để bỏ gạch chân, làm cho nó giống 1 ô
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
          // Vẫn vẽ border phải để giữ cấu trúc cột
          border: Border(
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
            children: [
              SGText(text: '- Sổ này có '),
              EditablePlaceholder(
                controller: TextEditingController(),
                placeholder: "...",
              ),
              SGText(
                text: " trang, đánh số từ trang 01 đến trang ",
                style: SettingPage.textStyle,
              ),
              EditablePlaceholder(
                controller: TextEditingController(),
                placeholder: "...",
              ),
            ],
          ),
          Row(
            children: [
              SGText(text: '- Ngày mở sổ: ', style: SettingPage.textStyle),
              EditablePlaceholder(
                controller: TextEditingController(),
                placeholder: "...",
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
                    SGText(text: ''),
                    SGText(
                      text: "Người ghi sổ",
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
                    SGText(text: ''),
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
                          style: SettingPage.textStyle.copyWith(),
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
                      text: "Giám đốc",
                      style: SettingPage.textStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

//Detail page
class DetailPageWidget extends StatefulWidget {
  const DetailPageWidget({super.key});

  @override
  State<DetailPageWidget> createState() => _DetailPageWidgetState();
}

class _DetailPageWidgetState extends State<DetailPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SGText(text: ''),
            SGText(text: ''),
            SGText(text: ''),
            SGText(text: ''),
            SGText(
              text: 'SỔ THEO DÕI TÀI SẢN CỐ ĐỊNH VÀ CÔNG CỤ,',
              style: SettingPage.textStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SGText(
              text: 'DỤNG CỤ TẠI NƠI SỬ DỤNG',
              style: SettingPage.textStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SGText(
              text: '(Mẫu số S22-DN)',
              style: SettingPage.textStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            Text.rich(
              TextSpan(
                // Style mặc định cho cả đoạn 1 (chữ thường)
                style: SettingPage.textStyle,
                children: [
                  // Chữ "1. Mục đích :" (đậm)
                  TextSpan(
                    text: "1. Mục đích : ",
                    style: SettingPage.textStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Nội dung (chữ thường)
                  const TextSpan(
                    text:
                        "Sổ này dùng để ghi chép tình hình tăng, giảm tài sản cố định và công cụ, dụng cụ tại từng nơi sử dụng nhằm quản lý tài sản và dụng cụ đã được cấp cho các phòng, ban làm căn cứ để đối chiếu khi tiến hành kiểm kê định kỳ.",
                  ),
                ],
              ),
            ),
          ],
        ),
        SGText(
          text: '2. Căn cứ và phương pháp ghi sổ',
          style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold),
        ),
        SGText(
          text:
              'Mỗi đơn vị hoặc bộ phận (phân xưởng, phòng ban...) thuộc doanh nghiệp phải mở một sổ để theo dõi tài sản. Căn cứ vào chứng từ gốc về tăng, giảm tài sản để ghi vào sổ tài sản theo đơn vị sử dụng như sau:',
          style: SettingPage.textStyle,
        ),
        SGText(
          text:
              '- Cột A, B: Ghi số hiệu, ngày tháng của chứng từ tăng tài sản cố định và công cụ, dụng cụ.',
          style: SettingPage.textStyle,
        ),
        SGText(
          text: '- Cột C: Ghi tên nhãn hiệu TSCĐ và công cụ, dụng cụ',
          style: SettingPage.textStyle,
        ),
        SGText(
          text: '- Cột D: Ghi đơn vị tính (cái, chiếc...)',
          style: SettingPage.textStyle,
        ),
        SGText(text: '- Cột 1: Ghi số lượng', style: SettingPage.textStyle),
        SGText(
          text: '- Cột 2: Ghi nguyên giá TSCĐ hoặc đơn giá công cụ, dụng cụ',
          style: SettingPage.textStyle,
        ),
        SGText(
          text: '- Cột 3: Ghi số tiền (Cột 3 = Cột 1 x Cột 2)',
          style: SettingPage.textStyle,
        ),
        SGText(
          text:
              '- Cột  E, G: Ghi số hiệu, ngày tháng của chứng từ ghi giảm tài sản cố định và công cụ, dụng cụ.',
          style: SettingPage.textStyle,
        ),
        SGText(
          text: '- Cột H: Ghi lý do giảm tài sản cố định và công cụ , dụng cụ',
          style: SettingPage.textStyle,
        ),
        SGText(
          text:
              '- Cột 4: Ghi số lượng tài sản cố định và công cụ, dụng cụ giảm',
          style: SettingPage.textStyle,
        ),
        SGText(
          text:
              '- Cột 5: Ghi nguyên giá tài sản cố định và giá trị công cụ, dụng cụ giảm.',
          style: SettingPage.textStyle,
        ),
      ],
    );
  }
}
