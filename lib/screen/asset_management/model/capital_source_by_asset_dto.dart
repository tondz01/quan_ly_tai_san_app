class CapitalSourceByAssetDto {
  final String? id;
  final String? idTaiSan;
  final String? idNguonKinhPhi;
  final String? tenNguonKinhPhi;

  CapitalSourceByAssetDto({
    this.id,
    this.idTaiSan,
    this.idNguonKinhPhi,
    this.tenNguonKinhPhi,
  });

  factory CapitalSourceByAssetDto.fromJson(Map<String, dynamic> json) {
    return CapitalSourceByAssetDto(
      id: json['id'],
      idTaiSan: json['ten'],
      idNguonKinhPhi: json['note'],
      tenNguonKinhPhi: json['tenNguonKinhPhi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ten': idTaiSan,
      'note': idNguonKinhPhi,
      'tenNguonKinhPhi': tenNguonKinhPhi,
    };
  }

  CapitalSourceByAssetDto copyWith({
    String? id,
    String? idTaiSan,
    String? idNguonKinhPhi,
    String? tenNguonKinhPhi,
  }) {
    return CapitalSourceByAssetDto(
      id: id ?? this.id,
      idTaiSan: idTaiSan ?? this.idTaiSan,
      idNguonKinhPhi: idNguonKinhPhi ?? this.idNguonKinhPhi,
      tenNguonKinhPhi: tenNguonKinhPhi ?? this.tenNguonKinhPhi,
    );
  }

  // @override
  // String toString() {
  //   return 'CapitalSourceByAssetDto(id: $id, ten: $idTaiSan, note: $idNguonKinhPhi)';
  // }
}