import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/screen/ToolsAndSupplies/bloc/tools_and_supplies_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/ToolsAndSupplies/provider/tools_and_supplies_provide.dart';
import 'package:quan_ly_tai_san_app/screen/ToolsAndSupplies/tools_and_supplies_view.dart';

class App extends GetView {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ToolsAndSuppliesBloc>(create: (BuildContext context) => ToolsAndSuppliesBloc()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ToolsAndSuppliesProvider(),),
        ],
        child: GestureDetector(
          onTap: () {
            Get.focusScope!.unfocus();
            FocusScope.of(context).unfocus();
          },
          child: ScreenUtilInit(
            // designSize: ,
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Quan Ly Tai San',
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.deepPurple,
                  ),
                ),
                home: ToolsAndSuppliesView(),
              );
            },
          ),
        ),
      ),
    );
  }
}
