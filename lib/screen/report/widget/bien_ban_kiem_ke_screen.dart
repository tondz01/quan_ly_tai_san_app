import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:quan_ly_tai_san_app/common/widgets/a4_canvas.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/inventory_minutes.dart';
import 'package:quan_ly_tai_san_app/screen/report/repository/report_repository.dart';
import 'package:quan_ly_tai_san_app/screen/report/views/bien_ban_kiem_ke_page.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class BienBanKiemKeScreen extends StatefulWidget {
  final String idDonVi;
  final String tenDonVi;
  final String denNgay;
  final Function()? onExportPdf;

  const BienBanKiemKeScreen({
    super.key,
    required this.idDonVi,
    required this.tenDonVi,
    required this.denNgay,
    this.onExportPdf,
  });

  @override
  State<BienBanKiemKeScreen> createState() => _BienBanKiemKeScreenState();
}

class _BienBanKiemKeScreenState extends State<BienBanKiemKeScreen> {
  final ReportRepository _repo = ReportRepository();
  List<InventoryMinutes> _list = [];
  final GlobalKey _contractKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _exportToPdf() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final pdf = pw.Document();
      final boundary =
          _contractKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary != null && boundary.debugNeedsPaint == false) {
        await Future.delayed(const Duration(milliseconds: 50));

        final image = await boundary.toImage(pixelRatio: 2.0);
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
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4.portrait,
            margin: pw.EdgeInsets.zero,
            build:
                (context) => pw.SizedBox.expand(
                  child: pw.FittedBox(
                    fit: pw.BoxFit.fill,
                    child: pw.Image(imageProvider),
                  ),
                ),
          ),
        );

        await Printing.sharePdf(
          bytes: await pdf.save(),
          filename: 'document.pdf',
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
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _loadData() async {
    final result = await _repo.getInventoryMinutes(
      widget.idDonVi,
      widget.denNgay,
    );

    setState(() {
      _list = (result['data'] as List).cast<InventoryMinutes>();
    });

    await Future.delayed(const Duration(seconds: 1));

    await _exportToPdf();

    widget.onExportPdf?.call();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _contractKey,
      child: A4Canvas(
        marginsMm: EdgeInsets.all(20),
        scale: 1.2,
        maxWidth: 800,
        maxHeight: 800 * (297 / 210),
        child: BienBanKiemKePage(
          inventoryMinutes: _list,
          denNgay: widget.denNgay,
          tenDonVi: widget.tenDonVi,
        ),
      ),
    );
  }
}