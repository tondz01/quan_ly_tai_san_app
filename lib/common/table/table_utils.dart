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
  return {
    for (final key in keys)
      key: originalWidths[key]! + extraPerCol,
  };
}