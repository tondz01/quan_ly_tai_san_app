class CcdcGroup {
  final String? id;
  final String? ten;
  final bool? hieuLuc;
  final String? idCongTy;
  final DateTime? ngayTao;
  final DateTime? ngayCapNhat;
  final String? nguoiTao;
  final String? nguoiCapNhat;

  CcdcGroup({
    this.id,
    this.ten,
    this.hieuLuc,
    this.idCongTy,
    this.ngayTao,
    this.ngayCapNhat,
    this.nguoiTao,
    this.nguoiCapNhat,
  });

  factory CcdcGroup.fromJson(Map<String, dynamic> json) {
    return CcdcGroup(
      id: json['id'],
      ten: json['ten'],
      hieuLuc: json['hieuLuc'],
      idCongTy: json['idCongTy'],
      ngayTao:
          json['ngayTao'] != null ? DateTime.tryParse(json['ngayTao']) : null,
      ngayCapNhat:
          json['ngayCapNhat'] != null
              ? DateTime.tryParse(json['ngayCapNhat'])
              : null,
      nguoiTao: json['nguoiTao'],
      nguoiCapNhat: json['nguoiCapNhat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ten': ten,
      'hieuLuc': hieuLuc,
      'idCongTy': idCongTy,
      'ngayTao': ngayTao?.toIso8601String(),
      'ngayCapNhat': ngayCapNhat?.toIso8601String(),
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
    };
  }
}
