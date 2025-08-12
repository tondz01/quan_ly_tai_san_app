import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart' as dio;
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/login/repository/auth_repository.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_event.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_state.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/auth_dto.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<PostLoginEvent>(_postLogin);
    on<GetUsersEvent>(_getUsers);
    on<CreateUserEvent>(_createUser);
    on<UpdateUserEvent>(_updateUser);
    on<DeleteUserEvent>(_deleteUser);
  }

  // Handle PostLoginEvent.
  //
  // Call method postLogin(event) api in AuthRepository.
  // Handle LoginSuccessState or LoginFailedState.
  // Emit to view.
  Future<void> _postLogin(
    PostLoginEvent event,
    Emitter emit,
  ) async {
    emit(LoginInitialState());
    emit(LoginLoadingState());
    Map<String, dynamic> result = await AuthRepository()
        .login(event.params);
    emit(LoginLoadingDismissState());
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      emit(PostLoginSuccessState(data: result['data']));
    } else {
      String msg = "Lỗi khi lấy dữ liệu ${result['status_code']}";
      log('message result ${result['status_code']}');
      emit(
        PostLoginFailedState(
          title: "notice",
          code: result['status_code'],
          message: msg,
        ),
      );
    }
  }


  Future<void> _getUsers(GetUsersEvent event, Emitter emit) async {
    emit(LoginLoadingState());
    try {
      final result = await AuthRepository().getUsers();
      emit(LoginLoadingDismissState());
      if (result.statusCode == 200 && result.data != null) {
        emit(GetUsersSuccessState(result.data!));
      } else {
        emit(
          PostLoginFailedState(
            title: "notice",
            code: result.statusCode ?? -1,
            message: result.statusMessage ?? '',
          ),
        );
      }
    } catch (e) {
      emit(LoginLoadingDismissState());
      emit(
        PostLoginFailedState(title: "error", code: -1, message: e.toString()),
      );
    }
  }

  Future<void> _createUser(CreateUserEvent event, Emitter emit) async {
    emit(LoginLoadingState());
    try {
      final result = await AuthRepository().createUser(event.user);
      emit(LoginLoadingDismissState());
      if (result.statusCode == 200 && result.data != null) {
        emit(CreateUserSuccessState(result.data!));
      } else {
        emit(
          PostLoginFailedState(
            title: "notice",
            code: result.statusCode ?? -1,
            message: result.statusMessage ?? '',
          ),
        );
      }
    } catch (e) {
      emit(LoginLoadingDismissState());
      emit(
        PostLoginFailedState(title: "error", code: -1, message: e.toString()),
      );
    }
  }

  Future<void> _updateUser(UpdateUserEvent event, Emitter emit) async {
    emit(LoginLoadingState());
    try {
      final result = await AuthRepository().updateUser(event.id, event.user);
      emit(LoginLoadingDismissState());
      if (result.statusCode == 200 && result.data != null) {
        emit(UpdateUserSuccessState(result.data!));
      } else {
        emit(
          PostLoginFailedState(
            title: "notice",
            code: result.statusCode ?? -1,
            message: result.statusMessage ?? '',
          ),
        );
      }
    } catch (e) {
      emit(LoginLoadingDismissState());
      emit(
        PostLoginFailedState(title: "error", code: -1, message: e.toString()),
      );
    }
  }

  Future<void> _deleteUser(DeleteUserEvent event, Emitter emit) async {
    emit(LoginLoadingState());
    try {
      final result = await AuthRepository().deleteUser(event.id);
      emit(LoginLoadingDismissState());
      if (result.statusCode == 200) {
        emit(DeleteUserSuccessState());
      } else {
        emit(
          PostLoginFailedState(
            title: "notice",
            code: result.statusCode ?? -1,
            message: result.statusMessage ?? '',
          ),
        );
      }
    } catch (e) {
      emit(LoginLoadingDismissState());
      emit(
        PostLoginFailedState(title: "error", code: -1, message: e.toString()),
      );
    }
  }
}
