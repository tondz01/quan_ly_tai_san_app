import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/project_manager_list.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/bloc/project_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/bloc/project_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/bloc/project_state.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/models/duan.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/pages/project_form_page.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/providers/project_provider.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class ProjectManager extends StatefulWidget {
  const ProjectManager({super.key});

  @override
  State<ProjectManager> createState() => _ProjectManagerState();
}

class _ProjectManagerState extends State<ProjectManager> {
  bool showForm = false;
  DuAn? editingProject;

  final ScrollController horizontalController = ScrollController();
  final TextEditingController controller = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  List<DuAn> data = [];
  List<DuAn> filteredData = [];
  bool isFirstLoad = false;
  bool isShowInput = false;

  void _showForm([DuAn? duAn]) {
    setState(() {
      isShowInput = true;
      editingProject = duAn;
    });
  }

  Future<Map<String, dynamic>?> insertData(
    BuildContext context,
    String fileName,
    String filePath,
    Uint8List fileBytes,
  ) async {
    if (kIsWeb) {
      if (fileName.isEmpty || filePath.isEmpty) return null;
    } else {
      if (filePath.isEmpty) return null;
    }
    try {
      final result =
          kIsWeb
              ? await ProjectProvider().insertDataFileBytes(fileName, fileBytes)
              : await ProjectProvider().insertDataFile(filePath);
      final statusCode = result['status_code'] as int? ?? 0;
      if (statusCode >= 200 && statusCode < 300) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Import dữ liệu thành công'),
              backgroundColor: Colors.green.shade600,
            ),
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<ProjectBloc>().add(LoadProjects());
          });
        }
        return result['data'];
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tải lên thất bại (mã $statusCode)'),
              backgroundColor: Colors.red.shade600,
            ),
          );
        }
        return null;
      }
    } catch (e) {
      SGLog.debug("AssetTransferDetail", ' Error uploading file: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tải lên tệp: ${e.toString()}'),
            backgroundColor: Colors.red.shade600,
          ),
        );
        return null;
      }
    }
    return null;
  }

  void _showDeleteDialog(BuildContext context, DuAn? duAn) {
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
                  context.read<ProjectBloc>().add(DeleteProject(duAn!));
                  Navigator.of(ctx).pop();
                },
                child: const Text('Xóa'),
              ),
            ],
          ),
    );
  }

  void _searchProjectManger(String value) {
    context.read<ProjectBloc>().add(SearchProject(value));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        if (state is ProjectLoaded) {
          List<DuAn> projects = state.projects;
          data = projects;
          filteredData = data;

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
                mainScreen: 'Quản lý dự án',
                onFileSelected: (fileName, filePath, fileBytes) {
                  if (fileName!.isNotEmpty &&
                      filePath!.isNotEmpty &&
                      fileBytes != null) {
                    insertData(context, fileName, filePath, fileBytes);
                  }
                },
                onExportData: () {
                  AppUtility.exportData(
                    context,
                    "Danh sách dự án",
                    data.map((e) => e.toJson()).toList(),
                  );
                },
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: CommonPageView(
                      childInput: ProjectFormPage(
                        duAn: editingProject,
                        onCancel: () {
                          setState(() {
                            isShowInput = false;
                          });
                        },
                        onSaved: () {
                          setState(() {
                            isShowInput = false;
                          });
                        },
                      ),
                      childTableView: ProjectManagerList(
                        data: filteredData,
                        onChangeDetail: (item) {
                          _showForm(item as DuAn?);
                        },
                        onDelete: (item) {
                          _showDeleteDialog(context, item as DuAn?);
                        },
                        onEdit: (item) {
                          _showForm(item as DuAn?);
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
