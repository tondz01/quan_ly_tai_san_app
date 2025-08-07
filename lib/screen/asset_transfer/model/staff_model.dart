class StaffModel {
  final String id;
  final String hoTen;
  final String diDong;
  final String emailCongViec;
  final int kieuKy;
  final String agreementUUId;
  final String pin;
  final String chuKy;
  final String? phongBanId;
  final String? tenPhongBan;
  final String chucVuId;
  final String tenChucVu;
  final String? quanLyId;
  final String? tenQuanLy;
  final bool laQuanLy;
  final String avatar;
  final String idCongTy;
  final String diaChiLamViec;
  final String hinhThucLamViec;
  final String gioLamViec;
  final String muiGio;
  final DateTime ngayTao;
  final DateTime ngayCapNhat;
  final String nguoiTao;
  final String nguoiCapNhat;
  final bool isActive;

  StaffModel({
    required this.id,
    required this.hoTen,
    required this.diDong,
    required this.emailCongViec,
    required this.kieuKy,
    required this.agreementUUId,
    required this.pin,
    required this.chuKy,
    this.phongBanId,
    this.tenPhongBan,
    required this.chucVuId,
    required this.tenChucVu,
    this.quanLyId,
    this.tenQuanLy,
    required this.laQuanLy,
    required this.avatar,
    required this.idCongTy,
    required this.diaChiLamViec,
    required this.hinhThucLamViec,
    required this.gioLamViec,
    required this.muiGio,
    required this.ngayTao,
    required this.ngayCapNhat,
    required this.nguoiTao,
    required this.nguoiCapNhat,
    required this.isActive,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['id'],
      hoTen: json['hoTen'],
      diDong: json['diDong'],
      emailCongViec: json['emailCongViec'],
      kieuKy: json['kieuKy'],
      agreementUUId: json['agreementUUId'],
      pin: json['pin'],
      chuKy: json['chuKy'],
      phongBanId: json['phongBanId'],
      tenPhongBan: json['tenPhongBan'],
      chucVuId: json['chucVuId'],
      tenChucVu: json['tenChucVu'],
      quanLyId: json['quanLyId'],
      tenQuanLy: json['tenQuanLy'],
      laQuanLy: json['laQuanLy'],
      avatar: json['avatar'],
      idCongTy: json['idCongTy'],
      diaChiLamViec: json['diaChiLamViec'],
      hinhThucLamViec: json['hinhThucLamViec'],
      gioLamViec: json['gioLamViec'],
      muiGio: json['muiGio'],
      ngayTao: DateTime.parse(json['ngayTao']),
      ngayCapNhat: DateTime.parse(json['ngayCapNhat']),
      nguoiTao: json['nguoiTao'],
      nguoiCapNhat: json['nguoiCapNhat'],
      isActive: json['isActive'],
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
      'phongBanId': phongBanId,
      'tenPhongBan': tenPhongBan,
      'chucVuId': chucVuId,
      'tenChucVu': tenChucVu,
      'quanLyId': quanLyId,
      'tenQuanLy': tenQuanLy,
      'laQuanLy': laQuanLy,
      'avatar': avatar,
      'idCongTy': idCongTy,
      'diaChiLamViec': diaChiLamViec,
      'hinhThucLamViec': hinhThucLamViec,
      'gioLamViec': gioLamViec,
      'muiGio': muiGio,
      'ngayTao': ngayTao.toIso8601String(),
      'ngayCapNhat': ngayCapNhat.toIso8601String(),
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'isActive': isActive,
    };
  }
}