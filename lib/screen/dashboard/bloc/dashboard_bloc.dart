import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/repository/asset_management_repository.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/providers/departments_provider.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/models/duan.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/staf_provider.dart/nhan_vien_provider.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/bloc/dashboard_event.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  List<NhanVien> _allStaffs = [];
  List<PhongBan> _allDepartments = [];
  List<AssetManagementDto> _allAsset = [];
  List<DuAn> _allProject = [];
  final NhanVienProvider nhanVienProvider = NhanVienProvider();
  final DepartmentsProvider departmentsProvider = DepartmentsProvider();
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboard>((event, emit) async {
      Map<String, dynamic> result = await AssetManagementRepository().getListAssetManagement("ct001");
      if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
        _allAsset = result['data'];
      }

      Map<String, dynamic> resultProject = await AssetManagementRepository().getListDuAn("ct001");
      if (resultProject['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
        _allProject = resultProject['data'];
      }

      _allStaffs = await nhanVienProvider.fetchNhanViens();
      _allDepartments = await departmentsProvider.fetchDepartments();

      emit(DashboardLoaded(_allStaffs, _allAsset, _allDepartments, _allProject));
    });
  }
  List<AssetManagementDto> get allAsset => _allAsset;
  List<NhanVien> get allStaffs => _allStaffs;
  List<PhongBan> get allDepartments => _allDepartments;
  List<DuAn> get allProject => _allProject;
}
