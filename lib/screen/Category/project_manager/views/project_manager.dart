import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/Category/project_manager/project_manager_list.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/bloc/project_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/bloc/project_event.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/bloc/project_state.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/pages/project_list_page.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/pages/project_form_page.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/models/project.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/widget/header_component.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';

class ProjectManager extends StatefulWidget {
  const ProjectManager({super.key});

  @override
  State<ProjectManager> createState() => _ProjectManagerState();
}

class _ProjectManagerState extends State<ProjectManager> {
  bool showForm = false;
  Project? editingProject;

  final ScrollController horizontalController = ScrollController();
  final TextEditingController controller = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  List<Project> data = [];
  List<Project> filteredData = [];
  bool isFirstLoad = false;
  bool isShowInput = false;

  void _showForm([Project? project]) {
    setState(() {
      showForm = true;
      editingProject = project;
    });
  }

  void _showList() {
    setState(() {
      showForm = false;
      editingProject = null;
    });
  }

  void _showDeleteDialog(BuildContext context, Project project) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: const Text('Bạn có chắc chắn muốn xóa dự án này?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Hủy'),
              ),
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

  void _searchProjectManger(String value) {
    if (value.isEmpty) {
      filteredData = data;
      return;
    }

    String searchLower = value.toLowerCase().trim();
    filteredData =
        data.where((item) {
          bool nameMatch = AppUtility.fuzzySearch(
            item.name.toLowerCase(),
            searchLower,
          );

          bool staffIdMatch = item.code.toLowerCase().contains(searchLower);

          bool staffOwnerMatch = AppUtility.fuzzySearch(
            item.note.toLowerCase(),
            searchLower,
          );

          return nameMatch || staffIdMatch || staffOwnerMatch;
        }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        if (state is ProjectLoaded) {
          List<Project> projects = state.projects;
          if (projects.isEmpty) {
            return const Center(child: Text('Chưa có dự án nào.'));
          }
          if (!isFirstLoad) {
            log('projects: ${projects.length}');
            data = projects;
            filteredData = data;
            isFirstLoad = true;
          }

          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: HeaderComponent(
                controller: searchController,
                onSearchChanged: (value) {
                  log('value: $value');
                  setState(() {
                    _searchProjectManger(value);
                  });
                },
                onNew: () {
                  setState(() {
                    _showForm(null);
                    isShowInput = true;
                  });
                },
                mainScreen: 'Quản lý nhân viên',
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: CommonPageView(
                      childInput: ProjectFormPage(
                        project: editingProject,
                        // onCancel: _showList,
                        // onSaved: _showList,
                      ),
                      childTableView: ProjectManagerList(
                        data: filteredData,
                        onChangeDetail: (item) {
                          _showForm(item);
                          isShowInput = true;
                        },
                        onDelete: (item) {
                          _showDeleteDialog(context, item);
                        },
                        onEdit: (item) {
                          // if (widget.onEdit != null) {
                          //   widget.onEdit!(item);
                          // } else {
                          //   Navigator.of(context).push(
                          //     MaterialPageRoute(
                          //       builder:
                          //           (_) => BlocProvider.value(
                          //             value: context.read<StaffBloc>(),
                          //             child: StaffFormPage(staff: item),
                          //           ),
                          //     ),
                          //   );
                          // }
                        },
                      ),

                      // Container(height: 200,color: Colors.limeAccent,),
                      isShowInput: isShowInput,
                      onExpandedChanged: (isExpanded) {
                        isShowInput = isExpanded;
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: (projects.length) >= 5,
                  child: SGPaginationControls(
                    totalPages: 1,
                    currentPage: 1,
                    rowsPerPage: 10,
                    controllerDropdownPage: controller,
                    items: [
                      DropdownMenuItem(value: 10, child: Text('10')),
                      DropdownMenuItem(value: 20, child: Text('20')),
                      DropdownMenuItem(value: 50, child: Text('50')),
                    ],
                    onPageChanged: (page) {},
                    onRowsPerPageChanged: (rows) {},
                  ),
                ),
              ],
            ),
          );
        } else if (state is ProjectError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   if (showForm) {
  //     return ProjectFormPage(
  //       project: editingProject,
  //       // Khi bấm Hủy hoặc Lưu sẽ quay lại danh sách
  //       key: ValueKey(editingProject?.code ?? 'new'),
  //       onCancel: _showList,
  //       onSaved: _showList,
  //     );
  //   } else {
  //     return ProjectListPage(
  //       onAdd: () => _showForm(),
  //       onEdit: (project) => _showForm(project),
  //     );
  //   }
  // }
}
