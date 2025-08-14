import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/enum/type_size_screen.dart';
import 'package:se_gay_components/common/sg_input_text.dart';
import 'package:se_gay_components/common/sg_text.dart';

class HeaderComponent extends StatefulWidget {
  const HeaderComponent({
    super.key,
    required this.controller,
    required this.onSearchChanged,
    this.onTap,
    required this.onNew,
    required this.mainScreen,
    this.subScreen,
    this.isShowSearch = true,
    this.child,
  });
  final TextEditingController controller;
  final Function(String) onSearchChanged;
  final Function()? onTap;
  final Function()? onNew;
  final String? mainScreen;
  final String? subScreen;
  final Widget? child;
  final bool? isShowSearch;
  @override
  State<HeaderComponent> createState() => _HeaderComponentState();
}

class _HeaderComponentState extends State<HeaderComponent> {
  @override
  Widget build(BuildContext context) {
    return buildHeader(
      context.width,
      widget.controller,
      widget.onSearchChanged,
      subScreen: widget.subScreen,
      onTap: widget.onTap,
      onNew: widget.onNew,
      mainScreen: widget.mainScreen,
      isShowSearch: widget.isShowSearch,
      child: widget.child,
    );
  }
}

Widget buildHeader(
  double width,
  TextEditingController controller,
  Function(String) onSearchChanged, {
  String? subScreen,
  Function()? onTap,
  Function()? onNew,
  String? mainScreen,
  bool? isShowSearch,
  Widget? child,
}) {
  final typeSize = TypeSizeScreenExtension.getSizeScreen(width);
  return typeSize == TypeSizeScreen.extraSmall ||
          typeSize == TypeSizeScreen.small
      ? _buildHeaderScreenSmall(
        width,
        controller,
        onSearchChanged,
        subScreen,
        mainScreen,
        onNew,
        onTap,
        isShowSearch,
        child,
      )
      : _buildHeaderScreenLarge(
        width,
        controller,
        onSearchChanged,
        subScreen,
        mainScreen,
        onNew,
        onTap,
        isShowSearch,
        child,
      );
}

Widget _buildHeaderScreenLarge(
  double width,
  TextEditingController controller,
  Function(String) onSearchChanged,
  String? subScreen,
  String? mainScreen,
  Function()? onNew,
  Function()? onTap,
  bool? isShowSearch,
  Widget? child,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      _buildHeaderNameScreen(mainScreen, subScreen, onNew, onTap),
      // if (subScreen != null && subScreen.isNotEmpty) 
      const SizedBox(width: 16),
      // if (subScreen == null || subScreen.isEmpty)
        Expanded(child: _buildSearchField(width, controller, onSearchChanged)),
      if (child != null) child,
    ],
  );
}

Widget _buildHeaderScreenSmall(
  double width,
  TextEditingController controller,
  Function(String) onSearchChanged,
  String? subScreen,
  String? mainScreen,
  Function()? onNew,
  Function()? onTap,
  bool? isShowSearch,
  Widget? child,
) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildHeaderNameScreen(mainScreen, subScreen, onNew, onTap),
      // if (subScreen != null && subScreen.isNotEmpty) 
      const SizedBox(height: 5),
      // if (subScreen == null || subScreen.isEmpty)
      if (isShowSearch == true)
        _buildSearchField(width, controller, onSearchChanged),
      if (child != null) child,
    ],
  );
}

Widget _buildHeaderNameScreen(
  String? mainScreen,
  String? subScreen,
  Function()? onNew,
  Function()? onTap,
) {
  bool isSubScreen = subScreen != null && subScreen.isNotEmpty;
  // log()
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      MaterialTextButton(
        text: 'Mới',
        // icon: Icons.add,
        backgroundColor: isSubScreen ? Colors.white : ColorValue.primaryBlue,
        foregroundColor: isSubScreen ? ColorValue.primaryBlue : Colors.white,
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
              text: mainScreen ?? "tas.info_tools_supplies".tr,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isSubScreen)
            SGText(text: subScreen, overflow: TextOverflow.ellipsis, size: 12,),
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
