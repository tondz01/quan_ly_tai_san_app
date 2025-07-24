import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/Category/capital_source/bloc/capital_source_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/Category/capital_source/bloc/capital_source_event.dart';
import 'package:quan_ly_tai_san_app/screen/Category/capital_source/models/capital_source.dart';
import 'package:quan_ly_tai_san_app/screen/Category/departments/bloc/department_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/Category/departments/bloc/department_event.dart';
import 'package:quan_ly_tai_san_app/screen/Category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/Category/project_manager/bloc/project_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/Category/project_manager/bloc/project_event.dart';
import 'package:quan_ly_tai_san_app/screen/Category/project_manager/models/project.dart';
import 'package:quan_ly_tai_san_app/screen/Category/staff/bloc/staff_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/Category/staff/bloc/staff_event.dart';
import 'package:quan_ly_tai_san_app/screen/Category/staff/models/staff.dart';
import 'package:se_gay_components/web_base/sg_web_base.dart';
import 'package:quan_ly_tai_san_app/utils/menu_items.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  int? selectedSubIndex;

  // Xóa khai báo menuItems cũ

  @override
  Widget build(BuildContext context) {
    String? mainId = menuItems[selectedIndex].idMenu;
    String? subId =
        (selectedSubIndex != null && menuItems[selectedIndex].children != null)
            ? menuItems[selectedIndex].children![selectedSubIndex!].idMenu
            : null;

    Widget body;
    if (subId != null && subPages.containsKey(subId)) {
      body = subPages[subId]!;
    } else if (mainId != null && pages.containsKey(mainId)) {
      body = pages[mainId]!;
    } else {
      body = const SizedBox();
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProjectBloc>(
          create: (_) => ProjectBloc()..add(LoadProjects(sampleProjects())),
        ),
        BlocProvider<StaffBloc>(
          create: (_) => StaffBloc()..add(LoadStaffs(sampleStaffDTOs())),
        ),
        BlocProvider<DepartmentBloc>(
          create: (_) => DepartmentBloc()..add(LoadDepartments(sampleDepartments())),
        ),
        BlocProvider<CapitalSourceBloc>(
          create: (_) => CapitalSourceBloc()..add(LoadCapitalSources(sampleCapitalSources())),
        ),
        
      ],
      child: SGWebBase(
        menuItems: menuItems,
        selectedIndex: selectedIndex,
        selectedSubIndex: selectedSubIndex,
        name: 'SeGay',
        onItemSelected: (index, [subIndex]) {
          setState(() {
            selectedIndex = index;
            selectedSubIndex = subIndex;
          });
        },
        body: body,
      ),
    );
  }
}
