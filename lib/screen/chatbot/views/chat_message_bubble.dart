import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/chatbot/model/chat_message.dart';
import 'package:quan_ly_tai_san_app/screen/chatbot/views/chat_data_table.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isFullScreen;

  const ChatMessageBubble({
    super.key,
    required this.message,
    this.isFullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: isFullScreen ? 16 : 8,
      ),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) _buildAvatar(),
          if (!message.isUser) const SizedBox(width: 8),
          Flexible(
            child: _buildMessageContent(context),
          ),
          if (message.isUser) const SizedBox(width: 8),
          if (message.isUser) _buildUserAvatar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: ColorValue.primaryBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.smart_toy,
        size: 20,
        color: ColorValue.primaryBlue,
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: ColorValue.neutral200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.person,
        size: 20,
        color: ColorValue.neutral600,
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    final hasData = message.responseData?.data.isNotEmpty ?? false;
    final maxWidthRatio = isFullScreen ? 0.85 : 0.75;

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * maxWidthRatio,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: message.isUser ? ColorValue.primaryBlue : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(message.isUser ? 16 : 4),
          bottomRight: Radius.circular(message.isUser ? 4 : 16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: message.isUser
            ? null
            : Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            message.content,
            style: TextStyle(
              fontSize: 14,
              color: message.isUser ? Colors.white : Colors.black87,
              height: 1.4,
            ),
          ),
          if (hasData) ...[
            const SizedBox(height: 12),
            ChatDataTable(
              data: message.responseData!.data,
              sqlQuery: message.responseData!.sqlQuery,
              isFullScreen: isFullScreen,
            ),
          ],
          const SizedBox(height: 4),
          Text(
            _formatTime(message.timestamp),
            style: TextStyle(
              fontSize: 10,
              color: message.isUser
                  ? Colors.white.withValues(alpha: 0.7)
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
