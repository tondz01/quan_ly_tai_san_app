import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final ChatbotResponseData? responseData;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.responseData,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      content: json['content'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      responseData: json['responseData'] != null
          ? ChatbotResponseData.fromJson(
              json['responseData'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'responseData': responseData?.toJson(),
    };
  }

  ChatMessage copyWith({
    String? id,
    String? content,
    bool? isUser,
    DateTime? timestamp,
    ChatbotResponseData? responseData,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      responseData: responseData ?? this.responseData,
    );
  }

  @override
  List<Object?> get props => [id, content, isUser, timestamp, responseData];
}

class ChatbotResponseData extends Equatable {
  final String sqlQuery;
  final List<Map<String, dynamic>> data;
  final String explanation;

  const ChatbotResponseData({
    required this.sqlQuery,
    required this.data,
    required this.explanation,
  });

  factory ChatbotResponseData.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    List<Map<String, dynamic>> parsedData = [];

    if (rawData is List) {
      parsedData = rawData
          .map((item) => item is Map<String, dynamic>
              ? item
              : <String, dynamic>{})
          .toList();
    }

    return ChatbotResponseData(
      sqlQuery: json['sqlQuery'] as String? ?? '',
      data: parsedData,
      explanation: json['explanation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sqlQuery': sqlQuery,
      'data': data,
      'explanation': explanation,
    };
  }

  @override
  List<Object?> get props => [sqlQuery, data, explanation];
}
