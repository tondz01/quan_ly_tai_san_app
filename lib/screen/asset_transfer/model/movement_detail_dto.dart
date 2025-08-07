class MovementDetailDto {
  final String? id;
  final String? idDieuDongTaiSan;
  final String? soQuyetDinh;
  final String? tenPhieu;
  final String? idTaiSan;
  final String? tenTaiSan;
  final String? donViTinh;
  final String? hienTrang;
  final int? soLuong;
  final String? ghiChu;
  final String? ngayTao;
  final String? ngayCapNhat;
  final String? nguoiTao;
  final String? nguoiCapNhat;
  final bool? isActive;

  MovementDetailDto({
    this.id,
    this.idDieuDongTaiSan,
    this.soQuyetDinh,
    this.tenPhieu,
    this.idTaiSan,
    this.tenTaiSan,
    this.donViTinh,
    this.hienTrang,
    this.soLuong,
    this.ghiChu,
    this.ngayTao,
    this.ngayCapNhat,
    this.nguoiTao,
    this.nguoiCapNhat,
    this.isActive,
  });

  factory MovementDetailDto.fromJson(Map<String, dynamic> json) {
    return MovementDetailDto(
      id: json['id'],
      idDieuDongTaiSan: json['idDieuDongTaiSan'],
      soQuyetDinh: json['soQuyetDinh'],
      tenPhieu: json['tenPhieu'],
      idTaiSan: json['idTaiSan'],
      tenTaiSan: json['tenTaiSan'],
      donViTinh: json['donViTinh'],
      hienTrang: json['hienTrang'],
      soLuong: json['soLuong'],
      ghiChu: json['ghiChu'],
      ngayTao: json['ngayTao'],
      ngayCapNhat: json['ngayCapNhat'],
      nguoiTao: json['nguoiTao'],
      nguoiCapNhat: json['nguoiCapNhat'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idDieuDongTaiSan': idDieuDongTaiSan,
      'soQuyetDinh': soQuyetDinh,
      'tenPhieu': tenPhieu,
      'idTaiSan': idTaiSan,
      'tenTaiSan': tenTaiSan,
      'donViTinh': donViTinh,
      'hienTrang': hienTrang,
      'soLuong': soLuong,
      'ghiChu': ghiChu,
      'ngayTao': ngayTao,
      'ngayCapNhat': ngayCapNhat,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'isActive': isActive,
    };
  }

  factory MovementDetailDto.empty() {
    return MovementDetailDto(
    );
  }
  
  // Tạo bản sao của đối tượng với các giá trị mới
  MovementDetailDto copyWith({
    String? id,
    String? idDieuDongTaiSan,
    String? soQuyetDinh,
    String? tenPhieu,
    String? idTaiSan,
    String? tenTaiSan,
    String? donViTinh,
    String? hienTrang,
    int? soLuong,
    String? ghiChu,
    String? ngayTao,
    String? ngayCapNhat,
    String? nguoiTao,
    String? nguoiCapNhat,
    bool? isActive,
  }) {
    return MovementDetailDto(
      id: id ?? this.id,
      idDieuDongTaiSan: idDieuDongTaiSan ?? this.idDieuDongTaiSan,
      soQuyetDinh: soQuyetDinh ?? this.soQuyetDinh,
      tenPhieu: tenPhieu ?? this.tenPhieu,
      idTaiSan: idTaiSan ?? this.idTaiSan,
      tenTaiSan: tenTaiSan ?? this.tenTaiSan,
      donViTinh: donViTinh ?? this.donViTinh,
      hienTrang: hienTrang ?? this.hienTrang,
      soLuong: soLuong ?? this.soLuong,
      ghiChu: ghiChu ?? this.ghiChu,
      ngayTao: ngayTao ?? this.ngayTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
      isActive: isActive ?? this.isActive,
    );
  }
  
  // Tạo bản sao từ một đối tượng có sẵn
  static MovementDetailDto copy(MovementDetailDto source, {
    String? id,
    String? idDieuDongTaiSan,
    String? soQuyetDinh,
    String? tenPhieu,
    String? idTaiSan,
    String? tenTaiSan,
    String? donViTinh,
    String? hienTrang,
    int? soLuong,
    String? ghiChu,
    String? ngayTao,
    String? ngayCapNhat,
    String? nguoiTao,
    String? nguoiCapNhat,
    bool? isActive,
  }) {
    return source.copyWith(
      id: id,
      idDieuDongTaiSan: idDieuDongTaiSan,
      soQuyetDinh: soQuyetDinh,
      tenPhieu: tenPhieu,
      idTaiSan: idTaiSan,
      tenTaiSan: tenTaiSan,
      donViTinh: donViTinh,
      hienTrang: hienTrang,
      soLuong: soLuong,
      ghiChu: ghiChu,
      ngayTao: ngayTao,
      ngayCapNhat: ngayCapNhat,
      nguoiTao: nguoiTao,
      nguoiCapNhat: nguoiCapNhat,
      isActive: isActive,
    );
  }
}
