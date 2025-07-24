import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/Category/project_manager/models/project.dart';
import 'package:se_gay_components/common/sg_button.dart';
import 'package:se_gay_components/common/table/sg_table.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import '../bloc/project_bloc.dart';
import '../bloc/project_event.dart';
import '../bloc/project_state.dart';
import 'project_form_page.dart';

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SGButton(
                  text: 'Thêm dự án',
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
                SizedBox(height: 8),
                BlocBuilder<ProjectBloc, ProjectState>(
                  builder: (context, state) {
                    if (state is ProjectLoaded) {
                      final projects = state.projects;
                      if (projects.isEmpty) {
                        return const Center(child: Text('Chưa có dự án nào.'));
                      }
                      return SingleChildScrollView(
                        child: SgTable<Project>(
                          // textHeaderColor: SGAppColors.error50,
                          headerBackgroundColor: Colors.blue,
                          evenRowBackgroundColor: Colors.grey.shade200,
                          oddRowBackgroundColor: Colors.white,

                          gridLineColor: Colors.grey.shade300,
                          gridLineWidth: 1.0,
                          showVerticalLines: true,
                          showHorizontalLines: true,
                          allowRowSelection: true,
                          onSelectionChanged: (selectedItems) {
                            SGLog.debug('ProjectListPage', 'onSelectionChanged: ${MediaQuery.of(context).size.width}');
                          },
                          // Bật tính năng hiển thị cột hành động
                          showActions: true,
                          actionColumnTitle: 'Thao tác',
                          actionColumnWidth: 150,
                          actionEditColor: Colors.blue,
                          actionDeleteColor: Colors.red,
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
                            ),
                            TableColumnBuilder.createTextColumn<Project>(
                              title: 'Ghi chú',
                              getValue: (item) => item.note,
                              width: MediaQuery.of(context).size.width / 4,
                              align: TextAlign.start,
                            ),
                            TableColumnBuilder.createTextColumn<Project>(
                              title: 'Có hiệu lực',
                              getValue: (item) => item.isActive ? 'Có' : 'Không',
                            ),
                          ],
                          data: projects,
                          onRowTap: (item) {},
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
