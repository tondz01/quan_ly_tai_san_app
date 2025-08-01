import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:se_gay_components/common/table/sg_table.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class MaterialTableWrapper<T> extends StatelessWidget {
  final List<SgTableColumn<T>> columns;
  final List<T> data;
  final String? searchTerm;
  final Function(T)? onRowTap;
  final Function(T)? onViewAction;
  final Function(T)? onEditAction;
  final Function(T)? onDeleteAction;
  final Function(List<T>)? onSelectionChanged;
  final bool Function(T)? onCustomFilter;
  final bool showCheckboxes;
  final bool showActions;
  final bool allowRowSelection;
  final double rowHeight;
  final EdgeInsetsGeometry? padding;
  final String? actionColumnTitle;
  final double? actionColumnWidth;
  final Color? actionViewColor;
  final Color? actionEditColor;
  final Color? actionDeleteColor;

  const MaterialTableWrapper({
    super.key,
    required this.columns,
    required this.data,
    this.searchTerm,
    this.onRowTap,
    this.onViewAction,
    this.onEditAction,
    this.onDeleteAction,
    this.onSelectionChanged,
    this.onCustomFilter,
    this.showCheckboxes = false,
    this.showActions = true,
    this.allowRowSelection = true,
    this.rowHeight = 56.0,
    this.padding,
    this.actionColumnTitle = 'Thao tác',
    this.actionColumnWidth = 160,
    this.actionViewColor,
    this.actionEditColor,
    this.actionDeleteColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ColorValue.neutral300.withOpacity(0.4),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: ColorValue.neutral200.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: padding ?? const EdgeInsets.all(16),
      child: SgTable<T>(
        headerBackgroundColor: ColorValue.primaryBlue,
        textHeaderColor: Colors.white,
        evenRowBackgroundColor: ColorValue.neutral50,
        oddRowBackgroundColor: Colors.white,
        selectedRowColor: ColorValue.primaryLightBlue.withOpacity(0.2),
        checkedRowColor: ColorValue.primaryLightBlue.withOpacity(0.1),
        gridLineColor: ColorValue.neutral200,
        gridLineWidth: 1.0,
        showVerticalLines: true,
        showHorizontalLines: true,
        allowRowSelection: allowRowSelection,
        searchTerm: searchTerm,
        rowHeight: rowHeight,
        showCheckboxes: showCheckboxes,
        onSelectionChanged: onSelectionChanged,
        customFilter: onCustomFilter,
        showActions: showActions,
        actionColumnTitle: actionColumnTitle,
        actionColumnWidth: actionColumnWidth,
        actionViewColor: actionViewColor ?? ColorValue.success,
        actionEditColor: actionEditColor ?? ColorValue.primaryBlue,
        actionDeleteColor: actionDeleteColor ?? ColorValue.error,
        onViewAction: onViewAction,
        onEditAction: onEditAction,
        onDeleteAction: onDeleteAction,
        columns: columns,
        data: data,
        onRowTap: onRowTap,
      ),
    );
  }
} 