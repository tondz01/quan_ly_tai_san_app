// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/button/action_button_config.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:se_gay_components/common/table/sg_table.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

abstract class TableBaseConfig {
  static Widget tableBase<T>({
    required List<SgTableColumn<T>> columns,
    required List<T> data,
    String? searchTerm,
    Function(T item)? onRowTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SgTable<T>(
        rowHeight: 45.0,
        data: data,
        titleStyleHeader: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: Colors.black87,
        ),
        searchTerm: searchTerm,
        rowHoverColor: ColorValue.accentLightCyan,
        rowHoverDuration: const Duration(milliseconds: 10),
        headerBackgroundColor: Colors.grey.shade100,
        oddRowBackgroundColor: Colors.white,
        evenRowBackgroundColor: Colors.grey.shade50,
        selectedRowColor: ColorValue.accentLightCyan,
        showCheckboxes : true,
        showVerticalLines: false,
        showHorizontalLines: true,
        columns: columns,
        onRowTap: onRowTap
      ),
    );
  }

  Widget viewActionBase<T>(
    T item, {
    bool isDisableDelete = false,
    Function(T item)? onView,
    Function(T item)? onEdit,
    Function(T item)? onDelete,
  }) {
    return viewActionButtons([
      ActionButtonConfig(
        icon: Icons.edit,
        tooltip: 'Sửa',
        iconColor: Colors.orange,
        backgroundColor: Colors.orange.shade50,
        onPressed: () => onEdit?.call(item),
      ),
      ActionButtonConfig(
        icon: Icons.visibility,
        tooltip: 'Xem',
        iconColor: Colors.blue,
        backgroundColor: Colors.blue.shade50,
        onPressed: () => onView?.call(item),
      ),
      ActionButtonConfig(
        icon: Icons.delete,
        tooltip: isDisableDelete ? null : 'Xóa',
        iconColor: isDisableDelete ? Colors.grey : Colors.red,
        backgroundColor: Colors.red.shade50,
        onPressed: isDisableDelete ? null : () => onDelete?.call(item),
        isDisabled: isDisableDelete,
      ),
    ]);
  }

  static SgTableColumn<T> columnTable<T>({
    required String title,
    required double width,
    required String Function(T) getValue,
    double fontSize = 12,
    Color textColor = Colors.black87,
    TextAlign? titleAlignment = TextAlign.center,
    bool searchable = false,
  }) {
    return TableColumnBuilder.createTextColumn<T>(
      title: title,
      textColor: textColor,
      getValue: getValue,
      fontSize: fontSize,
      width: width,
      searchable: searchable,
    );
  }

  static SgTableColumn<T> columnWidgetBase<T>({
    required String title,
    required double width,
    required Widget Function(T) cellBuilder,
    String Function(T)? sortValueGetter,
    String Function(T)? searchValueGetter,
    TextAlign? cellAlignment,
    TextAlign? titleAlignment,
    bool? searchable = false,
  }) {
    return SgTableColumn<T>(
      title: title,
      cellBuilder: cellBuilder,
      sortValueGetter: sortValueGetter ?? (item) => '',
      searchValueGetter: searchValueGetter ?? (item) => '',
      cellAlignment: cellAlignment ?? TextAlign.center,
      titleAlignment: titleAlignment ?? TextAlign.center,
      width: width,
      searchable: searchable ?? false,
    );
  }
}
