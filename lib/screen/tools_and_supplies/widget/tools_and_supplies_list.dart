// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/provider/tools_and_supplies_provide.dart';

class ToolsAndSuppliesList extends StatefulWidget {
  final ToolsAndSuppliesProvider provider;
  const ToolsAndSuppliesList({super.key, required this.provider});

  @override
  State<ToolsAndSuppliesList> createState() => _ToolsAndSuppliesListState();
}

class _ToolsAndSuppliesListState extends State<ToolsAndSuppliesList> {
  final ScrollController horizontalController = ScrollController();
  String searchTerm = "";
  @override
  Widget build(BuildContext context) {
    final columns = [
      TableBaseConfig.columnTable<ToolsAndSuppliesDto>(
        title: 'Công cụ dụng cụ',
        getValue: (item) => item.ten,
        width: 170,
      ),
      TableBaseConfig.columnTable<ToolsAndSuppliesDto>(
        title: 'Đơn vị nhập',
        getValue: (item) => item.idDonVi,
        width: 170,
      ),
      TableBaseConfig.columnTable<ToolsAndSuppliesDto>(
        title: 'Mã công cụ dụng cụ',
        getValue: (item) => item.soKyHieu,
        width: 170,
      ),
      TableBaseConfig.columnTable<ToolsAndSuppliesDto>(
        title: 'Ngày nhập',
        getValue: (item) => item.ngayNhap.toString(),
        width: 120,
      ),
      TableBaseConfig.columnTable<ToolsAndSuppliesDto>(
        title: 'Đơn vị tính',
        getValue: (item) => item.donViTinh,
        width: 120,
      ),
      TableBaseConfig.columnTable<ToolsAndSuppliesDto>(
        title: 'Số lượng',
        getValue: (item) => item.soLuong.toString(),
        width: 120,
      ),
      TableBaseConfig.columnTable<ToolsAndSuppliesDto>(
        title: 'Giá trị',
        getValue: (item) => item.giaTri.toString(),
        width: 120,
      ),
      TableBaseConfig.columnTable<ToolsAndSuppliesDto>(
        title: 'Số ký hiệu',
        getValue: (item) => item.soKyHieu,
        width: 120,
      ),
      TableBaseConfig.columnTable<ToolsAndSuppliesDto>(
        title: 'Ký hiệu',
        getValue: (item) => item.kyHieu,
        width: 120,
      ),
      TableBaseConfig.columnTable<ToolsAndSuppliesDto>(
        title: 'Công suất',
        getValue: (item) => item.congSuat,
        width: 120,
      ),
      TableBaseConfig.columnTable<ToolsAndSuppliesDto>(
        title: 'Nước sản xuất',
        getValue: (item) => item.nuocSanXuat,
        width: 120,
      ),
      TableBaseConfig.columnTable<ToolsAndSuppliesDto>(
        title: 'Năm sản xuất',
        getValue: (item) => item.namSanXuat.toString(),
        width: 120,
      ),
      TableBaseConfig.columnWidgetBase<ToolsAndSuppliesDto>(
        title: '',
        cellBuilder:
            (item) => TableBaseConfig.viewActionBase<ToolsAndSuppliesDto>(
              item: item,
              onDelete: (item) {
                // widget.onDelete?.call(item);
                _showDeleteConfirmationDialog(context, item, widget.provider);
              },
            ),
        width: 120,
        searchable: true,
      ),
    ];
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.table_chart,
                      color: Colors.grey.shade600,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Quản lý CCDC - Vật tư (${widget.provider.data.length})',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                // FindByStateAssetHandover(provider: widget.provider),
              ],
            ),
          ),
          Expanded(
            child: TableBaseView<ToolsAndSuppliesDto>(
              searchTerm: '',
              columns: columns,
              data: widget.provider.filteredData ?? [],
              horizontalController: ScrollController(),
              onRowTap: (item) {
                widget.provider.onChangeDetail(context, item);
              },
            ),
          ),
        ],
      ),
    );
  }


  void _showDeleteConfirmationDialog(
    BuildContext context,
    ToolsAndSuppliesDto item,
    ToolsAndSuppliesProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc chắn muốn xóa công cụ dụng cụ "${item.ten}" không?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                // Xóa item
                provider.deleteItem(item.id);
                Navigator.of(context).pop();
              },
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
