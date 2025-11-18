// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/components/loading_overlay.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/common/reponsitory/permission_reponsitory.dart';
import 'package:quan_ly_tai_san_app/core/enum/role_code.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/pages/staff_form_page.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/staf_provider/nhan_vien_provider.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/widget/staff_list.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/bloc/staff_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/bloc/staff_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/bloc/staff_state.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/constants/staff_constants.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:flutter/foundation.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:quan_ly_tai_san_app/screen/home/scroll_controller.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffManager extends StatefulWidget {
  const StaffManager({super.key});

  @override
  State<StaffManager> createState() => _StaffManagerState();
}

class _StaffManagerState extends State<StaffManager> with RouteAware {
  bool showForm = false;
  NhanVien? editingStaff;
  late int totalEntries;
  late int totalPages = 0;
  late int startIndex;
  late int endIndex;
  int rowsPerPage = StaffConstants.defaultRowsPerPage;
  int currentPage = 1;

  final ScrollController horizontalController = ScrollController();
  final TextEditingController controller = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  bool isFirstLoad = false;
  bool isShowInput = false;
  bool isCanCreate = false;
  bool isCanUpdate = false;
  bool isCanDelete = false;
  bool isNew = false;

  bool isImporting = false;

  String messageLoading = 'Đang tải dữ liệu...';

  void _showForm([NhanVien? staff]) {
    setState(() {
      isShowInput = true;
      editingStaff = staff;
      isNew = staff == null;
      log('_checkPermission isNew: $isNew');
    });
  }

  late HomeScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = HomeScrollController();
    _scrollController.addListener((_onScrollStateChanged));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StaffBloc>().add(const LoadStaffs());
    });
    _checkPermission();
  }

  void _onScrollStateChanged() {
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      isShowInput = false;
      _checkPermission();
    });
  }

  @override
  void didPopNext() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StaffBloc>().add(
        const LoadStaffs(),
      ); // Sửa StaffLoaded() thành LoadStaffs()
    });
    setState(() {
      isShowInput = false;
      _checkPermission();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollStateChanged);
    super.dispose();
  }

  void _searchStaff(String value) {
    context.read<StaffBloc>().add(SearchStaff(value));
  }

  void _checkPermission() async {
    try {
      final repo = PermissionRepository();
      final userId = AccountHelper.instance.getUserInfo()?.id ?? '';

      final permissions = await Future.wait([
        repo.checkCanCreatePermission(userId, RoleCode.NHANVIEN),
        repo.checkCanUpdatePermission(userId, RoleCode.NHANVIEN),
        repo.checkCanDeletePermission(userId, RoleCode.NHANVIEN),
      ]);

      if (mounted) {
        setState(() {
          isCanCreate = permissions[0] ?? false;
          isCanUpdate = permissions[1] ?? false;
          isCanDelete = permissions[2] ?? false;
        });
      }

      SGLog.info(
        "_checkPermission",
        'isCanCreate: $isCanCreate -- isCanDelete: $isCanDelete -- isCanUpdate: $isCanUpdate',
      );
    } catch (e) {
      SGLog.error("_checkPermission", 'Error checking permissions: $e');
      if (mounted) {
        setState(() {
          isCanCreate = false;
          isCanUpdate = false;
          isCanDelete = false;
        });
      }
    }
  }

  void importDataStaff(String filePath, Uint8List fileBytes) async {
    try {
      final resultSave = await NhanVienProvider().importFile(
        filePath,
        fileBytes,
      );
      if (checkStatusCodeDone(resultSave['status_code'])) {
        isImporting = false;
        AppUtility.showSnackBar(context, 'Import thành công');
        context.read<StaffBloc>().add(const LoadStaffs());
      } else {
        isImporting = false;
        AppUtility.showSnackBar(
          context,
          'Import thất bại: ${resultSave['message'] ?? 'Lỗi không xác định'}',
        );
        log('resultSave: ${resultSave['message']}');
      }
    } catch (e) {
      isImporting = false;
      AppUtility.showSnackBar(context, 'Import thất bại: $e');
      log('Import thất bại: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: BlocListener<StaffBloc, StaffState>(
        listener: (context, state) {
          if (state is AddStaffSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Thêm nhân viên thành công'),
                backgroundColor: const Color(0xFF21A366),
              ),
            );
            context.read<StaffBloc>().add(const LoadStaffs());
          }
          if (state is UpdateStaffSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Cập nhật nhân viên thành công'),
                backgroundColor: const Color(0xFF21A366),
              ),
            );
            context.read<StaffBloc>().add(const LoadStaffs());
          }
          if (state is StaffError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Lỗi: ${state.message}'),
                backgroundColor: Colors.red.shade600,
              ),
            );
          }
          if (state is DeleteStaffBatchSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Xóa nhân viên thành công'),
                backgroundColor: const Color(0xFF21A366),
              ),
            );
            context.read<StaffBloc>().add(const LoadStaffs());
          } else if (state is DeleteStaffBatchFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Xóa nhân viên thất bại: ${state.message}'),
                backgroundColor: Colors.red.shade600,
              ),
            );
          }
        },
        child: BlocBuilder<StaffBloc, StaffState>(
          builder: (context, state) {
            if (state is StaffLoaded) {
              List<NhanVien> staffs = state.staffs;
              AccountHelper.instance.clearNhanVien();
              AccountHelper.instance.setNhanVien(staffs);
              return LoadingOverlay(
                isLoading: isImporting,
                message: 'Đang nhập dữ liệu nhân viên...',
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    title: HeaderComponent(
                      controller: searchController,
                      onSearchChanged: (value) {
                        setState(() {
                          _searchStaff(value);
                        });
                      },
                      onNew: () {
                        if (!isCanCreate) {
                          AppUtility.showSnackBar(
                            context,
                            'Bạn không có quyền tạo nhân viên',
                          );
                          return;
                        }
                        setState(() {
                          _showForm(null);
                          isShowInput = true;
                        });
                      },
                      mainScreen: 'Quản lý nhân viên',
                      isShowSearch: false,
                      onFileSelected: (fileName, filePath, fileBytes) {
                        messageLoading = 'Đang nhập dữ liệu nhân viên...';
                        isImporting = true;
                        importDataStaff(
                          filePath ?? '',
                          fileBytes ?? Uint8List(0),
                        );
                      },
                      onExportData: () {
                        // isImporting = true;
                        // messageLoading = 'Đang xuất dữ liệu nhân viên...';
                        AppUtility.exportData(
                          context,
                          "nhan_vien",
                          staffs.map((e) => e.toExportJson()).toList(),
                        );
                        // final sessionId = '4A6E8943A475C7861752EF7BD0A6E19B';
                        // NhanVienProvider().exportNhanVienExcel(
                        //   staffs.map((e) => e.toExportJson()).toList(),
                        //   fileName: "Nhan_Vien",
                        //   sessionId: sessionId,
                        // );
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
                              title: 'Chi tiết nhân viên',
                              childInput: StaffFormPage(
                                staff: editingStaff,
                                staffs: staffs,
                                isNew: isNew,
                                isCanUpdate: isCanUpdate,
                                onCancel: () {
                                  setState(() {
                                    isShowInput = false;
                                  });
                                },
                                onSaved:
                                    () => setState(() {
                                      isShowInput = false;
                                    }),
                              ),
                              childTableView: StaffList(
                                data: staffs,
                                isCanDelete: isCanDelete,
                                onChangeDetail: (item) {
                                  _showForm(item);
                                  isShowInput = true;
                                },
                                onDelete: (item) {
                                  setState(() {
                                    if (!isCanDelete) {
                                      AppUtility.showSnackBar(
                                        context,
                                        'Bạn không có quyền xóa nhân viên',
                                      );
                                      return;
                                    }
                                    isShowInput = false;
                                    context.read<StaffBloc>().add(
                                      DeleteStaff(item),
                                    );
                                  });
                                },
                                onEdit: (item) {
                                  _showForm(item);
                                },
                                onDeleteBatch:
                                    (p0) => setState(() {
                                      isShowInput = false;
                                      context.read<StaffBloc>().add(
                                        DeleteStaffBatch(p0),
                                      );
                                    }),
                              ),

                              // Container(height: 200,color: Colors.limeAccent,),
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
                ),
              );
            } else if (state is StaffError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
