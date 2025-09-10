class SignatoryDto {
  final String? id;
  final String? idTaiLieu;
  final String? idPhongBan;
  final String? idNguoiKy;
  final String? tenNguoiKy;
  final int? trangThai;

  SignatoryDto({
    this.id,
    this.idTaiLieu,
    this.idPhongBan,
    this.idNguoiKy,
    this.tenNguoiKy,
    this.trangThai,
  });

  factory SignatoryDto.fromJson(Map<String, dynamic> json) {
    return SignatoryDto(
      id: json['id'],
      idTaiLieu: json['idTaiLieu'],
      idPhongBan: json['idPhongBan'],
      idNguoiKy: json['idNguoiKy'],
      tenNguoiKy: json['tenNguoiKy'],
      trangThai: json['trangThai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idTaiLieu': idTaiLieu,
      'idPhongBan': idPhongBan,
      'idNguoiKy': idNguoiKy,
      'tenNguoiKy': tenNguoiKy,
      'trangThai': trangThai,
    };
  }

  static List<SignatoryDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SignatoryDto.fromJson(json)).toList();
  }
  
  SignatoryDto copyWith({
    String? id,
    String? idTaiLieu,
    String? idPhongBan,
    String? idNguoiKy,
    String? tenNguoiKy,
    int? trangThai,
  }) {
    return SignatoryDto(
      id: id ?? this.id,
      idTaiLieu: idTaiLieu ?? this.idTaiLieu,
      idPhongBan: idPhongBan ?? this.idPhongBan,
      idNguoiKy: idNguoiKy ?? this.idNguoiKy,
      tenNguoiKy: tenNguoiKy ?? this.tenNguoiKy,
      trangThai: trangThai ?? this.trangThai,
    );
  }
}
