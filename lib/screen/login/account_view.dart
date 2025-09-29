import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_state.dart';
import 'package:quan_ly_tai_san_app/screen/login/provider/login_provider.dart';
import 'package:quan_ly_tai_san_app/screen/login/widget/account_list.dart';
import 'package:quan_ly_tai_san_app/screen/login/widget/staff_list_by_account.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LoginProvider>(context, listen: false).onInit(context);
    });
  }

  @override
  void didUpdateWidget(AccountView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (oldWidget.typeAssetTransfer != widget.typeAssetTransfer) {
    //   currentType = widget.typeAssetTransfer;
    //   _initData();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      builder: (context, state) {
        // Usar el ChangeNotifierProvider.value en lugar de Consumer
        // Esto asegura que todos los cambios en el provider actualizan la UI
        return ChangeNotifierProvider.value(
          value: context.read<LoginProvider>(),
          child: Consumer<LoginProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (provider.users == null) {
                return const Center(child: Text('Không có dữ liệu'));
              }

              return Scaffold(
                appBar: AppBar(
                  title: Row(
                    children: [
                      Expanded(
                        child: HeaderComponent(
                          controller: TextEditingController(),
                          isShowSearch: false,
                          onSearchChanged: (value) {
                            // Cập nhật trạng thái tìm kiếm trong provider
                            // provider.searchTerm = value;
                          },
                          onTap: () {},
                          onNew: () {
                            if(AccountHelper.instance.getUserInfo()?.tenDangNhap != "admin") {
                              AppUtility.showSnackBar(context, "Bạn không có quyền tạo tài khoản", isError: true);
                              return;
                            }
                            showDialog(
                              context: context,
                              builder:
                                  (context) => Dialog(
                                    // shape: RoundedRectangleBorder(
                                    //   borderRadius: BorderRadius.circular(16),
                                    // ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: StaffListByAccount(
                                        provider: provider,
                                      ),
                                    ),
                                  ),
                            );
                          },
                          mainScreen: 'User',
                        ),
                      ),
                    ],
                  ),
                ),
                body: Column(
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: CommonPageView(
                          title: "Chi tiết user",
                          childInput: Container(),
                          childTableView: AccountList(provider: provider),
                          isShowInput: false,
                          isShowCollapse: false,
                          onExpandedChanged: (isExpanded) {},
                        ),
                      ),
                    ),
                    Visibility(
                      visible: (provider.users?.length ?? 0) >= 5,
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

      listener: (context, state) {
        if (state is LoginLoadingState) {
          // Mostrar loading
        }
        if (state is GetUsersSuccessState) {
          context.read<LoginProvider>().getUsersSuccess(context, state);
        }
        if (state is GetUsersFailedState) {
          context.read<LoginProvider>().getUsersFailed(context, state);
        }
        if (state is CreateAccountSuccessState) {
          context.read<LoginProvider>().createUserSuccess(context, state);
        }
        if (state is UpdateUserSuccessState) {
          context.read<LoginProvider>().updateUserSuccess(context, state);
        }
        if (state is UpdatePermissionSuccessState) {
          AppUtility.showSnackBar(context, 'Cập nhật phân quyền thành công');
        }
        if (state is UpdatePermissionFailedState) {
          AppUtility.showSnackBar(
            context,
            'Cập nhật phân quyền thất bại\nLỗi: ${state.message}',
            isError: true,
          );
        }
        if (state is DeleteUserSuccessState) {
          context.read<LoginProvider>().deleteUserSuccess(context, state);
        }
        if (state is GetNhanVienSuccessState) {
          context.read<LoginProvider>().getNhanVienSuccess(context, state);
        }
        if (state is GetNhanVienFailedState) {
          // context.read<LoginProvider>().getNhanVienFailed(context, state);
        }
        if (state is CreateAccountFailedState) {
          AppUtility.showSnackBar(
            context,
            'Tạo account thất bại\nLỗi: ${state.message}',
          );
        }
        if (state is PostLoginFailedState) {
          AppUtility.showSnackBar(context, state.message, isError: true);
        }
      },
    );
  }
}
