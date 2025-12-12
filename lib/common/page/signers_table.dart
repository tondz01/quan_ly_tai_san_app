import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/model/signe_info.dart';

class SignersTable extends StatelessWidget {
  final List<SigneInfo> signers;
  final double scale;
  final TextStyle textStyle;
  final double gapAfterValue; // khoảng cách sau các giá trị để tách mục tiếp theo

  const SignersTable({
    super.key,
    required this.signers,
    required this.scale,
    required this.textStyle,
    this.gapAfterValue = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    if (signers.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 4.0 * scale),
        for (int i = 0; i < signers.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: 4.0 * scale),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 8.0 * scale),
                  child: Text(
                    "${i + 1}.",
                    style: textStyle,
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Table(
                          defaultVerticalAlignment: TableCellVerticalAlignment.top,
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.top,
                                  child: _buildInlineItem(label: "Ông (bà):", value: signers[i].hoTen),
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.top,
                                  child: _buildInlineItem(label: "Chức vụ:", value: signers[i].chucVu),
                                ),
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.top,
                                  child: _buildInlineItem(label: "Phòng:", value: signers[i].donVi),
                                ),
                              ],
                            ),
                          ],
                        ),
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

  Widget _buildInlineItem({required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textStyle,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: textStyle,
            softWrap: true,
          ),
        ),
      ],
    );
  }
} 