import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/chatbot/model/chat_message.dart';

abstract class ChatbotState extends Equatable {
  const ChatbotState();

  @override
  List<Object?> get props => [];
}

class ChatbotInitialState extends ChatbotState {
  const ChatbotInitialState();
}

class ChatbotLoadingState extends ChatbotState {
  final List<ChatMessage> messages;

  const ChatbotLoadingState({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class ChatbotMessagesState extends ChatbotState {
  final List<ChatMessage> messages;

  const ChatbotMessagesState({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class ChatbotErrorState extends ChatbotState {
  final List<ChatMessage> messages;
  final String errorMessage;

  const ChatbotErrorState({
    required this.messages,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [messages, errorMessage];
}
