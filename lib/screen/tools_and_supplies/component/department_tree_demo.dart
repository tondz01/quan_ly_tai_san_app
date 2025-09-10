import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/diagram/thread_lines.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:se_gay_components/common/sg_text.dart';

class DetailedDiagram extends StatefulWidget {
  final String title;
  final List<ThreadNode> sample;
  final Function()? onHiden;
  const DetailedDiagram({
    super.key,
    required this.title,
    required this.sample,
    this.onHiden,
  });

  @override
  State<DetailedDiagram> createState() => _DetailedDiagramState();
}

class _DetailedDiagramState extends State<DetailedDiagram> {
  @override
  void didUpdateWidget(covariant DetailedDiagram oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade600, width: 1),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
              SizedBox(width: 8),
              Expanded(
                child: SGText(
                  text: 'Chi tiết ${widget.title}',
                  size: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              InkWell(
                onTap: widget.onHiden,
                child: Icon(
                  Icons.visibility_off,
                  size: 16,
                  color: ColorValue.cyan,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ThreadList(
            nodes: widget.sample,
            indentWidth: 28,
            lineColor: const Color(0xFF9E9E9E),
          ),
        ),
      ],
    );
  }
}
