import 'package:flutter/material.dart';

class TreeNode {
  final String name;
  final String message;
  final bool isFirst;
  final List<TreeNode> children;

  TreeNode({
    required this.name,
    required this.message,
    this.isFirst = true,
    this.children = const [],
  });
}

class DepartmentTree extends StatelessWidget {
  final TreeNode node;
  final bool isLast;
  final bool isFirst;

  const DepartmentTree({
    super.key,
    required this.node,
    this.isLast = true,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Cột để vẽ line dọc
        // Container(
        //   width: 20,
        //   child: Column(
        //     children: [
        //       Container(
        //         width: 2,
        //         // nếu có con thì để null + dùng IntrinsicHeight (bên dưới)
        //         color: isLast ? Colors.transparent : Colors.grey,
        //       ),
        //     ],
        //   ),
        // ),

        /// Nội dung + line ngang
        Flexible(
          fit: FlexFit.loose,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // line ngang
                  Visibility(
                    visible: !isFirst,
                    child: Container(
                      width: 20,
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: Container(height: 2, width: 15, color: Colors.grey),
                    ),
                  ),

                  // nội dung comment
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.only(left: 10, right: 6, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        spacing: 5,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            node.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(node.message),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              /// Render children
              if (node.children.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < node.children.length; i++)
                        DepartmentTree(
                          node: node.children[i],
                          isLast: i == node.children.length - 1,
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
