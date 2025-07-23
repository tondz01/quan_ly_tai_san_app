import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/sg_dropdown_input_button.dart';

Widget filterDropdown(
  String title,
  List<String> items,
  String? value,
  Function(String?) onChanged,
  TextEditingController controller,
  Size size,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SGText(text: title, size: 14, color: SGAppColors.neutral700),
      const SizedBox(height: 4),
      SizedBox(
        width: size.width * 0.15,
        child: SGDropdownInputButton<String>(
          controller: controller,
          value: value,
          items:
              items
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
          sizeBorderCircular: 10,
          colorBorder: SGAppColors.neutral400,
          enableSearch: false,
          isShowSuffixIcon: true,
          hintText: 'Chọn ${title.toLowerCase()}',
          textAlign: TextAlign.left,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    ],
  );
}
