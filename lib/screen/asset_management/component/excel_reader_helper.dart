import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

class ExcelReaderHelper {
  static ExcelReaderResult readExcel(Uint8List fileBytes) {
    try {
      // Try excel package first
      final excel = Excel.decodeBytes(fileBytes);
      return ExcelReaderResult.success(excel: excel);
    } catch (e) {
      // Fallback to spreadsheet_decoder
      try {
        final decoder = SpreadsheetDecoder.decodeBytes(fileBytes, update: false);
        return ExcelReaderResult.fallback(decoder: decoder);
      } catch (e2) {
        return ExcelReaderResult.error('Không đọc được file: $e2');
      }
    }
  }
}

class ExcelReaderResult {
  final bool isSuccess;
  final bool isFallback;
  final Excel? excel;
  final SpreadsheetDecoder? decoder;
  final String? error;

  ExcelReaderResult._({
    required this.isSuccess,
    required this.isFallback,
    this.excel,
    this.decoder,
    this.error,
  });

  factory ExcelReaderResult.success({required Excel excel}) {
    return ExcelReaderResult._(isSuccess: true, isFallback: false, excel: excel);
  }

  factory ExcelReaderResult.fallback({required SpreadsheetDecoder decoder}) {
    return ExcelReaderResult._(isSuccess: true, isFallback: true, decoder: decoder);
  }

  factory ExcelReaderResult.error(String error) {
    return ExcelReaderResult._(isSuccess: false, isFallback: false, error: error);
  }
}
