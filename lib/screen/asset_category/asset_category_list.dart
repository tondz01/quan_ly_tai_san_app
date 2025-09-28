// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/bloc/asset_category_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/bloc/asset_category_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/models/asset_category_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';

class AssetCategoryList extends StatefulWidget {
  final List<AssetCategoryDto> data;
  final void Function(AssetCategoryDto)? onChangeDetail;
  final void Function(AssetCategoryDto)? onEdit;
  final void Function(AssetCategoryDto)? onDelete;
  const AssetCategoryList({
    super.key,
    required this.data,
    this.onChangeDetail,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<AssetCategoryList> createState() => _AssetCategoryListState();
}

class _AssetCategoryListState extends State<AssetCategoryList> {
  List<AssetCategoryDto> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    final columns = [
      TableBaseConfig.columnTable<AssetCategoryDto>(
        title: 'Mã mô hình',
        getValue: (item) => item.id ?? "",
        width: 100,
      ),
      TableBaseConfig.columnTable<AssetCategoryDto>(
        title: 'Tên mô hình tài sản',
        getValue: (item) => item.tenMoHinh ?? "",
        width: 200,
      ),
      TableBaseConfig.columnTable<AssetCategoryDto>(
        title: 'Phương pháp khấu hao',
        getValue: (item) => item.phuongPhapKhauHao == 1 ? 'Đường thẳng' : 'Khác',
        width: 150,
      ),
      TableBaseConfig.columnTable<AssetCategoryDto>(
        title: 'Kỳ khấu hao',
        getValue: (item) => item.kyKhauHao?.toString() ?? "",
        width: 100,
      ),
      TableBaseConfig.columnTable<AssetCategoryDto>(
        title: 'Loại kỳ khấu hao',
        getValue: (item) => item.loaiKyKhauHao == '1' ? 'Tháng' : item.loaiKyKhauHao == '2' ? 'Năm' : item.loaiKyKhauHao ?? "",
        width: 120,
      ),
      TableBaseConfig.columnTable<AssetCategoryDto>(
        title: 'Tài khoản tài sản',
        getValue: (item) => item.taiKhoanTaiSan ?? "",
        width: 120,
      ),
      TableBaseConfig.columnTable<AssetCategoryDto>(
        title: 'Tài khoản khấu hao',
        getValue: (item) => item.taiKhoanKhauHao ?? "",
        width: 120,
      ),
      TableBaseConfig.columnTable<AssetCategoryDto>(
        title: 'Tài khoản chi phí',
        getValue: (item) => item.taiKhoanChiPhi ?? "",
        width: 120,
      ),
      TableBaseConfig.columnWidgetBase<AssetCategoryDto>(
        title: 'Thao tác',
        cellBuilder: (item) => TableBaseConfig.viewActionBase<AssetCategoryDto>(
          item: item,
          onEdit: (item) {
            widget.onEdit?.call(item);
          },
          onDelete: (item) {
            widget.onDelete?.call(item);
          },
        ),
        width: 120,
        searchable: true,
      ),
    ];
    
    return Container(
      height: MediaQuery.of(context).size.height - 200,
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
                    SGText(
                      text: 'Danh sách mô hình tài sản',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: selectedItems.isNotEmpty,
                  child: Row(
                    children: [
                      SGText(
                        text:
                            'Danh sách mô hình tài sản đã chọn: ${selectedItems.length}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(width: 16),
                      MaterialTextButton(
                        text: 'Xóa đã chọn',
                        icon: Icons.delete,
                        backgroundColor: ColorValue.error,
                        foregroundColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            List<String> data =
                                selectedItems.map((e) => e.id!).toList();

                            showConfirmDialog(
                              context,
                              type: ConfirmType.delete,
                              title: 'Xóa mô hình tài sản',
                              message:
                                  'Bạn có chắc muốn xóa ${selectedItems.length} mô hình tài sản',
                              highlight: selectedItems.length.toString(),
                              cancelText: 'Không',
                              confirmText: 'Xóa',
                              onConfirm: () {
                                final assetCategoryBloc =
                                    context.read<AssetCategoryBloc>();
                                assetCategoryBloc.add(DeleteAssetCategoryBatchEvent(context, data));
                              },
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TableBaseView<AssetCategoryDto>(
              searchTerm: '',
              columns: columns,
              data: widget.data,
              horizontalController: ScrollController(),
              onRowTap: (item) {
                widget.onChangeDetail?.call(item);
              },
              onSelectionChanged: (items) {
                setState(() {
                  selectedItems = items;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
