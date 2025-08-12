class UserInfoDTO {
  final String id;
  final String tenDangNhap;
  final String matKhau;
  final String hoTen;
  final String? email;
  final String? soDienThoai;
  final String? hinhAnh;
  final String nguoiTao;
  final String? nguoiCapNhat;
  final String idCongTy;
  final int rule;
  final bool isActive;
  final DateTime? ngayTao;
  final DateTime? ngayCapNhat;

  const UserInfoDTO({
    required this.id,
    required this.tenDangNhap,
    required this.matKhau,
    required this.hoTen,
    this.email,
    this.soDienThoai,
    this.hinhAnh,
    required this.nguoiTao,
    this.nguoiCapNhat,
    required this.idCongTy,
    required this.rule,
    required this.isActive,
    this.ngayTao,
    this.ngayCapNhat,
  });

  factory UserInfoDTO.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      final s = '$v';
      if (s.isEmpty) return null;
      return DateTime.tryParse(s);
    }

    return UserInfoDTO(
      id: json['id'] as String? ?? '',
      tenDangNhap: json['tenDangNhap'] as String? ?? '',
      matKhau: json['matKhau'] as String? ?? '',
      hoTen: json['hoTen'] as String? ?? '',
      email: json['email'] as String?,
      soDienThoai: json['soDienThoai'] as String?,
      hinhAnh: json['hinhAnh'] as String?,
      nguoiTao: json['nguoiTao'] as String? ?? '',
      nguoiCapNhat: json['nguoiCapNhat'] as String?,
      idCongTy: json['idCongTy'] as String? ?? '',
      rule: json['rule'] is int ? json['rule'] as int : int.tryParse('${json['rule']}') ?? 0,
      isActive: json['isActive'] is bool ? json['isActive'] as bool : json['isActive'] == 1,
      ngayTao: parseDate(json['ngayTao']),
      ngayCapNhat: parseDate(json['ngayCapNhat']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenDangNhap': tenDangNhap,
      'matKhau': matKhau,
      'hoTen': hoTen,
      'email': email,
      'soDienThoai': soDienThoai,
      'hinhAnh': hinhAnh,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'idCongTy': idCongTy,
      'rule': rule,
      'isActive': isActive,
      'ngayTao': ngayTao?.toIso8601String(),
      'ngayCapNhat': ngayCapNhat?.toIso8601String(),
    };
  }
}
