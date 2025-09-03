import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';

checkStatusCodeDone(Map<String, dynamic> result) {
  if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS ||
      result['status_code'] == Numeral.STATUS_CODE_SUCCESS_CREATE ||
      result['status_code'] == Numeral.STATUS_CODE_SUCCESS_NO_CONTENT) {
    return true;
  }
  return false;
}

checkStatusCodeFailed(int statusCode) {
  if (statusCode != Numeral.STATUS_CODE_SUCCESS &&
      statusCode != Numeral.STATUS_CODE_SUCCESS_CREATE &&
      statusCode != Numeral.STATUS_CODE_SUCCESS_NO_CONTENT) {
    return true;
  }
  return false;
}
