// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/page/common_contract.dart';
import 'package:quan_ly_tai_san_app/common/page/contract_page.dart';
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
}) {
  log('isShowKy: $isShowKy');
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
        Icon(Icons.visibility, color: ColorValue.link, size: 18),
      ],
    ),
  );
}

previewDocument({
  required BuildContext context,
  required DieuDongTaiSanDto item,
  required DieuDongTaiSanProvider provider,
  bool isShowKy = true,
}) {
  UserInfoDTO userInfo = provider.userInfo!;
  log('message UserInfoDTO userInfo: ${userInfo.tenDangNhap}');
  NhanVien nhanVien = provider.getNhanVienByID(userInfo.tenDangNhap);
  String tenFile = path.basename(nhanVien.chuKyNhay.toString());
  log('nhanVien.chuKy: ${nhanVien.chuKyNhay}');
  String url = '${Config.baseUrl}/api/upload/download/$tenFile';
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
            contractType: ContractPage.assetMovePage(item),
            signatureList: [url],
            idTaiLieu: item.id.toString(),
            idNguoiKy: userInfo.tenDangNhap,
            tenNguoiKy: userInfo.hoTen,
            isShowKy: isShowKy,
            eventSignature: () {
              final assetHandoverBloc = BlocProvider.of<DieuDongTaiSanBloc>(
                context,
              );
              assetHandoverBloc.add(
                UpdateSigningStatusEvent(context, item.id.toString()),
              );
            },
          ),
        ),
  );
}
