import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/enum/type_size_screen.dart';
import 'package:quan_ly_tai_san_app/utils/constants/app_colors.dart';
import 'package:se_gay_components/common/sg_button.dart';
import 'package:se_gay_components/common/sg_input_text.dart';
import 'package:se_gay_components/common/sg_text.dart';

Widget buildHeader(
  double width,
  TextEditingController controller,
  Function(String) onSearchChanged,
) {
  final typeSize = TypeSizeScreenExtension.getSizeScreen(width);
  return typeSize == TypeSizeScreen.extraSmall ||
          typeSize == TypeSizeScreen.small
      ? _buildHeaderScreenSmall(width, controller, onSearchChanged)
      : _buildHeaderScreenLarge(width, controller, onSearchChanged);
}

Widget _buildHeaderScreenLarge(
  double width,
  TextEditingController controller,
  Function(String) onSearchChanged,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      _buildHeaderNameScreen(),
      const SizedBox(width: 16),
      Expanded(child: _buildSearchField(width, controller, onSearchChanged)),
    ],
  );
}

Widget _buildHeaderScreenSmall(
  double width,
  TextEditingController controller,
  Function(String) onSearchChanged,
) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildHeaderNameScreen(),
      const SizedBox(height: 5),
      _buildSearchField(width, controller, onSearchChanged),
    ],
  );
}

Widget _buildHeaderNameScreen() {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      // SGButton(
      //   width: 50,
      //   height: 35,
      //   borderRadius: 5,
      //   onclick: () {},
      //   text: 'Mới',
      //   textSize: 14,
      //   color: ColorValue.oldLavender,
      // ),
      const SizedBox(width: 8),
      Flexible(
        child: SGText(
          text: "Thông tin công cụ dụng cụ - Vật tư",
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}

//SEARCH
Widget _buildSearchField(
  double width,
  TextEditingController controller,
  Function(String) onSearchChanged,
) {
  final isSmallScreen =
      TypeSizeScreenExtension.getSizeScreen(width) ==
          TypeSizeScreen.extraSmall ||
      TypeSizeScreenExtension.getSizeScreen(width) == TypeSizeScreen.small;

  return SGInputText(
    height: 35,
    prefixIcon: const Icon(Icons.search),
    controller: controller,
    width: isSmallScreen ? width : width * 0.5,
    borderRadius: 10,
    padding: const EdgeInsets.all(1),
    fontSize: 14,
    hintText: 'Tìm kiếm',
    onChanged: onSearchChanged,
  );
}
