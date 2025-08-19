import 'chi_tiet_dieu_dong_tai_san.dart';

class DieuDongTaiSanDto {
  String? id;
  String? soQuyetDinh;
  String? tenPhieu;

  // ID + tên đơn vị giao
  String? idDonViGiao;
  String? tenDonViGiao;

  // ID + tên đơn vị nhận
  String? idDonViNhan;
  String? tenDonViNhan;

  // ID + tên đơn vị đề nghị
  String? idDonViDeNghi;
  String? tenDonViDeNghi;

  // ID + tên phòng ban xem phiếu
  String? idPhongBanXemPhieu;
  String? tenPhongBanXemPhieu;

  // ID + tên người đề nghị
  String? idNguoiDeNghi;
  String? tenNguoiDeNghi;

  // ID + tên trình duyệt cấp phòng
  String? idTrinhDuyetCapPhong;
  String? tenTrinhDuyetCapPhong;

  // ID + tên trình duyệt giám đốc
  String? idTrinhDuyetGiamDoc;
  String? tenTrinhDuyetGiamDoc;

  // ID + tên nhân sự xem phiếu
  String? idNhanSuXemPhieu;
  String? tenNhanSuXemPhieu;

  bool? nguoiLapPhieuKyNhay;
  bool? quanTrongCanXacNhan;
  bool? phoPhongXacNhan;
  String? tggnTuNgay;
  String? tggnDenNgay;
  String? diaDiemGiaoNhan;
  String? veViec;
  String? canCu;
  String? dieu1;
  String? dieu2;
  String? dieu3;
  String? noiNhan;
  String? themDongTrong;
  int? trangThai;
  String? idCongTy;
  String? ngayTao;
  String? ngayCapNhat;
  String? nguoiTao;
  String? nguoiCapNhat;
  bool? coHieuLuc;
  int? loai;
  bool? isActive;
  String? trichYeu;
  String? duongDanFile;
  String? tenFile;
  String? ngayKy;
  List<ChiTietDieuDongTaiSan>? chiTietDieuDongTaiSans;

  DieuDongTaiSanDto({
    this.id,
    this.soQuyetDinh,
    this.tenPhieu,
    this.idDonViGiao,
    this.tenDonViGiao,
    this.idDonViNhan,
    this.tenDonViNhan,
    this.idDonViDeNghi,
    this.tenDonViDeNghi,
    this.idPhongBanXemPhieu,
    this.tenPhongBanXemPhieu,
    this.idNguoiDeNghi,
    this.tenNguoiDeNghi,
    this.idTrinhDuyetCapPhong,
    this.tenTrinhDuyetCapPhong,
    this.idTrinhDuyetGiamDoc,
    this.tenTrinhDuyetGiamDoc,
    this.idNhanSuXemPhieu,
    this.tenNhanSuXemPhieu,
    this.nguoiLapPhieuKyNhay,
    this.quanTrongCanXacNhan,
    this.phoPhongXacNhan,
    this.tggnTuNgay,
    this.tggnDenNgay,
    this.diaDiemGiaoNhan,
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
    this.chiTietDieuDongTaiSans
  });

  factory DieuDongTaiSanDto.fromJson(Map<String, dynamic> json) {
    return DieuDongTaiSanDto(
      id: json['id'],
      soQuyetDinh: json['soQuyetDinh'],
      tenPhieu: json['tenPhieu'],
      idDonViGiao: json['idDonViGiao'],
      tenDonViGiao: json['tenDonViGiao'],
      idDonViNhan: json['idDonViNhan'],
      tenDonViNhan: json['tenDonViNhan'],
      idDonViDeNghi: json['idDonViDeNghi'],
      tenDonViDeNghi: json['tenDonViDeNghi'],
      idPhongBanXemPhieu: json['idPhongBanXemPhieu'],
      tenPhongBanXemPhieu: json['tenPhongBanXemPhieu'],
      idNguoiDeNghi: json['idNguoiDeNghi'],
      tenNguoiDeNghi: json['tenNguoiDeNghi'],
      idTrinhDuyetCapPhong: json['idTrinhDuyetCapPhong'],
      tenTrinhDuyetCapPhong: json['tenTrinhDuyetCapPhong'],
      idTrinhDuyetGiamDoc: json['idTrinhDuyetGiamDoc'],
      tenTrinhDuyetGiamDoc: json['tenTrinhDuyetGiamDoc'],
      idNhanSuXemPhieu: json['idNhanSuXemPhieu'],
      tenNhanSuXemPhieu: json['tenNhanSuXemPhieu'],
      nguoiLapPhieuKyNhay: json['nguoiLapPhieuKyNhay'],
      quanTrongCanXacNhan: json['quanTrongCanXacNhan'],
      phoPhongXacNhan: json['phoPhongXacNhan'],
      tggnTuNgay: json['tggnTuNgay'],
      tggnDenNgay: json['tggnDenNgay'],
      diaDiemGiaoNhan: json['diaDiemGiaoNhan'],
      veViec: json['veViec'],
      canCu: json['canCu'],
      dieu1: json['dieu1'],
      dieu2: json['dieu2'],
      dieu3: json['dieu3'],
      noiNhan: json['noiNhan'],
      themDongTrong: json['themDongTrong'],
      trangThai: json['trangThai'],
      idCongTy: json['idCongTy'],
      ngayTao: json['ngayTao'],
      ngayCapNhat: json['ngayCapNhat'],
      nguoiTao: json['nguoiTao'],
      nguoiCapNhat: json['nguoiCapNhat'],
      coHieuLuc: json['coHieuLuc'],
      loai: json['loai'],
      isActive: json['isActive'],
      trichYeu: json['trichYeu'],
      duongDanFile: json['duongDanFile'],
      tenFile: json['tenFile'],
      ngayKy: json['ngayKy'],
      chiTietDieuDongTaiSans: json['chiTietDieuDongTaiSans'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "soQuyetDinh": soQuyetDinh,
      "tenPhieu": tenPhieu,
      "idDonViGiao": idDonViGiao,
      "tenDonViGiao": tenDonViGiao,
      "idDonViNhan": idDonViNhan,
      "tenDonViNhan": tenDonViNhan,
      "idDonViDeNghi": idDonViDeNghi,
      "tenDonViDeNghi": tenDonViDeNghi,
      "idPhongBanXemPhieu": idPhongBanXemPhieu,
      "tenPhongBanXemPhieu": tenPhongBanXemPhieu,
      "idNguoiDeNghi": idNguoiDeNghi,
      "tenNguoiDeNghi": tenNguoiDeNghi,
      "idTrinhDuyetCapPhong": idTrinhDuyetCapPhong,
      "tenTrinhDuyetCapPhong": tenTrinhDuyetCapPhong,
      "idTrinhDuyetGiamDoc": idTrinhDuyetGiamDoc,
      "tenTrinhDuyetGiamDoc": tenTrinhDuyetGiamDoc,
      "idNhanSuXemPhieu": idNhanSuXemPhieu,
      "tenNhanSuXemPhieu": tenNhanSuXemPhieu,
      "nguoiLapPhieuKyNhay": nguoiLapPhieuKyNhay,
      "quanTrongCanXacNhan": quanTrongCanXacNhan,
      "phoPhongXacNhan": phoPhongXacNhan,
      "tggnTuNgay": tggnTuNgay,
      "tggnDenNgay": tggnDenNgay,
      "diaDiemGiaoNhan": diaDiemGiaoNhan,
      "veViec": veViec,
      "canCu": canCu,
      "dieu1": dieu1,
      "dieu2": dieu2,
      "dieu3": dieu3,
      "noiNhan": noiNhan,
      "themDongTrong": themDongTrong,
      "trangThai": trangThai,
      "idCongTy": idCongTy,
      "ngayTao": ngayTao,
      "ngayCapNhat": ngayCapNhat,
      "nguoiTao": nguoiTao,
      "nguoiCapNhat": nguoiCapNhat,
      "coHieuLuc": coHieuLuc,
      "loai": loai,
      "isActive": isActive,
      "trichYeu": trichYeu,
      "duongDanFile": duongDanFile,
      "tenFile": tenFile,
      "ngayKy": ngayKy,
      "chiTietDieuDongTaiSans": chiTietDieuDongTaiSans,
    };
  }
}
