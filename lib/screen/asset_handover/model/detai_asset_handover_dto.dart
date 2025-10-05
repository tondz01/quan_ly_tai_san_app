class DetailAssetHandoverDto {
  final String? id;
  final String? idBanGiaoTaiSan;
  final String? banGiaoTaiSan;
  final String? quyetDinhDieuDongSo;
  final String? idTaiSan;
  final String? tenTaiSan;
  final String? donViTinh;
  final String? kyHieu;
  final String? soKyHieu;
  final int? hienTrang;
  final String? moTa;
  final int? soLuong;
  final String? ngayTao;
  final String? ngayCapNhat;
  final String? nguoiTao;
  final String? nguoiCapNhat;
  final bool? isActive;

  DetailAssetHandoverDto({
    this.id,
    this.idBanGiaoTaiSan,
    this.banGiaoTaiSan,
    this.quyetDinhDieuDongSo,
    this.idTaiSan,
    this.tenTaiSan,
    this.donViTinh,
    this.kyHieu,
    this.soKyHieu,
    this.hienTrang,
    this.moTa,
    this.soLuong,
    this.ngayTao,
    this.ngayCapNhat,
    this.nguoiTao,
    this.nguoiCapNhat,
    this.isActive,
  });

  factory DetailAssetHandoverDto.fromJson(Map<String, dynamic> json) {
    return DetailAssetHandoverDto(
      id: json['id'] as String?,
      idBanGiaoTaiSan: json['idBanGiaoTaiSan'] as String?,
      banGiaoTaiSan: json['banGiaoTaiSan'] as String?,
      quyetDinhDieuDongSo: json['quyetDinhDieuDongSo'] as String?,
      idTaiSan: json['idTaiSan'] as String?,
      tenTaiSan: json['tenTaiSan'] as String?,
      donViTinh: json['donViTinh'] as String?,
      kyHieu: json['kyHieu'] as String?,
      soKyHieu: json['soKyHieu'] as String?,
      hienTrang: json['hienTrang'] is int
          ? json['hienTrang'] as int?
          : int.tryParse(json['hienTrang']?.toString() ?? ''),
      moTa: json['moTa'] as String?,
      soLuong: json['soLuong'] is int
          ? json['soLuong'] as int?
          : int.tryParse(json['soLuong']?.toString() ?? ''),
      ngayTao: json['ngayTao'] as String?,
      ngayCapNhat: json['ngayCapNhat'] as String?,
      nguoiTao: json['nguoiTao'] as String?,
      nguoiCapNhat: json['nguoiCapNhat'] as String?,
      isActive: json['isActive'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idBanGiaoTaiSan': idBanGiaoTaiSan,
      'banGiaoTaiSan': banGiaoTaiSan,
      'quyetDinhDieuDongSo': quyetDinhDieuDongSo,
      'idTaiSan': idTaiSan,
      'tenTaiSan': tenTaiSan,
      'donViTinh': donViTinh,
      'kyHieu': kyHieu,
      'soKyHieu': soKyHieu,
      'hienTrang': hienTrang,
      'moTa': moTa,
      'soLuong': soLuong,
      'ngayTao': ngayTao,
      'ngayCapNhat': ngayCapNhat,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'isActive': isActive,
    };
  }

  DetailAssetHandoverDto copyWith({
    String? id,
    String? idBanGiaoTaiSan,
    String? banGiaoTaiSan,
    String? quyetDinhDieuDongSo,
    String? idTaiSan,
    String? tenTaiSan,
    String? donViTinh,
    String? kyHieu,
    String? soKyHieu,
    int? hienTrang,
    String? moTa,
    int? soLuong,
    String? ngayTao,
    String? ngayCapNhat,
    String? nguoiTao,
    String? nguoiCapNhat,
    bool? isActive,
  }) {
    return DetailAssetHandoverDto(
      id: id ?? this.id,
      idBanGiaoTaiSan: idBanGiaoTaiSan ?? this.idBanGiaoTaiSan,
      banGiaoTaiSan: banGiaoTaiSan ?? this.banGiaoTaiSan,
      quyetDinhDieuDongSo: quyetDinhDieuDongSo ?? this.quyetDinhDieuDongSo,
      idTaiSan: idTaiSan ?? this.idTaiSan,
      tenTaiSan: tenTaiSan ?? this.tenTaiSan,
      donViTinh: donViTinh ?? this.donViTinh,
      kyHieu: kyHieu ?? this.kyHieu,
      soKyHieu: soKyHieu ?? this.soKyHieu,
      hienTrang: hienTrang ?? this.hienTrang,
      moTa: moTa ?? this.moTa,
      soLuong: soLuong ?? this.soLuong,
      ngayTao: ngayTao ?? this.ngayTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'DetailAssetHandoverDto(id: $id, idBanGiaoTaiSan: $idBanGiaoTaiSan, banGiaoTaiSan: $banGiaoTaiSan, quyetDinhDieuDongSo: $quyetDinhDieuDongSo, idTaiSan: $idTaiSan, tenTaiSan: $tenTaiSan, donViTinh: $donViTinh, kyHieu: $kyHieu, soKyHieu: $soKyHieu, hienTrang: $hienTrang, moTa: $moTa, soLuong: $soLuong, ngayTao: $ngayTao, ngayCapNhat: $ngayCapNhat, nguoiTao: $nguoiTao, nguoiCapNhat: $nguoiCapNhat, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DetailAssetHandoverDto &&
        other.id == id &&
        other.idBanGiaoTaiSan == idBanGiaoTaiSan &&
        other.banGiaoTaiSan == banGiaoTaiSan &&
        other.quyetDinhDieuDongSo == quyetDinhDieuDongSo &&
        other.idTaiSan == idTaiSan &&
        other.tenTaiSan == tenTaiSan &&
        other.donViTinh == donViTinh &&
        other.kyHieu == kyHieu &&
        other.soKyHieu == soKyHieu &&
        other.hienTrang == hienTrang &&
        other.moTa == moTa &&
        other.soLuong == soLuong &&
        other.ngayTao == ngayTao &&
        other.ngayCapNhat == ngayCapNhat &&
        other.nguoiTao == nguoiTao &&
        other.nguoiCapNhat == nguoiCapNhat &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        idBanGiaoTaiSan.hashCode ^
        banGiaoTaiSan.hashCode ^
        quyetDinhDieuDongSo.hashCode ^
        idTaiSan.hashCode ^
        tenTaiSan.hashCode ^
        donViTinh.hashCode ^
        kyHieu.hashCode ^
        soKyHieu.hashCode ^
        hienTrang.hashCode ^
        moTa.hashCode ^
        soLuong.hashCode ^
        ngayTao.hashCode ^
        ngayCapNhat.hashCode ^
        nguoiTao.hashCode ^
        nguoiCapNhat.hashCode ^
        isActive.hashCode;
  }
}
