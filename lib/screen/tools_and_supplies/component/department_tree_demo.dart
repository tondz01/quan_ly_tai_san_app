import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/diagram/department_tree.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';

class DepartmentTreeDemo extends StatelessWidget {
  final String title;
  final ToolsAndSuppliesDto? data;
  const DepartmentTreeDemo({
    super.key,
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final rootComments = [
      TreeNode(
        name: data?.ten ?? "Công cụ ...",
        message: "Số lượng: ${data?.soLuong ?? 0}",
        children: [
          TreeNode(name: "Kho công ty", message: "Số lượng: 3"),
          TreeNode(name: "Ban giam đốc", message: "Số lượng: 2"),
          TreeNode(name: "Phòng kế toán", message: "Số lượng: 5"),
        ],
      ),
    ];

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < rootComments.length; i++)
                  DepartmentTree(
                    node: rootComments[i],
                    isLast: i == rootComments.length - 1,
                    isFirst: i == 0,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
