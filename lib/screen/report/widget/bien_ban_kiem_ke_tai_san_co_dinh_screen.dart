import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/tai_san_co_dinh_dto.dart';
import 'package:quan_ly_tai_san_app/screen/report/repository/tai_san_co_dinh_repository.dart';
import 'package:quan_ly_tai_san_app/screen/report/views/bien_ban_kiem_ke_tai_san_co_dinh_page.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import 'package:quan_ly_tai_san_app/screen/report/service/screenshot_to_excel_service.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';

class BienBanKiemKeTaiSanCoDinhScreen extends StatefulWidget {
  final String idDonVi;
  final String tenDonVi;
  final String denNgay;

  const BienBanKiemKeTaiSanCoDinhScreen({
    super.key,
    required this.idDonVi,
    required this.tenDonVi,
    required this.denNgay,
  });

  @override
  State<BienBanKiemKeTaiSanCoDinhScreen> createState() =>
      _BienBanKiemKeTaiSanCoDinhScreenState();
}

class _BienBanKiemKeTaiSanCoDinhScreenState
    extends State<BienBanKiemKeTaiSanCoDinhScreen> {
  List<TaiSanCoDinhDto> _taiSanCoDinhList = [];
  bool _isLoading = true;
  bool isExporting = false;
  final GlobalKey _repaintKey = GlobalKey();
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final repository = TaiSanCoDinhRepository();
      final result = await repository.getListTaiSanCoDinh(widget.idDonVi);

      if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
        setState(() {
          _taiSanCoDinhList = result['data'] ?? [];
          _isLoading = false;
        });
        log('getListTaiSanCoDinhSuccess: ${_taiSanCoDinhList.length}');
      } else {
        setState(() {
          _error = 'Lỗi khi tải dữ liệu';
          _isLoading = false;
        });
      }
    } catch (e) {
      SGLog.error("BienBanKiemKeTaiSanCoDinhScreen", "Error loading data: $e");
      setState(() {
        _error = 'Lỗi khi tải dữ liệu: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> exportToExcel() async {
    setState(() => isExporting = true);

    try {
      await ScreenshotToExcelService.exportReportToExcel(
        repaintKey: _repaintKey,
        reportTitle: 'Bao_Cao_05_TSCD',
      );

      if (mounted) {
        AppUtility.showSnackBar(context, 'Xuất Excel thành công!');
      }
    } catch (e) {
      SGLog.error("BienBanKiemKeTaiSanCoDinhScreen", "Lỗi xuất Excel: $e");
      if (mounted) {
        AppUtility.showSnackBar(context, 'Lỗi xuất Excel: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => isExporting = false);
      }
    }
  }

  Future<void> _exportToPDF() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chức năng xuất PDF đang được phát triển'),
        ),
      );
    } catch (e) {
      SGLog.error(
        "BienBanKiemKeTaiSanCoDinhScreen",
        "Error exporting to PDF: $e",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biên bản kiểm kê tài sản cố định'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _exportToPDF,
          ),
          // Hidden per user request: Excel export button
          // IconButton(
          //   icon: const Icon(Icons.table_chart),
          //   tooltip: 'Xuất Excel',
          //   onPressed: _isExporting ? null : _exportToExcel,
          // ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadData,
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              )
              : _taiSanCoDinhList.isEmpty
              ? const Center(child: Text('Không có dữ liệu'))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: RepaintBoundary(
                  key: _repaintKey,
                  child: BienBanKiemKeTaiSanCoDinhPage(
                    taiSanCoDinhList: _taiSanCoDinhList,
                    denNgay: widget.denNgay,
                    tenDonVi: widget.tenDonVi,
                  ),
                ),
              ),
    );
  }
}
