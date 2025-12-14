class CurrentStatus {
  final int? id;
  final String? tenHTKT;
  final String? moTa;
  final String? ngayTao;
  final String? ngayCapNhat;
  final String? nguoiTao;
  final String? nguoiCapNhat;
  final bool? isActive;

  CurrentStatus({
    this.id,
    this.tenHTKT,
    this.moTa,
    this.ngayTao,
    this.ngayCapNhat,
    this.nguoiTao,
    this.nguoiCapNhat,
    this.isActive,
  });

  factory CurrentStatus.fromJson(Map<String, dynamic> json) {
    return CurrentStatus(
      id: json['id'],
      tenHTKT: json['tenHTKT'] ?? '',
      moTa: json['moTa'] ?? '',
      ngayTao: json['ngayTao'] ?? '',
      ngayCapNhat: json['ngayCapNhat'] ?? '',
      nguoiTao: json['nguoiTao'] ?? '',
      nguoiCapNhat: json['nguoiCapNhat'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenHTKT': tenHTKT,
      'moTa': moTa,
      'ngayTao': ngayTao,
      'ngayCapNhat': ngayCapNhat,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'isActive': isActive,
    };
  }

  dynamic _nullIfEmpty(dynamic value) {
    if (value == null) {
      return "";
    }
    if (value is String) {
      return value.trim().isEmpty ? "" : value;
    }
    return value;
  }

  Map<String, dynamic> toExportJson() {
    return {
      'Mã trạng thái': _nullIfEmpty(id),
      'Tên trạng thái': _nullIfEmpty(tenHTKT),
      'Mô tả': _nullIfEmpty(moTa),
      'Ngày tạo': _nullIfEmpty(ngayTao),
      'Ngày cập nhật': _nullIfEmpty(ngayCapNhat),
      'Người tạo': _nullIfEmpty(nguoiTao),
      'Người cập nhật': _nullIfEmpty(nguoiCapNhat),
      'Trạng thái': _nullIfEmpty(isActive == true ? 'Hoạt động' : 'Không hoạt động'),
    };
  }

  static CurrentStatus empty() {
    return CurrentStatus(
      id: 0,
      tenHTKT: 'Không xác định',
      moTa: '',
      ngayTao: '',
      ngayCapNhat: '',
      nguoiTao: '',
      nguoiCapNhat: '',
      isActive: true,
    );
  }

  @override
  String toString() {
    return tenHTKT ?? '';
  }
}
