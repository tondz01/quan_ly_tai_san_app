import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/widgets/dashboard_card.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/widgets/statistics_card.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/widgets/recent_activities.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/widgets/quick_actions.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/widgets/chart_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorValue.neutral50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            _buildHeader(),
            const SizedBox(height: 24),
            
            // Statistics cards
            _buildStatisticsSection(),
            const SizedBox(height: 24),
            
            // Main content grid
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // Quick actions
                      QuickActionsWidget(),
                      const SizedBox(height: 24),
                      
                      // Recent activities
                      RecentActivitiesWidget(),
                    ],
                  ),
                ),
                
                const SizedBox(width: 24),
                
                // Right column
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      // Chart widget
                      ChartWidget(),
                      const SizedBox(height: 24),
                      
                      // Asset status
                      _buildAssetStatusCard(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorValue.primaryLightBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.dashboard,
              color: ColorValue.primaryBlue,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tổng quan hệ thống',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: ColorValue.neutral900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Quản lý tài sản và theo dõi hoạt động',
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorValue.neutral600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Hôm nay',
                style: TextStyle(
                  fontSize: 14,
                  color: ColorValue.neutral600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getCurrentDate(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ColorValue.neutral900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        StatisticsCard(
          title: 'Tổng tài sản',
          value: '1,234',
          icon: Icons.inventory,
          color: ColorValue.primaryBlue,
          trend: '+12%',
          trendUp: true,
        ),
        StatisticsCard(
          title: 'Đang sử dụng',
          value: '987',
          icon: Icons.check_circle,
          color: ColorValue.success,
          trend: '+8%',
          trendUp: true,
        ),
        StatisticsCard(
          title: 'Bảo trì',
          value: '45',
          icon: Icons.build,
          color: ColorValue.warning,
          trend: '-3%',
          trendUp: false,
        ),
        StatisticsCard(
          title: 'Ngừng sử dụng',
          value: '23',
          icon: Icons.cancel,
          color: ColorValue.error,
          trend: '-5%',
          trendUp: false,
        ),
      ],
    );
  }

  Widget _buildAssetStatusCard() {
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
                Icons.pie_chart,
                color: ColorValue.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Trạng thái tài sản',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ColorValue.neutral900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildStatusItem('Đang sử dụng', 80, ColorValue.success),
          const SizedBox(height: 12),
          _buildStatusItem('Bảo trì', 15, ColorValue.warning),
          const SizedBox(height: 12),
          _buildStatusItem('Ngừng sử dụng', 5, ColorValue.error),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label, double percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ColorValue.neutral700,
              ),
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: ColorValue.neutral200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6',
      'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }
} 