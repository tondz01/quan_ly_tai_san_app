import 'package:equatable/equatable.dart';
import 'chat_message.dart';

class ChatbotResponse extends Equatable {
  final bool success;
  final String message;
  final ChatbotResponseData? data;
  final int affectedRows;

  const ChatbotResponse({
    required this.success,
    required this.message,
    this.data,
    required this.affectedRows,
  });

  factory ChatbotResponse.fromJson(Map<String, dynamic> json) {
    return ChatbotResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? ChatbotResponseData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      affectedRows: json['affectedRows'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'affectedRows': affectedRows,
    };
  }

  @override
  List<Object?> get props => [success, message, data, affectedRows];
}
