import 'package:flutter/material.dart';
import 'package:se_gay_components/common/switch/sg_checkbox.dart';

class CommonCheckboxInput extends StatelessWidget {
  final String label;
  final bool value;
  final bool isEditing;
  final bool isDisabled;
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
    required this.isDisabled,
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
                color:
                    !isDisabled ? Colors.black : Colors.black87.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(width: 18),
          SgCheckbox(
            value: value,
            onChanged: onChanged,
            checkedColor: activeColor,
            uncheckedColor: checkColor,
            size: checkboxSize,
            isDisabled: isDisabled,
            animationDuration: const Duration(milliseconds: 100),
          ),
        ],
      ),
    );
  }
}
