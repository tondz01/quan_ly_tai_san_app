class SigneInfo {
  final String idNhanVien;
  final String title;
  final String hoTen;
  final String chucVu;
  final String donVi;

  SigneInfo({
    required this.idNhanVien,
    required this.title,
    required this.hoTen,
    required this.chucVu,
    required this.donVi,
  });

  factory SigneInfo.fromJson(Map<String, dynamic> json) {
    return SigneInfo(
      idNhanVien: json['idNhanVien'],
      title: json['title'],
      hoTen: json['hoTen'],
      chucVu: json['chucVu'],
      donVi: json['donVi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idNhanVien': idNhanVien,
      'title': title,
      'hoTen': hoTen,
      'chucVu': chucVu,
      'donVi': donVi,
    };
  }

  @override
  String toString() {
    return 'SigneInfo(idNhanVien: $idNhanVien, title: $title, hoTen: $hoTen, chucVu: $chucVu, donVi: $donVi)';
  }

  SigneInfo copyWith({
    String? idNhanVien,
    String? title,
    String? hoTen,
    String? chucVu,
    String? donVi,
  }) {
    return SigneInfo(
      idNhanVien: idNhanVien ?? this.idNhanVien,
      title: title ?? this.title,
      hoTen: hoTen ?? this.hoTen,
      chucVu: chucVu ?? this.chucVu,
      donVi: donVi ?? this.donVi,
    );
  }
}
