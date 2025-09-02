import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';

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

  String? idNguoiKyNhay;
  bool? trangThaiKyNhay;

  // Các trường xác nhận
  bool? nguoiLapPhieuKyNhay;
  bool? quanTrongCanXacNhan;
  bool? phoPhongXacNhan;
  bool? truongPhongDonViGiaoXacNhan;
  bool? phoPhongDonViGiaoXacNhan;
  bool? trinhDuyetCapPhongXacNhan;
  bool? trinhDuyetGiamDocXacNhan;
  
  // Thời gian giao nhận
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
  bool? share;
  bool? isActive;
  
  List<DetailToolAndMaterialTransferDto>? detailToolAndMaterialTransfers;
  List<SignatoryDto>? listSignatory;

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
    this.idNguoiKyNhay,
    this.trangThaiKyNhay,
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
    this.share,
    this.isActive,
    this.detailToolAndMaterialTransfers,
    this.listSignatory,
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

    List<SignatoryDto>? parseSignatory(dynamic signatory) {

      if (signatory == null) return null;
      if (signatory is List) {
        return signatory.map((item) => SignatoryDto.fromJson(item)).toList();
      }
      return [];
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
      idNguoiKyNhay: json['idNguoiKyNhay'],
      trangThaiKyNhay: json['trangThaiKyNhay'],
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
      share: json['share'],
      isActive: json['isActive'],
      detailToolAndMaterialTransfers: parseDetails(json['chiTietToolAndMaterialTransfers']),
      listSignatory: parseSignatory(json['listSignatory']),
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
      "idNguoiKyNhay": idNguoiKyNhay,
      "trangThaiKyNhay": trangThaiKyNhay,
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
      "share": share,
      "isActive": isActive,
      "chiTietToolAndMaterialTransfers": detailToolAndMaterialTransfers?.map((detail) => detail.toJson()).toList(),
      "listSignatory": listSignatory?.map((signatory) => signatory.toJson()).toList(),
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
      idTruongPhongDonViGiao: '',
      tenTruongPhongDonViGiao: '',
      idPhoPhongDonViGiao: '',
      tenPhoPhongDonViGiao: '',
      idTrinhDuyetCapPhong: '',
      tenTrinhDuyetCapPhong: '',
      idTrinhDuyetGiamDoc: '',
      tenTrinhDuyetGiamDoc: '',
      idNhanSuXemPhieu: '',
      tenNhanSuXemPhieu: '',
      idNguoiKyNhay: '',
      trangThaiKyNhay: false,
      nguoiLapPhieuKyNhay: false,
      quanTrongCanXacNhan: false,
      phoPhongXacNhan: false,
      truongPhongDonViGiaoXacNhan: false,
      phoPhongDonViGiaoXacNhan: false,
      trinhDuyetCapPhongXacNhan: false,
      trinhDuyetGiamDocXacNhan: false,
      tggnTuNgay: DateTime.now().toIso8601String(),
      tggnDenNgay: DateTime.now().add(const Duration(days: 1)).toIso8601String(),
      diaDiemGiaoNhan: '',
      noiNhan: '',
      trichYeu: '',
      duongDanFile: '',
      tenFile: '',
      ngayKy: '',
      trangThai: 0,
      idCongTy: '',
      ngayTao: DateTime.now().toIso8601String(),
      ngayCapNhat: null,
      nguoiTao: '',
      nguoiCapNhat: '',
      coHieuLuc: true,
      loai: 0,
      isActive: true,
      detailToolAndMaterialTransfers: [],
      listSignatory: [],
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
    String? idTruongPhongDonViGiao,
    String? tenTruongPhongDonViGiao,
    String? idPhoPhongDonViGiao,
    String? tenPhoPhongDonViGiao,
    String? idTrinhDuyetCapPhong,
    String? tenTrinhDuyetCapPhong,
    String? idTrinhDuyetGiamDoc,
    String? tenTrinhDuyetGiamDoc,
    String? idNhanSuXemPhieu,
    String? tenNhanSuXemPhieu,
    String? idNguoiKyNhay,
    bool? trangThaiKyNhay,
    bool? nguoiLapPhieuKyNhay,
    bool? quanTrongCanXacNhan,
    bool? phoPhongXacNhan,
    bool? truongPhongDonViGiaoXacNhan,
    bool? phoPhongDonViGiaoXacNhan,
    bool? trinhDuyetCapPhongXacNhan,
    bool? trinhDuyetGiamDocXacNhan,
    String? tggnTuNgay,
    String? tggnDenNgay,
    String? diaDiemGiaoNhan,
    String? noiNhan,
    String? trichYeu,
    String? duongDanFile,
    String? tenFile,
    String? ngayKy,
    int? trangThai,
    String? idCongTy,
    String? ngayTao,
    String? ngayCapNhat,
    String? nguoiTao,
    String? nguoiCapNhat,
    bool? coHieuLuc,
    int? loai,
    bool? share,
    bool? isActive,
    List<DetailToolAndMaterialTransferDto>? detailToolAndMaterialTransfers,
    List<SignatoryDto>? listSignatory,
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
      idTruongPhongDonViGiao: idTruongPhongDonViGiao ?? this.idTruongPhongDonViGiao,
      tenTruongPhongDonViGiao: tenTruongPhongDonViGiao ?? this.tenTruongPhongDonViGiao,
      idPhoPhongDonViGiao: idPhoPhongDonViGiao ?? this.idPhoPhongDonViGiao,
      tenPhoPhongDonViGiao: tenPhoPhongDonViGiao ?? this.tenPhoPhongDonViGiao,
      idTrinhDuyetCapPhong: idTrinhDuyetCapPhong ?? this.idTrinhDuyetCapPhong,
      tenTrinhDuyetCapPhong: tenTrinhDuyetCapPhong ?? this.tenTrinhDuyetCapPhong,
      idTrinhDuyetGiamDoc: idTrinhDuyetGiamDoc ?? this.idTrinhDuyetGiamDoc,
      tenTrinhDuyetGiamDoc: tenTrinhDuyetGiamDoc ?? this.tenTrinhDuyetGiamDoc,
      idNhanSuXemPhieu: idNhanSuXemPhieu ?? this.idNhanSuXemPhieu,
      tenNhanSuXemPhieu: tenNhanSuXemPhieu ?? this.tenNhanSuXemPhieu,
      idNguoiKyNhay: idNguoiKyNhay ?? this.idNguoiKyNhay,
      trangThaiKyNhay: trangThaiKyNhay ?? this.trangThaiKyNhay,
      nguoiLapPhieuKyNhay: nguoiLapPhieuKyNhay ?? this.nguoiLapPhieuKyNhay,
      quanTrongCanXacNhan: quanTrongCanXacNhan ?? this.quanTrongCanXacNhan,
      phoPhongXacNhan: phoPhongXacNhan ?? this.phoPhongXacNhan,
      truongPhongDonViGiaoXacNhan: truongPhongDonViGiaoXacNhan ?? this.truongPhongDonViGiaoXacNhan,
      phoPhongDonViGiaoXacNhan: phoPhongDonViGiaoXacNhan ?? this.phoPhongDonViGiaoXacNhan,
      trinhDuyetCapPhongXacNhan: trinhDuyetCapPhongXacNhan ?? this.trinhDuyetCapPhongXacNhan,
      trinhDuyetGiamDocXacNhan: trinhDuyetGiamDocXacNhan ?? this.trinhDuyetGiamDocXacNhan,
      tggnTuNgay: tggnTuNgay ?? this.tggnTuNgay,
      tggnDenNgay: tggnDenNgay ?? this.tggnDenNgay,
      diaDiemGiaoNhan: diaDiemGiaoNhan ?? this.diaDiemGiaoNhan,
      noiNhan: noiNhan ?? this.noiNhan,
      trichYeu: trichYeu ?? this.trichYeu,
      duongDanFile: duongDanFile ?? this.duongDanFile,
      tenFile: tenFile ?? this.tenFile,
      ngayKy: ngayKy ?? this.ngayKy,
      trangThai: trangThai ?? this.trangThai,
      idCongTy: idCongTy ?? this.idCongTy,
      ngayTao: ngayTao ?? this.ngayTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
      coHieuLuc: coHieuLuc ?? this.coHieuLuc,
      loai: loai ?? this.loai,
      share: share ?? this.share,
      isActive: isActive ?? this.isActive,
      detailToolAndMaterialTransfers: detailToolAndMaterialTransfers ?? this.detailToolAndMaterialTransfers,
      listSignatory: listSignatory ?? this.listSignatory,
    );
  }
  
}
