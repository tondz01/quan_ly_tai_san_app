import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/detai_asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/repository/asset_handover_repository.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/detail_assets_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/repository/asset_management_repository.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/data_map.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/detail_tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/tool_and_supplies_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/repository/tool_and_supplies_handover_repository.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/repository/tools_and_supplies_repository.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class ReportProvider {
  Future<Map<String, dynamic>> getReportAsset(
    String idDepartment,
    DateTime year,
  ) async {
    Map<String, dynamic> resultReport = {
      'data_increase': [],
      'data_reduce': [],
    };
    try {
      List<AssetHandoverDto> listAssetHandover = [];
      Map<String, dynamic> result =
          await AssetHandoverRepository().getAllAssetHandover();
      if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
        listAssetHandover = result['data'];
      }
      if (listAssetHandover.isNotEmpty) {
        resultReport['data_increase'] =
            listAssetHandover
                .where((element) => element.idDonViNhan == idDepartment)
                .where((element) {
                  if (element.ngayBanGiao == null) return false;
                  String date = convertDate(element.ngayBanGiao)!;
                  DateFormat format = DateFormat("dd/MM/yyyy");
                  DateTime dateTime = format.parse(date);
                  return dateTime.year == year.year;
                })
                .toList();
        resultReport['data_reduce'] =
            listAssetHandover
                .where((element) => element.idDonViGiao == idDepartment)
                .where((element) {
                  if (element.ngayBanGiao == null) return false;

                  String date = convertDate(element.ngayBanGiao)!;
                  DateFormat format = DateFormat("dd/MM/yyyy");
                  DateTime dateTime = format.parse(date);
                  return dateTime.year == year.year;
                })
                .toList();
      }
    } catch (e) {
      return resultReport;
    }
    return resultReport;
  }

  Future<Map<String, dynamic>> getReportCCDC(
    String idDepartment,
    DateTime year,
  ) async {
    Map<String, dynamic> resultReport = {
      'data_increase': [],
      'data_reduce': [],
    };

    try {
      List<ToolAndSuppliesHandoverDto> listCCDCHandover = [];
      Map<String, dynamic> result =
          await ToolAndSuppliesHandoverRepository()
              .getAllToolSupHandoverStatus();
      if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
        listCCDCHandover = result['data'];
      }
      if (listCCDCHandover.isNotEmpty) {
        resultReport['data_increase'] =
            listCCDCHandover
                .where((element) => element.idDonViNhan == idDepartment)
                .where((element) {
                  if (element.ngayBanGiao == null) return false;
                  String date = convertDate(element.ngayBanGiao)!;
                  DateFormat format = DateFormat("dd/MM/yyyy");
                  DateTime dateTimeIncrease = format.parse(date);
                  return dateTimeIncrease.year == year.year;
                })
                .toList();
        resultReport['data_reduce'] =
            listCCDCHandover
                .where((element) => element.idDonViGiao == idDepartment)
                .where((element) {
                  if (element.ngayBanGiao == null) return false;
                  String date = convertDate(element.ngayBanGiao)!;
                  DateFormat format = DateFormat("dd/MM/yyyy");
                  DateTime dateTimeReduce = format.parse(date);
                  return dateTimeReduce.year == year.year;
                })
                .toList();
      }
    } catch (e) {
      return resultReport;
    }
    return resultReport;
  }

  AssetManagementDto? getInfoAsset(
    String idAsset,
    List<AssetManagementDto> listAssetManagement,
  ) {
    if (listAssetManagement.isNotEmpty) {
      return listAssetManagement.firstWhere(
        (element) => element.id == idAsset,
        orElse: () => AssetManagementDto.empty(),
      );
    }
    return AssetManagementDto.empty();
  }

  ToolsAndSuppliesDto? getInfoCCDC(
    String idAsset,
    List<ToolsAndSuppliesDto> listToolsAndSupplies,
  ) {
    if (listToolsAndSupplies.isNotEmpty) {
      return listToolsAndSupplies.firstWhere(
        (element) => element.id == idAsset,
        orElse: () => ToolsAndSuppliesDto.empty(),
      );
    }
    return ToolsAndSuppliesDto.empty();
  }

  Future<List<AssetManagementDto>> getListAsset() async {
    List<AssetManagementDto> list = [];
    Map<String, dynamic> result = await AssetManagementRepository()
        .getListAssetManagement('ct001');
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      list = result['data'];
    }
    return list;
  }

  Future<List<ToolsAndSuppliesDto>> getListCCDC(String idCongTy) async {
    List<ToolsAndSuppliesDto> list = [];
    Map<String, dynamic> result = await ToolsAndSuppliesRepository()
        .getListToolsAndSupplies(idCongTy);

    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      list = result['data'];
    }
    return list;
  }

  List<DataMap> mapIncrease(
    List<DetailAssetHandoverDto> list,
    List<AssetManagementDto> assets,
  ) {
    return list.map((dto) {
      AssetManagementDto? assetInfo = getInfoAsset(dto.idTaiSan ?? '', assets);
      return DataMap(
        tenTaiSan: assetInfo?.tenTaiSan,
        soHieu: assetInfo?.kyHieu,
        ngayThang: convertDate(dto.ngayTao),
        donViTinh: dto.donViTinh,
        soLuong: dto.soLuong,
        donGia: assetInfo?.nguyenGia ?? 0,
        soTien: assetInfo?.nguyenGia,
        type: DataMapType.INCREASE,
        // các trường còn lại để null
      );
    }).toList();
  }

  List<DataMap> mapReduce(
    List<DetailAssetHandoverDto> list,
    List<AssetManagementDto> assets,
  ) {
    return list.map((dto) {
      AssetManagementDto? assetInfo = getInfoAsset(dto.idTaiSan ?? '', assets);
      return DataMap(
        tenTaiSan: assetInfo?.tenTaiSan,
        soHieu: assetInfo?.kyHieu,
        ngayThang: convertDate(dto.ngayTao),
        donViTinh: dto.donViTinh,
        soLuong: dto.soLuong,
        donGia: assetInfo?.nguyenGia ?? 0,
        soTien: assetInfo?.nguyenGia,
        type: DataMapType.REDUCE,
        // các trường còn lại để null
      );
    }).toList();
  }

  List<DataMap> mapIncreaseCCDC(
    List<DetailToolAndMaterialTransferDto> list,
    List<ToolsAndSuppliesDto> assets,
  ) {
    return list.map((dto) {
      ToolsAndSuppliesDto? assetInfo = getInfoCCDC(dto.idCCDCVatTu, assets);
      List<DetailAssetDto>? detailAssetInfo =
          assetInfo?.chiTietTaiSanList ?? [];
      DetailAssetDto? detailAssetInfoItem = detailAssetInfo.firstWhere(
        (element) => element.id == dto.idChiTietCCDCVatTu,
        orElse: () => DetailAssetDto.empty(),
      );
      String tenDonVi =
          AccountHelper.instance
              .getDepartmentById(dto.donViTinh ?? '')
              ?.tenPhongBan ??
          '';
      return DataMap(
        tenTaiSan: assetInfo?.ten,
        soHieu: detailAssetInfoItem.id,
        ngayThang: convertDate(dto.ngayTao),
        donViTinh: tenDonVi,
        soLuong: dto.soLuong,
        donGia: assetInfo?.giaTri ?? 0,
        soTien: assetInfo?.giaTri ?? 0,
        type: DataMapType.INCREASE,
        // các trường còn lại để null
      );
    }).toList();
  }

  List<DataMap> mapReduceCCDC(
    List<DetailToolAndMaterialTransferDto> list,
    List<ToolsAndSuppliesDto> assets,
  ) {
    return list.map((dto) {
      ToolsAndSuppliesDto? assetInfo = getInfoCCDC(dto.idCCDCVatTu, assets);
      List<DetailAssetDto>? detailAssetInfo =
          assetInfo?.chiTietTaiSanList ?? [];
      DetailAssetDto? detailAssetInfoItem = detailAssetInfo.firstWhere(
        (element) => element.id == dto.idChiTietCCDCVatTu,
        orElse: () => DetailAssetDto.empty(),
      );
      String tenDonVi =
          AccountHelper.instance
              .getDepartmentById(dto.donViTinh ?? '')
              ?.tenPhongBan ??
          '';
      return DataMap(
        tenTaiSan: assetInfo?.ten,
        soHieu: detailAssetInfoItem.id,
        ngayThang: convertDate(dto.ngayTao),
        donViTinh: tenDonVi,
        soLuong: dto.soLuong,
        donGia: assetInfo?.giaTri ?? 0,
        soTien: assetInfo?.giaTri ?? 0,
        type: DataMapType.REDUCE,
        // các trường còn lại để null
      );
    }).toList();
  }

  String? convertDate(String? date) {
    if (date == null || date.isEmpty) return null;
    try {
      // Chuẩn hóa chuỗi ngày để tăng độ bền khi parse
      final normalized = date.trim().replaceFirst(' ', 'T');
      final DateTime dateTime = DateTime.parse(normalized);
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      return null;
    }
  }

  Future<void> exportToPdf(
    List<GlobalKey> pageKeys,
    BuildContext context,
    VoidCallback onExportSuccess,
  ) async {
    try {
      final pdf = pw.Document();
      // Đợi frame hiện tại kết thúc để đảm bảo UI render hoàn toàn
      await WidgetsBinding.instance.endOfFrame;
      if (pageKeys.isEmpty) {
        if (context.mounted) {
          AppUtility.showSnackBar(
            context,
            'Không có trang để xuất.',
            isError: true,
          );
        }
        return;
      }

      // Đợi thêm một khoảng nhỏ để ổn định layout (phòng trường hợp scroll/layout vừa thay đổi)
      await Future.delayed(const Duration(milliseconds: 50));

      for (final key in pageKeys) {
        final boundary =
            key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
        if (boundary == null) continue;

        final image = await boundary.toImage(pixelRatio: 1.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        final pngBytes = byteData!.buffer.asUint8List();

        final imageWidth = image.width.toDouble();
        final imageHeight = image.height.toDouble();
        if (imageWidth.isNaN ||
            imageHeight.isNaN ||
            imageWidth <= 0 ||
            imageHeight <= 0) {
          continue;
        }

        final imageProvider = pw.MemoryImage(pngBytes);
        final aspectRatio = imageWidth / imageHeight;
        final a4AspectRatio = PdfPageFormat.a4.width / PdfPageFormat.a4.height;

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4.portrait,
            margin: const pw.EdgeInsets.all(20),
            build: (context) {
              if (aspectRatio > a4AspectRatio) {
                return pw.Center(
                  child: pw.Image(imageProvider, fit: pw.BoxFit.fitWidth),
                );
              } else {
                return pw.Center(
                  child: pw.Image(imageProvider, fit: pw.BoxFit.fitHeight),
                );
              }
            },
          ),
        );
      }

      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename:
            'bien_ban_so_22_dn_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
    } catch (e) {
      SGLog.error('Lỗi xuất PDF', 'Lỗi xuất PDF: $e');
      if (context.mounted) {
        AppUtility.showSnackBar(context, 'Lỗi xuất PDF: $e', isError: true);
      }
      return;
    } finally {
      onExportSuccess.call();
    }
  }

  Future<void> exportToPdfAndPrint(
    List<GlobalKey> pageKeys,
    BuildContext context,
    VoidCallback onPrintDone,
  ) async {
    try {
      final pdf = pw.Document();
      await WidgetsBinding.instance.endOfFrame;
      if (pageKeys.isEmpty) {
        if (context.mounted) {
          AppUtility.showSnackBar(
            context,
            'Không có trang để in.',
            isError: true,
          );
        }
        return;
      }

      await Future.delayed(const Duration(milliseconds: 50));

      for (final key in pageKeys) {
        final boundary =
            key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
        if (boundary == null) continue;

        final image = await boundary.toImage(pixelRatio: 1.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        final pngBytes = byteData!.buffer.asUint8List();

        final imageWidth = image.width.toDouble();
        final imageHeight = image.height.toDouble();
        if (imageWidth.isNaN ||
            imageHeight.isNaN ||
            imageWidth <= 0 ||
            imageHeight <= 0) {
          continue;
        }

        final imageProvider = pw.MemoryImage(pngBytes);
        final aspectRatio = imageWidth / imageHeight;
        final a4AspectRatio = PdfPageFormat.a4.width / PdfPageFormat.a4.height;

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(20),
            build: (context) {
              if (aspectRatio > a4AspectRatio) {
                return pw.Center(
                  child: pw.Image(imageProvider, fit: pw.BoxFit.fitWidth),
                );
              } else {
                return pw.Center(
                  child: pw.Image(imageProvider, fit: pw.BoxFit.fitHeight),
                );
              }
            },
          ),
        );
      }

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => await pdf.save(),
      );
    } catch (e) {
      SGLog.error('Lỗi in PDF', 'Lỗi in PDF: $e');
      if (context.mounted) {
        AppUtility.showSnackBar(context, 'Lỗi in PDF: $e', isError: true);
      }
      return;
    } finally {
      onPrintDone.call();
    }
  }
}
