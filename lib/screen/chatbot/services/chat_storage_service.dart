import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:quan_ly_tai_san_app/screen/chatbot/model/chat_message.dart';

class ChatStorageService {
  static const String _storageKey = 'chatbot_history';
  static const int _maxMessages = 100;

  final GetStorage _storage = GetStorage();

  static final ChatStorageService _instance = ChatStorageService._internal();

  factory ChatStorageService() => _instance;

  ChatStorageService._internal();

  Future<List<ChatMessage>> loadChatHistory() async {
    try {
      final String? jsonString = _storage.read<String>(_storageKey);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map((item) => ChatMessage.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveChatHistory(List<ChatMessage> messages) async {
    try {
      List<ChatMessage> messagesToSave = messages;
      if (messages.length > _maxMessages) {
        messagesToSave = messages.sublist(messages.length - _maxMessages);
      }

      final List<Map<String, dynamic>> jsonList =
          messagesToSave.map((msg) => msg.toJson()).toList();
      final String jsonString = json.encode(jsonList);
      await _storage.write(_storageKey, jsonString);
    } catch (e) {
      // Silent fail
    }
  }

  Future<void> addMessage(ChatMessage message) async {
    final messages = await loadChatHistory();
    messages.add(message);
    await saveChatHistory(messages);
  }

  Future<void> clearHistory() async {
    try {
      await _storage.remove(_storageKey);
    } catch (e) {
      // Silent fail
    }
  }
}
