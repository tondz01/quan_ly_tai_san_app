import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/bloc/type_ccdc_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/bloc/type_ccdc_event.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/bloc/type_ccdc_state.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/component/convert_excel_to_type_ccdc.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/model/type_ccdc.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/provider/type_ccdc_provider.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/widget/type_ccdc_detail.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/widget/type_ccdc_list.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';

class TypeCcdcView extends StatefulWidget {
  const TypeCcdcView({super.key});

  @override
  State<TypeCcdcView> createState() => _TypeCcdcViewState();
}

class _TypeCcdcViewState extends State<TypeCcdcView> {
  final TextEditingController _searchController = TextEditingController();
  String searchTerm = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TypeCcdcProvider>(context, listen: false).onInit(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TypeCcdcBloc, TypeCcdcState>(
      listener: (context, state) {
        if (state is TypeCcdcLoadingState) {}
        if (state is GetListTypeCcdcSuccessState) {
          context.read<TypeCcdcProvider>().getListSuccess(
            context,
            state,
          );
        }
        if (state is CreateTypeCcdcSuccessState) {
          context.read<TypeCcdcProvider>().createSuccess(
            context,
            state,
          );
        }
        if (state is CreateTypeCcdcFailedState) {
          context.read<TypeCcdcProvider>().createFailed(
            context,
            state,
          );
        }
        if (state is GetListTypeCcdcFailedState) {
          context.read<TypeCcdcProvider>().getListFailed(
            context,
            state,
          );
        }
        if (state is UpdateTypeCcdcSuccessState) {
          context.read<TypeCcdcProvider>().updateSuccess(
            context,
            state,
          );
        }
        if (state is DeleteTypeCcdcSuccessState) {
          context.read<TypeCcdcProvider>().deleteSuccess(
            context,
            state,
          );
        }
        if (state is PutPostDeleteFailedState) {
          context.read<TypeCcdcProvider>().putPostDeleteFailed(context, state);
        }
      },
      builder: (context, state) {
        return ChangeNotifierProvider.value(
          value: context.read<TypeCcdcProvider>(),
          child: Consumer<TypeCcdcProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (provider.data == null) {
                return const Center(child: Text('Không có dữ liệu'));
              }
              return Scaffold(
                appBar: AppBar(
                  title: HeaderComponent(
                    controller: _searchController,
                    onSearchChanged: (value) {
                      provider.searchTerm = value;
                    },
                    onTap: () {},
                    onNew: () {
                      provider.onChangeDetail(null);
                    },
                    mainScreen: 'Loại CCDC',
                    onFileSelected: (fileName, filePath, fileBytes) async {
                      final bloc = context.read<TypeCcdcBloc>();
                      final List<TypeCcdc> list = fileBytes != null
                          ? await convertExcelToTypeCcdcBytes(fileBytes)
                          : await convertExcelToTypeCcdc(filePath!);
                      if (!mounted) return;
                      if (list.isNotEmpty) {
                        bloc.add(CreateTypeCcdcBatchEvent(list));
                      }
                    },
                    onExportData: () {
                      AppUtility.exportData(
                        context,
                        "type_ccdc",
                        provider.data?.map((e) => e.toExportJson()).toList() ?? [],
                      );
                    },
                  ),
                ),
                body: Column(
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: CommonPageView(
                          title: "Chi tiết loại CCDC",
                          childInput: TypeCcdcDetail(provider: provider),
                          childTableView: TypeCcdcList(provider: provider),
                          isShowInput: provider.isShowInput,
                          isShowCollapse: provider.isShowCollapse,
                          onExpandedChanged: (isExpanded) {
                            provider.isShowCollapse = isExpanded;
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
                        controllerDropdownPage:
                            provider.controllerDropdownPage!,
                        items: provider.items,
                        onPageChanged: provider.onPageChanged,
                        onRowsPerPageChanged: provider.onRowsPerPageChanged,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}


