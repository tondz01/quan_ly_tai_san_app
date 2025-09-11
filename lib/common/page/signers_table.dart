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

    return Table(
      columnWidths: {
        0: FixedColumnWidth(20 * scale),
        1: const IntrinsicColumnWidth(),
        2: const IntrinsicColumnWidth(),
        3: const IntrinsicColumnWidth(),
        4: const IntrinsicColumnWidth(),
        5: const IntrinsicColumnWidth(),
        6: const FlexColumnWidth(1),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        for (int i = 0; i < signers.length; i++)
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0 * scale),
                child: Text(
                  "${i + 1}.",
                  style: textStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0 * scale),
                child: Text(
                  "Ông (bà):",
                  style: textStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  0,
                  2.0 * scale,
                  gapAfterValue * scale,
                  2.0 * scale,
                ),
                child: Text(
                  signers[i].hoTen,
                  style: textStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0 * scale),
                child: Text(
                  "Chức vụ:",
                  style: textStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  0,
                  2.0 * scale,
                  gapAfterValue * scale,
                  2.0 * scale,
                ),
                child: Text(
                  signers[i].chucVu,
                  style: textStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0 * scale),
                child: Text(
                  "Đại diện:",
                  style: textStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0 * scale),
                child: Text(
                  signers[i].donVi,
                  style: textStyle,
                ),
              ),
            ],
          ),
      ],
    );
  }
} 