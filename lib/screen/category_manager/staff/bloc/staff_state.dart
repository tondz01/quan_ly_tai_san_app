import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';

abstract class StaffState extends Equatable {
  const StaffState();
  @override
  List<Object?> get props => [];
}

class StaffInitialState extends StaffState {}

class StaffLoadingState extends StaffState {}

class StaffLoadingDismissState extends StaffState {}

class AddStaffSuccessState extends StaffState {
  final String message;
  const AddStaffSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}

class UpdateStaffSuccessState extends StaffState {
  final String message;
  const UpdateStaffSuccessState(this.message);
  @override
  List<Object?> get props => [message];
}



class DeleteStaffBatchSuccess extends StaffState {}

class DeleteStaffBatchFailure extends StaffState {
  final String message;
  const DeleteStaffBatchFailure(this.message);
  @override
  List<Object?> get props => [message];
}

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
