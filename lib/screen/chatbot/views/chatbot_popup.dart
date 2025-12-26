import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/chatbot/bloc/chatbot_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/chatbot/bloc/chatbot_event.dart';
import 'package:quan_ly_tai_san_app/screen/chatbot/bloc/chatbot_state.dart';
import 'package:quan_ly_tai_san_app/screen/chatbot/model/chat_message.dart';
import 'package:quan_ly_tai_san_app/screen/chatbot/views/chat_message_bubble.dart';

class ChatbotPopup extends StatefulWidget {
  final VoidCallback onClose;
  final bool isFullScreen;
  final VoidCallback? onToggleFullScreen;

  const ChatbotPopup({
    super.key,
    required this.onClose,
    this.isFullScreen = false,
    this.onToggleFullScreen,
  });

  @override
  State<ChatbotPopup> createState() => _ChatbotPopupState();
}

class _ChatbotPopupState extends State<ChatbotPopup>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
    context.read<ChatbotBloc>().add(const LoadChatHistoryEvent());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    context.read<ChatbotBloc>().add(SendMessageEvent(message));
    _messageController.clear();
    _focusNode.requestFocus();
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xóa lịch sử chat'),
        content: const Text('Bạn có chắc muốn xóa toàn bộ lịch sử chat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ChatbotBloc>().add(const ClearChatEvent());
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFullScreen = widget.isFullScreen;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isFullScreen ? double.infinity : 450,
            height: isFullScreen ? double.infinity : 550,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isFullScreen ? 0 : 16),
              boxShadow: isFullScreen
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
            ),
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _buildMessageList(),
                ),
                _buildInputArea(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final isFullScreen = widget.isFullScreen;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF009E60), Color(0xFF026E42)],
        ),
        borderRadius: isFullScreen
            ? null
            : const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.smart_toy,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Assistant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Truy vấn dữ liệu bằng ngôn ngữ tự nhiên',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _clearChat,
            icon: const Icon(Icons.delete_outline, color: Colors.white70),
            tooltip: 'Xóa lịch sử',
            iconSize: 20,
            splashRadius: 20,
          ),
          if (widget.onToggleFullScreen != null)
            IconButton(
              onPressed: widget.onToggleFullScreen,
              icon: Icon(
                isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                color: Colors.white,
              ),
              tooltip: isFullScreen ? 'Thu nhỏ' : 'Toàn màn hình',
              iconSize: 20,
              splashRadius: 20,
            ),
          IconButton(
            onPressed: widget.onClose,
            icon: const Icon(Icons.close, color: Colors.white),
            tooltip: 'Đóng',
            iconSize: 20,
            splashRadius: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return BlocConsumer<ChatbotBloc, ChatbotState>(
      listener: (context, state) {
        if (state is ChatbotMessagesState || state is ChatbotLoadingState) {
          _scrollToBottom();
        }
      },
      builder: (context, state) {
        List<ChatMessage> messages = [];
        bool isLoading = false;

        if (state is ChatbotMessagesState) {
          messages = state.messages;
        } else if (state is ChatbotLoadingState) {
          messages = state.messages;
          isLoading = true;
        } else if (state is ChatbotErrorState) {
          messages = state.messages;
        }

        if (messages.isEmpty && !isLoading) {
          return _buildEmptyState();
        }

        return Container(
          color: ColorValue.neutral50,
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: messages.length + (isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (isLoading && index == messages.length) {
                return _buildTypingIndicator();
              }
              return ChatMessageBubble(
                message: messages[index],
                isFullScreen: widget.isFullScreen,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      color: ColorValue.neutral50,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Xin chào! Tôi có thể giúp bạn\ntruy vấn dữ liệu từ hệ thống.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            _buildSuggestionChips(),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChips() {
    final suggestions = [
      'Danh sách tài sản',
      'Thống kê điều động',
      'Báo cáo CCDC',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: suggestions.map((suggestion) {
        return ActionChip(
          label: Text(
            suggestion,
            style: const TextStyle(fontSize: 12),
          ),
          onPressed: () {
            _messageController.text = suggestion;
            _sendMessage();
          },
          backgroundColor: Colors.white,
          side: BorderSide(color: ColorValue.primaryBlue.withValues(alpha: 0.3)),
        );
      }).toList(),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
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
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + (index * 200)),
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: ColorValue.primaryBlue.withValues(alpha: 0.3 + (0.7 * value)),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }

  Widget _buildInputArea() {
    final isFullScreen = widget.isFullScreen;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: isFullScreen
            ? null
            : const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Nhập câu hỏi...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor: ColorValue.neutral50,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide:
                      const BorderSide(color: ColorValue.primaryBlue, width: 1),
                ),
              ),
              style: const TextStyle(fontSize: 14),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          BlocBuilder<ChatbotBloc, ChatbotState>(
            builder: (context, state) {
              final isLoading = state is ChatbotLoadingState;
              return Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF009E60), Color(0xFF026E42)],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: IconButton(
                  onPressed: isLoading ? null : _sendMessage,
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send, color: Colors.white, size: 20),
                  tooltip: 'Gửi',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
