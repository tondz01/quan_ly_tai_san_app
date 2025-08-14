import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/Category/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';

class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

// Define LoginInitialState class.
class LoginInitialState extends LoginState {}

// Define LoginLoadingState class.
class LoginLoadingState extends LoginState {}

// Define LoginLoadingDismissState class.
class LoginLoadingDismissState extends LoginState {}

// Define PostLoginSuccessState class.
class PostLoginSuccessState extends LoginState {
  final UserInfoDTO? data;

  const PostLoginSuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

// Define PostLoginFailedState class.
class PostLoginFailedState extends LoginState {
  final String title;
  final String message;
  final int code;

  const PostLoginFailedState({
    required this.title,
    required this.message,
    required this.code,
  });

  @override
  List<Object> get props => [title, message, code];

  Map<String, dynamic> toMap() {
    return {'code': code, 'title': title, 'message': message};
  }
}

class GetNhanVienSuccessState extends LoginState {
  final List<NhanVien> data;
  const GetNhanVienSuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class GetUsersSuccessState extends LoginState {
  final List<UserInfoDTO> data;
  const GetUsersSuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class CreateAccountSuccessState extends LoginState {
  final dynamic data;
  const CreateAccountSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateUserSuccessState extends LoginState {
  final UserInfoDTO user;
  const UpdateUserSuccessState(this.user);

  @override
  List<Object> get props => [user];
}

class CreateAccountFailedState extends LoginState {
  final String title;
  final int code;
  final String message;

  const CreateAccountFailedState({
    required this.title,
    required this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code, message];
}

class DeleteUserSuccessState extends LoginState {
  const DeleteUserSuccessState();
}

class GetUsersFailedState extends LoginState {
  final String title;
  final int code;
  final String message;

  const GetUsersFailedState({
    required this.title,
    required this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code, message];
}
class GetNhanVienFailedState extends LoginState {
  final String title;
  final int code;
  final String message;

  const GetNhanVienFailedState({
    required this.title,
    required this.code,
    required this.message,
  });

  @override
  List<Object> get props => [title, code, message];
}
