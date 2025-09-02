// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/diagram/thread_lines.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_event.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/component/department_tree_demo.dart';
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

  void _showDetailDepartmentTree(ToolsAndSuppliesDto item) {
    setState(() {
      selectedItem = item;
      titleDetailDepartmentTree = item.ten;
      isShowDetailDepartmentTree = true;
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
                showConfirmDialog(
                  context,
                  type: ConfirmType.delete,
                  title: 'Xóa CCDC - Vật Tư?',
                  message: 'Bạn có chắc muốn xóa ${item.ten}',
                  highlight: item.ten,
                  cancelText: 'Không',
                  confirmText: 'Xóa',
                  onConfirm: () {
                    context.read<ToolsAndSuppliesBloc>().add(
                      DeleteToolsAndSuppliesEvent(item.id),
                    );
                  },
                );
              },
            ),
        width: 120,
        searchable: true,
      ),
    ];

    final List<ThreadNode> sample = const [
      ThreadNode(header: 'Phòng Tổng công ty', depth: 0),
      ThreadNode(header: 'Phòng Kế toán', depth: 1),
      ThreadNode(header: 'Tổ Ngân quỹ', depth: 2),
      ThreadNode(header: 'Phòng Nhân sự', depth: 1),
      ThreadNode(header: 'Tổ Tuyển dụng', depth: 2),
      ThreadNode(header: 'Tổ Đào tạo', depth: 2),
      ThreadNode(header: 'Phòng IT', depth: 1),
      ThreadNode(header: 'Tổ Hạ tầng', depth: 2),
      ThreadNode(header: 'Tổ Phần mềm', depth: 2),
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
                            'Quản lý CCDC - Vật tư (${widget.provider.data.length})',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: isShowDetailDepartmentTree,
                        child: MaterialTextButton(
                          text: 'Đóng chi tiết sở hữu',
                          icon: Icons.visibility_off,
                          backgroundColor: ColorValue.success,
                          foregroundColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              isShowDetailDepartmentTree = false;
                            });
                          },
                        ),
                      ),
                      // FindByStateAssetHandover(provider: widget.provider),
                    ],
                  ),
                ),
                Expanded(
                  child: TableBaseView<ToolsAndSuppliesDto>(
                    searchTerm: '',
                    columns: columns,
                    data: widget.provider.filteredData,
                    horizontalController: ScrollController(),
                    onRowTap: (item) {
                      widget.provider.onChangeDetail(context, item);
                      setState(() {
                        _showDetailDepartmentTree(item);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Department tree sidebar
          Visibility(
            visible: isShowDetailDepartmentTree,
            child: Container(
              width: 300,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.grey.shade600, width: 1),
                ),
              ),
              child: DetailedDiagram(
                title: titleDetailDepartmentTree,
                sample: sample,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
