import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_date.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/khau_hao_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/home/scroll_controller.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/report/component/report_provider.dart';
import 'package:quan_ly_tai_san_app/screen/report/repository/tai_san_co_dinh_repository.dart';
import 'package:quan_ly_tai_san_app/screen/report/views/so_tai_san_co_dinh_s21_page.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class MauSo21Screen extends StatefulWidget {
  const MauSo21Screen({super.key});

  @override
  State<MauSo21Screen> createState() => _MauSo21ScreenState();
}

class _MauSo21ScreenState extends State<MauSo21Screen> {
  final GlobalKey _repaintKey = GlobalKey();
  final TaiSanCoDinhRepository _repository = TaiSanCoDinhRepository();

  TextEditingController controllerImportDate = TextEditingController();
  TextEditingController controllerLoaiTaiSan = TextEditingController();

  List<AssetGroupDto> listAssetGroup = [];
  AssetGroupDto? loaiTaiSan;
  String? selectedYear;
  List<KhauHaoTaiSanDto> listKhauHaoTaiSan = [];
  bool _isLoading = false;
  bool _isExporting = false;
  late HomeScrollController _scrollController;

  void _onScrollStateChanged() {
    // setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController = HomeScrollController();
    _scrollController.addListener(_onScrollStateChanged);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollStateChanged);
    controllerImportDate.dispose();
    controllerLoaiTaiSan.dispose();
    super.dispose();
  }

  Future<void> _exportToPdf() async {
    setState(() {
      _isExporting = true;
    });
    try {
      final pdf = pw.Document();
      await WidgetsBinding.instance.endOfFrame;

      if (_repaintKey.currentContext == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không có nội dung để xuất.')),
          );
        }
        return;
      }

      await Future.delayed(const Duration(milliseconds: 50));

      final boundary =
          _repaintKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final imageWidth = image.width.toDouble();
      final imageHeight = image.height.toDouble();
      if (imageWidth.isNaN ||
          imageHeight.isNaN ||
          imageWidth <= 0 ||
          imageHeight <= 0) {
        return;
      }

      final imageProvider = pw.MemoryImage(pngBytes);
      final aspectRatio = imageWidth / imageHeight;
      final a4AspectRatio = PdfPageFormat.a4.width / PdfPageFormat.a4.height;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.landscape,
          margin: const pw.EdgeInsets.all(20),
          build: (context) {
            if (aspectRatio > a4AspectRatio) {
              return pw.Center(
                child: pw.Image(imageProvider, fit: pw.BoxFit.fitWidth),
              );
            } else {
              return pw.Center(
                child: pw.Image(imageProvider, fit: pw.BoxFit.fitHeight),
              );
            }
          },
        ),
      );

      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename:
            'so_tai_san_co_dinh_s21_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
    } catch (e) {
      SGLog.error('Lỗi xuất PDF', 'Lỗi xuất PDF: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi xuất PDF: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  Future<void> _loadData() async {
    listAssetGroup = AccountHelper.instance.getAssetGroup() ?? [];
    setState(() {});
  }

  Future<void> onloadViewPage() async {
    if (loaiTaiSan == null) {
      AppUtility.showSnackBar(
        context,
        'Vui lòng chọn loại tài sản!',
        isError: true,
      );
      return;
    }

    if (controllerImportDate.text.trim().isEmpty) {
      AppUtility.showSnackBar(context, 'Vui lòng chọn năm!', isError: true);
      return;
    }

    // Get company ID
    final userInfo = AccountHelper.instance.getUserInfo();
    if (userInfo?.idCongTy == null) {
      AppUtility.showSnackBar(
        context,
        'Không tìm thấy thông tin công ty!',
        isError: true,
      );
      return;
    }

    // Extract date components
    try {
      final dateStr = formatToYyyyMmDd(controllerImportDate.text);
      final dateTime = DateTime.parse(dateStr);
      final year = dateTime.year.toString();
      final month = dateTime.month.toString();
      final day = dateTime.day.toString();

      setState(() {
        _isLoading = true;
        selectedYear = year;
      });
      debugPrint("huynd call api");
      // Call API to get khấu hao tài sản
      final result = await _repository.getKhauHaoTaiSan(
        idCongTy: userInfo!.idCongTy,
        ngay: day,
        thang: month,
        nam: year,
        idNhomTaiSan: loaiTaiSan!.id!,
      );

      if (!mounted) return;

      if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
        setState(() {
          listKhauHaoTaiSan = result['data'] as List<KhauHaoTaiSanDto>;
          _isLoading = false;
        });
        AppUtility.showSnackBar(
          context,
          'Lấy dữ liệu thành công! (${listKhauHaoTaiSan.length} bản ghi)',
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        AppUtility.showSnackBar(context, 'Không có báo cáo', isError: true);
      }
    } catch (e) {
      SGLog.error('onloadViewPage', 'Lỗi: $e');
      AppUtility.showSnackBar(
        context,
        'Lỗi khi xử lý dữ liệu: $e',
        isError: true,
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  String formatToYyyyMmDd(String input) {
    final String trimmed = input.trim();
    if (trimmed.isEmpty) return trimmed;
    try {
      final DateTime parsedIso = DateTime.parse(trimmed.split(' ').first);
      return "${parsedIso.year}-${parsedIso.month.toString().padLeft(2, '0')}-${parsedIso.day.toString().padLeft(2, '0')}";
    } catch (_) {
      try {
        final String dateOnly = trimmed.split(' ').first;
        final List<String> parts = dateOnly.split('/');
        if (parts.length == 3) {
          final int day = int.parse(parts[0]);
          final int month = int.parse(parts[1]);
          final int year = int.parse(parts[2]);
          return "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
        }
      } catch (e) {
        SGLog.info('formattedDate', 'DD/MM/YYYY parse error: $e');
      }
    }
    return trimmed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Center(
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
                              text: 'Sổ tài sản cố định (S21-DN)',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(height: 32),
                            Row(
                              children: [
                                Expanded(
                                  child: CmFormDate(
                                    label: 'Năm',
                                    controller: controllerImportDate,
                                    isEditing: true,
                                    fieldName: 'year',
                                    onChanged: (date) {},
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: CmFormDropdownObject<AssetGroupDto>(
                                    label: 'Loại tài sản',
                                    controller: controllerLoaiTaiSan,
                                    isEditing: true,
                                    items: [
                                      ...listAssetGroup.map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e.tenNhom ?? ''),
                                        ),
                                      ),
                                    ],
                                    fieldName: 'loaiTaiSan',
                                    value: loaiTaiSan,
                                    onChanged: (value) {
                                      setState(() {
                                        loaiTaiSan = value;
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
                                  onPressed: onloadViewPage,
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
                                  onPressed: _exportToPdf,
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
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) async {
                                          await ReportProvider()
                                              .exportToPdfAndPrint(
                                                [_repaintKey],
                                                context,
                                                () {
                                                  setState(
                                                    () => _isExporting = false,
                                                  );
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

                    // Content
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
                        child: Stack(
                          children: [
                            SingleChildScrollView(
                              physics:
                                  _scrollController.isParentScrolling
                                      ? const NeverScrollableScrollPhysics()
                                      : const BouncingScrollPhysics(),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: RepaintBoundary(
                                  key: _repaintKey,
                                  child: SoTaiSanCoDinhS21Page(
                                    year: selectedYear,
                                    loaiTaiSan: loaiTaiSan,
                                    khauHaoTaiSanList: listKhauHaoTaiSan,
                                  ),
                                ),
                              ),
                            ),
                            if (_isLoading)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black54,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isExporting)
            Container(
              width: double.maxFinite,
              height: double.maxFinite,
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
