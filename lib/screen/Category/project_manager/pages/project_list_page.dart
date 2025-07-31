import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/bloc/project_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/bloc/project_event.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/bloc/project_state.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/models/project.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/pages/project_form_page.dart';
import 'package:se_gay_components/common/sg_button.dart';
import 'package:se_gay_components/common/table/sg_table.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class ProjectListPage extends StatelessWidget {
  final VoidCallback? onAdd;
  final void Function(Project)? onEdit;
  const ProjectListPage({super.key, this.onAdd, this.onEdit});

  void _showDeleteDialog(BuildContext context, Project project) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: const Text('Bạn có chắc chắn muốn xóa dự án này?'),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Hủy')),
              ElevatedButton(
                onPressed: () {
                  context.read<ProjectBloc>().add(DeleteProject(project));
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
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
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
                        child: SGButton(
                          text: 'Mới',  
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          mainColor: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          onPressed: () {
                            if (onAdd != null) {
                              onAdd!();
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (_) => BlocProvider.value(
                                        value: context.read<ProjectBloc>(),
                                        child: const ProjectFormPage(),
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
                            labelText: 'Tìm kiếm dự án',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            isDense: true,
                          ),
                          onChanged: (value) {
                            context.read<ProjectBloc>().add(SearchProject(value));
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                  ],
                ),
                SizedBox(height: 8),
            
                BlocBuilder<ProjectBloc, ProjectState>(
                  builder: (context, state) {
                    if (state is ProjectLoaded) {
                      final projects = state.projects;
                      if (projects.isEmpty) {
                        return const Center(child: Text('Chưa có dự án nào.'));
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
                            child: SgTable<Project>(
                              headerBackgroundColor: ColorValue.primaryBlue,
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
                                SGLog.debug('ProjectListPage', 'onSelectionChanged: ${MediaQuery.of(context).size.width}');
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
                                        value: context.read<ProjectBloc>(),
                                        child: ProjectFormPage(project: item),
                                      ),
                                ),
                              );
                            }
                          },
                          onDeleteAction: (item) {
                            _showDeleteDialog(context, item);
                          },
                          columns: [
                            TableColumnBuilder.createTextColumn<Project>(title: 'Mã', getValue: (item) => item.code),
                            TableColumnBuilder.createTextColumn<Project>(
                              title: 'Tên',
                              getValue: (item) => item.name,
                              width: MediaQuery.of(context).size.width / 4,
                              align: TextAlign.start,
                              isFullWidth: true
                            ),
                            TableColumnBuilder.createTextColumn<Project>(
                              title: 'Ghi chú',
                              getValue: (item) => item.note,
                              width: MediaQuery.of(context).size.width / 4,
                              align: TextAlign.start,
                              isFullWidth: true
                            ),
                            TableColumnBuilder.createTextColumn<Project>(
                              title: 'Có hiệu lực',
                              getValue: (item) => item.isActive ? 'Có' : 'Không',
                              isFullWidth: true
                            ),
                          ],
                          data: projects,
                          onRowTap: (item) {},
                        ),
                          ),
                        ),
                      );
                    } else if (state is ProjectError) {
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
