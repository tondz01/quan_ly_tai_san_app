import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/common/Component/reusable_tag_search.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/enum/type_size_screen.dart';
import 'package:se_gay_components/common/sg_text.dart';

class HeaderComponent<T> extends StatefulWidget {
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
    required this.data,
    this.getters,
  });
  final TextEditingController controller;
  final Function(List<T> filteredItems) onSearchChanged;
  final List<T> data;
  final List<Map<String, Function(T)>>? getters;
  final Function()? onTap;
  final Function()? onNew;
  final String? mainScreen;
  final String? subScreen;
  final Widget? child;
  final bool? isShowSearch;
  @override
  State<HeaderComponent<T>> createState() => _HeaderComponentState<T>();
}

class _HeaderComponentState<T> extends State<HeaderComponent<T>> {
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
      data: widget.data,
      getters: widget.getters,
    );
  }
}

Widget buildHeader<T>(
  double width,
  TextEditingController controller,
  Function(List<T> filteredItems) onSearchChanged, {
  String? subScreen,
  Function()? onTap,
  Function()? onNew,
  String? mainScreen,
  bool? isShowSearch,
  Widget? child,
  required List<T> data,
  List<Map<String, Function(T)>>? getters,
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
        data,
        getters,
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
        data,
        getters,
      );
}

Widget _buildHeaderScreenLarge<T>(
  double width,
  TextEditingController controller,
  Function(List<T> filteredItems) onSearchChanged,
  String? subScreen,
  String? mainScreen,
  Function()? onNew,
  Function()? onTap,
  bool? isShowSearch,
  Widget? child,
  List<T> data,
  List<Map<String, Function(T)>>? getters,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      _buildHeaderNameScreen(mainScreen, subScreen, onNew, onTap),
      // if (subScreen != null && subScreen.isNotEmpty)
      const SizedBox(width: 16),
      // if (subScreen == null || subScreen.isEmpty)
      Expanded(
        child: _buildSearchField(
          width,
          controller,
          onSearchChanged,
          data,
          getters,
        ),
      ),
      if (child != null) child,
    ],
  );
}

Widget _buildHeaderScreenSmall<T>(
  double width,
  TextEditingController controller,
  Function(List<T> filteredItems) onSearchChanged,
  String? subScreen,
  String? mainScreen,
  Function()? onNew,
  Function()? onTap,
  bool? isShowSearch,
  Widget? child,
  List<T> data,
  List<Map<String, Function(T)>>? getters,
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
        _buildSearchField(width, controller, onSearchChanged, data, getters),
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
            SGText(text: subScreen, overflow: TextOverflow.ellipsis, size: 12),
        ],
      ),
    ],
  );
}

Widget _buildSearchField<T>(
  double width,
  TextEditingController controller,
  Function(List<T> filteredItems) onSearchChanged,
  List<T> data,
  List<Map<String, Function(T)>>? getters,
) {
  final isSmallScreen =
      TypeSizeScreenExtension.getSizeScreen(width) ==
          TypeSizeScreen.extraSmall ||
      TypeSizeScreenExtension.getSizeScreen(width) == TypeSizeScreen.small;

  return SizedBox(
    width: isSmallScreen ? width : width * 0.5,
    child: ReusableTagSearch<T>(
      hintText: 'Tìm kiếm',
      data: data,
      getters: getters,
      onFilteredItemsChanged: (List<T> filteredItems) {
        onSearchChanged(filteredItems);
      },
    ),
  );
}
