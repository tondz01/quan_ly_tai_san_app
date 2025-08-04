import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/bloc/staff_state.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/staff.dart';
import 'staff_event.dart';

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  List<StaffDTO> _allStaffs = [];
  StaffBloc() : super(StaffInitial()) {
    on<LoadStaffs>((event, emit) {
      _allStaffs = List.from(event.staffs);
      emit(StaffLoaded(_allStaffs));
    });
    on<SearchStaff>((event, emit) {
      final searchLower = event.keyword.toLowerCase();
      final filtered =  _allStaffs.where((item) {
      bool nameMatch = AppUtility.fuzzySearch(item.name.toLowerCase(), searchLower);
      
      bool staffIdMatch = item.staffId.toLowerCase().contains(searchLower);
      
      bool staffOwnerMatch = AppUtility.fuzzySearch(item.staffOwner.toLowerCase(), searchLower);
      
      bool departmentMatch = AppUtility.fuzzySearch(item.department.toLowerCase(), searchLower);
      
      bool activityMatch = AppUtility.fuzzySearch(item.activity.toLowerCase(), searchLower);
      
      bool positionMatch = AppUtility.fuzzySearch(item.position.toLowerCase(), searchLower);
      
      bool timeMatch = item.timeForActivity.toLowerCase().contains(searchLower);
      
      return nameMatch || staffIdMatch || staffOwnerMatch || 
             departmentMatch || activityMatch || positionMatch || timeMatch;
    }).toList();
      emit(StaffLoaded(filtered));

    });
    on<AddStaff>((event, emit) {
      if (state is StaffLoaded) {
        final staffs = List<StaffDTO>.from((state as StaffLoaded).staffs);
        staffs.add(event.staff);
        emit(StaffLoaded(staffs));
      } else {
        emit(StaffLoaded([event.staff]));
      }
    });
    on<UpdateStaff>((event, emit) {
      if (state is StaffLoaded) {
        final staffs = List<StaffDTO>.from((state as StaffLoaded).staffs);
        final index = staffs.indexWhere((element) => element.staffId == event.staff.staffId);
        if (index != -1) {
          staffs[index] = event.staff;
        }
        emit(StaffLoaded(staffs));
      }
    });
    on<DeleteStaff>((event, emit) {
      if (state is StaffLoaded) {
        final staffs = List<StaffDTO>.from((state as StaffLoaded).staffs);
        staffs.removeWhere((element) => element.staffId == event.staff.staffId);
        emit(StaffLoaded(staffs));
      }
    });
  }
} 