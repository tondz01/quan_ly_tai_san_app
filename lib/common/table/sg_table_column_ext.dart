
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
    // Thêm các thuộc tính khác nếu cần
  }) {
    return SgTableColumn<T>(
      title: title ?? this.title,
      cellBuilder: cellBuilder ?? this.cellBuilder,
      cellAlignment: cellAlignment ?? this.cellAlignment,
      titleAlignment: titleAlignment ?? this.titleAlignment,
      width: width ?? this.width,
      searchable: searchable ?? this.searchable,
      // ... thêm các thuộc tính khác nếu cần ...
    );
  }
}
