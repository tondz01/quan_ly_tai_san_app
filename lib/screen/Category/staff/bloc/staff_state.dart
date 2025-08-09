import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/nhan_vien.dart';

abstract class StaffState extends Equatable {
  const StaffState();
  @override
  List<Object?> get props => [];
}

class StaffInitial extends StaffState {}

class StaffLoaded extends StaffState {
  final List<NhanVien> staffs;
  const StaffLoaded(this.staffs);
  @override
  List<Object?> get props => [staffs];
}

class StaffError extends StaffState {
  final String message;
  const StaffError(this.message);
  @override
  List<Object?> get props => [message];
} 