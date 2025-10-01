import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/detail_subpplies_handover_dto.dart';

class ToolAndSuppliesHandoverDto {
  final String? id;
  final String? banGiaoCCDCVatTu;
  final String? quyetDinhDieuDongSo;
  final String? lenhDieuDong;
  final String? idDonViGiao;
  final String? tenDonViGiao;
  final String? idDonViNhan;
  final String? tenDonViNhan;
  final String? ngayBanGiao;
  final String? idLanhDao;
  final String? tenLanhDao;
  final String? idDaiDiendonviBanHanhQD;
  final String? tenDaiDienBanHanhQD;
  final bool? daXacNhan;
  final String? idDaiDienBenGiao;
  final String? tenDaiDienBenGiao;
  final bool? daiDienBenGiaoXacNhan;
  final String? idDaiDienBenNhan;
  final String? tenDaiDienBenNhan;
  final bool? daiDienBenNhanXacNhan;
  final int? trangThai;
  final String? note;
  final String? ngayTao;
  final String? ngayCapNhat;
  final String? nguoiTao;
  final String? nguoiCapNhat;
  final bool? share;
  final String? duongDanFile;
  final String? tenFile;
  final bool? active;
  List<SignatoryDto>? listSignatory;
  List<DetailSubppliesHandoverDto>? listDetailSubppliesHandover;
  bool? byStep;
  int? trangThaiPhieu;
  ToolAndSuppliesHandoverDto({
    this.id,
    this.banGiaoCCDCVatTu,
    this.quyetDinhDieuDongSo,
    this.lenhDieuDong,
    this.idDonViGiao,
    this.tenDonViGiao,
    this.idDonViNhan,
    this.tenDonViNhan,
    this.ngayBanGiao,
    this.idLanhDao,
    this.tenLanhDao,
    this.idDaiDiendonviBanHanhQD,
    this.tenDaiDienBanHanhQD,
    this.daXacNhan,
    this.idDaiDienBenGiao,
    this.tenDaiDienBenGiao,
    this.daiDienBenGiaoXacNhan,
    this.idDaiDienBenNhan,
    this.tenDaiDienBenNhan,
    this.daiDienBenNhanXacNhan,
    this.trangThai,
    this.note,
    this.ngayTao,
    this.ngayCapNhat,
    this.nguoiTao,
    this.nguoiCapNhat,
    this.share,
    this.duongDanFile,
    this.tenFile,
    this.active,
    this.listSignatory,
    this.byStep,
    this.listDetailSubppliesHandover,
    this.trangThaiPhieu,
  });

  factory ToolAndSuppliesHandoverDto.fromJson(Map<String, dynamic> json) {
    return ToolAndSuppliesHandoverDto(
      id: json['id'],
      banGiaoCCDCVatTu: json['banGiaoCCDCVatTu'],
      quyetDinhDieuDongSo: json['quyetDinhDieuDongSo'],
      lenhDieuDong: json['lenhDieuDong'],
      idDonViGiao: json['idDonViGiao'],
      tenDonViGiao: json['tenDonViGiao'],
      idDonViNhan: json['idDonViNhan'],
      tenDonViNhan: json['tenDonViNhan'],
      ngayBanGiao: json['ngayBanGiao'],
      idLanhDao: json['idLanhDao'],
      tenLanhDao: json['tenLanhDao'],
      idDaiDiendonviBanHanhQD: json['idDaiDiendonviBanHanhQD'],
      tenDaiDienBanHanhQD: json['tenDaiDienBanHanhQD'],
      daXacNhan: json['daXacNhan'],
      idDaiDienBenGiao: json['idDaiDienBenGiao'],
      tenDaiDienBenGiao: json['tenDaiDienBenGiao'],
      daiDienBenGiaoXacNhan: json['daiDienBenGiaoXacNhan'],
      idDaiDienBenNhan: json['idDaiDienBenNhan'],
      tenDaiDienBenNhan: json['tenDaiDienBenNhan'],
      daiDienBenNhanXacNhan: json['daiDienBenNhanXacNhan'],
      trangThai: json['trangThai'],
      note: json['note'],
      ngayTao: json['ngayTao'],
      ngayCapNhat: json['ngayCapNhat'],
      nguoiTao: json['nguoiTao'],
      nguoiCapNhat: json['nguoiCapNhat'],
      share: json['share'],
      duongDanFile: json['duongDanFile'],
      tenFile: json['tenFile'],
      active: json['active'],
      listSignatory:
          json['listSignatory'] != null
              ? List<SignatoryDto>.from(
                json['listSignatory'].map((x) => SignatoryDto.fromJson(x)),
              )
              : null,
      byStep: json['byStep'],
      listDetailSubppliesHandover:
          json['listDetailSubppliesHandover'] != null
              ? List<DetailSubppliesHandoverDto>.from(
                json['listDetailSubppliesHandover'].map(
                  (x) => DetailSubppliesHandoverDto.fromJson(x),
                ),
              )
              : null,
      trangThaiPhieu: json['trangThaiPhieu'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'banGiaoCCDCVatTu': banGiaoCCDCVatTu,
      'quyetDinhDieuDongSo': quyetDinhDieuDongSo,
      'lenhDieuDong': lenhDieuDong,
      'idDonViGiao': idDonViGiao,
      'tenDonViGiao': tenDonViGiao,
      'idDonViNhan': idDonViNhan,
      'tenDonViNhan': tenDonViNhan,
      'ngayBanGiao': ngayBanGiao,
      'idLanhDao': idLanhDao,
      'tenLanhDao': tenLanhDao,
      'idDaiDiendonviBanHanhQD': idDaiDiendonviBanHanhQD,
      'tenDaiDienBanHanhQD': tenDaiDienBanHanhQD,
      'daXacNhan': daXacNhan,
      'idDaiDienBenGiao': idDaiDienBenGiao,
      'tenDaiDienBenGiao': tenDaiDienBenGiao,
      'daiDienBenGiaoXacNhan': daiDienBenGiaoXacNhan,
      'idDaiDienBenNhan': idDaiDienBenNhan,
      'tenDaiDienBenNhan': tenDaiDienBenNhan,
      'daiDienBenNhanXacNhan': daiDienBenNhanXacNhan,
      'trangThai': trangThai,
      'note': note,
      'ngayTao': ngayTao,
      'ngayCapNhat': ngayCapNhat,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'share': share,
      'duongDanFile': duongDanFile,
      'tenFile': tenFile,
      'active': active,
      'listSignatory': listSignatory,
      'byStep': byStep,
      'listDetailSubppliesHandover': listDetailSubppliesHandover,
      'trangThaiPhieu': trangThaiPhieu,
    };
  }

  ToolAndSuppliesHandoverDto copyWith({
    String? id,
    String? banGiaoCCDCVatTu,
    String? quyetDinhDieuDongSo,
    String? lenhDieuDong,
    String? idDonViGiao,
    String? tenDonViGiao,
    String? idDonViNhan,
    String? tenDonViNhan,
    String? ngayBanGiao,
    String? idLanhDao,
    String? tenLanhDao,
    String? idDaiDiendonviBanHanhQD,
    String? tenDaiDienBanHanhQD,
    bool? daXacNhan,
    String? idDaiDienBenGiao,
    String? tenDaiDienBenGiao,
    bool? daiDienBenGiaoXacNhan,
    String? idDaiDienBenNhan,
    String? tenDaiDienBenNhan,
    bool? daiDienBenNhanXacNhan,
    int? trangThai,
    String? note,
    String? ngayTao,
    String? ngayCapNhat,
    String? nguoiTao,
    String? nguoiCapNhat,
    bool? share,
    String? duongDanFile,
    String? tenFile,
    bool? active,
    List<SignatoryDto>? listSignatory,
    bool? byStep,
    List<DetailSubppliesHandoverDto>? listDetailSubppliesHandover,
    int? trangThaiPhieu,
  }) {
    return ToolAndSuppliesHandoverDto(
      id: id ?? this.id,
      banGiaoCCDCVatTu: banGiaoCCDCVatTu ?? this.banGiaoCCDCVatTu,
      quyetDinhDieuDongSo: quyetDinhDieuDongSo ?? this.quyetDinhDieuDongSo,
      lenhDieuDong: lenhDieuDong ?? this.lenhDieuDong,
      idDonViGiao: idDonViGiao ?? this.idDonViGiao,
      tenDonViGiao: tenDonViGiao ?? this.tenDonViGiao,
      idDonViNhan: idDonViNhan ?? this.idDonViNhan,
      tenDonViNhan: tenDonViNhan ?? this.tenDonViNhan,
      ngayBanGiao: ngayBanGiao ?? this.ngayBanGiao,
      idLanhDao: idLanhDao ?? this.idLanhDao,
      tenLanhDao: tenLanhDao ?? this.tenLanhDao,
      idDaiDiendonviBanHanhQD:
          idDaiDiendonviBanHanhQD ?? this.idDaiDiendonviBanHanhQD,
      tenDaiDienBanHanhQD: tenDaiDienBanHanhQD ?? this.tenDaiDienBanHanhQD,
      daXacNhan: daXacNhan ?? this.daXacNhan,
      idDaiDienBenGiao: idDaiDienBenGiao ?? this.idDaiDienBenGiao,
      tenDaiDienBenGiao: tenDaiDienBenGiao ?? this.tenDaiDienBenGiao,
      daiDienBenGiaoXacNhan:
          daiDienBenGiaoXacNhan ?? this.daiDienBenGiaoXacNhan,
      idDaiDienBenNhan: idDaiDienBenNhan ?? this.idDaiDienBenNhan,
      tenDaiDienBenNhan: tenDaiDienBenNhan ?? this.tenDaiDienBenNhan,
      daiDienBenNhanXacNhan:
          daiDienBenNhanXacNhan ?? this.daiDienBenNhanXacNhan,
      trangThai: trangThai ?? this.trangThai,
      note: note ?? this.note,
      ngayTao: ngayTao ?? this.ngayTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
      share: share ?? this.share,
      duongDanFile: duongDanFile ?? this.duongDanFile,
      tenFile: tenFile ?? this.tenFile,
      active: active ?? this.active,
      listSignatory: listSignatory ?? this.listSignatory,
      byStep: byStep ?? this.byStep,
      listDetailSubppliesHandover:
          listDetailSubppliesHandover ?? this.listDetailSubppliesHandover,
      trangThaiPhieu: trangThaiPhieu ?? this.trangThaiPhieu,
    );
  }
}
