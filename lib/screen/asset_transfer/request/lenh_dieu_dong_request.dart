class LenhDieuDongRequest {
  final String id;
  final String soQuyetDinh;
  final String tenPhieu;
  final String idDonViGiao;
  final String idDonViNhan;
  final String idNguoiKyNhay;
  final bool trangThaiKyNhay;
  final bool nguoiLapPhieuKyNhay;
  final String idDonViDeNghi;
  final String tgGnTuNgay;
  final String tgGnDenNgay;
  final String idTrinhDuyetCapPhong;
  final bool trinhDuyetCapPhongXacNhan;
  final String idTrinhDuyetGiamDoc;
  final bool trinhDuyetGiamDocXacNhan;
  final String diaDiemGiaoNhan;
  final String idPhongBanXemPhieu;
  final String noiNhan;
  final int trangThai;
  final String idCongTy;
  final String ngayTao;
  final String ngayCapNhat;
  final String nguoiTao;
  final String nguoiCapNhat;
  final int coHieuLuc;
  final int loai;
  final bool share;
  final String trichYeu;
  final String duongDanFile;
  final String tenFile;
  final String ngayKy;
  final bool daBanGiao;
  final bool byStep;

  LenhDieuDongRequest({
    this.id = '',
    required this.soQuyetDinh,
    required this.tenPhieu,
    required this.idDonViGiao,
    required this.idDonViNhan,
    required this.idNguoiKyNhay,
    required this.trangThaiKyNhay,
    required this.nguoiLapPhieuKyNhay,
    required this.idDonViDeNghi,
    required this.tgGnTuNgay,
    required this.tgGnDenNgay,
    required this.idTrinhDuyetCapPhong,
    required this.trinhDuyetCapPhongXacNhan,
    required this.idTrinhDuyetGiamDoc,
    required this.trinhDuyetGiamDocXacNhan,
    required this.diaDiemGiaoNhan,
    required this.idPhongBanXemPhieu,
    required this.noiNhan,
    required this.trangThai,
    required this.idCongTy,
    required this.ngayTao,
    required this.ngayCapNhat,
    required this.nguoiTao,
    required this.nguoiCapNhat,
    required this.coHieuLuc,
    required this.loai,
    required this.share,
    required this.trichYeu,
    required this.duongDanFile,
    required this.tenFile,
    required this.ngayKy,
    required this.daBanGiao,
    required this.byStep,
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
      idNguoiKyNhay: json['idNguoiKyNhay'] ?? '',
      trangThaiKyNhay: parseBool(json['trangThaiKyNhay']),
      nguoiLapPhieuKyNhay: parseBool(json['nguoiLapPhieuKyNhay']),
      idDonViDeNghi: json['idDonViDeNghi'] ?? '',
      tgGnTuNgay: json['tgGnTuNgay']?.toString() ?? '',
      tgGnDenNgay: json['tgGnDenNgay']?.toString() ?? '',
      idTrinhDuyetCapPhong: json['idTrinhDuyetCapPhong'] ?? '',
      trinhDuyetCapPhongXacNhan: parseBool(json['trinhDuyetCapPhongXacNhan']),
      idTrinhDuyetGiamDoc: json['idTrinhDuyetGiamDoc'] ?? '',
      trinhDuyetGiamDocXacNhan: parseBool(json['trinhDuyetGiamDocXacNhan']),
      diaDiemGiaoNhan: json['diaDiemGiaoNhan'] ?? '',
      idPhongBanXemPhieu: json['idPhongBanXemPhieu'] ?? '',
      noiNhan: json['noiNhan'] ?? '',
      trangThai: parseInt(json['trangThai']),
      idCongTy: json['idCongTy'] ?? '',
      ngayTao: json['ngayTao']?.toString() ?? '',
      ngayCapNhat: json['ngayCapNhat']?.toString() ?? '',
      nguoiTao: json['nguoiTao'] ?? '',
      nguoiCapNhat: json['nguoiCapNhat'] ?? '',
      coHieuLuc: parseInt(json['coHieuLuc']),
      loai: parseInt(json['loai']),
      share: parseBool(json['share']),
      trichYeu: json['trichYeu'] ?? '',
      duongDanFile: json['duongDanFile'] ?? '',
      tenFile: json['tenFile'] ?? '',
      ngayKy: json['ngayKy']?.toString() ?? '',
      daBanGiao: parseBool(json['daBanGiao']),
      byStep: parseBool(json['byStep']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'soQuyetDinh': soQuyetDinh,
      'tenPhieu': tenPhieu,
      'idDonViGiao': idDonViGiao,
      'idDonViNhan': idDonViNhan,
      'idNguoiKyNhay': idNguoiKyNhay,
      'trangThaiKyNhay': trangThaiKyNhay,
      'nguoiLapPhieuKyNhay': nguoiLapPhieuKyNhay,
      'idDonViDeNghi': idDonViDeNghi,
      'tgGnTuNgay': tgGnTuNgay,
      'tgGnDenNgay': tgGnDenNgay,
      'idTrinhDuyetCapPhong': idTrinhDuyetCapPhong,
      'trinhDuyetCapPhongXacNhan': trinhDuyetCapPhongXacNhan,
      'idTrinhDuyetGiamDoc': idTrinhDuyetGiamDoc,
      'trinhDuyetGiamDocXacNhan': trinhDuyetGiamDocXacNhan,
      'diaDiemGiaoNhan': diaDiemGiaoNhan,
      'idPhongBanXemPhieu': idPhongBanXemPhieu,
      'noiNhan': noiNhan,
      'trangThai': trangThai,
      'idCongTy': idCongTy,
      'ngayTao': ngayTao,
      'ngayCapNhat': ngayCapNhat,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'coHieuLuc': coHieuLuc,
      'loai': loai,
      'share': share,
      'trichYeu': trichYeu,
      'duongDanFile': duongDanFile,
      'tenFile': tenFile,
      'ngayKy': ngayKy,
      'daBanGiao': daBanGiao,
      'byStep': byStep,
    };
  }

  LenhDieuDongRequest copyWith({
    String? id,
    String? soQuyetDinh,
    String? tenPhieu,
    String? idDonViGiao,
    String? idDonViNhan,
    String? idNguoiKyNhay,
    bool? trangThaiKyNhay,
    bool? nguoiLapPhieuKyNhay,
    String? idDonViDeNghi,
    String? tgGnTuNgay,
    String? tgGnDenNgay,
    String? idTrinhDuyetCapPhong,
    bool? trinhDuyetCapPhongXacNhan,
    String? idTrinhDuyetGiamDoc,
    bool? trinhDuyetGiamDocXacNhan,
    String? diaDiemGiaoNhan,
    String? idPhongBanXemPhieu,
    String? noiNhan,
    int? trangThai,
    String? idCongTy,
    String? ngayTao,
    String? ngayCapNhat,
    String? nguoiTao,
    String? nguoiCapNhat,
    int? coHieuLuc,
    int? loai,
    bool? share,
    String? trichYeu,
    String? duongDanFile,
    String? tenFile,
    String? ngayKy,
    bool? daBanGiao,
    bool? byStep,
  }) {
    return LenhDieuDongRequest(
      id: id ?? this.id,
      soQuyetDinh: soQuyetDinh ?? this.soQuyetDinh,
      tenPhieu: tenPhieu ?? this.tenPhieu,
      idDonViGiao: idDonViGiao ?? this.idDonViGiao,
      idDonViNhan: idDonViNhan ?? this.idDonViNhan,
      idNguoiKyNhay: idNguoiKyNhay ?? this.idNguoiKyNhay,
      trangThaiKyNhay: trangThaiKyNhay ?? this.trangThaiKyNhay,
      nguoiLapPhieuKyNhay: nguoiLapPhieuKyNhay ?? this.nguoiLapPhieuKyNhay,
      idDonViDeNghi: idDonViDeNghi ?? this.idDonViDeNghi,
      tgGnTuNgay: tgGnTuNgay ?? this.tgGnTuNgay,
      tgGnDenNgay: tgGnDenNgay ?? this.tgGnDenNgay,
      idTrinhDuyetCapPhong: idTrinhDuyetCapPhong ?? this.idTrinhDuyetCapPhong,
      trinhDuyetCapPhongXacNhan: trinhDuyetCapPhongXacNhan ?? this.trinhDuyetCapPhongXacNhan,
      idTrinhDuyetGiamDoc: idTrinhDuyetGiamDoc ?? this.idTrinhDuyetGiamDoc,
      trinhDuyetGiamDocXacNhan: trinhDuyetGiamDocXacNhan ?? this.trinhDuyetGiamDocXacNhan,
      diaDiemGiaoNhan: diaDiemGiaoNhan ?? this.diaDiemGiaoNhan,
      idPhongBanXemPhieu: idPhongBanXemPhieu ?? this.idPhongBanXemPhieu,
      noiNhan: noiNhan ?? this.noiNhan,
      trangThai: trangThai ?? this.trangThai,
      idCongTy: idCongTy ?? this.idCongTy,
      ngayTao: ngayTao ?? this.ngayTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
      coHieuLuc: coHieuLuc ?? this.coHieuLuc,
      loai: loai ?? this.loai,
      share: share ?? this.share,
      trichYeu: trichYeu ?? this.trichYeu,
      duongDanFile: duongDanFile ?? this.duongDanFile,
      tenFile: tenFile ?? this.tenFile,
      ngayKy: ngayKy ?? this.ngayKy,
      daBanGiao: daBanGiao ?? this.daBanGiao,
      byStep: byStep ?? this.byStep,
    );
  }
}
