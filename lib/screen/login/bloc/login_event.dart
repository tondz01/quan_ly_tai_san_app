import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/request/auth/auth_request.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class PostLoginEvent extends LoginEvent {
  final AuthRequest params;

  const PostLoginEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class GetUsersEvent extends LoginEvent {
  const GetUsersEvent();
  
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class CreateUserEvent extends LoginEvent {
  final UserInfoDTO user;
  const CreateUserEvent(this.user);

  @override
  List<Object?> get props => [user];
}

class UpdateUserEvent extends LoginEvent {
  final String id;
  final UserInfoDTO user;
  const UpdateUserEvent(this.id, this.user);

  @override
  List<Object?> get props => [id, user];
}

class DeleteUserEvent extends LoginEvent {
  final String id;
  const DeleteUserEvent(this.id);

  @override
  List<Object?> get props => [id];
}