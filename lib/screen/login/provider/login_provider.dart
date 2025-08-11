import 'package:flutter/cupertino.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/routes/routes.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_event.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_state.dart';
import 'package:quan_ly_tai_san_app/screen/login/request/auth/auth_request.dart';

class LoginProvider with ChangeNotifier {
  get authRequest => _authRequest;
  get error => _error;

  AuthRequest _authRequest = AuthRequest(tenDangNhap: "", matKhau: "");
  String? _error;

  // onInit method
  onInit(BuildContext context) {
    // AppLog.d("onInit LoginProvider");
  }

  // onDispose method
  onDispose() {}

  // onPressLogin method
  onPressLogin(BuildContext context, AuthRequest data) {
    Get.focusScope?.unfocus();
    _authRequest = data;
    if (context.mounted) {
      context.read<LoginBloc>().add(PostLoginEvent(_authRequest));
    }
    notifyListeners();
  }

  // onLoginSuccess method
  onLoginSuccess(BuildContext context, PostLoginSuccessState data, Widget child) async {
    _error = null;
    print('LOGIN DONE');
    notifyListeners();
    // AppR.instance.navigateAndRemove(
    //   navigatorKey: AppRoutes.instance.navigatorKey,
    //   routeName: Routes.APP_NAVIGATOR,
    // );
    // Get.to(const MyHomePage());
    // Get.to(const MyHomePageView());
    context.go(AppRoute.assetHandover.path, extra: child);
  }

  // onLoginFailed method
  onLoginFailed(PostLoginFailedState state) {
    _error =
        state.message.contains("The connection errored")
            ? "message.error_call_fail_api".tr
            : state.message;
    notifyListeners();
  }
}
