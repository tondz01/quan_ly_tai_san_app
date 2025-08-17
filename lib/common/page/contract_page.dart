import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class SettingPage {
  static double scale = 1.4;
  static TextStyle textStyle = TextStyle(fontFamily: "Times New Roman", fontWeight: FontWeight.w500, fontSize: 13 * scale, height: 1.5);
  static String formatted(String? date) {
    if (date == null || date.trim().isEmpty) {
      SGLog.debug("formatted", "Empty date string");
      return '';
    }
    try {
      DateTime dateTime = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").parse(date);
      return DateFormat("'ngày' dd 'tháng' MM 'năm' yyyy", 'vi').format(dateTime);
    } catch (e) {
      SGLog.debug("formatted", e.toString());
      return '';
    }
  }
}

class ContractPage {
  static Widget tableHeader(String text, double scale, TextStyle textStyle) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(padding: EdgeInsets.all(2.0 * scale), child: Text(text, textAlign: TextAlign.center, style: textStyle.copyWith(fontWeight: FontWeight.bold))),
    );
  }

  static Widget tableCell(String text, double scale, TextStyle textStyle) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.top,
      child: Padding(padding: EdgeInsets.all(2.0 * scale), child: Text(text, style: textStyle.copyWith(fontSize: 12 * scale))),
    );
  }

  static Widget assetHandoverPage(AssetHandoverDto assetHandoverDto, List<ChiTietDieuDongTaiSan>? listDetailAssetMobilization) {
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
                    SGText(text: "TẬP ĐOÀN CÔNG NGHIỆP\nTHAN - KHOÁNG SẢN VIỆT NAM", style: SettingPage.textStyle, textAlign: TextAlign.center),
                    SGText(text: "CÔNG TY THAN UÔNG BÍ - TKV", style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SGText(
                text: "BIÊN BẢN\nGIAO NHẬN TÀI SẢN",
                style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 14 * SettingPage.scale),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),

        SizedBox(height: 24 * SettingPage.scale),

        SGText(
          text:
              "\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0Căn cứ vào Quyết định điều động số ${assetHandoverDto.quyetDinhDieuDongSo ?? ''}, ${SettingPage.formatted(assetHandoverDto.ngayBanGiao ?? '')} của Giám đốc Công ty V/v điều động tài sản từ ${assetHandoverDto.tenDonViGiao ?? ''}  đến  ${assetHandoverDto.tenDonViNhan ?? ''}.\n"
              "\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0Hôm nay, ${SettingPage.formatted(assetHandoverDto.ngayBanGiao ?? '')} , tại ${assetHandoverDto.tenDonViGiao}.",
          style: SettingPage.textStyle,
        ),
        SGText(text: "Chúng tôi gồm có:", style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.start),
        SizedBox(height: 2 * SettingPage.scale),
        Padding(
          padding: EdgeInsets.only(left: 18 * SettingPage.scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SGText(text: "1.    Ông (bà): ${assetHandoverDto.tenLanhDao ?? ''}.....Chức vụ: Nhân viên.....Đại diện: Phòng CV", style: SettingPage.textStyle),
              SGText(
                text: "2.    Ông (bà): ${assetHandoverDto.tenDaiDienBenGiao ?? ''}.....Chức vụ: Trưởng phòng.....Đại diện: Kho Công ty (Bên giao)",
                style: SettingPage.textStyle,
              ),
              SGText(
                text: "3.    Ông (bà): ${assetHandoverDto.tenDaiDienBenNhan ?? ''}.....Chức vụ: Phó quản đốc.....Đại diện: Phân xưởng khai thác đào lò 1 (Bên nhận).",
                style: SettingPage.textStyle,
              ),
            ],
          ),
        ),
        SizedBox(height: 2 * SettingPage.scale),
        SGText(
          text: "Tiến hành giao nhận tài sản từ: ${assetHandoverDto.tenDonViGiao ?? ''} giao cho ${assetHandoverDto.tenDonViNhan ?? ''} cụ thể như sau:",
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
                tableHeader("TÊN TÀI SẢN", SettingPage.scale, SettingPage.textStyle),
                tableHeader("Ký, mã hiệu quy cách", SettingPage.scale, SettingPage.textStyle),
                tableHeader("Đơn vị tính", SettingPage.scale, SettingPage.textStyle),
                tableHeader("Số lượng", SettingPage.scale, SettingPage.textStyle),
                tableHeader("Tình trạng kỹ thuật", SettingPage.scale, SettingPage.textStyle),
                tableHeader("Ghi chú", SettingPage.scale, SettingPage.textStyle),
              ],
            ),

            // Dữ liệu chi tiết chưa được cung cấp trong AssetHandoverDto
            for (int i = 0; i < (listDetailAssetMobilization?.length ?? 0); i++)
              TableRow(
                children: [
                  tableCell((i + 1).toString(), SettingPage.scale, SettingPage.textStyle),
                  tableCell(listDetailAssetMobilization![i].tenTaiSan, SettingPage.scale, SettingPage.textStyle),
                  tableCell(listDetailAssetMobilization[i].idTaiSan, SettingPage.scale, SettingPage.textStyle),
                  tableCell(listDetailAssetMobilization[i].donViTinh, SettingPage.scale, SettingPage.textStyle),
                  tableCell(listDetailAssetMobilization[i].soLuong.toString(), SettingPage.scale, SettingPage.textStyle),
                  tableCell(listDetailAssetMobilization[i].hienTrang.toString(), SettingPage.scale, SettingPage.textStyle),
                  tableCell(listDetailAssetMobilization[i].ghiChu, SettingPage.scale, SettingPage.textStyle),
                ],
              ),
          ],
        ),
        SizedBox(height: 20 * SettingPage.scale),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SGText(text: "Đại diện bên giao", style: SettingPage.textStyle.copyWith(fontSize: 12 * SettingPage.scale, fontWeight: FontWeight.bold)),
                SGText(text: "(Ký, họ tên)", style: SettingPage.textStyle.copyWith(fontSize: 11 * SettingPage.scale)),
              ],
            ),
            Column(
              children: [
                SGText(text: "Đại diện bên nhận", style: SettingPage.textStyle.copyWith(fontSize: 12 * SettingPage.scale, fontWeight: FontWeight.bold)),
                SGText(text: "(Ký, họ tên)", style: SettingPage.textStyle.copyWith(fontSize: 11 * SettingPage.scale)),
              ],
            ),
            Column(
              children: [
                SGText(text: "Phòng Phòng CV", style: SettingPage.textStyle.copyWith(fontSize: 12 * SettingPage.scale, fontWeight: FontWeight.bold)),
                SGText(text: "(Ký, họ tên)", style: SettingPage.textStyle.copyWith(fontSize: 11 * SettingPage.scale)),
              ],
            ),
            Column(
              children: [
                SGText(text: "Đại diện Phòng KT", style: SettingPage.textStyle.copyWith(fontSize: 12 * SettingPage.scale, fontWeight: FontWeight.bold)),
                SGText(text: "(Ký, họ tên)", style: SettingPage.textStyle.copyWith(fontSize: 11 * SettingPage.scale)),
              ],
            ),
            Column(
              children: [
                SGText(text: "KT. Giám đốc", style: SettingPage.textStyle.copyWith(fontSize: 12 * SettingPage.scale, fontWeight: FontWeight.bold)),
                SGText(text: "(Ký, họ tên)", style: SettingPage.textStyle.copyWith(fontSize: 11 * SettingPage.scale)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static Widget assetMovePage(DieuDongTaiSanDto dieuDongTaiSanDto) {
    int type = dieuDongTaiSanDto.loai ?? 0;
    final String typeAssetTransfer =
        type == 1
            ? 'cấp phát tài sản'
            : type == 2
            ? 'diều động tài sản'
            : 'thu hồi tài sản';
    SGLog.debug("assetMovePage", dieuDongTaiSanDto.ngayCapNhat ?? '');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SGText(text: "TẬP ĐOÀN CÔNG NGHIỆP\nTHAN - KHOÁNG SẢN VIỆT NAM", style: SettingPage.textStyle, textAlign: TextAlign.center),
                    SGText(text: "CÔNG TY THAN UÔNG BÍ - TKV", style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      height: 1,
                      width: 70 * SettingPage.scale, // chỉnh độ dài của gạch ngang
                      color: Colors.black,
                    ),
                    SGText(text: "Số: ${dieuDongTaiSanDto.soQuyetDinh ?? ''}", style: SettingPage.textStyle, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SGText(text: "CỘNG HOÀ XÃ HỘI CHỦ NGHĨA VIỆT NAM", style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        SGText(text: "Độc lập - Tự do - Hạnh phúc", style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          height: 1,
                          width: 210 * SettingPage.scale, // chỉnh độ dài của gạch ngang
                          color: Colors.black,
                        ),
                      ],
                    ),
                    SGText(text: "", style: SettingPage.textStyle, textAlign: TextAlign.center),
                    SGText(text: "Uông Bí,  ${SettingPage.formatted(dieuDongTaiSanDto.ngayTao ?? '')} ", style: SettingPage.textStyle, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 24 * SettingPage.scale),
        Center(child: SGText(text: "QUYẾT ĐỊNH", style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 14 * SettingPage.scale))),
        Center(child: SGText(text: "Về việc $typeAssetTransfer", style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 14 * SettingPage.scale))),
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 2),
            height: 1,
            width: 120 * SettingPage.scale, // chỉnh độ dài của gạch ngang
            color: Colors.black,
          ),
        ),
        SizedBox(height: 16 * SettingPage.scale),
        Center(child: SGText(text: "GIÁM ĐỐC CÔNG TY THAN UÔNG BÍ - TKV", style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 14 * SettingPage.scale))),
        SizedBox(height: 16 * SettingPage.scale),
        SGText(
          text:
              "\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0Căn cứ Quyết định số ${dieuDongTaiSanDto.soQuyetDinh}, ${SettingPage.formatted(dieuDongTaiSanDto.ngayCapNhat ?? '')} của Giám đốc Công ty V/v $typeAssetTransfer từ ${dieuDongTaiSanDto.tenDonViGiao ?? ''} đến ${dieuDongTaiSanDto.tenDonViNhan ?? ''}\n"
              "\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0Hôm nay, ${SettingPage.formatted(dieuDongTaiSanDto.ngayCapNhat ?? '')}, tại  ${dieuDongTaiSanDto.tenDonViNhan ?? ''}",
          style: SettingPage.textStyle,
        ),
        SGText(text: "Chúng tôi gồm có:", style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 6 * SettingPage.scale),

        Padding(
          padding: EdgeInsets.only(left: 18 * SettingPage.scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SGText(text: "1.    Ông (bà): ${dieuDongTaiSanDto.tenNguoiDeNghi ?? ''}.....Chức vụ: Nhân viên.....Đại diện: ${dieuDongTaiSanDto.tenPhongBanXemPhieu ?? ''}."),
            ],
          ),
        ),
        SizedBox(height: 6 * SettingPage.scale),

        SGText(text: "Tiến hành điều động tài sản tại  ${dieuDongTaiSanDto.tenDonViNhan ?? ''} cụ thể như sau:", style: SettingPage.textStyle),
        SizedBox(height: 12 * SettingPage.scale),
        Table(
          border: TableBorder.all(),
          columnWidths: const {0: FixedColumnWidth(40), 1: FlexColumnWidth(2), 2: FlexColumnWidth(2), 3: FlexColumnWidth(1), 4: FlexColumnWidth(1), 5: FlexColumnWidth(1.5)},
          children: [
            TableRow(
              children: [
                tableHeader("STT", SettingPage.scale, SettingPage.textStyle),
                tableHeader("TÊN TÀI SẢN", SettingPage.scale, SettingPage.textStyle),
                tableHeader("Ký, mã hiệu quy cách", SettingPage.scale, SettingPage.textStyle),
                tableHeader("Đơn vị tính", SettingPage.scale, SettingPage.textStyle),
                tableHeader("Số lượng", SettingPage.scale, SettingPage.textStyle),
                tableHeader("Ghi chú", SettingPage.scale, SettingPage.textStyle),
              ],
            ),
            for (int i = 0; i < dieuDongTaiSanDto.chiTietDieuDongTaiSans!.length; i++)
              TableRow(
                children: [
                  tableCell((i + 1).toString(), SettingPage.scale, SettingPage.textStyle),
                  tableCell(dieuDongTaiSanDto.chiTietDieuDongTaiSans![i].tenTaiSan, SettingPage.scale, SettingPage.textStyle),
                  tableCell(dieuDongTaiSanDto.chiTietDieuDongTaiSans![i].idTaiSan, SettingPage.scale, SettingPage.textStyle),
                  tableCell(dieuDongTaiSanDto.chiTietDieuDongTaiSans![i].donViTinh, SettingPage.scale, SettingPage.textStyle),
                  tableCell(dieuDongTaiSanDto.chiTietDieuDongTaiSans![i].soLuong.toString(), SettingPage.scale, SettingPage.textStyle),
                  tableCell(dieuDongTaiSanDto.chiTietDieuDongTaiSans![i].ghiChu, SettingPage.scale, SettingPage.textStyle),
                ],
              ),
          ],
        ),

        SizedBox(height: 20 * SettingPage.scale),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 26 * SettingPage.scale),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SGText(text: "Nơi nhận", style: SettingPage.textStyle.copyWith(fontSize: 12 * SettingPage.scale, fontWeight: FontWeight.bold)),
                    SGText(text: "${dieuDongTaiSanDto.tenDonViNhan}", style: SettingPage.textStyle.copyWith(fontSize: 11 * SettingPage.scale)),
                  ],
                ),
              ),
            ),
            Expanded(child: Center(child: SGText(text: "GIÁM ĐỐC", style: SettingPage.textStyle.copyWith(fontSize: 12 * SettingPage.scale, fontWeight: FontWeight.bold)))),
          ],
        ),
      ],
    );
  }

  static Widget toolAndMaterialTransferPage(ToolAndMaterialTransferDto toolAndMaterialTransferDto) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SGText(text: "TẬP ĐOÀN CÔNG NGHIỆP\nTHAN - KHOÁNG SẢN VIỆT NAM", style: SettingPage.textStyle, textAlign: TextAlign.center),
                    SGText(text: "CÔNG TY THAN UÔNG BÍ - TKV", style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      height: 1,
                      width: 70 * SettingPage.scale, // chỉnh độ dài của gạch ngang
                      color: Colors.black,
                    ),
                    SGText(text: "Số: ${toolAndMaterialTransferDto.soQuyetDinh ?? ''}", style: SettingPage.textStyle, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SGText(text: "CỘNG HOÀ XÃ HỘI CHỦ NGHĨA VIỆT NAM", style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        SGText(text: "Độc lập - Tự do - Hạnh phúc", style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          height: 1,
                          width: 210 * SettingPage.scale, // chỉnh độ dài của gạch ngang
                          color: Colors.black,
                        ),
                      ],
                    ),
                    SGText(text: "", style: SettingPage.textStyle, textAlign: TextAlign.center),
                    SGText(text: "Uông Bí,  ${SettingPage.formatted(toolAndMaterialTransferDto.ngayTao ?? '')} ", style: SettingPage.textStyle, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 24 * SettingPage.scale),
        Center(child: SGText(text: "QUYẾT ĐỊNH", style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 14 * SettingPage.scale))),
        Center(child: SGText(text: "Về việc điều động CCDC - Vật tư", style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 14 * SettingPage.scale))),
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 2),
            height: 1,
            width: 120 * SettingPage.scale, // chỉnh độ dài của gạch ngang
            color: Colors.black,
          ),
        ),
        SizedBox(height: 16 * SettingPage.scale),
        Center(child: SGText(text: "GIÁM ĐỐC CÔNG TY THAN UÔNG BÍ - TKV", style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 14 * SettingPage.scale))),
        SizedBox(height: 16 * SettingPage.scale),

        SGText(
          text:
              "\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0Căn cứ vào Quyết định điều động số ${toolAndMaterialTransferDto.soQuyetDinh ?? ''}, ${SettingPage.formatted(toolAndMaterialTransferDto.ngayTao ?? '')} của Giám đốc Công ty V/v Điều động CCDC - Vật tư từ ${toolAndMaterialTransferDto.tenDonViGiao ?? ''}  đến  ${toolAndMaterialTransferDto.tenDonViNhan ?? ''}.\n"
              "\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0Hôm nay, ${SettingPage.formatted(toolAndMaterialTransferDto.ngayTao ?? '')}, tại  ${toolAndMaterialTransferDto.tenDonViNhan ?? ''}.",
          style: SettingPage.textStyle,
        ),
        SGText(text: "Chúng tôi gồm có:", style: SettingPage.textStyle.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 6 * SettingPage.scale),
        Padding(
          padding: EdgeInsets.only(left: 18 * SettingPage.scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SGText(
                text: "1.    Ông (bà): ${toolAndMaterialTransferDto.tenNguoiDeNghi}.....Chức vụ: Nhân viên.....Đại diện: ${toolAndMaterialTransferDto.tenPhongBanXemPhieu ?? ''}.",
              ),
            ],
          ),
        ),
        SizedBox(height: 6 * SettingPage.scale),
        SGText(text: "Tiến hành điều động tài sản tại  ${toolAndMaterialTransferDto.tenDonViNhan} cụ thể như sau:", style: SettingPage.textStyle),
        SizedBox(height: 12 * SettingPage.scale),
        Table(
          border: TableBorder.all(),
          columnWidths: const {0: FixedColumnWidth(40), 1: FlexColumnWidth(2), 2: FlexColumnWidth(2), 3: FlexColumnWidth(1), 4: FlexColumnWidth(1), 5: FlexColumnWidth(1.5)},
          children: [
            TableRow(
              children: [
                tableHeader("STT", SettingPage.scale, SettingPage.textStyle),
                tableHeader("TÊN TÀI SẢN", SettingPage.scale, SettingPage.textStyle),
                tableHeader("Ký, mã hiệu quy cách", SettingPage.scale, SettingPage.textStyle),
                tableHeader("Đơn vị tính", SettingPage.scale, SettingPage.textStyle),
                tableHeader("Số lượng", SettingPage.scale, SettingPage.textStyle),
                tableHeader("Ghi chú", SettingPage.scale, SettingPage.textStyle),
              ],
            ),
            for (int i = 0; i < toolAndMaterialTransferDto.detailToolAndMaterialTransfers!.length; i++)
              TableRow(
                children: [
                  tableCell((i + 1).toString(), SettingPage.scale, SettingPage.textStyle),
                  tableCell(toolAndMaterialTransferDto.detailToolAndMaterialTransfers![i].tenCCDCVatTu ?? '', SettingPage.scale, SettingPage.textStyle),
                  tableCell(toolAndMaterialTransferDto.detailToolAndMaterialTransfers![i].idCCDCVatTu, SettingPage.scale, SettingPage.textStyle),
                  tableCell(toolAndMaterialTransferDto.detailToolAndMaterialTransfers![i].donViTinh ?? '', SettingPage.scale, SettingPage.textStyle),
                  tableCell(toolAndMaterialTransferDto.detailToolAndMaterialTransfers![i].soLuong.toString(), SettingPage.scale, SettingPage.textStyle),
                  tableCell(toolAndMaterialTransferDto.detailToolAndMaterialTransfers![i].ghiChu, SettingPage.scale, SettingPage.textStyle),
                ],
              ),
          ],
        ),

        SizedBox(height: 20 * SettingPage.scale),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 26 * SettingPage.scale),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SGText(text: "Nơi nhận", style: SettingPage.textStyle.copyWith(fontSize: 12 * SettingPage.scale, fontWeight: FontWeight.bold)),
                    SGText(text: "${toolAndMaterialTransferDto.tenDonViNhan}", style: SettingPage.textStyle.copyWith(fontSize: 11 * SettingPage.scale)),
                  ],
                ),
              ),
            ),
            Expanded(child: Center(child: SGText(text: "GIÁM ĐỐC", style: SettingPage.textStyle.copyWith(fontSize: 12 * SettingPage.scale, fontWeight: FontWeight.bold)))),
          ],
        ),
      ],
    );
  }
}
