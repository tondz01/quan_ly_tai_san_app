import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/repository/asset_management_repository.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/repository/departments_repository.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/models/duan.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/staf_provider/nhan_vien_provider.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/bloc/dashboard_event.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/bloc/dashboard_state.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/model/dashboard_report.dart';
import 'package:quan_ly_tai_san_app/screen/dashboard/repository/dashboard_reponsitory.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  List<NhanVien> _allStaffs = [];
  List<PhongBan> _allDepartments = [];
  List<AssetManagementDto> _allAsset = [];
  List<DuAn> _allProject = [];
  DashboardReport? _data;
  final NhanVienProvider nhanVienProvider = NhanVienProvider();
  final DepartmentRepository departmentsProvider = DepartmentRepository();
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboard>((event, emit) async {
      // Parallel API calls với Future.wait - giảm load time từ 10s xuống 2-3s
      final idCongTy = AccountHelper.instance.getUserInfo()?.idCongTy ?? '';

      final results = await Future.wait([
        AssetManagementRepository().getListAssetManagement("ct001"),
        AssetManagementRepository().getListDuAn("ct001"),
        DashboardRepository().getDashboardData(),
        nhanVienProvider.fetchNhanViens(),
        departmentsProvider.getListDepartment(idCongTy),
      ]);

      // Parse results
      final result = results[0] as Map<String, dynamic>;
      if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
        _allAsset = result['data'];
      }

      final resultProject = results[1] as Map<String, dynamic>;
      if (resultProject['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
        _allProject = resultProject['data'];
      }

      final resultData = results[2] as Map<String, dynamic>;
      if (resultData['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
        var responseData = resultData['data'];
        _data = responseData;
      }

      _allStaffs = results[3] as List<NhanVien>;

      final resultDepartment = results[4] as Map<String, dynamic>;
      if (resultDepartment['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
        _allDepartments = resultDepartment['data'];
      }

      emit(
        DashboardLoaded(
          _allStaffs,
          _allAsset,
          _allDepartments,
          _allProject,
          _data!,
        ),
      );
    });
  }
  List<AssetManagementDto> get allAsset => _allAsset;
  List<NhanVien> get allStaffs => _allStaffs;
  List<PhongBan> get allDepartments => _allDepartments;
  List<DuAn> get allProject => _allProject;
  DashboardReport? get data => _data;
}
