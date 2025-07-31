import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_table.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/row_find_by_status.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/asset_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/asset_transfer_provider.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';

class AssetTransferMaterialList extends StatefulWidget {
  final AssetTransferProvider provider;
  final String mainScreen;
  
  const AssetTransferMaterialList({
    super.key,
    required this.provider,
    required this.mainScreen,
  });

  @override
  State<AssetTransferMaterialList> createState() => _AssetTransferMaterialListState();
}

class _AssetTransferMaterialListState extends State<AssetTransferMaterialList> {
  String searchTerm = "";
  int _currentPage = 0;
  final int _itemsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    return Consumer<AssetTransferProvider>(
      builder: (context, provider, child) {
        final data = provider.dataPage ?? [];
        final totalPages = (data.length / _itemsPerPage).ceil();
        final startIndex = _currentPage * _itemsPerPage;
        final endIndex = (startIndex + _itemsPerPage).clamp(0, data.length);
        final currentData = data.sublist(startIndex, endIndex);

        return Column(
          children: [
            // Filter section
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
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              child: RowFindByStatus(provider: provider),
            ),
            
            // Table section
            if (data.isNotEmpty)
              Expanded(
                child: MaterialTableWithPagination<AssetTransferDto>(
                  columns: _buildColumns(),
                  data: data,
                  itemsPerPage: _itemsPerPage,
                  searchTerm: searchTerm,
                  onRowTap: (item) {
                    provider.onChangeScreen(
                      item: item,
                      isMainScreen: false,
                      isEdit: false,
                    );
                  },
                  onViewAction: (item) {
                    // Handle view action
                    log('View action for item: ${item.id}');
                  },
                  onEditAction: (item) {
                    // Handle edit action
                    log('Edit action for item: ${item.id}');
                  },
                  onDeleteAction: (item) {
                    // Handle delete action
                    log('Delete action for item: ${item.id}');
                  },
                  showCheckboxes: true,
                  showActions: true,
                  allowRowSelection: true,
                  rowHeight: 64.0,
                  emptyMessage: 'Không có dữ liệu chuyển giao tài sản',
                  emptyWidget: _buildEmptyState(),
                ),
              )
            else
              Expanded(
                child: _buildEmptyState(),
              ),
          ],
        );
      }
    );
  }

  List<MaterialTableColumn<AssetTransferDto>> _buildColumns() {
    return [
      MaterialTableColumn<AssetTransferDto>(
        title: 'Số quyết định',
        flex: 2,
        builder: (item) => _buildCell(
          item.decisionNumber ?? 'N/A',
          isBold: true,
          color: ColorValue.primaryBlue,
        ),
      ),
      MaterialTableColumn<AssetTransferDto>(
        title: 'Tên phiếu',
        flex: 3,
        builder: (item) => _buildCell(
          item.documentName ?? 'N/A',
          isBold: false,
        ),
      ),
      MaterialTableColumn<AssetTransferDto>(
        title: 'Người đề nghị',
        flex: 2,
        builder: (item) => _buildCell(
          item.requester ?? 'N/A',
          isBold: false,
        ),
      ),
      MaterialTableColumn<AssetTransferDto>(
        title: 'Đơn vị giao',
        flex: 2,
        builder: (item) => _buildCell(
          item.deliveringUnit ?? 'N/A',
          isBold: false,
        ),
      ),
      MaterialTableColumn<AssetTransferDto>(
        title: 'Đơn vị nhận',
        flex: 2,
        builder: (item) => _buildCell(
          item.receivingUnit ?? 'N/A',
          isBold: false,
        ),
      ),
      MaterialTableColumn<AssetTransferDto>(
        title: 'Ngày quyết định',
        flex: 2,
        builder: (item) => _buildCell(
          item.decisionDate ?? 'N/A',
          isBold: false,
        ),
      ),
      MaterialTableColumn<AssetTransferDto>(
        title: 'Trạng thái',
        flex: 1,
        builder: (item) => _buildStatusBadge(item.status?.toString() ?? 'pending'),
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
    
    switch (status.toLowerCase()) {
      case 'completed':
      case 'success':
        badgeColor = ColorValue.success;
        statusText = 'Hoàn thành';
        break;
      case 'pending':
      case 'waiting':
        badgeColor = ColorValue.warning;
        statusText = 'Chờ xử lý';
        break;
      case 'processing':
      case 'in_progress':
        badgeColor = ColorValue.primaryBlue;
        statusText = 'Đang xử lý';
        break;
      case 'cancelled':
      case 'failed':
        badgeColor = ColorValue.error;
        statusText = 'Đã hủy';
        break;
      default:
        badgeColor = ColorValue.neutral500;
        statusText = 'Không xác định';
    }

    return MaterialStatusBadge(
      text: statusText,
      color: badgeColor,
      borderRadius: 12,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
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
              Icons.transfer_within_a_station,
              size: 48,
              color: ColorValue.primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Không có dữ liệu chuyển giao tài sản',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ColorValue.neutral800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Chưa có bản ghi chuyển giao tài sản nào được tạo',
            style: TextStyle(
              fontSize: 14,
              color: ColorValue.neutral600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          MaterialTextButton(
            text: 'Thêm chuyển giao mới',
            icon: Icons.add,
            onPressed: () {
              // Handle add new transfer
              log('Add new transfer action');
            },
          ),
        ],
      ),
    );
  }
} 