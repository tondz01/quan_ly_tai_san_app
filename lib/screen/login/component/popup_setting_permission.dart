import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:se_gay_components/common/switch/sg_checkbox.dart';

// Model cho permission data
class PermissionItem {
  final String label;
  final String value;
  bool isSelected;

  PermissionItem({
    required this.label,
    required this.value,
    this.isSelected = false,
  });

  // Copy constructor để tạo bản sao
  PermissionItem copyWith({String? label, String? value, bool? isSelected}) {
    return PermissionItem(
      label: label ?? this.label,
      value: value ?? this.value,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class PermissionCategory {
  final String categoryName;
  final String categoryValue;
  final List<PermissionItem> permissions;

  PermissionCategory({
    required this.categoryName,
    required this.categoryValue,
    List<PermissionItem>? permissions,
  }) : permissions = permissions ?? _createDefaultPermissions(categoryValue);

  // Tự động tạo 3 permissions mặc định với trạng thái có thể set
  static List<PermissionItem> _createDefaultPermissions(String categoryValue) {
    return [
      PermissionItem(
        label: "Thêm",
        value: "${categoryValue}_add",
        isSelected: false,
      ),
      PermissionItem(
        label: "Sửa",
        value: "${categoryValue}_edit",
        isSelected: false,
      ),
      PermissionItem(
        label: "Xóa",
        value: "${categoryValue}_delete",
        isSelected: false,
      ),
    ];
  }

  // Constructor để tạo category với trạng thái mặc định cho từng permission
  factory PermissionCategory.createWithDefaults({
    required String categoryName,
    required String categoryValue,
    bool addDefault = false,
    bool editDefault = false,
    bool deleteDefault = false,
  }) {
    return PermissionCategory(
      categoryName: categoryName,
      categoryValue: categoryValue,
      permissions: [
        PermissionItem(
          label: "Thêm",
          value: "${categoryValue}_add",
          isSelected: addDefault,
        ),
        PermissionItem(
          label: "Sửa",
          value: "${categoryValue}_edit",
          isSelected: editDefault,
        ),
        PermissionItem(
          label: "Xóa",
          value: "${categoryValue}_delete",
          isSelected: deleteDefault,
        ),
      ],
    );
  }

  // Copy constructor
  PermissionCategory copyWith({
    String? categoryName,
    String? categoryValue,
    List<PermissionItem>? permissions,
  }) {
    return PermissionCategory(
      categoryName: categoryName ?? this.categoryName,
      categoryValue: categoryValue ?? this.categoryValue,
      permissions:
          permissions ?? this.permissions.map((p) => p.copyWith()).toList(),
    );
  }
}

class PopupSettingPermission extends StatefulWidget {
  final List<PermissionCategory> categories;
  final String title;
  final String submitButtonText;
  final Function(List<PermissionCategory>)? onSubmit;
  final VoidCallback? onClose;

  const PopupSettingPermission({
    super.key,
    required this.categories,
    this.title = "Thiết lập quyền",
    this.submitButtonText = "Submit",
    this.onSubmit,
    this.onClose,
  });

  @override
  State<PopupSettingPermission> createState() => _PopupSettingPermissionState();
}

class _PopupSettingPermissionState extends State<PopupSettingPermission> {
  late List<PermissionCategory> _categories;

  @override
  void initState() {
    super.initState();
    // Tạo deep copy để không ảnh hưởng đến data gốc
    _categories =
        widget.categories.map((category) {
          return PermissionCategory(
            categoryName: category.categoryName,
            categoryValue: category.categoryValue,
            permissions:
                category.permissions.map((permission) {
                  return PermissionItem(
                    label: permission.label,
                    value: permission.value,
                    isSelected: permission.isSelected,
                  );
                }).toList(),
          );
        }).toList();
  }

  void _togglePermission(int categoryIndex, int permissionIndex) {
    setState(() {
      _categories[categoryIndex].permissions[permissionIndex].isSelected =
          !_categories[categoryIndex].permissions[permissionIndex].isSelected;
    });
  }

  void _onSubmit() {
    if (widget.onSubmit != null) {
      // Trả về toàn bộ thông tin của list permissions
      widget.onSubmit!(_categories);
    }
    Navigator.of(context).pop();
  }

  void _onClose() {
    if (widget.onClose != null) {
      widget.onClose!();
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.5,
        constraints: BoxConstraints(minWidth: 450),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1976D2),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                GestureDetector(
                  onTap: _onClose,
                  child: const Icon(Icons.close, color: Colors.black, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Content scrollable
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: Column(
                    children: [
                      ...List.generate(_categories.length, (categoryIndex) {
                        final category = _categories[categoryIndex];
                        return Column(
                          children: [
                            if (categoryIndex > 0)
                              const Divider(
                                color: Color(0xFFE0E0E0),
                                thickness: 1,
                              ),
                            // Category row
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Category name
                                  Expanded(
                                    child: Text(
                                      category.categoryName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  // Permission checkboxes
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        ...List.generate(
                                          category.permissions.length,
                                          (permissionIndex) {
                                            final permission =
                                                category
                                                    .permissions[permissionIndex];
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                left: 24,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SgCheckbox(
                                                    value: permission.isSelected,
                                                    onChanged:
                                                        (_) => _togglePermission(
                                                          categoryIndex,
                                                          permissionIndex,
                                                        ),
                                                    checkedColor: ColorValue.info,
                                                    uncheckedColor: Colors.white,
                                                    size: 20,
                                                    isDisabled: false,
                                                    animationDuration:
                                                        const Duration(
                                                          milliseconds: 100,
                                                        ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    permission.label,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Submit button fixed
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  widget.submitButtonText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper function để tạo popup dễ dàng
void showPermissionPopup({
  required BuildContext context,
  required List<PermissionCategory> categories,
  String title = "Thiết lập quyền",
  String submitButtonText = "Submit",
  Function(List<PermissionCategory>)? onSubmit,
  VoidCallback? onClose,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => PopupSettingPermission(
          categories: categories,
          title: title,
          submitButtonText: submitButtonText,
          onSubmit: onSubmit,
          onClose: onClose,
        ),
  );
}
