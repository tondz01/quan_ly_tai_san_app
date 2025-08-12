import 'package:flutter/material.dart';
import 'package:se_gay_components/common/switch/sg_checkbox.dart';
import '../../core/constants/app_colors.dart';

class ColumnDisplayOption {
  final String id;
  final String label;
  final bool isVisible;
  bool isChecked;
  final Function(bool?)? onChanged;

  ColumnDisplayOption({
    required this.id,
    required this.label,
    this.isVisible = true,
    this.isChecked = false,
    this.onChanged,
  });
}

class ColumnDisplayPopup extends StatefulWidget {
  final List<ColumnDisplayOption> columns;
  final Function(List<String> selectedColumns)? onSave;
  final VoidCallback? onCancel;
  final String title;
  final String selectAllText;
  final String saveText;
  final String cancelText;

  const ColumnDisplayPopup({
    super.key,
    required this.columns,
    this.onSave,
    this.onCancel,
    this.title = 'Tùy chỉnh hiển thị cột',
    this.selectAllText = 'Chọn tất cả',
    this.saveText = 'Lưu',
    this.cancelText = 'Hủy',
  });

  @override
  State<ColumnDisplayPopup> createState() => _ColumnDisplayPopupState();
}

class _ColumnDisplayPopupState extends State<ColumnDisplayPopup> {
  late List<ColumnDisplayOption> _columns;
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _columns = List.from(widget.columns);
    _updateSelectAllState();
  }

  void _updateSelectAllState() {
    final visibleColumns = _columns.where((col) => col.isVisible).toList();
    _selectAll =
        visibleColumns.isNotEmpty &&
        visibleColumns.every((col) => col.isChecked);
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      for (var column in _columns) {
        if (column.isVisible) {
          column.isChecked = _selectAll;
        }
      }
    });
  }

  void _toggleColumn(String columnId, bool? value) {
    setState(() {
      final column = _columns.firstWhere((col) => col.id == columnId);
      column.isChecked = value ?? false;
      _updateSelectAllState();
    });
  }

  void _handleSave() {
    final selectedColumns =
        _columns.where((col) => col.isChecked).map((col) => col.id).toList();
    widget.onSave?.call(selectedColumns);
    Navigator.of(context).pop();
  }

  void _handleCancel() {
    widget.onCancel?.call();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: UnconstrainedBox(
        alignment: Alignment.centerLeft,
        child: IntrinsicWidth(
          child: IntrinsicHeight(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header với icon và title
                  Row(
                    children: [
                      Icon(
                        Icons.settings,
                        color: ColorValue.primaryBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: ColorValue.primaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Danh sách các cột
                  SingleChildScrollView(child: _buildColumnLayout()),

                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Button Hủy
                      TextButton(
                        onPressed: _handleCancel,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          widget.cancelText,
                          style: const TextStyle(
                            color: ColorValue.primaryBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Button Lưu
                      ElevatedButton(
                        onPressed: _handleSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: ColorValue.primaryText,
                          side: const BorderSide(
                            color: ColorValue.neutral300,
                            width: 1,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          widget.saveText,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColumnLayout() {
    const int maxItemsPerColumn = 6;

    // Tạo danh sách tất cả items (bao gồm "Chọn tất cả")
    final List<Widget> allItems = [
      _buildColumnOption(
        id: 'select_all',
        label: widget.selectAllText,
        isChecked: _selectAll,
        onChanged: _toggleSelectAll,
        isSelectAll: true,
      ),
      const SizedBox(height: 12),
      ..._columns.where((col) => col.isVisible).map((column) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildColumnOption(
            id: column.id,
            label: column.label,
            isChecked: column.isChecked,
            onChanged: (value) => _toggleColumn(column.id, value),
          ),
        );
      }),
    ];

    // Tính số cột cần thiết
    final int totalItems = allItems.length;
    final int numberOfColumns = (totalItems / maxItemsPerColumn).ceil();

    // Nếu chỉ có 1 cột, hiển thị dạng Column
    if (numberOfColumns <= 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: allItems,
      );
    }

    // Nếu có nhiều cột, hiển thị dạng Row với các Column con
    return Row(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(numberOfColumns, (columnIndex) {
        final int startIndex = columnIndex * maxItemsPerColumn;
        final int endIndex = (columnIndex + 1) * maxItemsPerColumn;
        final List<Widget> columnItems = allItems.sublist(
          startIndex,
          endIndex > totalItems ? totalItems : endIndex,
        );

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: columnItems,
        );
      }),
    );
  }

  Widget _buildColumnOption({
    required String id,
    required String label,
    required bool isChecked,
    required Function(bool?)? onChanged,
    bool isSelectAll = false,
  }) {
    return SgCheckbox(
      value: isChecked,
      onChanged: onChanged,
      checkedColor: ColorValue.primaryBlue,
      uncheckedColor: Colors.white,
      // borderCheckedColor: isSelectAll ? ColorValue.primaryBlue : ColorValue.neutral400,
      borderRadius: 2,
      size: 16,
      text: label,
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: isSelectAll ? FontWeight.w600 : FontWeight.w400,
        color: isSelectAll ? ColorValue.primaryText : ColorValue.secondaryText,
      ),
    );
  }
}

/// Helper function để hiển thị popup
Future<List<String>?> showColumnDisplayPopup({
  required BuildContext context,
  required List<ColumnDisplayOption> columns,
  Function(List<String> selectedColumns)? onSave,
  VoidCallback? onCancel,
  String title = 'Tùy chỉnh hiển thị cột',
  String selectAllText = 'Chọn tất cả',
  String saveText = 'Lưu',
  String cancelText = 'Hủy',
}) async {
  List<String>? result;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => ColumnDisplayPopup(
          columns: columns,
          onSave: (selectedColumns) {
            result = selectedColumns;
            onSave?.call(selectedColumns);
          },
          onCancel: onCancel,
          title: title,
          selectAllText: selectAllText,
          saveText: saveText,
          cancelText: cancelText,
        ),
  );

  return result;
}
