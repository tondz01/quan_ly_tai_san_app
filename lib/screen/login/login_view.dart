import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/routes/app_route_path.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_state.dart';
import 'package:quan_ly_tai_san_app/screen/login/provider/login_provider.dart';
import 'package:quan_ly_tai_san_app/screen/login/widget/login_input_view.dart';

import 'package:se_gay_components/common/sg_colors.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  void hideLoadingDialog(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: ChangeNotifierProvider(
        create: (_) => LoginProvider(),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginInitialState) {}
            if (state is LoginLoadingState) {
              showLoadingDialog(context);
            }
            if (state is LoginLoadingDismissState) {
              hideLoadingDialog(context);
            }
            if (state is PostLoginSuccessState) {
              hideLoadingDialog(context);
              context.read<LoginProvider>().onLoginSuccess(context, state);
            }
            if (state is PostLoginFailedState) {
              hideLoadingDialog(context);
              context.read<LoginProvider>().onLoginFailed(state);
            }
          },
          builder: (BuildContext context, LoginState state) {
            return Consumer<LoginProvider>(
              builder: (loginProviderContext, provider, child) {
                if (provider.isLoggedIn) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.go(AppRoute.dashboard.path);
                  });
                }
                return Scaffold(
                  backgroundColor: SGAppColors.neutral100,

                  body: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/background.jpg"),
                        fit:
                            BoxFit
                                .cover, // cover, contain, fill, fitWidth, fitHeight
                      ),
                    ),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Container(
                          width: 400,
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: LoginInputView(
                            data: provider.authRequest,
                            errorText: provider.error,
                            onLogin: (data) {
                              log('message LoginInputView');
                              provider.onPressLogin(context, data);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
