import 'package:flutter/material.dart';

class RefreshButton extends StatefulWidget {
  final Future<void> Function()? onRefresh;

  const RefreshButton({super.key, this.onRefresh});

  @override
  State<RefreshButton> createState() => _RefreshButtonState();
}

class _RefreshButtonState extends State<RefreshButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    _controller.repeat();

    // Gọi callback nếu có
    if (widget.onRefresh != null) {
      await widget.onRefresh!();
    } else {
      await Future.delayed(const Duration(seconds: 2)); // ví dụ delay
    }

    _controller.stop();
    _controller.reset();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _handleRefresh,
      icon: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 6.3, // ~2π rad
            child: child,
          );
        },
        child: Icon(
          Icons.refresh,
          color: _isLoading ? Colors.blue : Colors.cyanAccent,
        ),
      ),
    );
  }
}
