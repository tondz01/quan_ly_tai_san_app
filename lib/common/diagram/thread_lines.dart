import 'package:flutter/material.dart';

class ThreadNode {
  final String header;
  final int depth;

  const ThreadNode({required this.header, required this.depth});
}

class ThreadList extends StatelessWidget {
  final List<ThreadNode> nodes;
  final double indentWidth;
  final Color lineColor;
  final EdgeInsets itemMargin;
  final Widget? child;
  const ThreadList({
    super.key,
    required this.nodes,
    this.indentWidth = 24,
    this.lineColor = const Color(0xFFBDBDBD),
    this.itemMargin = const EdgeInsets.symmetric(vertical: 8),
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: nodes.length,
      itemBuilder: (context, index) {
        final node = nodes[index];
        return _ThreadRow(
          depth: node.depth,
          indentWidth: indentWidth,
          lineColor: lineColor,
          itemMargin: itemMargin,
          child: _ContentBubble(
            text: node.header,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}

class _ThreadRow extends StatelessWidget {
  final int depth;
  final double indentWidth;
  final Color lineColor;
  final EdgeInsets itemMargin;
  final Widget child;

  const _ThreadRow({
    required this.depth,
    required this.indentWidth,
    required this.lineColor,
    required this.itemMargin,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (depth <= 0) return Container(margin: itemMargin, child: child);
    final double gutterWidth =
        depth * indentWidth + 12; // khoảng cách rất sát item
    return CustomPaint(
      foregroundPainter: _ThreadLinePainter(
        depth: depth,
        indentWidth: indentWidth,
        color: lineColor,
        gutterWidth: gutterWidth,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: gutterWidth),
        child: Container(margin: itemMargin, child: child),
      ),
    );
  }
}

class _ContentBubble extends StatelessWidget {
  final String text;
  final Widget? child;
  const _ContentBubble({required this.text, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class _ThreadLinePainter extends CustomPainter {
  final int depth;
  final double indentWidth;
  final Color color;
  final double gutterWidth;

  _ThreadLinePainter({
    required this.depth,
    required this.indentWidth,
    required this.color,
    required this.gutterWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final double bubbleEdgeX = gutterWidth - 6; // sát cạnh trái item (~6px đệm)
    final double centerY = size.height * 0.5;

    for (int i = 1; i <= depth; i++) {
      final double x = i * indentWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    final double currentX = depth * indentWidth;
    canvas.drawLine(
      Offset(currentX, centerY),
      Offset(bubbleEdgeX, centerY),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ThreadLinePainter oldDelegate) {
    return oldDelegate.depth != depth ||
        oldDelegate.indentWidth != indentWidth ||
        oldDelegate.color != color ||
        oldDelegate.gutterWidth != gutterWidth;
  }
}
