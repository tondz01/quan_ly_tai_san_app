import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/reponsitory/config_reponsitory.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';

void updateConfigTimeExpire(BuildContext context, int timeExpire) async {
  final result = await ConfigReponsitory().updateConfigTimeExpire(timeExpire);
  if (!context.mounted) return;
  if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS ||
      result['status_code'] == Numeral.STATUS_CODE_SUCCESS_CREATE) {
    AccountHelper.instance.setConfigTimeExpire(timeExpire);
    AppUtility.showSnackBar(context, 'Cập nhật thời gian thành công');
  } else {
    AppUtility.showSnackBar(
      context,
      'Cập nhật thời gian thất bại ${result['message']}',
      isError: true,
    );
  }
}

void fetchConfigTimeExpire(BuildContext context, int value) async {
  final result = await ConfigReponsitory().setConfigTimeExpire(value);
  if (!context.mounted) return;
  if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS ||
      result['status_code'] == Numeral.STATUS_CODE_SUCCESS_CREATE) {
    AccountHelper.instance.setConfigTimeExpire(value);
    AppUtility.showSnackBar(context, "Thiết lập thời gian hết hạn thành công");
  } else {
    AppUtility.showSnackBar(
      context,
      "Thiết lập thời gian hết hạn thất bại: ${result['message']}",
    );
  }
}
