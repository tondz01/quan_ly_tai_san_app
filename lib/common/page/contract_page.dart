import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/asset_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class ContractPage {
  static Widget assetHandoverPage(AssetHandoverDto assetHandoverDto) {
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
                    Text(
                      "GIAO NHẬN TÀI SẢN",
                      style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            "Căn cứ vào Quyết định điều động số ${assetHandoverDto.quyetDinhDieuDongSo}, ${assetHandoverDto.ngayBanGiao} của Giám đốc Công ty V/v điều động tài sản từ ${assetHandoverDto.tenDonViGiao}  đến  ${assetHandoverDto.tenDonViNhan}\n"
            "Hôm nay, ${assetHandoverDto.ngayBanGiao}, tại  ${assetHandoverDto.tenDonViGiao}\n",
            style: GoogleFonts.robotoSerif(height: 1.6),
          ),
          Text("Chúng tôi gồm có:", style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("1. Ông (bà):\t\t${assetHandoverDto.tenLanhDao ?? ''}\t\tChức vụ: Nhân viên\t\tĐại diện: Phòng CV"),
              Text(
                "2. Ông (bà):\t\t${assetHandoverDto.tenDaiDienBenGiao ?? ''}\t\tChức vụ: Trưởng phòng\t\tĐại diện: Kho Công ty (Bên giao)",
              ),
              Text(
                "3. Ông (bà):\t\t${assetHandoverDto.tenDaiDienBenNhan ?? ''}\t\tChức vụ: Phó quản đốc\t\tĐại diện: Phân xưởng khai thác đào lò 1 (Bên nhận)",
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text("Tiến hành giao nhận tài sản tại  ${assetHandoverDto.tenDonViNhan ?? ''} cụ thể như sau:"),
          const SizedBox(height: 8),

          Table(
            border: TableBorder.all(),
            columnWidths: const {
              0: FixedColumnWidth(50),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(1.5),
              4: FlexColumnWidth(1),
              5: FlexColumnWidth(1),
              6: FlexColumnWidth(1.5),
            },
            children: [
              TableRow(
                decoration: const BoxDecoration(color: Color(0xFFE0E0E0)),
                children: [
                  _tableHeader("STT"),
                  _tableHeader("TÊN TÀI SẢN"),
                  _tableHeader("Ký, mã hiệu quy cách"),
                  _tableHeader("Nước sản xuất"),
                  _tableHeader("Đơn vị tính"),
                  _tableHeader("Số lượng"),
                  _tableHeader("Tình trạng kỹ thuật"),
                ],
              ),
              // Dữ liệu chi tiết chưa được cung cấp trong AssetHandoverDto
              TableRow(
                children: [
                  _tableCell(""),
                  _tableCell(""),
                  _tableCell(""),
                  _tableCell(""),
                  _tableCell(""),
                  _tableCell(""),
                  _tableCell(""),
                ],
              ),
            ],
          ),

          const SizedBox(height: 48),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Đại diện bên giao"),
              Text("Đại diện bên nhận"),
              Text("Phòng Phòng CV"),
              Text("Đại diện Phòng KT"),
              Text("KT. Giám đốc"),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  static Widget assetMovePage(AssetTransferDto assetTransferDto) {
    int type = assetTransferDto.type ?? 0;
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
                    Text(
                      typeAssetTransfer.toUpperCase(),
                      style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            "Căn cứ vào Quyết định điều động số ${assetTransferDto.decisionNumber}, ${assetTransferDto.decisionDate} của Giám đốc Công ty V/v $typeAssetTransfer từ ${assetTransferDto.deliveringUnit}  đến  ${assetTransferDto.receivingUnit}\n"
            "Hôm nay, ${assetTransferDto.decisionDate}, tại  ${assetTransferDto.receivingUnit}\n",
            style: GoogleFonts.robotoSerif(height: 1.6),
          ),
          Text("Chúng tôi gồm có:", style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "1. Ông (bà):\t\t${assetTransferDto.requester!}\t\tChức vụ: Nhân viên\t\tĐại diện: ${assetTransferDto.proposingUnit}",
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text("Tiến hành điều động tài sản tại  ${assetTransferDto.receivingUnit} cụ thể như sau:"),
          const SizedBox(height: 8),

          Table(
            border: TableBorder.all(),
            columnWidths: const {
              0: FixedColumnWidth(50),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
              5: FlexColumnWidth(1.5),
            },
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
              for (int i = 0; i < assetTransferDto.movementDetails!.length; i++)
                TableRow(
                  children: [
                    _tableCell((i + 1).toString()),
                    _tableCell(assetTransferDto.movementDetails![i].name ?? ""),
                    _tableCell(assetTransferDto.movementDetails![i].assetId ?? ""),
                    _tableCell(assetTransferDto.movementDetails![i].measurementUnit ?? ""),
                    _tableCell(assetTransferDto.movementDetails![i].quantity ?? ""),
                    _tableCell(assetTransferDto.movementDetails![i].setCondition ?? ""),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 48),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Đại diện bên giao"),
              Text("Đại diện bên nhận"),
              Text("Phòng Phòng CV"),
              Text("Đại diện Phòng KT"),
              Text("KT. Giám đốc"),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  static Widget toolAndMaterialTransferPage(ToolAndMaterialTransferDto _toolAndMaterialTransferDto) {
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
                    Text(
                      'ĐIỀU ĐỘNG CÔNG CỤ DỤNG CỤ - VẬT TƯ',
                      style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            "Căn cứ vào Quyết định điều động số ${_toolAndMaterialTransferDto.decisionNumber}, ${_toolAndMaterialTransferDto.decisionDate} của Giám đốc Công ty V/v Điều động CCDC - Vật tư từ ${_toolAndMaterialTransferDto.deliveringUnit}  đến  ${_toolAndMaterialTransferDto.receivingUnit}\n"
            "Hôm nay, ${_toolAndMaterialTransferDto.decisionDate}, tại  ${_toolAndMaterialTransferDto.receivingUnit}\n",
            style: GoogleFonts.robotoSerif(height: 1.6),
          ),
          Text("Chúng tôi gồm có:", style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "1. Ông (bà):\t\t${_toolAndMaterialTransferDto.requester!}\t\tChức vụ: Nhân viên\t\tĐại diện: ${_toolAndMaterialTransferDto.proposingUnit}",
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text("Tiến hành điều động tài sản tại  ${_toolAndMaterialTransferDto.receivingUnit} cụ thể như sau:"),
          const SizedBox(height: 8),

          Table(
            border: TableBorder.all(),
            columnWidths: const {
              0: FixedColumnWidth(50),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
              5: FlexColumnWidth(1.5),
            },
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
              for (int i = 0; i < _toolAndMaterialTransferDto.movementDetails!.length; i++)
                TableRow(
                  children: [
                    _tableCell((i + 1).toString()),
                    _tableCell(_toolAndMaterialTransferDto.movementDetails![i].name ?? ""),
                    _tableCell(_toolAndMaterialTransferDto.movementDetails![i].assetId ?? ""),
                    _tableCell(_toolAndMaterialTransferDto.movementDetails![i].measurementUnit ?? ""),
                    _tableCell(_toolAndMaterialTransferDto.movementDetails![i].quantity ?? ""),
                    _tableCell(_toolAndMaterialTransferDto.movementDetails![i].setCondition ?? ""),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 48),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Đại diện bên giao"),
              Text("Đại diện bên nhận"),
              Text("Phòng Phòng CV"),
              Text("Đại diện Phòng KT"),
              Text("KT. Giám đốc"),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  static Widget _tableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Text(text, textAlign: TextAlign.center, style: GoogleFonts.robotoSerif(fontWeight: FontWeight.bold)),
    );
  }

  static Widget _tableCell(String text) {
    return Padding(padding: const EdgeInsets.all(6), child: Text(text, style: GoogleFonts.robotoSerif()));
  }
}
