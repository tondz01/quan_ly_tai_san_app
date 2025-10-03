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
        for (int i = 0; i < signers.length; i++)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0 * scale),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLine(label: "Ông (bà):", value: signers[i].hoTen),
                      SizedBox(height: 2.0 * scale),
                      _buildLine(label: "Chức vụ:", value: signers[i].chucVu),
                      SizedBox(height: 2.0 * scale),
                      _buildLine(label: "Đại diện:", value: signers[i].donVi),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildLine({required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 6.0 * scale),
          child: Text(
            label,
            style: textStyle,
          ),
        ),
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