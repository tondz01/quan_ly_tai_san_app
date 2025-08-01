import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';

class RecentActivitiesWidget extends StatelessWidget {
  const RecentActivitiesWidget({super.key});

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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.history,
                color: ColorValue.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Hoạt động gần đây',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ColorValue.neutral900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildActivityList(),
        ],
      ),
    );
  }

  Widget _buildActivityList() {
    final activities = [
      ActivityItem(
        title: 'Thêm tài sản mới',
        description: 'Laptop Dell XPS 13 đã được thêm vào hệ thống',
        time: '2 phút trước',
        icon: Icons.add_circle,
        color: ColorValue.success,
      ),
      ActivityItem(
        title: 'Chuyển giao tài sản',
        description: 'Máy in HP đã được chuyển từ IT sang Marketing',
        time: '15 phút trước',
        icon: Icons.swap_horiz,
        color: ColorValue.primaryBlue,
      ),
      ActivityItem(
        title: 'Bảo trì tài sản',
        description: 'Điều hòa Daikin đang được bảo trì định kỳ',
        time: '1 giờ trước',
        icon: Icons.build,
        color: ColorValue.warning,
      ),
      ActivityItem(
        title: 'Cập nhật thông tin',
        description: 'Thông tin nhân viên Nguyễn Văn A đã được cập nhật',
        time: '2 giờ trước',
        icon: Icons.edit,
        color: ColorValue.info,
      ),
      ActivityItem(
        title: 'Tạo báo cáo',
        description: 'Báo cáo tài sản tháng 3/2024 đã được tạo',
        time: '3 giờ trước',
        icon: Icons.assessment,
        color: ColorValue.accentCyan,
      ),
    ];

    return Column(
      children: activities.map((activity) => _buildActivityItem(activity)).toList(),
    );
  }

  Widget _buildActivityItem(ActivityItem activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: activity.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              activity.icon,
              color: activity.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ColorValue.neutral900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorValue.neutral600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            activity.time,
            style: TextStyle(
              fontSize: 11,
              color: ColorValue.neutral500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityItem {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color color;

  ActivityItem({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
  });
} 