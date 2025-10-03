class ConfigDto {
  final String idAccount;
  final int? thoiHanTaiLieu;
  final int? ngayBaoHetHan;

  ConfigDto({
    required this.idAccount,
    required this.thoiHanTaiLieu,
    required this.ngayBaoHetHan,
  });

  factory ConfigDto.fromJson(Map<String, dynamic> json) {
    return ConfigDto(
      idAccount: json['idAccount'],
      thoiHanTaiLieu: json['thoiHanTaiLieu'],
      ngayBaoHetHan: json['ngayBaoHetHan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idAccount': idAccount,
      'thoiHanTaiLieu': thoiHanTaiLieu,
      'ngayBaoHetHan': ngayBaoHetHan,
    };
  }

  @override
  String toString() {
    return 'ConfigDto(idAccount: $idAccount, thoiHanTaiLieu: $thoiHanTaiLieu, ngayBaoHetHan: $ngayBaoHetHan)';
  }

  ConfigDto copyWith({
    String? idAccount,
    int? thoiHanTaiLieu,
    int? ngayBaoHetHan,
  }) {
    return ConfigDto(
      idAccount: idAccount ?? this.idAccount,
      thoiHanTaiLieu: thoiHanTaiLieu ?? this.thoiHanTaiLieu,
      ngayBaoHetHan: ngayBaoHetHan ?? this.ngayBaoHetHan,
    );
  }
}
