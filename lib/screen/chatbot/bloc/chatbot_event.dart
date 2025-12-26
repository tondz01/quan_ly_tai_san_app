import 'package:equatable/equatable.dart';

abstract class ChatbotEvent extends Equatable {
  const ChatbotEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatHistoryEvent extends ChatbotEvent {
  const LoadChatHistoryEvent();
}

class SendMessageEvent extends ChatbotEvent {
  final String message;

  const SendMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class ClearChatEvent extends ChatbotEvent {
  const ClearChatEvent();
}
