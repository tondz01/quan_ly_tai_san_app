import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/tai_san_co_dinh_dto.dart';
import 'package:quan_ly_tai_san_app/screen/report/repository/tai_san_co_dinh_repository.dart';
import 'package:quan_ly_tai_san_app/screen/report/views/bien_ban_kiem_ke_tai_san_co_dinh_page.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

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
      print('result: ${result}');

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

  Future<void> _exportToPDF() async {
    try {
      // TODO: Implement PDF export functionality
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
                child: BienBanKiemKeTaiSanCoDinhPage(
                  taiSanCoDinhList: _taiSanCoDinhList,
                  denNgay: widget.denNgay,
                  tenDonVi: widget.tenDonVi,
                ),
              ),
    );
  }
}
