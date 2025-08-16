import 'dart:convert';

import 'package:quan_ly_tai_san_app/screen/asset_management/model/child_assets_dto.dart';

class AssetManagementDto {
  String? id;
  String? tenTaiSan;
  double? nguyenGia;
  double? giaTriKhauHaoBanDau;
  int? kyKhauHaoBanDau;
  double? giaTriThanhLy;
  String? idMoHinhTaiSan;
  String? tenMoHinh;
  String? idNhomTaiSan;
  String? tenNhom;
  String? idDuAn;
  String? tenDuAn;
  String? idNguonVon;
  String? tenNguonKinhPhi;
  int? phuongPhapKhauHao;
  int? soKyKhauHao;
  int? taiKhoanTaiSan;
  int? taiKhoanKhauHao;
  int? taiKhoanChiPhi;
  DateTime? ngayVaoSo;
  DateTime? ngaySuDung;
  String? kyHieu;
  String? soKyHieu;
  String? congSuat;
  String? nuocSanXuat;
  int? namSanXuat;
  int? lyDoTang;
  int? hienTrang;
  int? soLuong;
  String? donViTinh;
  String? ghiChu;
  String? idDonViBanDau;
  String? idDonViHienThoi;
  String? moTa;
  String? idCongTy;
  String? ngayTao;
  String? ngayCapNhat;
  String? nguoiTao;
  String? nguoiCapNhat;
  bool? isActive;
  List<ChildAssetDto>? childAssets;

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
    this.childAssets,
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
      ngayVaoSo:
          json['ngayVaoSo'] != null
              ? DateTime.tryParse(json['ngayVaoSo'])
              : null,
      ngaySuDung:
          json['ngaySuDung'] != null
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
      ngayTao: json['ngayTao'],
      ngayCapNhat: json['ngayCapNhat'],
      nguoiTao: json['nguoiTao'],
      nguoiCapNhat: json['nguoiCapNhat'],
      isActive: json['isActive'],
      childAssets: json['childAssets'] != null 
          ? (json['childAssets'] as List<dynamic>)
              .map<ChildAssetDto>((item) => ChildAssetDto.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
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
      'ngayTao': ngayTao,
      'ngayCapNhat': ngayCapNhat,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'isActive': isActive,
      'childAssets': childAssets?.map((asset) => asset.toJson()).toList(),
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

  factory AssetManagementDto.empty() {
    return AssetManagementDto(
      id: '',
      tenTaiSan: '',
      nguyenGia: null,
      giaTriKhauHaoBanDau: null,
      kyKhauHaoBanDau: null,
      giaTriThanhLy: null,
      idMoHinhTaiSan: '',
      tenMoHinh: '',
      idNhomTaiSan: '',
      tenNhom: '',
      idDuAn: '',
      tenDuAn: '',
      idNguonVon: '',
      tenNguonKinhPhi: '',
      phuongPhapKhauHao: null,
      soKyKhauHao: null,
      taiKhoanTaiSan: null,
      taiKhoanKhauHao: null,
      taiKhoanChiPhi: null,
      ngayVaoSo: DateTime.now(),
      ngaySuDung: DateTime.now(),
      kyHieu : '',
      soKyHieu: '',
      congSuat: '',
      nuocSanXuat: '',
      namSanXuat: null,
      lyDoTang: null,
      hienTrang: -1,
      soLuong: null,
      donViTinh: '',
      ghiChu: '',
      idDonViBanDau: '',
      idDonViHienThoi: '',
      moTa: '',
      idCongTy: '',
      ngayTao: DateTime.now().toIso8601String(),
      ngayCapNhat: DateTime.now().toIso8601String(),
      nguoiTao: '',
      nguoiCapNhat: '',
      isActive: true,
      childAssets: [],
    );
  }
  
  @override
  String toString() {
    return tenTaiSan ?? '';
  }
  
  AssetManagementDto copyWith({
    String? id,
    String? tenTaiSan,
    double? nguyenGia,
    double? giaTriKhauHaoBanDau,
    int? kyKhauHaoBanDau,
    double? giaTriThanhLy,
    String? idMoHinhTaiSan,
    String? tenMoHinh,
    String? idNhomTaiSan,
    String? tenNhom,
    String? idDuAn,
    String? tenDuAn,
    String? idNguonVon,
    String? tenNguonKinhPhi,
    int? phuongPhapKhauHao,
    int? soKyKhauHao,
    int? taiKhoanTaiSan,
    int? taiKhoanKhauHao,
    int? taiKhoanChiPhi,
    DateTime? ngayVaoSo,
    DateTime? ngaySuDung,
    String? kyHieu,
    String? soKyHieu,
    String? congSuat,
    String? nuocSanXuat,
    int? namSanXuat,
    int? lyDoTang,
    int? hienTrang,
    int? soLuong,
    String? donViTinh,
    String? ghiChu,
    String? idDonViBanDau,
    String? idDonViHienThoi,
    String? moTa,
    String? idCongTy,
    String? ngayTao,
    String? ngayCapNhat,
    String? nguoiTao,
    String? nguoiCapNhat,
    bool? isActive,
    List<ChildAssetDto>? childAssets,
  }) {
    return AssetManagementDto(
      id: id ?? this.id,
      tenTaiSan: tenTaiSan ?? this.tenTaiSan,
      nguyenGia: nguyenGia ?? this.nguyenGia,
      giaTriKhauHaoBanDau: giaTriKhauHaoBanDau ?? this.giaTriKhauHaoBanDau,
      kyKhauHaoBanDau: kyKhauHaoBanDau ?? this.kyKhauHaoBanDau,
      giaTriThanhLy: giaTriThanhLy ?? this.giaTriThanhLy,
      idMoHinhTaiSan: idMoHinhTaiSan ?? this.idMoHinhTaiSan,
      tenMoHinh: tenMoHinh ?? this.tenMoHinh,
      idNhomTaiSan: idNhomTaiSan ?? this.idNhomTaiSan,
      tenNhom: tenNhom ?? this.tenNhom,
      idDuAn: idDuAn ?? this.idDuAn,
      tenDuAn: tenDuAn ?? this.tenDuAn,
      idNguonVon: idNguonVon ?? this.idNguonVon,
      tenNguonKinhPhi: tenNguonKinhPhi ?? this.tenNguonKinhPhi,
      phuongPhapKhauHao: phuongPhapKhauHao ?? this.phuongPhapKhauHao,
      soKyKhauHao: soKyKhauHao ?? this.soKyKhauHao,
      taiKhoanTaiSan: taiKhoanTaiSan ?? this.taiKhoanTaiSan,
      taiKhoanKhauHao: taiKhoanKhauHao ?? this.taiKhoanKhauHao,
      taiKhoanChiPhi: taiKhoanChiPhi ?? this.taiKhoanChiPhi,
      ngayVaoSo: ngayVaoSo ?? this.ngayVaoSo,
      ngaySuDung: ngaySuDung ?? this.ngaySuDung,
      kyHieu: kyHieu ?? this.kyHieu,
      soKyHieu: soKyHieu ?? this.soKyHieu,
      congSuat: congSuat ?? this.congSuat,
      nuocSanXuat: nuocSanXuat ?? this.nuocSanXuat,
      namSanXuat: namSanXuat ?? this.namSanXuat,
      lyDoTang: lyDoTang ?? this.lyDoTang,
      hienTrang: hienTrang ?? this.hienTrang,
      soLuong: soLuong ?? this.soLuong,
      donViTinh: donViTinh ?? this.donViTinh,
      ghiChu: ghiChu ?? this.ghiChu,
      idDonViBanDau: idDonViBanDau ?? this.idDonViBanDau,
      idDonViHienThoi: idDonViHienThoi ?? this.idDonViHienThoi,
      moTa: moTa ?? this.moTa,
      idCongTy: idCongTy ?? this.idCongTy,
      ngayTao: ngayTao ?? this.ngayTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
      isActive: isActive ?? this.isActive,
      childAssets: childAssets ?? this.childAssets,
    );
  }
}
