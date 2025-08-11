class AuthRequest {
  String tenDangNhap;
  String matKhau;

  AuthRequest({
    required this.tenDangNhap,
    required this.matKhau,
  });

  Map<String, dynamic> toJson() {
    return {
      'tenDangNhap': tenDangNhap,
      'matKhau': matKhau,
    };
  }
}
