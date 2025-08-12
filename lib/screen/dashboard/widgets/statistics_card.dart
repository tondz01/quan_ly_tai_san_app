import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';

class StatisticsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? trend;
  final bool? trendUp;
  final Color? backgroundColor;

  const StatisticsCard({super.key, required this.title, required this.value, required this.icon, required this.color, this.trend, this.trendUp, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? ColorValue.backgroundBG4,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 24),
              ),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (trendUp ?? true) ? ColorValue.success.withOpacity(0.1) : ColorValue.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon((trendUp ?? true) ? Icons.trending_up : Icons.trending_down, size: 12, color: (trendUp ?? true) ? ColorValue.success : ColorValue.error),
                      const SizedBox(width: 4),
                      Text(trend!, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: (trendUp ?? true) ? ColorValue.success : ColorValue.error)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: ColorValue.neutral900)),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 14, color: ColorValue.neutral600, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
