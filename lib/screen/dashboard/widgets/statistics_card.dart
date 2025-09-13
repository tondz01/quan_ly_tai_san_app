import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/theme/app_text_style.dart';
import 'package:se_gay_components/common/sg_text.dart';

class StatisticsCard extends StatelessWidget {
  final String title;
  final String value;
  final Color? backgroundColor;

  const StatisticsCard({
    super.key,
    required this.title,
    required this.value,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? ColorValue.backgroundBG4,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          SGText(text: title, style: AppTextStyle.textStyleRegular14),
          Row(
            spacing: 8,
            children: [
              SGText(text: value, style: AppTextStyle.textStyleSemiBold24.copyWith(height: 1.4)),
              Expanded(child: SizedBox.shrink()),
              // SGText(text: trend!, style: AppTextStyle.textStyleRegular12),
              // Icon((trendUp ?? true) ? Icons.trending_up : Icons.trending_down, size: 12, color: Colors.black),
            ],
          ),
        ],
      ),
    );
  }
}
