import 'package:flutter/material.dart';

Map<String, double> adjustColumnWidths({
  required Map<String, double> originalWidths,
  required double minTableWidth,
}) {
  final totalWidth = originalWidths.values.fold(0.0, (a, b) => a + b);
  if (totalWidth >= minTableWidth) return originalWidths;

  final extra = minTableWidth - totalWidth;
  final keys = originalWidths.keys.toList();
  if (keys.isEmpty) return originalWidths;

  // Phân bổ đều phần dư cho các column
  final extraPerCol = extra / keys.length;
  return {for (final key in keys) key: originalWidths[key]! + extraPerCol};
}

TableRow headerRow(List<String> cells) {
  return TableRow(
    decoration: const BoxDecoration(color: Color(0xFFEFEFEF)),
    children:
        cells.map((text) {
          return Container(
            padding: const EdgeInsets.all(6),
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          );
        }).toList(),
  );
}

TableRow dataRow(List<String> cells) {
  return TableRow(
    children:
        cells.map((text) {
          return Container(
            padding: const EdgeInsets.all(6),
            height: 60,
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          );
        }).toList(),
  );
}
