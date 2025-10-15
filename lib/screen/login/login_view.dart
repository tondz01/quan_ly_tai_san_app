import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/widgets/gradient_header.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_image.dart';
import 'package:quan_ly_tai_san_app/main.dart';
import 'package:quan_ly_tai_san_app/routes/app_route_path.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/login/bloc/login_state.dart';
import 'package:quan_ly_tai_san_app/screen/login/provider/login_provider.dart';
import 'package:quan_ly_tai_san_app/screen/login/widget/login_input_view.dart';

import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_text.dart';

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

                  body: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/background.jpg"),
                            fit:
                                BoxFit
                                    .cover, // cover, contain, fill, fitWidth, fitHeight
                          ),
                        ),
                        child: Column(
                          children: [
                            GradientHeaderLogin(
                              title: 'PHẦN MỀM QUẢN LÝ TÀI SẢN',
                              onLogoTap: () {
                                // Handle logo tap if needed
                              },
                            ),
                           
                            SizedBox(height: 150),
                            Center(
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
                          ],
                        ),
                      ),
                      Positioned(
                        left: 20,
                        bottom: 20,
                        child: SGText(
                          text:
                              'quanlytaisan - Version: ${Config.appVersion}_${Config.appBuild}',
                          size: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
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

class GradientHeaderLogin extends StatelessWidget {
  final String? logoPath;
  final String title;
  final double height;
  final VoidCallback? onLogoTap;

  const GradientHeaderLogin({
    super.key,
    this.logoPath,
    required this.title,
    this.height = 120.0,
    this.onLogoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF009E60), // Dark blue left
            Color(0xFF026E42), // Green center
            Color(0xFF026E42), // Dark blue right
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Color bands decoration
          _buildColorBands(),
          // Main content
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo section
                  if (logoPath != null)
                    CircleAvatar(
                      radius: 32,
                      child: Image.asset(
                        logoPath ?? AppImage.imageLogo,
                        fit: BoxFit.cover,
                      ), // kích thước avatar
                    ),
                  const SizedBox(width: 24),
                  // Title section
                  _buildTitle(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorBands() {
    return Positioned.fill(child: CustomPaint(painter: ColorBandsPainter()));
  }

  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 50,
              fontWeight: FontWeight.w700,
              fontFamily: 'serif',
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ColorBandsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Define color bands
    final bands = [];

    double currentY = 0;

    for (final band in bands) {
      final paint =
          Paint()
            ..color = band['color'] as Color
            ..style = PaintingStyle.fill;

      final rect = Rect.fromLTWH(
        0,
        currentY,
        size.width,
        band['height'] as double,
      );

      canvas.drawRect(rect, paint);
      currentY += band['height'] as double;
    }

    // Add diagonal stripes for more visual interest
    final stripePaint =
        Paint()
          ..color = Colors.white.withOpacity(0.1)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    for (int i = 0; i < 8; i++) {
      final startX = (size.width / 8) * i;
      final endX = startX + (size.width / 4);
      final startY = size.height * 0.2;
      final endY = size.height * 0.8;

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), stripePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
