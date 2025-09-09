// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdfrx/pdfrx.dart' show PdfDocument, PdfPageView;
import 'package:quan_ly_tai_san_app/common/page/common_contract.dart';
import 'package:quan_ly_tai_san_app/common/page/contract_page.dart';
import 'package:quan_ly_tai_san_app/common/widgets/a4_canvas.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/main.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/bloc/tool_and_supplies_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/bloc/tool_and_supplies_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/tool_and_supplies_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/provider/tool_and_supplies_handover_provider.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:path/path.dart' as path;

Widget previewDocumentCcdcHandover({
  required BuildContext context,
  required ToolAndMaterialTransferDto? item,
  required ToolAndSuppliesHandoverDto? dieuDongCcdc,
  required ToolAndSuppliesHandoverProvider provider,
  bool isShowKy = true,
  bool isDisabled = false,
  PdfDocument? document,
}) {
  return InkWell(
    onTap: () {
      if (item == null) return;
      prevDocumentCcdcHandover(
        context: context,
        item: item,
        provider: provider,
        isShowKy: isShowKy,
        dieuDongCcdc: dieuDongCcdc,
        document: document,
      );
    },
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 2.5),
          child: SGText(
            text: "Xem trước tài liệu",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDisabled ? Colors.grey : ColorValue.link,
            ),
          ),
        ),
        SizedBox(width: 8),
        Icon(
          Icons.visibility,
          color: isDisabled ? Colors.grey : ColorValue.link,
          size: 18,
        ),
      ],
    ),
  );
}

prevDocumentCcdcHandover({
  required BuildContext context,
  required ToolAndMaterialTransferDto item,
  required ToolAndSuppliesHandoverDto? dieuDongCcdc,
  required ToolAndSuppliesHandoverProvider provider,
  bool isShowKy = true,
  PdfDocument? document,
}) {
  UserInfoDTO userInfo = AccountHelper.instance.getUserInfo()!;
  NhanVien nhanVien = provider.getNhanVien(idNhanVien: userInfo.tenDangNhap);
  String tenFileChuKyNhay = path.basename(nhanVien.chuKyNhay.toString());
  String tenFileChuKyThuong = path.basename(nhanVien.chuKyThuong.toString());
  String urlChuKyNhay =
      '${Config.baseUrl}/api/upload/download/$tenFileChuKyNhay';
  String urlChuKyThuong =
      '${Config.baseUrl}/api/upload/download/$tenFileChuKyThuong';
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder:
        (context) => Padding(
          padding: const EdgeInsets.only(
            left: 24.0,
            right: 24.0,
            top: 16.0,
            bottom: 16.0,
          ),
          child: CommonContract(
            contractPages: [
              if (document != null)
                for (var index = 0; index < document.pages.length; index++)
                  PdfPageView(
                    document: document,
                    pageNumber: index + 1,
                    alignment: Alignment.center,
                  ),
              A4Canvas(
                marginsMm: const EdgeInsets.all(20),
                scale: 1.2,
                maxWidth: 800,
                maxHeight: 800 * (297 / 210),
                child: ContractPage.toolAndMaterialTransferPage(item),
              ),
            ],
            signatureList: [urlChuKyNhay, urlChuKyThuong],
            idTaiLieu: item.id.toString(),
            idNguoiKy: userInfo.tenDangNhap,
            tenNguoiKy: userInfo.hoTen,
            isShowKy: isShowKy,
            isKyNhay: nhanVien.kyNhay ?? false,
            isKyThuong: nhanVien.kyThuong ?? false,
            isKySo: nhanVien.kySo ?? false,
            eventSignature: () {
              final bloc = BlocProvider.of<ToolAndSuppliesHandoverBloc>(
                context,
              );
              //           private String id;
              // private String idCCDCVT;
              // private String idDonViSoHuu;
              // private int soLuong;
              // private String thoiGianBanGiao;
              // private String ngayTao;
              // private String nguoiTao;
              // private String idTsCon;
              List<Map<String, dynamic>> request =
                  item.detailToolAndMaterialTransfers
                      ?.map(
                        (e) => {
                          'id': e.id,
                          'idCCDCVT': e.idCCDCVatTu,
                          'idDonViSoHuu': item.idDonViNhan,
                          'soLuong': e.soLuongXuat,
                          'thoiGianBanGiao': item.ngayTao,
                          'ngayTao': item.ngayTao,
                          'nguoiTao': userInfo.tenDangNhap,
                          'idTsCon': e.idChiTietCCDCVatTu,
                        },
                      )
                      .toList() ??
                  [];
              log('request check: $request');
              bloc.add(
                UpdateSigningStatusCcdcEvent(
                  context,
                  dieuDongCcdc?.id.toString() ?? '',
                  userInfo.tenDangNhap,
                  request,
                ),
              );
            },
          ),
        ),
  );
}
