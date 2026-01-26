import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/chatbot/bloc/chatbot_event.dart';
import 'package:quan_ly_tai_san_app/screen/chatbot/bloc/chatbot_state.dart';
import 'package:quan_ly_tai_san_app/screen/chatbot/model/chat_message.dart';
import 'package:quan_ly_tai_san_app/screen/chatbot/model/chatbot_response.dart';
import 'package:quan_ly_tai_san_app/screen/chatbot/repository/chatbot_repository.dart';
import 'package:quan_ly_tai_san_app/screen/chatbot/services/chat_storage_service.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final ChatbotRepository _repository = ChatbotRepository();
  final ChatStorageService _storageService = ChatStorageService();
  List<ChatMessage> _messages = [];

  ChatbotBloc() : super(const ChatbotInitialState()) {
    on<LoadChatHistoryEvent>(_onLoadChatHistory);
    on<SendMessageEvent>(_onSendMessage);
    on<ClearChatEvent>(_onClearChat);
  }

  Future<void> _onLoadChatHistory(
    LoadChatHistoryEvent event,
    Emitter<ChatbotState> emit,
  ) async {
    _messages = await _storageService.loadChatHistory();
    emit(ChatbotMessagesState(messages: List.from(_messages)));
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatbotState> emit,
  ) async {
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: event.message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    _messages.add(userMessage);
    await _storageService.saveChatHistory(_messages);

    emit(ChatbotLoadingState(messages: List.from(_messages)));

    final result = await _repository.sendMessage(event.message);

    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      final ChatbotResponse response = result['data'];
      final botMessage = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        content: response.data?.explanation ?? response.message,
        isUser: false,
        timestamp: DateTime.now(),
        responseData: response.data,
      );

      _messages.add(botMessage);
      await _storageService.saveChatHistory(_messages);

      emit(ChatbotMessagesState(messages: List.from(_messages)));
    } else {
      final errorMessage = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        content: result['message'] ?? 'Đã xảy ra lỗi',
        isUser: false,
        timestamp: DateTime.now(),
      );

      _messages.add(errorMessage);
      await _storageService.saveChatHistory(_messages);

      emit(ChatbotErrorState(
        messages: List.from(_messages),
        errorMessage: result['message'] ?? 'Đã xảy ra lỗi',
      ));
    }
  }

  Future<void> _onClearChat(
    ClearChatEvent event,
    Emitter<ChatbotState> emit,
  ) async {
    _messages.clear();
    await _storageService.clearHistory();
    emit(const ChatbotMessagesState(messages: []));
  }
}
