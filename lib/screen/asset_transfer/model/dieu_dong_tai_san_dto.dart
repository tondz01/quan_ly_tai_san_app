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

  // ID + tên trưởng phòng đơn vị giao
  String? idTruongPhongDonViGiao;
  String? tenTruongPhongDonViGiao;

  // ID + tên phó phòng đơn vị giao
  String? idPhoPhongDonViGiao;
  String? tenPhoPhongDonViGiao;

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
  
  // Các trường xác nhận
  bool? truongPhongDonViGiaoXacNhan;
  bool? phoPhongDonViGiaoXacNhan;
  bool? trinhDuyetCapPhongXacNhan;
  bool? trinhDuyetGiamDocXacNhan;
  
  String? tggnTuNgay;
  String? tggnDenNgay;
  String? diaDiemGiaoNhan;
  String? noiNhan;
  String? trichYeu;
  String? duongDanFile;
  String? tenFile;
  String? ngayKy;
  int? trangThai;
  String? idCongTy;
  String? ngayTao;
  String? ngayCapNhat;
  String? nguoiTao;
  String? nguoiCapNhat;
  bool? coHieuLuc;
  int? loai;
  bool? isActive;
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
    this.idTruongPhongDonViGiao,
    this.tenTruongPhongDonViGiao,
    this.idPhoPhongDonViGiao,
    this.tenPhoPhongDonViGiao,
    this.idTrinhDuyetCapPhong,
    this.tenTrinhDuyetCapPhong,
    this.idTrinhDuyetGiamDoc,
    this.tenTrinhDuyetGiamDoc,
    this.idNhanSuXemPhieu,
    this.tenNhanSuXemPhieu,
    this.nguoiLapPhieuKyNhay,
    this.quanTrongCanXacNhan,
    this.phoPhongXacNhan,
    this.truongPhongDonViGiaoXacNhan,
    this.phoPhongDonViGiaoXacNhan,
    this.trinhDuyetCapPhongXacNhan,
    this.trinhDuyetGiamDocXacNhan,
    this.tggnTuNgay,
    this.tggnDenNgay,
    this.diaDiemGiaoNhan,
    this.noiNhan,
    this.trichYeu,
    this.duongDanFile,
    this.tenFile,
    this.ngayKy,
    this.trangThai,
    this.idCongTy,
    this.ngayTao,
    this.ngayCapNhat,
    this.nguoiTao,
    this.nguoiCapNhat,
    this.coHieuLuc,
    this.loai,
    this.isActive,
    this.chiTietDieuDongTaiSans,
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
      idTruongPhongDonViGiao: json['idTruongPhongDonViGiao'],
      tenTruongPhongDonViGiao: json['tenTruongPhongDonViGiao'],
      idPhoPhongDonViGiao: json['idPhoPhongDonViGiao'],
      tenPhoPhongDonViGiao: json['tenPhoPhongDonViGiao'],
      idTrinhDuyetCapPhong: json['idTrinhDuyetCapPhong'],
      tenTrinhDuyetCapPhong: json['tenTrinhDuyetCapPhong'],
      idTrinhDuyetGiamDoc: json['idTrinhDuyetGiamDoc'],
      tenTrinhDuyetGiamDoc: json['tenTrinhDuyetGiamDoc'],
      idNhanSuXemPhieu: json['idNhanSuXemPhieu'],
      tenNhanSuXemPhieu: json['tenNhanSuXemPhieu'],
      nguoiLapPhieuKyNhay: json['nguoiLapPhieuKyNhay'],
      quanTrongCanXacNhan: json['quanTrongCanXacNhan'],
      phoPhongXacNhan: json['phoPhongXacNhan'],
      truongPhongDonViGiaoXacNhan: json['truongPhongDonViGiaoXacNhan'],
      phoPhongDonViGiaoXacNhan: json['phoPhongDonViGiaoXacNhan'],
      trinhDuyetCapPhongXacNhan: json['trinhDuyetCapPhongXacNhan'],
      trinhDuyetGiamDocXacNhan: json['trinhDuyetGiamDocXacNhan'],
      tggnTuNgay: json['tggnTuNgay'],
      tggnDenNgay: json['tggnDenNgay'],
      diaDiemGiaoNhan: json['diaDiemGiaoNhan'],
      noiNhan: json['noiNhan'],
      trichYeu: json['trichYeu'],
      duongDanFile: json['duongDanFile'],
      tenFile: json['tenFile'],
      ngayKy: json['ngayKy'],
      trangThai: json['trangThai'],
      idCongTy: json['idCongTy'],
      ngayTao: json['ngayTao'],
      ngayCapNhat: json['ngayCapNhat'],
      nguoiTao: json['nguoiTao'],
      nguoiCapNhat: json['nguoiCapNhat'],
      coHieuLuc: json['coHieuLuc'],
      loai: json['loai'],
      isActive: json['isActive'],
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
      "idTruongPhongDonViGiao": idTruongPhongDonViGiao,
      "tenTruongPhongDonViGiao": tenTruongPhongDonViGiao,
      "idPhoPhongDonViGiao": idPhoPhongDonViGiao,
      "tenPhoPhongDonViGiao": tenPhoPhongDonViGiao,
      "idTrinhDuyetCapPhong": idTrinhDuyetCapPhong,
      "tenTrinhDuyetCapPhong": tenTrinhDuyetCapPhong,
      "idTrinhDuyetGiamDoc": idTrinhDuyetGiamDoc,
      "tenTrinhDuyetGiamDoc": tenTrinhDuyetGiamDoc,
      "idNhanSuXemPhieu": idNhanSuXemPhieu,
      "tenNhanSuXemPhieu": tenNhanSuXemPhieu,
      "nguoiLapPhieuKyNhay": nguoiLapPhieuKyNhay,
      "quanTrongCanXacNhan": quanTrongCanXacNhan,
      "phoPhongXacNhan": phoPhongXacNhan,
      "truongPhongDonViGiaoXacNhan": truongPhongDonViGiaoXacNhan,
      "phoPhongDonViGiaoXacNhan": phoPhongDonViGiaoXacNhan,
      "trinhDuyetCapPhongXacNhan": trinhDuyetCapPhongXacNhan,
      "trinhDuyetGiamDocXacNhan": trinhDuyetGiamDocXacNhan,
      "tggnTuNgay": tggnTuNgay,
      "tggnDenNgay": tggnDenNgay,
      "diaDiemGiaoNhan": diaDiemGiaoNhan,
      "noiNhan": noiNhan,
      "trichYeu": trichYeu,
      "duongDanFile": duongDanFile,
      "tenFile": tenFile,
      "ngayKy": ngayKy,
      "trangThai": trangThai,
      "idCongTy": idCongTy,
      "ngayTao": ngayTao,
      "ngayCapNhat": ngayCapNhat,
      "nguoiTao": nguoiTao,
      "nguoiCapNhat": nguoiCapNhat,
      "coHieuLuc": coHieuLuc,
      "loai": loai,
      "isActive": isActive,
      "chiTietDieuDongTaiSans": chiTietDieuDongTaiSans,
    };
  }
}
