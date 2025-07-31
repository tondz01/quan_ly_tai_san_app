// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/index.dart';
import 'package:se_gay_components/common/table/sg_table.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

Widget movementDetailTable<AssetTransferDto>({
  required List<SgTableColumn<AssetTransferDto>> columns,
  required List<AssetTransferDto> data,
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
    child: SgTable<AssetTransferDto>(
      rowHeight: 45.0,
      data: data,
      titleStyleHeader: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 13,
        color: Colors.black87,
      ),
      rowHoverColor: ColorValue.accentLightCyan,
      rowHoverDuration: const Duration(milliseconds: 100),
      headerBackgroundColor: Colors.grey.shade100,
      oddRowBackgroundColor: Colors.white,
      evenRowBackgroundColor: Colors.grey.shade50,
      selectedRowColor: Colors.grey.shade100,
      showVerticalLines: false,
      showHorizontalLines: true,
      columns: columns,
    ),
  );
}
