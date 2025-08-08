import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/model_country.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/component/original_asset_information.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/component/other_information.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/model/asset_category_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/request/asset_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  String? idDuAn;
  String? idNguonKinhPhi;
  String? idLyDoTang;
  String? idHienTrang;
  String? idAssetCategory;
  String? idAssetGroup;
  String? idDepreciationMethod;

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

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssetManagementBloc, AssetManagementState>(
      listener: (context, state) {
        if (state is CreateAssetSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tạo tài sản thành công'),
              backgroundColor: Colors.green,
            ),
          );
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
            child: Row(
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
                        ctrlPhuongPhapKhauHao.text =
                            value.phuongPhapKhauHao == 1 ? 'Đường thẳng' : '';
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
                    hienTrang: hienTrang,
                    lyDoTang: lyDoTang,
                    country: country,
                    onNuocSanXuatChanged: (value) {
                      setState(() {
                        country = value;
                      });
                    },
                    onDuAnChanged: (value) {
                      setState(() {
                        idDuAn = value.id;
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
                        idLyDoTang = value.id.toString();
                      });
                    },
                    onHienTrangChanged: (value) {
                      setState(() {
                        hienTrang = value;
                        idHienTrang = value.id.toString();
                      });
                    },
                    onKhoiTaoDonViChanged: (value) {
                      setState(() {
                        valueKhoiTaoDonVi = value;
                      });
                    },
                    onChangeInitialUsage: (value) {
                      setState(() {
                        ctrlDonViBanDau.text = value.id ?? '';
                      });
                    },
                    onChangeCurrentUnit: (value) {
                      setState(() {
                        ctrlDonViHienThoi.text = value.id ?? '';
                      });
                    },
                  ),
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
      ctrlSoLuong.text = '';
      ctrlDonViTinh.text = '';
      ctrlGhiChu.text = '';
      ctrlDonViBanDau.text = '';
      ctrlDonViHienThoi.text = '';
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
    }
    log('message _initController: ${ctrlLyDoTang.text}');
  }

  AssetRequest _createAssetRequest() {
    return AssetRequest(
      idLoaiTaiSan: ctrlMaTaiSan.text,
      tenTaiSan: ctrlTenMoHinh.text,
      nguyenGia: double.tryParse(ctrlNguyenGia.text) ?? 0.0,
      giaTriKhauHaoBanDau: double.tryParse(ctrlGiaTriKhauHaoBanDau.text) ?? 0.0,
      kyKhauHaoBanDau: int.tryParse(ctrlKyKhauHaoBanDau.text) ?? 0,
      giaTriThanhLy: double.tryParse(ctrlGiaTriThanhLy.text) ?? 0.0,
      idMoHinhTaiSan: idAssetCategory ?? ctrlTenMoHinh.text,
      phuongPhapKhauHao: ctrlPhuongPhapKhauHao.text,
      soKyKhauHao: int.tryParse(ctrlSoKyKhauHao.text) ?? 0,
      taiKhoanTaiSan: int.tryParse(ctrlTaiKhoanTaiSan.text) ?? 0,
      taiKhoanKhauHao: int.tryParse(ctrlTaiKhoanKhauHao.text) ?? 0,
      taiKhoanChiPhi: int.tryParse(ctrlTaiKhoanChiPhi.text) ?? 0,
      idNhomTaiSan: idAssetGroup ?? '',
      ngayVaoSo: (() {
        try {
          return DateFormat('dd/MM/yyyy HH:mm:ss').parse(ctrlNgayVaoSo.text);
        } catch (_) {
          return DateTime.now();
        }
      })(),
      ngaySuDung: (() {
        try {
          return DateFormat('dd/MM/yyyy HH:mm:ss').parse(ctrlNgaySuDung.text);
        } catch (_) {
          return DateTime.now();
        }
      })(),
      idDuDan: idDuAn ?? '',
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
      idDonViBanDau: ctrlDonViBanDau.text,
      idDonViHienThoi: ctrlDonViHienThoi.text,
      moTa: ctrlGhiChu.text,
      idCongTy: 'ct001', // Cần lấy từ context hoặc config
      ngayTao: DateTime.now(),
      ngayCapNhat: DateTime.now(),
      nguoiTao: 'current_user', // Cần lấy từ auth
      nguoiCapNhat: 'current_user', // Cần lấy từ auth
      isActive: true,
    );
  }

  void _handleSave() {
    if (!isEditing) return;

    final request = _createAssetRequest();
    final bloc = context.read<AssetManagementBloc>();
    bloc.add(CreateAssetEvent(context, request));
  }
}
