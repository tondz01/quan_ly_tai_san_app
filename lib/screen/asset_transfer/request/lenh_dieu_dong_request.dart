class LenhDieuDongRequest {
  final String soQuyetDinh;
  final String tenPhieu;
  final String idDonViGiao;
  final String idDonViNhan;
  final String idNguoiDeNghi;
  final bool nguoiLapPhieuKyNhay;
  final bool quanTrongCanXacNhan;
  final bool phoPhongXacNhan;
  final String idDonViDeNghi;
  final String idTrinhDuyetCapPhong;
  final String tggnTuNgay;
  final String tggnDenNgay;
  final String idTrinhDuyetGiamDoc;
  final String diaDiemGiaoNhan;
  final String idPhongBanXemPhieu;
  final String idNhanSuXemPhieu;
  final String veViec;
  final String canCu;
  final String dieu1;
  final String dieu2;
  final String dieu3;
  final String noiNhan;
  final String themDongTrong;
  final int trangThai;
  final String idCongTy;
  final String ngayTao;
  final String ngayCapNhat;
  final String nguoiTao;
  final String nguoiCapNhat;
  final bool coHieuLuc;
  final int loai;
  final bool isActive;
  final String duongDanFile;
  final String tenFile;

  LenhDieuDongRequest({
    required this.soQuyetDinh,
    required this.tenPhieu,
    required this.idDonViGiao,
    required this.idDonViNhan,
    required this.idNguoiDeNghi,
    required this.nguoiLapPhieuKyNhay,
    required this.quanTrongCanXacNhan,
    required this.phoPhongXacNhan,
    required this.idDonViDeNghi,
    required this.idTrinhDuyetCapPhong,
    required this.tggnTuNgay,
    required this.tggnDenNgay,
    required this.idTrinhDuyetGiamDoc,
    required this.diaDiemGiaoNhan,
    required this.idPhongBanXemPhieu,
    required this.idNhanSuXemPhieu,
    required this.veViec,
    required this.canCu,
    required this.dieu1,
    required this.dieu2,
    required this.dieu3,
    required this.noiNhan,
    required this.themDongTrong,
    required this.trangThai,
    required this.idCongTy,
    required this.ngayTao,
    required this.ngayCapNhat,
    required this.nguoiTao,
    required this.nguoiCapNhat,
    required this.coHieuLuc,
    required this.loai,
    required this.isActive,
    required this.duongDanFile,
    required this.tenFile,
  });

  factory LenhDieuDongRequest.fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic v) {
      if (v is bool) return v;
      if (v is num) return v != 0;
      if (v is String) return v.toLowerCase() == 'true' || v == '1';
      return false;
    }

    int parseInt(dynamic v) {
      if (v is int) return v;
      return int.tryParse(v?.toString() ?? '0') ?? 0;
    }

    return LenhDieuDongRequest(
      soQuyetDinh: json['soQuyetDinh'] ?? '',
      tenPhieu: json['tenPhieu'] ?? '',
      idDonViGiao: json['idDonViGiao'] ?? '',
      idDonViNhan: json['idDonViNhan'] ?? '',
      idNguoiDeNghi: json['idNguoiDeNghi'] ?? '',
      nguoiLapPhieuKyNhay: parseBool(json['nguoiLapPhieuKyNhay']),
      quanTrongCanXacNhan: parseBool(json['quanTrongCanXacNhan']),
      phoPhongXacNhan: parseBool(json['phoPhongXacNhan']),
      idDonViDeNghi: json['idDonViDeNghi'] ?? '',
      idTrinhDuyetCapPhong: json['idTrinhDuyetCapPhong'] ?? '',
      tggnTuNgay: json['tggnTuNgay'] ?? '',
      tggnDenNgay: json['tggnDenNgay'] ?? '',
      idTrinhDuyetGiamDoc: json['idTrinhDuyetGiamDoc'] ?? '',
      diaDiemGiaoNhan: json['diaDiemGiaoNhan'] ?? '',
      idPhongBanXemPhieu: json['idPhongBanXemPhieu'] ?? '',
      idNhanSuXemPhieu: json['idNhanSuXemPhieu'] ?? '',
      veViec: json['veViec'] ?? '',
      canCu: json['canCu'] ?? '',
      dieu1: json['dieu1'] ?? '',
      dieu2: json['dieu2'] ?? '',
      dieu3: json['dieu3'] ?? '',
      noiNhan: json['noiNhan'] ?? '',
      themDongTrong: json['themDongTrong'] ?? '',
      trangThai: parseInt(json['trangThai']),
      idCongTy: json['idCongTy'] ?? '',
      ngayTao: json['ngayTao'] ?? '',
      ngayCapNhat: json['ngayCapNhat'] ?? '',
      nguoiTao: json['nguoiTao'] ?? '',
      nguoiCapNhat: json['nguoiCapNhat'] ?? '',
      coHieuLuc: parseBool(json['coHieuLuc']),
      loai: parseInt(json['loai']),
      isActive: parseBool(json['isActive']),
      duongDanFile: json['duongDanFile'] ?? '',
      tenFile: json['tenFile'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'soQuyetDinh': soQuyetDinh,
      'tenPhieu': tenPhieu,
      'idDonViGiao': idDonViGiao,
      'idDonViNhan': idDonViNhan,
      'idNguoiDeNghi': idNguoiDeNghi,
      'nguoiLapPhieuKyNhay': nguoiLapPhieuKyNhay,
      'quanTrongCanXacNhan': quanTrongCanXacNhan,
      'phoPhongXacNhan': phoPhongXacNhan,
      'idDonViDeNghi': idDonViDeNghi,
      'idTrinhDuyetCapPhong': idTrinhDuyetCapPhong,
      'tggnTuNgay': tggnTuNgay,
      'tggnDenNgay': tggnDenNgay,
      'idTrinhDuyetGiamDoc': idTrinhDuyetGiamDoc,
      'diaDiemGiaoNhan': diaDiemGiaoNhan,
      'idPhongBanXemPhieu': idPhongBanXemPhieu,
      'idNhanSuXemPhieu': idNhanSuXemPhieu,
      'veViec': veViec,
      'canCu': canCu,
      'dieu1': dieu1,
      'dieu2': dieu2,
      'dieu3': dieu3,
      'noiNhan': noiNhan,
      'themDongTrong': themDongTrong,
      'trangThai': trangThai,
      'idCongTy': idCongTy,
      'ngayTao': ngayTao,
      'ngayCapNhat': ngayCapNhat,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'coHieuLuc': coHieuLuc,
      'loai': loai,
      'isActive': isActive,
      'duongDanFile': duongDanFile,
      'tenFile': tenFile,
    };
  }

  LenhDieuDongRequest copyWith({
    String? soQuyetDinh,
    String? tenPhieu,
    String? idDonViGiao,
    String? idDonViNhan,
    String? idNguoiDeNghi,
    bool? nguoiLapPhieuKyNhay,
    bool? quanTrongCanXacNhan,
    bool? phoPhongXacNhan,
    String? idDonViDeNghi,
    String? idTrinhDuyetCapPhong,
    String? tggnTuNgay,
    String? tggnDenNgay,
    String? idTrinhDuyetGiamDoc,
    String? diaDiemGiaoNhan,
    String? idPhongBanXemPhieu,
    String? idNhanSuXemPhieu,
    String? veViec,
    String? canCu,
    String? dieu1,
    String? dieu2,
    String? dieu3,
    String? noiNhan,
    String? themDongTrong,
    int? trangThai,
    String? idCongTy,
    String? ngayTao,
    String? ngayCapNhat,
    String? nguoiTao,
    String? nguoiCapNhat,
    bool? coHieuLuc,
    int? loai,
    bool? isActive,
    String? duongDanFile,
    String? tenFile,
  }) {
    return LenhDieuDongRequest(
      soQuyetDinh: soQuyetDinh ?? this.soQuyetDinh,
      tenPhieu: tenPhieu ?? this.tenPhieu,
      idDonViGiao: idDonViGiao ?? this.idDonViGiao,
      idDonViNhan: idDonViNhan ?? this.idDonViNhan,
      idNguoiDeNghi: idNguoiDeNghi ?? this.idNguoiDeNghi,
      nguoiLapPhieuKyNhay: nguoiLapPhieuKyNhay ?? this.nguoiLapPhieuKyNhay,
      quanTrongCanXacNhan: quanTrongCanXacNhan ?? this.quanTrongCanXacNhan,
      phoPhongXacNhan: phoPhongXacNhan ?? this.phoPhongXacNhan,
      idDonViDeNghi: idDonViDeNghi ?? this.idDonViDeNghi,
      idTrinhDuyetCapPhong: idTrinhDuyetCapPhong ?? this.idTrinhDuyetCapPhong,
      tggnTuNgay: tggnTuNgay ?? this.tggnTuNgay,
      tggnDenNgay: tggnDenNgay ?? this.tggnDenNgay,
      idTrinhDuyetGiamDoc: idTrinhDuyetGiamDoc ?? this.idTrinhDuyetGiamDoc,
      diaDiemGiaoNhan: diaDiemGiaoNhan ?? this.diaDiemGiaoNhan,
      idPhongBanXemPhieu: idPhongBanXemPhieu ?? this.idPhongBanXemPhieu,
      idNhanSuXemPhieu: idNhanSuXemPhieu ?? this.idNhanSuXemPhieu,
      veViec: veViec ?? this.veViec,
      canCu: canCu ?? this.canCu,
      dieu1: dieu1 ?? this.dieu1,
      dieu2: dieu2 ?? this.dieu2,
      dieu3: dieu3 ?? this.dieu3,
      noiNhan: noiNhan ?? this.noiNhan,
      themDongTrong: themDongTrong ?? this.themDongTrong,
      trangThai: trangThai ?? this.trangThai,
      idCongTy: idCongTy ?? this.idCongTy,
      ngayTao: ngayTao ?? this.ngayTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
      coHieuLuc: coHieuLuc ?? this.coHieuLuc,
      loai: loai ?? this.loai,
      isActive: isActive ?? this.isActive,
      duongDanFile: duongDanFile ?? this.duongDanFile,
      tenFile: tenFile ?? this.tenFile,
    );
  }
}
