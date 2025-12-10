import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
// ignore: avoid_web_libraries_in_flutter
// import 'dart:html' as html;

/// Service for exporting S22-DN report to Excel format
class ExcelExportService {
  /// Export S22-DN report data to Excel file matching UI layout
  static Future<void> exportS22DNToExcel({
    required List<Map<String, dynamic>> assetData,
    required List<Map<String, dynamic>> ccdcData,
    required String fromDate,
    required String toDate,
    required String departmentName,
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

    if (kIsWeb) {
      // Web platform
      // final blob = html.Blob([bytes]);
      // final url = html.Url.createObjectUrlFromBlob(blob);
      // html.AnchorElement(href: url)
      //   ..setAttribute('download', fileName)
      //   ..click();
      // html.Url.revokeObjectUrl(url);
    } else {
      // Mobile/Desktop platform
      final String path = '/storage/emulated/0/Download/$fileName';
      final File file = File(path);
      await file.writeAsBytes(bytes, flush: true);
    }
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
}
