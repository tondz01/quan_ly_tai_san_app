import 'package:flutter/material.dart';

Future<void> downloadForWeb(String url, String fileName, BuildContext context) async {
  // Stub implementation cho các platform không phải web
  _showNotification(context, '⚠️ Download trên Web chưa được hỗ trợ trên platform này', false);
}

void _showNotification(BuildContext context, String message, bool isSuccess) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            isSuccess ? Icons.check_circle : Icons.error,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
} 