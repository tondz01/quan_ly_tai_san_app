import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';

class ChartWidget extends StatelessWidget {
  const ChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorValue.neutral200.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bar_chart,
                color: ColorValue.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Thống kê tài sản',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ColorValue.neutral900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildChart(),
          const SizedBox(height: 20),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildChart() {
    return Container(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: _buildBar('T1', 80, ColorValue.primaryBlue),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildBar('T2', 65, ColorValue.success),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildBar('T3', 90, ColorValue.warning),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildBar('T4', 75, ColorValue.error),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildBar('T5', 85, ColorValue.accentCyan),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildBar('T6', 70, ColorValue.info),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double percentage, Color color) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.bottomCenter,
              heightFactor: percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: ColorValue.neutral600,
          ),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Column(
      children: [
        _buildLegendItem('Thiết bị điện tử', ColorValue.primaryBlue, '45%'),
        const SizedBox(height: 8),
        _buildLegendItem('Máy móc', ColorValue.success, '30%'),
        const SizedBox(height: 8),
        _buildLegendItem('Nội thất', ColorValue.warning, '15%'),
        const SizedBox(height: 8),
        _buildLegendItem('Phương tiện', ColorValue.error, '10%'),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, String percentage) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: ColorValue.neutral700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          percentage,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: ColorValue.neutral900,
          ),
        ),
      ],
    );
  }
} 