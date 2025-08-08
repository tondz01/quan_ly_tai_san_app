import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:se_gay_components/common/sg_button_icon.dart';
import 'package:se_gay_components/common/sg_colors.dart';

class ToolsAndSuppliesHeaderActions extends StatelessWidget {
  final bool isEditing;
  final bool showToggle;
  final String toggleText;
  final VoidCallback onToggleEdit;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const ToolsAndSuppliesHeaderActions({
    super.key,
    required this.isEditing,
    required this.showToggle,
    required this.toggleText,
    required this.onToggleEdit,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        if (showToggle)
          SGButtonIcon(
            text: toggleText,
            borderRadius: 10,
            sizeText: 14,
            width: screenWidth * 0.12 <= 120 ? 120 : screenWidth * 0.12,
            height: 40,
            defaultBGColor:
                isEditing ? SGAppColors.colorInputDisable : ColorValue.oldLavender,
            colorHover: Colors.blueAccent,
            colorTextHover: Colors.white,
            isOutlined: true,
            borderWidth: 3,
            onPressed: onToggleEdit,
          ),
        if (isEditing) ...[
          SGButtonIcon(
            text: 'Sẵn sàng',
            borderRadius: 10,
            sizeText: 14,
            width: 70,
            height: 35,
            defaultBGColor: Colors.blue,
            colorHover: Colors.blueGrey,
            colorTextHover: Colors.white,
            isOutlined: false,
            onPressed: onSave,
          ),
          const SizedBox(width: 10),
          SGButtonIcon(
            text: 'Hủy',
            borderRadius: 10,
            sizeText: 14,
            width: 70,
            height: 35,
            defaultBGColor: Colors.red,
            colorHover: Colors.redAccent,
            colorTextHover: Colors.white,
            isOutlined: false,
            onPressed: onCancel,
          ),
        ],
      ],
    );
  }
} 