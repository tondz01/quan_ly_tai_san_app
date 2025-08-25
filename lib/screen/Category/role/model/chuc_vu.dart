import 'package:equatable/equatable.dart';

class ChucVu extends Equatable {
  final String id;
  final String tenChucVu;
  final bool quanLyNhanVien;
  final bool quanLyPhongBan;
  final bool quanLyDuAn;
  final bool quanLyNguonVon;
  final bool quanLyMoHinhTaiSan;
  final bool quanLyNhomTaiSan;
  final bool quanLyTaiSan;
  final bool quanLyCCDCVatTu;
  final bool dieuDongTaiSan;
  final bool dieuDongCCDCVatTu;
  final bool banGiaoTaiSan;
  final bool banGiaoCCDCVatTu;
  final bool baoCao;
  final String idCongTy;
  final String ngayTao;
  final String ngayCapNhat;
  final String nguoiTao;
  final String nguoiCapNhat;

  const ChucVu({
    required this.id,
    required this.tenChucVu,
    required this.quanLyNhanVien,
    required this.quanLyPhongBan,
    required this.quanLyDuAn,
    required this.quanLyNguonVon,
    required this.quanLyMoHinhTaiSan,
    required this.quanLyNhomTaiSan,
    required this.quanLyTaiSan,
    required this.quanLyCCDCVatTu,
    required this.dieuDongTaiSan,
    required this.dieuDongCCDCVatTu,
    required this.banGiaoTaiSan,
    required this.banGiaoCCDCVatTu,
    required this.baoCao,
    required this.idCongTy,
    required this.ngayTao,
    required this.ngayCapNhat,
    required this.nguoiTao,
    required this.nguoiCapNhat,
  });

  /// Tạo object từ JSON
  factory ChucVu.fromJson(Map<String, dynamic> json) {
    return ChucVu(
      id: json['id']?.toString() ?? '',
      tenChucVu: json['tenChucVu']?.toString() ?? '',
      quanLyNhanVien: json['quanLyNhanVien'] ?? false,
      quanLyPhongBan: json['quanLyPhongBan'] ?? false,
      quanLyDuAn: json['quanLyDuAn'] ?? false,
      quanLyNguonVon: json['quanLyNguonVon'] ?? false,
      quanLyMoHinhTaiSan: json['quanLyMoHinhTaiSan'] ?? false,
      quanLyNhomTaiSan: json['quanLyNhomTaiSan'] ?? false,
      quanLyTaiSan: json['quanLyTaiSan'] ?? false,
      quanLyCCDCVatTu: json['quanLyCCDCVatTu'] ?? false,
      dieuDongTaiSan: json['dieuDongTaiSan'] ?? false,
      dieuDongCCDCVatTu: json['dieuDongCCDCVatTu'] ?? false,
      banGiaoTaiSan: json['banGiaoTaiSan'] ?? false,
      banGiaoCCDCVatTu: json['banGiaoCCDCVatTu'] ?? false,
      baoCao: json['baoCao'] ?? false,
      idCongTy: json['idCongTy']?.toString() ?? '',
      ngayTao: json['ngayTao']?.toString() ?? '',
      ngayCapNhat: json['ngayCapNhat']?.toString() ?? '',
      nguoiTao: json['nguoiTao']?.toString() ?? '',
      nguoiCapNhat: json['nguoiCapNhat']?.toString() ?? '',
    );
  }

  /// Chuyển object thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenChucVu': tenChucVu,
      'quanLyNhanVien': quanLyNhanVien,
      'quanLyPhongBan': quanLyPhongBan,
      'quanLyDuAn': quanLyDuAn,
      'quanLyNguonVon': quanLyNguonVon,
      'quanLyMoHinhTaiSan': quanLyMoHinhTaiSan,
      'quanLyNhomTaiSan': quanLyNhomTaiSan,
      'quanLyTaiSan': quanLyTaiSan,
      'quanLyCCDCVatTu': quanLyCCDCVatTu,
      'dieuDongTaiSan': dieuDongTaiSan,
      'dieuDongCCDCVatTu': dieuDongCCDCVatTu,
      'banGiaoTaiSan': banGiaoTaiSan,
      'banGiaoCCDCVatTu': banGiaoCCDCVatTu,
      'baoCao': baoCao,
      'idCongTy': idCongTy,
      'ngayTao': ngayTao,
      'ngayCapNhat': ngayCapNhat,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
    };
  }

  /// copyWith để dễ dàng cập nhật field
  ChucVu copyWith({
    String? id,
    String? tenChucVu,
    bool? quanLyNhanVien,
    bool? quanLyPhongBan,
    bool? quanLyDuAn,
    bool? quanLyNguonVon,
    bool? quanLyMoHinhTaiSan,
    bool? quanLyNhomTaiSan,
    bool? quanLyTaiSan,
    bool? quanLyCCDCVatTu,
    bool? dieuDongTaiSan,
    bool? dieuDongCCDCVatTu,
    bool? banGiaoTaiSan,
    bool? banGiaoCCDCVatTu,
    bool? baoCao,
    String? idCongTy,
    String? ngayTao,
    String? ngayCapNhat,
    String? nguoiTao,
    String? nguoiCapNhat,
  }) {
    return ChucVu(
      id: id ?? this.id,
      tenChucVu: tenChucVu ?? this.tenChucVu,
      quanLyNhanVien: quanLyNhanVien ?? this.quanLyNhanVien,
      quanLyPhongBan: quanLyPhongBan ?? this.quanLyPhongBan,
      quanLyDuAn: quanLyDuAn ?? this.quanLyDuAn,
      quanLyNguonVon: quanLyNguonVon ?? this.quanLyNguonVon,
      quanLyMoHinhTaiSan: quanLyMoHinhTaiSan ?? this.quanLyMoHinhTaiSan,
      quanLyNhomTaiSan: quanLyNhomTaiSan ?? this.quanLyNhomTaiSan,
      quanLyTaiSan: quanLyTaiSan ?? this.quanLyTaiSan,
      quanLyCCDCVatTu: quanLyCCDCVatTu ?? this.quanLyCCDCVatTu,
      dieuDongTaiSan: dieuDongTaiSan ?? this.dieuDongTaiSan,
      dieuDongCCDCVatTu: dieuDongCCDCVatTu ?? this.dieuDongCCDCVatTu,
      banGiaoTaiSan: banGiaoTaiSan ?? this.banGiaoTaiSan,
      banGiaoCCDCVatTu: banGiaoCCDCVatTu ?? this.banGiaoCCDCVatTu,
      baoCao: baoCao ?? this.baoCao,
      idCongTy: idCongTy ?? this.idCongTy,
      ngayTao: ngayTao ?? this.ngayTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
    );
  }

  @override
  List<Object?> get props => [
    id,
    tenChucVu,
    quanLyNhanVien,
    quanLyPhongBan,
    quanLyDuAn,
    quanLyNguonVon,
    quanLyMoHinhTaiSan,
    quanLyNhomTaiSan,
    quanLyTaiSan,
    quanLyCCDCVatTu,
    dieuDongTaiSan,
    dieuDongCCDCVatTu,
    banGiaoTaiSan,
    banGiaoCCDCVatTu,
    baoCao,
    idCongTy,
    ngayTao,
    ngayCapNhat,
    nguoiTao,
    nguoiCapNhat,
  ];
}
