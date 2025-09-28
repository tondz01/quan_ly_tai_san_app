import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/bloc/staff_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/bloc/staff_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/component/upload_file_signature.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/constants/staff_constants.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/model/chuc_vu.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';

class StaffSaveService {
  static Future<bool> save({
    required BuildContext context,
    required NhanVien? existingStaff,
    // controllers/values
    required TextEditingController nameController,
    required TextEditingController telController,
    required TextEditingController emailController,
    required TextEditingController staffIdController,
    required TextEditingController agreementUUIdController,
    required TextEditingController pinController,
    required bool laQuanLy,
    required bool kyNhay,
    required bool kyThuong,
    required bool kySo,
    required PhongBan? phongBan,
    required NhanVien? staffDTO,
    required ChucVu? chucVuDTO,
    required bool isActive,
    // files
    required File? selectedFileChuKyNhay,
    required File? selectedFileChuKyThuong,
    required String? fileNameChuKyNhay,
    required String? fileNameChuKyThuong,
    required Uint8List? chuKyNhayData,
    required Uint8List? chuKyThuongData,
    required bool savePin,
  }) async {
    final userInfoDTO = AccountHelper.instance.getUserInfo();

    String s(String? v) => (v ?? '').trim();
    bool b(bool? v) => v ?? false;

    // Chỉ xem là "chọn file mới" nếu path khác path chữ ký cũ
    final bool isNewNhaySelected =
        selectedFileChuKyNhay != null &&
        s(selectedFileChuKyNhay.path) != s(existingStaff?.chuKyNhay);
    final bool isNewThuongSelected =
        selectedFileChuKyThuong != null &&
        s(selectedFileChuKyThuong.path) != s(existingStaff?.chuKyThuong);

    bool hasStaffChanged(NhanVien oldV, NhanVien newV) {
      // So sánh các trường nghiệp vụ; bỏ qua các trường hệ thống (ngày tạo/cập nhật, người tạo/cập nhật)
      final String oldDept = s(oldV.boPhan ?? oldV.phongBanId);
      final String newDept = s(newV.boPhan ?? newV.phongBanId);
      return s(oldV.id) != s(newV.id) ||
          s(oldV.hoTen) != s(newV.hoTen) ||
          s(oldV.diDong) != s(newV.diDong) ||
          s(oldV.emailCongViec) != s(newV.emailCongViec) ||
          s(oldV.agreementUUId) != s(newV.agreementUUId) ||
          s(oldV.pin) != s(newV.pin) ||
          s(oldV.nguoiQuanLy) != s(newV.nguoiQuanLy) ||
          s(oldV.chucVuId ?? oldV.chucVu) != s(newV.chucVuId ?? newV.chucVu) ||
          oldDept != newDept ||
          b(oldV.laQuanLy) != b(newV.laQuanLy) ||
          b(oldV.active) != b(newV.active) ||
          b(oldV.kyNhay) != b(newV.kyNhay) ||
          b(oldV.kyThuong) != b(newV.kyThuong) ||
          b(oldV.kySo) != b(newV.kySo) ||
          b(oldV.savePin) != b(newV.savePin);
    }

    bool hasUploadChanged(NhanVien? oldV, NhanVien newV) {
      // Có chọn file mới (khác path cũ) => cần upload
      if (isNewNhaySelected || isNewThuongSelected) return true;

      final bool oldNhay = oldV?.kyNhay ?? false;
      final bool oldThuong = oldV?.kyThuong ?? false;
      final bool newNhay = newV.kyNhay ?? false;
      final bool newThuong = newV.kyThuong ?? false;

      final bool oldNhayEmpty = s(oldV?.chuKyNhay).isEmpty;
      final bool oldThuongEmpty = s(oldV?.chuKyThuong).isEmpty;

      // Bật mới kiểu ký và trước đó chưa có file => cần upload
      if (newNhay && !oldNhay && oldNhayEmpty) return true;
      if (newThuong && !oldThuong && oldThuongEmpty) return true;

      // Còn lại: không cần upload
      return false;
    }

    NhanVien buildStaff(NhanVien? existing) {
      if (existing != null) {
        return existing.copyWith(
          hoTen: nameController.text.trim(),
          diDong: telController.text.trim(),
          emailCongViec: emailController.text.trim(),
          isActive: isActive,
          chucVu: chucVuDTO?.id,
          chucVuId: chucVuDTO?.id,
          id: staffIdController.text.trim(),
          nguoiQuanLy: staffDTO?.id ?? '',
          agreementUUId: agreementUUIdController.text.trim(),
          pin: pinController.text.trim(),
          laQuanLy: laQuanLy,
          boPhan: phongBan?.id,
          phongBanId: phongBan?.id,
          ngayCapNhat: DateTime.now().toIso8601String(),
          nguoiCapNhat: userInfoDTO?.id ?? '',
          kyNhay: kyNhay,
          kyThuong: kyThuong,
          kySo: kySo,
          savePin: savePin,
        );
      }
      return NhanVien(
        id: staffIdController.text.trim(),
        hoTen: nameController.text.trim(),
        diDong: telController.text.trim(),
        emailCongViec: emailController.text.trim(),
        active: isActive,
        chucVu: chucVuDTO?.id,
        chucVuId: chucVuDTO?.id,
        nguoiQuanLy: staffDTO?.id ?? '',
        agreementUUId: agreementUUIdController.text.trim(),
        pin: pinController.text.trim(),
        laQuanLy: laQuanLy,
        boPhan: phongBan?.id,
        phongBanId: phongBan?.id,
        ngayTao: DateTime.now().toIso8601String(),
        nguoiTao: userInfoDTO?.id ?? '',
        kyNhay: kyNhay,
        kyThuong: kyThuong,
        kySo: kySo,
        savePin: savePin,
      );
    }

    Future<NhanVien?> uploadNhayIfNeeded(NhanVien staff) async {
      final bool shouldUpload =
          existingStaff == null ? kyNhay : (kyNhay && isNewNhaySelected);
      if (!shouldUpload) return staff;
      final Map<String, dynamic>? result = await uploadFileSignature(
        context,
        fileNameChuKyNhay ?? '',
        selectedFileChuKyNhay?.path ?? '',
        chuKyNhayData ?? Uint8List(0),
      );
      if (result == null) {
        if (!context.mounted) return null;
        AppUtility.showSnackBar(
          context,
          StaffConstants.errorUploadSignature,
          isError: true,
        );
        return null;
      }
      return staff.copyWith(chuKyNhay: result['fileName']);
    }

    Future<NhanVien?> uploadThuongIfNeeded(NhanVien staff) async {
      final bool shouldUpload =
          existingStaff == null ? kyThuong : (kyThuong && isNewThuongSelected);
      if (!shouldUpload) return staff;
      final Map<String, dynamic>? result = await uploadFileSignature(
        context,
        fileNameChuKyThuong ?? '',
        selectedFileChuKyThuong?.path ?? '',
        chuKyThuongData ?? Uint8List(0),
      );
      if (result == null) {
        if (!context.mounted) return null;
        AppUtility.showSnackBar(
          context,
          StaffConstants.errorUploadSignature,
          isError: true,
        );
        return null;
      }
      return staff.copyWith(chuKyThuong: result['fileName']);
    }

    NhanVien staff = buildStaff(existingStaff);

    if (existingStaff == null) {
      if (kySo && (staff.pin?.isEmpty ?? true)) {
        AppUtility.showSnackBar(
          context,
          StaffConstants.errorPinRequired,
          isError: true,
        );
      }

      NhanVien? candidate = staff;
      candidate = await uploadNhayIfNeeded(candidate);
      if (candidate == null) return false;
      candidate = await uploadThuongIfNeeded(candidate);
      if (candidate == null) return false;
      if (!context.mounted) return false;
      context.read<StaffBloc>().add(AddStaff(candidate));
      return true;
    } else {
      // Chỉ update khi có thay đổi dữ liệu hoặc có thay đổi liên quan đến upload chữ ký
      final bool uploadChanged = hasUploadChanged(existingStaff, staff);
      final bool changed =
          hasStaffChanged(existingStaff, staff) || uploadChanged;
      if (!changed) {
        return true; // Không có thay đổi, bỏ qua update
      }

      if (kySo && (staff.pin?.isEmpty ?? true)) {
        AppUtility.showSnackBar(
          context,
          StaffConstants.errorPinRequired,
          isError: true,
        );
      }

      NhanVien? candidate = staff;

      if (uploadChanged) {
        // Nếu bật ký nháy nhưng chưa có file cũ và cũng không chọn file mới -> báo lỗi
        if (kyNhay && (s(candidate.chuKyNhay).isEmpty) && !isNewNhaySelected) {
          AppUtility.showSnackBar(
            context,
            StaffConstants.errorSelectSignatureFile,
            isError: true,
          );
          return false;
        }
        // Nếu bật ký thường nhưng chưa có file cũ và cũng không chọn file mới -> báo lỗi
        if (kyThuong &&
            (s(candidate.chuKyThuong).isEmpty) &&
            !isNewThuongSelected) {
          AppUtility.showSnackBar(
            context,
            StaffConstants.errorSelectSignatureFile,
            isError: true,
          );
          return false;
        }

        candidate = await uploadNhayIfNeeded(candidate);
        if (candidate == null) return false;
        candidate = await uploadThuongIfNeeded(candidate);
        if (candidate == null) return false;
      }

      if (!context.mounted) return false;
      context.read<StaffBloc>().add(UpdateStaff(candidate));
      return true;
    }
  }
}
