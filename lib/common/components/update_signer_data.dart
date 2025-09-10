import 'dart:developer';

import 'package:quan_ly_tai_san_app/common/widgets/additional_signers_selector.dart';
import 'package:quan_ly_tai_san_app/core/utils/uuid_generator.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';
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
      final repo = SignatoryRepository();

      // Lấy danh sách signatories hiện tại từ server
      final existingSignatories = await repo.getAll(idTaiLieu);

      // Xóa tất cả signatories hiện tại
      for (final signatory in existingSignatories) {
        if (signatory.id != null && signatory.id!.isNotEmpty) {
          await repo.delete(signatory.id!);
        }
      }

      // Tạo lại signatories mới
      for (final signerData in additionalSignersDetailed) {
        if (signerData.department?.id != null &&
            signerData.employee?.id != null) {
          final signatory = SignatoryDto(
            id: UUIDGenerator.generateWithFormat('NK-************'),
            idTaiLieu: idTaiLieu,
            idNguoiKy: signerData.employee?.id,
            idPhongBan: signerData.department?.id,
            tenNguoiKy: signerData.employee?.hoTen,
            trangThai: 0,
          );
          await repo.create(signatory);
        }
      }
    } catch (e) {
      log('Sync signatories error: $e');
    }
  }
}
