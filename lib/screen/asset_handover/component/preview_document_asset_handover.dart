// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/page/common_contract.dart';
import 'package:quan_ly_tai_san_app/common/page/contract_page.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/main.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/asset_handover_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/chi_tiet_dieu_dong_tai_san.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:path/path.dart' as path;

Widget previewDocumentAssetHandover({
  required BuildContext context,
  required AssetHandoverDto? item,
  required AssetHandoverProvider provider,
  required List<ChiTietDieuDongTaiSan> itemsDetail,
  bool isShowKy = true,
  bool isDisabled = false,
}) {
  return InkWell(
    onTap: () {
      if (item == null) return;
      previewDocumentHandover(
        context: context,
        item: item,
        provider: provider,
        isShowKy: isShowKy,
        itemsDetail: itemsDetail,
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
        Icon(Icons.visibility, color:  isDisabled ? Colors.grey : ColorValue.link, size: 18),
      ],
    ),
  );
}

previewDocumentHandover({
  required BuildContext context,
  required AssetHandoverDto item,
  required List<ChiTietDieuDongTaiSan> itemsDetail,
  required AssetHandoverProvider provider,
  bool isShowKy = true,
}) {
  UserInfoDTO userInfo = AccountHelper.instance.getUserInfo()!;
  log('message UserInfoDTO userInfo: ${userInfo.tenDangNhap}');
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
            contractPages: [ContractPage.assetHandoverPage(item, itemsDetail)],
            signatureList: [urlChuKyNhay, urlChuKyThuong],
            idTaiLieu: item.id.toString(),
            idNguoiKy: userInfo.tenDangNhap,
            tenNguoiKy: userInfo.hoTen,
            isShowKy: isShowKy,
            isKyNhay: nhanVien.kyNhay ?? false,
            isKyThuong: nhanVien.kyThuong ?? false,
            isKySo: nhanVien.kySo ?? false,
            eventSignature: () {
              final assetHandoverBloc = BlocProvider.of<AssetHandoverBloc>(
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
