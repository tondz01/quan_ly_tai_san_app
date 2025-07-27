// ignore_for_file: constant_identifier_names

class Numeral {
  static const int STATUS_CODE_DEFAULT = 0;
  static const int STATUS_CODE_SUCCESS = 200;
  static const int STATUS_CODE_DELETE = 400;
  static const int STATUS_CODE_SUCCESS_CREATE = 201;
  static const int STATUS_CODE_SUCCESS_NO_CONTENT = 204;
  static const int INTERNAL_SERVER_ERROR_EXCEPTION_CODE =
      500; // InternalServerErrorException
  static const int STATUS_CODE_450 = 450;
  static const int STATUS_CODE_453 = 453;
  static const int STATUS_CODE_452 = 452;
  static const int CONFLICT_EXCEPTION_CODE = 409; // ConflictException
  static const int STATUS_CODE_405 = 405;
  static const int NOTFOUND_EXCEPTION_CODE = 404; // NotFoundException
  static const int UNAUTHORIZED_EXCEPTION_CODE =
      401; // DioExceptionType.badResponse UnauthorizedException
  static const int BAD_REQUEST_EXCEPTION_CODE =
      400; // DioExceptionType.badResponse BadRequestException
  static const int UNKNOWN_TYPE_EXCEPTION_CODE =
      499; // DioExceptionType.unknown
  static const int CANCEL_EXCEPTION_CODE = 498; // DioExceptionType.cancel
  static const int BAD_CERTIFICATE_EXCEPTION_CODE =
      497; // DioExceptionType.badCertificate
  static const int NO_INTERNET_CONNECTION_EXCEPTION_CODE =
      496; // NoInternetConnectionException
  // case STATUS_CODE_495 for below DioExceptionType
  // case DioExceptionType.connectionTimeout:
  // case DioExceptionType.connectionError:
  // case DioExceptionType.sendTimeout:
  // case DioExceptionType.receiveTimeout:
  static const int STATUS_CODE_495 = 495;
  static const int STATUS_CODE_454 = 454;
  static const int UNKNOW_EXCEPTION_CODE =
      490; // Other Exception (not in DioExceptionType)
  static const int STATUS_CODE_UNPROCESSABLE_CONTENT = 422;
  static const int STATUS_CODE_403 = 403;
  static const double MARGIN = 20;
  static const int LIMIT_PAGE = 20;
  static const int ASC = 1;
  static const int DESC = 0;
  static const int ORDER_TYPE_DEFAULT = DESC;
  static const int MIN_1 = 1;
  static const int MIN_0 = 0;
  static const int MAX_100 = 100;
  static const int MAX_99999 = 99999;
  static const int MAX_9999 = 9999;
  static const int MAX_999 = 999;
  static const double MIN_DOUBLE_00 = 00.00;
  static const double MIN_DOUBLE_01 = 00.01;
  static const double MAX_DOUBLE_99 = 99.99;
}