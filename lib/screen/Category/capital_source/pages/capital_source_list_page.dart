import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/category/capital_source/bloc/capital_source_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/capital_source/bloc/capital_source_event.dart';
import 'package:quan_ly_tai_san_app/screen/category/capital_source/bloc/capital_source_state.dart';
import 'package:quan_ly_tai_san_app/screen/category/capital_source/models/capital_source.dart';
import 'package:quan_ly_tai_san_app/screen/category/capital_source/pages/capital_source_form_page.dart';
import 'package:se_gay_components/common/sg_button.dart';
import 'package:se_gay_components/common/table/sg_table.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class CapitalSourceListPage extends StatelessWidget {
  final VoidCallback? onAdd;
  final void Function(CapitalSource)? onEdit;
  const CapitalSourceListPage({super.key, this.onAdd, this.onEdit});

  void _showDeleteDialog(BuildContext context, CapitalSource capitalSource) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: const Text('Bạn có chắc chắn muốn xóa nguồn vốn này?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<CapitalSourceBloc>().add(
                    DeleteCapitalSource(capitalSource),
                  );
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
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        value:
                                            context.read<CapitalSourceBloc>(),
                                        child: const CapitalSourceFormPage(),
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
                            labelText: 'Tìm kiếm nguồn vốn',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            isDense: true,
                          ),
                          onChanged: (value) {
                            context.read<CapitalSourceBloc>().add(
                              SearchCapitalSource(value),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),

                SizedBox(height: 8),
                BlocBuilder<CapitalSourceBloc, CapitalSourceState>(
                  builder: (context, state) {
                    if (state is CapitalSourceLoaded) {
                      final capitalSources = state.capitalSources;
                      if (capitalSources.isEmpty) {
                        return const Center(
                          child: Text('Chưa có nguồn vốn nào.'),
                        );
                      }
                      return Container(
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
                          child: SingleChildScrollView(
                                                      child: SgTable<CapitalSource>(
                              headerBackgroundColor: ColorValue.primaryBlue,
                              textHeaderColor: Colors.white,
                              widthScreen: MediaQuery.of(context).size.width,
                            evenRowBackgroundColor: ColorValue.neutral50,
                            oddRowBackgroundColor: Colors.white,
                            selectedRowColor: ColorValue.primaryLightBlue.withOpacity(0.2),
                            checkedRowColor: ColorValue.primaryLightBlue.withOpacity(0.1),
                            gridLineColor: ColorValue.neutral200,
                            gridLineWidth: 1.0,
                            showVerticalLines: true,
                            showHorizontalLines: true,
                            allowRowSelection: true,
                            rowHeight: 56.0,
                            onSelectionChanged: (selectedItems) {
                              print(MediaQuery.of(context).size.width);
                            },
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
                                        value:
                                            context.read<CapitalSourceBloc>(),
                                        child: CapitalSourceFormPage(
                                          capitalSource: item,
                                        ),
                                      ),
                                ),
                              );
                            }
                          },
                          onDeleteAction: (item) {
                            _showDeleteDialog(context, item);
                          },
                          columns: [
                            TableColumnBuilder.createTextColumn<CapitalSource>(
                              title: 'Mã nguồn kinh phí',
                              getValue: (item) => item.code,
                            ),
                            TableColumnBuilder.createTextColumn<CapitalSource>(
                              title: 'Tên nguồn kinh phí',
                              getValue: (item) => item.name,
                              width: MediaQuery.of(context).size.width / 4,
                              align: TextAlign.start,
                              isFullWidth: true
                            ),
                            TableColumnBuilder.createTextColumn<CapitalSource>(
                              title: 'Ghi chú',
                              getValue: (item) => item.note,
                              width: MediaQuery.of(context).size.width / 4,
                              align: TextAlign.start,
                              isFullWidth: true
                            ),
                            TableColumnBuilder.createTextColumn<CapitalSource>(
                              title: 'Có hiệu lực',
                              getValue:
                                  (item) => item.isActive ? 'Có' : 'Không',
                              isFullWidth: true

                            ),
                          ],
                          data: capitalSources,
                          onRowTap: (item) {},
                        ),
                          ),
                        ),
                      );
                    } else if (state is CapitalSourceError) {
                      return Center(child: Text(state.message));
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
