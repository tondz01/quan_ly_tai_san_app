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
  final String? tenFile;
  final String? duongDanFile;
  List<SignatoryDto>? listSignatory;

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
    this.tenFile,
    this.duongDanFile,
    this.listSignatory,
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
      donViDaiDienXacNhan: json['donViDaiDienXacNhan'],
      trangThai: json['trangThai'],
      note: json['note'],
      ngayTao: json['ngayTao'],
      ngayCapNhat: json['ngayCapNhat'],
      nguoiTao: json['nguoiTao'],
      nguoiCapNhat: json['nguoiCapNhat'],
      isActive: json['isActive'],
      tenFile: json['tenFile'],
      duongDanFile: json['duongDanFile'],
      listSignatory: json['listSignatory'] != null
          ? List<SignatoryDto>.from(
              json['listSignatory'].map((x) => SignatoryDto.fromJson(x)),
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
      'donViDaiDienXacNhan': donViDaiDienXacNhan,
      'trangThai': trangThai,
      'note': note,
      'ngayTao': ngayTao,
      'ngayCapNhat': ngayCapNhat,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'isActive': isActive,
      'tenFile': tenFile,
      'duongDanFile': duongDanFile,
      'listSignatory': listSignatory?.map((x) => x.toJson()).toList(),
    };
  }
}
