import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/staff.dart';

abstract class StaffEvent extends Equatable {
  const StaffEvent();
  @override
  List<Object?> get props => [];
}

class LoadStaffs extends StaffEvent {
  final List<StaffDTO> staffs;
  const LoadStaffs(this.staffs);
  @override
  List<Object?> get props => [staffs];
}

class AddStaff extends StaffEvent {
  final StaffDTO staff;
  const AddStaff(this.staff);
  @override
  List<Object?> get props => [staff];
}

class UpdateStaff extends StaffEvent {
  final StaffDTO staff;
  const UpdateStaff(this.staff);
  @override
  List<Object?> get props => [staff];
}

class DeleteStaff extends StaffEvent {
  final StaffDTO staff;
  const DeleteStaff(this.staff);
  @override
  List<Object?> get props => [staff];
} 