class DetailToolAndMaterialTransferDto {
  final String id;
  final String idDieuDongCCDCVatTu; // idToolAndMaterialTransfer
  final String? tenCCDCVatTu;
  final String soQuyetDinh;
  final String idCCDCVatTu; // idTaiSan
  final String idChiTietCCDCVatTu;
  final String tenPhieu;
  final String? donViTinh;
  final String? congSuat;
  final String? nuocSanXuat;
  final String? soKyHieu;
  final String? kyHieu;
  final int? namSanXuat;
  final int soLuong;
  final int soLuongXuat;
  final String ghiChu;
  final String ngayTao;
  final String ngayCapNhat;
  final String nguoiTao;
  final String nguoiCapNhat;
  final bool isActive;
  final int? soLuongConLai;

  DetailToolAndMaterialTransferDto({
    required this.id,
    required this.idDieuDongCCDCVatTu,
    required this.idCCDCVatTu,
    required this.idChiTietCCDCVatTu,
    required this.soQuyetDinh,
    required this.tenPhieu,
    this.tenCCDCVatTu,
    this.donViTinh,
    this.congSuat,
    this.nuocSanXuat,
    this.soKyHieu,
    this.kyHieu,
    this.namSanXuat,
    required this.soLuong,
    required this.soLuongXuat,
    required this.ghiChu,
    required this.ngayTao,
    required this.ngayCapNhat,
    required this.nguoiTao,
    required this.nguoiCapNhat,
    required this.isActive,
    this.soLuongConLai,
  });

  factory DetailToolAndMaterialTransferDto.fromJson(Map<String, dynamic> json) {
    String parseString(dynamic v) => v?.toString() ?? '';
    
    int parseInt(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v?.toString() ?? '0') ?? 0;
    }
    
    int? parseNullableInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      final parsed = int.tryParse(v.toString());
      return parsed;
    }
    
    bool parseBool(dynamic v) {
      if (v is bool) return v;
      if (v is num) return v != 0;
      if (v is String) return v.toLowerCase() == 'true' || v == '1';
      return false;
    }

    return DetailToolAndMaterialTransferDto(
      id: parseString(json['id']),
      idDieuDongCCDCVatTu: parseString(json['idDieuDongCCDCVatTu'] ?? json['idToolAndMaterialTransfer']),
      idCCDCVatTu: parseString(json['idCCDCVatTu'] ?? json['idTaiSan']),
      idChiTietCCDCVatTu: parseString(json['idChiTietCCDCVatTu']),
      soQuyetDinh: parseString(json['soQuyetDinh']),
      tenPhieu: parseString(json['tenPhieu']),
      tenCCDCVatTu: json['tenCCDCVatTu'],
      donViTinh: json['donViTinh'],
      congSuat: json['congSuat'],
      nuocSanXuat: json['nuocSanXuat'],
      soKyHieu: json['soKyHieu'],
      kyHieu: json['kyHieu'],
      namSanXuat: parseNullableInt(json['namSanXuat']),
      soLuong: parseInt(json['soLuong']),
      soLuongXuat: parseInt(json['soLuongXuat'] ?? 0),
      ghiChu: parseString(json['ghiChu']),
      ngayTao: parseString(json['ngayTao']),
      ngayCapNhat: parseString(json['ngayCapNhat']),
      nguoiTao: parseString(json['nguoiTao']),
      nguoiCapNhat: parseString(json['nguoiCapNhat']),
      isActive: parseBool(json['isActive']),
      soLuongConLai: parseNullableInt(json['soLuongConLai']),
    );
  }

  Map<String, dynamic> toJson() {
    
    return {
      'id': id,
      'idDieuDongCCDCVatTu': idDieuDongCCDCVatTu,
      'idToolAndMaterialTransfer': idDieuDongCCDCVatTu, // Tương thích ngược
      'idCCDCVatTu': idCCDCVatTu,
      'idTaiSan': idCCDCVatTu, // Tương thích ngược
      'idChiTietCCDCVatTu': idChiTietCCDCVatTu,
      'soQuyetDinh': soQuyetDinh,
      'tenPhieu': tenPhieu,
      'tenCCDCVatTu': tenCCDCVatTu,
      'donViTinh': donViTinh,
      'congSuat': congSuat,
      'nuocSanXuat': nuocSanXuat,
      'soKyHieu': soKyHieu,
      'kyHieu': kyHieu,
      'namSanXuat': namSanXuat,
      'soLuong': soLuong,
      'soLuongXuat': soLuongXuat,
      'ghiChu': ghiChu,
      'ngayTao': ngayTao,
      'ngayCapNhat': ngayCapNhat,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'isActive': isActive,
      'soLuongConLai': soLuongConLai,
    };
  }

  factory DetailToolAndMaterialTransferDto.empty() {
    final now = DateTime.now();
    return DetailToolAndMaterialTransferDto(
      id: '',
      idDieuDongCCDCVatTu: '',
      idCCDCVatTu: '',
      idChiTietCCDCVatTu: '',
      soQuyetDinh: '',
      tenPhieu: '',
      tenCCDCVatTu: null,
      donViTinh: null,
      congSuat: null,
      nuocSanXuat: null,
      soKyHieu: null,
      kyHieu: null,
      namSanXuat: null,
      soLuong: 0,
      soLuongXuat: 0,
      ghiChu: '',
      ngayTao: now.toIso8601String(),
      ngayCapNhat: now.toIso8601String(),
      nguoiTao: '',
      nguoiCapNhat: '',
      isActive: true,
      soLuongConLai: 0,
    );
  }
  
  // Tạo một bản sao với các giá trị mới
  DetailToolAndMaterialTransferDto copyWith({
    String? id,
    String? idDieuDongCCDCVatTu,
    String? idCCDCVatTu,
    String? idChiTietCCDCVatTu,
    String? soQuyetDinh,
    String? tenPhieu,
    String? tenCCDCVatTu,
    String? donViTinh,
    String? congSuat,
    String? nuocSanXuat,
    String? soKyHieu,
    String? kyHieu,
    int? namSanXuat,
    int? soLuong,
    int? soLuongXuat,
    String? ghiChu,
    String? ngayTao,
    String? ngayCapNhat,
    String? nguoiTao,
    String? nguoiCapNhat,
    bool? isActive,
    int? soLuongConLai,
  }) {
    return DetailToolAndMaterialTransferDto(
      id: id ?? this.id,
      idDieuDongCCDCVatTu: idDieuDongCCDCVatTu ?? this.idDieuDongCCDCVatTu,
      idCCDCVatTu: idCCDCVatTu ?? this.idCCDCVatTu,
      idChiTietCCDCVatTu: idChiTietCCDCVatTu ?? this.idChiTietCCDCVatTu,
      soQuyetDinh: soQuyetDinh ?? this.soQuyetDinh,
      tenPhieu: tenPhieu ?? this.tenPhieu,
      tenCCDCVatTu: tenCCDCVatTu ?? this.tenCCDCVatTu,
      donViTinh: donViTinh ?? this.donViTinh,
      congSuat: congSuat ?? this.congSuat,
      nuocSanXuat: nuocSanXuat ?? this.nuocSanXuat,
      soKyHieu: soKyHieu ?? this.soKyHieu,
      kyHieu: kyHieu ?? this.kyHieu,
      namSanXuat: namSanXuat ?? this.namSanXuat,
      soLuong: soLuong ?? this.soLuong,
      soLuongXuat: soLuongXuat ?? this.soLuongXuat,
      ghiChu: ghiChu ?? this.ghiChu,
      ngayTao: ngayTao ?? this.ngayTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
      isActive: isActive ?? this.isActive,
      soLuongConLai: soLuongConLai ?? this.soLuongConLai,
    );
  }
}
