import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';

Future<bool> showUnsavedChangesDialog(
  BuildContext context,
  ToolsAndSuppliesDto? item,
  Function()? onPressed,
) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Thay đổi chưa lưu'),
            content: const Text(
              'Bạn có thay đổi chưa lưu. Bạn có chắc chắn muốn rời khỏi trang này?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  onPressed?.call();
                  Navigator.of(context).pop();
                },
                child: const Text('Rời khỏi'),
              ),
            ],
          );
        },
      ) ??
      false;
}
