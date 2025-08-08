class AssetCategoryRequest {
  final String id;
  final String tenMoHinh;
  final String idCongTy;
  final String? ghiChu;
  final String nguoiTao;
  final String? nguoiCapNhat;
  final DateTime? ngayTao;
  final DateTime? ngayCapNhat;
  final bool isActive;

  const AssetCategoryRequest({
    required this.id,
    required this.tenMoHinh,
    required this.idCongTy,
    this.ghiChu,
    required this.nguoiTao,
    this.nguoiCapNhat,
    this.ngayTao,
    this.ngayCapNhat,
    required this.isActive,
  });

  factory AssetCategoryRequest.fromJson(Map<String, dynamic> json) {
    return AssetCategoryRequest(
      id: json['id'] ?? '',
      tenMoHinh: json['tenMoHinh'] ?? '',
      idCongTy: json['idCongTy'] ?? '',
      ghiChu: json['ghiChu'],
      nguoiTao: json['nguoiTao'] ?? '',
      nguoiCapNhat: json['nguoiCapNhat'],
      ngayTao: json['ngayTao'] != null && (json['ngayTao'] as String).isNotEmpty
          ? DateTime.parse(json['ngayTao'])
          : null,
      ngayCapNhat: json['ngayCapNhat'] != null && (json['ngayCapNhat'] as String).isNotEmpty
          ? DateTime.parse(json['ngayCapNhat'])
          : null,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'tenMoHinh': tenMoHinh,
      'idCongTy': idCongTy,
      'ghiChu': ghiChu,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'ngayTao': ngayTao?.toIso8601String(),
      'ngayCapNhat': ngayCapNhat?.toIso8601String(),
      'isActive': isActive,
    };
  }

  AssetCategoryRequest copyWith({
    String? id,
    String? tenMoHinh,
    String? idCongTy,
    String? ghiChu,
    String? nguoiTao,
    String? nguoiCapNhat,
    DateTime? ngayTao,
    DateTime? ngayCapNhat,
    bool? isActive,
  }) {
    return AssetCategoryRequest(
      id: id ?? this.id,
      tenMoHinh: tenMoHinh ?? this.tenMoHinh,
      idCongTy: idCongTy ?? this.idCongTy,
      ghiChu: ghiChu ?? this.ghiChu,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
      ngayTao: ngayTao ?? this.ngayTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'AssetCategoryRequest(id: ' 
        '$id, tenMoHinh: $tenMoHinh, idCongTy: $idCongTy, ghiChu: $ghiChu, '
        'nguoiTao: $nguoiTao, nguoiCapNhat: $nguoiCapNhat, ngayTao: $ngayTao, '
        'ngayCapNhat: $ngayCapNhat, isActive: $isActive)';
  }
}
