// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/page/common_contract.dart';
import 'package:quan_ly_tai_san_app/common/page/contract_page.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/main.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/provider/tool_and_material_transfer_provider.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:path/path.dart' as path;

Widget previewDocumentToolAndMaterialTransfer({
  required BuildContext context,
  required ToolAndMaterialTransferDto? item,
  required ToolAndMaterialTransferProvider provider,
  bool isShowKy = true,
}) {
  log('isShowKy: $isShowKy');
  return InkWell(
    onTap: () {
      log('item: $item');
      if (item == null) return;
      previewDocumentToolAndMaterial(
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
              color: ColorValue.link,
            ),
          ),
        ),
        SizedBox(width: 8),
        Icon(Icons.visibility, color: ColorValue.link, size: 18),
      ],
    ),
  );
}

previewDocumentToolAndMaterial({
  required BuildContext context,
  required ToolAndMaterialTransferDto item,
  required ToolAndMaterialTransferProvider provider,
  bool isShowKy = true,
}) {
  UserInfoDTO userInfo = provider.userInfo!;
  log('message UserInfoDTO userInfo: ${userInfo.tenDangNhap}');
  NhanVien nhanVien = provider.getNhanVienByID(userInfo.tenDangNhap);
  String tenFile = path.basename(nhanVien.chuKyNhay.toString());
  String tenFileKyThuong = path.basename(nhanVien.chuKyThuong.toString());
  String urlKyNhay = '${Config.baseUrl}/api/upload/download/$tenFile';
  String urlKyThuong = '${Config.baseUrl}/api/upload/download/$tenFileKyThuong';
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
            contractType: ContractPage.toolAndMaterialTransferPage(item),
            signatureList: [urlKyNhay, urlKyThuong],
            idTaiLieu: item.id.toString(),
            idNguoiKy: userInfo.tenDangNhap,
            tenNguoiKy: userInfo.hoTen,
            isShowKy: isShowKy,
          ),
        ),
  );
}
