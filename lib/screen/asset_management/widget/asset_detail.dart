import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/model_country.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/core/utils/uuid_generator.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/models/duan.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/component/original_asset_information.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/component/other_information.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/component/table_child_assets.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/child_assets_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/model/asset_category_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/repository/asset_management_repository.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/request/asset_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:se_gay_components/common/sg_input_text.dart';
import 'package:se_gay_components/common/sg_text.dart';

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
  LyDoTang? lyDoTang;
  Country? country;

  List<AssetCategoryDto> listAssetCategory = [];
  List<DropdownMenuItem<AssetCategoryDto>> itemsAssetCategory = [];

  TextEditingController ctrlMaTaiSan = TextEditingController();
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
  TextEditingController ctrlNgayVaoSo = TextEditingController();
  TextEditingController ctrlNgaySuDung = TextEditingController();

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
  String? idAssetGroup;
  String? idDepreciationMethod;

  int? phuongPhapKhauHao;

  DuAn? duAn;
  PhongBan? phongBanBanDau;
  PhongBan? phongBanHienThoi;

  List<ChildAssetDto> newChildAssets = [];
  List<ChildAssetDto> initialChildAssets = [];

  Map<String, bool> validationErrors = {};

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didUpdateWidget(covariant AssetDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.provider.dataDetail != data) {
      log('message didUpdateWidget: ${widget.provider.dataDetail?.toJson()}');
      _initData();
    }
  }

  _initData() {
    // newChildAssets.clear();
    if (widget.provider.dataDetail != null) {
      data = widget.provider.dataDetail;
      isEditing = false;
    } else {
      data = null;
      isEditing = true;
    }
    log('message _initData: $isEditing');
    _initController();
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
    final size = MediaQuery.of(context).size;
    return BlocListener<AssetManagementBloc, AssetManagementState>(
      listener: (context, state) {
        if (state is GetListChildAssetsSuccessState) {
          setState(() {
            // newChildAssets = state.data;
          });
        }
        if (state is GetListChildAssetsFailedState) {
          log('GetListChildAssetsFailedState');
        }
        if (state is CreateAssetSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tạo tài sản thành công'),
              backgroundColor: Colors.green,
            ),
          );
          widget.provider.getDataAll(context);
          setState(() {
            isEditing = false;
          });
        } else if (state is CreateAssetFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderDetail(),
          const SizedBox(height: 5),
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
                SGText(
                  text: 'Tên Tài sản',
                  style: TextStyle(
                    fontSize: 16,
                    color: isEditing ? Colors.black : ColorValue.neutral500,
                  ),
                  // fontWeight: FontWeight.w800,
                ),
                const SizedBox(width: 10),
                SGInputText(
                  controller: ctrlTenTaiSan,
                  borderRadius: 10,
                  enabled: isEditing,
                  onlyLine: true,
                  showBorder: false,
                  fontSize: 24,
                  hintText: 'Tên tài sản',
                  hintStyle: TextStyle(
                    fontSize: 24,
                    color: ColorValue.neutral500,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.1,
                    right: size.width * 0.1,
                    top: 10,
                    bottom: 20,
                  ),
                  child: Divider(color: ColorValue.neutral300, height: 1),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: buildOriginalAssetInfomation(
                        context,
                        isEditing: isEditing,
                        ctrlMaTaiSan: ctrlMaTaiSan,
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
                        ctrlNgayVaoSo: ctrlNgayVaoSo,
                        ctrlNgaySuDung: ctrlNgaySuDung,
                        listAssetCategory: listAssetCategory,
                        listAssetGroup: widget.provider.dataGroup!,
                        itemsAssetCategory: itemsAssetCategory,
                        itemsAssetGroup: widget.provider.itemsAssetGroup!,
                        onAssetCategoryChanged: (value) {
                          setState(() {
                            idAssetCategory = value.id;
                            phuongPhapKhauHao = value.phuongPhapKhauHao;
                            ctrlPhuongPhapKhauHao.text =
                                value.phuongPhapKhauHao == 1
                                    ? 'Đường thẳng'
                                    : '';
                            ctrlTaiKhoanTaiSan.text =
                                value.taiKhoanTaiSan.toString();
                            ctrlSoKyKhauHao.text = value.kyKhauHao.toString();
                            ctrlTaiKhoanKhauHao.text =
                                value.taiKhoanKhauHao.toString();
                            ctrlTaiKhoanChiPhi.text =
                                value.taiKhoanChiPhi.toString();
                            log(
                              'Asset category changed: ${ctrlTaiKhoanChiPhi.text}',
                            );
                          });
                        },
                        onAssetGroupChanged: (value) {
                          setState(() {
                            idAssetGroup = value.id;
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
                        listNguonKinhPhi: widget.provider.dataCapitalSource!,
                        itemsPhongBan: widget.provider.itemsPhongBan!,
                        itemsDuAn: widget.provider.itemsDuAn!,
                        itemsNguonKinhPhi: widget.provider.itemsNguonKinhPhi!,
                        provider: widget.provider,
                        duAn: duAn,
                        hienTrang: hienTrang,
                        lyDoTang: lyDoTang,
                        country: country,
                        phongBanBanDau: phongBanBanDau,
                        phongBanHienThoi: phongBanHienThoi,
                        onNuocSanXuatChanged: (value) {
                          setState(() {
                            country = value;
                          });
                        },
                        onDuAnChanged: (value) {
                          setState(() {
                            duAn = value;
                            log('message duAn: ${duAn!.id}');
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
                                ngayTao: DateTime.now().toIso8601String(),
                                ngayCapNhat: DateTime.now().toIso8601String(),
                                nguoiTao: e.nguoiTao,
                                nguoiCapNhat: e.nguoiCapNhat,
                                isActive: e.isActive,
                              ),
                            )
                            .toList();
                    log('message newChildAssets: ${jsonEncode(dataChange)}');
                    // setState(() {
                    // });
                    // });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
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

  void _initController() {
    // If data is null, set all controllers to empty string
    if (data == null) {
      ctrlMaTaiSan.text = '';
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
      ctrlGhiChu.text = '';
      ctrlDonViBanDau.text = '';
      ctrlDonViHienThoi.text = '';
      ctrlTenTaiSan.text = '';
      valueKhoiTaoDonVi = false;
    } else {
      // If data is not null, set controllers with data values
      ctrlMaTaiSan.text = data!.id ?? '';
      ctrlIdNhomTaiSan.text = data!.tenNhom ?? '';
      ctrlNguyenGia.text = data!.nguyenGia?.toString() ?? '';
      ctrlGiaTriKhauHaoBanDau.text =
          data!.giaTriKhauHaoBanDau?.toString() ?? '';
      ctrlKyKhauHaoBanDau.text = data!.kyKhauHaoBanDau?.toString() ?? '';
      ctrlGiaTriThanhLy.text = data!.giaTriThanhLy?.toString() ?? '';
      ctrlTenMoHinh.text = data!.idMoHinhTaiSan ?? '';
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
      ctrlLyDoTang.text = data!.lyDoTang?.toString() ?? '';
      ctrlHienTrang.text = data!.hienTrang?.toString() ?? '';
      ctrlSoLuong.text = data!.soLuong?.toString() ?? '';
      ctrlDonViTinh.text = data!.donViTinh ?? '';
      ctrlGhiChu.text = data!.ghiChu ?? '';
      ctrlDonViBanDau.text = data!.idDonViBanDau ?? '';
      ctrlDonViHienThoi.text = data!.idDonViHienThoi ?? '';
      valueKhoiTaoDonVi = data!.idDonViBanDau != null;
      ctrlTenTaiSan.text = data!.tenTaiSan ?? '';
    }
    log('message _initController: ${ctrlLyDoTang.text}');
  }

  AssetRequest _createAssetRequest() {
    return AssetRequest(
      id: ctrlMaTaiSan.text.replaceAll(RegExp(r"\s+"), ""),
      idLoaiTaiSan: idAssetGroup ?? '',
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
      idNhomTaiSan: idAssetGroup ?? '',
      ngayVaoSo:
          AppUtility.parseDateTimeOrNow(ctrlNgayVaoSo.text).toIso8601String(),
      ngaySuDung:
          AppUtility.parseDateTimeOrNow(ctrlNgaySuDung.text).toIso8601String(),
      idDuDan: duAn?.id ?? '',
      idNguonVon: idNguonKinhPhi ?? '',
      kyHieu: ctrlKyHieu.text,
      soKyHieu: ctrlSoKyHieu.text,
      congSuat: ctrlCongSuat.text,
      nuocSanXuat: country?.name ?? '',
      namSanXuat: int.tryParse(ctrlNamSanXuat.text) ?? 0,
      lyDoTang: lyDoTang?.id ?? 0,
      hienTrang: hienTrang?.id ?? 0,
      soLuong: int.tryParse(ctrlSoLuong.text) ?? 0,
      donViTinh: ctrlDonViTinh.text,
      ghiChu: ctrlGhiChu.text,
      idDonViBanDau: phongBanBanDau?.id ?? '',
      idDonViHienThoi: phongBanHienThoi?.id ?? '',
      moTa: ctrlGhiChu.text,
      idCongTy: 'ct001', // Cần lấy từ context hoặc config
      ngayTao: DateTime.now().toIso8601String(),
      ngayCapNhat: DateTime.now().toIso8601String(),
      nguoiTao: 'current_user', // Cần lấy từ auth
      nguoiCapNhat: 'current_user', // Cần lấy từ auth
      active: true,
    );
  }

  List<String> errorMessage = [];

  // Thêm: Hàm validate form trước khi lưu
  List<String> _validateForm() {
    final String tenTaiSan = ctrlTenTaiSan.text.trim();
    final String donViTinh = ctrlDonViTinh.text.trim();

    final int namSanXuat = int.tryParse(ctrlNamSanXuat.text.trim()) ?? 0;

    final num nguyenGia = AppUtility.parseCurrency(ctrlNguyenGia.text);
    final num giaTriThanhLy = AppUtility.parseCurrency(ctrlGiaTriThanhLy.text);
    validationErrors['idDonViBanDau'] = false;
    validationErrors['idDonViHienThoi'] = false;
    validationErrors['donViBanDau'] = false;
    // Bắt buộc
    if (tenTaiSan.isEmpty) {
      validationErrors['tenTaiSan'] = true;
      errorMessage.add('Tên tài sản');
    }
    if (ctrlMaTaiSan.text.isEmpty) {
      validationErrors['id'] = true;
      errorMessage.add('Mã tài sản');
    }
    if (nguyenGia <= 0) {
      validationErrors['nguyenGia'] = true;
      errorMessage.add('Nguyên giá');
    }
    if (ctrlGiaTriKhauHaoBanDau.text.isEmpty) {
      validationErrors['giaTriKhauHaoBanDau'] = true;
      errorMessage.add('Giá trị khấu hao ban đầu');
    }
    if (giaTriThanhLy < 0) {
      validationErrors['giaTriThanhLy'] = true;
      errorMessage.add('Giá trị thanh lý');
    }
    if ((idAssetGroup ?? '').isEmpty) {
      validationErrors['idAssetGroup'] = true;
      errorMessage.add('Nhóm tài sản');
    }
    if ((idAssetCategory ?? '').isEmpty && ctrlTenMoHinh.text.trim().isEmpty) {
      validationErrors['idAssetCategory'] = true;
      errorMessage.add('Loại tài sản');
    }
    if (ctrlKyHieu.text.isEmpty) {
      validationErrors['kyHieu'] = true;
      errorMessage.add('Ký hiệu');
    }
    if (ctrlSoKyHieu.text.isEmpty) {
      validationErrors['soKyHieu'] = true;
      errorMessage.add('Số ký hiệu');
    }
    if (ctrlCongSuat.text.isEmpty) {
      validationErrors['congSuat'] = true;
      errorMessage.add('Công suất');
    }
    if (ctrlNuocSanXuat.text.isEmpty) {
      validationErrors['nuocSanXuat'] = true;
      errorMessage.add('Nước sản xuất');
    }
    if (ctrlNamSanXuat.text.isEmpty) {
      validationErrors['namSanXuat'] = true;
      errorMessage.add('Năm sản xuất');
    }
    if (ctrlLyDoTang.text.isEmpty) {
      validationErrors['lyDoTang'] = true;
      errorMessage.add('Lý do tăng');
    }
    if (ctrlHienTrang.text.isEmpty) {
      validationErrors['hienTrang'] = true;
      errorMessage.add('Hiện trạng');
    }
    if (ctrlSoLuong.text.isEmpty) {
      validationErrors['soLuong'] = true;
      errorMessage.add('Số lượng');
    }
    if (ctrlDonViTinh.text.isEmpty) {
      validationErrors['donViTinh'] = true;
      errorMessage.add('Đơn vị tính');
    }
    if (ctrlGhiChu.text.isEmpty) {
      validationErrors['ghiChu'] = true;
      errorMessage.add('Ghi chú');
    }
    if (ctrlDonViHienThoi.text.isEmpty) {
      validationErrors['donViHienThoi'] = true;
      errorMessage.add('Đơn vị hiện thời');
    }
    if (donViTinh.isEmpty) {
      validationErrors['donViTinh'] = true;
      errorMessage.add('Đơn vị tính');
    }

    // Số lượng, nguyên giá, khấu hao
    if ((phuongPhapKhauHao ?? 0) == 0) {
      validationErrors['phuongPhapKhauHao'] = true;
      errorMessage.add('Phương pháp khấu hao');
      log('message errorMessage: ${errorMessage}');
    }

    // Năm sản xuất (nếu nhập)
    if (ctrlNamSanXuat.text.trim().isNotEmpty) {
      final int currentYear = DateTime.now().year;
      if (namSanXuat < 1900 || namSanXuat > currentYear) {
        validationErrors['namSanXuat'] = true;
        errorMessage.add('Năm sản xuất');
        log('message errorMessage: ${errorMessage}');
      }
    }

    // Ngày (chỉ kiểm tra không rỗng)
    if (ctrlNgayVaoSo.text.trim().isEmpty) {
      validationErrors['ngayVaoSo'] = true;
      errorMessage.add('Ngày vào sử dụng');
      log('message errorMessage: ${errorMessage}');
    }
    if (ctrlNgaySuDung.text.trim().isEmpty) {
      validationErrors['ngaySuDung'] = true;
      errorMessage.add('Ngày sử dụng');
      log('message errorMessage: ${errorMessage}');
    }

    return validationErrors.entries
        .where((e) => e.value == true)
        .map((e) => e.key)
        .toList();
  }

  List<ChildAssetDto> _createChildAssets() {
    return newChildAssets
        .map(
          (e) => ChildAssetDto(
            id: e.id,
            idTaiSanCon: e.id,
            idTaiSanCha: data?.id ?? '',
            ngayTao: DateTime.now().toIso8601String(),
            ngayCapNhat: DateTime.now().toIso8601String(),
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
            ngayTao: DateTime.now().toIso8601String(),
            ngayCapNhat: DateTime.now().toIso8601String(),
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

    // Validate trước khi lưu
    final errors = _validateForm();
    if (errors.isNotEmpty) {
      log('message errors: ${errors}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Vui lòng điền đầy đủ thông tin bắt buộc: ${errors.join(', ')}',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final request = _createAssetRequest();
    var childAssets = _createChildAssets();
    final bloc = context.read<AssetManagementBloc>();
    if (data == null) {
      log(
        'message requestrequestrequestrequestrequest: ${jsonEncode(request)}',
      );
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
    } else {
      // Cập nhật chi tiết nếu có thay đổi
      if (_detailsChanged()) {
        await _syncDetails(data!.id!);
      }
      bloc.add(UpdateAssetEvent(context, request, data!.id!));
    }
  }
}
