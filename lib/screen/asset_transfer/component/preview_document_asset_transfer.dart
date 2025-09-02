// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdfrx/pdfrx.dart' as pdfrx;
import 'package:quan_ly_tai_san_app/common/page/common_contract.dart';
import 'package:quan_ly_tai_san_app/common/page/contract_page.dart';
import 'package:quan_ly_tai_san_app/common/widgets/a4_canvas.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/main.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/dieu_dong_tai_san_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/dieu_dong_tai_san_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/dieu_dong_tai_san_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/dieu_dong_tai_san_provider.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:path/path.dart' as path;

Widget previewDocumentAssetTransfer({
  required BuildContext context,
  required DieuDongTaiSanDto? item,
  required DieuDongTaiSanProvider provider,
  Function? callBack,
  bool isShowKy = true,
  bool isDisabled = false,
  pdfrx.PdfDocument? document,
}) {
  return InkWell(
    onTap: () {
      if (isDisabled) return;
      log('item: ${jsonEncode(item)}');
      callBack?.call();
      if (item == null) return;
      previewDocument(
        context: context,
        item: item,
        provider: provider,
        isShowKy: isShowKy,
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

previewDocument({
  required BuildContext context,
  required DieuDongTaiSanDto item,
  required DieuDongTaiSanProvider provider,
  bool isShowKy = true,
  pdfrx.PdfDocument? document,
}) {
  UserInfoDTO userInfo = provider.userInfo!;
  NhanVien nhanVien = provider.getNhanVienByID(userInfo.tenDangNhap);
  String tenFile = path.basename(nhanVien.chuKyNhay.toString());
  String tenFileThuong = path.basename(nhanVien.chuKyThuong.toString());
  String urlNhay = '${Config.baseUrl}/api/upload/download/$tenFile';
  String urlThuong = '${Config.baseUrl}/api/upload/download/$tenFileThuong';

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
                  pdfrx.PdfPageView(
                    document: document,
                    pageNumber: index + 1,
                    alignment: Alignment.center,
                  ),
              A4Canvas(
                marginsMm: const EdgeInsets.all(20),
                scale: 1.2,
                maxWidth: 800,
                maxHeight: 800 * (297 / 210),
                child: ContractPage.assetMovePage(item),
              ),
            ],
            signatureList: [urlNhay, urlThuong],
            idTaiLieu: item.id.toString(),
            idNguoiKy: userInfo.tenDangNhap,
            tenNguoiKy: userInfo.hoTen,
            isShowKy: isShowKy,
            isKyNhay: nhanVien.kyNhay ?? false,
            isKyThuong: nhanVien.kyThuong ?? false,
            isKySo: nhanVien.kySo ?? false,
            eventSignature: () {
              final assetHandoverBloc = BlocProvider.of<DieuDongTaiSanBloc>(
                context,
              );
              assetHandoverBloc.add(
                UpdateSigningStatusEvent(
                  context,
                  item.id.toString(),
                  userInfo.tenDangNhap,
                ),
              );
            },
          ),
        ),
  );
}

previewDocumentView({
  required BuildContext context,
  required DieuDongTaiSanDto item,
  required UserInfoDTO userInfo,
  required NhanVien nhanVien,
  bool isShowKy = true,
  pdfrx.PdfDocument? document,
}) {
  String tenFile = path.basename(nhanVien.chuKyNhay.toString());
  String tenFileThuong = path.basename(nhanVien.chuKyThuong.toString());
  String urlNhay = '${Config.baseUrl}/api/upload/download/$tenFile';
  String urlThuong = '${Config.baseUrl}/api/upload/download/$tenFileThuong';

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
                  pdfrx.PdfPageView(
                    document: document,
                    pageNumber: index + 1,
                    alignment: Alignment.center,
                  ),
              A4Canvas(
                marginsMm: const EdgeInsets.all(20),
                scale: 1.2,
                maxWidth: 800,
                maxHeight: 800 * (297 / 210),
                child: ContractPage.assetMovePage(item),
              ),
            ],
            signatureList: [urlNhay, urlThuong],
            idTaiLieu: item.id.toString(),
            idNguoiKy: userInfo.tenDangNhap,
            tenNguoiKy: userInfo.hoTen,
            isShowKy: isShowKy,
            isKyNhay: nhanVien.kyNhay ?? false,
            isKyThuong: nhanVien.kyThuong ?? false,
            isKySo: nhanVien.kySo ?? false,
            eventSignature: () {
              final assetHandoverBloc = BlocProvider.of<DieuDongTaiSanBloc>(
                context,
              );
              assetHandoverBloc.add(
                UpdateSigningStatusEvent(
                  context,
                  item.id.toString(),
                  userInfo.tenDangNhap,
                ),
              );
            },
          ),
        ),
  );
}
