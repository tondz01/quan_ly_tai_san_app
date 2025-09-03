import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_date.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/common/widgets/a4_canvas.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/providers/departments_provider.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/inventory_minutes.dart';
import 'package:quan_ly_tai_san_app/screen/report/repository/report_repository.dart';
import 'package:quan_ly_tai_san_app/screen/report/views/bien_ban_kiem_ke_page.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class BienBanKiemKeScreen extends StatefulWidget {
  const BienBanKiemKeScreen({super.key});

  @override
  State<BienBanKiemKeScreen> createState() => _BienBanKiemKeScreenState();
}

class _BienBanKiemKeScreenState extends State<BienBanKiemKeScreen> {
  List<InventoryMinutes> _list = [];
  final ReportRepository _repo = ReportRepository();
  final GlobalKey _contractKey = GlobalKey();

  TextEditingController controllerImportDate = TextEditingController();
  TextEditingController controllerDonVi = TextEditingController();

  List<PhongBan> listPhongBan = [];
  PhongBan? donVi;
  bool _isLoading = false;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _exportToPdf() async {
    setState(() {
      _isExporting = true;
    });
    try {
      final pdf = pw.Document();
      final boundary =
          _contractKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary != null) {
        // Đợi để đảm bảo UI đã được render hoàn toàn
        await Future.delayed(const Duration(milliseconds: 100));

        // Tăng pixelRatio để có độ phân giải cao hơn
        final image = await boundary.toImage(pixelRatio: 3.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        final pngBytes = byteData!.buffer.asUint8List();

        // Kiểm tra kích thước ảnh
        final imageWidth = image.width.toDouble();
        final imageHeight = image.height.toDouble();

        if (imageWidth.isNaN ||
            imageHeight.isNaN ||
            imageWidth <= 0 ||
            imageHeight <= 0) {
          throw Exception(
            'Kích thước ảnh không hợp lệ: ${imageWidth}x$imageHeight',
          );
        }

        final imageProvider = pw.MemoryImage(pngBytes);

        // Tính toán tỷ lệ để giữ nguyên aspect ratio
        final aspectRatio = imageWidth / imageHeight;
        final a4AspectRatio = PdfPageFormat.a4.width / PdfPageFormat.a4.height;

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4.portrait,
            margin: const pw.EdgeInsets.all(20), // Thêm margin nhỏ
            build: (context) {
              if (aspectRatio > a4AspectRatio) {
                // Ảnh rộng hơn trang A4, fit theo chiều rộng
                return pw.Center(
                  child: pw.Image(imageProvider, fit: pw.BoxFit.fitWidth),
                );
              } else {
                // Ảnh cao hơn trang A4, fit theo chiều cao
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
              'bien_ban_kiem_ke_${DateTime.now().millisecondsSinceEpoch}.pdf',
        );
      }
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
    listPhongBan = await DepartmentsProvider().fetchDepartments();
    setState(() {});
  }

  Future<void> onloadViewPage() async {
    if (donVi == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Format date to YYYY-MM-DD format
    String formattedDate = controllerImportDate.text;
    if (formattedDate.isNotEmpty) {
      try {
        // Parse the date from the controller
        DateTime parsedDate = DateTime.parse(formattedDate);
        // Format to YYYY-MM-DD
        formattedDate = "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";
      } catch (e) {
        // If parsing fails, try DD/MM/YYYY format
        try {
          final parts = formattedDate.split('/');
          if (parts.length == 3) {
            final day = int.parse(parts[0]);
            final month = int.parse(parts[1]);
            final year = int.parse(parts[2]);
            formattedDate = "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
          }
        } catch (e) {
          // Keep original format if all parsing fails
        }
      }
    }

    final result = await _repo.getInventoryMinutes(
      donVi!.id!,
      formattedDate,
    );

    setState(() {
      _list = (result['data'] as List).cast<InventoryMinutes>();
      _isLoading = false;
    });
  }

  String formatDate(String date) {
    try {
      // Try parsing as ISO format first
      final DateTime parsedDate = DateTime.parse(date);
      return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
    } catch (e) {
      // If that fails, try parsing DD/MM/YYYY HH:mm:ss format
      try {
        final parts = date.split(' ');
        if (parts.isNotEmpty) {
          final datePart = parts[0];
          final dateParts = datePart.split('/');
          if (dateParts.length == 3) {
            final day = int.parse(dateParts[0]);
            final month = int.parse(dateParts[1]);
            final year = int.parse(dateParts[2]);
            return "$day/$month/$year";
          }
        }
      } catch (e) {
        // If all parsing fails, return the original string
        return date;
      }
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 16.0,
              bottom: 16.0,
            ),
            child: SizedBox(
              width: 960,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        SGText(
                          text: 'Biên bản kiểm kê',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(),
                        CmFormDate(
                          label: 'Ngày kiểm kê',
                          controller: controllerImportDate,
                          isEditing: true,
                          fieldName: 'importDate',
                          onChanged: (date) {
                            setState(() {});
                          },
                        ),
                        CmFormDropdownObject<PhongBan>(
                          label: 'Đơn vị',
                          controller: controllerDonVi,
                          isEditing: true,
                          items: [
                            ...listPhongBan.map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.tenPhongBan ?? ''),
                              ),
                            ),
                          ],
                          fieldName: 'tPDonVi',
                          value: donVi,
                          onChanged: (value) {
                            setState(() {
                              donVi = value;
                            });
                          },
                        ),
                        Divider(),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _loadData();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Làm mới file',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Expanded(child: SizedBox.shrink()),
                            GestureDetector(
                              onTap: () {
                                _exportToPdf();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Xuất PDF',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: RepaintBoundary(
                            key: _contractKey,
                            child: A4Canvas(
                              marginsMm: EdgeInsets.all(4),
                              scale: 1.2,
                              maxWidth: 800,
                              maxHeight: 800 * (297 / 210),
                              child: BienBanKiemKePage(
                                inventoryMinutes: _list,
                                denNgay: formatDate(controllerImportDate.text),
                                tenDonVi: donVi?.tenPhongBan ?? '',
                              ),
                            ),
                          ),
                        ),

                        if (_isLoading)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black54,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
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
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }
}
