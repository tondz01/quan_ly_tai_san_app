import 'package:quan_ly_tai_san_app/core/utils/utils.dart';

class ChiTietDieuDongTaiSan {
  String id;
  String idDieuDongTaiSan;
  String soQuyetDinh;
  String tenPhieu;
  String idTaiSan;
  String tenTaiSan;
  String donViTinh;
  int hienTrang;
  int soLuong;
  String ghiChu;
  String ngayTao;
  String ngayCapNhat;
  String nguoiTao;
  String nguoiCapNhat;
  bool isActive;

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
    String parseString(dynamic v) => v?.toString() ?? '';
    int parseInt(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v?.toString() ?? '0') ?? 0;
    }

    bool parseBool(dynamic v) {
      if (v is bool) return v;
      if (v is num) return v != 0;
      if (v is String) return v.toLowerCase() == 'true' || v == '1';
      return false;
    }

    return ChiTietDieuDongTaiSan(
      id: parseString(json['id']),
      idDieuDongTaiSan: parseString(json['idDieuDongTaiSan']),
      soQuyetDinh: parseString(json['soQuyetDinh']),
      tenPhieu: parseString(json['tenPhieu']),
      idTaiSan: parseString(json['idTaiSan']),
      tenTaiSan: parseString(json['tenTaiSan']),
      donViTinh: parseString(json['donViTinh']),
      hienTrang: parseInt(json['hienTrang']),
      soLuong: parseInt(json['soLuong']),
      ghiChu: parseString(json['ghiChu']),
      ngayTao: AppUtility.formatFromISOString(json['ngayTao']),
      ngayCapNhat: AppUtility.formatFromISOString(json['ngayCapNhat']),
      nguoiTao: parseString(json['nguoiTao']),
      nguoiCapNhat: parseString(json['nguoiCapNhat']),
      isActive: parseBool(json['isActive']),
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
      'ngayTao': AppUtility.formatFromISOString(ngayTao),
      'ngayCapNhat': AppUtility.formatFromISOString(ngayCapNhat),
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
      ngayTao: AppUtility.formatFromISOString(DateTime.now().toIso8601String()),
      ngayCapNhat: AppUtility.formatFromISOString(
        DateTime.now().toIso8601String(),
      ),
      nguoiTao: '',
      nguoiCapNhat: '',
      isActive: true,
    );
  }
  @override
  String toString() {
    return tenTaiSan;
  }
}
