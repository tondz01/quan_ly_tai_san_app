import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/core/utils/bloc_providers.dart';
import 'package:quan_ly_tai_san_app/core/utils/providers.dart';
import 'package:quan_ly_tai_san_app/injection.dart';
import 'package:quan_ly_tai_san_app/locale/locale_controller.dart';
import 'package:quan_ly_tai_san_app/routes/app_route_conf.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:quan_ly_tai_san_app/screen/login/repository/auth_repository.dart';
import 'package:se_gay_components/common/sg_popup_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    final userInfo = AccountHelper.instance.getUserInfo() ?? UserInfoDTO.empty();
    // _loadDataIfNeeded(userInfo);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = locator<AppRouteConf>().router;

    return MultiBlocProvider(
      providers: blocProvider,
      child: MultiProvider(
        providers: providers,
        child: GestureDetector(
          onTap: () {
            primaryFocus?.unfocus();
            FocusScope.of(context).unfocus();
            SGPopupManager().closeAllPopups();
          },
          child: GetMaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Quan Ly Tai San',
            theme: ThemeData.light(),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('vi', 'VN'), Locale('en', 'US')],
            locale: const Locale('vi', 'VN'),
            fallbackLocale: const Locale('en', 'US'),
            translations: MyLocale(),
            routerDelegate: router.routerDelegate,
            routeInformationParser: router.routeInformationParser,
            routeInformationProvider: router.routeInformationProvider,
          ),
        ),
      ),
    );
  }

  Future<void> _loadDataIfNeeded(UserInfoDTO userInfo) async {
    log('message test: _loadDataIfNeeded');
    if (userInfo.idCongTy.isNotEmpty) {
      log('message test: _loadDataIfNeeded 2');
      await AuthRepository().loadData(userInfo.idCongTy);
    }
  }
}
