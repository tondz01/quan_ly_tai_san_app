
import 'package:flutter/material.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

extension SgTableColumnCopyWith<T> on SgTableColumn<T> {
  SgTableColumn<T> copyWith({
    String? title,
    Widget Function(T)? cellBuilder,
    TextAlign? cellAlignment,
    TextAlign? titleAlignment,
    double? width,
    bool? searchable,
    bool? filterable,
    String Function(T)? searchValueGetter,
    dynamic Function(T)? sortValueGetter,
    // Thêm các thuộc tính khác nếu cần
  }) {
    return SgTableColumn<T>(
      title: title ?? this.title,
      cellBuilder: cellBuilder ?? this.cellBuilder,
      titleAlignment: titleAlignment ?? this.titleAlignment,
      width: width ?? this.width,
      cellAlignment: cellAlignment ?? this.cellAlignment,
      searchValueGetter: searchValueGetter ?? this.searchValueGetter,
      sortValueGetter: sortValueGetter ?? this.sortValueGetter,
      searchable: searchable ?? this.searchable,
      filterable: filterable ?? this.filterable,
      // ... thêm các thuộc tính khác nếu cần ...
    );
  }
}
