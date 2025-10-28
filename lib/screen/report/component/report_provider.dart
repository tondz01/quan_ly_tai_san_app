import 'dart:convert';
import 'dart:developer';

import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/repository/asset_handover_repository.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/repository/asset_management_repository.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';

class ReportProvider {
  Future<Map<String, dynamic>> getReportAsset(String idDepartment) async {
    Map<String, dynamic> resultReport = {
      'data_increase': [],
      'data_reduce': [],
    };

    try {
      List<AssetHandoverDto> listAssetHandover = [];
      Map<String, dynamic> result =
          await AssetHandoverRepository().getAllAssetHandover();
      if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
        listAssetHandover = result['data'];
      }
      if (listAssetHandover.isNotEmpty) {
        resultReport['data_increase'] =
            listAssetHandover
                .where((element) => element.idDonViNhan == idDepartment)
                .toList();
        resultReport['data_reduce'] =
            listAssetHandover
                .where((element) => element.idDonViGiao == idDepartment)
                .toList();
      }
    } catch (e) {
      return resultReport;
    }
    return resultReport;
  }

  Future<List<AssetManagementDto>> getListAsset() async {
    List<AssetManagementDto> list = [];
    Map<String, dynamic> result = await AssetManagementRepository()
        .getListAssetManagement('ct001');
    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      list = result['data'];
    }
    return list;
  }
}
