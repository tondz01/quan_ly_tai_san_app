import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:flutter/foundation.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/bloc/department_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/bloc/department_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/bloc/department_state.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/component/convert_excel_to_department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/constants/department_constants.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/department_list.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/pages/department_form_page.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/providers/table_department_provider.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/providers/departments_provider.dart';
import 'package:quan_ly_tai_san_app/screen/home/scroll_controller.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';

class DepartmentManager extends StatefulWidget {
  const DepartmentManager({super.key});

  @override
  State<DepartmentManager> createState() => _DepartmentManagerState();
}

class _DepartmentManagerState extends State<DepartmentManager> with RouteAware {
  bool showForm = false;
  PhongBan? editingDepartment;

  final TextEditingController searchController = TextEditingController();
  List<PhongBan> data = [];
  bool isShowInput = false;
  bool isUpdateDetail = false;
  late HomeScrollController _scrollController;
  bool _isRefreshingTable = false;
  void _refreshTableProvider() {
    if (_isRefreshingTable) return;
    _isRefreshingTable = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final container = riverpod.ProviderScope.containerOf(context);
      container.read(tableDepartmentProvider.notifier).refreshData();
      _isRefreshingTable = false;
    });
  }
  @override
  void initState() {
    super.initState();
    _scrollController = HomeScrollController();
    _scrollController.addListener((_onScrollStateChanged));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DepartmentBloc>().add(const LoadDepartments());
    });
  }

  void _onScrollStateChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollStateChanged);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Removed duplicate LoadDepartments call
  }

  @override
  void didPopNext() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DepartmentBloc>().add(const LoadDepartments());
    });
  }

  void _showForm([PhongBan? department]) {
    setState(() {
      isShowInput = true;
      editingDepartment = department;
      isUpdateDetail = true;
    });
  }

  void _importData(List<PhongBan> departments) async {
    if (departments.isNotEmpty) {
      final result = await DepartmentsProvider().saveDepartmentBatch(
        departments,
      );
      if (checkStatusCodeDone(result)) {
        if (context.mounted) {
          AppUtility.showSnackBar(
            context,
            'Import dữ liệu thành công ${departments.length} nhân viên',
          );
          searchController.clear();
          context.read<DepartmentBloc>().add(const LoadDepartments());
          _refreshTableProvider();
          setState(() {
            isShowInput = false;
          });
        }
      } else {
        if (context.mounted) {
          AppUtility.showSnackBar(
            context,
            'Import dữ liệu thất bại ${result['message']}',
            isError: true,
          );
        }
      }
    } else {
      if (context.mounted) {
        AppUtility.showSnackBar(
          context,
          'Import dữ liệu thất bại',
          isError: true,
        );
      }
    }
  }

  void _showDeleteDialog(BuildContext context, PhongBan department) {
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
                  context.read<DepartmentBloc>().add(
                    DeleteDepartment(department),
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
    return BlocListener<DepartmentBloc, DepartmentState>(
      listener: (context, state) {
        isShowInput = false;
        if (state is AddDepartmentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFF21A366),
              duration:
                  kIsWeb
                      ? DepartmentConstants.webSnackBarDuration
                      : DepartmentConstants.mobileSnackBarDuration,
            ),
          );
          _refreshTableProvider();
        }
        if (state is UpdateDepartmentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFF21A366),
              duration:
                  kIsWeb
                      ? DepartmentConstants.webSnackBarDuration
                      : DepartmentConstants.mobileSnackBarDuration,
            ),
          );
          _refreshTableProvider();
        }
        if (state is DeleteDepartmentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFF21A366),
              duration:
                  kIsWeb
                      ? DepartmentConstants.webSnackBarDuration
                      : DepartmentConstants.mobileSnackBarDuration,
            ),
          );
          _refreshTableProvider();
        }
        if (state is DepartmentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: ${state.message}'),
              backgroundColor: Colors.red.shade600,
              duration:
                  kIsWeb
                      ? DepartmentConstants.webSnackBarDuration
                      : DepartmentConstants.mobileSnackBarDuration,
            ),
          );
        }
        if (state is DeleteDepartmentBatchSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Xóa phòng ban thành công'),
              backgroundColor: const Color(0xFF21A366),
              duration:
                  kIsWeb
                      ? DepartmentConstants.webSnackBarDuration
                      : DepartmentConstants.mobileSnackBarDuration,
            ),
          );
          _refreshTableProvider();
        } else if (state is DeleteDepartmentBatchFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Xóa phòng ban thất bại: ${state.message}'),
              backgroundColor: Colors.red.shade600,
              duration:
                  kIsWeb
                      ? DepartmentConstants.webSnackBarDuration
                      : DepartmentConstants.mobileSnackBarDuration,
            ),
          );
        }
      },
      child: BlocBuilder<DepartmentBloc, DepartmentState>(
        builder: (context, state) {
          if (state is DepartmentLoaded) {
            List<PhongBan> departments = state.departments;
            data = departments;
            AccountHelper.instance.clearDepartment();
            AccountHelper.instance.setDepartment(departments);

            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: HeaderComponent(
                  controller: searchController,
                  onSearchChanged: (value) {
                    final container = riverpod.ProviderScope.containerOf(context);
                    container.read(tableDepartmentProvider.notifier).searchTerm =
                        value;
                  },
                  isShowSearch: false,
                  onNew: () {
                    setState(() {
                      _showForm(null);
                      isShowInput = true;
                    });
                  },
                  mainScreen: 'Quản lý phòng ban',
                  onFileSelected: (fileName, filePath, fileBytes) async {
                    final result = await convertExcelToPhongBan(
                      filePath!,
                      fileBytes: fileBytes,
                      phongBans: departments,
                    );

                    if (result['success']) {
                      List<PhongBan> phongBans = result['data'];
                      _importData(phongBans);
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
                            'Dòng $rowNumber: ${rowErrors.join(', ')}';
                        errorMessages.add(errorText);
                      }

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
                      "phong_ban",
                      departments.map((e) => e.toExportJson()).toList(),
                    );
                  },
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        return true; // Xử lý scroll event bình thường
                      },
                      child: SingleChildScrollView(
                        physics:
                            _scrollController.isParentScrolling
                                ? const NeverScrollableScrollPhysics() // Parent đang cuộn => ngăn child cuộn
                                : const BouncingScrollPhysics(), // Parent đã cuộn hết => cho phép child cuộn
                        scrollDirection: Axis.vertical,
                        child: CommonPageView(
                          title: 'Chi tiết phòng ban',
                          childInput: DepartmentFormPage(
                            department: editingDepartment,
                            onCancel: () {
                              setState(() {
                                isShowInput = false;
                              });
                            },
                            onSaved: () {
                              setState(() {
                                isShowInput = false;
                                isUpdateDetail = false;
                              });
                            },
                            onUpdateDetail: () {
                              setState(() {
                                isUpdateDetail = false;
                              });
                            },
                          ),
                          childTableView: DepartmentList(
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

                          isShowInput: isShowInput,
                          onExpandedChanged: (isExpanded) {
                            isShowInput = isExpanded;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is DepartmentError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
