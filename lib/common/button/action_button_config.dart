import 'package:flutter/material.dart';

class ActionButtonConfig<T> {
  final IconData icon;
  final String? tooltip;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onPressed;
  final bool isDisabled;

  ActionButtonConfig({
    required this.icon,
    this.tooltip,
    this.iconColor,
    this.backgroundColor,
    this.borderColor,
    this.onPressed,
    this.isDisabled = false,
  });
}

Widget viewActionButtons<T>(List<ActionButtonConfig<T>> actions) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children:
        actions.map((action) {
            return Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: action.backgroundColor ?? Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: action.borderColor ?? Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(action.icon, size: 16, color: action.iconColor),
                    tooltip: action.tooltip,
                    color: action.iconColor,
                    onPressed: action.isDisabled ? null : action.onPressed,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    padding: const EdgeInsets.all(4),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            );
          }).toList()
          ..removeLast(),
  );
}
