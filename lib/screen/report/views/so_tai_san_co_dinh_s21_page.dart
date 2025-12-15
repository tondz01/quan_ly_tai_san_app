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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:Center(
                child: _buildTable(),
              ),
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
    // Tổng width: 50 + 620 + 300 + 250 = 1220
    const double tableWidth = 1230;

    return Center(
      child: Container(
        width: tableWidth,
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
                  Container(
                    width: 50,
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
                  // Phần còn lại của header
                  Expanded(
                    child: Column(
                      children: [
                        // Header Row 1
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildHeaderCell(
                                'Ghi tăng TSCD',
                                620,
                                textStyle: textStyle,
                              ),
                              _buildHeaderCell(
                                'Khấu hao TSCD',
                                300,
                                textStyle: textStyle,
                              ),
                              _buildHeaderCell(
                                'Ghi giảm TSCD',
                                250,
                                textStyle: textStyle,
                                isLast: true,
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
                              SizedBox(
                                width: 120,
                                child: Column(
                                  children: [
                                    _buildHeaderCell(
                                      'Chứng từ',
                                      120,
                                      textStyle: textStyle,
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          _buildHeaderCell(
                                            'Số hiệu',
                                            60,
                                            textStyle: textStyle,
                                          ),
                                          _buildHeaderCell(
                                            'Ngày tháng',
                                            60,
                                            textStyle: textStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Tên, đặc điểm - merge 2 hàng
                              Container(
                                width: 140,
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
                              // Nước sản xuất - merge 2 hàng
                              Container(
                                width: 80,
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
                              // Tháng năm đưa vào sử dụng - merge 2 hàng
                              Container(
                                width: 90,
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
                              // Số hiệu TSCD - merge 2 hàng
                              Container(
                                width: 90,
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
                              // Nguyên giá TSCD - merge 2 hàng
                              Container(
                                width: 100,
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
                              // Khấu hao - chia thành 2 hàng
                              SizedBox(
                                width: 180,
                                child: Column(
                                  children: [
                                    _buildHeaderCell(
                                      'Khấu hao',
                                      180,
                                      textStyle: textStyle,
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          _buildHeaderCell(
                                            'Tỷ lệ (%)\nkhấu hao',
                                            90,
                                            textStyle: textStyle,
                                          ),
                                          _buildHeaderCell(
                                            'Mức khấu\nhao',
                                            90,
                                            textStyle: textStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Khấu hao đã tính - merge 2 hàng
                              Container(
                                width: 120,
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
                              // Chứng từ (Ghi giảm) - chia thành 2 hàng
                              SizedBox(
                                width: 120,
                                child: Column(
                                  children: [
                                    _buildHeaderCell(
                                      'Chứng từ',
                                      120,
                                      textStyle: textStyle,
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          _buildHeaderCell(
                                            'Số hiệu',
                                            60,
                                            textStyle: textStyle,
                                          ),
                                          _buildHeaderCell(
                                            'Ngày, tháng,\nnăm',
                                            60,
                                            textStyle: textStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Lý do giảm TSCD - merge 2 hàng
                              Container(
                                width: 130,
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
                  _buildHeaderCell(
                    'A',
                    50,
                    isFirst: true,
                    textStyle: textStyle,
                  ),
                  _buildHeaderCell('B', 60, textStyle: textStyle),
                  _buildHeaderCell('C', 60, textStyle: textStyle),
                  _buildHeaderCell('D', 140, textStyle: textStyle),
                  _buildHeaderCell('E', 80, textStyle: textStyle),
                  _buildHeaderCell('G', 90, textStyle: textStyle),
                  _buildHeaderCell('H', 90, textStyle: textStyle),
                  _buildHeaderCell('I', 100, textStyle: textStyle),
                  _buildHeaderCell('2', 90, textStyle: textStyle),
                  _buildHeaderCell('3', 90, textStyle: textStyle),
                  _buildHeaderCell('4', 120, textStyle: textStyle),
                  _buildHeaderCell('I', 60, textStyle: textStyle),
                  _buildHeaderCell('K', 60, textStyle: textStyle),
                  _buildHeaderCell(
                    'L',
                    130,
                    textStyle: textStyle,
                    isLast: true,
                  ),
                ],
              ),
            ),

            // Data rows
            ..._rows.map((row) => _buildDataRow(row)),

            // Summary row
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildStaticCell('', 50, isFirst: true),
                  _buildStaticCell('Cộng', 60),
                  _buildStaticCell('x', 60),
                  _buildStaticCell('x', 140),
                  _buildStaticCell('x', 80),
                  _buildStaticCell('', 90),
                  _buildStaticCell('', 90),
                  _buildDataCell(
                    '',
                    100,
                    summaryNguyenGiaController,
                    keyboardType: TextInputType.number,
                  ),
                  _buildStaticCell('', 90),
                  _buildStaticCell('', 90),
                  _buildDataCell(
                    '',
                    120,
                    summaryKhauHaoDaTinhController,
                    keyboardType: TextInputType.number,
                  ),
                  _buildStaticCell('x', 60),
                  _buildStaticCell('x', 60),
                  _buildStaticCell('x', 130, isLast: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(S21RowData row) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDataCell(
            row.stt.text,
            50,
            row.stt,
            align: TextAlign.center,
            isFirst: true,
          ),
          _buildDataCell('', 60, row.chungTuSoHieu),
          _buildDataCell('', 60, row.chungTuNgayThang),
          _buildDataCell('', 140, row.tenDacDiem),
          _buildDataCell('', 80, row.nuocSanXuat),
          _buildDataCell('', 90, row.thangNamDuaVaoSuDung),
          _buildDataCell('', 90, row.soHieuTSCD),
          _buildDataCell(
            '',
            100,
            row.nguyenGia,
            keyboardType: TextInputType.number,
          ),
          _buildDataCell(
            '',
            90,
            row.tyLeKhauHao,
            keyboardType: TextInputType.number,
          ),
          _buildDataCell(
            '',
            90,
            row.mucKhauHao,
            keyboardType: TextInputType.number,
          ),
          _buildDataCell(
            '',
            120,
            row.khauHaoDaTinh,
            keyboardType: TextInputType.number,
          ),
          _buildDataCell('', 60, row.giamChungTuSoHieu),
          _buildDataCell('', 60, row.giamNgayThangNam),
          _buildDataCell('', 130, row.lyDoGiam, isLast: true),
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
    String text,
    double width, {
    bool isFirst = false,
    bool isLast = false,
    required TextStyle textStyle,
  }) {
    return Container(
      width: width,
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
    double width,
    TextEditingController controller, {
    TextAlign align = TextAlign.left,
    TextInputType keyboardType = TextInputType.text,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      width: width,
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
    String text,
    double width, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      width: width,
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
