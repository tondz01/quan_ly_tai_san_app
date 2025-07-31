import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_table.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';

class UnifiedTablesDemo extends StatefulWidget {
  const UnifiedTablesDemo({super.key});

  @override
  State<UnifiedTablesDemo> createState() => _UnifiedTablesDemoState();
}

class _UnifiedTablesDemoState extends State<UnifiedTablesDemo> {
  final List<DemoTableData> _demoData = [
    DemoTableData(
      id: '1',
      name: 'Laptop Dell XPS 13',
      category: 'Thiết bị điện tử',
      status: 'active',
      assignedTo: 'Nguyễn Văn A',
      department: 'IT',
      purchaseDate: '2024-01-15',
      value: 25000000,
    ),
    DemoTableData(
      id: '2',
      name: 'Máy in HP LaserJet',
      category: 'Thiết bị văn phòng',
      status: 'maintenance',
      assignedTo: 'Trần Thị B',
      department: 'HR',
      purchaseDate: '2023-12-20',
      value: 8000000,
    ),
    DemoTableData(
      id: '3',
      name: 'Bàn làm việc',
      category: 'Nội thất',
      status: 'active',
      assignedTo: 'Lê Văn C',
      department: 'Marketing',
      purchaseDate: '2024-02-10',
      value: 3000000,
    ),
    DemoTableData(
      id: '4',
      name: 'Máy chiếu Epson',
      category: 'Thiết bị trình chiếu',
      status: 'inactive',
      assignedTo: 'Phạm Thị D',
      department: 'Sales',
      purchaseDate: '2023-11-05',
      value: 15000000,
    ),
    DemoTableData(
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
        title: const Text('Unified Tables Demo'),
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
            // Header
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
                      Icons.table_chart,
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
                          'Tất cả bảng đã được thống nhất màu sắc',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: ColorValue.neutral900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Header màu xanh dương với chữ trắng, bo góc 20px, đổ bóng đẹp',
                          style: TextStyle(
                            fontSize: 14,
                            color: ColorValue.neutral600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Unified Table Demo
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: ColorValue.neutral300.withOpacity(0.4),
                      spreadRadius: 0,
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: ColorValue.neutral200.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: MaterialTableWithPagination<DemoTableData>(
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
                    emptyMessage: 'Không có dữ liệu',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<MaterialTableColumn<DemoTableData>> _buildColumns() {
    return [
      MaterialTableColumn<DemoTableData>(
        title: 'Mã tài sản',
        flex: 1,
        builder: (item) => _buildCell(
          item.id,
          isBold: true,
          color: ColorValue.primaryBlue,
        ),
      ),
      MaterialTableColumn<DemoTableData>(
        title: 'Tên tài sản',
        flex: 3,
        builder: (item) => _buildCell(
          item.name,
          isBold: false,
        ),
      ),
      MaterialTableColumn<DemoTableData>(
        title: 'Danh mục',
        flex: 2,
        builder: (item) => _buildCell(
          item.category,
          isBold: false,
        ),
      ),
      MaterialTableColumn<DemoTableData>(
        title: 'Người sử dụng',
        flex: 2,
        builder: (item) => _buildCell(
          item.assignedTo,
          isBold: false,
        ),
      ),
      MaterialTableColumn<DemoTableData>(
        title: 'Phòng ban',
        flex: 1,
        builder: (item) => _buildCell(
          item.department,
          isBold: false,
        ),
      ),
      MaterialTableColumn<DemoTableData>(
        title: 'Ngày mua',
        flex: 2,
        builder: (item) => _buildCell(
          item.purchaseDate,
          isBold: false,
        ),
      ),
      MaterialTableColumn<DemoTableData>(
        title: 'Giá trị',
        flex: 2,
        builder: (item) => _buildCell(
          '${_formatCurrency(item.value)}',
          isBold: true,
          color: ColorValue.success,
        ),
      ),
      MaterialTableColumn<DemoTableData>(
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
}

class DemoTableData {
  final String id;
  final String name;
  final String category;
  final String status;
  final String assignedTo;
  final String department;
  final String purchaseDate;
  final int value;

  DemoTableData({
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