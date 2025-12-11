import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/inventory_minutes.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/tai_san_co_dinh_dto.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/tang_giam_trong_ky_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/khau_hao_tai_san_dto.dart';

import '../../../common/reponsitory/save_export_file_stub.dart'
    if (dart.library.html) '../../../common/reponsitory/save_export_file_web.dart'
    if (dart.library.io) '../../../common/reponsitory/save_export_file_io.dart';

/// Service for exporting reports to Excel format
class ExcelExportService {
  /// Export S22-DN report data to Excel file matching UI layout
  static Future<void> exportS22DNToExcel({
    required List<Map<String, dynamic>> assetData,
    required List<Map<String, dynamic>> ccdcData,
    required String fromDate,
    required String toDate,
    required String departmentName,
    bool print = false,
  }) async {
    // Create a new Excel document
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    // Set sheet name
    sheet.name = 'S22-DN';

    int currentRow = 1;

    // ===== HEADER: ĐƠN VỊ VÀ THÔNG TIN =====
    // Row 1-2: Đơn vị và địa chỉ (bên trái), Mẫu số S22-DN (bên phải)
    sheet.getRangeByIndex(currentRow, 1, currentRow, 7).merge();
    final donViRange = sheet.getRangeByIndex(currentRow, 1);
    donViRange.setText('Đơn vị: $departmentName');
    donViRange.cellStyle.fontSize = 11;
    donViRange.cellStyle.bold = true;

    sheet.getRangeByIndex(currentRow, 8, currentRow, 13).merge();
    final mauSoRange = sheet.getRangeByIndex(currentRow, 8);
    mauSoRange.setText('Mẫu số S22-DN');
    mauSoRange.cellStyle.fontSize = 11;
    mauSoRange.cellStyle.hAlign = HAlignType.center;
    currentRow++;

    sheet.getRangeByIndex(currentRow, 1, currentRow, 7).merge();
    final diaChiRange = sheet.getRangeByIndex(currentRow, 1);
    diaChiRange.setText('Địa chỉ: ...........');
    diaChiRange.cellStyle.fontSize = 11;
    diaChiRange.cellStyle.bold = true;

    sheet.getRangeByIndex(currentRow, 8, currentRow, 13).merge();
    final thongTuRange = sheet.getRangeByIndex(currentRow, 8);
    thongTuRange.setText('(Ban hành theo Thông tư số 200/2014/TT-BTC\nNgày 22/12/2014 của Bộ Tài chính)');
    thongTuRange.cellStyle.fontSize = 10;
    thongTuRange.cellStyle.hAlign = HAlignType.center;
    thongTuRange.cellStyle.wrapText = true;
    sheet.setRowHeightInPixels(currentRow, 30);
    currentRow++;

    // ===== TITLE =====
    currentRow++;
    sheet.getRangeByIndex(currentRow, 1, currentRow, 13).merge();
    final titleRange = sheet.getRangeByIndex(currentRow, 1);
    titleRange.setText('Sổ Theo dõi tài sản cố định và công cụ, dụng cụ tại nơi sử dụng');
    titleRange.cellStyle.fontSize = 14;
    titleRange.cellStyle.bold = true;
    titleRange.cellStyle.hAlign = HAlignType.center;
    currentRow++;

    // Năm
    sheet.getRangeByIndex(currentRow, 1, currentRow, 13).merge();
    final namRange = sheet.getRangeByIndex(currentRow, 1);
    namRange.setText('Năm ${DateTime.now().year}');
    namRange.cellStyle.fontSize = 11;
    namRange.cellStyle.bold = true;
    currentRow++;

    // Tên đơn vị
    sheet.getRangeByIndex(currentRow, 1, currentRow, 13).merge();
    final tenDonViRange = sheet.getRangeByIndex(currentRow, 1);
    tenDonViRange.setText('Tên đơn vị (phòng, ban hoặc người sử dụng) $departmentName');
    tenDonViRange.cellStyle.fontSize = 11;
    currentRow += 2;

    // ===== SECTION 1: TÀI SẢN CỐ ĐỊNH =====
    if (assetData.isNotEmpty) {
      sheet.getRangeByIndex(currentRow, 1, currentRow, 13).merge();
      final sectionRange = sheet.getRangeByIndex(currentRow, 1);
      sectionRange.setText('Bảng ghi tăng/giảm Tài sản cố định');
      sectionRange.cellStyle.fontSize = 12;
      sectionRange.cellStyle.bold = true;
      sectionRange.cellStyle.hAlign = HAlignType.center;
      currentRow += 2;

      currentRow = _buildTableWithData(sheet, currentRow, assetData, 'tài sản');
      currentRow += 2;
    }

    // ===== SECTION 2: CCDC =====
    if (ccdcData.isNotEmpty) {
      sheet.getRangeByIndex(currentRow, 1, currentRow, 13).merge();
      final sectionRange = sheet.getRangeByIndex(currentRow, 1);
      sectionRange.setText('Bảng ghi tăng/giảm Công cụ, dụng cụ cố định');
      sectionRange.cellStyle.fontSize = 12;
      sectionRange.cellStyle.bold = true;
      sectionRange.cellStyle.hAlign = HAlignType.center;
      currentRow += 2;

      currentRow = _buildTableWithData(sheet, currentRow, ccdcData, 'công cụ, dụng cụ');
      currentRow += 2;
    }

    // ===== FOOTER =====
    _buildFooter(sheet, currentRow);

    // ===== SAVE FILE =====
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String fileName = 'Bao_cao_S22DN_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    await saveExportFile(Uint8List.fromList(bytes), fileName, print: print);
  }

  /// Build table with 3-row header structure matching UI
  static int _buildTableWithData(
    Worksheet sheet,
    int startRow,
    List<Map<String, dynamic>> data,
    String title,
  ) {
    int currentRow = startRow;

    // ===== HEADER ROW 1: "Ghi tăng" / "Ghi giảm" / "Ghi chú" =====
    // "Ghi tăng tài sản cố định" (columns 1-7)
    sheet.getRangeByIndex(currentRow, 1, currentRow, 7).merge();
    final ghiTangCell = sheet.getRangeByIndex(currentRow, 1);
    ghiTangCell.setText('Ghi tăng $title cố định');
    ghiTangCell.cellStyle.fontSize = 11;
    ghiTangCell.cellStyle.bold = true;
    ghiTangCell.cellStyle.hAlign = HAlignType.center;
    ghiTangCell.cellStyle.vAlign = VAlignType.center;
    ghiTangCell.cellStyle.backColor = '#D9E1F2';
    ghiTangCell.cellStyle.borders.all.lineStyle = LineStyle.thin;

    // "Ghi giảm tài sản cố định" (columns 8-12)
    sheet.getRangeByIndex(currentRow, 8, currentRow, 12).merge();
    final ghiGiamCell = sheet.getRangeByIndex(currentRow, 8);
    ghiGiamCell.setText('Ghi giảm $title cố định');
    ghiGiamCell.cellStyle.fontSize = 11;
    ghiGiamCell.cellStyle.bold = true;
    ghiGiamCell.cellStyle.hAlign = HAlignType.center;
    ghiGiamCell.cellStyle.vAlign = VAlignType.center;
    ghiGiamCell.cellStyle.backColor = '#D9E1F2';
    ghiGiamCell.cellStyle.borders.all.lineStyle = LineStyle.thin;

    // "Ghi chú" (column 13, rowspan 3)
    sheet.getRangeByIndex(currentRow, 13, currentRow + 2, 13).merge();
    final ghiChuCell = sheet.getRangeByIndex(currentRow, 13);
    ghiChuCell.setText('Ghi chú');
    ghiChuCell.cellStyle.fontSize = 11;
    ghiChuCell.cellStyle.bold = true;
    ghiChuCell.cellStyle.hAlign = HAlignType.center;
    ghiChuCell.cellStyle.vAlign = VAlignType.center;
    ghiChuCell.cellStyle.backColor = '#D9E1F2';
    ghiChuCell.cellStyle.borders.all.lineStyle = LineStyle.thin;
    currentRow++;

    // ===== HEADER ROW 2: "Chứng từ" / "Tên, nhãn hiệu" / etc. =====
    // Ghi tăng section
    sheet.getRangeByIndex(currentRow, 1, currentRow, 2).merge();
    _setHeaderCell(sheet, currentRow, 1, 'Chứng từ');

    sheet.getRangeByIndex(currentRow, 3, currentRow + 1, 3).merge();
    _setHeaderCell(sheet, currentRow, 3, 'Tên, nhãn hiệu, quy cách $title cố định');

    sheet.getRangeByIndex(currentRow, 4, currentRow + 1, 4).merge();
    _setHeaderCell(sheet, currentRow, 4, 'Đơn vị tính');

    sheet.getRangeByIndex(currentRow, 5, currentRow + 1, 5).merge();
    _setHeaderCell(sheet, currentRow, 5, 'Số lượng');

    sheet.getRangeByIndex(currentRow, 6, currentRow + 1, 6).merge();
    _setHeaderCell(sheet, currentRow, 6, 'Đơn giá');

    sheet.getRangeByIndex(currentRow, 7, currentRow + 1, 7).merge();
    _setHeaderCell(sheet, currentRow, 7, 'Số tiền');

    // Ghi giảm section
    sheet.getRangeByIndex(currentRow, 8, currentRow, 9).merge();
    _setHeaderCell(sheet, currentRow, 8, 'Chứng từ');

    sheet.getRangeByIndex(currentRow, 10, currentRow + 1, 10).merge();
    _setHeaderCell(sheet, currentRow, 10, 'Lý do');

    sheet.getRangeByIndex(currentRow, 11, currentRow + 1, 11).merge();
    _setHeaderCell(sheet, currentRow, 11, 'Số lượng');

    sheet.getRangeByIndex(currentRow, 12, currentRow + 1, 12).merge();
    _setHeaderCell(sheet, currentRow, 12, 'Số tiền');
    currentRow++;

    // ===== HEADER ROW 3: "Số hiệu" / "Ngày, tháng" =====
    _setHeaderCell(sheet, currentRow, 1, 'Số hiệu');
    _setHeaderCell(sheet, currentRow, 2, 'Ngày, tháng');
    _setHeaderCell(sheet, currentRow, 8, 'Số hiệu');
    _setHeaderCell(sheet, currentRow, 9, 'Ngày, tháng');
    currentRow++;

    // ===== DATA ROWS =====
    for (final item in data) {
      // Chứng từ tăng - Số hiệu
      sheet.getRangeByIndex(currentRow, 1).setText(item['ct_tang_so_hieu']?.toString() ?? '');
      _setDataCellStyle(sheet, currentRow, 1, HAlignType.left);

      // Chứng từ tăng - Ngày tháng
      sheet.getRangeByIndex(currentRow, 2).setText(item['ct_tang_ngay']?.toString() ?? '');
      _setDataCellStyle(sheet, currentRow, 2, HAlignType.center);

      // Tên tài sản
      sheet.getRangeByIndex(currentRow, 3).setText(item['ten_ts']?.toString() ?? '');
      _setDataCellStyle(sheet, currentRow, 3, HAlignType.left);

      // Đơn vị tính
      sheet.getRangeByIndex(currentRow, 4).setText(item['dvt']?.toString() ?? '');
      _setDataCellStyle(sheet, currentRow, 4, HAlignType.center);

      // Số lượng tăng
      if (item['tang_sl'] != null && item['tang_sl'].toString().isNotEmpty) {
        sheet.getRangeByIndex(currentRow, 5).setNumber(
          double.tryParse(item['tang_sl'].toString()) ?? 0
        );
        sheet.getRangeByIndex(currentRow, 5).numberFormat = '#,##0';
      }
      _setDataCellStyle(sheet, currentRow, 5, HAlignType.right);

      // Đơn giá tăng
      if (item['tang_don_gia'] != null && item['tang_don_gia'].toString().isNotEmpty) {
        sheet.getRangeByIndex(currentRow, 6).setNumber(
          double.tryParse(item['tang_don_gia'].toString()) ?? 0
        );
        sheet.getRangeByIndex(currentRow, 6).numberFormat = '#,##0';
      }
      _setDataCellStyle(sheet, currentRow, 6, HAlignType.right);

      // Số tiền tăng
      if (item['tang_so_tien'] != null && item['tang_so_tien'].toString().isNotEmpty) {
        sheet.getRangeByIndex(currentRow, 7).setNumber(
          double.tryParse(item['tang_so_tien'].toString()) ?? 0
        );
        sheet.getRangeByIndex(currentRow, 7).numberFormat = '#,##0';
      }
      _setDataCellStyle(sheet, currentRow, 7, HAlignType.right);

      // Chứng từ giảm - Số hiệu
      sheet.getRangeByIndex(currentRow, 8).setText(item['ct_giam_so_hieu']?.toString() ?? '');
      _setDataCellStyle(sheet, currentRow, 8, HAlignType.left);

      // Chứng từ giảm - Ngày tháng
      sheet.getRangeByIndex(currentRow, 9).setText(item['ct_giam_ngay']?.toString() ?? '');
      _setDataCellStyle(sheet, currentRow, 9, HAlignType.center);

      // Lý do giảm
      sheet.getRangeByIndex(currentRow, 10).setText(item['giam_ly_do']?.toString() ?? '');
      _setDataCellStyle(sheet, currentRow, 10, HAlignType.left);

      // Số lượng giảm
      if (item['giam_sl'] != null && item['giam_sl'].toString().isNotEmpty) {
        sheet.getRangeByIndex(currentRow, 11).setNumber(
          double.tryParse(item['giam_sl'].toString()) ?? 0
        );
        sheet.getRangeByIndex(currentRow, 11).numberFormat = '#,##0';
      }
      _setDataCellStyle(sheet, currentRow, 11, HAlignType.right);

      // Số tiền giảm
      if (item['giam_so_tien'] != null && item['giam_so_tien'].toString().isNotEmpty) {
        sheet.getRangeByIndex(currentRow, 12).setNumber(
          double.tryParse(item['giam_so_tien'].toString()) ?? 0
        );
        sheet.getRangeByIndex(currentRow, 12).numberFormat = '#,##0';
      }
      _setDataCellStyle(sheet, currentRow, 12, HAlignType.right);

      // Ghi chú
      sheet.getRangeByIndex(currentRow, 13).setText(item['ghi_chu']?.toString() ?? '');
      _setDataCellStyle(sheet, currentRow, 13, HAlignType.left);

      currentRow++;
    }

    // Set column widths
    sheet.getRangeByIndex(1, 1).columnWidth = 10;  // Số hiệu (tăng)
    sheet.getRangeByIndex(1, 2).columnWidth = 12;  // Ngày tháng (tăng)
    sheet.getRangeByIndex(1, 3).columnWidth = 35;  // Tên TS
    sheet.getRangeByIndex(1, 4).columnWidth = 10;  // ĐVT
    sheet.getRangeByIndex(1, 5).columnWidth = 10;  // SL (tăng)
    sheet.getRangeByIndex(1, 6).columnWidth = 15;  // Đơn giá
    sheet.getRangeByIndex(1, 7).columnWidth = 15;  // Số tiền (tăng)
    sheet.getRangeByIndex(1, 8).columnWidth = 10;  // Số hiệu (giảm)
    sheet.getRangeByIndex(1, 9).columnWidth = 12;  // Ngày tháng (giảm)
    sheet.getRangeByIndex(1, 10).columnWidth = 15; // Lý do
    sheet.getRangeByIndex(1, 11).columnWidth = 10; // SL (giảm)
    sheet.getRangeByIndex(1, 12).columnWidth = 15; // Số tiền (giảm)
    sheet.getRangeByIndex(1, 13).columnWidth = 20; // Ghi chú

    return currentRow;
  }

  /// Set header cell style
  static void _setHeaderCell(Worksheet sheet, int row, int col, String text) {
    final cell = sheet.getRangeByIndex(row, col);
    cell.setText(text);
    cell.cellStyle.fontSize = 11;
    cell.cellStyle.bold = true;
    cell.cellStyle.hAlign = HAlignType.center;
    cell.cellStyle.vAlign = VAlignType.center;
    cell.cellStyle.backColor = '#D9E1F2';
    cell.cellStyle.borders.all.lineStyle = LineStyle.thin;
    cell.cellStyle.wrapText = true;
  }

  /// Set data cell style
  static void _setDataCellStyle(Worksheet sheet, int row, int col, HAlignType align) {
    final cell = sheet.getRangeByIndex(row, col);
    cell.cellStyle.fontSize = 11;
    cell.cellStyle.hAlign = align;
    cell.cellStyle.vAlign = VAlignType.center;
    cell.cellStyle.borders.all.lineStyle = LineStyle.thin;
  }

  /// Build footer section
  static void _buildFooter(Worksheet sheet, int startRow) {
    int currentRow = startRow;

    // Sổ này có ... trang
    sheet.getRangeByIndex(currentRow, 1, currentRow, 13).merge();
    final soTrangRange = sheet.getRangeByIndex(currentRow, 1);
    soTrangRange.setText('- Sổ này có ... trang, đánh số từ trang 01 đến trang ...');
    soTrangRange.cellStyle.fontSize = 11;
    currentRow++;

    // Ngày mở sổ
    sheet.getRangeByIndex(currentRow, 1, currentRow, 13).merge();
    final ngayMoRange = sheet.getRangeByIndex(currentRow, 1);
    ngayMoRange.setText('- Ngày mở sổ: ...');
    ngayMoRange.cellStyle.fontSize = 11;
    currentRow += 2;

    // Người ghi sổ / Kế toán trưởng / Giám đốc
    sheet.getRangeByIndex(currentRow, 1, currentRow, 4).merge();
    final nguoiGhiRange = sheet.getRangeByIndex(currentRow, 1);
    nguoiGhiRange.setText('Người ghi sổ\n(Ký, họ tên)');
    nguoiGhiRange.cellStyle.fontSize = 11;
    nguoiGhiRange.cellStyle.bold = true;
    nguoiGhiRange.cellStyle.hAlign = HAlignType.center;
    nguoiGhiRange.cellStyle.wrapText = true;

    sheet.getRangeByIndex(currentRow, 5, currentRow, 8).merge();
    final keToanRange = sheet.getRangeByIndex(currentRow, 5);
    keToanRange.setText('Kế toán trưởng\n(Ký, họ tên)');
    keToanRange.cellStyle.fontSize = 11;
    keToanRange.cellStyle.bold = true;
    keToanRange.cellStyle.hAlign = HAlignType.center;
    keToanRange.cellStyle.wrapText = true;

    sheet.getRangeByIndex(currentRow, 9, currentRow, 13).merge();
    final giamDocRange = sheet.getRangeByIndex(currentRow, 9);
    giamDocRange.setText('Ngày ... tháng ... năm ...\nGiám đốc\n(Ký, họ tên, đóng dấu)');
    giamDocRange.cellStyle.fontSize = 11;
    giamDocRange.cellStyle.bold = true;
    giamDocRange.cellStyle.hAlign = HAlignType.center;
    giamDocRange.cellStyle.wrapText = true;

    sheet.setRowHeightInPixels(currentRow, 60);
    currentRow += 2;

    // ===== PHẦN HƯỚNG DẪN SỬ DỤNG SỔ =====
    _buildDetailSection(sheet, currentRow);
  }

  /// Build detail/instruction section (DetailPageWidget equivalent)
  static void _buildDetailSection(Worksheet sheet, int startRow) {
    int currentRow = startRow;

    // Spacing
    currentRow += 4;

    // Title section
    sheet.getRangeByIndex(currentRow, 1, currentRow, 13).merge();
    final title1 = sheet.getRangeByIndex(currentRow, 1);
    title1.setText('SỔ THEO DÕI TÀI SẢN CỐ ĐỊNH VÀ CÔNG CỤ,');
    title1.cellStyle.fontSize = 12;
    title1.cellStyle.bold = true;
    title1.cellStyle.hAlign = HAlignType.center;
    currentRow++;

    sheet.getRangeByIndex(currentRow, 1, currentRow, 13).merge();
    final title2 = sheet.getRangeByIndex(currentRow, 1);
    title2.setText('DỤNG CỤ TẠI NƠI SỬ DỤNG');
    title2.cellStyle.fontSize = 12;
    title2.cellStyle.bold = true;
    title2.cellStyle.hAlign = HAlignType.center;
    currentRow++;

    sheet.getRangeByIndex(currentRow, 1, currentRow, 13).merge();
    final title3 = sheet.getRangeByIndex(currentRow, 1);
    title3.setText('(Mẫu số S22-DN)');
    title3.cellStyle.fontSize = 12;
    title3.cellStyle.bold = true;
    title3.cellStyle.hAlign = HAlignType.center;
    currentRow += 2;

    // 1. Mục đích
    sheet.getRangeByIndex(currentRow, 1, currentRow, 13).merge();
    final mucDich = sheet.getRangeByIndex(currentRow, 1);
    mucDich.setText('1. Mục đích : Sổ này dùng để ghi chép tình hình tăng, giảm tài sản cố định và công cụ, dụng cụ tại từng nơi sử dụng nhằm quản lý tài sản và dụng cụ đã được cấp cho các phòng, ban làm căn cứ để đối chiếu khi tiến hành kiểm kê định kỳ.');
    mucDich.cellStyle.fontSize = 11;
    mucDich.cellStyle.wrapText = true;
    sheet.setRowHeightInPixels(currentRow, 40);
    currentRow++;

    // 2. Căn cứ và phương pháp ghi sổ
    sheet.getRangeByIndex(currentRow, 1, currentRow, 13).merge();
    final phuongPhap = sheet.getRangeByIndex(currentRow, 1);
    phuongPhap.setText('2. Căn cứ và phương pháp ghi sổ');
    phuongPhap.cellStyle.fontSize = 11;
    phuongPhap.cellStyle.bold = true;
    currentRow++;

    // Đoạn mở đầu
    sheet.getRangeByIndex(currentRow, 1, currentRow, 13).merge();
    final intro = sheet.getRangeByIndex(currentRow, 1);
    intro.setText('Mỗi đơn vị hoặc bộ phận (phân xưởng, phòng ban...) thuộc doanh nghiệp phải mở một sổ để theo dõi tài sản. Căn cứ vào chứng từ gốc về tăng, giảm tài sản để ghi vào sổ tài sản theo đơn vị sử dụng như sau:');
    intro.cellStyle.fontSize = 11;
    intro.cellStyle.wrapText = true;
    sheet.setRowHeightInPixels(currentRow, 35);
    currentRow++;

    // Các hướng dẫn chi tiết
    final List<String> instructions = [
      '- Cột A, B: Ghi số hiệu, ngày tháng của chứng từ tăng tài sản cố định và công cụ, dụng cụ.',
      '- Cột C: Ghi tên nhãn hiệu TSCĐ và công cụ, dụng cụ',
      '- Cột D: Ghi đơn vị tính (cái, chiếc...)',
      '- Cột 1: Ghi số lượng',
      '- Cột 2: Ghi nguyên giá TSCĐ hoặc đơn giá công cụ, dụng cụ',
      '- Cột 3: Ghi số tiền (Cột 3 = Cột 1 x Cột 2)',
      '- Cột  E, G: Ghi số hiệu, ngày tháng của chứng từ ghi giảm tài sản cố định và công cụ, dụng cụ.',
      '- Cột H: Ghi lý do giảm tài sản cố định và công cụ , dụng cụ',
      '- Cột 4: Ghi số lượng tài sản cố định và công cụ, dụng cụ giảm',
      '- Cột 5: Ghi nguyên giá tài sản cố định và giá trị công cụ, dụng cụ giảm.',
    ];

    for (final instruction in instructions) {
      sheet.getRangeByIndex(currentRow, 1, currentRow, 13).merge();
      final cell = sheet.getRangeByIndex(currentRow, 1);
      cell.setText(instruction);
      cell.cellStyle.fontSize = 11;
      cell.cellStyle.wrapText = true;
      sheet.setRowHeightInPixels(currentRow, 20);
      currentRow++;
    }
  }

  // ========================================================================
  // BIÊN BẢN KIỂM KÊ EXPORT
  // ========================================================================

  /// Export Biên bản kiểm kê to Excel
  static Future<void> exportBienBanKiemKeToExcel({
    required List<InventoryMinutes> data,
    required String departmentName,
    required String ngayKiemKe,
  }) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'Bien_Ban_Kiem_Ke';

    int currentRow = 1;

    // ===== HEADER =====
    // Row 1: TẬP ĐOÀN CÔNG NGHIỆP (left) | Mẫu số 01a-TS (right)
    sheet.getRangeByIndex(currentRow, 1, currentRow, 4).merge();
    final tapDoanRange = sheet.getRangeByIndex(currentRow, 1);
    tapDoanRange.setText('TẬP ĐOÀN CÔNG NGHIỆP\nTHAN - KHOÁNG SẢN VIỆT NAM');
    tapDoanRange.cellStyle.fontSize = 11;
    tapDoanRange.cellStyle.hAlign = HAlignType.center;
    tapDoanRange.cellStyle.wrapText = true;

    sheet.getRangeByIndex(currentRow, 5, currentRow, 8).merge();
    final mauSoRange = sheet.getRangeByIndex(currentRow, 5);
    mauSoRange.setText('Mẫu số 01a-TS');
    mauSoRange.cellStyle.fontSize = 11;
    mauSoRange.cellStyle.bold = true;
    mauSoRange.cellStyle.hAlign = HAlignType.center;
    sheet.setRowHeightInPixels(currentRow, 35);
    currentRow++;

    // Row 2: CÔNG TY THAN UÔNG BÍ - TKV (left) | (Ban hành...) (right)
    sheet.getRangeByIndex(currentRow, 1, currentRow, 4).merge();
    final congTyRange = sheet.getRangeByIndex(currentRow, 1);
    congTyRange.setText('CÔNG TY THAN UÔNG BÍ - TKV');
    congTyRange.cellStyle.fontSize = 11;
    congTyRange.cellStyle.bold = true;
    congTyRange.cellStyle.hAlign = HAlignType.center;

    sheet.getRangeByIndex(currentRow, 5, currentRow, 8).merge();
    final banHanhRange = sheet.getRangeByIndex(currentRow, 5);
    banHanhRange.setText('(Ban hành kèm theo QĐ số ...../QĐ-TUB\nngày ..../..../.... của Giám đốc Công ty)');
    banHanhRange.cellStyle.fontSize = 10;
    banHanhRange.cellStyle.hAlign = HAlignType.center;
    banHanhRange.cellStyle.wrapText = true;
    sheet.setRowHeightInPixels(currentRow, 30);
    currentRow += 2;

    // Title
    sheet.getRangeByIndex(currentRow, 1, currentRow, 8).merge();
    final titleRange = sheet.getRangeByIndex(currentRow, 1);
    titleRange.setText('BIÊN BẢN KIỂM KÊ TÀI SẢN CỐ ĐỊNH VÀ CÔNG CỤ DỤNG CỤ');
    titleRange.cellStyle.fontSize = 14;
    titleRange.cellStyle.bold = true;
    titleRange.cellStyle.hAlign = HAlignType.center;
    currentRow++;

    // Đơn vị
    sheet.getRangeByIndex(currentRow, 1, currentRow, 8).merge();
    final donViRange = sheet.getRangeByIndex(currentRow, 1);
    donViRange.setText('Đơn vị: $departmentName');
    donViRange.cellStyle.fontSize = 11;
    donViRange.cellStyle.bold = true;
    donViRange.cellStyle.hAlign = HAlignType.center;
    currentRow++;

    // Thời điểm kiểm kê
    sheet.getRangeByIndex(currentRow, 1, currentRow, 8).merge();
    final thoiDiemRange = sheet.getRangeByIndex(currentRow, 1);
    thoiDiemRange.setText('Thời điểm kiểm kê: $ngayKiemKe');
    thoiDiemRange.cellStyle.fontSize = 11;
    thoiDiemRange.cellStyle.hAlign = HAlignType.center;
    currentRow += 2;

    // ===== TABLE HEADER =====
    final headers = [
      'STT',
      'Tên tài sản',
      'Đơn vị tính',
      'Nước sản xuất',
      'Phương thức kiểm kê',
      'Số lượng kiểm kê thực tế',
      'Hiện trạng',
      'Ghi chú',
    ];

    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.getRangeByIndex(currentRow, i + 1);
      cell.setText(headers[i]);
      cell.cellStyle.fontSize = 11;
      cell.cellStyle.bold = true;
      cell.cellStyle.hAlign = HAlignType.center;
      cell.cellStyle.vAlign = VAlignType.center;
      cell.cellStyle.backColor = '#D9E1F2';
      cell.cellStyle.borders.all.lineStyle = LineStyle.thin;
      cell.cellStyle.wrapText = true;
    }
    sheet.setRowHeightInPixels(currentRow, 40);
    currentRow++;

    // ===== DATA ROWS =====
    for (int i = 0; i < data.length; i++) {
      final item = data[i];

      // STT
      sheet.getRangeByIndex(currentRow, 1).setNumber(i + 1);
      _setDataCellStyle(sheet, currentRow, 1, HAlignType.center);

      // Tên tài sản
      sheet.getRangeByIndex(currentRow, 2).setText(item.tenTaiSan ?? '');
      _setDataCellStyle(sheet, currentRow, 2, HAlignType.left);

      // Đơn vị tính
      sheet.getRangeByIndex(currentRow, 3).setText(item.donViTinh);
      _setDataCellStyle(sheet, currentRow, 3, HAlignType.center);

      // Nước sản xuất
      sheet.getRangeByIndex(currentRow, 4).setText(item.nuocSanXuat ?? '');
      _setDataCellStyle(sheet, currentRow, 4, HAlignType.center);

      // Phương thức kiểm kê
      sheet.getRangeByIndex(currentRow, 5).setText(item.phuongThucKiemKe ?? '');
      _setDataCellStyle(sheet, currentRow, 5, HAlignType.center);

      // Số lượng kiểm kê thực tế
      if (item.soLuongKiemKeThucTe != null) {
        sheet.getRangeByIndex(currentRow, 6).setNumber(item.soLuongKiemKeThucTe!.toDouble());
        sheet.getRangeByIndex(currentRow, 6).numberFormat = '#,##0';
      }
      _setDataCellStyle(sheet, currentRow, 6, HAlignType.right);

      // Hiện trạng
      sheet.getRangeByIndex(currentRow, 7).setText(item.hienTrang ?? '');
      _setDataCellStyle(sheet, currentRow, 7, HAlignType.left);

      // Ghi chú
      sheet.getRangeByIndex(currentRow, 8).setText(item.ghiChu ?? '');
      _setDataCellStyle(sheet, currentRow, 8, HAlignType.left);

      currentRow++;
    }

    // Set column widths
    sheet.getRangeByIndex(1, 1).columnWidth = 6;
    sheet.getRangeByIndex(1, 2).columnWidth = 35;
    sheet.getRangeByIndex(1, 3).columnWidth = 12;
    sheet.getRangeByIndex(1, 4).columnWidth = 15;
    sheet.getRangeByIndex(1, 5).columnWidth = 18;
    sheet.getRangeByIndex(1, 6).columnWidth = 15;
    sheet.getRangeByIndex(1, 7).columnWidth = 20;
    sheet.getRangeByIndex(1, 8).columnWidth = 20;

    // ===== FOOTER =====
    currentRow += 2;
    _buildBienBanKiemKeFooter(sheet, currentRow);

    // ===== SAVE FILE =====
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String fileName = 'Bien_ban_kiem_ke_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx';
    await saveExportFile(Uint8List.fromList(bytes), fileName);
  }

  static void _buildBienBanKiemKeFooter(Worksheet sheet, int startRow) {
    int currentRow = startRow;

    sheet.getRangeByIndex(currentRow, 1, currentRow, 8).merge();
    final ketThucRange = sheet.getRangeByIndex(currentRow, 1);
    ketThucRange.setText('Biên bản được lập xong hồi ....... giờ cùng ngày, các thành viên thống nhất thông qua.');
    ketThucRange.cellStyle.fontSize = 11;
    currentRow += 2;

    // Signatures
    sheet.getRangeByIndex(currentRow, 1, currentRow, 4).merge();
    final giamDocRange = sheet.getRangeByIndex(currentRow, 1);
    giamDocRange.setText('Giám đốc\n(Ghi ý kiến giải quyết số chênh lệch)\n(Ký, họ tên, đóng dấu)');
    giamDocRange.cellStyle.fontSize = 11;
    giamDocRange.cellStyle.bold = true;
    giamDocRange.cellStyle.hAlign = HAlignType.center;
    giamDocRange.cellStyle.wrapText = true;

    sheet.getRangeByIndex(currentRow, 5, currentRow, 8).merge();
    final keToanRange = sheet.getRangeByIndex(currentRow, 5);
    keToanRange.setText('Kế toán\n(Ký, họ tên)');
    keToanRange.cellStyle.fontSize = 11;
    keToanRange.cellStyle.bold = true;
    keToanRange.cellStyle.hAlign = HAlignType.center;
    keToanRange.cellStyle.wrapText = true;

    sheet.setRowHeightInPixels(currentRow, 60);
  }

  // ========================================================================
  // BÁO CÁO 05-TSCD EXPORT
  // ========================================================================

  /// Export Báo cáo 05-TSCD (Biên bản kiểm kê TSCĐ) to Excel
  static Future<void> exportBaoCao05TSCDToExcel({
    required List<TaiSanCoDinhDto> data,
    required String departmentName,
    required String ngayKiemKe,
  }) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'Bao_cao_05_TSCD';

    int currentRow = 1;

    // ===== HEADER =====
    sheet.getRangeByIndex(currentRow, 1, currentRow, 7).merge();
    final tapDoanRange = sheet.getRangeByIndex(currentRow, 1);
    tapDoanRange.setText('TẬP ĐOÀN CÔNG NGHIỆP\nTHAN - KHOÁNG SẢN VIỆT NAM');
    tapDoanRange.cellStyle.fontSize = 11;
    tapDoanRange.cellStyle.hAlign = HAlignType.center;
    tapDoanRange.cellStyle.wrapText = true;

    sheet.getRangeByIndex(currentRow, 8, currentRow, 14).merge();
    final mauSoRange = sheet.getRangeByIndex(currentRow, 8);
    mauSoRange.setText('Mẫu số 05 - TSCĐ');
    mauSoRange.cellStyle.fontSize = 11;
    mauSoRange.cellStyle.bold = true;
    mauSoRange.cellStyle.hAlign = HAlignType.center;
    sheet.setRowHeightInPixels(currentRow, 35);
    currentRow++;

    sheet.getRangeByIndex(currentRow, 1, currentRow, 7).merge();
    final congTyRange = sheet.getRangeByIndex(currentRow, 1);
    congTyRange.setText('CÔNG TY THAN UÔNG BÍ - TKV');
    congTyRange.cellStyle.fontSize = 11;
    congTyRange.cellStyle.bold = true;
    congTyRange.cellStyle.hAlign = HAlignType.center;

    sheet.getRangeByIndex(currentRow, 8, currentRow, 14).merge();
    final banHanhRange = sheet.getRangeByIndex(currentRow, 8);
    banHanhRange.setText('Ban hành kèm theo QĐ số ...../QĐ-TUB\nngày ..../..../.... của Giám đốc Công ty');
    banHanhRange.cellStyle.fontSize = 10;
    banHanhRange.cellStyle.hAlign = HAlignType.center;
    banHanhRange.cellStyle.wrapText = true;
    sheet.setRowHeightInPixels(currentRow, 30);
    currentRow += 2;

    // Title
    sheet.getRangeByIndex(currentRow, 1, currentRow, 14).merge();
    final titleRange = sheet.getRangeByIndex(currentRow, 1);
    titleRange.setText('BIÊN BẢN KIỂM KÊ TÀI SẢN CỐ ĐỊNH');
    titleRange.cellStyle.fontSize = 14;
    titleRange.cellStyle.bold = true;
    titleRange.cellStyle.hAlign = HAlignType.center;
    currentRow++;

    sheet.getRangeByIndex(currentRow, 1, currentRow, 14).merge();
    final donViRange = sheet.getRangeByIndex(currentRow, 1);
    donViRange.setText('Đơn vị: $departmentName');
    donViRange.cellStyle.fontSize = 11;
    donViRange.cellStyle.bold = true;
    donViRange.cellStyle.hAlign = HAlignType.center;
    currentRow++;

    sheet.getRangeByIndex(currentRow, 1, currentRow, 14).merge();
    final thoiDiemRange = sheet.getRangeByIndex(currentRow, 1);
    thoiDiemRange.setText('Thời điểm kiểm kê: $ngayKiemKe');
    thoiDiemRange.cellStyle.fontSize = 11;
    thoiDiemRange.cellStyle.hAlign = HAlignType.center;
    currentRow += 2;

    // ===== TABLE HEADER ROW 1 =====
    // STT (rowspan 2)
    sheet.getRangeByIndex(currentRow, 1, currentRow + 1, 1).merge();
    _setHeaderCell(sheet, currentRow, 1, 'STT');

    // Tên TSCĐ (rowspan 2)
    sheet.getRangeByIndex(currentRow, 2, currentRow + 1, 2).merge();
    _setHeaderCell(sheet, currentRow, 2, 'Tên TSCĐ');

    // Mã số (rowspan 2)
    sheet.getRangeByIndex(currentRow, 3, currentRow + 1, 3).merge();
    _setHeaderCell(sheet, currentRow, 3, 'Mã số');

    // Nơi sử dụng (rowspan 2)
    sheet.getRangeByIndex(currentRow, 4, currentRow + 1, 4).merge();
    _setHeaderCell(sheet, currentRow, 4, 'Nơi sử dụng');

    // Kế toán (colspan 3)
    sheet.getRangeByIndex(currentRow, 5, currentRow, 7).merge();
    _setHeaderCell(sheet, currentRow, 5, 'Kế toán');

    // Kiểm kê (colspan 3)
    sheet.getRangeByIndex(currentRow, 8, currentRow, 10).merge();
    _setHeaderCell(sheet, currentRow, 8, 'Kiểm kê');

    // Chênh lệch (colspan 3)
    sheet.getRangeByIndex(currentRow, 11, currentRow, 13).merge();
    _setHeaderCell(sheet, currentRow, 11, 'Chênh lệch');

    // Ghi chú (rowspan 2)
    sheet.getRangeByIndex(currentRow, 14, currentRow + 1, 14).merge();
    _setHeaderCell(sheet, currentRow, 14, 'Ghi chú');
    currentRow++;

    // ===== TABLE HEADER ROW 2 =====
    // Kế toán sub-columns
    _setHeaderCell(sheet, currentRow, 5, 'Số lượng');
    _setHeaderCell(sheet, currentRow, 6, 'Nguyên giá');
    _setHeaderCell(sheet, currentRow, 7, 'Giá trị còn lại');

    // Kiểm kê sub-columns
    _setHeaderCell(sheet, currentRow, 8, 'Số lượng');
    _setHeaderCell(sheet, currentRow, 9, 'Nguyên giá');
    _setHeaderCell(sheet, currentRow, 10, 'Giá trị còn lại');

    // Chênh lệch sub-columns
    _setHeaderCell(sheet, currentRow, 11, 'Số lượng');
    _setHeaderCell(sheet, currentRow, 12, 'Nguyên giá');
    _setHeaderCell(sheet, currentRow, 13, 'Giá trị còn lại');
    currentRow++;

    // ===== DATA ROWS =====
    for (int i = 0; i < data.length; i++) {
      final item = data[i];

      // STT
      sheet.getRangeByIndex(currentRow, 1).setNumber(i + 1);
      _setDataCellStyle(sheet, currentRow, 1, HAlignType.center);

      // Tên TSCĐ
      sheet.getRangeByIndex(currentRow, 2).setText(item.tenTaiSan);
      _setDataCellStyle(sheet, currentRow, 2, HAlignType.left);

      // Mã số
      sheet.getRangeByIndex(currentRow, 3).setText(item.maSo);
      _setDataCellStyle(sheet, currentRow, 3, HAlignType.center);

      // Nơi sử dụng
      sheet.getRangeByIndex(currentRow, 4).setText(item.noiSuDung);
      _setDataCellStyle(sheet, currentRow, 4, HAlignType.left);

      // Kế toán - Số lượng
      sheet.getRangeByIndex(currentRow, 5).setNumber(item.soLuongSoSach.toDouble());
      sheet.getRangeByIndex(currentRow, 5).numberFormat = '#,##0';
      _setDataCellStyle(sheet, currentRow, 5, HAlignType.right);

      // Kế toán - Nguyên giá
      sheet.getRangeByIndex(currentRow, 6).setNumber(item.nguyenGiaSoSach);
      sheet.getRangeByIndex(currentRow, 6).numberFormat = '#,##0';
      _setDataCellStyle(sheet, currentRow, 6, HAlignType.right);

      // Kế toán - Giá trị còn lại
      sheet.getRangeByIndex(currentRow, 7).setNumber(item.giaTriConLaiSoSach);
      sheet.getRangeByIndex(currentRow, 7).numberFormat = '#,##0';
      _setDataCellStyle(sheet, currentRow, 7, HAlignType.right);

      // Kiểm kê - Số lượng
      sheet.getRangeByIndex(currentRow, 8).setNumber(item.soLuongKiemKe.toDouble());
      sheet.getRangeByIndex(currentRow, 8).numberFormat = '#,##0';
      _setDataCellStyle(sheet, currentRow, 8, HAlignType.right);

      // Kiểm kê - Nguyên giá
      sheet.getRangeByIndex(currentRow, 9).setNumber(item.nguyenGiaKiemKe);
      sheet.getRangeByIndex(currentRow, 9).numberFormat = '#,##0';
      _setDataCellStyle(sheet, currentRow, 9, HAlignType.right);

      // Kiểm kê - Giá trị còn lại
      sheet.getRangeByIndex(currentRow, 10).setNumber(item.giaTriConLaiKiemKe);
      sheet.getRangeByIndex(currentRow, 10).numberFormat = '#,##0';
      _setDataCellStyle(sheet, currentRow, 10, HAlignType.right);

      // Chênh lệch - Số lượng
      sheet.getRangeByIndex(currentRow, 11).setNumber(item.chenhLechSoLuong.toDouble());
      sheet.getRangeByIndex(currentRow, 11).numberFormat = '#,##0';
      _setDataCellStyle(sheet, currentRow, 11, HAlignType.right);

      // Chênh lệch - Nguyên giá
      sheet.getRangeByIndex(currentRow, 12).setNumber(item.chenhLechNguyenGia);
      sheet.getRangeByIndex(currentRow, 12).numberFormat = '#,##0';
      _setDataCellStyle(sheet, currentRow, 12, HAlignType.right);

      // Chênh lệch - Giá trị còn lại
      sheet.getRangeByIndex(currentRow, 13).setNumber(item.chenhLechGiaTriConLai);
      sheet.getRangeByIndex(currentRow, 13).numberFormat = '#,##0';
      _setDataCellStyle(sheet, currentRow, 13, HAlignType.right);

      // Ghi chú
      sheet.getRangeByIndex(currentRow, 14).setText(item.ghiChu);
      _setDataCellStyle(sheet, currentRow, 14, HAlignType.left);

      currentRow++;
    }

    // Set column widths
    sheet.getRangeByIndex(1, 1).columnWidth = 5;
    sheet.getRangeByIndex(1, 2).columnWidth = 25;
    sheet.getRangeByIndex(1, 3).columnWidth = 10;
    sheet.getRangeByIndex(1, 4).columnWidth = 15;
    sheet.getRangeByIndex(1, 5).columnWidth = 10;
    sheet.getRangeByIndex(1, 6).columnWidth = 15;
    sheet.getRangeByIndex(1, 7).columnWidth = 15;
    sheet.getRangeByIndex(1, 8).columnWidth = 10;
    sheet.getRangeByIndex(1, 9).columnWidth = 15;
    sheet.getRangeByIndex(1, 10).columnWidth = 15;
    sheet.getRangeByIndex(1, 11).columnWidth = 10;
    sheet.getRangeByIndex(1, 12).columnWidth = 15;
    sheet.getRangeByIndex(1, 13).columnWidth = 15;
    sheet.getRangeByIndex(1, 14).columnWidth = 15;

    // ===== FOOTER =====
    currentRow += 2;
    _buildBienBanKiemKeFooter(sheet, currentRow);

    // ===== SAVE FILE =====
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String fileName = 'Bao_cao_05_TSCD_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx';
    await saveExportFile(Uint8List.fromList(bytes), fileName);
  }

  // ========================================================================
  // MẪU SỐ 01 EXPORT
  // ========================================================================

  /// Export Mẫu số 01 (Sổ theo dõi TSCĐ và CCDC tại nơi sử dụng) to Excel
  static Future<void> exportMauSo01ToExcel({
    required List<TangGiamTrongKyDto> data,
    required String departmentName,
    required String thangNam,
  }) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'Mau_So_01';

    int currentRow = 1;

    // ===== HEADER =====
    sheet.getRangeByIndex(currentRow, 1, currentRow, 6).merge();
    final tapDoanRange = sheet.getRangeByIndex(currentRow, 1);
    tapDoanRange.setText('TẬP ĐOÀN CÔNG NGHIỆP\nTHAN – KHOÁNG SẢN VIỆT NAM');
    tapDoanRange.cellStyle.fontSize = 11;
    tapDoanRange.cellStyle.hAlign = HAlignType.center;
    tapDoanRange.cellStyle.wrapText = true;

    sheet.getRangeByIndex(currentRow, 7, currentRow, 12).merge();
    final mauSoRange = sheet.getRangeByIndex(currentRow, 7);
    mauSoRange.setText('Mẫu số 01');
    mauSoRange.cellStyle.fontSize = 11;
    mauSoRange.cellStyle.bold = true;
    mauSoRange.cellStyle.hAlign = HAlignType.center;
    sheet.setRowHeightInPixels(currentRow, 35);
    currentRow++;

    sheet.getRangeByIndex(currentRow, 1, currentRow, 6).merge();
    final congTyRange = sheet.getRangeByIndex(currentRow, 1);
    congTyRange.setText('CÔNG TY THAN UÔNG BÍ - TKV');
    congTyRange.cellStyle.fontSize = 11;
    congTyRange.cellStyle.bold = true;
    congTyRange.cellStyle.hAlign = HAlignType.center;

    sheet.getRangeByIndex(currentRow, 7, currentRow, 12).merge();
    final banHanhRange = sheet.getRangeByIndex(currentRow, 7);
    banHanhRange.setText('Ban hành kèm theo QĐ số ...../QĐ-TUB\nngày ..../..../.... của Giám đốc Công ty');
    banHanhRange.cellStyle.fontSize = 10;
    banHanhRange.cellStyle.hAlign = HAlignType.center;
    banHanhRange.cellStyle.wrapText = true;
    sheet.setRowHeightInPixels(currentRow, 30);
    currentRow += 2;

    // Title
    sheet.getRangeByIndex(currentRow, 1, currentRow, 12).merge();
    final titleRange = sheet.getRangeByIndex(currentRow, 1);
    titleRange.setText('SỔ THEO DÕI');
    titleRange.cellStyle.fontSize = 14;
    titleRange.cellStyle.bold = true;
    titleRange.cellStyle.hAlign = HAlignType.center;
    currentRow++;

    sheet.getRangeByIndex(currentRow, 1, currentRow, 12).merge();
    final title2Range = sheet.getRangeByIndex(currentRow, 1);
    title2Range.setText('TÀI SẢN CỐ ĐỊNH VÀ CÔNG CỤ DỤNG CỤ TẠI NƠI SỬ DỤNG');
    title2Range.cellStyle.fontSize = 14;
    title2Range.cellStyle.bold = true;
    title2Range.cellStyle.hAlign = HAlignType.center;
    currentRow++;

    sheet.getRangeByIndex(currentRow, 1, currentRow, 12).merge();
    final thangNamRange = sheet.getRangeByIndex(currentRow, 1);
    thangNamRange.setText('Tháng $thangNam');
    thangNamRange.cellStyle.fontSize = 11;
    thangNamRange.cellStyle.bold = true;
    thangNamRange.cellStyle.hAlign = HAlignType.center;
    currentRow++;

    sheet.getRangeByIndex(currentRow, 1, currentRow, 12).merge();
    final apDungRange = sheet.getRangeByIndex(currentRow, 1);
    apDungRange.setText('(Áp dụng cho các phân xưởng)');
    apDungRange.cellStyle.fontSize = 11;
    apDungRange.cellStyle.italic = true;
    apDungRange.cellStyle.hAlign = HAlignType.center;
    currentRow += 2;

    // ===== TABLE HEADER ROW 1 =====
    // STT (rowspan 3)
    sheet.getRangeByIndex(currentRow, 1, currentRow + 2, 1).merge();
    _setHeaderCell(sheet, currentRow, 1, 'STT');

    // Tên nhãn hiệu (rowspan 3)
    sheet.getRangeByIndex(currentRow, 2, currentRow + 2, 2).merge();
    _setHeaderCell(sheet, currentRow, 2, 'Tên nhãn hiệu, quy cách tài sản cố định, công cụ dụng cụ');

    // Đơn vị tính (rowspan 3)
    sheet.getRangeByIndex(currentRow, 3, currentRow + 2, 3).merge();
    _setHeaderCell(sheet, currentRow, 3, 'Đơn vị tính');

    // Nước sản xuất (rowspan 3)
    sheet.getRangeByIndex(currentRow, 4, currentRow + 2, 4).merge();
    _setHeaderCell(sheet, currentRow, 4, 'Nước sản xuất');

    // Số dư đầu kỳ (rowspan 3)
    sheet.getRangeByIndex(currentRow, 5, currentRow + 2, 5).merge();
    _setHeaderCell(sheet, currentRow, 5, 'Số dư đầu kỳ');

    // Tăng trong kỳ (colspan 2)
    sheet.getRangeByIndex(currentRow, 6, currentRow, 7).merge();
    _setHeaderCell(sheet, currentRow, 6, 'Tăng trong kỳ');

    // Giảm trong kỳ (colspan 2)
    sheet.getRangeByIndex(currentRow, 8, currentRow, 9).merge();
    _setHeaderCell(sheet, currentRow, 8, 'Giảm trong kỳ');

    // Số dư cuối kỳ (rowspan 3)
    sheet.getRangeByIndex(currentRow, 10, currentRow + 2, 10).merge();
    _setHeaderCell(sheet, currentRow, 10, 'Số dư cuối kỳ');

    // Tình trạng kỹ thuật (rowspan 3)
    sheet.getRangeByIndex(currentRow, 11, currentRow + 2, 11).merge();
    _setHeaderCell(sheet, currentRow, 11, 'Tình trạng kỹ thuật');

    // Ghi chú (rowspan 3)
    sheet.getRangeByIndex(currentRow, 12, currentRow + 2, 12).merge();
    _setHeaderCell(sheet, currentRow, 12, 'Ghi chú');
    currentRow++;

    // ===== TABLE HEADER ROW 2 =====
    // Tăng sub-columns
    _setHeaderCell(sheet, currentRow, 6, 'Số lượng');
    _setHeaderCell(sheet, currentRow, 7, 'Lý do tăng');

    // Giảm sub-columns
    _setHeaderCell(sheet, currentRow, 8, 'Số lượng');
    _setHeaderCell(sheet, currentRow, 9, 'Lý do giảm');
    currentRow++;

    // ===== TABLE HEADER ROW 3 =====
    _setHeaderCell(sheet, currentRow, 1, 'A');
    _setHeaderCell(sheet, currentRow, 2, 'B');
    _setHeaderCell(sheet, currentRow, 3, 'C');
    _setHeaderCell(sheet, currentRow, 4, '1');
    _setHeaderCell(sheet, currentRow, 5, '2');
    _setHeaderCell(sheet, currentRow, 6, '3');
    _setHeaderCell(sheet, currentRow, 7, '4');
    _setHeaderCell(sheet, currentRow, 8, '5');
    _setHeaderCell(sheet, currentRow, 9, '6');
    _setHeaderCell(sheet, currentRow, 10, '7=2+3-5');
    _setHeaderCell(sheet, currentRow, 11, '8');
    _setHeaderCell(sheet, currentRow, 12, '9');
    currentRow++;

    // ===== DATA ROWS =====
    // Separate data by type
    final taiSanList = data.where((item) => item.isTaiSan).toList();
    final ccdcList = data.where((item) => item.isCCDC).toList();

    // A. Tài sản cố định
    sheet.getRangeByIndex(currentRow, 1).setText('A');
    sheet.getRangeByIndex(currentRow, 2, currentRow, 12).merge();
    sheet.getRangeByIndex(currentRow, 2).setText('Tài sản cố định');
    for (int i = 1; i <= 12; i++) {
      final cell = sheet.getRangeByIndex(currentRow, i);
      cell.cellStyle.bold = true;
      cell.cellStyle.backColor = '#E2EFDA';
      cell.cellStyle.borders.all.lineStyle = LineStyle.thin;
    }
    currentRow++;

    // Tài sản data
    for (int i = 0; i < taiSanList.length; i++) {
      currentRow = _writeMauSo01DataRow(sheet, currentRow, taiSanList[i], i + 1);
    }

    // B. Công cụ dụng cụ
    sheet.getRangeByIndex(currentRow, 1).setText('B');
    sheet.getRangeByIndex(currentRow, 2, currentRow, 12).merge();
    sheet.getRangeByIndex(currentRow, 2).setText('Công cụ dụng cụ');
    for (int i = 1; i <= 12; i++) {
      final cell = sheet.getRangeByIndex(currentRow, i);
      cell.cellStyle.bold = true;
      cell.cellStyle.backColor = '#E2EFDA';
      cell.cellStyle.borders.all.lineStyle = LineStyle.thin;
    }
    currentRow++;

    // CCDC data
    for (int i = 0; i < ccdcList.length; i++) {
      currentRow = _writeMauSo01DataRow(sheet, currentRow, ccdcList[i], i + 1);
    }

    // Set column widths
    sheet.getRangeByIndex(1, 1).columnWidth = 5;
    sheet.getRangeByIndex(1, 2).columnWidth = 35;
    sheet.getRangeByIndex(1, 3).columnWidth = 10;
    sheet.getRangeByIndex(1, 4).columnWidth = 12;
    sheet.getRangeByIndex(1, 5).columnWidth = 12;
    sheet.getRangeByIndex(1, 6).columnWidth = 10;
    sheet.getRangeByIndex(1, 7).columnWidth = 20;
    sheet.getRangeByIndex(1, 8).columnWidth = 10;
    sheet.getRangeByIndex(1, 9).columnWidth = 20;
    sheet.getRangeByIndex(1, 10).columnWidth = 12;
    sheet.getRangeByIndex(1, 11).columnWidth = 15;
    sheet.getRangeByIndex(1, 12).columnWidth = 15;

    // ===== FOOTER =====
    currentRow += 2;
    _buildMauSo01Footer(sheet, currentRow);

    // ===== SAVE FILE =====
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String fileName = 'Mau_So_01_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx';
    await saveExportFile(Uint8List.fromList(bytes), fileName);
  }

  static int _writeMauSo01DataRow(Worksheet sheet, int currentRow, TangGiamTrongKyDto item, int stt) {
    // STT
    sheet.getRangeByIndex(currentRow, 1).setNumber(stt.toDouble());
    _setDataCellStyle(sheet, currentRow, 1, HAlignType.center);

    // Tên nhãn hiệu
    sheet.getRangeByIndex(currentRow, 2).setText(item.tenTaiSan);
    _setDataCellStyle(sheet, currentRow, 2, HAlignType.left);

    // Đơn vị tính
    sheet.getRangeByIndex(currentRow, 3).setText(item.donViTinh);
    _setDataCellStyle(sheet, currentRow, 3, HAlignType.center);

    // Nước sản xuất
    sheet.getRangeByIndex(currentRow, 4).setText(item.nuocSanXuat);
    _setDataCellStyle(sheet, currentRow, 4, HAlignType.center);

    // Số dư đầu kỳ
    sheet.getRangeByIndex(currentRow, 5).setNumber(item.soDuDauKy.toDouble());
    sheet.getRangeByIndex(currentRow, 5).numberFormat = '#,##0';
    _setDataCellStyle(sheet, currentRow, 5, HAlignType.right);

    // Tăng - Số lượng
    sheet.getRangeByIndex(currentRow, 6).setNumber(item.soLuongTangTrongKy.toDouble());
    sheet.getRangeByIndex(currentRow, 6).numberFormat = '#,##0';
    _setDataCellStyle(sheet, currentRow, 6, HAlignType.right);

    // Tăng - Lý do
    sheet.getRangeByIndex(currentRow, 7).setText(item.lyDoTangTrongKy ?? '');
    _setDataCellStyle(sheet, currentRow, 7, HAlignType.left);

    // Giảm - Số lượng
    sheet.getRangeByIndex(currentRow, 8).setNumber(item.soLuongGiamTrongKy.toDouble());
    sheet.getRangeByIndex(currentRow, 8).numberFormat = '#,##0';
    _setDataCellStyle(sheet, currentRow, 8, HAlignType.right);

    // Giảm - Lý do
    sheet.getRangeByIndex(currentRow, 9).setText(item.lyDoGiamTrongKy ?? '');
    _setDataCellStyle(sheet, currentRow, 9, HAlignType.left);

    // Số dư cuối kỳ
    sheet.getRangeByIndex(currentRow, 10).setNumber(item.soDuCuoiKy.toDouble());
    sheet.getRangeByIndex(currentRow, 10).numberFormat = '#,##0';
    _setDataCellStyle(sheet, currentRow, 10, HAlignType.right);

    // Tình trạng kỹ thuật
    sheet.getRangeByIndex(currentRow, 11).setText(item.tinhTrangKyThuat);
    _setDataCellStyle(sheet, currentRow, 11, HAlignType.left);

    // Ghi chú
    sheet.getRangeByIndex(currentRow, 12).setText(item.ghiChu ?? '');
    _setDataCellStyle(sheet, currentRow, 12, HAlignType.left);

    return currentRow + 1;
  }

  static void _buildMauSo01Footer(Worksheet sheet, int startRow) {
    int currentRow = startRow;

    sheet.getRangeByIndex(currentRow, 1, currentRow, 12).merge();
    final noteRange = sheet.getRangeByIndex(currentRow, 1);
    noteRange.setText('Gửi kèm theo các Quyết định, biên bản giao nhận tăng giảm tài sản, công cụ dụng cụ trong kỳ báo cáo');
    noteRange.cellStyle.fontSize = 11;
    noteRange.cellStyle.italic = true;
    currentRow++;

    sheet.getRangeByIndex(currentRow, 1, currentRow, 12).merge();
    final note2Range = sheet.getRangeByIndex(currentRow, 1);
    note2Range.setText('Lưu ý: Báo cáo tháng trước vào ngày 15 hàng tháng (tháng sau)');
    note2Range.cellStyle.fontSize = 11;
    currentRow += 2;

    // Signatures
    sheet.getRangeByIndex(currentRow, 1, currentRow, 4).merge();
    final thongKeRange = sheet.getRangeByIndex(currentRow, 1);
    thongKeRange.setText('Thống kê phân xưởng\n(Ký, ghi rõ họ tên)');
    thongKeRange.cellStyle.fontSize = 11;
    thongKeRange.cellStyle.bold = true;
    thongKeRange.cellStyle.hAlign = HAlignType.center;
    thongKeRange.cellStyle.wrapText = true;

    sheet.getRangeByIndex(currentRow, 5, currentRow, 8).merge();
    final phoQuanDocRange = sheet.getRangeByIndex(currentRow, 5);
    phoQuanDocRange.setText('Phó quản đốc cơ điện\n(Ký, ghi rõ họ tên)');
    phoQuanDocRange.cellStyle.fontSize = 11;
    phoQuanDocRange.cellStyle.bold = true;
    phoQuanDocRange.cellStyle.hAlign = HAlignType.center;
    phoQuanDocRange.cellStyle.wrapText = true;

    sheet.getRangeByIndex(currentRow, 9, currentRow, 12).merge();
    final quanDocRange = sheet.getRangeByIndex(currentRow, 9);
    quanDocRange.setText('Quản đốc phân xưởng\n(Ký, ghi rõ họ tên)');
    quanDocRange.cellStyle.fontSize = 11;
    quanDocRange.cellStyle.bold = true;
    quanDocRange.cellStyle.hAlign = HAlignType.center;
    quanDocRange.cellStyle.wrapText = true;

    sheet.setRowHeightInPixels(currentRow, 50);
  }

  // ========================================================================
  // MẪU SỐ 21 (S21-DN) EXPORT
  // ========================================================================

  /// Export Mẫu số 21 (S21-DN - Sổ tài sản cố định) to Excel
  static Future<void> exportMauSo21ToExcel({
    required List<KhauHaoTaiSanDto> data,
    required String year,
    required String loaiTaiSan,
  }) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'Mau_So_S21_DN';

    int currentRow = 1;

    // ===== HEADER =====
    sheet.getRangeByIndex(currentRow, 1, currentRow, 7).merge();
    final donViRange = sheet.getRangeByIndex(currentRow, 1);
    donViRange.setText('Đơn vị: ...................');
    donViRange.cellStyle.fontSize = 11;

    sheet.getRangeByIndex(currentRow, 8, currentRow, 14).merge();
    final mauSoRange = sheet.getRangeByIndex(currentRow, 8);
    mauSoRange.setText('Mẫu số S21-DN');
    mauSoRange.cellStyle.fontSize = 14;
    mauSoRange.cellStyle.bold = true;
    mauSoRange.cellStyle.hAlign = HAlignType.right;
    currentRow++;

    sheet.getRangeByIndex(currentRow, 1, currentRow, 7).merge();
    final diaChiRange = sheet.getRangeByIndex(currentRow, 1);
    diaChiRange.setText('Địa chỉ: ...................');
    diaChiRange.cellStyle.fontSize = 11;

    sheet.getRangeByIndex(currentRow, 8, currentRow, 14).merge();
    final thongTuRange = sheet.getRangeByIndex(currentRow, 8);
    thongTuRange.setText('(Ban hành theo Thông tư số 200/2014/TT-BTC\nNgày 22/12/2014 của Bộ Tài chính)');
    thongTuRange.cellStyle.fontSize = 10;
    thongTuRange.cellStyle.hAlign = HAlignType.right;
    thongTuRange.cellStyle.wrapText = true;
    sheet.setRowHeightInPixels(currentRow, 30);
    currentRow += 2;

    // Title
    sheet.getRangeByIndex(currentRow, 1, currentRow, 14).merge();
    final titleRange = sheet.getRangeByIndex(currentRow, 1);
    titleRange.setText('Sổ tài sản cố định');
    titleRange.cellStyle.fontSize = 16;
    titleRange.cellStyle.bold = true;
    titleRange.cellStyle.hAlign = HAlignType.center;
    currentRow++;

    sheet.getRangeByIndex(currentRow, 1, currentRow, 14).merge();
    final yearRange = sheet.getRangeByIndex(currentRow, 1);
    yearRange.setText('Năm: $year');
    yearRange.cellStyle.fontSize = 11;
    yearRange.cellStyle.hAlign = HAlignType.center;
    currentRow++;

    sheet.getRangeByIndex(currentRow, 1, currentRow, 14).merge();
    final loaiRange = sheet.getRangeByIndex(currentRow, 1);
    loaiRange.setText('Loại tài sản: $loaiTaiSan');
    loaiRange.cellStyle.fontSize = 11;
    loaiRange.cellStyle.hAlign = HAlignType.center;
    currentRow += 2;

    // ===== TABLE HEADER ROW 1 =====
    // STT (rowspan 4)
    sheet.getRangeByIndex(currentRow, 1, currentRow + 3, 1).merge();
    _setHeaderCell(sheet, currentRow, 1, 'STT');

    // Ghi tăng TSCD (colspan 7)
    sheet.getRangeByIndex(currentRow, 2, currentRow, 8).merge();
    _setHeaderCell(sheet, currentRow, 2, 'Ghi tăng TSCD');

    // Khấu hao TSCD (colspan 3)
    sheet.getRangeByIndex(currentRow, 9, currentRow, 11).merge();
    _setHeaderCell(sheet, currentRow, 9, 'Khấu hao TSCD');

    // Ghi giảm TSCD (colspan 3)
    sheet.getRangeByIndex(currentRow, 12, currentRow, 14).merge();
    _setHeaderCell(sheet, currentRow, 12, 'Ghi giảm TSCD');
    currentRow++;

    // ===== TABLE HEADER ROW 2 =====
    // Chứng từ (colspan 2)
    sheet.getRangeByIndex(currentRow, 2, currentRow, 3).merge();
    _setHeaderCell(sheet, currentRow, 2, 'Chứng từ');

    // Tên, đặc điểm (rowspan 3)
    sheet.getRangeByIndex(currentRow, 4, currentRow + 2, 4).merge();
    _setHeaderCell(sheet, currentRow, 4, 'Tên, đặc\ndiểm, ký hiệu\nTSCD');

    // Nước sản xuất (rowspan 3)
    sheet.getRangeByIndex(currentRow, 5, currentRow + 2, 5).merge();
    _setHeaderCell(sheet, currentRow, 5, 'Nước sản\nxuất');

    // Tháng năm đưa vào sử dụng (rowspan 3)
    sheet.getRangeByIndex(currentRow, 6, currentRow + 2, 6).merge();
    _setHeaderCell(sheet, currentRow, 6, 'Tháng năm,\nđưa vào sử\ndụng');

    // Số hiệu TSCD (rowspan 3)
    sheet.getRangeByIndex(currentRow, 7, currentRow + 2, 7).merge();
    _setHeaderCell(sheet, currentRow, 7, 'Số hiệu\nTSCD');

    // Nguyên giá TSCD (rowspan 3)
    sheet.getRangeByIndex(currentRow, 8, currentRow + 2, 8).merge();
    _setHeaderCell(sheet, currentRow, 8, 'Nguyên giá\nTSCD');

    // Khấu hao (colspan 2)
    sheet.getRangeByIndex(currentRow, 9, currentRow, 10).merge();
    _setHeaderCell(sheet, currentRow, 9, 'Khấu hao');

    // Khấu hao đã tính (rowspan 3)
    sheet.getRangeByIndex(currentRow, 11, currentRow + 2, 11).merge();
    _setHeaderCell(sheet, currentRow, 11, 'Khấu hao\nđã tính đến\nkhi ghi giảm\nTSCD');

    // Chứng từ giảm (colspan 2)
    sheet.getRangeByIndex(currentRow, 12, currentRow, 13).merge();
    _setHeaderCell(sheet, currentRow, 12, 'Chứng từ');

    // Lý do giảm (rowspan 3)
    sheet.getRangeByIndex(currentRow, 14, currentRow + 2, 14).merge();
    _setHeaderCell(sheet, currentRow, 14, 'Lý do giảm\nTSCD');
    currentRow++;

    // ===== TABLE HEADER ROW 3 =====
    _setHeaderCell(sheet, currentRow, 2, 'Số hiệu');
    _setHeaderCell(sheet, currentRow, 3, 'Ngày tháng');
    _setHeaderCell(sheet, currentRow, 9, 'Tỷ lệ (%)\nkhấu hao');
    _setHeaderCell(sheet, currentRow, 10, 'Mức khấu\nhao');
    _setHeaderCell(sheet, currentRow, 12, 'Số hiệu');
    _setHeaderCell(sheet, currentRow, 13, 'Ngày, tháng,\nnăm');
    currentRow++;

    // ===== TABLE HEADER ROW 4 =====
    _setHeaderCell(sheet, currentRow, 1, 'A');
    _setHeaderCell(sheet, currentRow, 2, 'B');
    _setHeaderCell(sheet, currentRow, 3, 'C');
    _setHeaderCell(sheet, currentRow, 4, 'D');
    _setHeaderCell(sheet, currentRow, 5, 'E');
    _setHeaderCell(sheet, currentRow, 6, 'G');
    _setHeaderCell(sheet, currentRow, 7, 'H');
    _setHeaderCell(sheet, currentRow, 8, 'I');
    _setHeaderCell(sheet, currentRow, 9, '2');
    _setHeaderCell(sheet, currentRow, 10, '3');
    _setHeaderCell(sheet, currentRow, 11, '4');
    _setHeaderCell(sheet, currentRow, 12, 'I');
    _setHeaderCell(sheet, currentRow, 13, 'K');
    _setHeaderCell(sheet, currentRow, 14, 'L');
    currentRow++;

    // ===== DATA ROWS =====
    double totalNguyenGia = 0;
    double totalKhauHaoDaTinh = 0;

    for (int i = 0; i < data.length; i++) {
      final item = data[i];

      // STT
      sheet.getRangeByIndex(currentRow, 1).setNumber(i + 1);
      _setDataCellStyle(sheet, currentRow, 1, HAlignType.center);

      // Chứng từ - Số hiệu
      sheet.getRangeByIndex(currentRow, 2).setText('');
      _setDataCellStyle(sheet, currentRow, 2, HAlignType.center);

      // Chứng từ - Ngày tháng
      String ngayThang = '';
      if (item.ngayTinhKhao != null) {
        ngayThang = '${item.ngayTinhKhao!.day.toString().padLeft(2, '0')}/${item.ngayTinhKhao!.month.toString().padLeft(2, '0')}/${item.ngayTinhKhao!.year}';
      }
      sheet.getRangeByIndex(currentRow, 3).setText(ngayThang);
      _setDataCellStyle(sheet, currentRow, 3, HAlignType.center);

      // Tên, đặc điểm
      sheet.getRangeByIndex(currentRow, 4).setText(item.tenTaiSan ?? '');
      _setDataCellStyle(sheet, currentRow, 4, HAlignType.left);

      // Nước sản xuất
      sheet.getRangeByIndex(currentRow, 5).setText('');
      _setDataCellStyle(sheet, currentRow, 5, HAlignType.center);

      // Tháng năm đưa vào sử dụng
      String thangNamSuDung = '';
      if (item.thangKh != null) {
        thangNamSuDung = 'Tháng ${item.thangKh}';
      }
      sheet.getRangeByIndex(currentRow, 6).setText(thangNamSuDung);
      _setDataCellStyle(sheet, currentRow, 6, HAlignType.center);

      // Số hiệu TSCD
      sheet.getRangeByIndex(currentRow, 7).setText(item.soThe ?? '');
      _setDataCellStyle(sheet, currentRow, 7, HAlignType.center);

      // Nguyên giá TSCD
      if (item.nguyenGia != null) {
        sheet.getRangeByIndex(currentRow, 8).setNumber(item.nguyenGia!);
        sheet.getRangeByIndex(currentRow, 8).numberFormat = '#,##0';
        totalNguyenGia += item.nguyenGia!;
      }
      _setDataCellStyle(sheet, currentRow, 8, HAlignType.right);

      // Tỷ lệ khấu hao
      sheet.getRangeByIndex(currentRow, 9).setText('');
      _setDataCellStyle(sheet, currentRow, 9, HAlignType.right);

      // Mức khấu hao
      if (item.khauHaoBinhQuan != null) {
        sheet.getRangeByIndex(currentRow, 10).setNumber(item.khauHaoBinhQuan!);
        sheet.getRangeByIndex(currentRow, 10).numberFormat = '#,##0';
      }
      _setDataCellStyle(sheet, currentRow, 10, HAlignType.right);

      // Khấu hao đã tính
      if (item.khauHaoPsck != null) {
        sheet.getRangeByIndex(currentRow, 11).setNumber(item.khauHaoPsck!);
        sheet.getRangeByIndex(currentRow, 11).numberFormat = '#,##0';
        totalKhauHaoDaTinh += item.khauHaoPsck!;
      }
      _setDataCellStyle(sheet, currentRow, 11, HAlignType.right);

      // Chứng từ giảm - Số hiệu
      sheet.getRangeByIndex(currentRow, 12).setText('');
      _setDataCellStyle(sheet, currentRow, 12, HAlignType.center);

      // Chứng từ giảm - Ngày tháng
      sheet.getRangeByIndex(currentRow, 13).setText('');
      _setDataCellStyle(sheet, currentRow, 13, HAlignType.center);

      // Lý do giảm
      sheet.getRangeByIndex(currentRow, 14).setText(item.ghiChuKhao ?? '');
      _setDataCellStyle(sheet, currentRow, 14, HAlignType.left);

      currentRow++;
    }

    // ===== SUMMARY ROW =====
    sheet.getRangeByIndex(currentRow, 2).setText('Cộng');
    sheet.getRangeByIndex(currentRow, 2).cellStyle.bold = true;
    _setDataCellStyle(sheet, currentRow, 1, HAlignType.center);
    _setDataCellStyle(sheet, currentRow, 2, HAlignType.center);
    for (int i = 3; i <= 7; i++) {
      sheet.getRangeByIndex(currentRow, i).setText('x');
      _setDataCellStyle(sheet, currentRow, i, HAlignType.center);
    }

    sheet.getRangeByIndex(currentRow, 8).setNumber(totalNguyenGia);
    sheet.getRangeByIndex(currentRow, 8).numberFormat = '#,##0';
    sheet.getRangeByIndex(currentRow, 8).cellStyle.bold = true;
    _setDataCellStyle(sheet, currentRow, 8, HAlignType.right);

    _setDataCellStyle(sheet, currentRow, 9, HAlignType.center);
    _setDataCellStyle(sheet, currentRow, 10, HAlignType.center);

    sheet.getRangeByIndex(currentRow, 11).setNumber(totalKhauHaoDaTinh);
    sheet.getRangeByIndex(currentRow, 11).numberFormat = '#,##0';
    sheet.getRangeByIndex(currentRow, 11).cellStyle.bold = true;
    _setDataCellStyle(sheet, currentRow, 11, HAlignType.right);

    for (int i = 12; i <= 14; i++) {
      sheet.getRangeByIndex(currentRow, i).setText('x');
      _setDataCellStyle(sheet, currentRow, i, HAlignType.center);
    }
    currentRow++;

    // Set column widths
    sheet.getRangeByIndex(1, 1).columnWidth = 5;
    sheet.getRangeByIndex(1, 2).columnWidth = 10;
    sheet.getRangeByIndex(1, 3).columnWidth = 12;
    sheet.getRangeByIndex(1, 4).columnWidth = 25;
    sheet.getRangeByIndex(1, 5).columnWidth = 12;
    sheet.getRangeByIndex(1, 6).columnWidth = 15;
    sheet.getRangeByIndex(1, 7).columnWidth = 12;
    sheet.getRangeByIndex(1, 8).columnWidth = 15;
    sheet.getRangeByIndex(1, 9).columnWidth = 12;
    sheet.getRangeByIndex(1, 10).columnWidth = 12;
    sheet.getRangeByIndex(1, 11).columnWidth = 15;
    sheet.getRangeByIndex(1, 12).columnWidth = 10;
    sheet.getRangeByIndex(1, 13).columnWidth = 12;
    sheet.getRangeByIndex(1, 14).columnWidth = 20;

    // ===== FOOTER =====
    currentRow += 2;
    _buildMauSo21Footer(sheet, currentRow);

    // ===== SAVE FILE =====
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String fileName = 'Mau_So_S21_DN_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx';
    await saveExportFile(Uint8List.fromList(bytes), fileName);
  }

  static void _buildMauSo21Footer(Worksheet sheet, int startRow) {
    int currentRow = startRow;

    sheet.getRangeByIndex(currentRow, 1, currentRow, 14).merge();
    final soTrangRange = sheet.getRangeByIndex(currentRow, 1);
    soTrangRange.setText('- Sổ này có ... trang, đánh số từ trang 01 đến trang ...');
    soTrangRange.cellStyle.fontSize = 11;
    currentRow++;

    sheet.getRangeByIndex(currentRow, 1, currentRow, 14).merge();
    final ngayMoRange = sheet.getRangeByIndex(currentRow, 1);
    ngayMoRange.setText('- Ngày mở sổ: ...');
    ngayMoRange.cellStyle.fontSize = 11;
    currentRow += 2;

    // Signatures
    sheet.getRangeByIndex(currentRow, 1, currentRow, 4).merge();
    final nguoiGhiRange = sheet.getRangeByIndex(currentRow, 1);
    nguoiGhiRange.setText('Người ghi sổ\n(Ký, họ tên)');
    nguoiGhiRange.cellStyle.fontSize = 11;
    nguoiGhiRange.cellStyle.bold = true;
    nguoiGhiRange.cellStyle.hAlign = HAlignType.center;
    nguoiGhiRange.cellStyle.wrapText = true;

    sheet.getRangeByIndex(currentRow, 5, currentRow, 9).merge();
    final keToanRange = sheet.getRangeByIndex(currentRow, 5);
    keToanRange.setText('Kế toán trưởng\n(Ký, họ tên)');
    keToanRange.cellStyle.fontSize = 11;
    keToanRange.cellStyle.bold = true;
    keToanRange.cellStyle.hAlign = HAlignType.center;
    keToanRange.cellStyle.wrapText = true;

    sheet.getRangeByIndex(currentRow, 10, currentRow, 14).merge();
    final giamDocRange = sheet.getRangeByIndex(currentRow, 10);
    giamDocRange.setText('Ngày ... tháng ... năm ...\nGiám đốc\n(Ký, họ tên, đóng dấu)');
    giamDocRange.cellStyle.fontSize = 11;
    giamDocRange.cellStyle.bold = true;
    giamDocRange.cellStyle.hAlign = HAlignType.center;
    giamDocRange.cellStyle.wrapText = true;

    sheet.setRowHeightInPixels(currentRow, 60);
  }
}
