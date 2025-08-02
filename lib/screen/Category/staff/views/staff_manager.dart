import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/Category/staff/pages/staff_form_page.dart';
import 'package:quan_ly_tai_san_app/screen/Category/staff/widget/staff_list.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/bloc/staff_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/bloc/staff_event.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/bloc/staff_state.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/staff.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/widget/header_component.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';

class StaffManager extends StatefulWidget {
  const StaffManager({super.key});

  @override
  State<StaffManager> createState() => _StaffManagerState();
}

class _StaffManagerState extends State<StaffManager> {
  bool showForm = false;
  StaffDTO? editingStaff;

  void _showForm([StaffDTO? staff]) {
    setState(() {
      showForm = true;
      editingStaff = staff;
    });
  }

  void _showList() {
    setState(() {
      showForm = false;
      editingStaff = null;
    });
  }

  final ScrollController horizontalController = ScrollController();
  final TextEditingController controller = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  List<StaffDTO> _data = [];
  List<StaffDTO> _filteredData = [];
  bool isFirstLoad = false;

  bool isShowInput = false;
  void _showDeleteDialog(BuildContext context, StaffDTO staff) {
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
                  context.read<StaffBloc>().add(DeleteStaff(staff));
                  Navigator.of(ctx).pop();
                },
                child: const Text('Xóa'),
              ),
            ],
          ),
    );
  }

  void _searchStaff(String value) {
    if (value.isEmpty) {
      _filteredData = _data;
      return;
    }
    
    String searchLower = value.toLowerCase().trim();
    _filteredData = _data.where((item) {
      bool nameMatch = AppUtility.fuzzySearch(item.name.toLowerCase(), searchLower);
      
      bool staffIdMatch = item.staffId.toLowerCase().contains(searchLower);
      
      bool staffOwnerMatch = AppUtility.fuzzySearch(item.staffOwner.toLowerCase(), searchLower);
      
      bool departmentMatch = AppUtility.fuzzySearch(item.department.toLowerCase(), searchLower);
      
      bool activityMatch = AppUtility.fuzzySearch(item.activity.toLowerCase(), searchLower);
      
      bool positionMatch = AppUtility.fuzzySearch(item.position.toLowerCase(), searchLower);
      
      bool timeMatch = item.timeForActivity.toLowerCase().contains(searchLower);
      
      return nameMatch || staffIdMatch || staffOwnerMatch || 
             departmentMatch || activityMatch || positionMatch || timeMatch;
    }).toList();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StaffBloc, StaffState>(
      builder: (context, state) {
        if (state is StaffLoaded) {
          List<StaffDTO> staffs = state.staffs;
          if (staffs.isEmpty) {
            return const Center(child: Text('Chưa có nhân viên nào.'));
          }
          if (!isFirstLoad) {
            log('staffs: ${staffs.length}');
            _data = staffs;
            _filteredData = staffs;
            isFirstLoad = true;
          }

          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: HeaderComponent(
                controller: controller,
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
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: CommonPageView(
                      childInput: StaffFormPage(
                        staff: editingStaff,
                        // onCancel: _showList,
                        // onSaved: _showList,
                      ),
                      childTableView: StaffList(
                        data: _filteredData,
                        onChangeDetail: (item) {
                          _showForm(item);
                          isShowInput = true;
                        },
                        onDelete: (item) {
                          _showDeleteDialog(context, item);
                        },
                        onEdit: (item) {
                          // if (widget.onEdit != null) {
                          //   widget.onEdit!(item);
                          // } else {
                          //   Navigator.of(context).push(
                          //     MaterialPageRoute(
                          //       builder:
                          //           (_) => BlocProvider.value(
                          //             value: context.read<StaffBloc>(),
                          //             child: StaffFormPage(staff: item),
                          //           ),
                          //     ),
                          //   );
                          // }
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
                  visible: (staffs.length ?? 0) >= 5,
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
        } else if (state is StaffError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
    // if (showForm) {
    //   return StaffFormPage(
    //     staff: editingStaff,
    //     // Khi bấm Hủy hoặc Lưu sẽ quay lại danh sách
    //     key: ValueKey(editingStaff?.staffId ?? 'new'),
    //     onCancel: _showList,
    //     onSaved: _showList,
    //   );
    // } else {
    //   return StaffListPage(
    //     onAdd: () => _showForm(),
    //     onEdit: (staff) => _showForm(staff),
    //   );
    // }
  }
}
