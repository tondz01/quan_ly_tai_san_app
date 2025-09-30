// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/button/action_button_config.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/unit/bloc/unit_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/unit/bloc/unit_event.dart';
import 'package:quan_ly_tai_san_app/screen/unit/model/unit_dto.dart';
import 'package:quan_ly_tai_san_app/screen/unit/provider/unit_provider.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/switch/sg_checkbox.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class UnitList extends StatefulWidget {
  final UnitProvider provider;
  const UnitList({super.key, required this.provider});

  @override
  State<UnitList> createState() => _UnitListState();
}

class _UnitListState extends State<UnitList> {
  final ScrollController horizontalController = ScrollController();
  String searchTerm = "";

  List<UnitDto> listSelected = [];

  // Column display options
  late List<ColumnDisplayOption> columnOptions;
  List<String> visibleColumnIds = ['code_unit', 'name_unit', 'note', 'actions'];

  @override
  void initState() {
    super.initState();
    _initializeColumnOptions();
  }

  void _initializeColumnOptions() {
    columnOptions = [
      ColumnDisplayOption(
        id: 'code_unit',
        label: 'Mã đơn vị tính',
        isChecked: visibleColumnIds.contains('code_unit'),
      ),
      ColumnDisplayOption(
        id: 'name_unit',
        label: 'Tên đơn vị tính',
        isChecked: visibleColumnIds.contains('name_unit'),
      ),
      ColumnDisplayOption(
        id: 'note',
        label: 'Ghi chú',
        isChecked: visibleColumnIds.contains('note'),
      ),
      ColumnDisplayOption(
        id: 'actions',
        label: 'Thao tác',
        isChecked: visibleColumnIds.contains('actions'),
      ),
    ];
  }

  List<SgTableColumn<UnitDto>> _buildColumns() {
    final List<SgTableColumn<UnitDto>> columns = [];

    // Thêm cột dựa trên visibleColumnIds
    for (String columnId in visibleColumnIds) {
      switch (columnId) {
        case 'code_unit':
          columns.add(
            TableBaseConfig.columnTable<UnitDto>(
              title: 'Mã đơn vị tính',
              getValue: (item) => item.id ?? '',
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'name_unit':
          columns.add(
            TableBaseConfig.columnTable<UnitDto>(
              title: 'Tên đơn vị tính',
              getValue: (item) => item.tenDonVi ?? '',
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'note':
          columns.add(
            TableBaseConfig.columnTable<UnitDto>(
              title: 'Ghi chú',
              getValue: (item) => '',
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'actions':
          columns.add(
            TableBaseConfig.columnWidgetBase<UnitDto>(
              title: 'Thao tác',
              cellBuilder: (item) => viewAction(item),
              width: 120,
              searchable: true,
            ),
          );
          break;
      }
    }

    return columns;
  }

  @override
  Widget build(BuildContext context) {
    final List<SgTableColumn<UnitDto>> columns = _buildColumns();

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
                  spacing: 8,
                  children: [
                    Icon(
                      Icons.table_chart,
                      color: Colors.grey.shade600,
                      size: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.5),
                      child: Text(
                        'Danh sách đơn vị tính (${widget.provider.data.length})',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: listSelected.isNotEmpty,
                  child: Row(
                    children: [
                      SGText(
                        text: 'Đơn vị tính đã chọn: ${listSelected.length}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(width: 16),
                      MaterialTextButton(
                        text: 'Xóa đã chọn tính',
                        icon: Icons.delete,
                        backgroundColor: ColorValue.error,
                        foregroundColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            final ids = listSelected.map((e) => e.id!).toList();
                            showConfirmDialog(
                              context,
                              type: ConfirmType.delete,
                              title: 'Xóa đơn vị tính',
                              message:
                                  'Bạn có chắc muốn xóa ${listSelected.length} đơn vị tính',
                              highlight: listSelected.length.toString(),
                              cancelText: 'Không',
                              confirmText: 'Xóa',
                              onConfirm: () {
                                final unitBloc = context.read<UnitBloc>();
                                unitBloc.add(DeleteUnitBatchEvent(ids));
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
          Divider(
            height: 1,
            thickness: 1,
            color: SGAppColors.colorBorderGray.withValues(alpha: 0.3),
          ),
          Expanded(
            child: TableBaseView<UnitDto>(
              searchTerm: '',
              columns: columns,
              data: widget.provider.dataPage ?? [],
              horizontalController: ScrollController(),
              onRowTap: (item) {
                widget.provider.onChangeDetail(item);
              },
              onSelectionChanged: (items) {
                setState(() {
                  listSelected = items;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget showCheckBoxActive(bool isActive) {
    return SgCheckbox(value: isActive);
  }

  String getNameColumnAssetGroup(UnitDto item) {
    return "${item.id} - ${item.tenDonVi}";
  }

  Widget viewAction(UnitDto item) {
    return viewActionButtons([
      ActionButtonConfig(
        icon: Icons.delete,
        tooltip: 'Xóa',
        iconColor: Colors.red.shade700,
        backgroundColor: Colors.red.shade50,
        borderColor: Colors.red.shade200,
        onPressed:
            () => {
              showConfirmDialog(
                context,
                type: ConfirmType.delete,
                title: 'Xóa đơn vị tính',
                message: 'Bạn có chắc muốn xóa ${item.tenDonVi}',
                highlight: item.tenDonVi ?? '',
                cancelText: 'Không',
                confirmText: 'Xóa',
                onConfirm: () {
                  context.read<UnitBloc>().add(
                    DeleteUnitEvent(context, item.id!),
                  );
                },
              ),
            },
      ),
    ]);
  }
}
