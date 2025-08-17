import 'detail_tool_and_material_transfer_dto.dart';

class ToolAndMaterialTransferDto {
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
  
  // Thời gian giao nhận
  String? tggnTuNgay;
  String? tggnDenNgay;
  
  String? diaDiemGiaoNhan;
  String? noiNhan;
  
  int? trangThai;
  String? idCongTy;
  
  String? ngayTao;
  String? ngayCapNhat;
  
  String? nguoiTao;
  String? nguoiCapNhat;
  
  bool? coHieuLuc;
  int? loai;
  bool? isActive;
  
  // Các trường không có trong Java nhưng có trong model cũ
  String? veViec;
  String? canCu;
  String? dieu1;
  String? dieu2;
  String? dieu3;
  String? themDongTrong;
  String? trichYeu;
  String? duongDanFile;
  String? tenFile;
  String? ngayKy;
  
  List<DetailToolAndMaterialTransferDto>? detailToolAndMaterialTransfers;

  ToolAndMaterialTransferDto({
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
    this.detailToolAndMaterialTransfers
  });

  factory ToolAndMaterialTransferDto.fromJson(Map<String, dynamic> json) {

    // Parse các danh sách chi tiết nếu có
    List<DetailToolAndMaterialTransferDto>? parseDetails(dynamic details) {
      if (details == null) return null;
      if (details is List) {
        return details
            .map((item) => DetailToolAndMaterialTransferDto.fromJson(item))
            .toList();
      }
      return null;
    }

    return ToolAndMaterialTransferDto(
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
      detailToolAndMaterialTransfers: parseDetails(json['chiTietToolAndMaterialTransfers']),
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
      "chiTietToolAndMaterialTransfers": detailToolAndMaterialTransfers?.map((detail) => detail.toJson()).toList(),
    };
  }
  
  // Tạo một instance rỗng cho việc khởi tạo mới
  factory ToolAndMaterialTransferDto.empty() {
    return ToolAndMaterialTransferDto(
      id: null,
      soQuyetDinh: '',
      tenPhieu: '',
      idDonViGiao: '',
      tenDonViGiao: '',
      idDonViNhan: '',
      tenDonViNhan: '',
      idDonViDeNghi: '',
      tenDonViDeNghi: '',
      idPhongBanXemPhieu: '',
      tenPhongBanXemPhieu: '',
      idNguoiDeNghi: '',
      tenNguoiDeNghi: '',
      idTrinhDuyetCapPhong: '',
      tenTrinhDuyetCapPhong: '',
      idTrinhDuyetGiamDoc: '',
      tenTrinhDuyetGiamDoc: '',
      idNhanSuXemPhieu: '',
      tenNhanSuXemPhieu: '',
      nguoiLapPhieuKyNhay: false,
      quanTrongCanXacNhan: false,
      phoPhongXacNhan: false,
      tggnTuNgay: DateTime.now().toIso8601String(),
      tggnDenNgay: DateTime.now().add(const Duration(days: 1)).toIso8601String(),
      diaDiemGiaoNhan: '',
      veViec: '',
      canCu: '',
      dieu1: '',
      dieu2: '',
      dieu3: '',
      noiNhan: '',
      themDongTrong: '',
      trangThai: 0,
      idCongTy: '',
      ngayTao: DateTime.now().toIso8601String(),
      ngayCapNhat: null,
      nguoiTao: '',
      nguoiCapNhat: '',
      coHieuLuc: true,
      loai: 0,
      isActive: true,
      trichYeu: '',
      duongDanFile: '',
      tenFile: '',
      ngayKy: '',
      detailToolAndMaterialTransfers: [],
    );
  }

  // Tạo một bản sao với các giá trị mới
  ToolAndMaterialTransferDto copyWith({
    String? id,
    String? soQuyetDinh,
    String? tenPhieu,
    String? idDonViGiao,
    String? tenDonViGiao,
    String? idDonViNhan,
    String? tenDonViNhan,
    String? idDonViDeNghi,
    String? tenDonViDeNghi,
    String? idPhongBanXemPhieu,
    String? tenPhongBanXemPhieu,
    String? idNguoiDeNghi,
    String? tenNguoiDeNghi,
    String? idTrinhDuyetCapPhong,
    String? tenTrinhDuyetCapPhong,
    String? idTrinhDuyetGiamDoc,
    String? tenTrinhDuyetGiamDoc,
    String? idNhanSuXemPhieu,
    String? tenNhanSuXemPhieu,
    bool? nguoiLapPhieuKyNhay,
    bool? quanTrongCanXacNhan,
    bool? phoPhongXacNhan,
    String? tggnTuNgay,
    String? tggnDenNgay,
    String? diaDiemGiaoNhan,
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
    String? trichYeu,
    String? duongDanFile,
    String? tenFile,
    String? ngayKy,
    List<DetailToolAndMaterialTransferDto>? detailToolAndMaterialTransfers,
  }) {
    return ToolAndMaterialTransferDto(
      id: id ?? this.id,
      soQuyetDinh: soQuyetDinh ?? this.soQuyetDinh,
      tenPhieu: tenPhieu ?? this.tenPhieu,
      idDonViGiao: idDonViGiao ?? this.idDonViGiao,
      tenDonViGiao: tenDonViGiao ?? this.tenDonViGiao,
      idDonViNhan: idDonViNhan ?? this.idDonViNhan,
      tenDonViNhan: tenDonViNhan ?? this.tenDonViNhan,
      idDonViDeNghi: idDonViDeNghi ?? this.idDonViDeNghi,
      tenDonViDeNghi: tenDonViDeNghi ?? this.tenDonViDeNghi,
      idPhongBanXemPhieu: idPhongBanXemPhieu ?? this.idPhongBanXemPhieu,
      tenPhongBanXemPhieu: tenPhongBanXemPhieu ?? this.tenPhongBanXemPhieu,
      idNguoiDeNghi: idNguoiDeNghi ?? this.idNguoiDeNghi,
      tenNguoiDeNghi: tenNguoiDeNghi ?? this.tenNguoiDeNghi,
      idTrinhDuyetCapPhong: idTrinhDuyetCapPhong ?? this.idTrinhDuyetCapPhong,
      tenTrinhDuyetCapPhong: tenTrinhDuyetCapPhong ?? this.tenTrinhDuyetCapPhong,
      idTrinhDuyetGiamDoc: idTrinhDuyetGiamDoc ?? this.idTrinhDuyetGiamDoc,
      tenTrinhDuyetGiamDoc: tenTrinhDuyetGiamDoc ?? this.tenTrinhDuyetGiamDoc,
      idNhanSuXemPhieu: idNhanSuXemPhieu ?? this.idNhanSuXemPhieu,
      tenNhanSuXemPhieu: tenNhanSuXemPhieu ?? this.tenNhanSuXemPhieu,
      nguoiLapPhieuKyNhay: nguoiLapPhieuKyNhay ?? this.nguoiLapPhieuKyNhay,
      quanTrongCanXacNhan: quanTrongCanXacNhan ?? this.quanTrongCanXacNhan,
      phoPhongXacNhan: phoPhongXacNhan ?? this.phoPhongXacNhan,
      tggnTuNgay: tggnTuNgay ?? this.tggnTuNgay,
      tggnDenNgay: tggnDenNgay ?? this.tggnDenNgay,
      diaDiemGiaoNhan: diaDiemGiaoNhan ?? this.diaDiemGiaoNhan,
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
      trichYeu: trichYeu ?? this.trichYeu,
      duongDanFile: duongDanFile ?? this.duongDanFile,
      tenFile: tenFile ?? this.tenFile,
      ngayKy: ngayKy ?? this.ngayKy,
      detailToolAndMaterialTransfers: detailToolAndMaterialTransfers ?? this.detailToolAndMaterialTransfers,
    );
  }
  
}
