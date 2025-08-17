import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

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
    final DateFormat inputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ");
    DateTime date = inputFormat.parse(assetHandoverDto.ngayBanGiao?.trim() ?? '');
    String formatted = DateFormat("'ngày' dd 'tháng' MM 'năm' yyyy", 'vi').format(date);
    double scale = 1.4;
    TextStyle textStyle = TextStyle(fontFamily: "Times New Roman", fontWeight: FontWeight.w500, fontSize: 13 * scale, height: 1.5);
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
                    SGText(text: "TẬP ĐOÀN CÔNG NGHIỆP\nTHAN - KHOÁNG SẢN VIỆT NAM", style: textStyle, textAlign: TextAlign.center),
                    SGText(text: "CÔNG TY THAN UÔNG BÍ - TKV", style: textStyle.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            Expanded(child: SGText(text: "BIÊN BẢN\nGIAO NHẬN TÀI SẢN", style: textStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 14 * scale), textAlign: TextAlign.center)),
          ],
        ),

        SizedBox(height: 24 * scale),

        SGText(
          text:
              "\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0Căn cứ vào Quyết định điều động số ${assetHandoverDto.quyetDinhDieuDongSo}/QĐ-TUB, $formatted của Giám đốc Công ty V/v điều động tài sản từ ${assetHandoverDto.tenDonViGiao}  đến  ${assetHandoverDto.tenDonViNhan}.\n"
              "\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0Hôm nay, $formatted , tại ${assetHandoverDto.tenDonViGiao}.",
          style: textStyle,
        ),
        SGText(text: "Chúng tôi gồm có:", style: textStyle.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.start),
        SizedBox(height: 2 * scale),
        Padding(
          padding: EdgeInsets.only(left: 18 * scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SGText(text: "1.    Ông (bà): ${assetHandoverDto.tenLanhDao ?? ''}.....Chức vụ: Nhân viên.....Đại diện: Phòng CV", style: textStyle),
              SGText(text: "2.    Ông (bà): ${assetHandoverDto.tenDaiDienBenGiao ?? ''}.....Chức vụ: Trưởng phòng.....Đại diện: Kho Công ty (Bên giao)", style: textStyle),
              SGText(
                text: "3.    Ông (bà): ${assetHandoverDto.tenDaiDienBenNhan ?? ''}.....Chức vụ: Phó quản đốc.....Đại diện: Phân xưởng khai thác đào lò 1 (Bên nhận).",
                style: textStyle,
              ),
            ],
          ),
        ),
        SizedBox(height: 2 * scale),
        SGText(text: "Tiến hành giao nhận tài sản từ: ${assetHandoverDto.tenDonViGiao ?? ''} giao cho ${assetHandoverDto.tenDonViNhan ?? ''} cụ thể như sau:", style: textStyle),
        SizedBox(height: 4 * scale),
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
                tableHeader("STT", scale, textStyle),
                tableHeader("TÊN TÀI SẢN", scale, textStyle),
                tableHeader("Ký, mã hiệu quy cách", scale, textStyle),
                tableHeader("Đơn vị tính", scale, textStyle),
                tableHeader("Số lượng", scale, textStyle),
                tableHeader("Tình trạng kỹ thuật", scale, textStyle),
                tableHeader("Ghi chú", scale, textStyle),
              ],
            ),

            // Dữ liệu chi tiết chưa được cung cấp trong AssetHandoverDto
            for (int i = 0; i < (listDetailAssetMobilization?.length ?? 0); i++)
              TableRow(
                children: [
                  tableCell((i + 1).toString(), scale, textStyle),
                  tableCell(listDetailAssetMobilization![i].tenTaiSan, scale, textStyle),
                  tableCell(listDetailAssetMobilization[i].idTaiSan, scale, textStyle),
                  tableCell(listDetailAssetMobilization[i].donViTinh, scale, textStyle),
                  tableCell(listDetailAssetMobilization[i].soLuong.toString(), scale, textStyle),
                  tableCell(listDetailAssetMobilization[i].hienTrang.toString(), scale, textStyle),
                  tableCell(listDetailAssetMobilization[i].ghiChu, scale, textStyle),
                ],
              ),
          ],
        ),
        SizedBox(height: 20 * scale),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SGText(text: "Đại diện bên giao", style: textStyle.copyWith(fontSize: 12 * scale, fontWeight: FontWeight.bold)),
                SGText(text: "(Ký, họ tên)", style: textStyle.copyWith(fontSize: 11 * scale)),
              ],
            ),
            Column(
              children: [
                SGText(text: "Đại diện bên nhận", style: textStyle.copyWith(fontSize: 12 * scale, fontWeight: FontWeight.bold)),
                SGText(text: "(Ký, họ tên)", style: textStyle.copyWith(fontSize: 11 * scale)),
              ],
            ),
            Column(
              children: [
                SGText(text: "Phòng Phòng CV", style: textStyle.copyWith(fontSize: 12 * scale, fontWeight: FontWeight.bold)),
                SGText(text: "(Ký, họ tên)", style: textStyle.copyWith(fontSize: 11 * scale)),
              ],
            ),
            Column(
              children: [
                SGText(text: "Đại diện Phòng KT", style: textStyle.copyWith(fontSize: 12 * scale, fontWeight: FontWeight.bold)),
                SGText(text: "(Ký, họ tên)", style: textStyle.copyWith(fontSize: 11 * scale)),
              ],
            ),
            Column(
              children: [
                SGText(text: "KT. Giám đốc", style: textStyle.copyWith(fontSize: 12 * scale, fontWeight: FontWeight.bold)),
                SGText(text: "(Ký, họ tên)", style: textStyle.copyWith(fontSize: 11 * scale)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static Widget assetMovePage(DieuDongTaiSanDto dieuDongTaiSanDto) {
    int type = dieuDongTaiSanDto.loai ?? 0;
    SGLog.info("Contract", "Type: $type");

    final String typeAssetTransfer =
        type == 1
            ? 'Cấp phát tài sản'
            : type == 2
            ? 'Điều động tài sản'
            : 'Thu hồi tài sản';

    return DefaultTextStyle(
      style: GoogleFonts.robotoSerif(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Column(
                  children: [
                    Text("TẬP ĐOÀN CÔNG NGHIỆP", style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold)),
                    Text("THAN - KHOÁNG SẢN VIỆT NAM", style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold)),
                    Text("CÔNG TY THAN UÔNG BÍ - TKV", style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Text("BIÊN BẢN", style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold, fontSize: 20)),
                    Text(typeAssetTransfer.toUpperCase(), style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold, fontSize: 20)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            "Căn cứ vào Quyết định điều động số ${dieuDongTaiSanDto.soQuyetDinh}, ${dieuDongTaiSanDto.ngayCapNhat} của Giám đốc Công ty V/v $typeAssetTransfer từ ${dieuDongTaiSanDto.tenDonViGiao}  đến  ${dieuDongTaiSanDto.tenDonViNhan}\n"
            "Hôm nay, ${dieuDongTaiSanDto.ngayCapNhat}, tại  ${dieuDongTaiSanDto.tenDonViNhan}\n",
            style: GoogleFonts.robotoSerif(height: 1.6),
          ),
          Text("Chúng tôi gồm có:", style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text("1. Ông (bà):\t\t${dieuDongTaiSanDto.tenNguoiDeNghi!}\t\tChức vụ: Nhân viên\t\tĐại diện: ${dieuDongTaiSanDto.tenPhongBanXemPhieu}")],
          ),
          const SizedBox(height: 16),

          Text("Tiến hành điều động tài sản tại  ${dieuDongTaiSanDto.tenDonViNhan} cụ thể như sau:"),
          const SizedBox(height: 8),

          Table(
            border: TableBorder.all(),
            columnWidths: const {0: FixedColumnWidth(50), 1: FlexColumnWidth(2), 2: FlexColumnWidth(2), 3: FlexColumnWidth(1), 4: FlexColumnWidth(1), 5: FlexColumnWidth(1.5)},
            children: [
              TableRow(
                decoration: const BoxDecoration(color: Color(0xFFE0E0E0)),
                children: [
                  _tableHeader("STT"),
                  _tableHeader("TÊN TÀI SẢN"),
                  _tableHeader("Ký, mã hiệu quy cách"),
                  _tableHeader("Đơn vị tính"),
                  _tableHeader("Số lượng"),
                  _tableHeader("Tình trạng kỹ thuật"),
                ],
              ),
              for (int i = 0; i < dieuDongTaiSanDto.chiTietDieuDongTaiSans!.length; i++)
                TableRow(
                  children: [
                    _tableCell((i + 1).toString()),
                    _tableCell(dieuDongTaiSanDto.chiTietDieuDongTaiSans![i].tenTaiSan),
                    _tableCell(dieuDongTaiSanDto.chiTietDieuDongTaiSans![i].idTaiSan),
                    _tableCell(dieuDongTaiSanDto.chiTietDieuDongTaiSans![i].donViTinh),
                    _tableCell(dieuDongTaiSanDto.chiTietDieuDongTaiSans![i].soLuong.toString()),
                    _tableCell(dieuDongTaiSanDto.chiTietDieuDongTaiSans![i].ghiChu),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 48),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Đại diện bên giao"), Text("Đại diện bên nhận"), Text("Phòng Phòng CV"), Text("Đại diện Phòng KT"), Text("KT. Giám đốc")],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  static Widget toolAndMaterialTransferPage(ToolAndMaterialTransferDto toolAndMaterialTransferDto) {
    return DefaultTextStyle(
      style: GoogleFonts.robotoSerif(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Column(
                  children: [
                    Text("TẬP ĐOÀN CÔNG NGHIỆP", style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold)),
                    Text("THAN - KHOÁNG SẢN VIỆT NAM", style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold)),
                    Text("CÔNG TY THAN UÔNG BÍ - TKV", style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Text("BIÊN BẢN", style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold, fontSize: 20)),
                    Text('ĐIỀU ĐỘNG CÔNG CỤ DỤNG CỤ - VẬT TƯ', style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold, fontSize: 20)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            "Căn cứ vào Quyết định điều động số ${toolAndMaterialTransferDto.soQuyetDinh}, ${toolAndMaterialTransferDto.ngayCapNhat} của Giám đốc Công ty V/v Điều động CCDC - Vật tư từ ${toolAndMaterialTransferDto.tenDonViGiao}  đến  ${toolAndMaterialTransferDto.tenDonViNhan}\n"
            "Hôm nay, ${toolAndMaterialTransferDto.ngayCapNhat}, tại  ${toolAndMaterialTransferDto.tenDonViNhan}\n",
            style: GoogleFonts.robotoSerif(height: 1.6),
          ),
          Text("Chúng tôi gồm có:", style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "1. Ông (bà):\t\t${toolAndMaterialTransferDto.tenNguoiDeNghi!}\t\tChức vụ: Nhân viên\t\tĐại diện: ${toolAndMaterialTransferDto.tenPhongBanXemPhieu}",
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text("Tiến hành điều động tài sản tại  ${toolAndMaterialTransferDto.tenDonViNhan} cụ thể như sau:"),
          const SizedBox(height: 8),

          Table(
            border: TableBorder.all(),
            columnWidths: const {0: FixedColumnWidth(50), 1: FlexColumnWidth(2), 2: FlexColumnWidth(2), 3: FlexColumnWidth(1), 4: FlexColumnWidth(1), 5: FlexColumnWidth(1.5)},
            children: [
              TableRow(
                decoration: const BoxDecoration(color: Color(0xFFE0E0E0)),
                children: [
                  _tableHeader("STT"),
                  _tableHeader("TÊN TÀI SẢN"),
                  _tableHeader("Ký, mã hiệu quy cách"),
                  _tableHeader("Đơn vị tính"),
                  _tableHeader("Số lượng"),
                  _tableHeader("Tình trạng kỹ thuật"),
                ],
              ),
              for (int i = 0; i < toolAndMaterialTransferDto.detailToolAndMaterialTransfers!.length; i++)
                TableRow(
                  children: [
                    _tableCell((i + 1).toString()),
                    _tableCell(toolAndMaterialTransferDto.detailToolAndMaterialTransfers![i].tenCCDCVatTu ?? ''),
                    _tableCell(toolAndMaterialTransferDto.detailToolAndMaterialTransfers![i].idCCDCVatTu),
                    _tableCell(toolAndMaterialTransferDto.detailToolAndMaterialTransfers![i].donViTinh ?? ''),
                    _tableCell(toolAndMaterialTransferDto.detailToolAndMaterialTransfers![i].soLuong.toString()),
                    _tableCell(toolAndMaterialTransferDto.detailToolAndMaterialTransfers![i].ghiChu),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 48),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Đại diện bên giao"), Text("Đại diện bên nhận"), Text("Phòng Phòng CV"), Text("Đại diện Phòng KT"), Text("KT. Giám đốc")],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  static Widget _tableHeader(String text) {
    return Padding(padding: const EdgeInsets.all(6), child: Text(text, textAlign: TextAlign.center, style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold)));
  }

  static Widget _tableCell(String text) {
    return Padding(padding: const EdgeInsets.all(6), child: Text(text, style: GoogleFonts.robotoSerif()));
  }
}
