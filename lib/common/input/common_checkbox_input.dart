import 'package:flutter/material.dart';

class CommonCheckboxInput extends StatelessWidget {
  final String label;
  final bool value;
  final bool isEditing;
  final bool isEnable;
  final ValueChanged<bool>? onChanged;
  final double labelWidth;
  final double checkboxSize;
  final Color? activeColor;
  final Color? checkColor;
  final EdgeInsetsGeometry? padding;

  const CommonCheckboxInput({
    super.key,
    required this.label,
    required this.value,
    required this.isEditing,
    required this.isEnable,
    this.onChanged,
    this.labelWidth = 180,
    this.checkboxSize = 24,
    this.activeColor,
    this.checkColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              '$label :',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: !isEnable ? Colors.black : Colors.black87.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(width: 18),
          SizedBox(
            width: checkboxSize,
            height: checkboxSize,
            child: Checkbox(
              value: value,
              onChanged: !isEnable && isEditing
                  ? (newValue) {
                      if (onChanged != null) {
                        onChanged!(newValue ?? false);
                      }
                    }
                  : null,
              activeColor: activeColor ?? const Color(0xFF80C9CB),
              checkColor: checkColor ?? Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
    );
  }
}