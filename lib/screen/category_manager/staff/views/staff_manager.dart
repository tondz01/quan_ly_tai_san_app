import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/pages/staff_form_page.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/widget/staff_list.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/bloc/staff_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/bloc/staff_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/bloc/staff_state.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';

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

  void _showForm([NhanVien? staff]) {
    setState(() {
      isShowInput = true;
      editingStaff = staff;
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StaffBloc>().add(
        const LoadStaffs(),
      ); // Sửa LoadStaff thành LoadStaffs
    });
  }

  @override
  void didPopNext() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StaffBloc>().add(
        const LoadStaffs(),
      ); // Sửa StaffLoaded() thành LoadStaffs()
    });
  }

  void _searchStaff(String value) {
    context.read<StaffBloc>().add(SearchStaff(value));
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StaffBloc, StaffState>(
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
                  log('value: $value');
                  setState(() {
                    _searchStaff(value);
                  });
                },
                onNew: () {
                  setState(() {
                    _showForm(null);
                    isShowInput = true;
                  });
                },
                mainScreen: 'Quản lý nhân viên',
                onFileSelected: (fileName, filePath, fileBytes) {
                  AppUtility.showSnackBar(context, "Chức năng đang phát triển");
                },
                onExportData: () {
                  AppUtility.exportData(
                    context,
                    "Danh sách nhân viên",
                    staffs.map((e) => e.toJson()).toList(),
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
                        onChangeDetail: (item) {
                          _showForm(item);
                          isShowInput = true;
                        },
                        onDelete: (item) {
                          setState(() {
                            isShowInput = false;
                            context.read<StaffBloc>().add(DeleteStaff(item));
                          });
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
    );
  }
}
