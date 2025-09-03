import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';

abstract class StaffEvent extends Equatable {
  const StaffEvent();
  @override
  List<Object?> get props => [];
}

class LoadStaffs extends StaffEvent {
  const LoadStaffs();
  @override
  List<Object?> get props => [];
}

class AddStaff extends StaffEvent {
  final NhanVien staff;
  const AddStaff(this.staff);
  @override
  List<Object?> get props => [staff];
}

class UpdateStaff extends StaffEvent {
  final NhanVien staff;
  const UpdateStaff(this.staff);
  @override
  List<Object?> get props => [staff];
}

class DeleteStaff extends StaffEvent {
  final NhanVien staff;
  const DeleteStaff(this.staff);
  @override
  List<Object?> get props => [staff];
}

class SearchStaff extends StaffEvent {
  final String keyword;
  const SearchStaff(this.keyword);
  @override
  List<Object?> get props => [keyword];
} 