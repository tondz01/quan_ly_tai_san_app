import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/component/convert_excel_to_project.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/constants/project_constants.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/project_manager_list.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/bloc/project_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/bloc/project_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/bloc/project_state.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/models/duan.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/pages/project_form_page.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/providers/project_provider.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';

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

  @override
  void initState() {
    super.initState();
    Provider.of<ProjectProvider>(context, listen: false).onInit(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Removed duplicate onInit call - already called in initState
  }

  void _showForm([DuAn? duAn]) {
    setState(() {
      isShowInput = true;
      editingProject = duAn;
    });
  }

  void _showDeleteDialog(BuildContext context, DuAn? duAn) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(ProjectConstants.confirmDeleteTitle),
            content: Text(ProjectConstants.confirmDeleteMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(ProjectConstants.cancelText),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<ProjectBloc>().add(DeleteProjectEvent(duAn!));
                  Navigator.of(ctx).pop();
                },
                child: Text(ProjectConstants.deleteText),
              ),
            ],
          ),
    );
  }

  // void _searchProjectManger(String value) {
  //   context.read<ProjectBloc>().add(SearchProject(value));
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectBloc, ProjectState>(
      builder: (context, state) {
        return Consumer<ProjectProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            provider.controllerDropdownPage ??= TextEditingController(
              text: provider.rowsPerPage.toString(),
            );

            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: HeaderComponent(
                  controller: searchController,
                  onSearchChanged: (value) {
                    provider.onSearchRoles(value);
                  },
                  onNew: () {
                    setState(() {
                      _showForm(null);
                      isShowInput = true;
                    });
                  },
                  mainScreen: 'Quản lý dự án',
                  onFileSelected: (fileName, filePath, fileBytes) async {
                    final roleBloc = context.read<ProjectBloc>();

                    final result = await convertExcelToProject(
                      filePath!,
                      fileBytes: fileBytes,
                    );
                    if (!mounted) return;
                    if (result['success']) {
                      List<DuAn> duAnList = result['data'];
                      roleBloc.add(CreateProjectBatchEvent(duAnList));
                    } else {
                      List<dynamic> errors = result['errors'];

                      // Tạo danh sách lỗi dạng list
                      List<String> errorMessages = [];
                      for (var error in errors) {
                        String rowNumber = error['row'].toString();
                        List<String> rowErrors = List<String>.from(
                          error['errors'],
                        );
                        String errorText =
                            'Dòng $rowNumber: ${rowErrors.join(', ')}\n';
                        errorMessages.add(errorText);
                      }

                      log(
                        '[ToolsAndSuppliesView] errorMessages: $errorMessages',
                      );
                      if (!mounted) return;

                      // Hiển thị thông báo tổng quan
                      AppUtility.showSnackBar(
                        context,
                        'Import dữ liệu thất bại: \n $errorMessages',
                        isError: true,
                        timeDuration: 4,
                      );
                    }
                  },
                  onExportData: () {
                    AppUtility.exportData(
                      context,
                      ProjectConstants.exportFileName,
                      provider.data.map((e) => e.toExportJson()).toList(),
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
                          data: provider.dataPage,
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
                        isShowInput: isShowInput,
                        onExpandedChanged: (isExpanded) {
                          isShowInput = isExpanded;
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible:
                        (provider.data?.length ?? 0) >=
                        ProjectConstants.minPaginationThreshold,
                    child: SGPaginationControls(
                      totalPages: provider.totalPages,
                      currentPage: provider.currentPage,
                      rowsPerPage: provider.rowsPerPage,
                      controllerDropdownPage: provider.controllerDropdownPage!,
                      items: provider.items,
                      onPageChanged: provider.onPageChanged,
                      onRowsPerPageChanged: provider.onRowsPerPageChanged,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      listener: (context, state) {
        isShowInput = false;
        if (state is ProjectInitialState) {}
        if (state is ProjectLoadingState) {}
        if (state is ProjectLoadingDismissState) {}
        if (state is GetListProjectSuccessState) {
          context.read<ProjectProvider>().getListProjectSuccess(context, state);
        }
        if (state is GetListProjectFailedState) {}
        if (state is CreateProjectSuccessState) {
          // Refresh list
          context.read<ProjectProvider>().createRolesSuccess(context, state);
        }
        if (state is CreateProjectFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade600,
              duration:
                  kIsWeb
                      ? ProjectConstants.webSnackBarDuration
                      : ProjectConstants.mobileSnackBarDuration,
            ),
          );
        }
        if (state is UpdateProjectSuccessState) {
          context.read<ProjectProvider>().updateRolesSuccess(context, state);
        }
        if (state is DeleteProjectSuccessState) {
          context.read<ProjectProvider>().deleteRolesSuccess(context, state);
        }
        if (state is PutPostDeleteFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade600,
              duration:
                  kIsWeb
                      ? ProjectConstants.webSnackBarDuration
                      : ProjectConstants.mobileSnackBarDuration,
            ),
          );
        }
        if (state is DeleteProjectBatchSuccess) {
          context.read<ProjectProvider>().deleteProjectBatchSuccess(
            context,
            state,
          );
        } else if (state is DeleteProjectBatchFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Xóa dự án thất bại: ${state.message}'),
              backgroundColor: Colors.red.shade600,
              duration:
                  kIsWeb
                      ? ProjectConstants.webSnackBarDuration
                      : ProjectConstants.mobileSnackBarDuration,
            ),
          );
        }
      },
    );
  }
}
