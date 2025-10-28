import 'package:quan_ly_tai_san_app/core/constants/numeral.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/detai_asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/repository/asset_handover_repository.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/repository/asset_management_repository.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/data_map.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/detail_tool_and_material_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/tool_and_supplies_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/repository/tool_and_supplies_handover_repository.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/repository/tools_and_supplies_repository.dart';

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

  Future<Map<String, dynamic>> getReportCCDC(String idDepartment) async {
    Map<String, dynamic> resultReport = {
      'data_increase': [],
      'data_reduce': [],
    };

    try {
      List<ToolAndSuppliesHandoverDto> listCCDCHandover = [];
      Map<String, dynamic> result =
          await ToolAndSuppliesHandoverRepository()
              .getAllToolSupHandoverStatus();
      if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
        listCCDCHandover = result['data'];
      }
      if (listCCDCHandover.isNotEmpty) {
        resultReport['data_increase'] =
            listCCDCHandover
                .where((element) => element.idDonViNhan == idDepartment)
                .toList();
        resultReport['data_reduce'] =
            listCCDCHandover
                .where((element) => element.idDonViGiao == idDepartment)
                .toList();
      }
    } catch (e) {
      return resultReport;
    }
    return resultReport;
  }

  AssetManagementDto? getInfoAsset(
    String idAsset,
    List<AssetManagementDto> listAssetManagement,
  ) {
    if (listAssetManagement.isNotEmpty) {
      return listAssetManagement.firstWhere(
        (element) => element.id == idAsset,
        orElse: () => AssetManagementDto.empty(),
      );
    }
    return AssetManagementDto.empty();
  }

  ToolsAndSuppliesDto? getInfoCCDC(
    String idAsset,
    List<ToolsAndSuppliesDto> listToolsAndSupplies,
  ) {
    if (listToolsAndSupplies.isNotEmpty) {
      return listToolsAndSupplies.firstWhere( 
        (element) => element.id == idAsset,
        orElse: () => ToolsAndSuppliesDto.empty(),
      );
    }
    return ToolsAndSuppliesDto.empty();
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

  Future<List<ToolsAndSuppliesDto>> getListCCDC(String idCongTy) async {
    List<ToolsAndSuppliesDto> list = [];
    Map<String, dynamic> result = await ToolsAndSuppliesRepository()
        .getListToolsAndSupplies(idCongTy);

    if (result['status_code'] == Numeral.STATUS_CODE_SUCCESS) {
      list = result['data'];
    }    return list;
  }

  List<DataMap> mapIncrease(
    List<DetailAssetHandoverDto> list,
    List<AssetManagementDto> assets,
  ) {
    return list.map((dto) {
      AssetManagementDto? assetInfo = getInfoAsset(dto.idTaiSan ?? '', assets);
      return DataMap(
        tenTaiSan: dto.tenTaiSan,
        soHieu: dto.soKyHieu,
        ngayThang: dto.ngayTao,
        donViTinh: dto.donViTinh,
        soLuong: dto.soLuong,
        donGia: assetInfo?.nguyenGia ?? 0,
        soTien: assetInfo?.nguyenGia,
        type: DataMapType.INCREASE,
        // các trường còn lại để null
      );
    }).toList();
  }

  List<DataMap> mapReduce(
    List<DetailAssetHandoverDto> list,
    List<AssetManagementDto> assets,
  ) {
    return list.map((dto) {
      AssetManagementDto? assetInfo = getInfoAsset(dto.idTaiSan ?? '', assets);
      return DataMap(
        tenTaiSan: dto.tenTaiSan,
        soHieu: dto.soKyHieu,
        ngayThang: dto.ngayTao,
        donViTinh: dto.donViTinh,
        soLuong: dto.soLuong,
        donGia: assetInfo?.nguyenGia ?? 0,
        soTien: assetInfo?.nguyenGia,
        type: DataMapType.REDUCE,
        // các trường còn lại để null
      );
    }).toList();
  }

  List<DataMap> mapIncreaseCCDC(
    List<DetailToolAndMaterialTransferDto> list,
    List<ToolsAndSuppliesDto> assets,
  ) {
    return list.map((dto) {
      ToolsAndSuppliesDto? assetInfo = getInfoCCDC(dto.idCCDCVatTu, assets);
      return DataMap(
        tenTaiSan: dto.tenCCDCVatTu,
        soHieu: dto.soKyHieu,
        ngayThang: dto.ngayTao,
        donViTinh: dto.donViTinh,
        soLuong: dto.soLuong,
        donGia: assetInfo?.giaTri ?? 0,
        soTien: assetInfo?.giaTri ?? 0,
        type: DataMapType.INCREASE,
        // các trường còn lại để null
      );
    }).toList();
  }

  List<DataMap> mapReduceCCDC(
    List<DetailToolAndMaterialTransferDto> list,
    List<ToolsAndSuppliesDto> assets,
  ) {
    return list.map((dto) {
      ToolsAndSuppliesDto? assetInfo = getInfoCCDC(dto.idCCDCVatTu, assets);
      return DataMap(
        tenTaiSan: dto.tenCCDCVatTu,
        soHieu: dto.soKyHieu,
        ngayThang: dto.ngayTao,
        donViTinh: dto.donViTinh,
        soLuong: dto.soLuong,
        donGia: assetInfo?.giaTri ?? 0,
        soTien: assetInfo?.giaTri ?? 0,
        type: DataMapType.REDUCE,
        // các trường còn lại để null
      );
    }).toList();
  }
}
