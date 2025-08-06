import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/component/original_asset_information.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/model/asset_category_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';

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

  List<AssetCategoryDto> listAssetCategory = [];
  List<AssetGroupDto> listAssetGroup = [];
  List<DropdownMenuItem<AssetCategoryDto>> itemsAssetCategory = [];
  List<DropdownMenuItem<AssetGroupDto>> itemsAssetGroup = [];

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

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() {
    if (widget.provider.dataDetail != null) {
      data = widget.provider.dataDetail;
      isEditing = false;
    } else {
      isEditing = true;
    }
    _initController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              buildOriginalAssetInfomation(
                context,
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
                listAssetGroup: listAssetGroup,
                itemsAssetCategory: itemsAssetCategory,
                itemsAssetGroup: itemsAssetGroup,
              ),
              // _buildInfoAssetHandoverMobile(isWideScreen),
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
              onPressed: () {},
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
    ctrlMaTaiSan.text = data?.id ?? '';
    ctrlIdNhomTaiSan.text = data?.tenNhom ?? '';
    ctrlNguyenGia.text = data?.nguyenGia.toString() ?? '';
    ctrlGiaTriKhauHaoBanDau.text = data?.giaTriKhauHaoBanDau.toString() ?? '';
    ctrlKyKhauHaoBanDau.text = data?.kyKhauHaoBanDau.toString() ?? '';
    ctrlGiaTriThanhLy.text = data?.giaTriThanhLy.toString() ?? '';
    ctrlTenMoHinh.text = data?.idMoHinhTaiSan ?? '';
    ctrlPhuongPhapKhauHao.text = data?.giaTriKhauHaoBanDau.toString() ?? '';
    ctrlSoKyKhauHao.text = data?.soKyKhauHao.toString() ?? '';
    ctrlTaiKhoanTaiSan.text = data?.taiKhoanTaiSan.toString() ?? '';
    ctrlTaiKhoanKhauHao.text = data?.taiKhoanKhauHao.toString() ?? '';
    ctrlTaiKhoanChiPhi.text = data?.taiKhoanChiPhi.toString() ?? '';
    ctrlTenNhom.text = data?.idNhomTaiSan ?? '';
    ctrlNgayVaoSo.text = data?.ngayVaoSo.toString() ?? '';
    ctrlNgaySuDung.text = data?.ngaySuDung.toString() ?? '';
  }
}
