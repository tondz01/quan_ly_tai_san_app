import 'package:equatable/equatable.dart';

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
  });

  factory NhanVien.fromJson(Map<String, dynamic> json) {
    return NhanVien(
      id: json['id'],
      hoTen: json['hoTen'],
      diDong: json['diDong'],
      emailCongViec: json['emailCongViec'],
      agreementUUId: json['agreementUUId'],
      pin: json['pin'],
      chuKyNhay: json['chuKyNhay'],
      chuKyThuong: json['chuKyThuong'],
      boPhan: json['boPhan'],
      chucVu: json['chucVu'],
      tenChucVu: json['tenChucVu'],
      chucVuId: json['chucVuId'],
      nguoiQuanLy: json['nguoiQuanLy'],
      quanLyId: json['quanLyId'],
      tenQuanLy: json['tenQuanLy'],
      phongBanId: json['phongBanId'],
      tenPhongBan: json['tenPhongBan'],
      laQuanLy: json['laQuanLy'],
      avatar: json['avatar'],
      idCongTy: json['idCongTy'],
      active: json['active'],
      kyNhay: json['kyNhay'],
      kyThuong: json['kyThuong'],
      kySo: json['kySo'],
      ngayTao: json['ngayTao'],
      ngayCapNhat: json['ngayCapNhat'],
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
      'idCongTy': "ct001",
      'diaChiLamViec': diaChiLamViec,
      'hinhThucLamViec': hinhThucLamViec,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'active': active,
      'phongBanId': phongBanId,
      'kyNhay': kyNhay,
      'kyThuong': kyThuong,
      'kySo': kySo,
      'ngayTao': ngayTao,
      'ngayCapNhat': ngayCapNhat,
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
      'id': _nullIfEmpty(id),
      'hoTen': _nullIfEmpty(hoTen),
      'diDong': _nullIfEmpty(diDong),
      'emailCongViec': _nullIfEmpty(emailCongViec),
      'kyNhay': kyNhay,
      'kyThuong': kyThuong,
      'kySo': kySo,
      'chuKyNhay': _nullIfEmpty(chuKyNhay),
      'chuKyThuong': _nullIfEmpty(chuKyThuong),
      'agreementUUId': _nullIfEmpty(agreementUUId),
      'pin': _nullIfEmpty(pin),
      'boPhan': _nullIfEmpty(boPhan),
      'chucVu': _nullIfEmpty(chucVu),
      'nguoiQuanLy': _nullIfEmpty(nguoiQuanLy),
      'laQuanLy': laQuanLy,
      'avatar': _nullIfEmpty(avatar),
      'idCongTy': _nullIfEmpty(idCongTy),
      'diaChiLamViec': _nullIfEmpty(diaChiLamViec),
      'hinhThucLamViec': _nullIfEmpty(hinhThucLamViec),
      'gioLamViec': _nullIfEmpty('PBTM'),
      'muiGio': _nullIfEmpty('true'),
      'nguoiTao': _nullIfEmpty(nguoiTao),
      'nguoiCapNhat': _nullIfEmpty(nguoiCapNhat),
      'ngayTao': _nullIfEmpty(ngayTao),
      'ngayCapNhat': _nullIfEmpty(ngayCapNhat),
      'active': active,
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
    ngayTao,
    ngayCapNhat,
  ];
}
