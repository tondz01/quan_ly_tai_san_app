import 'dart:convert';
import 'dart:developer';

import 'package:quan_ly_tai_san_app/common/widgets/additional_signers_selector.dart';
import 'package:quan_ly_tai_san_app/core/utils/uuid_generator.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/asset_transfer_reponsitory.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/repository/signatory_repository.dart';

class UpdateSignerData {
  List<Map<String, dynamic>> normalizeSignatories(
    List<AdditionalSignerData> list,
  ) {
    final data =
        list
            .map(
              (d) => {
                'idPhongBan': d.department?.id ?? '',
                'idNguoiKy': d.employee?.id ?? '',
                'tenNguoiKy': d.employee?.hoTen ?? '',
              },
            )
            .toList();
    data.sort(
      (a, b) => (a['idNguoiKy'] as String).compareTo(b['idNguoiKy'] as String),
    );
    return data;
  }

  Future<void> syncSignatories(
    String idTaiLieu,
    List<AdditionalSignerData> additionalSignersDetailed,
  ) async {
    try {
      // final repo = SignatoryRepository();

      log('message additionalSigners idTaiLieu: $idTaiLieu');
      final result = await AssetTransferRepository().updateSignatory(
        idTaiLieu,
        additionalSignersDetailed
            .map(
              (e) => SignatoryDto(
                id: UUIDGenerator.generateWithFormat('NK-************'),
                idTaiLieu: idTaiLieu,
                idNguoiKy: e.employee?.id,
                idPhongBan: e.department?.id,
                tenNguoiKy: e.employee?.hoTen,
                trangThai: 0,
              ),
            )
            .toList(),
      );
      log('message [additionalSigners] syncSignatories result: ${jsonEncode(result)}');
    } catch (e) {
      log('Sync signatories error: $e');
    }
  }
}
