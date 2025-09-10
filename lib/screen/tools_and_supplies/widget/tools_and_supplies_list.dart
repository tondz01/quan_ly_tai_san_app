// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_event.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/component/ownership_unit_details.dart';
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

  ToolsAndSuppliesDto? selectedItem;

  String searchTerm = "";
  String titleDetailDepartmentTree = "";
  bool isShowDetailDepartmentTree = false;
  List<Map<String, DateTime Function(ToolsAndSuppliesDto)>> getters = [
    {'Ngày tạo': (item) => item.ngayTao},
    {'Ngày cập nhật': (item) => item.ngayCapNhat},
    {'Ngày nhập': (item) => item.ngayNhap},
  ];

  void _showDetailDepartmentTree(ToolsAndSuppliesDto item) {
    setState(() {
      selectedItem = item;
      titleDetailDepartmentTree = item.ten;
      isShowDetailDepartmentTree =
          item.chiTietTaiSanList.isNotEmpty &&
          item.detailOwnershipUnit.isNotEmpty;
    });
  }

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
        getValue: (item) => item.id,
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
        title: 'Ký hiệu',
        getValue: (item) => item.kyHieu,
        width: 120,
      ),
      TableBaseConfig.columnWidgetBase<ToolsAndSuppliesDto>(
        title: '',
        cellBuilder:
            (item) => TableBaseConfig.viewActionBase<ToolsAndSuppliesDto>(
              item: item,
              onDelete: (item) {
                // widget.onDelete?.call(item);
                showConfirmDialog(
                  context,
                  type: ConfirmType.delete,
                  title: 'Xóa CCDC - Vật Tư?',
                  message: 'Bạn có chắc muốn xóa ${item.ten}',
                  highlight: item.ten,
                  cancelText: 'Không',
                  confirmText: 'Xóa',
                  onConfirm: () {
                    List<String> listIdAssetDetail =
                        item.chiTietTaiSanList
                            .where(
                              (detail) =>
                                  detail.id != null && detail.id!.isNotEmpty,
                            )
                            .map((detail) => detail.id!)
                            .toList();

                    final jsonIdAssetDetail = jsonEncode(listIdAssetDetail);

                    context.read<ToolsAndSuppliesBloc>().add(
                      DeleteToolsAndSuppliesEvent(item.id, jsonIdAssetDetail),
                    );
                  },
                );
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
      child: Row(
        children: [
          Expanded(
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
                            'Quản lý CCDC - Vật tư (${widget.provider.data?.length ?? 0})',
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
                  child:
                      widget.provider.filteredData != null
                          ? TableBaseView<ToolsAndSuppliesDto>(
                            searchTerm: '',
                            columns: columns,
                            data: widget.provider.filteredData!,
                            horizontalController: ScrollController(),
                            getters: getters,
                            startDate: DateTime.tryParse(
                              widget.provider.filteredData!.isNotEmpty
                                  ? widget.provider.filteredData!.first.ngayTao
                                      .toString()
                                  : '',
                            ),
                            onRowTap: (item) {
                              widget.provider.onChangeDetail(context, item);
                              setState(() {
                                _showDetailDepartmentTree(item);
                              });
                            },
                          )
                          : const Center(
                            child: Text('Không có dữ liệu để hiển thị'),
                          ),
                ),
              ],
            ),
          ),

          // Department tree sidebar
          Visibility(
            visible: isShowDetailDepartmentTree,
            child: OwnershipUnitDetails(
              title: 'Chi tiết đơn vị sở hữu "${selectedItem?.ten}"',
              item: selectedItem ?? ToolsAndSuppliesDto.empty(),
              provider: widget.provider,
              onHiden: () {
                setState(() {
                  isShowDetailDepartmentTree = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
