/// Enum định nghĩa các loại kho trong hệ thống
enum LoaiKho {
  /// Không phải kho (giá trị: 0)
  none(0, 'Không phải kho'),

  /// Kho cấp phát (giá trị: 1)
  capPhat(1, 'Kho cấp phát'),

  /// Kho thu hồi (giá trị: 2)
  thuHoi(2, 'Kho thu hồi');

  final int value;
  final String label;

  const LoaiKho(this.value, this.label);

  /// Chuyển từ int sang enum
  static LoaiKho fromValue(int? value) {
    return LoaiKho.values.firstWhere(
      (e) => e.value == value,
      orElse: () => LoaiKho.none,
    );
  }

  /// Kiểm tra có phải kho cấp phát không
  bool get isKhoCapPhat => this == LoaiKho.capPhat;

  /// Kiểm tra có phải kho thu hồi không
  bool get isKhoThuHoi => this == LoaiKho.thuHoi;

  /// Kiểm tra có phải kho hay không
  bool get isKho => this != LoaiKho.none;
}
