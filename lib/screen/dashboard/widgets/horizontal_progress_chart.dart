import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';

class HorizontalProgressChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String labelKey;
  final String valueKey;
  final String percentageKey;
  final List<Color>? colors;
  final double height;
  final bool showValues;
  final bool showPercentages;

  const HorizontalProgressChart({
    super.key,
    required this.data,
    this.labelKey = 'label',
    this.valueKey = 'value',
    this.percentageKey = 'percentage',
    this.colors,
    this.height = 200,
    this.showValues = true,
    this.showPercentages = true,
  });

  @override
  Widget build(BuildContext context) {
    final List<Color> resolvedColors = colors ?? _getDefaultColors();

    return Container(
      height: height,
      child: Column(
        children:
            data.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final label = item[labelKey]?.toString() ?? 'Không xác định';
              final value = (item[valueKey] as num?)?.toDouble() ?? 0.0;
              final percentage =
                  (item[percentageKey] as num?)?.toDouble() ?? 0.0;
              final color = resolvedColors[index % resolvedColors.length];

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildProgressItem(
                  label: label,
                  value: value,
                  percentage: percentage,
                  color: color,
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildProgressItem({
    required String label,
    required double value,
    required double percentage,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (showValues || showPercentages) ...[
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showValues) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: color.withOpacity(0.3)),
                      ),
                      child: Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                    if (showPercentages) const SizedBox(width: 8),
                  ],
                  if (showPercentages)
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 12,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(6),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }

  List<Color> _getDefaultColors() {
    return [
      ColorValue.primaryBlue,
      ColorValue.success,
      ColorValue.warning,
      ColorValue.error,
      ColorValue.accentCyan,
      ColorValue.info,
      Colors.purple,
      Colors.orange,
    ];
  }
}
