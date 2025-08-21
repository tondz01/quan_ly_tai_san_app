import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/category/asset/bloc/asset_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/asset/bloc/asset_event.dart';
import 'package:quan_ly_tai_san_app/screen/category/asset/bloc/asset_state.dart';
import 'package:quan_ly_tai_san_app/screen/category/asset/models/asset.dart';
import 'package:quan_ly_tai_san_app/screen/category/asset/pages/asset_form_page.dart';
import 'package:se_gay_components/common/table/sg_table.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class AssetListPage extends StatelessWidget {
  final VoidCallback? onAdd;
  final void Function(AssetDTO)? onEdit;
  const AssetListPage({super.key, this.onAdd, this.onEdit});

  void _showDeleteDialog(BuildContext context, AssetDTO asset) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: const Text('Bạn có chắc chắn muốn xóa tài sản này?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<AssetBloc>().add(DeleteAsset(asset));
                  Navigator.of(ctx).pop();
                },
                child: const Text('Xóa'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                                                  child: MaterialTextButton(
                          text: 'Mới',
                          icon: Icons.add,
                          backgroundColor: ColorValue.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          onPressed: () {
                            if (onAdd != null) {
                              onAdd!();
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (_) => BlocProvider.value(
                                        value: context.read<AssetBloc>(),
                                        child: const AssetFormPage(),
                                      ),
                                ),
                              );
                            }
                          },
                        ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Tìm kiếm tài sản',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              isDense: true,
                            ),
                            onChanged: (value) {
                              context.read<AssetBloc>().add(SearchAsset(value));
                            },
                          ),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                    ],
                  ),
                  SizedBox(height: 8),
                  BlocBuilder<AssetBloc, AssetState>(
                    builder: (context, state) {
                      if (state is AssetLoaded) {
                        final assets = state.assets;
                        if (assets.isEmpty) {
                          return const Center(
                            child: Text('Chưa có tài sản nào.'),
                          );
                        }
                        return Expanded(
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
                              child: SgTable<AssetDTO>(
                                headerBackgroundColor: ColorValue.primaryBlue,
                                textHeaderColor: Colors.white,
                                widthScreen: MediaQuery.of(context).size.width,
                                evenRowBackgroundColor: ColorValue.neutral50,
                                oddRowBackgroundColor: Colors.white,
                                selectedRowColor: ColorValue.primaryLightBlue.withOpacity(0.2),
                                gridLineColor: ColorValue.neutral200,
                                gridLineWidth: 1.0,
                                showVerticalLines: true,
                                showHorizontalLines: true,
                                allowRowSelection: true,
                                rowHeight: 56.0,
                                showActions: true,
                                actionColumnTitle: 'Thao tác',
                                actionColumnWidth: 160,
                                actionViewColor: ColorValue.success,
                                actionEditColor: ColorValue.primaryBlue,
                                actionDeleteColor: ColorValue.error,
                                onEditAction: (item) {
                                  if (onEdit != null) {
                                    onEdit!(item);
                                  } else {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (_) => BlocProvider.value(
                                              value: context.read<AssetBloc>(),
                                              child: AssetFormPage(asset: item),
                                            ),
                                      ),
                                    );
                                  }
                                },
                                onDeleteAction: (item) {
                                  _showDeleteDialog(context, item);
                                },
                                columns: [
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Mã tài sản',
                                    getValue: (item) => item.assetId,
                                    width: 120,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Nguyên giá',
                                    getValue: (item) => item.originalPrice,
                                    width: 120,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Giá trị khấu hao ban đầu',
                                    getValue:
                                        (item) => item.initialDepreciationValue,
                                    width: 150,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Kỳ khấu hao ban đầu',
                                    getValue:
                                        (item) =>
                                            item.initialDepreciationPeriod,
                                    width: 150,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Giá trị thanh lý',
                                    getValue: (item) => item.liquidationValue,
                                    width: 120,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Mô hình tài sản',
                                    getValue: (item) => item.assetModel,
                                    width: 200,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Phương pháp khấu hao',
                                    getValue: (item) => item.depreciationMethod,
                                    width: 150,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Số kỳ khấu hao',
                                    getValue:
                                        (item) => item.depreciationPeriods,
                                    width: 120,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Tài khoản tài sản',
                                    getValue: (item) => item.assetAccount,
                                    width: 150,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Tài khoản khấu hao',
                                    getValue:
                                        (item) => item.depreciationAccount,
                                    width: 150,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Tài khoản chi phí',
                                    getValue: (item) => item.costAccount,
                                    width: 150,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Nhóm tài sản',
                                    getValue: (item) => item.assetGroup,
                                    width: 200,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Ngày vào sổ',
                                    getValue: (item) => item.entryDate,
                                    width: 120,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Ngày sử dụng',
                                    getValue: (item) => item.usageDate,
                                    width: 120,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Dự án',
                                    getValue: (item) => item.project,
                                    width: 120,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Nguồn kinh phí',
                                    getValue: (item) => item.fundingSource,
                                    width: 150,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Ký hiệu',
                                    getValue: (item) => item.symbol,
                                    width: 100,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Số ký hiệu',
                                    getValue: (item) => item.symbolNumber,
                                    width: 120,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Công suất',
                                    getValue: (item) => item.capacity,
                                    width: 100,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Nước sản xuất',
                                    getValue: (item) => item.countryOfOrigin,
                                    width: 150,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Năm sản xuất',
                                    getValue: (item) => item.yearOfManufacture,
                                    width: 120,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Lý do tăng',
                                    getValue: (item) => item.reasonForIncrease,
                                    width: 120,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Hiện trạng',
                                    getValue: (item) => item.status,
                                    width: 120,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Số lượng',
                                    getValue: (item) => item.quantity,
                                    width: 100,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Đơn vị tính',
                                    getValue: (item) => item.unit,
                                    width: 100,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Ghi chú',
                                    getValue: (item) => item.note,
                                    width: 150,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Khởi tạo Đơn vị ban đầu',
                                    getValue:
                                        (item) =>
                                            item.initialUnitCreated
                                                ? 'Có'
                                                : 'Không',
                                    width: 180,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Đơn vị sử dụng ban đầu',
                                    getValue: (item) => item.initialUsageUnit,
                                    width: 180,
                                  ),
                                  TableColumnBuilder.createTextColumn<AssetDTO>(
                                    title: 'Đơn vị hiện thời',
                                    getValue: (item) => item.currentUnit,
                                    width: 150,
                                  ),
                                ],
                                data: assets,
                                onRowTap: (item) {},
                              ),
                            ),
                          ),
                        );
                      } else if (state is AssetError) {
                        return Center(child: Text(state.message));
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
