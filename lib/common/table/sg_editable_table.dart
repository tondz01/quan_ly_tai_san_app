import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_input_text.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:quan_ly_tai_san_app/common/table/table_utils.dart';
import 'package:se_gay_components/common/sg_dropdown_input_button.dart';

// Add sort direction enum
enum SortDirection { none, ascending, descending }

// Add editor type enum for editable cells
enum EditableCellEditor { text, dropdown }

class SgEditableTable<T> extends StatefulWidget {
  final List<SgEditableColumn<T>> columns;
  final List<T> initialData;
  final double rowHeight;
  final Color? textHeaderColor;
  final Color headerBackgroundColor;
  final Color oddRowBackgroundColor;
  final Color evenRowBackgroundColor;
  final Color selectedRowColor;
  final Color gridLineColor;
  final double gridLineWidth;
  final bool showVerticalLines;
  final bool showHorizontalLines;
  final String addRowText;
  final Function(List<T>)? onDataChanged;
  final T Function() createEmptyItem;
  final bool isEditing; // Add isEditing property
  final double?
  omittedSize; // kích thước sẽ bị lược bỏ khi tính adjustColumnWidths
  // NEW: Per-row editable settings
  final bool defaultRowEditable;
  final bool Function(T item, int rowIndex)? rowEditableDecider;

  const SgEditableTable({
    super.key,
    required this.columns,
    required this.initialData,
    required this.createEmptyItem,
    this.rowHeight = 48.0,
    this.textHeaderColor,
    this.headerBackgroundColor = SGAppColors.neutral100,
    this.oddRowBackgroundColor = Colors.white,
    this.evenRowBackgroundColor = SGAppColors.neutral200,
    this.selectedRowColor = SGAppColors.info100,
    this.gridLineColor = SGAppColors.neutral200,
    this.gridLineWidth = 1.0,
    this.showVerticalLines = true,
    this.showHorizontalLines = true,
    this.addRowText = 'Thêm một dòng',
    this.onDataChanged,
    this.isEditing = true, // Default to true for backward compatibility
    this.defaultRowEditable = true,
    this.rowEditableDecider,
    this.omittedSize,
  });

  @override
  State<SgEditableTable<T>> createState() => SgEditableTableState<T>();
}

class SgEditableTableState<T> extends State<SgEditableTable<T>> {
  late List<T> _tableData;
  int? _selectedRowIndex;
  Map<int, Map<String, TextEditingController>> _controllers = {};
  // NEW: track per-row editable flags
  Map<int, bool> _rowEditableFlags = {};

  // Add sorting state variables
  int? _sortColumnIndex;
  SortDirection _sortDirection = SortDirection.none;

  @override
  void initState() {
    super.initState();
    _tableData = List.from(widget.initialData);
    _initControllers();
  }

  void _initControllers() {
    _controllers.clear();
    _rowEditableFlags.clear();
    for (int i = 0; i < _tableData.length; i++) {
      _initRowControllers(i);
      _initRowEditableFlag(i);
    }
  }

  void _initRowControllers(int rowIndex) {
    final item = _tableData[rowIndex];
    _controllers[rowIndex] = {};

    for (var column in widget.columns) {
      if (column.isEditable) {
        final value = column.getValueWithIndex?.call(item, rowIndex) ?? column.getValue(item);
        final controller = TextEditingController(text: value?.toString() ?? '');
        _controllers[rowIndex]![column.field] = controller;
      }
    }
  }

  void _initRowEditableFlag(int rowIndex) {
    final item = _tableData[rowIndex];
    final editable =
        widget.rowEditableDecider?.call(item, rowIndex) ??
        widget.defaultRowEditable;
    _rowEditableFlags[rowIndex] = editable;
  }

  @override
  void didUpdateWidget(SgEditableTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialData != oldWidget.initialData) {
      setState(() {
        _tableData = List.from(widget.initialData);
        _initControllers();
      });
    }
  }

  @override
  void dispose() {
    // Dispose all text controllers
    for (var rowControllers in _controllers.values) {
      for (var controller in rowControllers.values) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void _addRow() {
    setState(() {
      final newItem = widget.createEmptyItem();
      _tableData.add(newItem);
      final newIndex = _tableData.length - 1;
      _initRowControllers(newIndex);
      // Set editable flag for new row
      _rowEditableFlags[newIndex] =
          widget.rowEditableDecider?.call(newItem, newIndex) ??
          widget.defaultRowEditable;
    });
    _notifyDataChanged();
  }

  void _removeRow(int index) {
    // Dispose controllers for the row being removed
    final rowControllers = _controllers[index];
    if (rowControllers != null) {
      for (var controller in rowControllers.values) {
        controller.dispose();
      }
    }

    setState(() {
      _tableData.removeAt(index);

      // Rebuild controllers with updated indices
      final newControllers = <int, Map<String, TextEditingController>>{};
      final newEditableFlags = <int, bool>{};
      for (int i = 0; i < _tableData.length; i++) {
        if (i < index) {
          newControllers[i] = _controllers[i] ?? {};
          newEditableFlags[i] =
              _rowEditableFlags[i] ?? widget.defaultRowEditable;
        } else {
          final oldIndex = i + 1;
          if (_controllers.containsKey(oldIndex)) {
            newControllers[i] = _controllers[oldIndex] ?? {};
          } else {
            _initRowControllers(i);
            newControllers[i] = _controllers[i] ?? {};
          }
          if (_rowEditableFlags.containsKey(oldIndex)) {
            newEditableFlags[i] =
                _rowEditableFlags[oldIndex] ?? widget.defaultRowEditable;
          } else {
            newEditableFlags[i] =
                widget.rowEditableDecider?.call(_tableData[i], i) ??
                widget.defaultRowEditable;
          }
        }
      }
      _controllers = newControllers;
      _rowEditableFlags = newEditableFlags;
    });
    _notifyDataChanged();
  }

  void _updateCellValue(int rowIndex, String field, dynamic value) {
    _setCellValue(rowIndex, field, value);
  }

  // Safely set a cell value in data and sync controller text
  void _setCellValue(int rowIndex, String field, dynamic value) {
    final column = widget.columns.firstWhere((c) => c.field == field);
    column.setValue(_tableData[rowIndex], value);
    // Sync controller if exists
    final controller = _controllers[rowIndex]?[field];
    if (controller != null && controller.text != (value?.toString() ?? '')) {
      log('_setCellValue: Setting controller.text to: ${value?.toString() ?? ''}');
      controller.text = value?.toString() ?? '';
    }
    setState(() {});
    _notifyDataChanged();
  }

  // Add sorting methods
  void _sortData() {
    if (_sortColumnIndex == null ||
        _sortDirection == SortDirection.none ||
        _sortColumnIndex! >= widget.columns.length ||
        widget.columns[_sortColumnIndex!].sortValueGetter == null) {
      return;
    }

    setState(() {
      final sortValueGetter =
          widget.columns[_sortColumnIndex!].sortValueGetter!;

      _tableData.sort((a, b) {
        final aValue = sortValueGetter(a);
        final bValue = sortValueGetter(b);

        if (aValue == null && bValue == null) return 0;
        if (aValue == null) {
          return _sortDirection == SortDirection.ascending ? -1 : 1;
        }
        if (bValue == null) {
          return _sortDirection == SortDirection.ascending ? 1 : -1;
        }

        int comparison;
        if (aValue is String && bValue is String) {
          comparison = aValue.toLowerCase().compareTo(bValue.toLowerCase());
        } else if (aValue is num && bValue is num) {
          comparison = aValue.compareTo(bValue);
        } else if (aValue is DateTime && bValue is DateTime) {
          comparison = aValue.compareTo(bValue);
        } else if (aValue is bool && bValue is bool) {
          comparison = aValue ? (bValue ? 0 : 1) : (bValue ? -1 : 0);
        } else {
          comparison = aValue.toString().compareTo(bValue.toString());
        }

        return _sortDirection == SortDirection.ascending
            ? comparison
            : -comparison;
      });

      // Rebuild controllers after sorting
      _initControllers();
    });

    _notifyDataChanged();
  }

  void _onSortColumn(int columnIndex) {
    if (widget.columns[columnIndex].sortValueGetter == null) return;

    setState(() {
      if (_sortColumnIndex == columnIndex) {
        if (_sortDirection == SortDirection.none) {
          _sortDirection = SortDirection.ascending;
        } else if (_sortDirection == SortDirection.ascending) {
          _sortDirection = SortDirection.descending;
        } else {
          _sortDirection = SortDirection.none;
        }
      } else {
        _sortColumnIndex = columnIndex;
        _sortDirection = SortDirection.ascending;
      }

      _sortData();
    });
  }

  Widget _buildSortIcon(int columnIndex) {
    if (_sortColumnIndex != columnIndex ||
        _sortDirection == SortDirection.none) {
      return const SizedBox.shrink();
    }

    return Icon(
      _sortDirection == SortDirection.ascending
          ? Icons.arrow_upward
          : Icons.arrow_downward,
      size: 16,
      color: Colors.grey[700],
    );
  }

  void _notifyDataChanged() {
    if (widget.onDataChanged != null) {
      widget.onDataChanged!(_tableData);
    }
  }

  // Public API: set row editable flag
  void setRowEditable(int rowIndex, bool editable) {
    if (rowIndex < 0 || rowIndex >= _tableData.length) return;
    setState(() {
      _rowEditableFlags[rowIndex] = editable;
    });
  }

  String exportToJson() {
    return jsonEncode(_tableData);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width - (widget.omittedSize ?? 0);
    final newWidths = adjustColumnWidths(
      originalWidths: {for (final col in widget.columns) col.title: col.width},
      minTableWidth: screenWidth,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTable(newWidths),
        const SizedBox(height: 8),
        _buildAddRowButton(),
      ],
    );
  }

  Widget _buildTable(Map<String, double> newWidths) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          _buildHeaderRow(newWidths),

          // Table rows
          ..._tableData.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isEven = index % 2 == 0;
            return _buildDataRow(item, index, isEven, newWidths);
          }),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(Map<String, double> newWidths) {
    return Container(
      height: widget.rowHeight,
      decoration: BoxDecoration(
        color: widget.headerBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: widget.gridLineColor,
            width: widget.gridLineWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          // Header cells with sorting capability
          ...widget.columns.asMap().entries.map((entry) {
            final index = entry.key;
            final column = entry.value;
            final hasSort = column.sortValueGetter != null;

            return _buildCell(
              child: InkWell(
                onTap: hasSort ? () => _onSortColumn(index) : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: SGText(
                          text: column.title,
                          fontWeight: FontWeight.bold,
                          textAlign: column.titleAlignment,
                          color: widget.textHeaderColor ?? Colors.black,
                        ),
                      ),
                      if (hasSort &&
                          _sortColumnIndex == index &&
                          _sortDirection != SortDirection.none)
                        _buildSortIcon(index),
                    ],
                  ),
                ),
              ),
              width: newWidths[column.title] ?? column.width,
            );
          }),
          // Action column for delete button - only show in edit mode
          if (widget.isEditing)
            _buildCell(
              child: const Center(
                child: SGText(text: '', fontWeight: FontWeight.bold),
              ),
              width: 50,
            ),
        ],
      ),
    );
  }

  Widget _buildDataRow(
    T item,
    int index,
    bool isEven,
    Map<String, double> newWidths,
  ) {
    final backgroundColor =
        _selectedRowIndex == index
            ? widget.selectedRowColor
            : isEven
            ? widget.evenRowBackgroundColor
            : widget.oddRowBackgroundColor;

    return Container(
      height: widget.rowHeight,
      decoration: BoxDecoration(
        color: backgroundColor,
        border:
            widget.showHorizontalLines
                ? Border(
                  bottom: BorderSide(
                    color: widget.gridLineColor,
                    width: widget.gridLineWidth,
                  ),
                )
                : null,
      ),
      child: Row(
        children: [
          // Data cells
          ...widget.columns.map(
            (column) => _buildCell(
              child:
                  _isCellEditable(item, index, column)
                      ? _buildEditableCell(item, index, column)
                      : _buildDisplayCell(item, column),
              width: newWidths[column.title] ?? column.width,
            ),
          ),
          // Delete button cell - only show when editing and row editable
          if (widget.isEditing && (_rowEditableFlags[index] ?? true))
            _buildCell(
              child: Center(
                child: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red.shade800,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => _removeRow(index),
                ),
              ),
              width: 50,
            ),
        ],
      ),
    );
  }

  bool _isCellEditable(T item, int rowIndex, SgEditableColumn<T> column) {
    if (!widget.isEditing) return false;
    if (!column.isEditable) return false;
    final byRow = _rowEditableFlags[rowIndex] ?? true;
    final byColumn = column.isCellEditableDecider?.call(item, rowIndex);
    if (byColumn == null) return byRow;
    return byRow && byColumn;
  }

  Widget _buildEditableCell(T item, int rowIndex, SgEditableColumn<T> column) {
    final controller =
        _controllers[rowIndex]?[column.field] ?? TextEditingController();

    if (column.editor == EditableCellEditor.dropdown) {
      final currentValue = column.getValueWithIndex?.call(item, rowIndex) ?? column.getValue(item);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: SGDropdownInputButton<T>(
          height: 40,
          controller: controller,
          value: currentValue,
          defaultValue: currentValue,
          items: column.dropdownItems ?? [],
          showUnderlineBorderOnly: true,
          isClearController: false,
          fontSize: 14,
          inputType: column.inputType ?? TextInputType.text,
          isShowSuffixIcon: true,
          hintText: '',
          textAlign: TextAlign.left,
          textAlignItem: TextAlign.left,
          sizeBorderCircular: 6,
          contentPadding: const EdgeInsets.only(
            top: 4,
            bottom: 4,
            left: 6,
            right: 6,
          ),
          onChanged: (value) {
            if (value != null) {
              _updateCellValue(rowIndex, column.field, value);
              // cascade updates
              final updater = column.onValueChanged;
              if (updater != null) {
                updater(item, rowIndex, value, (
                  String targetField,
                  dynamic targetValue,
                ) {
                  if (targetField == column.field) return; // avoid recursion
                  _setCellValue(rowIndex, targetField, targetValue);
                });
              }
            }
          },
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SGInputText(
          controller: controller,
          height: 32,
          inputFormatters:
              column.inputType == TextInputType.number
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : null,
          borderRadius: 10,
          enabled: widget.isEditing,
          onlyLine: true,
          showBorder: false,
          hintText: 'Nhập thông tin',
          onChanged: (value) {
            setState(() {
              // controller.text = value;
              controller.text = column.getValue(item).toString();
              log('message onChanged: ${column.getValue(item)}');
              log('message onChanged2: ${controller.text}');
              _updateCellValue(rowIndex, column.field, value);
              // cascade updates
              final updater = column.onValueChanged;
              if (updater != null) {
                updater(item, rowIndex, value, (
                  String targetField,
                  dynamic targetValue,
                ) {
                  if (targetField == column.field) return; // avoid recursion
                  _setCellValue(rowIndex, targetField, targetValue);
                });
              }
            });
          },
        ),
        if (column.errorText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              "*${column.errorText}",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildDisplayCell(T item, SgEditableColumn<T> column) {
    // Try to get rowIndex for display cell
    final rowIndex = _tableData.indexOf(item);
    final value = column.getValueWithIndex?.call(item, rowIndex) ?? column.getValue(item);

    return Tooltip(
      message: column.tooltip ?? 'Không thể nhập',
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Align(
          alignment:
              column.cellAlignment == TextAlign.center
                  ? Alignment.center
                  : column.cellAlignment == TextAlign.right
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
          child: TextField(
            enabled: false,
            controller: TextEditingController(text: value?.toString() ?? ''),
            style: TextStyle(fontSize: 14),
            readOnly: true,
            decoration: InputDecoration(
              isDense: false,
              filled: true,
              fillColor: Colors.transparent,
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: SGAppColors.colorBorderGray,
                  width: 1,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: SGAppColors.colorBorderGray,
                  width: 1,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: SGAppColors.colorBorderGray,
                  width: 1,
                ),
              ),
              suffixIcon: null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCell({
    required Widget child,
    required double width,
    bool isLast = false,
  }) {
    return Container(
      width: width,
      height: widget.rowHeight,
      decoration:
          widget.showVerticalLines && !isLast
              ? BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: widget.gridLineColor,
                    width: widget.gridLineWidth,
                  ),
                ),
              )
              : null,
      child: child,
    );
  }

  Widget _buildAddRowButton() {
    if (!widget.isEditing) {
      return const SizedBox.shrink(); // Hide when not in edit mode
    }

    return SizedBox(
      height: 36,
      child: TextButton.icon(
        onPressed: _addRow,
        icon: const Icon(Icons.add, size: 18),
        label: Text(widget.addRowText),
        style: TextButton.styleFrom(
          foregroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}

class SgEditableColumn<T> {
  final String field;
  final String title;
  final String? tooltip;
  final double width;
  final TextAlign titleAlignment;
  final TextAlign cellAlignment;
  final bool isEditable;
  final dynamic Function(T) getValue;
  final dynamic Function(T, int)? getValueWithIndex; // NEW: getValue with rowIndex
  final void Function(T, dynamic) setValue;
  final dynamic Function(T)? sortValueGetter;
  final bool Function(T item, int rowIndex)? isCellEditableDecider;
  final TextInputType? inputType;
  final String errorText;
  // NEW: editor type and dropdown config
  final EditableCellEditor editor;
  final List<DropdownMenuItem<T>>? dropdownItems;
  // NEW: cascade update callback when value changes
  final void Function(
    T item,
    int rowIndex,
    dynamic newValue,
    void Function(String targetField, dynamic targetValue) updateRow,
  )?
  onValueChanged;

  SgEditableColumn({
    required this.field,
    required this.title,
    this.tooltip,
    required this.width,
    this.titleAlignment = TextAlign.left,
    this.cellAlignment = TextAlign.left,
    this.isEditable = true,
    required this.getValue,
    this.getValueWithIndex, // NEW: optional parameter
    required this.setValue,
    this.sortValueGetter,
    this.isCellEditableDecider,
    this.editor = EditableCellEditor.text,
    this.dropdownItems,
    this.onValueChanged,
    this.inputType,
    this.errorText = '',
  });
}
