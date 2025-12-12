import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/common/model/signe_info.dart';
import 'package:quan_ly_tai_san_app/common/page/signers_table.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/detai_asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/Repository/auth_repository.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/detail_subpplies_handover_dto.dart';
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
        SGLog.debug(
          "formatted",
          "Failed to parse date: $date, Error: ${e2.toString()}",
        );
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
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: EdgeInsets.all(2.0 * scale),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: textStyle.copyWith(fontSize: 12 * scale),
        ),
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
    if (AccountHelper.instance.getAllUnit().isEmpty) {
      AuthRepository().loadUnit('ct001');
    }
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
                      AccountHelper.instance
                              .getUnitById(
                                dieuDongTaiSanDto
                                    .chiTietDieuDongTaiSans![i]
                                    .donViTinh,
                              )
                              ?.tenDonVi ??
                          '',
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
                      AppUtility.getHienTrang(
                        dieuDongTaiSanDto.chiTietDieuDongTaiSans![i].hienTrang,
                      ).name,
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
    if (AccountHelper.instance.getAllUnit().isEmpty) {
      AuthRepository().loadUnit('ct001');
    }
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
                  "Đơn vị tính",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Số lượng có sẵn",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Số lượng xuất kho",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Số lượng đã bàn giao",
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
                      AccountHelper.instance
                              .getUnitById(
                                toolAndMaterialTransferDto
                                    .detailToolAndMaterialTransfers![i]
                                    .donViTinh ??
                                    '',
                              )
                              ?.tenDonVi ??
                          '',
                      SettingPage.scale,
                      SettingPage.textStyle,
                    ),
                    tableCell(
                      toolAndMaterialTransferDto.detailToolAndMaterialTransfers![i].soLuong.toString(),
                      SettingPage.scale,
                      SettingPage.textStyle,
                    ),
                    tableCell(
                      toolAndMaterialTransferDto.detailToolAndMaterialTransfers![i].soLuongXuat.toString(),
                      SettingPage.scale,
                      SettingPage.textStyle,
                    ),
                    tableCell(
                      toolAndMaterialTransferDto.detailToolAndMaterialTransfers![i].soLuongDaBanGiao.toString(),
                      SettingPage.scale,
                      SettingPage.textStyle,
                    ),
                    tableCell(
                      toolAndMaterialTransferDto.detailToolAndMaterialTransfers![i].ghiChu,
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
    List<DetailAssetHandoverDto>? listDetailAssetMobilization,
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
              "\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0Căn cứ QĐ số: ${assetHandoverDto.soQuyetDinh ?? ''} / ${SettingPage.formatted(assetHandoverDto.ngayQuyetDinh ?? '')} của Giám đốc Công ty V/v điều động tài sản từ PX${assetHandoverDto.tenDonViGiao ?? ''}  đến PX ${assetHandoverDto.tenDonViNhan ?? ''}.\n"
              "\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0Hôm nay, ${SettingPage.formatted(assetHandoverDto.ngayBanGiao ?? '')} tại ${assetHandoverDto.diaDiemQuyetDinh ?? ''}.",
          style: SettingPage.textStyle,
        ),

        SGText(
          text: "Chúng tôi gồm:",
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
              "Tiến hành giao nhận tài sản từ phân xưởng ${assetHandoverDto.tenDonViGiao ?? ''} giao cho phân xưởng ${assetHandoverDto.tenDonViNhan ?? ''} cụ thể như sau:",
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
                  "Mã hiệu, quy cách",
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
                    listDetailAssetMobilization![i].tenTaiSan ?? '',
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    AccountHelper.instance
                            .getUnitById(
                              listDetailAssetMobilization[i].donViTinh ?? '',
                            )
                            ?.tenDonVi ??
                        '',
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization[i].soLuong == 0
                        ? '1'
                        : listDetailAssetMobilization[i].soLuong?.toString() ??
                            '1',
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    AppUtility.getHienTrang(
                      listDetailAssetMobilization[i].hienTrang ?? 0,
                    ).name,
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization[i].moTa ?? '',
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                ],
              ),
          ],
        ),
        SGText(text: "Sau khi hai bên kiểm tra kỹ lưỡng tình trạng và thống nhất ký tên vào biên bản.",),
        SizedBox(height: 20 * SettingPage.scale),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...listSigneInfo!.map(
                (e) => Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 50 * SettingPage.scale,
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: SGText(
                            text: e.donVi,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: SettingPage.textStyle.copyWith(
                              fontSize: 12 * SettingPage.scale,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 90 * SettingPage.scale),
                      SizedBox(
                        height: 40 * SettingPage.scale,
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: SGText(
                            text: e.hoTen.toUpperCase(),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: SettingPage.textStyle.copyWith(
                              fontSize: 11 * SettingPage.scale,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget toolAndSuppliesHandoverPageV2(
    ToolAndSuppliesHandoverDto banGiaoCCDCVatTu,
    List<DetailSubppliesHandoverDto>? listDetailAssetMobilization,
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
              "\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0Căn cứ QĐ số: ${banGiaoCCDCVatTu.soQuyetDinh ?? ''} / ${SettingPage.formatted(banGiaoCCDCVatTu.ngayQuyetDinh ?? '')} của Giám đốc Công ty V/v điều động tài sản từ PX${banGiaoCCDCVatTu.tenDonViGiao ?? ''}  đến PX ${banGiaoCCDCVatTu.tenDonViNhan ?? ''}.\n"
              "\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0Hôm nay, ${SettingPage.formatted(banGiaoCCDCVatTu.ngayBanGiao ?? '')} tại ${banGiaoCCDCVatTu.diaDiemQuyetDinh ?? ''}.",
          style: SettingPage.textStyle,
        ),
        SGText(
          text: "Chúng tôi gồm:",
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
              "Tiến hành giao nhận tài sản từ phân xưởng ${banGiaoCCDCVatTu.tenDonViGiao ?? ''} giao cho phân xưởng ${banGiaoCCDCVatTu.tenDonViNhan ?? ''} cụ thể như sau:",
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
                  "Tên ccdc - vật tư",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Mã hiệu, quy cách",
                  SettingPage.scale,
                  SettingPage.textStyle,
                ),
                tableHeader(
                  "Số lượng cần bàn giao",
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
                    listDetailAssetMobilization![i]
                            .chiTietDieuDongCCDCVatTuDTO
                            ?.tenCCDCVatTu ??
                        '',
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    AccountHelper.instance
                            .getUnitById(
                              listDetailAssetMobilization[i]
                                      .chiTietDieuDongCCDCVatTuDTO
                                      ?.donViTinh ??
                                  '',
                            )
                            ?.tenDonVi ??
                        '',
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    "${(listDetailAssetMobilization[i].chiTietDieuDongCCDCVatTuDTO?.soLuongXuat ?? 0) - (listDetailAssetMobilization[i].chiTietDieuDongCCDCVatTuDTO?.soLuongDaBanGiao ?? 0)}",
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization[i].soLuong.toString(),
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                  tableCell(
                    listDetailAssetMobilization[i]
                            .chiTietDieuDongCCDCVatTuDTO
                            ?.ghiChu
                            .toString() ??
                        '',
                    SettingPage.scale,
                    SettingPage.textStyle,
                  ),
                ],
              ),
          ],
        ),
        SizedBox(height: 20 * SettingPage.scale),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...listSigneInfo!.map(
                (e) => Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 50 * SettingPage.scale,
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: SGText(
                            text: e.isBGD ? e.chucVu : e.donVi,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: SettingPage.textStyle.copyWith(
                              fontSize: 12 * SettingPage.scale,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 90 * SettingPage.scale),
                      SizedBox(
                        height: 40 * SettingPage.scale,
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: SGText(
                            text: e.hoTen.toUpperCase(),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: SettingPage.textStyle.copyWith(
                              fontSize: 11 * SettingPage.scale,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
