import 'dart:developer';
import 'dart:typed_data';
import 'dart:io' show File;

import 'package:excel/excel.dart' as excel;
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';

/// Optimized single-pass import: validates and converts in one go
/// Returns a tuple: (success, assets, errors)
Future<(bool, List<AssetManagementDto>, List<String>)> importAssetsOptimized({
  Uint8List? bytes,
  String? filePath,
  BuildContext? context,
  Function(int current, int total)? onProgress,
}) async {
  try {
    final Uint8List fileBytes;
    if (bytes != null) {
      fileBytes = bytes;
    } else if (filePath != null && filePath.isNotEmpty) {
      fileBytes = File(filePath).readAsBytesSync();
    } else {
      final errors = ['Không tìm thấy dữ liệu file import'];
      if (context != null) {
        AppUtility.showSnackBar(context, errors.first, isError: true);
      }
      return (false, <AssetManagementDto>[], errors);
    }

    final fallbackUser = AccountHelper.instance.getUserInfo()?.tenDangNhap ?? '';
    
    // Validation configuration
    const int maxErrorsBeforeExit = 500;
    const int maxRowsToProcess = 5000;
    
    final List<String> errors = <String>[];
    final List<AssetManagementDto> assets = <AssetManagementDto>[];
    
    // Required fields with their Excel column indices
    final List<_RequiredField> requiredFields = <_RequiredField>[
      _RequiredField(index: 0, displayName: 'ID tài sản'),
      _RequiredField(index: 1, displayName: 'Số thẻ tài sản'),
      _RequiredField(index: 2, displayName: 'Tên tài sản'),
      _RequiredField(index: 7, displayName: 'Mã nhóm tài sản'),
      _RequiredField(index: 31, displayName: 'Mã đơn vị hiện thời'),
    ];
    
    // Capital fields that must be numeric
    final List<_CapitalField> capitalFields = <_CapitalField>[
      _CapitalField(index: 10, displayName: 'Vốn NS'),
      _CapitalField(index: 11, displayName: 'Vốn vay'),
      _CapitalField(index: 12, displayName: 'Vốn khác'),
      _CapitalField(index: 24, displayName: 'Năm sản xuất'),
    ];
    
    bool earlyStoppedByErrorLimit = false;
    int totalRowsProcessed = 0;
    
    // Try faster SpreadsheetDecoder first
    try {
      final decoder = SpreadsheetDecoder.decodeBytes(fileBytes, update: false);
      
      for (final table in decoder.tables.keys) {
        final sheet = decoder.tables[table];
        if (sheet == null) continue;
        
        final int totalRows = sheet.maxRows - 1; // Exclude header
        final int rowsToProcess = maxRowsToProcess > 0 
            ? totalRows.clamp(0, maxRowsToProcess)
            : totalRows;
        
        bool limitedByRowCap = totalRows > rowsToProcess;
        
        for (int rowIndex = 1; rowIndex <= rowsToProcess && rowIndex < sheet.maxRows; rowIndex++) {
          final row = sheet.rows[rowIndex];
          totalRowsProcessed++;
          
          // Call progress callback
          if (onProgress != null && totalRowsProcessed % 50 == 0) {
            onProgress(totalRowsProcessed, rowsToProcess);
          }
          
          dynamic cellAt(int idx) => (idx < row.length) ? row[idx] : null;
          
          // Validate required fields
          for (final rf in requiredFields) {
            final raw = cellAt(rf.index);
            final valueStr = AppUtility.s(raw);
            final String columnLetter = _getColumnLetter(rf.index);
            
            if (valueStr.trim().isEmpty) {
              errors.add('Cột $columnLetter - Hàng ${rowIndex + 1}: ${rf.displayName} đang bỏ trống');
              if (errors.length >= maxErrorsBeforeExit) {
                earlyStoppedByErrorLimit = true;
                break;
              }
            }
          }
          
          if (earlyStoppedByErrorLimit) break;
          
          // Validate numeric fields
          for (final cf in capitalFields) {
            final raw = cellAt(cf.index);
            final valueStr = AppUtility.s(raw);
            final String columnLetter = _getColumnLetter(cf.index);
            
            if (valueStr.trim().isNotEmpty) {
              final cleanedValue = valueStr.replaceAll(RegExp(r'[^\d.]'), '');
              if (double.tryParse(cleanedValue) == null) {
                errors.add('Cột $columnLetter - Hàng ${rowIndex + 1}: ${cf.displayName} phải là số, không được là text: "$valueStr"');
                if (errors.length >= maxErrorsBeforeExit) {
                  earlyStoppedByErrorLimit = true;
                  break;
                }
              }
            }
          }
          
          if (earlyStoppedByErrorLimit) break;
          
          // If validation passed, convert to DTO (note: decoder uses 0-based indices differently than Excel)
          final vonNS = AppUtility.parseCurrency(AppUtility.s(cellAt(10)));
          final vonVay = AppUtility.parseCurrency(AppUtility.s(cellAt(11)));
          final vonKhac = AppUtility.parseCurrency(AppUtility.s(cellAt(12)));
          final totalNguyenGia = vonNS + vonVay + vonKhac;
          
          final json = <String, dynamic>{
            'id': AppUtility.s(cellAt(0)),
            'soThe': AppUtility.s(cellAt(1)),
            'tenTaiSan': AppUtility.s(cellAt(2)),
            'nguyenGia': totalNguyenGia,
            'giaTriKhauHaoBanDau': AppUtility.parseCurrency(AppUtility.s(cellAt(3))),
            'kyKhauHaoBanDau': int.tryParse(AppUtility.s(cellAt(4))),
            'giaTriThanhLy': AppUtility.parseCurrency(AppUtility.s(cellAt(5))),
            'idMoHinhTaiSan': AppUtility.s(cellAt(6)),
            'idNhomTaiSan': AppUtility.s(cellAt(7)),
            'idLoaiTaiSanCon': AppUtility.s(cellAt(8)),
            'idDuAn': AppUtility.s(cellAt(9)),
            'vonNS': vonNS,
            'vonVay': vonVay,
            'vonKhac': vonKhac,
            'phuongPhapKhauHao': int.tryParse(AppUtility.s(cellAt(13))),
            'soKyKhauHao': int.tryParse(AppUtility.s(cellAt(14))),
            'taiKhoanTaiSan': int.tryParse(AppUtility.s(cellAt(15))),
            'taiKhoanKhauHao': int.tryParse(AppUtility.s(cellAt(16))),
            'taiKhoanChiPhi': int.tryParse(AppUtility.s(cellAt(17))),
            'ngayVaoSo': AppUtility.normalizeDateIsoStringV2(cellAt(18)),
            'ngaySuDung': AppUtility.normalizeDateIsoStringV2(cellAt(19)),
            'kyHieu': AppUtility.s(cellAt(20)),
            'soKyHieu': AppUtility.s(cellAt(21)),
            'congSuat': AppUtility.s(cellAt(22)),
            'nuocSanXuat': AppUtility.s(cellAt(23)),
            'namSanXuat': int.tryParse(AppUtility.s(cellAt(24))),
            'lyDoTang': AppUtility.s(cellAt(25)),
            'hienTrang': int.tryParse(AppUtility.s(cellAt(26))),
            'soLuong': 1,
            'donViTinh': AppUtility.s(cellAt(27)),
            'ghiChu': AppUtility.s(cellAt(28)),
            'idDonViBanDau': AppUtility.s(cellAt(29)),
            'idDonViHienThoi': AppUtility.s(cellAt(30)),
            'moTa': AppUtility.s(cellAt(31)),
            'idCongTy': 'ct001',
            'ngayTao': AppUtility.normalizeDateIsoStringV2(cellAt(32)),
            'ngayCapNhat': AppUtility.normalizeDateIsoStringV2(cellAt(33)),
            'nguoiTao': AppUtility.s(cellAt(34), fallback: fallbackUser),
            'nguoiCapNhat': AppUtility.s(cellAt(35), fallback: fallbackUser),
            'isActive': true,
            'isTaiSanCon': false,
          };
          
          assets.add(AssetManagementDto.fromJson(json));
        }
        
        if (earlyStoppedByErrorLimit) break;
        
        if (limitedByRowCap && totalRows > rowsToProcess) {
          errors.add('Đã giới hạn xử lý ${rowsToProcess} hàng đầu tiên để tăng tốc.');
        }
      }
    } catch (e) {
      // Fallback to Excel package
      log('Decoder failed, falling back to Excel: $e');
      try {
        final excelFile = excel.Excel.decodeBytes(fileBytes);
        
        for (final table in excelFile.tables.keys) {
          final sheet = excelFile.tables[table];
          if (sheet == null) continue;
          
          final int totalRows = sheet.maxRows - 1;
          final int rowsToProcess = maxRowsToProcess > 0 
              ? totalRows.clamp(0, maxRowsToProcess)
              : totalRows;
          
          bool limitedByRowCap = totalRows > rowsToProcess;
          
          for (int i = 0; i < rowsToProcess; i++) {
            final int rowIndex = i + 1; // Skip header
            if (rowIndex >= sheet.rows.length) break;
            
            final row = sheet.rows[rowIndex];
            totalRowsProcessed++;
            
            if (onProgress != null && totalRowsProcessed % 50 == 0) {
              onProgress(totalRowsProcessed, rowsToProcess);
            }
            
            // Validate required fields
            for (final rf in requiredFields) {
              final cell = rf.index < row.length ? row[rf.index] : null;
              final raw = cell?.value;
              final valueStr = AppUtility.s(raw);
              final String columnLetter = _getColumnLetter(rf.index);
              
              if (valueStr.trim().isEmpty) {
                errors.add('Cột $columnLetter - Hàng ${rowIndex + 1}: ${rf.displayName} đang bỏ trống');
                if (errors.length >= maxErrorsBeforeExit) {
                  earlyStoppedByErrorLimit = true;
                  break;
                }
              }
            }
            
            if (earlyStoppedByErrorLimit) break;
            
            // Validate numeric fields
            for (final cf in capitalFields) {
              final cell = cf.index < row.length ? row[cf.index] : null;
              final raw = cell?.value;
              final valueStr = AppUtility.s(raw);
              final String columnLetter = _getColumnLetter(cf.index);
              
              if (valueStr.trim().isNotEmpty) {
                final cleanedValue = valueStr.replaceAll(RegExp(r'[^\d.]'), '');
                if (double.tryParse(cleanedValue) == null) {
                  errors.add('Cột $columnLetter - Hàng ${rowIndex + 1}: ${cf.displayName} phải là số, không được là text: "$valueStr"');
                  if (errors.length >= maxErrorsBeforeExit) {
                    earlyStoppedByErrorLimit = true;
                    break;
                  }
                }
              }
            }
            
            if (earlyStoppedByErrorLimit) break;
            
            // Convert to DTO
            final vonNS = AppUtility.parseCurrency(AppUtility.s(row[10]?.value));
            final vonVay = AppUtility.parseCurrency(AppUtility.s(row[11]?.value));
            final vonKhac = AppUtility.parseCurrency(AppUtility.s(row[12]?.value));
            final totalNguyenGia = vonNS + vonVay + vonKhac;
            
            final json = <String, dynamic>{
              'id': AppUtility.s(row[0]?.value),
              'soThe': AppUtility.s(row[1]?.value),
              'tenTaiSan': AppUtility.s(row[2]?.value),
              'nguyenGia': totalNguyenGia,
              'giaTriKhauHaoBanDau': AppUtility.parseCurrency(AppUtility.s(row[3]?.value)),
              'kyKhauHaoBanDau': int.tryParse(AppUtility.s(row[4]?.value)),
              'giaTriThanhLy': AppUtility.parseCurrency(AppUtility.s(row[5]?.value)),
              'idMoHinhTaiSan': AppUtility.s(row[6]?.value),
              'idNhomTaiSan': AppUtility.s(row[7]?.value),
              'idLoaiTaiSanCon': AppUtility.s(row[8]?.value),
              'idDuAn': AppUtility.s(row[9]?.value),
              'vonNS': vonNS,
              'vonVay': vonVay,
              'vonKhac': vonKhac,
              'phuongPhapKhauHao': int.tryParse(AppUtility.s(row[13]?.value)),
              'soKyKhauHao': int.tryParse(AppUtility.s(row[14]?.value)),
              'taiKhoanTaiSan': int.tryParse(AppUtility.s(row[15]?.value)),
              'taiKhoanKhauHao': int.tryParse(AppUtility.s(row[16]?.value)),
              'taiKhoanChiPhi': int.tryParse(AppUtility.s(row[17]?.value)),
              'ngayVaoSo': AppUtility.normalizeDateIsoStringV2(row[18]?.value),
              'ngaySuDung': AppUtility.normalizeDateIsoStringV2(row[19]?.value),
              'kyHieu': AppUtility.s(row[20]?.value),
              'soKyHieu': AppUtility.s(row[21]?.value),
              'congSuat': AppUtility.s(row[22]?.value),
              'nuocSanXuat': AppUtility.s(row[23]?.value),
              'namSanXuat': int.tryParse(AppUtility.s(row[24]?.value)),
              'lyDoTang': AppUtility.s(row[25]?.value),
              'hienTrang': int.tryParse(AppUtility.s(row[26]?.value)),
              'soLuong': 1,
              'donViTinh': AppUtility.s(row[27]?.value),
              'ghiChu': AppUtility.s(row[28]?.value),
              'idDonViBanDau': AppUtility.s(row[29]?.value),
              'idDonViHienThoi': AppUtility.s(row[30]?.value),
              'moTa': AppUtility.s(row[31]?.value),
              'idCongTy': 'ct001',
              'ngayTao': AppUtility.normalizeDateIsoStringV2(row[32]?.value),
              'ngayCapNhat': AppUtility.normalizeDateIsoStringV2(row[33]?.value),
              'nguoiTao': AppUtility.s(row[34]?.value, fallback: fallbackUser),
              'nguoiCapNhat': AppUtility.s(row[35]?.value, fallback: fallbackUser),
              'isActive': true,
              'isTaiSanCon': false,
            };
            
            assets.add(AssetManagementDto.fromJson(json));
          }
          
          if (limitedByRowCap && totalRows > rowsToProcess) {
            errors.add('Đã giới hạn xử lý ${rowsToProcess} hàng đầu tiên để tăng tốc.');
          }
        }
      } catch (e2) {
        log('Both parsers failed: $e2');
        final errorList = ['Không đọc được file import: $e2'];
        if (context != null) {
          AppUtility.showSnackBar(context, errorList.first, isError: true);
        }
        return (false, <AssetManagementDto>[], errorList);
      }
    }
    
    // Add final progress callback
    if (onProgress != null && totalRowsProcessed > 0) {
      onProgress(totalRowsProcessed, totalRowsProcessed);
    }
    
    // Check if we have errors
    if (errors.isNotEmpty) {
      if (earlyStoppedByErrorLimit) {
        errors.add('... Đã dừng kiểm tra sớm do quá nhiều lỗi (>${maxErrorsBeforeExit}).');
      }
      
      if (context != null) {
        _showErrorDialog(context, errors);
      }
      return (false, <AssetManagementDto>[], errors);
    }
    
    return (true, assets, <String>[]);
  } catch (e) {
    log('Import error: $e');
    final errorList = ['Không đọc được file import: $e'];
    if (context != null) {
      AppUtility.showSnackBar(context, errorList.first, isError: true);
    }
    return (false, <AssetManagementDto>[], errorList);
  }
}

class _RequiredField {
  final int index;
  final String displayName;
  const _RequiredField({required this.index, required this.displayName});
}

class _CapitalField {
  final int index;
  final String displayName;
  const _CapitalField({required this.index, required this.displayName});
}

/// Convert column index to Excel column letter
String _getColumnLetter(int columnIndex) {
  String result = '';
  int idx = columnIndex;
  while (idx >= 0) {
    result = String.fromCharCode(65 + (idx % 26)) + result;
    idx = (idx ~/ 26) - 1;
  }
  return result;
}

/// Process assets in smaller batches to avoid blocking UI
Future<(bool, int, int)> processAssetsInBatches({
  required List<AssetManagementDto> assets,
  required BuildContext context,
  required Function(List<AssetManagementDto> batch) uploadBatch,
  Function(int currentBatch, int totalBatches, int currentCount, int totalCount)? onProgress,
  int batchSize = 100,
}) async {
  if (assets.isEmpty) {
    return (true, 0, 0);
  }

  final int totalAssets = assets.length;
  final int totalBatches = (totalAssets / batchSize).ceil();
  int successCount = 0;
  int failureCount = 0;

  for (int batchIndex = 0; batchIndex < totalBatches; batchIndex++) {
    final int start = batchIndex * batchSize;
    final int end = (start + batchSize).clamp(0, totalAssets);
    final List<AssetManagementDto> batch = assets.sublist(start, end);

    // Update progress
    if (onProgress != null) {
      onProgress(
        batchIndex + 1, 
        totalBatches, 
        (batchIndex * batchSize) + batch.length, 
        totalAssets
      );
    }

    try {
      // Call upload batch
      await uploadBatch(batch);
      successCount += batch.length;
    } catch (e) {
      // If one batch fails, continue with others
      failureCount += batch.length;
      // Could add more error handling here if needed
    }

    // Small delay between batches to prevent overwhelming the server
    await Future.delayed(Duration(milliseconds: 100));
  }

  return (failureCount == 0, successCount, failureCount);
}

/// Show error dialog with scrollable list of errors
void _showErrorDialog(BuildContext context, List<String> errors) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text('Lỗi Import Dữ Liệu'),
          ],
        ),
        content: Container(
          width: double.minPositive,
          height: 400,
          constraints: BoxConstraints(minWidth: 450),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Có ${errors.length} lỗi cần sửa trước khi import:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: errors.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 4),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              errors[index],
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.red.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Đóng'),
          ),
        ],
      );
    },
  );
}

