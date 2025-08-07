import 'dart:convert';

import 'package:quan_ly_tai_san_app/core/utils/utils.dart';

class AssetTransferDto {
  final String id;
  final String soQuyetDinh;
  final String tenPhieu;
  final String idDonViGiao;
  final String? tenDonViGiao;
  final String idDonViNhan;
  final String? tenDonViNhan;
  final String idDonViDeNghi;
  final String? tenDonViDeNghi;
  final String idPhongBanXemPhieu;
  final String? tenPhongBanXemPhieu;
  final String idNguoiDeNghi;
  final String? tenNguoiDeNghi;
  final String idTrinhDuyetCapPhong;
  final String? tenTrinhDuyetCapPhong;
  final String idTrinhDuyetGiamDoc;
  final String? tenTrinhDuyetGiamDoc;
  final String idNhanSuXemPhieu;
  final String? tenNhanSuXemPhieu;
  final bool nguoiLapPhieuKyNhay;
  final bool quanTrongCanXacNhan;
  final bool phoPhongXacNhan;
  final String tggnTuNgay;
  final String tggnDenNgay;
  final String diaDiemGiaoNhan;
  final String veViec;
  final String canCu;
  final String dieu1;
  final String dieu2;
  final String dieu3;
  final String noiNhan;
  final String themDongTrong;
  final int trangThai;
  final String idCongTy;
  final String ngayTao;
  final String ngayCapNhat;
  final String nguoiTao;
  final String nguoiCapNhat;
  final bool coHieuLuc;
  final int loai;
  final bool isActive;
  final String? trichYeu;
  final String? duongDanFile;
  final String? tenFile;
  final String? ngayKy;
  final bool active;

  AssetTransferDto({
    required this.id,
    required this.soQuyetDinh,
    required this.tenPhieu,
    required this.idDonViGiao,
    this.tenDonViGiao,
    required this.idDonViNhan,
    this.tenDonViNhan,
    required this.idDonViDeNghi,
    this.tenDonViDeNghi,
    required this.idPhongBanXemPhieu,
    this.tenPhongBanXemPhieu,
    required this.idNguoiDeNghi,
    this.tenNguoiDeNghi,
    required this.idTrinhDuyetCapPhong,
    this.tenTrinhDuyetCapPhong,
    required this.idTrinhDuyetGiamDoc,
    this.tenTrinhDuyetGiamDoc,
    required this.idNhanSuXemPhieu,
    this.tenNhanSuXemPhieu,
    required this.nguoiLapPhieuKyNhay,
    required this.quanTrongCanXacNhan,
    required this.phoPhongXacNhan,
    required this.tggnTuNgay,
    required this.tggnDenNgay,
    required this.diaDiemGiaoNhan,
    required this.veViec,
    required this.canCu,
    required this.dieu1,
    required this.dieu2,
    required this.dieu3,
    required this.noiNhan,
    required this.themDongTrong,
    required this.trangThai,
    required this.idCongTy,
    required this.ngayTao,
    required this.ngayCapNhat,
    required this.nguoiTao,
    required this.nguoiCapNhat,
    required this.coHieuLuc,
    required this.loai,
    required this.isActive,
    this.trichYeu,
    this.duongDanFile,
    this.tenFile,
    this.ngayKy,
    required this.active,
  });

  factory AssetTransferDto.fromJson(Map<String, dynamic> json) {
    return AssetTransferDto(
      id: json['id'],
      soQuyetDinh: json['soQuyetDinh'],
      tenPhieu: json['tenPhieu'],
      idDonViGiao: json['idDonViGiao'],
      tenDonViGiao: json['tenDonViGiao'],
      idDonViNhan: json['idDonViNhan'],
      tenDonViNhan: json['tenDonViNhan'],
      idDonViDeNghi: json['idDonViDeNghi'],
      tenDonViDeNghi: json['tenDonViDeNghi'],
      idPhongBanXemPhieu: json['idPhongBanXemPhieu'],
      tenPhongBanXemPhieu: json['tenPhongBanXemPhieu'],
      idNguoiDeNghi: json['idNguoiDeNghi'],
      tenNguoiDeNghi: json['tenNguoiDeNghi'],
      idTrinhDuyetCapPhong: json['idTrinhDuyetCapPhong'],
      tenTrinhDuyetCapPhong: json['tenTrinhDuyetCapPhong'],
      idTrinhDuyetGiamDoc: json['idTrinhDuyetGiamDoc'],
      tenTrinhDuyetGiamDoc: json['tenTrinhDuyetGiamDoc'],
      idNhanSuXemPhieu: json['idNhanSuXemPhieu'],
      tenNhanSuXemPhieu: json['tenNhanSuXemPhieu'],
      nguoiLapPhieuKyNhay: json['nguoiLapPhieuKyNhay'],
      quanTrongCanXacNhan: json['quanTrongCanXacNhan'],
      phoPhongXacNhan: json['phoPhongXacNhan'],
      tggnTuNgay: AppUtility.formatDateTimeVN(json['tggnTuNgay']),
      tggnDenNgay: AppUtility.formatDateTimeVN(json['tggnDenNgay']),
      diaDiemGiaoNhan: json['diaDiemGiaoNhan'],
      veViec: json['veViec'],
      canCu: json['canCu'],
      dieu1: json['dieu1'],
      dieu2: json['dieu2'],
      dieu3: json['dieu3'],
      noiNhan: json['noiNhan'],
      themDongTrong: json['themDongTrong'],
      trangThai: json['trangThai'],
      idCongTy: json['idCongTy'],
      ngayTao: AppUtility.formatDateTimeVN(json['ngayTao']),
      ngayCapNhat: AppUtility.formatDateTimeVN(json['ngayCapNhat']),
      nguoiTao: json['nguoiTao'],
      nguoiCapNhat: json['nguoiCapNhat'],
      coHieuLuc: json['coHieuLuc'],
      loai: json['loai'],
      isActive: json['isActive'],
      trichYeu: json['trichYeu'],
      duongDanFile: json['duongDanFile'],
      tenFile: json['tenFile'],
      ngayKy: json['ngayKy'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'soQuyetDinh': soQuyetDinh,
      'tenPhieu': tenPhieu,
      'idDonViGiao': idDonViGiao,
      'tenDonViGiao': tenDonViGiao,
      'idDonViNhan': idDonViNhan,
      'tenDonViNhan': tenDonViNhan,
      'idDonViDeNghi': idDonViDeNghi,
      'tenDonViDeNghi': tenDonViDeNghi,
      'idPhongBanXemPhieu': idPhongBanXemPhieu,
      'tenPhongBanXemPhieu': tenPhongBanXemPhieu,
      'idNguoiDeNghi': idNguoiDeNghi,
      'tenNguoiDeNghi': tenNguoiDeNghi,
      'idTrinhDuyetCapPhong': idTrinhDuyetCapPhong,
      'tenTrinhDuyetCapPhong': tenTrinhDuyetCapPhong,
      'idTrinhDuyetGiamDoc': idTrinhDuyetGiamDoc,
      'tenTrinhDuyetGiamDoc': tenTrinhDuyetGiamDoc,
      'idNhanSuXemPhieu': idNhanSuXemPhieu,
      'tenNhanSuXemPhieu': tenNhanSuXemPhieu,
      'nguoiLapPhieuKyNhay': nguoiLapPhieuKyNhay,
      'quanTrongCanXacNhan': quanTrongCanXacNhan,
      'phoPhongXacNhan': phoPhongXacNhan,
      'tggnTuNgay': tggnTuNgay,
      'tggnDenNgay': tggnDenNgay,
      'diaDiemGiaoNhan': diaDiemGiaoNhan,
      'veViec': veViec,
      'canCu': canCu,
      'dieu1': dieu1,
      'dieu2': dieu2,
      'dieu3': dieu3,
      'noiNhan': noiNhan,
      'themDongTrong': themDongTrong,
      'trangThai': trangThai,
      'idCongTy': idCongTy,
      'ngayTao': ngayTao,
      'ngayCapNhat': ngayCapNhat,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'coHieuLuc': coHieuLuc,
      'loai': loai,
      'isActive': isActive,
      'trichYeu': trichYeu,
      'duongDanFile': duongDanFile,
      'tenFile': tenFile,
      'ngayKy': ngayKy,
      'active': active,
    };
  }

  static List<AssetTransferDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => AssetTransferDto.fromJson(json)).toList();
  }

  static String encode(List<AssetTransferDto> transfers) =>
      json.encode(transfers.map((transfer) => transfer.toJson()).toList());

  static List<AssetTransferDto> decode(String transfers) =>
      (json.decode(transfers) as List<dynamic>)
          .map<AssetTransferDto>((item) => AssetTransferDto.fromJson(item))
          .toList();
}