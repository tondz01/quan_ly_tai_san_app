import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_event.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_state.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:se_gay_components/common/sg_text.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  void _showUserDialog(BuildContext context, {UserInfoDTO? user}) {
    // TODO: Hiển thị dialog nhập thông tin user (dùng cho thêm/sửa)
    // Nếu user == null => Thêm, ngược lại là Sửa
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(user == null ? 'Thêm User' : 'Sửa User'),
            content: const Text('TODO: Form nhập user'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Gửi event thêm/sửa user
                  Navigator.of(context).pop();
                },
                child: const Text('Lưu'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => LoginBloc()..add(const GetUsersEvent()),
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is LoginLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is GetUsersSuccessState) {
              final users = state.users;
              if (users.isEmpty) {
                return const Center(child: Text('No users found'));
              }
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SGText(text: 'Danh sách User', size: 24, fontWeight: FontWeight.bold,),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _showUserDialog(context),
                          tooltip: 'Thêm User',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: users.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return ListTile(
                          // leading: CircleAvatar(
                          //   child: Text(user.tenDangNhap[0].toUpperCase()),
                          // ),
                          title: Text(user.hoTen),
                          subtitle: Text(user.email ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                tooltip: 'Sửa',
                                onPressed:
                                    () => _showUserDialog(context, user: user),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                tooltip: 'Xóa',
                                onPressed: () {
                                  // TODO: Gửi event xóa user
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            if (state is PostLoginFailedState) {
              return Center(child: Text('Error:  ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserDialog(context),
        tooltip: 'Thêm User',
        child: const Icon(Icons.add),
      ),
    );
  }
}
