class DieuDongTaiSan {
  String? id;
  String? soQuyetDinh;
  String? tenPhieu;
  String? idDonViGiao;
  String? idDonViNhan;
  String? idNguoiDeNghi;
  bool? nguoiLapPhieuKyNhay;
  bool? quanTrongCanXacNhan;
  bool? phoPhongXacNhan;
  String? idDonViDeNghi;
  String? idTrinhDuyetCapPhong;
  DateTime? tggnTuNgay;
  DateTime? tggnDenNgay;
  String? idTrinhDuyetGiamDoc;
  String? diaDiemGiaoNhan;
  String? idPhongBanXemPhieu;
  String? idNhanSuXemPhieu;
  String? veViec;
  String? canCu;
  String? dieu1;
  String? dieu2;
  String? dieu3;
  String? noiNhan;
  String? themDongTrong;
  int? trangThai;
  String? idCongTy;
  DateTime? ngayTao;
  DateTime? ngayCapNhat;
  String? nguoiTao;
  String? nguoiCapNhat;
  bool? coHieuLuc;
  int? loai;
  bool? isActive;

  String? trichYeu;
  String? duongDanFile;
  String? tenFile;
  String? ngayKy;

  DieuDongTaiSan({
    this.id,
    this.soQuyetDinh,
    this.tenPhieu,
    this.idDonViGiao,
    this.idDonViNhan,
    this.idNguoiDeNghi,
    this.nguoiLapPhieuKyNhay,
    this.quanTrongCanXacNhan,
    this.phoPhongXacNhan,
    this.idDonViDeNghi,
    this.idTrinhDuyetCapPhong,
    this.tggnTuNgay,
    this.tggnDenNgay,
    this.idTrinhDuyetGiamDoc,
    this.diaDiemGiaoNhan,
    this.idPhongBanXemPhieu,
    this.idNhanSuXemPhieu,
    this.veViec,
    this.canCu,
    this.dieu1,
    this.dieu2,
    this.dieu3,
    this.noiNhan,
    this.themDongTrong,
    this.trangThai,
    this.idCongTy,
    this.ngayTao,
    this.ngayCapNhat,
    this.nguoiTao,
    this.nguoiCapNhat,
    this.coHieuLuc,
    this.loai,
    this.isActive,
    this.trichYeu,
    this.duongDanFile,
    this.tenFile,
    this.ngayKy,
  });

  factory DieuDongTaiSan.fromJson(Map<String, dynamic> json) {
    return DieuDongTaiSan(
      id: json['id'],
      soQuyetDinh: json['soQuyetDinh'],
      tenPhieu: json['tenPhieu'],
      idDonViGiao: json['idDonViGiao'],
      idDonViNhan: json['idDonViNhan'],
      idNguoiDeNghi: json['idNguoiDeNghi'],
      nguoiLapPhieuKyNhay: json['nguoiLapPhieuKyNhay'],
      quanTrongCanXacNhan: json['quanTrongCanXacNhan'],
      phoPhongXacNhan: json['phoPhongXacNhan'],
      idDonViDeNghi: json['idDonViDeNghi'],
      idTrinhDuyetCapPhong: json['idTrinhDuyetCapPhong'],
      tggnTuNgay: json['tggnTuNgay'] != null ? DateTime.parse(json['tggnTuNgay']) : null,
      tggnDenNgay: json['tggnDenNgay'] != null ? DateTime.parse(json['tggnDenNgay']) : null,
      idTrinhDuyetGiamDoc: json['idTrinhDuyetGiamDoc'],
      diaDiemGiaoNhan: json['diaDiemGiaoNhan'],
      idPhongBanXemPhieu: json['idPhongBanXemPhieu'],
      idNhanSuXemPhieu: json['idNhanSuXemPhieu'],
      veViec: json['veViec'],
      canCu: json['canCu'],
      dieu1: json['dieu1'],
      dieu2: json['dieu2'],
      dieu3: json['dieu3'],
      noiNhan: json['noiNhan'],
      themDongTrong: json['themDongTrong'],
      trangThai: json['trangThai'],
      idCongTy: json['idCongTy'],
      ngayTao: json['ngayTao'] != null ? DateTime.parse(json['ngayTao']) : null,
      ngayCapNhat: json['ngayCapNhat'] != null ? DateTime.parse(json['ngayCapNhat']) : null,
      nguoiTao: json['nguoiTao'],
      nguoiCapNhat: json['nguoiCapNhat'],
      coHieuLuc: json['coHieuLuc'],
      loai: json['loai'],
      isActive: json['isActive'],
      trichYeu: json['trichYeu'],
      duongDanFile: json['duongDanFile'],
      tenFile: json['tenFile'],
      ngayKy: json['ngayKy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
      'tggnTuNgay': tggnTuNgay?.toIso8601String(),
      'tggnDenNgay': tggnDenNgay?.toIso8601String(),
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
      'ngayTao': ngayTao?.toIso8601String(),
      'ngayCapNhat': ngayCapNhat?.toIso8601String(),
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'coHieuLuc': coHieuLuc,
      'loai': loai,
      'isActive': isActive,
      'trichYeu': trichYeu,
      'duongDanFile': duongDanFile,
      'tenFile': tenFile,
      'ngayKy': ngayKy,
    };
  }
}
