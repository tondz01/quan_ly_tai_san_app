import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/bloc/role_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/widget/role_detail.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/widget/role_list.dart';

import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';
import 'bloc/role_state.dart';
import 'provider/role_provide.dart';

class RoleView extends StatefulWidget {
  const RoleView({super.key});

  @override
  State<RoleView> createState() => _RoleViewState();
}

class _RoleViewState extends State<RoleView> {
  final TextEditingController _searchController = TextEditingController();
  String searchTerm = "";

  @override
  void initState() {
    super.initState();
    Provider.of<RoleProvider>(context, listen: false).onInit(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<RoleProvider>(context, listen: false).onInit(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RoleBloc, RoleState>(
      builder: (context, state) {
        return Consumer<RoleProvider>(
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
              appBar: AppBar(
                title: HeaderComponent(
                  controller: _searchController,
                  onSearchChanged: (value) {
                    provider.onSearchRoles(value);
                  },
                  onTap: () {
                    // provider.onChangeDetailAssetTransfer(null);
                  },
                  onNew: () {
                    provider.onChangeDetail(context, null);
                  },
                  mainScreen: 'Quản lý chức vụ',
                  subScreen: provider.subScreen,
                  onFileSelected: (fileName, filePath, fileBytes) {
                    provider.insertData(
                      context,
                      fileName!,
                      filePath!,
                      fileBytes!,
                    );
                  },
                  onExportData: () {
                    AppUtility.exportData(
                      context,
                      "Danh sách chức vụ",
                      provider.data?.map((e) => e.toJson()).toList() ?? [],
                    );
                  },
                ),
              ),
              // body: DepartmentTreeDemo(),
              body: Column(
                children: [
                  Flexible(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: CommonPageView(
                        title: 'Chi tiết chức vụ',
                        childInput: RoleDetail(provider: provider),
                        childTableView: RoleList(provider: provider),
                        isShowInput: provider.isShowInput,
                        isShowCollapse: provider.isShowCollapse,
                        onExpandedChanged: (isExpanded) {
                          provider.onSetsShowCollapse(isExpanded);
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
        if (state is RolesInitialState) {}
        if (state is RolesLoadingState) {}
        if (state is RolesLoadingDismissState) {}
        if (state is GetListRoleSuccessState) {
          context.read<RoleProvider>().getListRolesSuccess(context, state);
        }
        if (state is GetListRoleFailedState) {}
        if (state is CreateRoleSuccessState) {
          // Refresh list
          context.read<RoleProvider>().createRolesSuccess(context, state);
        }
        if (state is CreateRoleFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        if (state is UpdateRoleSuccessState) {
          context.read<RoleProvider>().updateRolesSuccess(context, state);
        }
        if (state is DeleteRoleSuccessState) {
          context.read<RoleProvider>().deleteRolesSuccess(context, state);
        }
        if (state is PutPostDeleteFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
    );
  }
}
