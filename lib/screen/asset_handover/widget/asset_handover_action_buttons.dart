import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';

class AssetHandoverActionButtons extends StatelessWidget {
  final bool isEditing;
  final AssetHandoverDto? item;
  final bool isFindNew;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final VoidCallback onCancelHandover;

  const AssetHandoverActionButtons({
    super.key,
    required this.isEditing,
    required this.item,
    required this.isFindNew,
    required this.onSave,
    required this.onCancel,
    required this.onCancelHandover,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
            Visibility(
              visible: isEditing,
              child: MaterialTextButton(
                text: 'Lưu',
                icon: Icons.save,
                backgroundColor: ColorValue.success,
                foregroundColor: Colors.white,
                onPressed: onSave,
              ),
            ),
            const SizedBox(width: 8),
            Visibility(
              visible: isEditing,
              child: MaterialTextButton(
                text: 'Hủy',
                icon: Icons.cancel,
                backgroundColor: ColorValue.error,
                foregroundColor: Colors.white,
                onPressed: onCancel,
              ),
            ),
            Visibility(
              visible: item != null &&
                  ![0, 2, 3].contains(item!.trangThai) &&
                  !isFindNew,
              child: MaterialTextButton(
                text: 'Hủy phiếu bàn giao',
                icon: Icons.cancel,
                backgroundColor: ColorValue.error,
                foregroundColor: Colors.white,
                onPressed: onCancelHandover,
              ),
            ),
          ],
        );
  }
}

