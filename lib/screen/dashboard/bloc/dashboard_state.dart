import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/models/duan.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/model/dashboard_report.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<NhanVien> staffs;
  final List<AssetManagementDto> assets;
  final List<PhongBan> departments;
  final List<DuAn> projects;
  final DashboardReport? data;
  const DashboardLoaded(this.staffs, this.assets, this.departments, this.projects, this.data);
  @override
  List<Object?> get props => [staffs, assets, departments, projects, data];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
  @override
  List<Object?> get props => [message];
}
