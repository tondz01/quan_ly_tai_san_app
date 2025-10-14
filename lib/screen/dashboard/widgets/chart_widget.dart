import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';

class ChartWidget extends StatelessWidget {
  const ChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart, color: Colors.green.shade600, size: 16),
              const SizedBox(width: 6),
              Text(
                'Thống kê tài sản',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildChart(),
          const SizedBox(height: 12),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildChart() {
    return Container(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: _buildBar('T1', 80, Colors.green.shade500)),
          const SizedBox(width: 4),
          Expanded(child: _buildBar('T2', 65, Colors.green.shade500)),
          const SizedBox(width: 4),
          Expanded(child: _buildBar('T3', 90, Colors.green.shade500)),
          const SizedBox(width: 4),
          Expanded(child: _buildBar('T4', 75, Colors.green.shade500)),
          const SizedBox(width: 4),
          Expanded(child: _buildBar('T5', 85, Colors.green.shade500)),
          const SizedBox(width: 4),
          Expanded(child: _buildBar('T6', 70, Colors.green.shade500)),
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
        _buildLegendItem('Thiết bị điện tử', Colors.green.shade500, '45%'),
        const SizedBox(height: 4),
        _buildLegendItem('Máy móc', Colors.green.shade500, '30%'),
        const SizedBox(height: 4),
        _buildLegendItem('Nội thất', Colors.green.shade500, '15%'),
        const SizedBox(height: 4),
        _buildLegendItem('Phương tiện', Colors.green.shade500, '10%'),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, String percentage) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.green.shade600,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Text(
          percentage,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.green.shade700,
          ),
        ),
      ],
    );
  }
}
