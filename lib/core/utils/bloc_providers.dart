import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import 'package:quan_ly_tai_san_app/screen/Category/project_manager/bloc/project_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/Category/project_manager/bloc/project_event.dart';
import 'package:quan_ly_tai_san_app/screen/Category/project_manager/models/project.dart';
import 'package:quan_ly_tai_san_app/screen/Category/staff/bloc/staff_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/Category/staff/bloc/staff_event.dart';
import 'package:quan_ly_tai_san_app/screen/Category/staff/models/staff.dart';
import 'package:quan_ly_tai_san_app/screen/ToolsAndSupplies/bloc/tools_and_supplies_bloc.dart';

List<SingleChildWidget> get blocProvider {
  return [
    // BlocProvider<BaseBloc>(
    //   create: (_) => BaseBloc(),
    // ),
    BlocProvider<ProjectBloc>(create: (_) => ProjectBloc()..add(LoadProjects(sampleProjects()))),
    BlocProvider<StaffBloc>(create: (_) => StaffBloc()..add(LoadStaffs(sampleStaffDTOs()))),
    BlocProvider<ToolsAndSuppliesBloc>(create: (_) => ToolsAndSuppliesBloc()),
  ];
}
