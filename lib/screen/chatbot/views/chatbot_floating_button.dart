import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/chatbot/bloc/chatbot_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/chatbot/views/chatbot_popup.dart';

class ChatbotFloatingButton extends StatefulWidget {
  const ChatbotFloatingButton({super.key});

  @override
  State<ChatbotFloatingButton> createState() => _ChatbotFloatingButtonState();
}

class _ChatbotFloatingButtonState extends State<ChatbotFloatingButton>
    with SingleTickerProviderStateMixin {
  bool _isPopupOpen = false;
  bool _isFullScreen = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _togglePopup() {
    setState(() {
      _isPopupOpen = !_isPopupOpen;
      if (!_isPopupOpen) {
        _isFullScreen = false;
      }
    });
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_isPopupOpen)
          Positioned(
            top: _isFullScreen ? 0 : 80,
            right: _isFullScreen ? 0 : 24,
            bottom: _isFullScreen ? 0 : null,
            left: _isFullScreen ? 0 : null,
            child: BlocProvider(
              create: (_) => ChatbotBloc(),
              child: ChatbotPopup(
                onClose: _togglePopup,
                isFullScreen: _isFullScreen,
                onToggleFullScreen: _toggleFullScreen,
              ),
            ),
          ),
        Positioned(
          top: 80,
          right: 24,
          child: _buildFloatingButton(),
        ),
      ],
    );
  }

  Widget _buildFloatingButton() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isPopupOpen ? 1.0 : _pulseAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: _togglePopup,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF009E60), Color(0xFF026E42)],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF009E60).withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _isPopupOpen ? Icons.close : Icons.smart_toy,
                key: ValueKey(_isPopupOpen),
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedBuilder extends StatelessWidget {
  final Animation<double> animation;
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required this.animation,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder2(
      animation: animation,
      builder: builder,
      child: child,
    );
  }
}

class AnimatedBuilder2 extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;

  const AnimatedBuilder2({
    super.key,
    required Animation<double> animation,
    required this.builder,
    this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
