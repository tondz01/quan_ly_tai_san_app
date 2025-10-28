// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

/// Lightweight loading overlay component
/// Usage:
/// LoadingOverlay(
///   isLoading: state.isLoading,
///   message: 'Đang xử lý...',
///   child: YourContent(),
/// )
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final String? message;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;
    return Stack(
      children: [
        child,
        // Chặn toàn bộ tương tác phía sau
        ModalBarrier(
          color: Colors.black.withOpacity(0.4),
          dismissible: false,
        ),
        // Nội dung loading ở trung tâm
        Positioned.fill(
          child: IgnorePointer(
            ignoring: true,
            child: Center(child: _LoadingContent(message: message)),
          ),
        ),
      ],
    );
  }
}

class _LoadingContent extends StatelessWidget {
  final String? message;
  const _LoadingContent({this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
          if (message != null && message!.trim().isNotEmpty) ...[
            const SizedBox(width: 12),
            Text(
              message!,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ],
      ),
    );
  }
}


