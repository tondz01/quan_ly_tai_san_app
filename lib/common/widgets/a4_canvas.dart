import 'dart:math' as math;
import 'package:flutter/material.dart';

class A4Canvas extends StatelessWidget {
  /// Chiều rộng A4 mm
  final double pageWidthMm;

  /// Chiều cao A4 mm
  final double pageHeightMm;

  /// Widget con (nội dung của bạn)
  final Widget child;

  /// Lề (mm)
  final EdgeInsets marginsMm;

  final double maxWidth;
  final double maxHeight;

  final double scale;

  const A4Canvas({
    super.key,
    this.pageWidthMm = 210,
    this.pageHeightMm = 297,
    this.marginsMm = const EdgeInsets.all(0),
    this.scale = 1.0,
    required this.child,
    required this.maxWidth,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    final aspectRatio = pageWidthMm / pageHeightMm;
    double w = maxWidth;
    double h = maxHeight;

    Size pageSize;
    if (w / h > aspectRatio) {
      // Fix theo chiều cao
      h = math.min(h, maxHeight) * scale;
      w = h * aspectRatio;
      pageSize = Size(w, h);
    } else {
      // Fix theo chiều rộng
      w = math.min(w, maxWidth) * scale;
      h = w / aspectRatio;
      pageSize = Size(w, h);
    }
    return Container(
      width: pageSize.width,
      height: pageSize.height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400, width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(2, 2))],
      ),
      padding: EdgeInsets.fromLTRB(
        marginsMm.left * pageSize.width / pageWidthMm,
        marginsMm.top * pageSize.height / pageHeightMm,
        marginsMm.right * pageSize.width / pageWidthMm,
        marginsMm.bottom * pageSize.height / pageHeightMm,
      ),
      child: child,
    );
  }
}
