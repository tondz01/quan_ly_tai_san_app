class LenhDieuDongRequest {
  final String id;
  final String soQuyetDinh;
  final String tenPhieu;
  final String idDonViGiao;
  final String idDonViNhan;
  final String idNguoiDeNghi;
  final bool nguoiLapPhieuKyNhay;
  final bool quanTrongCanXacNhan;
  final bool phoPhongXacNhan;
  final String idDonViDeNghi;
  final String tggnTuNgay;
  final String tggnDenNgay;
  final String idTruongPhongDonViGiao;
  final bool truongPhongDonViGiaoXacNhan;
  final String idPhoPhongDonViGiao;
  final bool phoPhongDonViGiaoXacNhan;
  final String idTrinhDuyetCapPhong;
  final bool trinhDuyetCapPhongXacNhan;
  final String idTrinhDuyetGiamDoc;
  final bool trinhDuyetGiamDocXacNhan;
  final String diaDiemGiaoNhan;
  final String idPhongBanXemPhieu;
  final String idNhanSuXemPhieu;
  final String noiNhan;
  final int trangThai;
  final String idCongTy;
  final String ngayTao;
  final String ngayCapNhat;
  final String nguoiTao;
  final String nguoiCapNhat;
  final bool coHieuLuc;
  final int loai;
  final bool isActive;
  final String trichYeu;
  final String duongDanFile;
  final String tenFile;
  final String ngayKy;
  final bool share;
  final String idNguoiKyNhay;
  final bool trangThaiKyNhay;
  LenhDieuDongRequest({
    this.id = '',
    required this.soQuyetDinh,
    required this.tenPhieu,
    required this.idDonViGiao,
    required this.idDonViNhan,
    required this.idNguoiDeNghi,
    required this.nguoiLapPhieuKyNhay,
    required this.quanTrongCanXacNhan,
    required this.phoPhongXacNhan,
    required this.idDonViDeNghi,
    required this.tggnTuNgay,
    required this.tggnDenNgay,
    required this.idTruongPhongDonViGiao,
    required this.truongPhongDonViGiaoXacNhan,
    required this.idPhoPhongDonViGiao,
    required this.phoPhongDonViGiaoXacNhan,
    required this.idTrinhDuyetCapPhong,
    required this.trinhDuyetCapPhongXacNhan,
    required this.idTrinhDuyetGiamDoc,
    required this.trinhDuyetGiamDocXacNhan,
    required this.diaDiemGiaoNhan,
    required this.idPhongBanXemPhieu,
    required this.idNhanSuXemPhieu,
    required this.noiNhan,
    required this.trangThai,
    required this.idCongTy,
    required this.ngayTao,
    required this.ngayCapNhat,
    required this.nguoiTao,
    required this.nguoiCapNhat,
    required this.coHieuLuc,
    required this.loai,
    required this.isActive,
    required this.trichYeu,
    required this.duongDanFile,
    required this.tenFile,
    required this.ngayKy,
    required this.share,
    required this.idNguoiKyNhay,
    required this.trangThaiKyNhay,
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
      id: json['id'] ?? '',
      soQuyetDinh: json['soQuyetDinh'] ?? '',
      tenPhieu: json['tenPhieu'] ?? '',
      idDonViGiao: json['idDonViGiao'] ?? '',
      idDonViNhan: json['idDonViNhan'] ?? '',
      idNguoiDeNghi: json['idNguoiDeNghi'] ?? '',
      nguoiLapPhieuKyNhay: parseBool(json['nguoiLapPhieuKyNhay']),
      quanTrongCanXacNhan: parseBool(json['quanTrongCanXacNhan']),
      phoPhongXacNhan: parseBool(json['phoPhongXacNhan']),
      idDonViDeNghi: json['idDonViDeNghi'] ?? '',
      tggnTuNgay: json['tggnTuNgay']?.toString() ?? '',
      tggnDenNgay: json['tggnDenNgay']?.toString() ?? '',
      idTruongPhongDonViGiao: json['idTruongPhongDonViGiao'] ?? '',
      truongPhongDonViGiaoXacNhan: parseBool(json['truongPhongDonViGiaoXacNhan']),
      idPhoPhongDonViGiao: json['idPhoPhongDonViGiao'] ?? '',
      phoPhongDonViGiaoXacNhan: parseBool(json['phoPhongDonViGiaoXacNhan']),
      idTrinhDuyetCapPhong: json['idTrinhDuyetCapPhong'] ?? '',
      trinhDuyetCapPhongXacNhan: parseBool(json['trinhDuyetCapPhongXacNhan']),
      idTrinhDuyetGiamDoc: json['idTrinhDuyetGiamDoc'] ?? '',
      trinhDuyetGiamDocXacNhan: parseBool(json['trinhDuyetGiamDocXacNhan']),
      diaDiemGiaoNhan: json['diaDiemGiaoNhan'] ?? '',
      idPhongBanXemPhieu: json['idPhongBanXemPhieu'] ?? '',
      idNhanSuXemPhieu: json['idNhanSuXemPhieu'] ?? '',
      noiNhan: json['noiNhan'] ?? '',
      trangThai: parseInt(json['trangThai']),
      idCongTy: json['idCongTy'] ?? '',
      ngayTao: json['ngayTao']?.toString() ?? '',
      ngayCapNhat: json['ngayCapNhat']?.toString() ?? '',
      nguoiTao: json['nguoiTao'] ?? '',
      nguoiCapNhat: json['nguoiCapNhat'] ?? '',
      coHieuLuc: parseBool(json['coHieuLuc']),
      loai: parseInt(json['loai']),
      isActive: parseBool(json['isActive']),
      trichYeu: json['trichYeu'] ?? '',
      duongDanFile: json['duongDanFile'] ?? '',
      tenFile: json['tenFile'] ?? '',
      ngayKy: json['ngayKy']?.toString() ?? '',
      share: parseBool(json['share']),
      idNguoiKyNhay: json['idNguoiKyNhay'] ?? '',
      trangThaiKyNhay: parseBool(json['trangThaiKyNhay']),
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
      'tggnTuNgay': tggnTuNgay,
      'tggnDenNgay': tggnDenNgay,
      'idTruongPhongDonViGiao': idTruongPhongDonViGiao,
      'truongPhongDonViGiaoXacNhan': truongPhongDonViGiaoXacNhan,
      'idPhoPhongDonViGiao': idPhoPhongDonViGiao,
      'phoPhongDonViGiaoXacNhan': phoPhongDonViGiaoXacNhan,
      'idTrinhDuyetCapPhong': idTrinhDuyetCapPhong,
      'trinhDuyetCapPhongXacNhan': trinhDuyetCapPhongXacNhan,
      'idTrinhDuyetGiamDoc': idTrinhDuyetGiamDoc,
      'trinhDuyetGiamDocXacNhan': trinhDuyetGiamDocXacNhan,
      'diaDiemGiaoNhan': diaDiemGiaoNhan,
      'idPhongBanXemPhieu': idPhongBanXemPhieu,
      'idNhanSuXemPhieu': idNhanSuXemPhieu,
      'noiNhan': noiNhan,
      'trangThai': trangThai,
      'idCongTy': idCongTy,
      'ngayTao': ngayTao,
      'ngayCapNhat': ngayCapNhat,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'coHieuLuc': coHieuLuc,
      'loai': loai,
      'isActive': isActive,
      'trichYeu': trichYeu,
      'duongDanFile': duongDanFile,
      'tenFile': tenFile,
      'ngayKy': ngayKy,
      'share': share,
      'idNguoiKyNhay': idNguoiKyNhay,
      'trangThaiKyNhay': trangThaiKyNhay,
    };
  }

  LenhDieuDongRequest copyWith({
    String? id,
    String? soQuyetDinh,
    String? tenPhieu,
    String? idDonViGiao,
    String? idDonViNhan,
    String? idNguoiDeNghi,
    bool? nguoiLapPhieuKyNhay,
    bool? quanTrongCanXacNhan,
    bool? phoPhongXacNhan,
    String? idDonViDeNghi,
    String? tggnTuNgay,
    String? tggnDenNgay,
    String? idTruongPhongDonViGiao,
    bool? truongPhongDonViGiaoXacNhan,
    String? idPhoPhongDonViGiao,
    bool? phoPhongDonViGiaoXacNhan,
    String? idTrinhDuyetCapPhong,
    bool? trinhDuyetCapPhongXacNhan,
    String? idTrinhDuyetGiamDoc,
    bool? trinhDuyetGiamDocXacNhan,
    String? diaDiemGiaoNhan,
    String? idPhongBanXemPhieu,
    String? idNhanSuXemPhieu,
    String? noiNhan,
    int? trangThai,
    String? idCongTy,
    String? ngayTao,
    String? ngayCapNhat,
    String? nguoiTao,
    String? nguoiCapNhat,
    bool? coHieuLuc,
    int? loai,
    bool? isActive,
    String? trichYeu,
    String? duongDanFile,
    String? tenFile,
    String? ngayKy,
    bool? share,
    String? idNguoiKyNhay,
    bool? trangThaiKyNhay,
  }) {
    return LenhDieuDongRequest(
      id: id ?? this.id,
      soQuyetDinh: soQuyetDinh ?? this.soQuyetDinh,
      tenPhieu: tenPhieu ?? this.tenPhieu,
      idDonViGiao: idDonViGiao ?? this.idDonViGiao,
      idDonViNhan: idDonViNhan ?? this.idDonViNhan,
      idNguoiDeNghi: idNguoiDeNghi ?? this.idNguoiDeNghi,
      nguoiLapPhieuKyNhay: nguoiLapPhieuKyNhay ?? this.nguoiLapPhieuKyNhay,
      quanTrongCanXacNhan: quanTrongCanXacNhan ?? this.quanTrongCanXacNhan,
      phoPhongXacNhan: phoPhongXacNhan ?? this.phoPhongXacNhan,
      idDonViDeNghi: idDonViDeNghi ?? this.idDonViDeNghi,
      tggnTuNgay: tggnTuNgay ?? this.tggnTuNgay,
      tggnDenNgay: tggnDenNgay ?? this.tggnDenNgay,
      idTruongPhongDonViGiao: idTruongPhongDonViGiao ?? this.idTruongPhongDonViGiao,
      truongPhongDonViGiaoXacNhan: truongPhongDonViGiaoXacNhan ?? this.truongPhongDonViGiaoXacNhan,
      idPhoPhongDonViGiao: idPhoPhongDonViGiao ?? this.idPhoPhongDonViGiao,
      phoPhongDonViGiaoXacNhan: phoPhongDonViGiaoXacNhan ?? this.phoPhongDonViGiaoXacNhan,
      idTrinhDuyetCapPhong: idTrinhDuyetCapPhong ?? this.idTrinhDuyetCapPhong,
      trinhDuyetCapPhongXacNhan: trinhDuyetCapPhongXacNhan ?? this.trinhDuyetCapPhongXacNhan,
      idTrinhDuyetGiamDoc: idTrinhDuyetGiamDoc ?? this.idTrinhDuyetGiamDoc,
      trinhDuyetGiamDocXacNhan: trinhDuyetGiamDocXacNhan ?? this.trinhDuyetGiamDocXacNhan,
      diaDiemGiaoNhan: diaDiemGiaoNhan ?? this.diaDiemGiaoNhan,
      idPhongBanXemPhieu: idPhongBanXemPhieu ?? this.idPhongBanXemPhieu,
      idNhanSuXemPhieu: idNhanSuXemPhieu ?? this.idNhanSuXemPhieu,
      noiNhan: noiNhan ?? this.noiNhan,
      trangThai: trangThai ?? this.trangThai,
      idCongTy: idCongTy ?? this.idCongTy,
      ngayTao: ngayTao ?? this.ngayTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
      coHieuLuc: coHieuLuc ?? this.coHieuLuc,
      loai: loai ?? this.loai,
      isActive: isActive ?? this.isActive,
      trichYeu: trichYeu ?? this.trichYeu,
      duongDanFile: duongDanFile ?? this.duongDanFile,
      tenFile: tenFile ?? this.tenFile,
      ngayKy: ngayKy ?? this.ngayKy,
      share: share ?? this.share,
      idNguoiKyNhay: idNguoiKyNhay ?? this.idNguoiKyNhay,
      trangThaiKyNhay: trangThaiKyNhay ?? this.trangThaiKyNhay,
    );
  }
}
