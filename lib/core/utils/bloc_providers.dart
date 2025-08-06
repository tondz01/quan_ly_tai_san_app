import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/bloc/asset_category_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/bloc/asset_group_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/asset_transfer_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/asset/bloc/asset_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/asset/bloc/asset_event.dart';
import 'package:quan_ly_tai_san_app/screen/category/asset/models/sample_asset.dart';
import 'package:quan_ly_tai_san_app/screen/category/capital_source/bloc/capital_source_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/capital_source/bloc/capital_source_event.dart';
import 'package:quan_ly_tai_san_app/screen/category/capital_source/models/capital_source.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/bloc/department_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/bloc/department_event.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/bloc/project_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/bloc/project_event.dart';
import 'package:quan_ly_tai_san_app/screen/category/project_manager/models/project.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/bloc/staff_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/bloc/staff_event.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/staff.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/bloc/tool_and_material_transfer_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_bloc.dart';

List<SingleChildWidget> get blocProvider {
  return [
    // BlocProvider<BaseBloc>(
    //   create: (_) => BaseBloc(),
    // ),
    // BlocProvider<ProjectBloc>(create: (_) => ProjectBloc()..add(LoadProjects(sampleProjects()))),
    // BlocProvider<StaffBloc>(create: (_) => StaffBloc()..add(LoadStaffs(sampleStaffDTOs()))),
    BlocProvider<ToolsAndSuppliesBloc>(create: (_) => ToolsAndSuppliesBloc()),
    BlocProvider<AssetTransferBloc>(create: (_) => AssetTransferBloc()),
    BlocProvider<AssetHandoverBloc>(create: (_) => AssetHandoverBloc()),
    BlocProvider<StaffBloc>(create: (_) => StaffBloc()..add(LoadStaffs(sampleStaffDTOs()))),
    BlocProvider<ProjectBloc>(create: (_) => ProjectBloc()..add(LoadProjects(sampleProjects()))),
    BlocProvider<DepartmentBloc>(create: (_) => DepartmentBloc()..add(LoadDepartments(sampleDepartments()))),
    BlocProvider<CapitalSourceBloc>(create: (_) => CapitalSourceBloc()..add(LoadCapitalSources(sampleCapitalSources()))),
    BlocProvider<AssetBloc>(create: (_) => AssetBloc()..add(LoadAssets(sampleAssetDTOs()))),
    BlocProvider<ToolAndMaterialTransferBloc>(create: (_) => ToolAndMaterialTransferBloc()),
    BlocProvider<AssetGroupBloc>(create: (_) => AssetGroupBloc()),
    BlocProvider<AssetManagementBloc>(create: (_) => AssetManagementBloc()),
    BlocProvider<AssetCategoryBloc>(create: (_) => AssetCategoryBloc()),
  ];
}
