import 'dart:convert';

import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/capital_source_by_asset_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/child_assets_dto.dart';

class AssetManagementDto {
  // Helper chuyển null/empty string thành "null" để export
  dynamic _nullIfEmpty(dynamic value) {
    if (value == null) {
      return "";
    }
    if (value is String) {
      return value.trim().isEmpty ? "" : value;
    }
    return value;
  }

  /// Dữ liệu export cho tài sản
  Map<String, dynamic> toExportJson() {
    DateTime? ngayTao = DateTime.tryParse(this.ngayTao ?? '');
    DateTime? ngayCapNhat = DateTime.tryParse(this.ngayCapNhat ?? '');
    return {
      'Số thẻ tài sản': _nullIfEmpty(id),
      'Mã tài sản': _nullIfEmpty(soThe),
      'Tên tài sản': _nullIfEmpty(tenTaiSan),
      'Nguyên giá': nguyenGia ?? 0.0,
      'Giá trị khấu hao ban đầu': giaTriKhauHaoBanDau ?? 0.0,
      'Kỳ khấu hao ban đầu': kyKhauHaoBanDau ?? 0,
      'Giá trị thanh lý': giaTriThanhLy ?? 0.0,
      'Mã mô hình tài sản': _nullIfEmpty(idMoHinhTaiSan),
      'Mã nhóm tài sản': _nullIfEmpty(idNhomTaiSan),
      'Mã loại tài sản': _nullIfEmpty(idLoaiTaiSanCon),
      'Mã dự án': _nullIfEmpty(idDuAn),
      'Mã nguồn vốn': _nullIfEmpty(idNguonVon),
      'Tên nguồn kinh phí': _nullIfEmpty(tenNguonKinhPhi),
      'Phương pháp khấu hao': phuongPhapKhauHao ?? 0,
      'Số kỳ khấu hao': soKyKhauHao ?? 0,
      'TK tài sản': taiKhoanTaiSan ?? 0,
      'TK khấu hao': taiKhoanKhauHao ?? 0,
      'TK chi phí': taiKhoanChiPhi ?? 0,
      'Ngày vào sổ': AppUtility.formatDateString(ngayVaoSo),
      'Ngày sử dụng': AppUtility.formatDateString(ngaySuDung),
      'Ký hiệu': _nullIfEmpty(kyHieu),
      'Số ký hiệu': _nullIfEmpty(soKyHieu),
      'Công suất': _nullIfEmpty(congSuat),
      'Nước sản xuất': _nullIfEmpty(nuocSanXuat),
      'Năm sản xuất': namSanXuat ?? 0,
      'Lý do tăng': lyDoTang ?? 0,
      'Hiện trạng': hienTrang ?? 0,
      'Số lượng': soLuong ?? 0,
      'Đơn vị tính': _nullIfEmpty(donViTinh),
      'Ghi chú': _nullIfEmpty(ghiChu),
      'Mã đơn vị ban đầu': _nullIfEmpty(idDonViBanDau),
      'Mã đơn vị hiện thời': _nullIfEmpty(idDonViHienThoi),
      'Mô tả': _nullIfEmpty(moTa),
      // 'Mã công ty': _nullIfEmpty(idCongTy),
      'Ngày tạo': AppUtility.formatDateString(ngayTao),
      'Ngày cập nhật': AppUtility.formatDateString(ngayCapNhat),
      'Người tạo': _nullIfEmpty(nguoiTao),
      'Người cập nhật': _nullIfEmpty(nguoiCapNhat),
      // 'Hiển thị': isActive ?? false,
    };
  }

  String? id;
  String? soThe;
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
  bool? isTaiSanCon;
  String? idLoaiTaiSanCon;
  List<CapitalSourceByAssetDto>? nguonKinhPhiList;

  AssetManagementDto({
    this.id,
    this.soThe,
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
    this.isTaiSanCon,
    this.idLoaiTaiSanCon,
    this.nguonKinhPhiList,
  });

  factory AssetManagementDto.fromJson(Map<String, dynamic> json) {
    return AssetManagementDto(
      id: json['id'],
      soThe: json['soThe'],
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
      lyDoTang: json['lyDoTang'] == null
        ? null
        : (json['lyDoTang'] is int
            ? json['lyDoTang'] as int
            : int.tryParse(json['lyDoTang'].toString())),
      hienTrang: json['hienTrang'] == null
        ? null
        : (json['hienTrang'] is int
            ? json['hienTrang'] as int
            : int.tryParse(json['hienTrang'].toString())),
    soLuong: json['soLuong'] == null
        ? null
        : (json['soLuong'] is int
            ? json['soLuong'] as int
            : int.tryParse(json['soLuong'].toString())),
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
      childAssets:
          json['childAssets'] != null
              ? (json['childAssets'] as List<dynamic>)
                  .map<ChildAssetDto>(
                    (item) =>
                        ChildAssetDto.fromJson(item as Map<String, dynamic>),
                  )
                  .toList()
              : [],
      isTaiSanCon: json['isTaiSanCon'],
      idLoaiTaiSanCon: json['idLoaiTaiSanCon'],
      nguonKinhPhiList: json['nguonKinhPhiList'] != null
          ? (json['nguonKinhPhiList'] as List<dynamic>)
              .map<CapitalSourceByAssetDto>(
                (item) => CapitalSourceByAssetDto.fromJson(item as Map<String, dynamic>),
              )
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'soThe': soThe,
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
      'ngayVaoSo': AppUtility.formatDateString(ngayVaoSo),
      'ngaySuDung': AppUtility.formatDateString(ngaySuDung),
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
      'isTaiSanCon': isTaiSanCon,
      'idLoaiTaiSanCon': idLoaiTaiSanCon,
      'nguonKinhPhiList': nguonKinhPhiList?.map((item) => item.toJson()).toList(),
    };
  }

  // String _formatDateForServer(DateTime? dateTime) {
  //   if (dateTime == null) return '';
  //   return '${dateTime.year.toString().padLeft(4, '0')}-'
  //       '${dateTime.month.toString().padLeft(2, '0')}-'
  //       '${dateTime.day.toString().padLeft(2, '0')} '
  //       '${dateTime.hour.toString().padLeft(2, '0')}:'
  //       '${dateTime.minute.toString().padLeft(2, '0')}:'
  //       '${dateTime.second.toString().padLeft(2, '0')}';
  // }

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
      soThe: '',
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
      kyHieu: '',
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
      isTaiSanCon: false,
      idLoaiTaiSanCon: '',
      nguonKinhPhiList: [],
    );
  }

  @override
  String toString() {
    return tenTaiSan ?? '';
  }

  AssetManagementDto copyWith({
    String? id,
    String? soThe,
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
    bool? isTaiSanCon,
    String? idLoaiTaiSanCon,
    List<CapitalSourceByAssetDto>? nguonKinhPhiList,
  }) {
    return AssetManagementDto(
      id: id ?? this.id,
      soThe: soThe ?? this.soThe,
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
      isTaiSanCon: isTaiSanCon ?? this.isTaiSanCon,
      idLoaiTaiSanCon: idLoaiTaiSanCon ?? this.idLoaiTaiSanCon,
      nguonKinhPhiList: nguonKinhPhiList ?? this.nguonKinhPhiList,
    );
  }
}
