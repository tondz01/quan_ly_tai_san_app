// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    this.onFileSelected,
    this.onExportData,
  });
  final TextEditingController controller;
  final Function(String) onSearchChanged;
  final Function()? onTap;
  final Function()? onNew;
  final String? mainScreen;
  final String? subScreen;
  final Widget? child;
  final bool? isShowSearch;
  final Function(String? fileName, String? filePath, Uint8List? fileBytes)?
  onFileSelected;
  final Function()? onExportData;
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
      context: context,
      onFileSelected:
          widget.onFileSelected ?? (fileName, filePath, fileBytes) {},
      onExportData: widget.onExportData ?? () {},
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
  required BuildContext context,
  required Function(String? fileName, String? filePath, Uint8List? fileBytes)
  onFileSelected,
  Function()? onExportData,
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
        context,
        onFileSelected: onFileSelected,
        onExportData: onExportData,
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
        context,
        onFileSelected: onFileSelected,
        onExportData: onExportData,
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
  BuildContext context, {
  required Function(String? fileName, String? filePath, Uint8List? fileBytes)
  onFileSelected,
  Function()? onExportData,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      _buildHeaderNameScreen(
        mainScreen,
        subScreen,
        onNew,
        onTap,
        context,
        onFileSelected: onFileSelected,
        onExportData: onExportData,
      ),
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
  BuildContext context, {
  required Function(String? fileName, String? filePath, Uint8List? fileBytes)
  onFileSelected,
  Function()? onExportData,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildHeaderNameScreen(
        mainScreen,
        subScreen,
        onNew,
        onTap,
        context,
        onFileSelected: onFileSelected,
        onExportData: onExportData,
      ),
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
  BuildContext context, {
  required Function(String? fileName, String? filePath, Uint8List? fileBytes)
  onFileSelected,
  Function()? onExportData,
}) {
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
      Row(
        children: [
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
                SGText(
                  text: subScreen,
                  overflow: TextOverflow.ellipsis,
                  size: 12,
                ),
            ],
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTapDown: (TapDownDetails details) {
              _showCustomMenu(
                context,
                details.globalPosition,
                onFileSelected: onFileSelected,
                onExportData: onExportData,
              );
            },
            child: Icon(
              Icons.settings,
              size: 20,
              color: ColorValue.primaryBlue,
            ),
          ),
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

void _showCustomMenu(
  BuildContext context,
  Offset offset, {
  required Function(String? fileName, String? filePath, Uint8List? fileBytes)
  onFileSelected,
  Function()? onExportData,
}) async {
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;

  await showMenu(
    context: context,
    position: RelativeRect.fromRect(
      Rect.fromLTWH(offset.dx - 20, offset.dy - 40, 0, 0), // vị trí popup
      Offset.zero & overlay.size, // kích thước màn hình
    ),
    items: [
      PopupMenuItem(
        value: 1,
        child: Row(
          children: const [
            Icon(Icons.download, size: 20, color: Colors.black87),
            SizedBox(width: 8),
            Text("Import dữ liệu"),
          ],
        ),
      ),
      PopupMenuItem(
        value: 2,
        child: Row(
          children: const [
            Icon(Icons.upload, size: 20, color: Colors.black87),
            SizedBox(width: 8),
            Text("Xuất toàn bộ"),
          ],
        ),
      ),
    ],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), // bo góc
      side: const BorderSide(color: Colors.black12), // viền nhẹ
    ),
    elevation: 8,
  ).then((value) {
    if (value != null) {
      if (value == 1) {
        _selectDocument(context: context, onFileSelected: onFileSelected);
      } else if (value == 2) {
        onExportData?.call();
      }
    }
  });
}

Future<void> _selectDocument({
  required BuildContext context,
  required Function(String? fileName, String? filePath, Uint8List? fileBytes)
  onFileSelected,
}) async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx', 'xls'],
      withData: false,
      withReadStream: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      onFileSelected(file.name, file.path, kIsWeb ? file.bytes : null);
      log('Selected file: ${file.name}, Path: ${file.path}');
    }
  } on PlatformException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lỗi khi chọn tệp: ${e.message}'),
        backgroundColor: Colors.red.shade600,
      ),
    );
  } catch (e) {
    log('Error selecting file: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Không thể chọn tệp: ${e.toString()}'),
        backgroundColor: Colors.red.shade600,
      ),
    );
  }
}
