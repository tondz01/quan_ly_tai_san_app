import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/table/table_utils.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';
import 'package:quan_ly_tai_san_app/common/table/sg_table_column_ext.dart';

class TableBaseView<T> extends StatefulWidget {
  const TableBaseView({
    super.key,
    required this.searchTerm,
    required this.columns,
    required this.data,
    this.horizontalController,
    this.onRowTap,
  });
  final String searchTerm;
  final List<SgTableColumn<T>> columns;
  final List<T> data;
  final ScrollController? horizontalController;
  final Function(T item)? onRowTap;
  @override
  State<TableBaseView<T>> createState() => _TableBaseViewState<T>();
}

class _TableBaseViewState<T> extends State<TableBaseView<T>> {
  late final ScrollController _horizontalController;

  @override
  void initState() {
    super.initState();
    _horizontalController = widget.horizontalController ?? ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final newWidths = adjustColumnWidths(
      originalWidths: {
        for (final col in widget.columns) col.title: col.width ?? 0,
      },
      minTableWidth: screenWidth,
    );

    final newColumns = widget.columns
        .map((col) => col.copyWith(width: newWidths[col.title]))
        .toList();

    return Scrollbar(
      controller: _horizontalController,
      thumbVisibility: true,
      thickness: 4,
      notificationPredicate:
          (notification) => notification.metrics.axis == Axis.horizontal,
      child: SingleChildScrollView(
        controller: _horizontalController,
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: TableBaseConfig.tableBase<T>(
            columns: newColumns,
            data: widget.data,
            searchTerm: widget.searchTerm,
            onRowTap: (item) {
              widget.onRowTap?.call(item);
            },
          ),
        ),
      ),
    );
  }
}
