import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_table.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';

class MaterialTableDemo extends StatefulWidget {
  const MaterialTableDemo({super.key});

  @override
  State<MaterialTableDemo> createState() => _MaterialTableDemoState();
}

class _MaterialTableDemoState extends State<MaterialTableDemo> {
  final List<DemoData> _demoData = [
    DemoData(
      id: '1',
      name: 'Laptop Dell XPS 13',
      category: 'Thiết bị điện tử',
      status: 'active',
      assignedTo: 'Nguyễn Văn A',
      department: 'IT',
      purchaseDate: '2024-01-15',
      value: 25000000,
    ),
    DemoData(
      id: '2',
      name: 'Máy in HP LaserJet',
      category: 'Thiết bị văn phòng',
      status: 'maintenance',
      assignedTo: 'Trần Thị B',
      department: 'HR',
      purchaseDate: '2023-12-20',
      value: 8000000,
    ),
    DemoData(
      id: '3',
      name: 'Bàn làm việc',
      category: 'Nội thất',
      status: 'active',
      assignedTo: 'Lê Văn C',
      department: 'Marketing',
      purchaseDate: '2024-02-10',
      value: 3000000,
    ),
    DemoData(
      id: '4',
      name: 'Máy chiếu Epson',
      category: 'Thiết bị trình chiếu',
      status: 'inactive',
      assignedTo: 'Phạm Thị D',
      department: 'Sales',
      purchaseDate: '2023-11-05',
      value: 15000000,
    ),
    DemoData(
      id: '5',
      name: 'Điều hòa Daikin',
      category: 'Thiết bị làm mát',
      status: 'active',
      assignedTo: 'Hoàng Văn E',
      department: 'Operations',
      purchaseDate: '2024-03-01',
      value: 12000000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Table Demo'),
        backgroundColor: Colors.white,
        foregroundColor: ColorValue.neutral900,
        elevation: 0,
      ),
      body: Container(
        color: ColorValue.neutral50,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: ColorValue.neutral200.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColorValue.primaryLightBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.inventory,
                      color: ColorValue.primaryBlue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Danh sách tài sản',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: ColorValue.neutral900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Quản lý và theo dõi tài sản công ty',
                          style: TextStyle(
                            fontSize: 14,
                            color: ColorValue.neutral600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialTextButton(
                    text: 'Thêm tài sản',
                    icon: Icons.add,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Thêm tài sản mới')),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // Table section
            Expanded(
              child: MaterialTableWithPagination<DemoData>(
                columns: _buildColumns(),
                data: _demoData,
                itemsPerPage: 5,
                onRowTap: (item) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Chọn: ${item.name}')),
                  );
                },
                onViewAction: (item) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Xem: ${item.name}')),
                  );
                },
                onEditAction: (item) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sửa: ${item.name}')),
                  );
                },
                onDeleteAction: (item) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Xóa: ${item.name}')),
                  );
                },
                showCheckboxes: true,
                showActions: true,
                allowRowSelection: true,
                rowHeight: 64.0,
                emptyMessage: 'Không có dữ liệu tài sản',
                emptyWidget: _buildEmptyState(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<MaterialTableColumn<DemoData>> _buildColumns() {
    return [
      MaterialTableColumn<DemoData>(
        title: 'Mã tài sản',
        flex: 1,
        builder: (item) => _buildCell(
          item.id,
          isBold: true,
          color: ColorValue.primaryBlue,
        ),
      ),
      MaterialTableColumn<DemoData>(
        title: 'Tên tài sản',
        flex: 3,
        builder: (item) => _buildCell(
          item.name,
          isBold: false,
        ),
      ),
      MaterialTableColumn<DemoData>(
        title: 'Danh mục',
        flex: 2,
        builder: (item) => _buildCell(
          item.category,
          isBold: false,
        ),
      ),
      MaterialTableColumn<DemoData>(
        title: 'Người sử dụng',
        flex: 2,
        builder: (item) => _buildCell(
          item.assignedTo,
          isBold: false,
        ),
      ),
      MaterialTableColumn<DemoData>(
        title: 'Phòng ban',
        flex: 1,
        builder: (item) => _buildCell(
          item.department,
          isBold: false,
        ),
      ),
      MaterialTableColumn<DemoData>(
        title: 'Ngày mua',
        flex: 2,
        builder: (item) => _buildCell(
          item.purchaseDate,
          isBold: false,
        ),
      ),
      MaterialTableColumn<DemoData>(
        title: 'Giá trị',
        flex: 2,
        builder: (item) => _buildCell(
          '${_formatCurrency(item.value)}',
          isBold: true,
          color: ColorValue.success,
        ),
      ),
      MaterialTableColumn<DemoData>(
        title: 'Trạng thái',
        flex: 1,
        builder: (item) => _buildStatusBadge(item.status),
      ),
    ];
  }

  Widget _buildCell(String text, {bool isBold = false, Color? color}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
        color: color ?? ColorValue.neutral800,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    String statusText;
    IconData statusIcon;
    
    switch (status.toLowerCase()) {
      case 'active':
        badgeColor = ColorValue.success;
        statusText = 'Hoạt động';
        statusIcon = Icons.check_circle;
        break;
      case 'maintenance':
        badgeColor = ColorValue.warning;
        statusText = 'Bảo trì';
        statusIcon = Icons.build;
        break;
      case 'inactive':
        badgeColor = ColorValue.error;
        statusText = 'Không hoạt động';
        statusIcon = Icons.cancel;
        break;
      default:
        badgeColor = ColorValue.neutral500;
        statusText = 'Không xác định';
        statusIcon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: badgeColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            size: 12,
            color: badgeColor,
          ),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: TextStyle(
              color: badgeColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int value) {
    return '${(value / 1000000).toStringAsFixed(1)}M';
  }

  Widget _buildEmptyState() {
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
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorValue.primaryLightBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.inventory_2,
              size: 48,
              color: ColorValue.primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Không có dữ liệu tài sản',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ColorValue.neutral800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Chưa có tài sản nào được thêm vào hệ thống',
            style: TextStyle(
              fontSize: 14,
              color: ColorValue.neutral600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          MaterialTextButton(
            text: 'Thêm tài sản đầu tiên',
            icon: Icons.add,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thêm tài sản mới')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DemoData {
  final String id;
  final String name;
  final String category;
  final String status;
  final String assignedTo;
  final String department;
  final String purchaseDate;
  final int value;

  DemoData({
    required this.id,
    required this.name,
    required this.category,
    required this.status,
    required this.assignedTo,
    required this.department,
    required this.purchaseDate,
    required this.value,
  });
} 