import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:se_gay_components/common/sg_indicator.dart';

Widget buildHeaderDetail({
  required bool isEditing,
  required Function() onSave,
  required Function() onCancel,
  required Function() onEdit,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 10, bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        isEditing
            ? Row(
              children: [
                MaterialTextButton(
                  text: 'Lưu',
                  icon: Icons.save,
                  backgroundColor: ColorValue.success,
                  foregroundColor: Colors.white,
                  onPressed: onSave,
                ),
                const SizedBox(width: 8),
                MaterialTextButton(
                  text: 'Hủy',
                  icon: Icons.cancel,
                  backgroundColor: ColorValue.error,
                  foregroundColor: Colors.white,
                  onPressed: onCancel,
                ),
              ],
            )
            : MaterialTextButton(
              text: 'Chỉnh sửa nhóm tài sản',
              icon: Icons.save,
              backgroundColor: ColorValue.success,
              foregroundColor: Colors.white,
              onPressed: onEdit,
            ),
        SgIndicator(
          steps: ['Nháp', 'Khóa'],
          currentStep: !isEditing ? 1 : 0,
          fontSize: 10,
        ),
      ],
    ),
  );
}
