import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/detai_asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/signatory_dto.dart';

class AssetHandoverDto {
  final String? id;
  final String? idCongTy;
  final String? banGiaoTaiSan;
  final String? quyetDinhDieuDongSo;
  final String? lenhDieuDong;
  final String? idDonViGiao;
  final String? tenDonViGiao;
  final String? idDonViNhan;
  final String? tenDonViNhan;
  final String? idDonViDaiDien;
  final String? tenDonViDaiDien;
  final String? ngayBanGiao;
  final String? ngayTaoChungTu;
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
  final String? donViDaiDienXacNhan;
  final int? trangThai;
  final String? note;
  final String? ngayTao;
  final String? ngayCapNhat;
  final String? nguoiTao;
  final String? nguoiCapNhat;
  final bool? isActive;
  final bool? share;
  final String? tenFile;
  final String? duongDanFile;
  final bool? byStep;
  final int? trangThaiPhieu;
  List<SignatoryDto>? listSignatory;
  List<DetailAssetHandoverDto>? chiTietBanGiaoTaiSan;

  AssetHandoverDto({
    this.id,
    this.idCongTy,
    this.banGiaoTaiSan,
    this.quyetDinhDieuDongSo,
    this.lenhDieuDong,
    this.idDonViGiao,
    this.tenDonViGiao,
    this.idDonViNhan,
    this.tenDonViNhan,
    this.idDonViDaiDien,
    this.tenDonViDaiDien,
    this.ngayBanGiao,
    this.ngayTaoChungTu,
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
    this.donViDaiDienXacNhan,
    this.trangThai,
    this.note,
    this.ngayTao,
    this.ngayCapNhat,
    this.nguoiTao,
    this.nguoiCapNhat,
    this.isActive,
    this.share,
    this.tenFile,
    this.duongDanFile,
    this.listSignatory,
    this.byStep,
    this.trangThaiPhieu,
    this.chiTietBanGiaoTaiSan,
  });

  factory AssetHandoverDto.fromJson(Map<String, dynamic> json) {
    return AssetHandoverDto(
      id: json['id'],
      idCongTy: json['idCongTy'],
      banGiaoTaiSan: json['banGiaoTaiSan'],
      quyetDinhDieuDongSo: json['quyetDinhDieuDongSo'],
      lenhDieuDong: json['lenhDieuDong'],
      idDonViGiao: json['idDonViGiao'],
      tenDonViGiao: json['tenDonViGiao'],
      idDonViNhan: json['idDonViNhan'],
      tenDonViNhan: json['tenDonViNhan'],
      idDonViDaiDien: json['idDonViDaiDien'],
      tenDonViDaiDien: json['tenDonViDaiDien'],
      ngayBanGiao: AppUtility.formatFromISOString(json['ngayBanGiao']),
      ngayTaoChungTu: AppUtility.formatFromISOString(
        json['ngayTaoChungTu'] ?? '',
      ),
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
      donViDaiDienXacNhan: json['donViDaiDienXacNhan'],
      trangThai: json['trangThai'],
      note: json['note'],
      ngayTao: AppUtility.formatFromISOString(json['ngayTao']),
      ngayCapNhat: AppUtility.formatFromISOString(json['ngayCapNhat']),
      nguoiTao: json['nguoiTao'],
      nguoiCapNhat: json['nguoiCapNhat'],
      isActive: json['isActive'],
      share: json['share'],
      tenFile: json['tenFile'],
      duongDanFile: json['duongDanFile'],
      listSignatory:
          json['listSignatory'] != null
              ? List<SignatoryDto>.from(
                json['listSignatory'].map((x) => SignatoryDto.fromJson(x)),
              )
              : null,
      byStep: json['byStep'],
      trangThaiPhieu: json['trangThaiPhieu'],
      chiTietBanGiaoTaiSan:
          json['chiTietBanGiaoTaiSan'] != null
              ? List<DetailAssetHandoverDto>.from(
                json['chiTietBanGiaoTaiSan'].map(
                  (x) => DetailAssetHandoverDto.fromJson(x),
                ),
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idCongTy': idCongTy,
      'banGiaoTaiSan': banGiaoTaiSan,
      'quyetDinhDieuDongSo': quyetDinhDieuDongSo,
      'lenhDieuDong': lenhDieuDong,
      'idDonViGiao': idDonViGiao,
      'tenDonViGiao': tenDonViGiao,
      'idDonViNhan': idDonViNhan,
      'tenDonViNhan': tenDonViNhan,
      'idDonViDaiDien': idDonViDaiDien,
      'tenDonViDaiDien': tenDonViDaiDien,
      'ngayBanGiao': AppUtility.formatFromISOString(ngayBanGiao ?? ''),
      'ngayTaoChungTu': AppUtility.formatFromISOString(ngayTaoChungTu ?? ''),
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
      'donViDaiDienXacNhan': donViDaiDienXacNhan,
      'trangThai': trangThai,
      'note': note,
      'ngayTao': AppUtility.formatFromISOString(ngayTao ?? ''),
      'ngayCapNhat': AppUtility.formatFromISOString(ngayCapNhat ?? ''),
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'isActive': isActive,
      'share': share,
      'tenFile': tenFile,
      'duongDanFile': duongDanFile,
      'listSignatory': listSignatory?.map((x) => x.toJson()).toList(),
      'byStep': byStep,
      'trangThaiPhieu': trangThaiPhieu,
      'chiTietBanGiaoTaiSan':
          chiTietBanGiaoTaiSan?.map((x) => x.toJson()).toList(),
    };
  }

  AssetHandoverDto copyWith({
    String? id,
    String? idCongTy,
    String? banGiaoTaiSan,
    String? quyetDinhDieuDongSo,
    String? lenhDieuDong,
    String? idDonViGiao,
    String? tenDonViGiao,
    String? idDonViNhan,
    String? tenDonViNhan,
    String? idDonViDaiDien,
    String? tenDonViDaiDien,
    String? ngayBanGiao,
    String? ngayTaoChungTu,
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
    String? donViDaiDienXacNhan,
    int? trangThai,
    String? note,
    String? ngayTao,
    String? ngayCapNhat,
    String? nguoiTao,
    String? nguoiCapNhat,
    bool? isActive,
    bool? share,
    String? tenFile,
    String? duongDanFile,
    List<SignatoryDto>? listSignatory,
    bool? byStep,
    int? trangThaiPhieu,
    List<DetailAssetHandoverDto>? chiTietBanGiaoTaiSan,
  }) {
    return AssetHandoverDto(
      id: id ?? this.id,
      idCongTy: idCongTy ?? this.idCongTy,
      banGiaoTaiSan: banGiaoTaiSan ?? this.banGiaoTaiSan,
      quyetDinhDieuDongSo: quyetDinhDieuDongSo ?? this.quyetDinhDieuDongSo,
      lenhDieuDong: lenhDieuDong ?? this.lenhDieuDong,
      idDonViGiao: idDonViGiao ?? this.idDonViGiao,
      tenDonViGiao: tenDonViGiao ?? this.tenDonViGiao,
      idDonViNhan: idDonViNhan ?? this.idDonViNhan,
      tenDonViNhan: tenDonViNhan ?? this.tenDonViNhan,
      idDonViDaiDien: idDonViDaiDien ?? this.idDonViDaiDien,
      tenDonViDaiDien: tenDonViDaiDien ?? this.tenDonViDaiDien,
      ngayBanGiao: ngayBanGiao ?? this.ngayBanGiao,
      ngayTaoChungTu: ngayTaoChungTu ?? this.ngayTaoChungTu,
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
      donViDaiDienXacNhan: donViDaiDienXacNhan ?? this.donViDaiDienXacNhan,
      trangThai: trangThai ?? this.trangThai,
      note: note ?? this.note,
      ngayTao: ngayTao ?? this.ngayTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
      isActive: isActive ?? this.isActive,
      share: share ?? this.share,
      tenFile: tenFile ?? this.tenFile,
      duongDanFile: duongDanFile ?? this.duongDanFile,
      listSignatory: listSignatory ?? this.listSignatory,
      byStep: byStep ?? this.byStep,
      trangThaiPhieu: trangThaiPhieu ?? this.trangThaiPhieu,
      chiTietBanGiaoTaiSan: chiTietBanGiaoTaiSan ?? this.chiTietBanGiaoTaiSan,
    );
  }
}
