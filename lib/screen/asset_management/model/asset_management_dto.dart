import 'dart:convert';

class AssetManagementDto {
  final String? id;
  final String? tenTaiSan;
  final double? nguyenGia;
  final double? giaTriKhauHaoBanDau;
  final int? kyKhauHaoBanDau;
  final double? giaTriThanhLy;
  final String? idMoHinhTaiSan;
  final String? tenMoHinh;
  final String? idNhomTaiSan;
  final String? tenNhom;
  final String? idDuAn;
  final String? tenDuAn;
  final String? idNguonVon;
  final String? tenNguonKinhPhi;
  final String? phuongPhapKhauHao;
  final int? soKyKhauHao;
  final int? taiKhoanTaiSan;
  final int? taiKhoanKhauHao;
  final int? taiKhoanChiPhi;
  final DateTime? ngayVaoSo;
  final DateTime? ngaySuDung;
  final String? kyHieu;
  final String? soKyHieu;
  final String? congSuat;
  final String? nuocSanXuat;
  final int? namSanXuat;
  final int? lyDoTang;
  final int? hienTrang;
  final int? soLuong;
  final String? donViTinh;
  final String? ghiChu;
  final String? idDonViBanDau;
  final String? idDonViHienThoi;
  final String? moTa;
  final String? idCongTy;
  final DateTime? ngayTao;
  final DateTime? ngayCapNhat;
  final String? nguoiTao;
  final String? nguoiCapNhat;
  final bool? isActive;

  AssetManagementDto({
    this.id,
    this.tenTaiSan,
    this.nguyenGia,
    this.giaTriKhauHaoBanDau,
    this.kyKhauHaoBanDau,
    this.giaTriThanhLy,
    this.idMoHinhTaiSan,
    this.tenMoHinh,
    this.idNhomTaiSan,
    this.tenNhom,
    this.idDuAn,
    this.tenDuAn,
    this.idNguonVon,
    this.tenNguonKinhPhi,
    this.phuongPhapKhauHao,
    this.soKyKhauHao,
    this.taiKhoanTaiSan,
    this.taiKhoanKhauHao,
    this.taiKhoanChiPhi,
    this.ngayVaoSo,
    this.ngaySuDung,
    this.kyHieu,
    this.soKyHieu,
    this.congSuat,
    this.nuocSanXuat,
    this.namSanXuat,
    this.lyDoTang,
    this.hienTrang,
    this.soLuong,
    this.donViTinh,
    this.ghiChu,
    this.idDonViBanDau,
    this.idDonViHienThoi,
    this.moTa,
    this.idCongTy,
    this.ngayTao,
    this.ngayCapNhat,
    this.nguoiTao,
    this.nguoiCapNhat,
    this.isActive,
  });

  factory AssetManagementDto.fromJson(Map<String, dynamic> json) {
    return AssetManagementDto(
      id: json['id'],
      tenTaiSan: json['tenTaiSan'],
      nguyenGia: json['nguyenGia']?.toDouble(),
      giaTriKhauHaoBanDau: json['giaTriKhauHaoBanDau']?.toDouble(),
      kyKhauHaoBanDau: json['kyKhauHaoBanDau'],
      giaTriThanhLy: json['giaTriThanhLy']?.toDouble(),
      idMoHinhTaiSan: json['idMoHinhTaiSan'],
      tenMoHinh: json['tenMoHinh'],
      idNhomTaiSan: json['idNhomTaiSan'],
      tenNhom: json['tenNhom'],
      idDuAn: json['idDuAn'],
      tenDuAn: json['tenDuAn'],
      idNguonVon: json['idNguonVon'],
      tenNguonKinhPhi: json['tenNguonKinhPhi'],
      phuongPhapKhauHao: json['phuongPhapKhauHao'],
      soKyKhauHao: json['soKyKhauHao'],
      taiKhoanTaiSan: json['taiKhoanTaiSan'],
      taiKhoanKhauHao: json['taiKhoanKhauHao'],
      taiKhoanChiPhi: json['taiKhoanChiPhi'],
      ngayVaoSo: json['ngayVaoSo'] != null
          ? DateTime.tryParse(json['ngayVaoSo'])
          : null,
      ngaySuDung: json['ngaySuDung'] != null
          ? DateTime.tryParse(json['ngaySuDung'])
          : null,
      kyHieu: json['kyHieu'],
      soKyHieu: json['soKyHieu'],
      congSuat: json['congSuat'],
      nuocSanXuat: json['nuocSanXuat'],
      namSanXuat: json['namSanXuat'],
      lyDoTang: json['lyDoTang'],
      hienTrang: json['hienTrang'],
      soLuong: json['soLuong'],
      donViTinh: json['donViTinh'],
      ghiChu: json['ghiChu'],
      idDonViBanDau: json['idDonViBanDau'],
      idDonViHienThoi: json['idDonViHienThoi'],
      moTa: json['moTa'],
      idCongTy: json['idCongTy'],
      ngayTao: json['ngayTao'] != null
          ? DateTime.tryParse(json['ngayTao'])
          : null,
      ngayCapNhat: json['ngayCapNhat'] != null
          ? DateTime.tryParse(json['ngayCapNhat'])
          : null,
      nguoiTao: json['nguoiTao'],
      nguoiCapNhat: json['nguoiCapNhat'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenTaiSan': tenTaiSan,
      'nguyenGia': nguyenGia,
      'giaTriKhauHaoBanDau': giaTriKhauHaoBanDau,
      'kyKhauHaoBanDau': kyKhauHaoBanDau,
      'giaTriThanhLy': giaTriThanhLy,
      'idMoHinhTaiSan': idMoHinhTaiSan,
      'tenMoHinh': tenMoHinh,
      'idNhomTaiSan': idNhomTaiSan,
      'tenNhom': tenNhom,
      'idDuAn': idDuAn,
      'tenDuAn': tenDuAn,
      'idNguonVon': idNguonVon,
      'tenNguonKinhPhi': tenNguonKinhPhi,
      'phuongPhapKhauHao': phuongPhapKhauHao,
      'soKyKhauHao': soKyKhauHao,
      'taiKhoanTaiSan': taiKhoanTaiSan,
      'taiKhoanKhauHao': taiKhoanKhauHao,
      'taiKhoanChiPhi': taiKhoanChiPhi,
      'ngayVaoSo': ngayVaoSo?.toIso8601String(),
      'ngaySuDung': ngaySuDung?.toIso8601String(),
      'kyHieu': kyHieu,
      'soKyHieu': soKyHieu,
      'congSuat': congSuat,
      'nuocSanXuat': nuocSanXuat,
      'namSanXuat': namSanXuat,
      'lyDoTang': lyDoTang,
      'hienTrang': hienTrang,
      'soLuong': soLuong,
      'donViTinh': donViTinh,
      'ghiChu': ghiChu,
      'idDonViBanDau': idDonViBanDau,
      'idDonViHienThoi': idDonViHienThoi,
      'moTa': moTa,
      'idCongTy': idCongTy,
      'ngayTao': ngayTao?.toIso8601String(),
      'ngayCapNhat': ngayCapNhat?.toIso8601String(),
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'isActive': isActive,
    };
  }

  static List<AssetManagementDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => AssetManagementDto.fromJson(json)).toList();
  }

  static String encode(List<AssetManagementDto> assets) =>
      json.encode(assets.map((asset) => asset.toJson()).toList());

  static List<AssetManagementDto> decode(String assets) =>
      (json.decode(assets) as List<dynamic>)
          .map<AssetManagementDto>((item) => AssetManagementDto.fromJson(item))
          .toList();
}