import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/chatbot/model/chatbot_response.dart';
import 'package:se_gay_components/base_api/sg_api_base.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class ChatbotRepository extends ApiBase {
  static const String _endPoint = "/api/chatbot/query";

  Future<Map<String, dynamic>> sendMessage(String message) async {
    Map<String, dynamic> result = {
      'data': null,
      'status_code': Numeral.STATUS_CODE_DEFAULT,
      'message': '',
    };

    try {
      final response = await post(
        _endPoint,
        data: {'message': message},
      );

      if (response.statusCode != Numeral.STATUS_CODE_SUCCESS) {
        result['status_code'] = response.statusCode;
        result['message'] = 'Lỗi kết nối server';
        return result;
      }

      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final chatbotResponse = ChatbotResponse.fromJson(responseData);

        if (chatbotResponse.success) {
          result['status_code'] = Numeral.STATUS_CODE_SUCCESS;
          result['data'] = chatbotResponse;
          result['message'] = chatbotResponse.message;
        } else {
          result['status_code'] = Numeral.STATUS_CODE_DEFAULT;
          result['message'] = chatbotResponse.message;
        }
      } else {
        result['status_code'] = Numeral.STATUS_CODE_DEFAULT;
        result['message'] = 'Dữ liệu trả về không hợp lệ';
      }
    } catch (e) {
      SGLog.error("ChatbotRepository", "Error at sendMessage: $e");
      result['status_code'] = 500;
      result['message'] = 'Lỗi: $e';
    }

    return result;
  }
}
