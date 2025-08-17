import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class NhanVien extends Equatable {
  final String? id;
  final String? hoTen;
  final String? diDong;
  final String? emailCongViec;

  final int? kieuKy;
  final String? agreementUUId;
  final String? pin;
  final String? chuKy;
  final String? boPhan;
  final String? chucVu;
  final String? tenChucVu;
  final String? chucVuId;
  final String? nguoiQuanLy;
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
  final bool? isActive;
  final DateTime? ngayTao;
  final DateTime? ngayCapNhat;
  final Uint8List? chuKyData;

  //kiểu ký
  final bool? kyNhay;
  final bool? kyThuong;
  final bool? kySo;

  const NhanVien({
    this.id,
    this.hoTen,
    this.diDong,
    this.emailCongViec,
    this.kieuKy,
    this.agreementUUId,
    this.pin,
    this.chuKy,
    this.boPhan,
    this.chucVu,
    this.tenChucVu,
    this.chucVuId,
    this.nguoiQuanLy,
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
    this.isActive,
    this.ngayTao,
    this.ngayCapNhat,
    this.phongBanId,
    this.tenPhongBan,
    this.chuKyData,
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
      kieuKy: int.parse(json['kieuKy']?.toString() ?? '0'),
      agreementUUId: json['agreementUUId'],
      pin: json['pin'],
      chuKy: json['chuKy'],
      boPhan: json['boPhan'],
      chucVu: json['chucVu'],
      tenChucVu: json['tenChucVu'],
      chucVuId: json['chucVuId'],
      nguoiQuanLy: json['nguoiQuanLy'],
      tenQuanLy: json['tenQuanLy'],
      phongBanId: json['phongBanId'],
      tenPhongBan: json['tenPhongBan'],
      laQuanLy: json['laQuanLy'],
      avatar: json['avatar'],
      idCongTy: json['idCongTy'],
      isActive: json['isActive'],
      kyNhay: json['kyNhay'],
      kyThuong: json['kyThuong'],
      kySo: json['kySo'],
    );
  }
  NhanVien copyWith({
    String? id,
    String? hoTen,
    String? diDong,
    String? emailCongViec,
    int? kieuKy,
    String? agreementUUId,
    String? pin,
    String? chuKy,
    String? boPhan,
    String? chucVu,
    String? tenChucVu,
    String? chucVuId,
    String? nguoiQuanLy,
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
    Uint8List? chuKyData,
    bool? kyNhay,
    bool? kyThuong,
    bool? kySo,
  }) {
    return NhanVien(
      id: id ?? this.id,
      hoTen: hoTen ?? this.hoTen,
      diDong: diDong ?? this.diDong,
      emailCongViec: emailCongViec ?? this.emailCongViec,
      kieuKy: kieuKy ?? this.kieuKy,
      agreementUUId: agreementUUId ?? this.agreementUUId,
      pin: pin ?? this.pin,
      chuKy: chuKy ?? this.chuKy,
      boPhan: boPhan ?? this.boPhan,
      chucVu: chucVu ?? this.chucVu,
      tenChucVu: tenChucVu ?? this.tenChucVu,
      chucVuId: chucVuId ?? this.chucVuId,
      nguoiQuanLy: nguoiQuanLy ?? this.nguoiQuanLy,
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
      isActive: isActive ?? this.isActive,
      phongBanId: phongBanId ?? this.phongBanId,
      tenPhongBan: tenPhongBan ?? this.tenPhongBan,
      chuKyData: chuKyData ?? this.chuKyData,
      kyNhay: kyNhay ?? this.kyNhay,
      kyThuong: kyThuong ?? this.kyThuong,
      kySo: kySo ?? this.kySo,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hoTen': hoTen,
      'diDong': diDong,
      'emailCongViec': emailCongViec,
      'kieuKy': kieuKy,
      'agreementUUId': agreementUUId,
      'pin': pin,
      'chuKy': chuKy,
      'boPhan': boPhan,
      'chucVu': chucVu,
      'nguoiQuanLy': nguoiQuanLy,
      'laQuanLy': laQuanLy,
      'avatar': avatar,
      'idCongTy': "ct001",
      'diaChiLamViec': diaChiLamViec,
      'hinhThucLamViec': hinhThucLamViec,
      'nguoiTao': nguoiTao,
      'isActive': isActive,
      'phongBanId': phongBanId,
      'kyNhay': kyNhay,
      'kyThuong': kyThuong,
      'kySo': kySo,
    };
  }

  @override
  List<Object?> get props => [
        id,
        hoTen,
        diDong,
        emailCongViec,
        kieuKy,
        agreementUUId,
        pin,
        chuKy,
        boPhan,
        chucVu,
        nguoiQuanLy,
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
        isActive,
        ngayTao,
        ngayCapNhat,
        kyNhay,
        kyThuong,
        kySo,
      ];
}
