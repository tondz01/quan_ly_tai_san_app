import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/common/model/signe_info.dart';
import 'package:quan_ly_tai_san_app/common/page/signers_table.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/detail_tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/tool_and_supplies_handover_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class SettingPage {
  static double scale = 1.4;
  static TextStyle textStyle = TextStyle(
    fontFamily: "Times New Roman",
    fontWeight: FontWeight.w500,
    fontSize: 13 * scale,
    height: 1.5,
  );
  
  static String formatted(String? date) {
    if (date == null || date.trim().isEmpty) {
      SGLog.debug("formatted", "Empty date string");
      return '';
    }
    try {
      // Thử parse với định dạng mới trước: yyyy-MM-dd HH:mm:ss
      DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
      return DateFormat(
        "'ngày' dd 'tháng' MM 'năm' yyyy",
        'vi',
      ).format(dateTime);
    } catch (e) {
      try {
        // Fallback về định dạng cũ nếu định dạng mới không khớp
        DateTime dateTime = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").parse(date);
        return DateFormat(
          "'ngày' dd 'tháng' MM 'năm' yyyy",
          'vi',
        ).format(dateTime);
      } catch (e2) {
        SGLog.debug("formatted", "Failed to parse date: $date, Error: ${e2.toString()}");
        return '';
      }
    }
  }

}

class ContractPage {
  static Widget tableHeader(String text, double scale, TextStyle textStyle) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: EdgeInsets.all(2.0 * scale),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: textStyle.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static Widget tableCell(String text, double scale, TextStyle textStyle) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.top,
      child: Padding(
        padding: EdgeInsets.all(2.0 * scale),
        child: Text(text, style: textStyle.copyWith(fontSize: 12 * scale)),
      ),
    );
  }

  static Widget assetHandoverPage(
    AssetHandoverDto assetHandoverDto,
    List<ChiTietDieuDongTaiSan>? listDetailAssetMobilization,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: SGText(
            text: "BẢNG KÊ CHI TIẾT",
            style: SettingPage.textStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14 * SettingPage.scale,
            ),
          ),
        ),
        SizedBox(height: 14 * SettingPage.scale),
        Table(
          border: TableBorder.all(),
          columnWidths: const {
            0: FixedColumnWidth(40),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(1.5),
            4: FlexColumnWidth(1),
            5: FlexColumnWidth(1.5),
            6: FlexColumnWidth(1.5),
          },
          children: [
            TableRow(
              children: [
                tableHeader("STT", SettingPage.scale, SettingPage.textStyle),
                tableHeader(
                  "TÊN TÀI SẢN",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Ký, mã hiệu quy cách",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Đơn vị tính",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Số lượng",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Tình trạng kỹ thuật",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Ghi chú",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
              ],
            ),

            // Dữ liệu chi tiết chưa được cung cấp trong AssetHandoverDto
            for (int i = 0; i < (listDetailAssetMobilization?.length ?? 0); i++)
              TableRow(
                children: [
                  tableCell(
                    (i + 1).toString(),
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization![i].tenTaiSan,
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization[i].idTaiSan,
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization[i].donViTinh,
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization[i].soLuong.toString(),
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization[i].hienTrang.toString(),
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization[i].ghiChu,
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  static Widget ccdcHandoverPage(
    ToolAndSuppliesHandoverDto toolAndSuppliesHandoverDto,
    List<ChiTietDieuDongTaiSan>? listDetailAssetMobilization,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: SGText(
            text: "BẢNG KÊ CHI TIẾT",
            style: SettingPage.textStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14 * SettingPage.scale,
            ),
          ),
        ),
        SizedBox(height: 14 * SettingPage.scale),
        Table(
          border: TableBorder.all(),
          columnWidths: const {
            0: FixedColumnWidth(40),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(1.5),
            4: FlexColumnWidth(1),
            5: FlexColumnWidth(1.5),
            6: FlexColumnWidth(1.5),
          },
          children: [
            TableRow(
              children: [
                tableHeader("STT", SettingPage.scale, SettingPage.textStyle),
                tableHeader(
                  "TÊN TÀI SẢN",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Ký, mã hiệu quy cách",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Đơn vị tính",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Số lượng",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Tình trạng kỹ thuật",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Ghi chú",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
              ],
            ),

            // Dữ liệu chi tiết chưa được cung cấp trong AssetHandoverDto
            for (int i = 0; i < (listDetailAssetMobilization?.length ?? 0); i++)
              TableRow(
                children: [
                  tableCell(
                    (i + 1).toString(),
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization![i].tenTaiSan,
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization[i].idTaiSan,
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization[i].donViTinh,
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization[i].soLuong.toString(),
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization[i].hienTrang.toString(),
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization[i].ghiChu,
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  static Widget assetMovePage(DieuDongTaiSanDto dieuDongTaiSanDto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: SGText(
            text: "BẢNG KÊ CHI TIẾT",
            style: SettingPage.textStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14 * SettingPage.scale,
            ),
          ),
        ),
        SizedBox(height: 14 * SettingPage.scale),
        Table(
          border: TableBorder.all(),
          columnWidths: const {
            0: FixedColumnWidth(40),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
            5: FlexColumnWidth(1.5),
          },
          children: [
            TableRow(
              children: [
                tableHeader("STT", SettingPage.scale, SettingPage.textStyle),
                tableHeader(
                  "TÊN TÀI SẢN",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Ký, mã hiệu quy cách",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Đơn vị tính",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Số lượng",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Ghi chú",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
              ],
            ),
            if (dieuDongTaiSanDto.chiTietDieuDongTaiSans != null)
              for (
                int i = 0;
                i < dieuDongTaiSanDto.chiTietDieuDongTaiSans!.length;
                i++
              )
                TableRow(
                  children: [
                    tableCell(
                      (i + 1).toString(),
                      SettingPage.scale,
                      SettingPage.textStyle,
                    ),
                    tableCell(
                      dieuDongTaiSanDto.chiTietDieuDongTaiSans![i].tenTaiSan,
                      SettingPage.scale,
                      SettingPage.textStyle,
                    ),
                    tableCell(
                      dieuDongTaiSanDto.chiTietDieuDongTaiSans![i].idTaiSan,
                      SettingPage.scale,
                      SettingPage.textStyle,
                    ),
                    tableCell(
                      dieuDongTaiSanDto.chiTietDieuDongTaiSans![i].donViTinh,
                      SettingPage.scale,
                      SettingPage.textStyle,
                    ),
                    tableCell(
                      dieuDongTaiSanDto.chiTietDieuDongTaiSans![i].soLuong
                          .toString(),
                      SettingPage.scale,
                      SettingPage.textStyle,
                    ),
                    tableCell(
                      dieuDongTaiSanDto.chiTietDieuDongTaiSans![i].ghiChu,
                      SettingPage.scale,
                      SettingPage.textStyle,
                    ),
                  ],
                ),
          ],
        ),
      ],
    );
  }

  static Widget toolAndMaterialTransferPage(
    ToolAndMaterialTransferDto toolAndMaterialTransferDto,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: SGText(
            text: "BẢNG KÊ CHI TIẾT",
            style: SettingPage.textStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14 * SettingPage.scale,
            ),
          ),
        ),
        SizedBox(height: 14 * SettingPage.scale),
        Table(
          border: TableBorder.all(),
          columnWidths: const {
            0: FixedColumnWidth(40),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
            5: FlexColumnWidth(1),
            6: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              children: [
                tableHeader("STT", SettingPage.scale, SettingPage.textStyle),
                tableHeader(
                  "TÊN CCDC, VẬT TƯ",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Ký, mã hiệu quy cách",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Đơn vị tính",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Số lượng",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Số lượng xuất kho",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Ghi chú",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
              ],
            ),
            if (toolAndMaterialTransferDto.detailToolAndMaterialTransfers !=
                null)
              for (
                int i = 0;
                i <
                    toolAndMaterialTransferDto
                        .detailToolAndMaterialTransfers!
                        .length;
                i++
              )
                TableRow(
                  children: [
                    tableCell(
                      (i + 1).toString(),
                      SettingPage.scale,
                      SettingPage.textStyle,
                    ),
                    tableCell(
                      toolAndMaterialTransferDto
                              .detailToolAndMaterialTransfers![i]
                              .tenCCDCVatTu ??
                          '',
                      SettingPage.scale,
                      SettingPage.textStyle,
                    ),
                    tableCell(
                      toolAndMaterialTransferDto
                          .detailToolAndMaterialTransfers![i]
                          .idCCDCVatTu,
                      SettingPage.scale,
                      SettingPage.textStyle,
                    ),
                    tableCell(
                      toolAndMaterialTransferDto
                              .detailToolAndMaterialTransfers![i]
                              .donViTinh ??
                          '',
                      SettingPage.scale,
                      SettingPage.textStyle,
                    ),
                    tableCell(
                      toolAndMaterialTransferDto
                          .detailToolAndMaterialTransfers![i]
                          .soLuong
                          .toString(),
                      SettingPage.scale,
                      SettingPage.textStyle,
                    ),
                    tableCell(
                      toolAndMaterialTransferDto
                          .detailToolAndMaterialTransfers![i]
                          .soLuongXuat
                          .toString(),
                      SettingPage.scale,
                      SettingPage.textStyle,
                    ),
                    tableCell(
                      toolAndMaterialTransferDto
                          .detailToolAndMaterialTransfers![i]
                          .ghiChu,
                      SettingPage.scale,
                      SettingPage.textStyle,
                    ),
                  ],
                ),
          ],
        ),
      ],
    );
  }

  static Widget assetHandoverPageV2(
    AssetHandoverDto assetHandoverDto,
    List<ChiTietDieuDongTaiSan>? listDetailAssetMobilization,
    List<SigneInfo>? listSigneInfo,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SGText(
                      text: "TẬP ĐOÀN CÔNG NGHIỆP\nTHAN - KHOÁNG SẢN VIỆT NAM",
                      style: SettingPage.textStyle,
                      textAlign: TextAlign.center,
                    ),
                    SGText(
                      text: "CÔNG TY THAN UÔNG BÍ - TKV",
                      style: SettingPage.textStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SGText(
                text: "BIÊN BẢN\nGIAO NHẬN TÀI SẢN",
                style: SettingPage.textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14 * SettingPage.scale,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),

        SizedBox(height: 24 * SettingPage.scale),

        SGText(
          text:
              "\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0Căn cứ vào Quyết định điều động số ${assetHandoverDto.quyetDinhDieuDongSo ?? ''}, ${SettingPage.formatted(assetHandoverDto.ngayBanGiao ?? '')} của Giám đốc Công ty V/v điều động tài sản từ ${assetHandoverDto.tenDonViGiao ?? ''}  đến  ${assetHandoverDto.tenDonViNhan ?? ''}.\n"
              "\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0Hôm nay, ${SettingPage.formatted(assetHandoverDto.ngayTaoChungTu ?? '')} , tại ${assetHandoverDto.tenDonViGiao}.",
          style: SettingPage.textStyle,
        ),

        SGText(
          text: "Chúng tôi gồm có:",
          style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 2 * SettingPage.scale),
        Padding(
          padding: EdgeInsets.only(left: 18 * SettingPage.scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((listSigneInfo?.length ?? 0) > 0)
                SignersTable(
                  signers: listSigneInfo!,
                  scale: SettingPage.scale,
                  textStyle: SettingPage.textStyle,
                  gapAfterValue: 18.0,
                ),
            ],
          ),
        ),
        SizedBox(height: 2 * SettingPage.scale),
        SGText(
          text:
              "Tiến hành giao nhận tài sản từ: ${assetHandoverDto.tenDonViGiao ?? ''} giao cho ${assetHandoverDto.tenDonViNhan ?? ''} cụ thể như sau:",
          style: SettingPage.textStyle,
        ),
        SizedBox(height: 4 * SettingPage.scale),
        Table(
          border: TableBorder.all(),
          columnWidths: const {
            0: FixedColumnWidth(40),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(1.5),
            4: FlexColumnWidth(1),
            5: FlexColumnWidth(1.5),
            6: FlexColumnWidth(1.5),
          },
          children: [
            TableRow(
              children: [
                tableHeader("STT", SettingPage.scale, SettingPage.textStyle),
                tableHeader(
                  "TÊN TÀI SẢN",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Ký, mã hiệu quy cách",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Đơn vị tính",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Số lượng",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Tình trạng kỹ thuật",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Ghi chú",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
              ],
            ),

            // Dữ liệu chi tiết chưa được cung cấp trong AssetHandoverDto
            for (int i = 0; i < (listDetailAssetMobilization?.length ?? 0); i++)
              TableRow(
                children: [
                  tableCell(
                    (i + 1).toString(),
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization![i].tenTaiSan,
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization[i].idTaiSan,
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization[i].donViTinh,
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization[i].soLuong.toString(),
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization[i].hienTrang.toString(),
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization[i].ghiChu,
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                ],
              ),
          ],
        ),
        SizedBox(height: 20 * SettingPage.scale),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...listSigneInfo!.map(
              (e) => Column(
                children: [
                  SGText(
                    text: e.title,
                    style: SettingPage.textStyle.copyWith(
                      fontSize: 12 * SettingPage.scale,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SGText(
                    text: "(Ký, họ tên)",
                    style: SettingPage.textStyle.copyWith(
                      fontSize: 11 * SettingPage.scale,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget toolAndSuppliesHandoverPageV2(
    ToolAndSuppliesHandoverDto banGiaoCCDCVatTu,
    List<DetailToolAndMaterialTransferDto>? listDetailAssetMobilization,
    List<SigneInfo>? listSigneInfo,
  ) {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SGText(
                      text: "TẬP ĐOÀN CÔNG NGHIỆP\nTHAN - KHOÁNG SẢN VIỆT NAM",
                      style: SettingPage.textStyle,
                      textAlign: TextAlign.center,
                    ),
                    SGText(
                      text: "CÔNG TY THAN UÔNG BÍ - TKV",
                      style: SettingPage.textStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SGText(
                text: "BIÊN BẢN\nGIAO NHẬN TÀI SẢN",
                style: SettingPage.textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14 * SettingPage.scale,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),

        SizedBox(height: 24 * SettingPage.scale),

        SGText(
          text:
              "\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0Căn cứ vào Quyết định điều động số ${banGiaoCCDCVatTu.quyetDinhDieuDongSo ?? ''}, ${SettingPage.formatted(banGiaoCCDCVatTu.ngayBanGiao ?? '')} của Giám đốc Công ty V/v điều động tài sản từ ${banGiaoCCDCVatTu.tenDonViGiao ?? ''}  đến  ${banGiaoCCDCVatTu.tenDonViNhan ?? ''}.\n"
              "\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0Hôm nay, ${SettingPage.formatted(banGiaoCCDCVatTu.ngayTaoChungTu ?? '')} , tại ${banGiaoCCDCVatTu.tenDonViGiao}.",
          style: SettingPage.textStyle,
        ),
        SGText(
          text: "Chúng tôi gồm có:",
          style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 2 * SettingPage.scale),
        Padding(
          padding: EdgeInsets.only(left: 18 * SettingPage.scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((listSigneInfo?.length ?? 0) > 0)
                SignersTable(
                  signers: listSigneInfo!,
                  scale: SettingPage.scale,
                  textStyle: SettingPage.textStyle,
                  gapAfterValue: 18.0,
                ),
            ],
          ),
        ),
        SizedBox(height: 2 * SettingPage.scale),
        SGText(
          text:
              "Tiến hành giao nhận tài sản từ: ${banGiaoCCDCVatTu.tenDonViGiao ?? ''} giao cho ${banGiaoCCDCVatTu.tenDonViNhan ?? ''} cụ thể như sau:",
          style: SettingPage.textStyle,
        ),
        SizedBox(height: 4 * SettingPage.scale),
        Table(
          border: TableBorder.all(),
          columnWidths: const {
            0: FixedColumnWidth(40),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(1.5),
            4: FlexColumnWidth(1),
            5: FlexColumnWidth(1.5),
            6: FlexColumnWidth(1.5),
          },
          children: [
            TableRow(
              children: [
                tableHeader("STT", SettingPage.scale, SettingPage.textStyle),
                tableHeader(
                  "TÊN CCDC - VẬT TƯ",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Đơn vị tính",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Số lượng",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Số lượng xuất",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Ghi chú",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
              ],
            ),

            // Dữ liệu chi tiết chưa được cung cấp trong AssetHandoverDto
            for (int i = 0; i < (listDetailAssetMobilization?.length ?? 0); i++)
              TableRow(
                children: [
                  tableCell(
                    (i + 1).toString(),
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization![i].tenCCDCVatTu ?? '',
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization[i].donViTinh ?? '',
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization[i].soLuong.toString(),
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization[i].soLuongXuat.toString(),
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization[i].ghiChu,
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                ],
              ),
          ],
        ),
        SizedBox(height: 20 * SettingPage.scale),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...listSigneInfo!.map(
              (e) => Column(
                children: [
                  SGText(
                    text: e.title,
                    style: SettingPage.textStyle.copyWith(
                      fontSize: 12 * SettingPage.scale,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SGText(
                    text: "(Ký, họ tên)",
                    style: SettingPage.textStyle.copyWith(
                      fontSize: 11 * SettingPage.scale,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
