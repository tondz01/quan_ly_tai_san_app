import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/diagram/thread_lines.dart';
import 'package:se_gay_components/common/sg_text.dart';

class DepartmentTreeDemo extends StatelessWidget {
  final String title;
  final List<ThreadNode> sample;
  const DepartmentTreeDemo({
    super.key,
    required this.title,
    required this.sample,
  });

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
                  text: 'Chi tiết đơn vị sở hữu "$title"',
                  size: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ThreadList(
            nodes: sample,
            indentWidth: 28,
            lineColor: const Color(0xFF9E9E9E),
          ),
        ),
      ],
    );
  }
}
