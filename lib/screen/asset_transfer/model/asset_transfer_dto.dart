import 'dart:convert';

import 'package:quan_ly_tai_san_app/core/utils/utils.dart';

class AssetTransferDto {
  final String? id;
  final String? soQuyetDinh;
  final String? tenPhieu;
  final String? idDonViGiao;
  final String? tenDonViGiao;
  final String? idDonViNhan;
  final String? tenDonViNhan;
  final String? idDonViDeNghi;
  final String? tenDonViDeNghi;
  final String? idPhongBanXemPhieu;
  final String? tenPhongBanXemPhieu;
  final String? idNguoiDeNghi;
  final String? tenNguoiDeNghi;
  final String? idTrinhDuyetCapPhong;
  final String? tenTrinhDuyetCapPhong;
  final String? idTrinhDuyetGiamDoc;
  final String? tenTrinhDuyetGiamDoc;
  final String? idNhanSuXemPhieu;
  final String? tenNhanSuXemPhieu;
  final bool? nguoiLapPhieuKyNhay;
  final bool? quanTrongCanXacNhan;
  final bool? phoPhongXacNhan;
  final String? tggnTuNgay;
  final String? tggnDenNgay;
  final String? diaDiemGiaoNhan;
  final String? veViec;
  final String? canCu;
  final String? dieu1;
  final String? dieu2;
  final String? dieu3;
  final String? noiNhan;
  final String? themDongTrong;
  final int? trangThai;
  final String? idCongTy;
  final String? ngayTao;
  final String? ngayCapNhat;
  final String? nguoiTao;
  final String? nguoiCapNhat;
  final bool? coHieuLuc;
  final int? loai;
  final bool? isActive;
  final String? trichYeu;
  final String? duongDanFile;
  final String? tenFile;
  final String? ngayKy;
  final bool? active;

  AssetTransferDto({
    this.id,
    this.soQuyetDinh,
    this.tenPhieu,
    this.idDonViGiao,
    this.tenDonViGiao,
    this.idDonViNhan,
    this.tenDonViNhan,
    this.idDonViDeNghi,
    this.tenDonViDeNghi,
    this.idPhongBanXemPhieu,
    this.tenPhongBanXemPhieu,
    this.idNguoiDeNghi,
    this.tenNguoiDeNghi,
    this.idTrinhDuyetCapPhong,
    this.tenTrinhDuyetCapPhong,
    this.idTrinhDuyetGiamDoc,
    this.tenTrinhDuyetGiamDoc,
    this.idNhanSuXemPhieu,
    this.tenNhanSuXemPhieu,
    this.nguoiLapPhieuKyNhay,
    this.quanTrongCanXacNhan,
    this.phoPhongXacNhan,
    this.tggnTuNgay,
    this.tggnDenNgay,
    this.diaDiemGiaoNhan,
    this.veViec,
    this.canCu,
    this.dieu1,
    this.dieu2,
    this.dieu3,
    this.noiNhan,
    this.themDongTrong,
    this.trangThai,
    this.idCongTy,
    this.ngayTao,
    this.ngayCapNhat,
    this.nguoiTao,
    this.nguoiCapNhat,
    this.coHieuLuc,
    this.loai,
    this.isActive,
    this.trichYeu,
    this.duongDanFile,
    this.tenFile,
    this.ngayKy,
    this.active,
  });

  factory AssetTransferDto.fromJson(Map<String, dynamic> json) {
    String? fmt(dynamic v) {
      if (v is String && v.isNotEmpty) {
        return AppUtility.formatDateTimeVN(v);
      }
      return '';
    }

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
      tggnTuNgay: fmt(json['tggnTuNgay']),
      tggnDenNgay: fmt(json['tggnDenNgay']),
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
      ngayTao: fmt(json['ngayTao']),
      ngayCapNhat: fmt(json['ngayCapNhat']),
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
