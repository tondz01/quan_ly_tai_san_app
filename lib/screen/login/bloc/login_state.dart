import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/auth_dto.dart';
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
  final AuthDTO? data;

  const PostLoginSuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

// Define PostLoginFailedState class.
class PostLoginFailedState extends LoginState {
  final String title;
  final String message;
  final int code;

  const PostLoginFailedState({required this.title, required this.message, required this.code});

  @override
  List<Object> get props => [title, message, code];

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'title': title,
      'message': message,
    };
  }
}

class GetUsersSuccessState extends LoginState {
  final List<UserInfoDTO> users;
  const GetUsersSuccessState(this.users);

  @override
  List<Object> get props => [users];
}

class CreateUserSuccessState extends LoginState {
  final UserInfoDTO user;
  const CreateUserSuccessState(this.user);

  @override
  List<Object> get props => [user];
}

class UpdateUserSuccessState extends LoginState {
  final UserInfoDTO user;
  const UpdateUserSuccessState(this.user);

  @override
  List<Object> get props => [user];
}

class DeleteUserSuccessState extends LoginState {
  const DeleteUserSuccessState();
}