import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/model_country.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/core/utils/uuid_generator.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/capital_source_by_asset_dto.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/models/capital_source.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/models/duan.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/component/original_asset_information.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/component/other_information.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/component/table_child_assets.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/child_assets_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/models/asset_category_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/repository/asset_management_repository.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/request/asset_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/model/reason_increase.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/model/type_asset.dart';
import 'package:quan_ly_tai_san_app/screen/unit/model/unit_dto.dart';

class AssetDetail extends StatefulWidget {
  const AssetDetail({super.key, required this.provider});
  final AssetManagementProvider provider;

  @override
  State<AssetDetail> createState() => _AssetDetailState();
}

class _AssetDetailState extends State<AssetDetail> {
  AssetManagementDto? data;
  Map<String, TextEditingController> controllers = {};

  bool isEditing = false;
  bool valueKhoiTaoDonVi = false;

  HienTrang? hienTrang;
  ReasonIncrease? lyDoTang;
  Country? country;

  List<AssetCategoryDto> listAssetCategory = [];
  List<NguonKinhPhi> listNguonKinhPhi = [];
  List<CapitalSourceByAssetDto> listNguonKinhPhiByAsset = [];
  List<DropdownMenuItem<AssetCategoryDto>> itemsAssetCategory = [];

  TextEditingController ctrlMaTaiSan = TextEditingController();
  TextEditingController ctrlSoThe = TextEditingController();
  TextEditingController ctrlIdNhomTaiSan = TextEditingController();
  TextEditingController ctrlNguyenGia = TextEditingController();
  TextEditingController ctrlGiaTriKhauHaoBanDau = TextEditingController();
  TextEditingController ctrlKyKhauHaoBanDau = TextEditingController();
  TextEditingController ctrlGiaTriThanhLy = TextEditingController();
  TextEditingController ctrlTenMoHinh = TextEditingController();
  TextEditingController ctrlPhuongPhapKhauHao = TextEditingController();
  TextEditingController ctrlSoKyKhauHao = TextEditingController();
  TextEditingController ctrlTaiKhoanTaiSan = TextEditingController();
  TextEditingController ctrlTaiKhoanKhauHao = TextEditingController();
  TextEditingController ctrlTaiKhoanChiPhi = TextEditingController();
  TextEditingController ctrlTenNhom = TextEditingController();
  TextEditingController ctrlTenLoaiTaiSan = TextEditingController();
  TextEditingController ctrlNgayVaoSo = TextEditingController();
  TextEditingController ctrlNgaySuDung = TextEditingController();

  TextEditingController ctrlVonNS = TextEditingController();
  TextEditingController ctrlVonVay = TextEditingController();
  TextEditingController ctrlVonKhac = TextEditingController();

  TextEditingController ctrlDuAn = TextEditingController();
  TextEditingController ctrlNguonKinhPhi = TextEditingController();
  TextEditingController ctrlKyHieu = TextEditingController();
  TextEditingController ctrlSoKyHieu = TextEditingController();
  TextEditingController ctrlCongSuat = TextEditingController();
  TextEditingController ctrlNuocSanXuat = TextEditingController();
  TextEditingController ctrlNamSanXuat = TextEditingController();
  TextEditingController ctrlLyDoTang = TextEditingController();
  TextEditingController ctrlHienTrang = TextEditingController();
  TextEditingController ctrlSoLuong = TextEditingController();
  TextEditingController ctrlDonViTinh = TextEditingController();
  TextEditingController ctrlGhiChu = TextEditingController();
  TextEditingController ctrlDonViBanDau = TextEditingController();
  TextEditingController ctrlDonViHienThoi = TextEditingController();
  TextEditingController ctrlTenTaiSan = TextEditingController();

  String? idDuAn;
  String? idNguonKinhPhi;
  String? idLyDoTang;
  String? idHienTrang;
  String? idAssetCategory;
  AssetGroupDto? assetGroup;
  String? idDepreciationMethod;

  int? phuongPhapKhauHao;

  DuAn? duAn;
  PhongBan? phongBanBanDau;
  PhongBan? phongBanHienThoi;
  TypeAsset? typeAsset;
  UnitDto? unit;

  List<ChildAssetDto> newChildAssets = [];
  List<ChildAssetDto> initialChildAssets = [];
  List<TypeAsset> listTypeAsset = [];
  List<UnitDto> listUnit = [];
  List<ReasonIncrease> listLyDoTang = [];

  List<DropdownMenuItem<ReasonIncrease>> itemsLyDoTang = [];
  List<DropdownMenuItem<UnitDto>> itemsUnit = [];

  Map<String, bool> validationErrors = {};

  @override
  void initState() {
    setState(() {
      _initController();
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AssetDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.provider.dataDetail != data) {
      setState(() {
        _initController();
      });
    }
  }

  List<Map<String, dynamic>> _normalizeDetails(List<ChildAssetDto> list) {
    final data =
        list
            .map(
              (d) => {
                'idTaiSan': d.idTaiSanCha,
                'idTaiSanCon': d.idTaiSanCon,
                'ngayTao': d.ngayTao,
                'ngayCapNhat': d.ngayCapNhat,
                'nguoiTao': d.nguoiTao,
                'nguoiCapNhat': d.nguoiCapNhat,
                'isActive': d.isActive,
              },
            )
            .toList();
    data.sort(
      (a, b) => (a['idTaiSan'] as String).compareTo(b['idTaiSan'] as String),
    );
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.provider.isNew ||
            (widget.provider.isCanUpdate &&
                !widget.provider.isNew &&
                data != null))
          _buildHeaderDetail(),
        SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: buildOriginalAssetInfomation(
                      context,
                      isEditing: isEditing,
                      ctrlTenTaiSan: ctrlTenTaiSan,
                      ctrlMaTaiSan: ctrlMaTaiSan,
                      ctrlSoThe: ctrlSoThe,
                      ctrlIdNhomTaiSan: ctrlIdNhomTaiSan,
                      ctrlNguyenGia: ctrlNguyenGia,
                      ctrlGiaTriKhauHaoBanDau: ctrlGiaTriKhauHaoBanDau,
                      ctrlKyKhauHaoBanDau: ctrlKyKhauHaoBanDau,
                      ctrlGiaTriThanhLy: ctrlGiaTriThanhLy,
                      ctrlTenMoHinh: ctrlTenMoHinh,
                      ctrlPhuongPhapKhauHao: ctrlPhuongPhapKhauHao,
                      ctrlSoKyKhauHao: ctrlSoKyKhauHao,
                      ctrlTaiKhoanTaiSan: ctrlTaiKhoanTaiSan,
                      ctrlTaiKhoanKhauHao: ctrlTaiKhoanKhauHao,
                      ctrlTaiKhoanChiPhi: ctrlTaiKhoanChiPhi,
                      ctrlTenNhom: ctrlTenNhom,
                      ctrlTenLoaiTaiSan: ctrlTenLoaiTaiSan,
                      ctrlNgayVaoSo: ctrlNgayVaoSo,
                      ctrlNgaySuDung: ctrlNgaySuDung,
                      listAssetCategory: listAssetCategory,
                      itemsAssetCategory: itemsAssetCategory,
                      assetGroup: assetGroup ?? AssetGroupDto(),
                      validationErrors: validationErrors,
                      listTypeAsset: listTypeAsset,
                      onAssetCategoryChanged: (value) {
                        setState(() {
                          idAssetCategory = value.id;
                          phuongPhapKhauHao = value.phuongPhapKhauHao;
                          ctrlPhuongPhapKhauHao.text =
                              value.phuongPhapKhauHao == 1 ? 'Đường thẳng' : '';
                          ctrlTaiKhoanTaiSan.text =
                              value.taiKhoanTaiSan.toString();
                          ctrlSoKyKhauHao.text = value.kyKhauHao.toString();
                          ctrlTaiKhoanKhauHao.text =
                              value.taiKhoanKhauHao.toString();
                          ctrlTaiKhoanChiPhi.text =
                              value.taiKhoanChiPhi.toString();
                        });
                      },
                      onAssetGroupChanged: (value) {
                        setState(() {
                          assetGroup = value;
                          listTypeAsset = AccountHelper.instance.getTypeAsset(
                            assetGroup?.id ?? '',
                          );
                        });
                      },
                      onDepreciationMethodChanged: (value) {
                        setState(() {
                          ctrlPhuongPhapKhauHao.text = value;
                          phuongPhapKhauHao = int.tryParse(value) ?? 0;
                        });
                      },
                      onChangedNgayVaoSo: (value) {},
                      onChangedNgaySuDung: (value) {},
                      onTypeAssetChanged: (value) {
                        setState(() {
                          typeAsset = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 30),
                  Expanded(
                    child: buildOtherInformation(
                      context,
                      isEditing: isEditing,
                      ctrlDuAn: ctrlDuAn,
                      ctrlNguonKinhPhi: ctrlNguonKinhPhi,
                      ctrlKyHieu: ctrlKyHieu,
                      ctrlSoKyHieu: ctrlSoKyHieu,
                      ctrlCongSuat: ctrlCongSuat,
                      ctrlNuocSanXuat: ctrlNuocSanXuat,
                      ctrlNamSanXuat: ctrlNamSanXuat,
                      ctrlLyDoTang: ctrlLyDoTang,
                      ctrlHienTrang: ctrlHienTrang,
                      ctrlSoLuong: ctrlSoLuong,
                      ctrlDonViTinh: ctrlDonViTinh,
                      ctrlGhiChu: ctrlGhiChu,
                      ctrlDonViBanDau: ctrlDonViBanDau,
                      ctrlDonViHienThoi: ctrlDonViHienThoi,
                      valueKhoiTaoDonVi: valueKhoiTaoDonVi,
                      listPhongBan: widget.provider.dataDepartment!,
                      listDuAn: widget.provider.dataProject!,
                      listLyDoTang: listLyDoTang,
                      itemsLyDoTang: itemsLyDoTang,
                      lyDoTang: lyDoTang,
                      listUnit: listUnit,
                      itemsUnit: itemsUnit,
                      itemsPhongBan: widget.provider.itemsPhongBan!,
                      itemsDuAn:
                          widget
                              .provider
                              .itemsDuAn!, // itemsNguonKinhPhi: widget.provider.itemsNguonKinhPhi!,
                      ctrlVonNS: ctrlVonNS,
                      ctrlVonVay: ctrlVonVay,
                      ctrlVonKhac: ctrlVonKhac,
                      provider: widget.provider,
                      duAn: duAn,
                      hienTrang: hienTrang,
                      country: country,
                      phongBanBanDau: phongBanBanDau,
                      phongBanHienThoi: phongBanHienThoi,
                      unit: unit,
                      validationErrors: validationErrors,
                      onTotalCapitalChanged: (value) {
                        log(
                          'message test [AssetDetail]: onTotalCapitalChanged called with value: $value',
                        );
                        setState(() {
                          ctrlNguyenGia.text = value.toString();
                          log(
                            'message test [AssetDetail]: ctrlNguyenGia.text set to: ${ctrlNguyenGia.text}',
                          );
                        });
                      },
                      onNuocSanXuatChanged: (value) {
                        setState(() {
                          country = value;
                        });
                      },
                      onDuAnChanged: (value) {
                        setState(() {
                          duAn = value;
                        });
                      },
                      onKhoiTaoDonViChanged: (value) {
                        setState(() {
                          valueKhoiTaoDonVi = value;
                        });
                      },
                      onNguonKinhPhiChanged: (value) {
                        setState(() {
                          idNguonKinhPhi = value.id;
                        });
                      },
                      onLyDoTangChanged: (value) {
                        setState(() {
                          lyDoTang = value;
                        });
                      },
                      onHienTrangChanged: (value) {
                        setState(() {
                          hienTrang = value;
                        });
                      },
                      onChangeInitialUsage: (value) {
                        setState(() {
                          phongBanBanDau = value;
                        });
                      },
                      onChangeCurrentUnit: (value) {
                        setState(() {
                          phongBanHienThoi = value;
                        });
                      },
                      onUnitChanged: (value) {
                        setState(() {
                          unit = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              TableChildAssets(
                context,
                isEditing: isEditing,
                initialDetails: data?.childAssets ?? [],
                allAssets: widget.provider.data ?? [],
                onDataChanged: (dataChange) {
                  // setState(() {
                  newChildAssets =
                      dataChange
                          .map(
                            (e) => ChildAssetDto(
                              id: e.id,
                              idTaiSanCha: data?.id ?? '',
                              idTaiSanCon: e.id,
                              ngayTao: AppUtility.formatDateString(
                                DateTime.now(),
                              ),
                              ngayCapNhat: AppUtility.formatDateString(
                                DateTime.now(),
                              ),
                              nguoiTao: e.nguoiTao,
                              nguoiCapNhat: e.nguoiCapNhat,
                              isActive: e.isActive,
                            ),
                          )
                          .toList();
                  // setState(() {
                  // });
                  // });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderDetail() {
    return isEditing
        ? Row(
          children: [
            MaterialTextButton(
              text: 'Lưu',
              icon: Icons.save,
              backgroundColor: ColorValue.success,
              foregroundColor: Colors.white,
              onPressed: _handleSave,
            ),
            const SizedBox(width: 8),
            MaterialTextButton(
              text: 'Hủy',
              icon: Icons.cancel,
              backgroundColor: ColorValue.error,
              foregroundColor: Colors.white,
              onPressed: () {
                isEditing = false;
                widget.provider.onCloseDetail(context);
              },
            ),
          ],
        )
        : MaterialTextButton(
          text: 'Chỉnh sửa nhóm tài sản',
          icon: Icons.save,
          backgroundColor: ColorValue.success,
          foregroundColor: Colors.white,
          onPressed: () {
            setState(() {
              isEditing = true;
            });
          },
        );
  }

  void _initController() async {
    // If data is null, set all controllers to empty string
    _clearValidationErrors();
    listAssetCategory = AccountHelper.instance.getAssetCategory() ?? [];
    listUnit = widget.provider.dataUnit ?? [];
    listLyDoTang = AccountHelper.instance.getReasonIncrease() ?? [];
    itemsLyDoTang.clear();
    itemsLyDoTang.addAll([
      ...listLyDoTang.map(
        (e) => DropdownMenuItem<ReasonIncrease>(
          value: e,
          child: Text(e.ten ?? ''),
        ),
      ),
    ]);

    log('message test [AssetDetail]: listUnit: ${AccountHelper.instance.getAllUnit()}');
    log('message test [AssetDetail]: listUnit [2]: ${jsonEncode(listUnit)}');
    
    itemsUnit.clear();
    itemsUnit.addAll([
      ...listUnit.map(
        (e) => DropdownMenuItem<UnitDto>(
          value: e,
          child: Text(e.tenDonVi ?? ''),
        ),
      ),
    ]);

    if (listAssetCategory.isNotEmpty) {
      itemsAssetCategory.clear();
      itemsAssetCategory.addAll([
        ...listAssetCategory.map(
          (e) => DropdownMenuItem<AssetCategoryDto>(
            value: e,
            child: Text(e.tenMoHinh ?? ''),
          ),
        ),
      ]);
    }
    if (widget.provider.dataDetail == null) {
      isEditing = true;
      ctrlMaTaiSan.text = '';
      ctrlSoThe.text = '';
      ctrlIdNhomTaiSan.text = '';
      ctrlNguyenGia.text = '';
      ctrlGiaTriKhauHaoBanDau.text = '';
      ctrlKyKhauHaoBanDau.text = '';
      ctrlGiaTriThanhLy.text = '';
      ctrlTenMoHinh.text = '';
      ctrlPhuongPhapKhauHao.text = '';
      ctrlSoKyKhauHao.text = '';
      ctrlTaiKhoanTaiSan.text = '';
      ctrlTaiKhoanKhauHao.text = '';
      ctrlTaiKhoanChiPhi.text = '';
      ctrlTenNhom.text = '';
      ctrlNgayVaoSo.text = '';
      ctrlNgaySuDung.text = '';
      ctrlDuAn.text = '';
      ctrlNguonKinhPhi.text = '';
      ctrlKyHieu.text = '';
      ctrlSoKyHieu.text = '';
      ctrlCongSuat.text = '';
      ctrlNuocSanXuat.text = '';
      ctrlNamSanXuat.text = '';
      ctrlLyDoTang.text = '';
      ctrlHienTrang.text = '';
      ctrlSoLuong.text = 1.toString();
      ctrlDonViTinh.text = '';
      unit = null;
      ctrlGhiChu.text = '';
      ctrlDonViBanDau.text = '';
      ctrlDonViHienThoi.text = '';
      ctrlTenTaiSan.text = '';
      valueKhoiTaoDonVi = false;
    } else {
      if (widget.provider.dataDetail != null) {
        data = widget.provider.dataDetail;
        isEditing = false;
      }
      if (!widget.provider.isCanUpdate && !widget.provider.isNew) {
        isEditing = false;
      }
      // if (widget.provider.initialSelectedNguonKinhPhi != null) {
      //   listNguonKinhPhi = widget.provider.initialSelectedNguonKinhPhi ?? [];
      // }
      // If data is not null, set controllers with data values
      ctrlMaTaiSan.text = data!.id ?? '';
      ctrlSoThe.text = data!.soThe ?? '';
      ctrlNguyenGia.text =
          NumberFormat.currency(
            locale: 'vi_VN',
            symbol: '',
          ).format(data!.nguyenGia ?? 0.0).toString();
      ctrlGiaTriKhauHaoBanDau.text =
          data!.giaTriKhauHaoBanDau?.toString() ?? '';
      ctrlKyKhauHaoBanDau.text = data!.kyKhauHaoBanDau?.toString() ?? '';
      ctrlGiaTriThanhLy.text = data!.giaTriThanhLy?.toString() ?? '';
      // Resolve model name safely
      final moHinh =
          listAssetCategory.any((element) => element.id == data!.idMoHinhTaiSan)
              ? listAssetCategory.firstWhere(
                (element) => element.id == data!.idMoHinhTaiSan,
              )
              : null;
      ctrlTenMoHinh.text = moHinh?.tenMoHinh ?? '';
      idAssetCategory = data!.idMoHinhTaiSan;
      ctrlPhuongPhapKhauHao.text = data!.giaTriKhauHaoBanDau?.toString() ?? '';
      ctrlSoKyKhauHao.text = data!.soKyKhauHao?.toString() ?? '';
      ctrlTaiKhoanTaiSan.text = data!.taiKhoanTaiSan?.toString() ?? '';
      ctrlTaiKhoanKhauHao.text = data!.taiKhoanKhauHao?.toString() ?? '';
      ctrlTaiKhoanChiPhi.text = data!.taiKhoanChiPhi?.toString() ?? '';
      ctrlTenNhom.text = data!.idNhomTaiSan ?? '';
      ctrlNgayVaoSo.text = data!.ngayVaoSo?.toString() ?? '';
      ctrlNgaySuDung.text = data!.ngaySuDung?.toString() ?? '';
      ctrlDuAn.text = data!.idDuAn ?? '';
      ctrlNguonKinhPhi.text = data!.idNguonVon ?? '';
      ctrlKyHieu.text = data!.kyHieu ?? '';
      ctrlSoKyHieu.text = data!.soKyHieu ?? '';
      ctrlCongSuat.text = data!.congSuat?.toString() ?? '';
      ctrlNuocSanXuat.text = data!.nuocSanXuat ?? '';
      ctrlNamSanXuat.text = data!.namSanXuat?.toString() ?? '';
      ctrlSoLuong.text = data!.soLuong?.toString() ?? '';
      unit = AccountHelper.instance.getUnitById(data!.donViTinh ?? '');
      ctrlDonViTinh.text = unit?.tenDonVi ?? '';
      ctrlGhiChu.text = data!.ghiChu ?? '';
      ctrlDonViBanDau.text = data!.idDonViBanDau ?? '';
      ctrlDonViHienThoi.text = data!.idDonViHienThoi ?? '';
      valueKhoiTaoDonVi = data!.idDonViBanDau != null;
      ctrlTenTaiSan.text = data!.tenTaiSan ?? '';

      assetGroup = AccountHelper.instance.getAssetGroupById(
        data!.idNhomTaiSan ?? '',
      );
      ctrlIdNhomTaiSan.text = assetGroup?.tenNhom ?? '';
      log('message test [AssetDetail]: data!.lyDoTang: ${data!.lyDoTang}');
      log(
        'message test [AssetDetail]: AccountHelper.instance.getReasonIncreaseById(data!.lyDoTang ?? '
        '): ${AccountHelper.instance.getReasonIncreaseById(data!.lyDoTang ?? '')}',
      );
      lyDoTang = listLyDoTang.where((e) => e.id == data!.lyDoTang).firstOrNull;
      ctrlLyDoTang.text = lyDoTang?.ten ?? '';


      unit = listUnit.where((e) => e.id == data!.donViTinh).firstOrNull;
      ctrlDonViTinh.text = unit?.tenDonVi ?? '';

      ctrlVonNS.text =
          NumberFormat.currency(
            locale: 'vi_VN',
            symbol: '',
          ).format(data!.vonNS ?? 0.0).toString();
      ctrlVonVay.text =
          NumberFormat.currency(
            locale: 'vi_VN',
            symbol: '',
          ).format(data!.vonVay ?? 0.0).toString();
      ctrlVonKhac.text =
          NumberFormat.currency(
            locale: 'vi_VN',
            symbol: '',
          ).format(data!.vonKhac ?? 0.0).toString();

      List<TypeAsset> listTypeAsset = AccountHelper.instance.getTypeAsset(
        data!.idNhomTaiSan ?? '',
      );
      typeAsset =
          listTypeAsset.any((element) => element.id == data!.idLoaiTaiSanCon)
              ? listTypeAsset.firstWhere(
                (element) => element.id == data!.idLoaiTaiSanCon,
              )
              : null;
      ctrlTenLoaiTaiSan.text = typeAsset?.tenLoai ?? '';
    }
  }

  AssetRequest _createAssetRequest() {
    return AssetRequest(
      id: ctrlMaTaiSan.text.replaceAll(RegExp(r"\s+"), ""),
      soThe: ctrlSoThe.text,
      idLoaiTaiSan: assetGroup?.id ?? '',
      tenTaiSan: ctrlTenTaiSan.text,
      nguyenGia: AppUtility.parseCurrency(ctrlNguyenGia.text),
      giaTriKhauHaoBanDau: AppUtility.parseCurrency(
        ctrlGiaTriKhauHaoBanDau.text,
      ),
      kyKhauHaoBanDau: int.tryParse(ctrlKyKhauHaoBanDau.text) ?? 0,
      giaTriThanhLy: AppUtility.parseCurrency(ctrlGiaTriThanhLy.text),
      idMoHinhTaiSan: idAssetCategory ?? ctrlTenMoHinh.text,
      phuongPhapKhauHao: phuongPhapKhauHao ?? 1,
      soKyKhauHao: int.tryParse(ctrlSoKyKhauHao.text) ?? 0,
      taiKhoanTaiSan: int.tryParse(ctrlTaiKhoanTaiSan.text) ?? 0,
      taiKhoanKhauHao: int.tryParse(ctrlTaiKhoanKhauHao.text) ?? 0,
      taiKhoanChiPhi: int.tryParse(ctrlTaiKhoanChiPhi.text) ?? 0,
      idNhomTaiSan: assetGroup?.id ?? '',
      ngayVaoSo: AppUtility.parseDateTimeOrNow(ctrlNgayVaoSo.text).toString(),
      ngaySuDung: AppUtility.parseDateTimeOrNow(ctrlNgaySuDung.text).toString(),
      idDuDan: duAn?.id ?? '',
      idNguonVon: idNguonKinhPhi ?? '',
      kyHieu: ctrlKyHieu.text,
      soKyHieu: ctrlSoKyHieu.text,
      congSuat: ctrlCongSuat.text,
      nuocSanXuat: country?.name ?? '',
      namSanXuat: int.tryParse(ctrlNamSanXuat.text) ?? 0,
      lyDoTang: lyDoTang?.id ?? '',
      hienTrang: hienTrang?.id ?? 0,
      soLuong: int.tryParse(ctrlSoLuong.text) ?? 0,
      donViTinh: unit?.id ?? '',
      ghiChu: ctrlGhiChu.text,
      idDonViBanDau: phongBanBanDau?.id ?? '',
      idDonViHienThoi: phongBanHienThoi?.id ?? '',
      moTa: ctrlGhiChu.text,
      idCongTy: 'ct001', // Cần lấy từ context hoặc config
      ngayTao: AppUtility.formatDateString(DateTime.now()),
      ngayCapNhat: AppUtility.formatDateString(DateTime.now()),
      nguoiTao: AccountHelper.instance.getUserInfo()?.tenDangNhap ?? '',
      nguoiCapNhat: '',
      active: true,
      isTaiSanCon: false,
      idLoaiTaiSanCon: typeAsset?.id ?? '',
      vonNS: AppUtility.parseCurrency(ctrlVonNS.text),
      vonVay: AppUtility.parseCurrency(ctrlVonVay.text),
      vonKhac: AppUtility.parseCurrency(ctrlVonKhac.text),
    );
  }

  bool _validateForm() {
    Map<String, bool> newValidationErrors = {};
    final String tenTaiSan = ctrlTenTaiSan.text.trim();
    if (tenTaiSan.isEmpty) {
      newValidationErrors['tenTaiSan'] = true;
    }
    if (ctrlMaTaiSan.text.isEmpty) {
      newValidationErrors['id'] = true;
    }

    if (assetGroup == null) {
      newValidationErrors['idNhomTaiSan'] = true;
    }
    if (ctrlDonViTinh.text.isEmpty || unit == null) {
      newValidationErrors['donViTinh'] = true;
    }
    if (ctrlDonViHienThoi.text.isEmpty) {
      newValidationErrors['idDonViHienThoi'] = true;
    }

    bool hasChanges = !mapEquals(validationErrors, newValidationErrors);
    if (hasChanges) {
      setState(() {
        validationErrors = newValidationErrors;
      });
    }
    return newValidationErrors.isEmpty;
  }

  void _clearValidationErrors() {
    if (validationErrors.isNotEmpty) {
      setState(() {
        validationErrors = {};
      });
    }
  }

  List<ChildAssetDto> _createChildAssets() {
    return newChildAssets
        .map(
          (e) => ChildAssetDto(
            id: e.id,
            idTaiSanCon: e.id,
            idTaiSanCha: data?.id ?? '',
            ngayTao: AppUtility.formatDateString(DateTime.now()),
            ngayCapNhat: AppUtility.formatDateString(DateTime.now()),
            nguoiTao: e.nguoiTao,
            nguoiCapNhat: e.nguoiCapNhat,
            isActive: e.isActive,
          ),
        )
        .toList();
  }

  bool _detailsChanged() {
    if (data == null) return newChildAssets.isNotEmpty;
    final beforeJson = jsonEncode(_normalizeDetails(initialChildAssets));
    final afterJson = jsonEncode(_normalizeDetails(newChildAssets));
    return beforeJson != afterJson;
  }

  Future<void> _syncDetails(String idTaiSan) async {
    try {
      final repo = AssetManagementRepository();
      for (final d in initialChildAssets) {
        if (d.id != null) {
          await repo.delete(d.id!);
        }
      }
      for (final d in newChildAssets) {
        await repo.create(
          ChildAssetDto(
            id: d.id,
            idTaiSanCon: d.id,
            idTaiSanCha: data?.id ?? '',
            ngayTao: AppUtility.formatDateString(DateTime.now()),
            ngayCapNhat: AppUtility.formatDateString(DateTime.now()),
            nguoiTao: d.nguoiTao,
            nguoiCapNhat: d.nguoiCapNhat,
            isActive: d.isActive,
          ),
        );
      }
    } catch (e) {
      log('Sync details error: $e');
    }
  }

  Future<void> _handleSave() async {
    if (!isEditing) return;

    if (!_validateForm()) {
      AppUtility.showSnackBar(
        context,
        'Vui lòng điền đầy đủ thông tin bắt buộc (*)',
        isError: true,
      );
      return;
    }
    widget.provider.onCloseDetail(context);
    final request = _createAssetRequest();
    var childAssets = _createChildAssets();
    final bloc = context.read<AssetManagementBloc>();
    if (data == null) {
      childAssets =
          childAssets
              .map(
                (d) => d.copyWith(
                  id: UUIDGenerator.generateWithFormat('TSC-******'),
                  idTaiSanCha: request.id,
                ),
              )
              .toList();
      bloc.add(CreateAssetEvent(context, request, childAssets));
      // Create all selected capital sources for the new asset (if any)
      // if (listNguonKinhPhi.isNotEmpty) {
      //   await _syncCapitalSources(request.id, listNguonKinhPhi);
      // }
    } else {
      // Cập nhật chi tiết nếu có thay đổi
      if (_detailsChanged()) {
        await _syncDetails(data!.id!);
      }
      final request = _createAssetRequest().copyWith(
        nguoiCapNhat: AccountHelper.instance.getUserInfo()?.tenDangNhap ?? '',
        ngayCapNhat: AppUtility.formatDateString(DateTime.now()),
      );

      // Sync capital sources: update/create/delete differences
      // await _syncCapitalSources(data!.id ?? request.id, listNguonKinhPhi);

      bloc.add(UpdateAssetEvent(request, data!.id!));
    }
  }

  // Future<void> _syncCapitalSources(
  //   String assetId,
  //   List<NguonKinhPhi> selected,
  // ) async {
  //   try {
  //     final repo = AssetManagementRepository();

  //     // Old list from current asset data
  //     final List<CapitalSourceByAssetDto> oldList =
  //         data?.nguonKinhPhiList ?? [];
  //     final Map<String, CapitalSourceByAssetDto> oldByCapitalId = {
  //       for (final x in oldList) (x.idNguonKinhPhi ?? ''): x,
  //     };

  //     final Set<String> oldIds =
  //         oldByCapitalId.keys.where((e) => e.isNotEmpty).toSet();
  //     final Set<String> newIds =
  //         selected.map((e) => e.id ?? '').where((e) => e.isNotEmpty).toSet();

  //     // Build new list dto mapped from selected
  //     final List<CapitalSourceByAssetDto> newList =
  //         selected.map((e) {
  //           return CapitalSourceByAssetDto(
  //             id: oldByCapitalId[e.id ?? '']?.id ?? UUIDGenerator.generateWithFormat('NKP-******'),
  //             idTaiSan: assetId,
  //             idNguonKinhPhi: e.id,
  //             tenNguonKinhPhi: e.tenNguonKinhPhi,
  //           );
  //         }).toList();

  //     // CREATE new
  //     final List<CapitalSourceByAssetDto> toCreate =
  //         newList
  //             .where((n) => !oldIds.contains(n.idNguonKinhPhi ?? ''))
  //             .toList();
  //     if (toCreate.isNotEmpty) {
  //       await repo.createListCapitalSourceByAsset(toCreate);
  //     }

  //     // UPDATE changed
  //     for (final n in newList) {
  //       final key = n.idNguonKinhPhi ?? '';
  //       if (oldIds.contains(key)) {
  //         final old = oldByCapitalId[key]!;
  //         final bool changed =
  //             (old.tenNguonKinhPhi ?? '') != (n.tenNguonKinhPhi ?? '');
  //         if (changed && (old.id ?? '').isNotEmpty) {
  //           await repo.updateListCapitalSourceByAsset(old.id!, n);
  //         }
  //       }
  //     }

  //     // DELETE removed
  //     final List<String> removedIds = oldIds.difference(newIds).toList();
  //     if (removedIds.isNotEmpty) {
  //       final List<String> toDeleteRecordIds =
  //           removedIds
  //               .map((idCap) => oldByCapitalId[idCap]?.id)
  //               .whereType<String>()
  //               .toList();
  //       if (toDeleteRecordIds.isNotEmpty) {
  //         await repo.deleteListCapitalSourceByAsset(toDeleteRecordIds);
  //       }
  //     }
  //   } catch (e) {
  //     log('Sync capital sources error: $e');
  //   }
  // }
}
