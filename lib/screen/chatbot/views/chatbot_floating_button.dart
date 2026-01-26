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
  bool _isDragging = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Vị trí của button (mặc định góc trên bên phải, cách lề 100)
  double? _buttonX;
  double? _buttonY;

  // Kích thước button
  static const double _buttonSize = 56.0;
  static const double _edgeMargin = 100.0;

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

  void _initPosition(Size screenSize) {
    if (_buttonX == null || _buttonY == null) {
      // Vị trí mặc định: góc trên bên phải, cách lề 100
      _buttonX = screenSize.width - _buttonSize - _edgeMargin;
      _buttonY = _edgeMargin;
    }
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

  void _onDragUpdate(DragUpdateDetails details, Size screenSize) {
    setState(() {
      _isDragging = true;
      _buttonX = (_buttonX! + details.delta.dx).clamp(
        _edgeMargin,
        screenSize.width - _buttonSize - _edgeMargin,
      );
      _buttonY = (_buttonY! + details.delta.dy).clamp(
        _edgeMargin,
        screenSize.height - _buttonSize - _edgeMargin,
      );
    });
  }

  void _onDragEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    _initPosition(screenSize);

    return Stack(
      children: [
        // Popup
        if (_isPopupOpen)
          Positioned(
            top: _isFullScreen ? 0 : _buttonY! + _buttonSize + 10,
            right: _isFullScreen ? 0 : null,
            left: _isFullScreen ? 0 : _getPopupLeftPosition(screenSize),
            bottom: _isFullScreen ? 0 : null,
            child: BlocProvider(
              create: (_) => ChatbotBloc(),
              child: ChatbotPopup(
                onClose: _togglePopup,
                isFullScreen: _isFullScreen,
                onToggleFullScreen: _toggleFullScreen,
              ),
            ),
          ),
        // Draggable floating button
        Positioned(
          left: _buttonX,
          top: _buttonY,
          child: GestureDetector(
            onPanUpdate: (details) => _onDragUpdate(details, screenSize),
            onPanEnd: _onDragEnd,
            onTap: _togglePopup,
            child: _buildFloatingButton(),
          ),
        ),
      ],
    );
  }

  double _getPopupLeftPosition(Size screenSize) {
    const popupWidth = 450.0;
    // Tính vị trí để popup nằm gần button
    double left = _buttonX! - popupWidth + _buttonSize;
    // Đảm bảo popup không ra ngoài màn hình
    if (left < 10) {
      left = 10;
    }
    if (left + popupWidth > screenSize.width - 10) {
      left = screenSize.width - popupWidth - 10;
    }
    return left;
  }

  Widget _buildFloatingButton() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isPopupOpen ? 1.0 : (_isDragging ? 1.1 : _pulseAnimation.value),
          child: child,
        );
      },
      child: MouseRegion(
        cursor: _isDragging ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _buttonSize,
          height: _buttonSize,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _isDragging
                  ? [const Color(0xFF00C978), const Color(0xFF028A52)]
                  : [const Color(0xFF009E60), const Color(0xFF026E42)],
            ),
            borderRadius: BorderRadius.circular(_buttonSize / 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF009E60).withValues(alpha: _isDragging ? 0.6 : 0.4),
                blurRadius: _isDragging ? 16 : 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  _isPopupOpen ? Icons.close : Icons.smart_toy,
                  key: ValueKey(_isPopupOpen),
                  color: Colors.white,
                  size: 28,
                ),
              ),
              // Drag indicator
              if (!_isPopupOpen)
                Positioned(
                  bottom: 4,
                  child: Icon(
                    Icons.drag_indicator,
                    size: 12,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
            ],
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
