import 'package:flutter/material.dart';

InputDecoration inputDecoration(
  String label, {
  bool required = false,
  String? hint,
}) {
  return InputDecoration(
    label:
        required
            ? Text.rich(
              TextSpan(
                text: label,
                children: const [
                  TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
                ],
              ),
            )
            : Text(label),
    hintText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );
}
