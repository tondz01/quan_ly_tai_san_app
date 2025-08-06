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
  final String? nguoiQuanLy;
  final bool? laQuanLy;
  final String? avatar;
  final String? idCongTy;
  final String? diaChiLamViec;
  final String? hinhThucLamViec;
  final String? gioLamViec;
  final String? muiGio;
  final String? nguoiTao;
  final String? nguoiCapNhat;
  final bool? isActive;
  final DateTime? ngayTao;
  final DateTime? ngayCapNhat;

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
    this.nguoiQuanLy,
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
  });

  factory NhanVien.fromJson(Map<String, dynamic> json) {
    return NhanVien(
      id: json['id'],
      hoTen: json['hoTen'],
      diDong: json['diDong'],
      emailCongViec: json['emailCongViec'],
      kieuKy: json['kieuKy'],
      agreementUUId: json['agreementUUId'],
      pin: json['pin'],
      chuKy: json['chuKy'],
      boPhan: json['boPhan'],
      chucVu: json['chucVu'],
      nguoiQuanLy: json['nguoiQuanLy'],
      laQuanLy: json['laQuanLy'],
      avatar: json['avatar'],
      idCongTy: json['idCongTy'],
      diaChiLamViec: json['diaChiLamViec'],
      hinhThucLamViec: json['hinhThucLamViec'],
      gioLamViec: json['gioLamViec'],
      muiGio: json['muiGio'],
      nguoiTao: json['nguoiTao'],
      nguoiCapNhat: json['nguoiCapNhat'],
      isActive: json['isActive'],
      ngayTao: json['ngayTao'] != null ? DateTime.tryParse(json['ngayTao']) : null,
      ngayCapNhat: json['ngayCapNhat'] != null ? DateTime.tryParse(json['ngayCapNhat']) : null,
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
      'idCongTy': idCongTy,
      'diaChiLamViec': diaChiLamViec,
      'hinhThucLamViec': hinhThucLamViec,
      'gioLamViec': gioLamViec,
      'muiGio': muiGio,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'isActive': isActive,
      'ngayTao': ngayTao?.toIso8601String(),
      'ngayCapNhat': ngayCapNhat?.toIso8601String(),
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
        laQuanLy,
        avatar,
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
      ];
}
