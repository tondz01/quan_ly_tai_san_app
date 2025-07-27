import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_text.dart';

// Add sort direction enum
enum SortDirection { none, ascending, descending }

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
  });

  @override
  State<SgEditableTable<T>> createState() => SgEditableTableState<T>();
}

class SgEditableTableState<T> extends State<SgEditableTable<T>> {
  late List<T> _tableData;
  int? _selectedRowIndex;
  Map<int, Map<String, TextEditingController>> _controllers = {};

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
    for (int i = 0; i < _tableData.length; i++) {
      _initRowControllers(i);
    }
  }

  void _initRowControllers(int rowIndex) {
    final item = _tableData[rowIndex];
    _controllers[rowIndex] = {};

    for (var column in widget.columns) {
      if (column.isEditable) {
        final value = column.getValue(item);
        final controller = TextEditingController(text: value?.toString() ?? '');
        _controllers[rowIndex]![column.field] = controller;
      }
    }
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
      _initRowControllers(_tableData.length - 1);
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
      for (int i = 0; i < _tableData.length; i++) {
        if (i < index) {
          newControllers[i] = _controllers[i] ?? {};
        } else {
          final oldIndex = i + 1;
          if (_controllers.containsKey(oldIndex)) {
            newControllers[i] = _controllers[oldIndex] ?? {};
          } else {
            _initRowControllers(i);
            newControllers[i] = _controllers[i] ?? {};
          }
        }
      }
      _controllers = newControllers;
    });
    _notifyDataChanged();
  }

  void _updateCellValue(int rowIndex, String field, dynamic value) {
    widget.columns
        .firstWhere((column) => column.field == field)
        .setValue(_tableData[rowIndex], value);
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

  String exportToJson() {
    return jsonEncode(_tableData);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTable(),
        const SizedBox(height: 8),
        _buildAddRowButton(),
      ],
    );
  }

  Widget _buildTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          _buildHeaderRow(),

          // Table rows
          ..._tableData.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isEven = index % 2 == 0;
            return _buildDataRow(item, index, isEven);
          }),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
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
              width: column.width,
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

  Widget _buildDataRow(T item, int index, bool isEven) {
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
                  column.isEditable
                      ? _buildEditableCell(item, index, column)
                      : _buildDisplayCell(item, column),
              width: column.width,
            ),
          ),
          // Delete button cell - only show when editing
          if (widget.isEditing)
            _buildCell(
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red.shade800, size: 20),
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

  Widget _buildEditableCell(T item, int rowIndex, SgEditableColumn<T> column) {
    final controller =
        _controllers[rowIndex]?[column.field] ?? TextEditingController();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: widget.isEditing 
          ? TextField(
              controller: controller,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                // border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (value) {
                _updateCellValue(rowIndex, column.field, value);
              },
            )
          : Align(
              alignment: column.cellAlignment == TextAlign.center
                  ? Alignment.center
                  : column.cellAlignment == TextAlign.right
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
              child: Text(
                controller.text,
                style: const TextStyle(fontSize: 14),
              ),
            ),
    );
  }

  Widget _buildDisplayCell(T item, SgEditableColumn<T> column) {
    final value = column.getValue(item);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Align(
        alignment:
            column.cellAlignment == TextAlign.center
                ? Alignment.center
                : column.cellAlignment == TextAlign.right
                ? Alignment.centerRight
                : Alignment.centerLeft,
        child: Text(
          value?.toString() ?? '',
          style: const TextStyle(fontSize: 14),
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
    if (!widget.isEditing) return const SizedBox.shrink(); // Hide when not in edit mode
    
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
  final double width;
  final TextAlign titleAlignment;
  final TextAlign cellAlignment;
  final bool isEditable;
  final dynamic Function(T) getValue;
  final void Function(T, dynamic) setValue;
  // Add sort value getter similar to SgTable
  final dynamic Function(T)? sortValueGetter;

  SgEditableColumn({
    required this.field,
    required this.title,
    required this.width,
    this.titleAlignment = TextAlign.left,
    this.cellAlignment = TextAlign.left,
    this.isEditable = true,
    required this.getValue,
    required this.setValue,
    this.sortValueGetter,
  });
}
