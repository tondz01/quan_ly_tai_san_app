import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/common/reponsitory/permission_reponsitory.dart';
import 'package:quan_ly_tai_san_app/core/enum/role_code.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';

import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/captital_source_list.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/bloc/capital_source_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/bloc/capital_source_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/bloc/capital_source_state.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/models/capital_source.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/pages/capital_source_form_page.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/providers/capital_source_provider.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class CapitalSourceManager extends StatefulWidget {
  const CapitalSourceManager({super.key});

  @override
  State<CapitalSourceManager> createState() => _CapitalSourceManagerState();
}

class _CapitalSourceManagerState extends State<CapitalSourceManager> {
  bool showForm = false;
  NguonKinhPhi? editingCapitalSource;

  final ScrollController horizontalController = ScrollController();
  final TextEditingController controller = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  List<NguonKinhPhi> data = [];
  List<NguonKinhPhi> filteredData = [];
  bool isFirstLoad = false;
  bool isShowInput = false;
  bool isCanCreate = false;
  bool isCanUpdate = false;
  bool isCanDelete = false;
  bool isNew = false;

  void _showForm([NguonKinhPhi? capitalSource]) {
    setState(() {
      isShowInput = true;
      editingCapitalSource = capitalSource;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }
  

  void _showDeleteDialog(BuildContext context, NguonKinhPhi capitalSource) {
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

  void _searchCapitalSource(String value) {
    context.read<CapitalSourceBloc>().add(SearchCapitalSource(value));
  }

  void _checkPermission() async {
    final repo = PermissionRepository();
    final userId = AccountHelper.instance.getUserInfo()?.id ?? '';
    isCanCreate =
        await repo.checkCanCreatePermission(userId, RoleCode.NHANVIEN) ?? false;
    isCanUpdate =
        await repo.checkCanUpdatePermission(userId, RoleCode.NHANVIEN) ?? false;
    isCanDelete =
        await repo.checkCanDeletePermission(userId, RoleCode.NHANVIEN) ?? false;
    SGLog.info(
      "_checkPermission",
      'isCanCreate: $isCanCreate -- isCanDelete: $isCanDelete -- isCanUpdate: $isCanUpdate',
    );
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
              ? await CapitalSourceProvider().insertDataFileBytes(
                fileName,
                fileBytes,
              )
              : await CapitalSourceProvider().insertDataFile(filePath);
      final statusCode = result['status_code'] as int? ?? 0;
      if (statusCode >= 200 && statusCode < 300) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Import dữ liệu thành công'),
              backgroundColor: Colors.green.shade600,
            ),
          );
          // Reload list after successful import
          context.read<CapitalSourceBloc>().add(LoadCapitalSources());
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
      SGLog.debug("DepartmentManager", ' Error uploading file: $e');
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CapitalSourceBloc, CapitalSourceState>(
      builder: (context, state) {
        if (state is CapitalSourceLoaded) {
          List<NguonKinhPhi> capitalSources = state.capitalSources;
          data = capitalSources;
          filteredData = data;

          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: HeaderComponent(
                controller: searchController,
                onSearchChanged: (value) {
                  setState(() {
                    _searchCapitalSource(value);
                  });
                },
                onNew: () {
                  setState(() {
                    _showForm(null);
                  });
                },
                mainScreen: 'Quản lý nguồn vốn',
                onFileSelected: (fileName, filePath, fileBytes) {
                  insertData(context, fileName!, filePath!, fileBytes!);
                },
                onExportData: () {
                  AppUtility.exportData(
                    context,
                    "nguon_von",
                    data.map((e) => e.toExportJson()).toList(),
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
                      title: 'Chi tiết nguồn vốn',
                      childInput: CapitalSourceFormPage(
                        isNew: isNew = true,
                        isCanUpdate: isCanUpdate = true,
                        capitalSource: editingCapitalSource,
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
                      childTableView: CapitalSourceList(
                        data: filteredData,
                        onChangeDetail: (item) {
                          _showForm(item);
                        },
                        onDelete: (item) {
                          _showDeleteDialog(context, item);
                        },
                        onEdit: (item) {
                          _showForm(item);
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
                  visible: (capitalSources.length) >= 5,
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
        } else if (state is CapitalSourceError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   if (showForm) {
  //     return CapitalSourceFormPage(
  //       capitalSource: editingCapitalSource,
  //       // Khi bấm Hủy hoặc Lưu sẽ quay lại danh sách
  //       key: ValueKey(editingCapitalSource?.code ?? 'new'),
  //       onCancel: _showList,
  //       onSaved: _showList,
  //     );
  //   } else {
  //     return CapitalSourceListPage(
  //       onAdd: () => _showForm(),
  //       onEdit: (capitalSource) => _showForm(capitalSource),
  //     );
  //   }
  // }
}
