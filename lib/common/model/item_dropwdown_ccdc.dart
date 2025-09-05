import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';

class ItemDropdownDetailCcdc {
  String id;
  String idCCDCVatTu;
  String tenCCDCVatTu;
  String idDetaiAsset;
  String tenDetailAsset;
  String idDonVi;
  String donViTinh;
  int namSanXuat;
  int soLuong;
  String ghiChu;
  int soLuongXuat; // Thêm field này
  ToolsAndSuppliesDto? asset;

  ItemDropdownDetailCcdc({
    required this.id,
    required this.idCCDCVatTu,
    required this.tenCCDCVatTu,
    required this.idDetaiAsset,
    required this.tenDetailAsset,
    required this.idDonVi,
    required this.donViTinh,
    required this.namSanXuat,
    required this.soLuong,
    required this.ghiChu,
    this.soLuongXuat = 0, // Thêm parameter này
    this.asset,
  });

  factory ItemDropdownDetailCcdc.fromJson(Map<String, dynamic> json) {
    return ItemDropdownDetailCcdc(
      id: json['id'] ?? '',
      idCCDCVatTu: json['idCCDCVatTu'] ?? '',
      tenCCDCVatTu: json['tenCCDCVatTu'] ?? '',
      idDetaiAsset: json['idDetaiAsset'] ?? '',
      tenDetailAsset: json['tenDetailAsset'] ?? '',
      idDonVi: json['idDonVi'] ?? '',
      donViTinh: json['donViTinh'] ?? '',
      namSanXuat: json['namSanXuat'] ?? '',
      soLuong: json['soLuong'] ?? 0,
      ghiChu: json['ghiChu'] ?? '',
      soLuongXuat: json['soLuongXuat'] ?? 0,
      asset:
          json['asset'] != null
              ? ToolsAndSuppliesDto.fromJson(json['asset'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idCCDCVatTu': idCCDCVatTu,
      'tenCCDCVatTu': tenCCDCVatTu,
      'idDetaiAsset': idDetaiAsset,
      'tenDetailAsset': tenDetailAsset,
      'idDonVi': idDonVi,
      'donViTinh': donViTinh,
      'namSanXuat': namSanXuat,
      'soLuong': soLuong,
      'ghiChu': ghiChu,
      'soLuongXuat': soLuongXuat,
      'asset': asset?.toJson(),
    };
  }

  @override
  String toString() {
    return tenDetailAsset;
  }

  ItemDropdownDetailCcdc copyWith({
    int? soLuongXuat,
    String? idCCDCVatTu,
    String? tenCCDCVatTu,
    String? idDetaiAsset,
    String? tenDetailAsset,
    String? idDonVi,
    String? donViTinh,
    int? namSanXuat,
    int? soLuong,
    String? ghiChu,
    ToolsAndSuppliesDto? asset,
  }) {
    return ItemDropdownDetailCcdc(
      id: id,
      idCCDCVatTu: idCCDCVatTu ?? this.idCCDCVatTu,
      tenCCDCVatTu: tenCCDCVatTu ?? this.tenCCDCVatTu,
      idDetaiAsset: idDetaiAsset ?? this.idDetaiAsset,
      tenDetailAsset: tenDetailAsset ?? this.tenDetailAsset,
      idDonVi: idDonVi ?? this.idDonVi,
      donViTinh: donViTinh ?? this.donViTinh,
      namSanXuat: namSanXuat ?? this.namSanXuat,
      soLuong: soLuong ?? this.soLuong,
      ghiChu: ghiChu ?? this.ghiChu,
      soLuongXuat: soLuongXuat ?? this.soLuongXuat,
      asset: asset ?? this.asset,
    );
  }

  static ItemDropdownDetailCcdc empty() {
    return ItemDropdownDetailCcdc(
      id: '',
      idCCDCVatTu: 'adasdas',
      tenCCDCVatTu: '',
      idDetaiAsset: '',
      tenDetailAsset: '',
      idDonVi: '',
      donViTinh: '',
      namSanXuat: 2010,
      soLuong: 0,
      ghiChu: '',
      soLuongXuat: 0,
      asset: null,
    );
  }
}
