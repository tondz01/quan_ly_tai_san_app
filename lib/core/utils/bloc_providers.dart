import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/asset_transfer_bloc.dart';
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
  ];
}
