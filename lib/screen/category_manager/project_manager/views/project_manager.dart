
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
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
    Provider.of<ProjectProvider>(context, listen: false).onInit(context);
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
            title: const Text('Xác nhận xóa'),
            content: const Text('Bạn có chắc chắn muốn xóa dự án này?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<ProjectBloc>().add(DeleteProjectEvent(duAn!));
                  Navigator.of(ctx).pop();
                },
                child: const Text('Xóa'),
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
            // if (provider.data == null) {
            //   return const Center(child: Text('Không có dữ liệu'));
            // }
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
                  onFileSelected: (fileName, filePath, fileBytes) {
                    if (fileName!.isNotEmpty &&
                        filePath!.isNotEmpty &&
                        fileBytes != null) {}
                  },
                  onExportData: () {
                    AppUtility.exportData(
                      context,
                      "du_an",
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
                          data: provider.filteredData,
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
                    visible: (provider.data?.length ?? 0) >= 5,
                    child: SGPaginationControls(
                      totalPages: provider.totalPages,
                      currentPage: provider.currentPage,
                      rowsPerPage: provider.rowsPerPage,
                      controllerDropdownPage: provider.controllerDropdownPage!,
                      items: provider.itemsPagination,
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
        if (state is ProjectInitialState) {}
        if (state is ProjectLoadingState) {}
        if (state is ProjectLoadingDismissState) {}
        if (state is GetListProjectSuccsessState) {
          context.read<ProjectProvider>().getListProjectSuccess(context, state);
        }
        if (state is AddProjectSuccessState) {
          // Refresh list
          context.read<ProjectProvider>().createRolesSuccess(context, state);
        }

        if (state is UpdateProjectSuccessState) {
          context.read<ProjectProvider>().updateRolesSuccess(context, state);
        }
        if (state is DeleteProjectSuccessState) {
          context.read<ProjectProvider>().deleteRolesSuccess(context, state);
        }
        if (state is ProjectErrorState) {
          context.read<ProjectProvider>().onCallFailled(context, state);
        }
      },
    );
  }
}
