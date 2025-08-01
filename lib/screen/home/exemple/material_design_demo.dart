import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';

class MaterialDesignDemo extends StatefulWidget {
  const MaterialDesignDemo({super.key});

  @override
  State<MaterialDesignDemo> createState() => _MaterialDesignDemoState();
}

class _MaterialDesignDemoState extends State<MaterialDesignDemo> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Design Demo'),
        backgroundColor: Colors.white,
        foregroundColor: ColorValue.neutral900,
        elevation: 0,
      ),
      body: Container(
        color: ColorValue.neutral50,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Field Demo
              MaterialCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search Field',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorValue.neutral900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    MaterialSearchField(
                      controller: _searchController,
                      hintText: 'Tìm kiếm sản phẩm...',
                      onChanged: (value) {
                        print('Search: $value');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Buttons Demo
              MaterialCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Buttons',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorValue.neutral900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        MaterialTextButton(
                          text: 'Primary Button',
                          icon: Icons.add,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Primary button pressed')),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        MaterialOutlinedButton(
                          text: 'Secondary Button',
                          icon: Icons.edit,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Secondary button pressed')),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        MaterialIconButton(
                          icon: Icons.settings,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Settings button pressed')),
                            );
                          },
                          tooltip: 'Settings',
                        ),
                        const SizedBox(width: 8),
                        MaterialIconButton(
                          icon: Icons.notifications,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Notifications button pressed')),
                            );
                          },
                          tooltip: 'Notifications',
                        ),
                        const SizedBox(width: 8),
                        MaterialIconButton(
                          icon: Icons.help,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Help button pressed')),
                            );
                          },
                          tooltip: 'Help',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Status Badges Demo
              MaterialCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status Badges',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorValue.neutral900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        MaterialStatusBadge.success(text: 'Thành công'),
                        MaterialStatusBadge.processing(text: 'Đang xử lý'),
                        MaterialStatusBadge.warning(text: 'Cảnh báo'),
                        MaterialStatusBadge.error(text: 'Lỗi'),
                        MaterialStatusBadge.pending(text: 'Chờ xử lý'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Chips Demo
              MaterialCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chips',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorValue.neutral900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        MaterialChip(
                          label: 'Tài sản',
                          icon: Icons.inventory,
                          selected: true,
                        ),
                        MaterialChip(
                          label: 'Nhân viên',
                          icon: Icons.people,
                        ),
                        MaterialChip(
                          label: 'Dự án',
                          icon: Icons.work,
                        ),
                        MaterialChip(
                          label: 'Báo cáo',
                          icon: Icons.assessment,
                          onDeleted: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Chip deleted')),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // User Avatar Demo
              MaterialCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Avatars',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorValue.neutral900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        MaterialUserAvatar(
                          name: 'Nguyễn Văn A',
                          size: 40,
                        ),
                        const SizedBox(width: 16),
                        MaterialUserAvatar(
                          name: 'Trần Thị B',
                          size: 50,
                        ),
                        const SizedBox(width: 16),
                        MaterialUserAvatar(
                          name: 'Lê Văn C',
                          size: 60,
                        ),
                        const SizedBox(width: 16),
                        MaterialUserAvatar(
                          imageUrl: 'https://i.pravatar.cc/150?img=3',
                          name: 'User with Image',
                          size: 50,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Info Cards Demo
              MaterialCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Info Cards',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorValue.neutral900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: MaterialCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.inventory,
                                      color: ColorValue.primaryBlue,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Tổng tài sản',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: ColorValue.neutral700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '1,234',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: ColorValue.neutral900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: MaterialCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.people,
                                      color: ColorValue.success,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Nhân viên',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: ColorValue.neutral700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '56',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: ColorValue.neutral900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
} 