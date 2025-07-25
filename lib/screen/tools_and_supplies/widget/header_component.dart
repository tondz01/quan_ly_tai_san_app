import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/enum/type_size_screen.dart';
import 'package:quan_ly_tai_san_app/utils/constants/app_colors.dart';
import 'package:se_gay_components/common/sg_button_icon.dart';
import 'package:se_gay_components/common/sg_input_text.dart';
import 'package:se_gay_components/common/sg_text.dart';

Widget buildHeader(
  double width,
  TextEditingController controller,
  Function(String) onSearchChanged, {
  String? subScreen,
  Function()? onTap,
  Function()? onNew,
}) {
  final typeSize = TypeSizeScreenExtension.getSizeScreen(width);
  return typeSize == TypeSizeScreen.extraSmall ||
          typeSize == TypeSizeScreen.small
      ? _buildHeaderScreenSmall(
        width,
        controller,
        onSearchChanged,
        subScreen,
        onNew,
        onTap,
      )
      : _buildHeaderScreenLarge(
        width,
        controller,
        onSearchChanged,
        subScreen,
        onNew,
        onTap,
      );
}

Widget _buildHeaderScreenLarge(
  double width,
  TextEditingController controller,
  Function(String) onSearchChanged,
  String? subScreen,
  Function()? onNew,
  Function()? onTap,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      _buildHeaderNameScreen(subScreen, onNew, onTap),
      const SizedBox(width: 16),
      Expanded(child: _buildSearchField(width, controller, onSearchChanged)),
    ],
  );
}

Widget _buildHeaderScreenSmall(
  double width,
  TextEditingController controller,
  Function(String) onSearchChanged,
  String? subScreen,
  Function()? onNew,
  Function()? onTap,
) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildHeaderNameScreen(subScreen, onNew, onTap),
      const SizedBox(height: 5),
      _buildSearchField(width, controller, onSearchChanged),
    ],
  );
}

Widget _buildHeaderNameScreen(String? subScreen, Function()? onNew, Function()? onTap) {
  bool isSubScreen = subScreen != null && subScreen.isNotEmpty;
  // log()
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      SGButtonIcon(
        text: 'Mới',
        width: 50,
        height: 35,
        defaultBGColor: isSubScreen ? Colors.white : ColorValue.oldLavender,
        isOutlined: true,
        isBorder: true,
        colorHover: Colors.blue,
        colorBorder: ColorValue.oldLavender,
        colorText: isSubScreen ? ColorValue.oldLavender : Colors.white,
        borderWidth: 3,
        onPressed: onNew,
      ),
      // SGButton(text: 'Mới'),
      const SizedBox(width: 8),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: !isSubScreen ? null : onTap,
            child: SGText(
              color: isSubScreen ? ColorValue.tealBlue : Colors.black,
              text: "tas.info_tools_supplies".tr,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isSubScreen)
            SGText(text: subScreen, overflow: TextOverflow.ellipsis),
        ],
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
