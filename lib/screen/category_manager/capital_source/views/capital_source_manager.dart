import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';

import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/captital_source_list.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/bloc/capital_source_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/bloc/capital_source_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/bloc/capital_source_state.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/models/capital_source.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/pages/capital_source_form_page.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';

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

  void _showForm([NguonKinhPhi? capitalSource]) {
    setState(() {
      isShowInput = true;
      editingCapitalSource = capitalSource;
    });
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
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: CommonPageView(
                      childInput: CapitalSourceFormPage(
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
