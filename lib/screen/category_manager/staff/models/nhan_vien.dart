import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/constants/staff_constants.dart';

class NhanVien extends Equatable {
  final String? id;
  final String? hoTen;
  final String? diDong;
  final String? emailCongViec;

  final String? agreementUUId;
  final String? pin;
  final String? chuKyNhay;
  final String? chuKyThuong;
  final String? boPhan;
  final String? chucVu;
  final String? tenChucVu;
  final String? chucVuId;
  final String? nguoiQuanLy;
  final String? quanLyId;
  final String? tenQuanLy;
  final bool? laQuanLy;
  final String? avatar;
  final String? idCongTy;
  final String? diaChiLamViec;
  final String? hinhThucLamViec;
  final String? gioLamViec;
  final String? muiGio;
  final String? nguoiTao;
  final String? nguoiCapNhat;
  final String? phongBanId;
  final String? tenPhongBan;
  final bool? active;
  final String? ngayTao;
  final String? ngayCapNhat;

  //kiểu ký
  final bool? kyNhay;
  final bool? kyThuong;
  final bool? kySo;

  final bool? savePin;

  const NhanVien({
    this.id,
    this.hoTen,
    this.diDong,
    this.emailCongViec,
    this.agreementUUId,
    this.pin,
    this.chuKyNhay,
    this.chuKyThuong,
    this.boPhan,
    this.chucVu,
    this.tenChucVu,
    this.chucVuId,
    this.nguoiQuanLy,
    this.quanLyId,
    this.tenQuanLy,
    this.laQuanLy,
    this.avatar,
    this.idCongTy,
    this.diaChiLamViec,
    this.hinhThucLamViec,
    this.gioLamViec,
    this.muiGio,
    this.nguoiTao,
    this.nguoiCapNhat,
    this.active,
    this.ngayTao,
    this.ngayCapNhat,
    this.phongBanId,
    this.tenPhongBan,
    this.kyNhay,
    this.kyThuong,
    this.kySo,
    this.savePin,
  });

  factory NhanVien.fromJson(Map<String, dynamic> json) {
    String? s(dynamic v) => v?.toString();
    bool? b(dynamic v) {
      if (v == null) return null;
      if (v is bool) return v;
      if (v is num) return v != 0;
      final str = v.toString().trim().toLowerCase();
      if (str.isEmpty) return null;
      return str == 'true' || str == '1' || str == 'yes' || str == 'y';
    }

    return NhanVien(
      id: s(json['id']),
      hoTen: s(json['hoTen']),
      diDong: s(json['diDong']),
      emailCongViec: s(json['emailCongViec']),
      agreementUUId: s(json['agreementUUId']),
      pin: s(json['pin']),
      chuKyNhay: s(json['chuKyNhay']),
      chuKyThuong: s(json['chuKyThuong']),
      boPhan: s(json['boPhan']),
      chucVu: s(json['chucVu']),
      tenChucVu: s(json['tenChucVu']),
      chucVuId: s(json['chucVuId']),
      nguoiQuanLy: s(json['nguoiQuanLy']),
      quanLyId: s(json['quanLyId']),
      tenQuanLy: s(json['tenQuanLy']),
      phongBanId: s(json['phongBanId']),
      tenPhongBan: s(json['tenPhongBan']),
      laQuanLy: b(json['laQuanLy']),
      avatar: s(json['avatar']),
      idCongTy: s(json['idCongTy']),
      active: b(json['active']),
      kyNhay: b(json['kyNhay']),
      kyThuong: b(json['kyThuong']),
      kySo: b(json['kySo']),
      ngayTao: s(json['ngayTao']),
      ngayCapNhat: s(json['ngayCapNhat']),
      savePin: b(json['savePin']),
    );
  }
  NhanVien copyWith({
    String? id,
    String? hoTen,
    String? diDong,
    String? emailCongViec,
    String? agreementUUId,
    String? pin,
    String? chuKyNhay,
    String? chuKyThuong,
    String? boPhan,
    String? chucVu,
    String? tenChucVu,
    String? chucVuId,
    String? nguoiQuanLy,
    String? quanLyId,
    String? tenQuanLy,
    bool? laQuanLy,
    String? avatar,
    String? idCongTy,
    String? diaChiLamViec,
    String? hinhThucLamViec,
    String? gioLamViec,
    String? muiGio,
    String? nguoiTao,
    String? nguoiCapNhat,
    bool? isActive,
    String? ngayTao,
    String? ngayCapNhat,
    String? phongBanId,
    String? tenPhongBan,
    bool? kyNhay,
    bool? kyThuong,
    bool? kySo,
    bool? savePin,
  }) {
    return NhanVien(
      id: id ?? this.id,
      hoTen: hoTen ?? this.hoTen,
      diDong: diDong ?? this.diDong,
      emailCongViec: emailCongViec ?? this.emailCongViec,
      agreementUUId: agreementUUId ?? this.agreementUUId,
      pin: pin ?? this.pin,
      chuKyNhay: chuKyNhay ?? this.chuKyNhay,
      chuKyThuong: chuKyThuong ?? this.chuKyThuong,
      boPhan: boPhan ?? this.boPhan,
      chucVu: chucVu ?? this.chucVu,
      tenChucVu: tenChucVu ?? this.tenChucVu,
      chucVuId: chucVuId ?? this.chucVuId,
      nguoiQuanLy: nguoiQuanLy ?? this.nguoiQuanLy,
      quanLyId: quanLyId ?? this.quanLyId,
      tenQuanLy: tenQuanLy ?? this.tenQuanLy,
      laQuanLy: laQuanLy ?? this.laQuanLy,
      avatar: avatar ?? this.avatar,
      idCongTy: idCongTy ?? this.idCongTy,
      diaChiLamViec: diaChiLamViec ?? this.diaChiLamViec,
      hinhThucLamViec: hinhThucLamViec ?? this.hinhThucLamViec,
      gioLamViec: gioLamViec ?? this.gioLamViec,
      muiGio: muiGio ?? this.muiGio,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
      active: isActive ?? this.active,
      phongBanId: phongBanId ?? this.phongBanId,
      tenPhongBan: tenPhongBan ?? this.tenPhongBan,
      kyNhay: kyNhay ?? this.kyNhay,
      kyThuong: kyThuong ?? this.kyThuong,
      kySo: kySo ?? this.kySo,
      ngayTao: ngayTao ?? this.ngayTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      savePin: savePin ?? this.savePin,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hoTen': hoTen,
      'diDong': diDong,
      'emailCongViec': emailCongViec,
      'agreementUUId': agreementUUId,
      'pin': pin,
      'chuKyNhay': chuKyNhay,
      'chuKyThuong': chuKyThuong,
      'boPhan': boPhan,
      'chucVu': chucVu,
      'nguoiQuanLy': nguoiQuanLy,
      'laQuanLy': laQuanLy,
      'avatar': avatar,
      'idCongTy': idCongTy ?? StaffConstants.defaultCompanyId,
      'diaChiLamViec': diaChiLamViec,
      'hinhThucLamViec': hinhThucLamViec,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'phongBanId': phongBanId,
      'kyNhay': kyNhay,
      'kyThuong': kyThuong,
      'kySo': kySo,
      'ngayTao': ngayTao,
      'ngayCapNhat': ngayCapNhat,
      'active': active,
      'savePin': savePin,
    };
  }

  // Trả về null nếu là chuỗi rỗng hoặc chỉ khoảng trắng; giữ nguyên nếu không phải String
  dynamic _nullIfEmpty(dynamic value) {
    if (value == null) {
      return "";
    }
    if (value is String) {
      return value.trim().isEmpty ? "" : value;
    }
    return value;
  }

  // Map dữ liệu để export: chuyển tất cả chuỗi rỗng "" => null
  Map<String, dynamic> toExportJson() {
    return {
      'Mã nhân viên': _nullIfEmpty(id),
      'Tên nhân viên': _nullIfEmpty(hoTen),
      'Số điện thoại': _nullIfEmpty(diDong),
      'Email': _nullIfEmpty(emailCongViec),
      'Agreement UUId': _nullIfEmpty(agreementUUId),
      'Mã Pin': _nullIfEmpty(pin),
      'Phòng ban (Mã phòng ban)': _nullIfEmpty(phongBanId),
      'Chức vụ (Mã chức vụ)': _nullIfEmpty(chucVuId),
      'Ngày tạo': _nullIfEmpty(ngayTao),
      'Ngày cập nhật': _nullIfEmpty(ngayCapNhat),
    };
  }

  @override
  List<Object?> get props => [
    id,
    hoTen,
    diDong,
    emailCongViec,
    agreementUUId,
    pin,
    chuKyNhay,
    chuKyThuong,
    boPhan,
    chucVu,
    nguoiQuanLy,
    quanLyId,
    tenQuanLy,
    laQuanLy,
    avatar,
    phongBanId,
    idCongTy,
    diaChiLamViec,
    hinhThucLamViec,
    gioLamViec,
    muiGio,
    nguoiTao,
    nguoiCapNhat,
    active,
    ngayTao,
    ngayCapNhat,
    kyNhay,
    kyThuong,
    kySo,
    savePin,
  ];
}
