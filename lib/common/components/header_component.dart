// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:file_picker/file_picker.dart';
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
    this.isShowInput = true,
    this.isShownew = true,
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
  final bool isShowInput;
  final bool isShownew;
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
      isShownew: widget.isShownew,
      child: widget.child,
      context: context,
      onFileSelected:
          widget.onFileSelected ?? (fileName, filePath, fileBytes) {},
      onExportData: widget.onExportData ?? () {},
      isShowInput: widget.isShowInput,
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
  bool isShowInput = true,
  bool isShownew = true,
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
        isShowInput,
        isShownew,
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
        isShowInput,
        isShownew,
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
  bool isShowInput,
  bool isShownew,
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
        isShowInput,
        isShownew,
        context,
        onFileSelected: onFileSelected,
        onExportData: onExportData,
      ),
      // if (subScreen != null && subScreen.isNotEmpty)
      const SizedBox(width: 16),
      // if (subScreen == null || subScreen.isEmpty)
      if (isShowSearch == true)
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
  bool isShowInput,
  bool isShownew,
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
        isShowInput,
        isShownew,
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
  bool isShowInput,
  bool isShownew,
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
      if (isShownew)
        MaterialTextButton(
          text: 'Mới',
          // icon: Icons.add,
          backgroundColor: isSubScreen ? Colors.white : const Color(0xFF21A366),
          foregroundColor: isSubScreen ? const Color(0xFF21A366) : Colors.white,
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
          Visibility(
            visible: isShowInput,
            child: Builder(
              builder: (iconContext) {
                return GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    // 🟢 Lấy RenderBox của chính icon
                    final RenderBox iconBox =
                        iconContext.findRenderObject() as RenderBox;
                    final RenderBox overlay =
                        Overlay.of(iconContext).context.findRenderObject()
                            as RenderBox;

                    // 🟢 Tính vị trí icon tương đối với overlay (đã trừ offset scroll)
                    final Offset position = iconBox.localToGlobal(
                      Offset.zero,
                      ancestor: overlay,
                    );
                    final Size size = iconBox.size;
                    // Gọi popup tại đúng vị trí icon
                    _showCustomMenu(
                      iconContext,
                      position,
                      size,
                      onFileSelected: onFileSelected,
                      onExportData: onExportData,
                    );
                  },
                  child: Icon(
                    Icons.settings,
                    size: 20,
                    color: const Color(0xFF21A366),
                  ),
                );
              },
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
  Offset offset,
  Size size, {
  required Function(String? fileName, String? filePath, Uint8List? fileBytes)
  onFileSelected,
  Function()? onExportData,
}) async {
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;

  await showMenu(
    context: context,
    position: RelativeRect.fromRect(
      Rect.fromLTWH(
        offset.dx,
        offset.dy + size.height, // hiển thị ngay dưới icon
        size.width,
        size.height,
      ),
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
      withData: true, // luôn lấy bytes (kể cả không phải Web)
      withReadStream: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      final selectedPath = file.path; // Trên Web có thể là null
      final selectedBytes =
          file.bytes; // Khi kIsWeb && withData=true sẽ có bytes

      if (selectedPath == null && selectedBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể đọc tệp đã chọn.'),
            backgroundColor: Colors.red.shade600,
          ),
        );
        return;
      }

      onFileSelected(file.name, selectedPath, selectedBytes);
      log('Selected file: ${file.name}, Path: $selectedPath');
    }
  } on PlatformException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lỗi khi chọn tệp: ${e.message}'),
        backgroundColor: Colors.red.shade600,
      ),
    );
  } catch (e) {
    log('Error _selectDocument file: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Không thể chọn tệp: ${e.toString()}'),
        backgroundColor: Colors.red.shade600,
      ),
    );
  }
}
