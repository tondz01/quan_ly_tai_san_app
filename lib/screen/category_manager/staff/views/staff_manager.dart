import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/common/reponsitory/permission_reponsitory.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/enum/role_code.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/component/convert_excel_to_staff.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/pages/staff_form_page.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/staf_provider.dart/nhan_vien_provider.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/widget/staff_list.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/bloc/staff_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/bloc/staff_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/bloc/staff_state.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

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
  int rowsPerPage = 10;
  int currentPage = 1;

  final ScrollController horizontalController = ScrollController();
  final TextEditingController controller = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  List<NhanVien> _filteredData = [];
  List<NhanVien> dataPage = [];

  bool isFirstLoad = false;
  bool isShowInput = false;
  bool isCanCreate = false;
  bool isCanUpdate = false;
  bool isCanDelete = false;
  bool isNew = false;

  void _showForm([NhanVien? staff]) {
    setState(() {
      isShowInput = true;
      editingStaff = staff;
      isNew = staff == null;
      log('_checkPermission isNew: $isNew');
    });
  }

  void onPageChanged(int page) {
    setState(() {
      currentPage = page;
      _updatePagination();
    });
  }

  void onRowsPerPageChanged(int? value) {
    setState(() {
      if (value == null) return;
      rowsPerPage = value;
      currentPage = 1;
      _updatePagination();
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StaffBloc>().add(
        const LoadStaffs(),
      ); // Sửa LoadStaff thành LoadStaffs
    });
    setState(() {
      _checkPermission();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StaffBloc>().add(
        const LoadStaffs(),
      ); // Sửa LoadStaff thành LoadStaffs
    });
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

  void _searchStaff(String value) {
    context.read<StaffBloc>().add(SearchStaff(value));
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

  void _updatePagination() {
    // Sử dụng _filteredData thay vì _data
    totalEntries = _filteredData.length;
    totalPages = (totalEntries / rowsPerPage).ceil().clamp(1, 9999);
    startIndex = (currentPage - 1) * rowsPerPage;
    endIndex = (startIndex + rowsPerPage).clamp(0, totalEntries);

    if (startIndex >= totalEntries && totalEntries > 0) {
      currentPage = 1;
      startIndex = 0;
      endIndex = rowsPerPage.clamp(0, totalEntries);
    }
    dataPage =
        _filteredData.isNotEmpty
            ? _filteredData.sublist(
              startIndex < totalEntries ? startIndex : 0,
              endIndex < totalEntries ? endIndex : totalEntries,
            )
            : [];
  }

  void importDataStaff(String? filePath) async {
    List<NhanVien> nv = await convertExcelToNhanVien(filePath!);
    log('nv: ${jsonEncode(nv)}');
    if (nv.isNotEmpty) {
      final result = await NhanVienProvider().saveNhanVienBatch(nv);
      if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS ||
          result['status_code'] == Numeral.STATUS_CODE_SUCCESS_CREATE) {
        if (!mounted) return;
        AppUtility.showSnackBar(context, 'Import dữ liệu thành công');
        searchController.clear();
        currentPage = 1;
        rowsPerPage = 10;
        _filteredData = [];
        dataPage = [];
        context.read<StaffBloc>().add(const LoadStaffs());
        context.read<StaffBloc>().add(const LoadStaffs());
        setState(() {
          isShowInput = false;
        });
      } else {
        if (!mounted) return;
        AppUtility.showSnackBar(
          context,
          'Import dữ liệu thất bại ${result['message']}',
        );
      }
    } else {
      if (!mounted) return;
      AppUtility.showSnackBar(context, 'Import dữ liệu thất bại: File lỗi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StaffBloc, StaffState>(
      listener: (context, state) {
        if (state is DeleteStaffBatchSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Xóa nhân viên thành công'),
              backgroundColor: Colors.green.shade600,
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
            _filteredData = staffs;
            _updatePagination();
            AccountHelper.instance.clearNhanVien();
            AccountHelper.instance.setNhanVien(staffs);
            return Scaffold(
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
                  onFileSelected: (fileName, filePath, fileBytes) {
                    importDataStaff(filePath);
                  },
                  onExportData: () {
                    AppUtility.exportData(
                      context,
                      "nhan_vien",
                      staffs.map((e) => e.toExportJson()).toList(),
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
                        title: 'Chi tiết nhân viên',
                        childInput: StaffFormPage(
                          staff: editingStaff,
                          staffs: staffs,
                          isNew: isNew,
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
                          data: dataPage,
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
                              context.read<StaffBloc>().add(DeleteStaff(item));
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
                  Visibility(
                    visible: (staffs.length) >= 5,
                    child: SGPaginationControls(
                      totalPages: totalPages,
                      currentPage: currentPage,
                      rowsPerPage: rowsPerPage,
                      controllerDropdownPage: controller,
                      items: [
                        DropdownMenuItem(value: 10, child: Text('10')),
                        DropdownMenuItem(value: 20, child: Text('20')),
                        DropdownMenuItem(value: 50, child: Text('50')),
                      ],
                      onPageChanged: onPageChanged,
                      onRowsPerPageChanged: onRowsPerPageChanged,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is StaffError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
