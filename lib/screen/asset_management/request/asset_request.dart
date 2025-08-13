class AssetRequest {
  final String id;
  final String idLoaiTaiSan;
  final String tenTaiSan;
  final double nguyenGia;
  final double giaTriKhauHaoBanDau;
  final int kyKhauHaoBanDau;
  final double giaTriThanhLy;
  final String idMoHinhTaiSan;
  final int phuongPhapKhauHao;
  final int soKyKhauHao;
  final int taiKhoanTaiSan;
  final int taiKhoanKhauHao;
  final int taiKhoanChiPhi;
  final String idNhomTaiSan;
  final String ngayVaoSo;
  final String ngaySuDung;
  final String idDuDan;
  final String idNguonVon;
  final String kyHieu;
  final String soKyHieu;
  final String congSuat;
  final String nuocSanXuat;
  final int namSanXuat;
  final int lyDoTang;
  final int hienTrang;
  final int soLuong;
  final String donViTinh;
  final String ghiChu;
  final String idDonViBanDau;
  final String idDonViHienThoi;
  final String moTa;
  final String idCongTy;
  final String ngayTao;
  final String ngayCapNhat;
  final String nguoiTao;
  final String nguoiCapNhat;
  final bool active;

  AssetRequest({
    required this.id,
    required this.idLoaiTaiSan,
    required this.tenTaiSan,
    required this.nguyenGia,
    required this.giaTriKhauHaoBanDau,
    required this.kyKhauHaoBanDau,
    required this.giaTriThanhLy,
    required this.idMoHinhTaiSan,
    required this.phuongPhapKhauHao,
    required this.soKyKhauHao,
    required this.taiKhoanTaiSan,
    required this.taiKhoanKhauHao,
    required this.taiKhoanChiPhi,
    required this.idNhomTaiSan,
    required this.ngayVaoSo,
    required this.ngaySuDung,
    required this.idDuDan,
    required this.idNguonVon,
    required this.kyHieu,
    required this.soKyHieu,
    required this.congSuat,
    required this.nuocSanXuat,
    required this.namSanXuat,
    required this.lyDoTang,
    required this.hienTrang,
    required this.soLuong,
    required this.donViTinh,
    required this.ghiChu,
    required this.idDonViBanDau,
    required this.idDonViHienThoi,
    required this.moTa,
    required this.idCongTy,
    required this.ngayTao,
    required this.ngayCapNhat,
    required this.nguoiTao,
    required this.nguoiCapNhat,
    required this.active,
  });

  factory AssetRequest.fromJson(Map<String, dynamic> json) {
    return AssetRequest(
      id: json['id'] ?? '',
      idLoaiTaiSan: json['idLoaiTaiSan'] ?? '',
      tenTaiSan: json['tenTaiSan'] ?? '',
      nguyenGia: (json['nguyenGia'] ?? 0.0).toDouble(),
      giaTriKhauHaoBanDau: (json['giaTriKhauHaoBanDau'] ?? 0.0).toDouble(),
      kyKhauHaoBanDau: json['kyKhauHaoBanDau'] ?? 0,
      giaTriThanhLy: (json['giaTriThanhLy'] ?? 0.0).toDouble(),
      idMoHinhTaiSan: json['idMoHinhTaiSan'] ?? '',
      phuongPhapKhauHao: json['phuongPhapKhauHao'] ?? '',
      soKyKhauHao: json['soKyKhauHao'] ?? 0,
      taiKhoanTaiSan: json['taiKhoanTaiSan'] ?? 0,
      taiKhoanKhauHao: json['taiKhoanKhauHao'] ?? 0,
      taiKhoanChiPhi: json['taiKhoanChiPhi'] ?? 0,
      idNhomTaiSan: json['idNhomTaiSan'] ?? '',
      ngayVaoSo: json['ngayVaoSo'] ?? DateTime.now().toIso8601String(),
      ngaySuDung: json['ngaySuDung'] ?? DateTime.now().toIso8601String(),
      idDuDan: json['idDuDan'] ?? '',
      idNguonVon: json['idNguonVon'] ?? '',
      kyHieu: json['kyHieu'] ?? '',
      soKyHieu: json['soKyHieu'] ?? '',
      congSuat: json['congSuat'] ?? '',
      nuocSanXuat: json['nuocSanXuat'] ?? '',
      namSanXuat: json['namSanXuat'] ?? 0,
      lyDoTang: json['lyDoTang'] ?? 0,
      hienTrang: json['hienTrang'] ?? 0,
      soLuong: json['soLuong'] ?? 0,
      donViTinh: json['donViTinh'] ?? '',
      ghiChu: json['ghiChu'] ?? '',
      idDonViBanDau: json['idDonViBanDau'] ?? '',
      idDonViHienThoi: json['idDonViHienThoi'] ?? '',
      moTa: json['moTa'] ?? '',
      idCongTy: json['idCongTy'] ?? '',
      ngayTao: json['ngayTao'] ?? DateTime.now().toIso8601String(),
      ngayCapNhat: json['ngayCapNhat'] ?? DateTime.now().toIso8601String(),
      nguoiTao: json['nguoiTao'] ?? '',
      nguoiCapNhat: json['nguoiCapNhat'] ?? '',
      active: json['active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idLoaiTaiSan': idLoaiTaiSan,
      'tenTaiSan': tenTaiSan,
      'nguyenGia': nguyenGia,
      'giaTriKhauHaoBanDau': giaTriKhauHaoBanDau,
      'kyKhauHaoBanDau': kyKhauHaoBanDau,
      'giaTriThanhLy': giaTriThanhLy,
      'idMoHinhTaiSan': idMoHinhTaiSan,
      'phuongPhapKhauHao': phuongPhapKhauHao,
      'soKyKhauHao': soKyKhauHao,
      'taiKhoanTaiSan': taiKhoanTaiSan,
      'taiKhoanKhauHao': taiKhoanKhauHao,
      'taiKhoanChiPhi': taiKhoanChiPhi,
      'idNhomTaiSan': idNhomTaiSan,
      'ngayVaoSo': ngayVaoSo,
      'ngaySuDung': ngaySuDung,
      'idDuDan': idDuDan,
      'idNguonVon': idNguonVon,
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
      'active': active,
    };
  }

  // Copy with method for easy updates
  AssetRequest copyWith({
    String? id,
    String? idLoaiTaiSan,
    String? tenTaiSan,
    double? nguyenGia,
    double? giaTriKhauHaoBanDau,
    int? kyKhauHaoBanDau,
    double? giaTriThanhLy,
    String? idMoHinhTaiSan,
    int? phuongPhapKhauHao,
    int? soKyKhauHao,
    int? taiKhoanTaiSan,
    int? taiKhoanKhauHao,
    int? taiKhoanChiPhi,
    String? idNhomTaiSan,
    String? ngayVaoSo,
    String? ngaySuDung,
    String? idDuDan,
    String? idNguonVon,
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
    bool? active,
  }) {
    return AssetRequest(
      id: id ?? this.id,
      idLoaiTaiSan: idLoaiTaiSan ?? this.idLoaiTaiSan,
      tenTaiSan: tenTaiSan ?? this.tenTaiSan,
      nguyenGia: nguyenGia ?? this.nguyenGia,
      giaTriKhauHaoBanDau: giaTriKhauHaoBanDau ?? this.giaTriKhauHaoBanDau,
      kyKhauHaoBanDau: kyKhauHaoBanDau ?? this.kyKhauHaoBanDau,
      giaTriThanhLy: giaTriThanhLy ?? this.giaTriThanhLy,
      idMoHinhTaiSan: idMoHinhTaiSan ?? this.idMoHinhTaiSan,
      phuongPhapKhauHao: phuongPhapKhauHao ?? this.phuongPhapKhauHao,
      soKyKhauHao: soKyKhauHao ?? this.soKyKhauHao,
      taiKhoanTaiSan: taiKhoanTaiSan ?? this.taiKhoanTaiSan,
      taiKhoanKhauHao: taiKhoanKhauHao ?? this.taiKhoanKhauHao,
      taiKhoanChiPhi: taiKhoanChiPhi ?? this.taiKhoanChiPhi,
      idNhomTaiSan: idNhomTaiSan ?? this.idNhomTaiSan,
      ngayVaoSo: ngayVaoSo ?? this.ngayVaoSo,
      ngaySuDung: ngaySuDung ?? this.ngaySuDung,
      idDuDan: idDuDan ?? this.idDuDan,
      idNguonVon: idNguonVon ?? this.idNguonVon,
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
      active: active ?? this.active,
    );
  }
}
