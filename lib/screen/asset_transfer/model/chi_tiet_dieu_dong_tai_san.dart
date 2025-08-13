class ChiTietDieuDongTaiSan {
  final String id;
  final String idDieuDongTaiSan;
  final String soQuyetDinh;
  final String tenPhieu;
  final String idTaiSan;
  final String tenTaiSan;
  final String donViTinh;
  final int hienTrang;
  final int soLuong;
  final String ghiChu;
  final String ngayTao;
  final String ngayCapNhat;
  final String nguoiTao;
  final String nguoiCapNhat;
  final bool isActive;

  ChiTietDieuDongTaiSan({
    required this.id,
    required this.idDieuDongTaiSan,
    required this.soQuyetDinh,
    required this.tenPhieu,
    required this.idTaiSan,
    required this.tenTaiSan,
    required this.donViTinh,
    required this.hienTrang,
    required this.soLuong,
    required this.ghiChu,
    required this.ngayTao,
    required this.ngayCapNhat,
    required this.nguoiTao,
    required this.nguoiCapNhat,
    required this.isActive,
  });

  factory ChiTietDieuDongTaiSan.fromJson(Map<String, dynamic> json) {
    return ChiTietDieuDongTaiSan(
      id: json['id'] as String,
      idDieuDongTaiSan: json['idDieuDongTaiSan'] as String,
      soQuyetDinh: json['soQuyetDinh'] as String,
      tenPhieu: json['tenPhieu'] as String,
      idTaiSan: json['idTaiSan'] as String,
      tenTaiSan: json['tenTaiSan'] as String,
      donViTinh: json['donViTinh'] as String,
      hienTrang: int.parse(json['hienTrang']),
      soLuong: json['soLuong'] as int,
      ghiChu: json['ghiChu'] as String,
      ngayTao: json['ngayTao'] as String,
      ngayCapNhat: json['ngayCapNhat'] as String,
      nguoiTao: json['nguoiTao'] as String,
      nguoiCapNhat: json['nguoiCapNhat'] as String,
      isActive: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idDieuDongTaiSan': idDieuDongTaiSan,
      'soQuyetDinh': soQuyetDinh,
      'tenPhieu': tenPhieu,
      'idTaiSan': idTaiSan,
      'tenTaiSan': tenTaiSan,
      'donViTinh': donViTinh,
      'hienTrang': hienTrang,
      'soLuong': soLuong,
      'ghiChu': ghiChu,
      'ngayTao': ngayTao,
      'ngayCapNhat': ngayCapNhat,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'isActive': isActive,
    };
  }

  factory ChiTietDieuDongTaiSan.empty() {
    return ChiTietDieuDongTaiSan(
      id: '',
      idDieuDongTaiSan: '',
      soQuyetDinh: '',
      tenPhieu: '',
      idTaiSan: '',
      tenTaiSan: '',
      donViTinh: '',
      hienTrang: 0,
      soLuong: 0,
      ghiChu: '',
      ngayTao: DateTime.now().toIso8601String(),
      ngayCapNhat: DateTime.now().toIso8601String(),
      nguoiTao: '',
      nguoiCapNhat: '',
      isActive: true,
    );
  }
}
