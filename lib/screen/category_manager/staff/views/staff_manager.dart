import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/common/reponsitory/permission_reponsitory.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/core/enum/role_code.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/model/chuc_vu.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/component/convert_excel_to_staff.dart';
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
  int rowsPerPage = StaffConstants.defaultRowsPerPage;
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
      context.read<StaffBloc>().add(const LoadStaffs());
    });
    _checkPermission();
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

  void _updatePagination() {
    // Sử dụng _filteredData thay vì _data
    totalEntries = _filteredData.length;
    totalPages = (totalEntries / rowsPerPage).ceil().clamp(
      1,
      StaffConstants.maxPaginationPages,
    );
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

  void importDataStaff(String? filePath, Uint8List? fileBytes) async {
    List<ChucVu> chucVus = context.read<StaffBloc>().chucvus;
    List<PhongBan> phongBans = context.read<StaffBloc>().department;

    log('importDataStaff chucVus: ${jsonEncode(chucVus)}');
    log('importDataStaff phongBans: ${jsonEncode(phongBans)}');

    final result = await convertExcelToNhanVien(
      filePath!,
      fileBytes: fileBytes,
      chucVus: chucVus,
      phongBans: phongBans,
    );

    if (result['success']) {
      List<NhanVien> nhanViens = result['data'];

      log('importDataStaff nhanViens: ${jsonEncode(nhanViens)}');
      
      final resultSave = await NhanVienProvider().saveNhanVienBatch(nhanViens);
      if (checkStatusCodeDone(resultSave)) {
        if (!mounted) return;
        AppUtility.showSnackBar(
          context,
          'Import dữ liệu thành công ${nhanViens.length} nhân viên',
        );
        searchController.clear();
        currentPage = 1;
        rowsPerPage = StaffConstants.defaultRowsPerPage;
        _filteredData = [];
        dataPage = [];
        context.read<StaffBloc>().add(const LoadStaffs());
        setState(() {
          isShowInput = false;
        });
      } else {
        if (!mounted) return;
        AppUtility.showSnackBar(
          context,
          'Import dữ liệu thất bại ${resultSave['message']}',
        );
      }
    } else {
      List<dynamic> errors = result['errors'];

      // Tạo danh sách lỗi dạng list
      List<String> errorMessages = [];
      for (var error in errors) {
        String rowNumber = error['row'].toString();
        List<String> rowErrors = List<String>.from(error['errors']);
        String errorText = 'Dòng $rowNumber: ${rowErrors.join(', ')}';
        errorMessages.add(errorText);
      }

      log('[ToolsAndSuppliesView] errorMessages: $errorMessages');
      if (!mounted) return;

      // Hiển thị thông báo tổng quan
      AppUtility.showSnackBar(
        context,
        'Import dữ liệu thất bại: \n $errorMessages',
        isError: true,
        timeDuration: 4,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StaffBloc, StaffState>(
      listener: (context, state) {
        if (state is AddStaffSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Thêm nhân viên thành công'),
              backgroundColor: Colors.green.shade600,
            ),
          );
          context.read<StaffBloc>().add(const LoadStaffs());
        }
        if (state is UpdateStaffSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cập nhật nhân viên thành công'),
              backgroundColor: Colors.green.shade600,
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
                    importDataStaff(filePath, fileBytes);
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
                    visible:
                        staffs.length >= StaffConstants.minPaginationThreshold,
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
