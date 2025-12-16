import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/khau_hao_tai_san_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';

import '../../../common/page/contract_page.dart' show SettingPage;

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SoTaiSanCoDinhS21Page(),
    ),
  );
}

class SoTaiSanCoDinhS21Page extends StatefulWidget {
  final String? year;
  final AssetGroupDto? loaiTaiSan;
  final List<KhauHaoTaiSanDto>? khauHaoTaiSanList;

  const SoTaiSanCoDinhS21Page({
    super.key,
    this.year,
    this.loaiTaiSan,
    this.khauHaoTaiSanList,
  });

  @override
  State<SoTaiSanCoDinhS21Page> createState() => _SoTaiSanCoDinhS21PageState();
}

class _SoTaiSanCoDinhS21PageState extends State<SoTaiSanCoDinhS21Page> {
  // Controllers cho header
  final TextEditingController donViController = TextEditingController();
  final TextEditingController diaChiController = TextEditingController();
  final TextEditingController namController = TextEditingController();
  final TextEditingController loaiTaiSanController = TextEditingController();

  // Controllers cho footer
  final TextEditingController soTrangController = TextEditingController();
  final TextEditingController ngayMoSoController = TextEditingController();
  final TextEditingController ngayKyController = TextEditingController();

  // Controllers cho summary row (dòng tổng cộng)
  final TextEditingController summaryNguyenGiaController =
      TextEditingController();
  final TextEditingController summaryKhauHaoDaTinhController =
      TextEditingController();

  // List data rows
  final List<S21RowData> _rows = [];

  @override
  void initState() {
    super.initState();
    _updateControllers();
    _loadDataFromApi();
  }

  @override
  void didUpdateWidget(SoTaiSanCoDinhS21Page oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.year != widget.year ||
        oldWidget.loaiTaiSan != widget.loaiTaiSan ||
        oldWidget.khauHaoTaiSanList != widget.khauHaoTaiSanList) {
      _updateControllers();
      _loadDataFromApi();
    }
  }

  void _updateControllers() {
    if (widget.year != null) {
      namController.text = widget.year!;
    }
    if (widget.loaiTaiSan != null) {
      loaiTaiSanController.text = widget.loaiTaiSan!.tenNhom ?? '';
    }
  }

  // Helper: format số, nếu = 0 thì trả về ''
  String _formatNumber(num? value) {
    if (value == null || value == 0) return '';
    return value.toStringAsFixed(0);
  }

  void _loadDataFromApi() {
    setState(() {
      _rows.clear();

      if (widget.khauHaoTaiSanList != null &&
          widget.khauHaoTaiSanList!.isNotEmpty) {
        // Convert từ KhauHaoTaiSanDto sang S21RowData
        double totalNguyenGia = 0;
        double totalKhauHaoDaTinh = 0;

        for (int i = 0; i < widget.khauHaoTaiSanList!.length; i++) {
          final khauHao = widget.khauHaoTaiSanList![i];

          _rows.add(
            S21RowData(
              stt: (i + 1).toString(),
              // Chứng từ
              chungTuSoHieu: '',
              chungTuNgayThang:
                  khauHao.ngayTinhKhao != null
                      ? '${khauHao.ngayTinhKhao!.day.toString().padLeft(2, '0')}/${khauHao.ngayTinhKhao!.month.toString().padLeft(2, '0')}/${khauHao.ngayTinhKhao!.year}'
                      : '',
              // Tên, đặc điểm TSCD
              tenDacDiem: khauHao.tenTaiSan ?? '',
              // Nước sản xuất (không có trong API)
              nuocSanXuat: '',
              // Tháng năm đưa vào sử dụng
              thangNamDuaVaoSuDung:
                  khauHao.thangKh != null ? 'Tháng ${khauHao.thangKh}' : '',
              // Số hiệu TSCD
              soHieuTSCD: khauHao.soThe ?? '',
              // Nguyên giá
              nguyenGia: _formatNumber(khauHao.nguyenGia),
              // Tỷ lệ khấu hao (không có trong API, tính từ data nếu có)
              tyLeKhauHao: '',
              // Mức khấu hao
              mucKhauHao: _formatNumber(khauHao.khauHaoBinhQuan),
              // Khấu hao đã tính
              khauHaoDaTinh: _formatNumber(khauHao.khauHaoPsck),
              // Ghi giảm - Chứng từ
              giamChungTuSoHieu: '',
              giamNgayThangNam: '',
              // Lý do giảm
              lyDoGiam: khauHao.ghiChuKhao ?? '',
            ),
          );

          // Tính tổng
          totalNguyenGia += khauHao.nguyenGia ?? 0;
          totalKhauHaoDaTinh += khauHao.khauHaoPsck ?? 0;
        }

        // Cập nhật tổng cộng (chỉ hiện nếu > 0)
        summaryNguyenGiaController.text = _formatNumber(totalNguyenGia);
        summaryKhauHaoDaTinhController.text = _formatNumber(totalKhauHaoDaTinh);
      } else {
        // Nếu không có data từ API, thêm 5 rows trống
        for (int i = 0; i < 5; i++) {
          _rows.add(S21RowData(stt: (i + 1).toString()));
        }
      }
    });
  }

  @override
  void dispose() {
    donViController.dispose();
    diaChiController.dispose();
    namController.dispose();
    loaiTaiSanController.dispose();
    soTrangController.dispose();
    ngayMoSoController.dispose();
    ngayKyController.dispose();
    summaryNguyenGiaController.dispose();
    summaryKhauHaoDaTinhController.dispose();

    for (var row in _rows) {
      row.dispose();
    }
    super.dispose();
  }

  void _addRow() {
    setState(() {
      _rows.add(S21RowData(stt: (_rows.length + 1).toString()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildTitle(),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              const double minTableWidth = 1230;
              final double viewportWidth = constraints.maxWidth;
              final double tableWidth =
                  viewportWidth > minTableWidth ? viewportWidth : minTableWidth;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: _buildTable(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildFooter(),
          const SizedBox(height: 16),
          _buildSignatures(),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              onPressed: _addRow,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Thêm dòng'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SGText(text: 'Đơn vị:', style: SettingPage.textStyle),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: donViController,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: '.....................',
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                      ),
                      style: SettingPage.textStyle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  SGText(text: 'Địa chỉ:', style: SettingPage.textStyle),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: diaChiController,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: '.....................',
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                      ),
                      style: SettingPage.textStyle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Right side
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SGText(
                text: 'Mẫu số S21-DN',
                style: SettingPage.textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 4),
              SGText(
                text: '(Ban hành theo Thông tư số 200/2014/TT-BTC',
                style: SettingPage.textStyle.copyWith(fontSize: 11),
                textAlign: TextAlign.right,
              ),
              SGText(
                text: 'Ngày 22/12/2014 của Bộ Tài chính)',
                style: SettingPage.textStyle.copyWith(fontSize: 11),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        SGText(
          text: 'Sổ tài sản cố định',
          style: SettingPage.textStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SGText(text: 'Năm:', style: SettingPage.textStyle),
            SizedBox(
              width: 80,
              child: TextField(
                controller: namController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: '...',
                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                ),
                style: SettingPage.textStyle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SGText(text: 'Loại tài sản:', style: SettingPage.textStyle),
            SizedBox(
              width: 150,
              child: TextField(
                controller: loaiTaiSanController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: '...........',
                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                ),
                style: SettingPage.textStyle,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTable() {
    const textStyle = TextStyle(fontSize: 10, fontWeight: FontWeight.bold);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0.5),
      ),
      child: Column(
        children: [
          // Header Rows 1-3 với STT merge
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Cột STT merge 3 hàng
                Expanded(
                  flex: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        left: const BorderSide(color: Colors.black, width: 0.5),
                        bottom: const BorderSide(
                          color: Colors.black,
                          width: 0.5,
                        ),
                        right: const BorderSide(
                          color: Colors.black,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Center(
                      child: SGText(
                        text: 'STT',
                        style: textStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                // Phần còn lại của header
                Expanded(
                  flex: 1180, // tổng còn lại 1230 - 50
                  child: Column(
                    children: [
                      // Header Row 1
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 620,
                              child: _buildHeaderCell(
                                'Ghi tăng TSCD',
                                textStyle: textStyle,
                              ),
                            ),
                            Expanded(
                              flex: 300,
                              child: _buildHeaderCell(
                                'Khấu hao TSCD',
                                textStyle: textStyle,
                              ),
                            ),
                            Expanded(
                              flex: 250,
                              child: _buildHeaderCell(
                                'Ghi giảm TSCD',
                                textStyle: textStyle,
                                isLast: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Header Row 2-3 với các cột merge
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Chứng từ - chia thành 2 hàng
                            Expanded(
                              flex: 120,
                              child: Column(
                                children: [
                                  _buildHeaderCell(
                                    'Chứng từ',
                                    textStyle: textStyle,
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 60,
                                          child: _buildHeaderCell(
                                            'Số hiệu',
                                            textStyle: textStyle,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 60,
                                          child: _buildHeaderCell(
                                            'Ngày tháng',
                                            textStyle: textStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Tên, đặc điểm - merge 2 hàng
                            Expanded(
                              flex: 140,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom: const BorderSide(
                                      color: Colors.black,
                                      width: 0.5,
                                    ),
                                    right: const BorderSide(
                                      color: Colors.black,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: SGText(
                                    text: 'Tên, đặc\ndiểm, ký hiệu\nTSCD',
                                    style: textStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            // Nước sản xuất - merge 2 hàng
                            Expanded(
                              flex: 80,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom: const BorderSide(
                                      color: Colors.black,
                                      width: 0.5,
                                    ),
                                    right: const BorderSide(
                                      color: Colors.black,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: SGText(
                                    text: 'Nước sản\nxuất',
                                    style: textStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            // Tháng năm đưa vào sử dụng - merge 2 hàng
                            Expanded(
                              flex: 90,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom: const BorderSide(
                                      color: Colors.black,
                                      width: 0.5,
                                    ),
                                    right: const BorderSide(
                                      color: Colors.black,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: SGText(
                                    text: 'Tháng năm,\nđưa vào sử\ndụng',
                                    style: textStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            // Số hiệu TSCD - merge 2 hàng
                            Expanded(
                              flex: 90,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom: const BorderSide(
                                      color: Colors.black,
                                      width: 0.5,
                                    ),
                                    right: const BorderSide(
                                      color: Colors.black,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: SGText(
                                    text: 'Số hiệu\nTSCD',
                                    style: textStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            // Nguyên giá TSCD - merge 2 hàng
                            Expanded(
                              flex: 100,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom: const BorderSide(
                                      color: Colors.black,
                                      width: 0.5,
                                    ),
                                    right: const BorderSide(
                                      color: Colors.black,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: SGText(
                                    text: 'Nguyên giá\nTSCD',
                                    style: textStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            // Khấu hao - chia thành 2 hàng
                            Expanded(
                              flex: 180,
                              child: Column(
                                children: [
                                  _buildHeaderCell(
                                    'Khấu hao',
                                    textStyle: textStyle,
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 90,
                                          child: _buildHeaderCell(
                                            'Tỷ lệ (%)\nkhấu hao',
                                            textStyle: textStyle,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 90,
                                          child: _buildHeaderCell(
                                            'Mức khấu\nhao',
                                            textStyle: textStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Khấu hao đã tính - merge 2 hàng
                            Expanded(
                              flex: 120,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom: const BorderSide(
                                      color: Colors.black,
                                      width: 0.5,
                                    ),
                                    right: const BorderSide(
                                      color: Colors.black,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: SGText(
                                    text:
                                        'Khấu hao\nđã tính đến\nkhi ghi giảm\nTSCD',
                                    style: textStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            // Chứng từ (Ghi giảm) - chia thành 2 hàng
                            Expanded(
                              flex: 120,
                              child: Column(
                                children: [
                                  _buildHeaderCell(
                                    'Chứng từ',
                                    textStyle: textStyle,
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 60,
                                          child: _buildHeaderCell(
                                            'Số hiệu',
                                            textStyle: textStyle,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 60,
                                          child: _buildHeaderCell(
                                            'Ngày, tháng,\nnăm',
                                            textStyle: textStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Lý do giảm TSCD - merge 2 hàng
                            Expanded(
                              flex: 130,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom: const BorderSide(
                                      color: Colors.black,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: SGText(
                                    text: 'Lý do giảm\nTSCD',
                                    style: textStyle,
                                    textAlign: TextAlign.center,
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
              ],
            ),
          ),

          // Header Row 4 - Column labels
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 50,
                  child: _buildHeaderCell(
                    'A',
                    isFirst: true,
                    textStyle: textStyle,
                  ),
                ),
                Expanded(
                  flex: 60,
                  child: _buildHeaderCell('B', textStyle: textStyle),
                ),
                Expanded(
                  flex: 60,
                  child: _buildHeaderCell('C', textStyle: textStyle),
                ),
                Expanded(
                  flex: 140,
                  child: _buildHeaderCell('D', textStyle: textStyle),
                ),
                Expanded(
                  flex: 80,
                  child: _buildHeaderCell('E', textStyle: textStyle),
                ),
                Expanded(
                  flex: 90,
                  child: _buildHeaderCell('G', textStyle: textStyle),
                ),
                Expanded(
                  flex: 90,
                  child: _buildHeaderCell('H', textStyle: textStyle),
                ),
                Expanded(
                  flex: 100,
                  child: _buildHeaderCell('I', textStyle: textStyle),
                ),
                Expanded(
                  flex: 90,
                  child: _buildHeaderCell('2', textStyle: textStyle),
                ),
                Expanded(
                  flex: 90,
                  child: _buildHeaderCell('3', textStyle: textStyle),
                ),
                Expanded(
                  flex: 120,
                  child: _buildHeaderCell('4', textStyle: textStyle),
                ),
                Expanded(
                  flex: 60,
                  child: _buildHeaderCell('I', textStyle: textStyle),
                ),
                Expanded(
                  flex: 60,
                  child: _buildHeaderCell('K', textStyle: textStyle),
                ),
                Expanded(
                  flex: 130,
                  child: _buildHeaderCell(
                    'L',
                    textStyle: textStyle,
                    isLast: true,
                  ),
                ),
              ],
            ),
          ),

          // Data rows
          for (final row in _rows) _buildDataRow(row),

          // Summary row
          _buildSummaryRow(),
        ],
      ),
    );
  }

  Widget _buildDataRow(S21RowData row) {
    // Dùng height cố định để tránh IntrinsicHeight cho mỗi row (tối ưu layout)
    return SizedBox(
      height: 32,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 50,
            child: _buildDataCell(
              row.stt.text,
              row.stt,
              align: TextAlign.center,
              isFirst: true,
            ),
          ),
          Expanded(flex: 60, child: _buildDataCell('', row.chungTuSoHieu)),
          Expanded(flex: 60, child: _buildDataCell('', row.chungTuNgayThang)),
          Expanded(flex: 140, child: _buildDataCell('', row.tenDacDiem)),
          Expanded(flex: 80, child: _buildDataCell('', row.nuocSanXuat)),
          Expanded(
            flex: 90,
            child: _buildDataCell('', row.thangNamDuaVaoSuDung),
          ),
          Expanded(flex: 90, child: _buildDataCell('', row.soHieuTSCD)),
          Expanded(
            flex: 100,
            child: _buildDataCell(
              '',
              row.nguyenGia,
              keyboardType: TextInputType.number,
            ),
          ),
          Expanded(
            flex: 90,
            child: _buildDataCell(
              '',
              row.tyLeKhauHao,
              keyboardType: TextInputType.number,
            ),
          ),
          Expanded(
            flex: 90,
            child: _buildDataCell(
              '',
              row.mucKhauHao,
              keyboardType: TextInputType.number,
            ),
          ),
          Expanded(
            flex: 120,
            child: _buildDataCell(
              '',
              row.khauHaoDaTinh,
              keyboardType: TextInputType.number,
            ),
          ),
          Expanded(
            flex: 60,
            child: _buildDataCell('', row.giamChungTuSoHieu),
          ),
          Expanded(
            flex: 60,
            child: _buildDataCell('', row.giamNgayThangNam),
          ),
          Expanded(
            flex: 130,
            child: _buildDataCell('', row.lyDoGiam, isLast: true),
          ),
        ],
      ),
    );
  }

  // Tách summary row riêng để dễ tối ưu và tái sử dụng
  Widget _buildSummaryRow() {
    return SizedBox(
      height: 32,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 50,
            child: _buildStaticCell('', isFirst: true),
          ),
          Expanded(
            flex: 60,
            child: _buildStaticCell('Cộng'),
          ),
          Expanded(
            flex: 60,
            child: _buildStaticCell('x'),
          ),
          Expanded(
            flex: 140,
            child: _buildStaticCell('x'),
          ),
          Expanded(
            flex: 80,
            child: _buildStaticCell('x'),
          ),
          Expanded(
            flex: 90,
            child: _buildStaticCell(''),
          ),
          Expanded(
            flex: 90,
            child: _buildStaticCell(''),
          ),
          Expanded(
            flex: 100,
            child: _buildDataCell(
              '',
              summaryNguyenGiaController,
              keyboardType: TextInputType.number,
            ),
          ),
          Expanded(
            flex: 90,
            child: _buildStaticCell(''),
          ),
          Expanded(
            flex: 90,
            child: _buildStaticCell(''),
          ),
          Expanded(
            flex: 120,
            child: _buildDataCell(
              '',
              summaryKhauHaoDaTinhController,
              keyboardType: TextInputType.number,
            ),
          ),
          Expanded(
            flex: 60,
            child: _buildStaticCell('x'),
          ),
          Expanded(
            flex: 60,
            child: _buildStaticCell('x'),
          ),
          Expanded(
            flex: 130,
            child: _buildStaticCell('x', isLast: true),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SGText(text: '- Sổ này có ', style: SettingPage.textStyle),
            SizedBox(
              width: 40,
              child: TextField(
                controller: soTrangController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: '...',
                ),
                style: SettingPage.textStyle,
              ),
            ),
            SGText(
              text: ' trang, đánh số từ trang 01 đến trang ',
              style: SettingPage.textStyle,
            ),
            SizedBox(
              width: 40,
              child: TextField(
                controller: soTrangController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: '...',
                ),
                style: SettingPage.textStyle,
              ),
            ),
          ],
        ),
        Row(
          children: [
            SGText(text: '- Ngày mở sổ: ', style: SettingPage.textStyle),
            SizedBox(
              width: 100,
              child: TextField(
                controller: ngayMoSoController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: '...',
                ),
                style: SettingPage.textStyle,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignatures() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                SGText(
                  text: 'Người ghi sổ',
                  style: SettingPage.textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SGText(
                  text: '(Ký, họ tên)',
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
              children: [
                SGText(
                  text: 'Kế toán trưởng',
                  style: SettingPage.textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SGText(
                  text: '(Ký, họ tên)',
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SGText(
                      text: 'Ngày',
                      style: SettingPage.textStyle.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: '...',
                        ),
                        style: SettingPage.textStyle.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    SGText(
                      text: ' tháng',
                      style: SettingPage.textStyle.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: '...',
                        ),
                        style: SettingPage.textStyle.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    SGText(
                      text: ' năm',
                      style: SettingPage.textStyle.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: '......',
                        ),
                        style: SettingPage.textStyle.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                SGText(
                  text: 'Giám đốc',
                  style: SettingPage.textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SGText(
                  text: '(Ký, họ tên, đóng dấu)',
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
    );
  }

  Widget _buildHeaderCell(
    String text, {
    bool isFirst = false,
    bool isLast = false,
    required TextStyle textStyle,
  }) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left:
              isFirst
                  ? const BorderSide(color: Colors.black, width: 0.5)
                  : BorderSide.none,
          bottom: const BorderSide(color: Colors.black, width: 0.5),
          right:
              isLast
                  ? BorderSide.none
                  : const BorderSide(color: Colors.black, width: 0.5),
        ),
      ),
      child: Center(
        child: SGText(
          text: text,
          style: textStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDataCell(
    String initialValue,
    TextEditingController controller, {
    TextAlign align = TextAlign.left,
    TextInputType keyboardType = TextInputType.text,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left:
              isFirst
                  ? const BorderSide(color: Colors.black, width: 0.5)
                  : BorderSide.none,
          bottom: const BorderSide(color: Colors.black, width: 0.5),
          right:
              isLast
                  ? BorderSide.none
                  : const BorderSide(color: Colors.black, width: 0.5),
        ),
      ),
      child: TextField(
        controller: controller,
        textAlign: align,
        keyboardType: keyboardType,
        decoration: const InputDecoration(
          isDense: true,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(4),
        ),
        style: const TextStyle(fontSize: 11),
      ),
    );
  }

  Widget _buildStaticCell(
    String text, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left:
              isFirst
                  ? const BorderSide(color: Colors.black, width: 0.5)
                  : BorderSide.none,
          bottom: const BorderSide(color: Colors.black, width: 0.5),
          right:
              isLast
                  ? BorderSide.none
                  : const BorderSide(color: Colors.black, width: 0.5),
        ),
      ),
      child: SGText(
        text: text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// Data model cho mỗi row
class S21RowData {
  final TextEditingController stt;
  final TextEditingController chungTuSoHieu;
  final TextEditingController chungTuNgayThang;
  final TextEditingController tenDacDiem;
  final TextEditingController nuocSanXuat;
  final TextEditingController thangNamDuaVaoSuDung;
  final TextEditingController soHieuTSCD;
  final TextEditingController nguyenGia;
  final TextEditingController tyLeKhauHao;
  final TextEditingController mucKhauHao;
  final TextEditingController khauHaoDaTinh;
  final TextEditingController giamChungTuSoHieu;
  final TextEditingController giamNgayThangNam;
  final TextEditingController lyDoGiam;

  S21RowData({
    String stt = '',
    String chungTuSoHieu = '',
    String chungTuNgayThang = '',
    String tenDacDiem = '',
    String nuocSanXuat = '',
    String thangNamDuaVaoSuDung = '',
    String soHieuTSCD = '',
    String nguyenGia = '',
    String tyLeKhauHao = '',
    String mucKhauHao = '',
    String khauHaoDaTinh = '',
    String giamChungTuSoHieu = '',
    String giamNgayThangNam = '',
    String lyDoGiam = '',
  }) : stt = TextEditingController(text: stt),
       chungTuSoHieu = TextEditingController(text: chungTuSoHieu),
       chungTuNgayThang = TextEditingController(text: chungTuNgayThang),
       tenDacDiem = TextEditingController(text: tenDacDiem),
       nuocSanXuat = TextEditingController(text: nuocSanXuat),
       thangNamDuaVaoSuDung = TextEditingController(text: thangNamDuaVaoSuDung),
       soHieuTSCD = TextEditingController(text: soHieuTSCD),
       nguyenGia = TextEditingController(text: nguyenGia),
       tyLeKhauHao = TextEditingController(text: tyLeKhauHao),
       mucKhauHao = TextEditingController(text: mucKhauHao),
       khauHaoDaTinh = TextEditingController(text: khauHaoDaTinh),
       giamChungTuSoHieu = TextEditingController(text: giamChungTuSoHieu),
       giamNgayThangNam = TextEditingController(text: giamNgayThangNam),
       lyDoGiam = TextEditingController(text: lyDoGiam);

  void dispose() {
    stt.dispose();
    chungTuSoHieu.dispose();
    chungTuNgayThang.dispose();
    tenDacDiem.dispose();
    nuocSanXuat.dispose();
    thangNamDuaVaoSuDung.dispose();
    soHieuTSCD.dispose();
    nguyenGia.dispose();
    tyLeKhauHao.dispose();
    mucKhauHao.dispose();
    khauHaoDaTinh.dispose();
    giamChungTuSoHieu.dispose();
    giamNgayThangNam.dispose();
    lyDoGiam.dispose();
  }
}
