import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/asset-management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset-management/provider/asset_management_provider.dart';

class AssetDetail extends StatefulWidget {
  const AssetDetail({super.key, required this.provider});
  final AssetManagementProvider provider;

  @override
  State<AssetDetail> createState() => _AssetDetailState();
}

class _AssetDetailState extends State<AssetDetail> {
  AssetManagementDto? data;
  Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() {
    if (widget.provider.dataDetail != null) {
      data = widget.provider.dataDetail;
    }
    _initController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      height: MediaQuery.of(context).size.height * 0.5,
    );
  }

  void _initController() {
    controllers.clear();
    controllers['id'] = TextEditingController(text: data?.id ?? '');
    controllers['tenTaiSan'] = TextEditingController(text: data?.tenTaiSan ?? '');
    controllers['idNhomTaiSan'] = TextEditingController(text: data?.idNhomTaiSan ?? '');
    controllers['nguyenGia'] = TextEditingController(text: data?.nguyenGia?.toString() ?? '');
    controllers['giaTriKhauHaoBanDau'] = TextEditingController(text: data?.giaTriKhauHaoBanDau?.toString() ?? '');
    controllers['kyKhauHaoBanDau'] = TextEditingController(text: data?.kyKhauHaoBanDau?.toString() ?? '');
    controllers['giaTriThanhLy'] = TextEditingController(text: data?.giaTriThanhLy?.toString() ?? '');
    controllers['tenMoHinh'] = TextEditingController(text: data?.tenMoHinh ?? '');
    controllers['phuongPhapKhauHao'] = TextEditingController(text: data?.phuongPhapKhauHao ?? '');
    controllers['soKyKhauHao'] = TextEditingController(text: data?.soKyKhauHao?.toString() ?? '');
    controllers['taiKhoanTaiSan'] = TextEditingController(text: data?.taiKhoanTaiSan.toString() ?? '');
    controllers['taiKhoanKhauHao'] = TextEditingController(text: data?.taiKhoanKhauHao.toString() ?? '');
    controllers['taiKhoanChiPhi'] = TextEditingController(text: data?.taiKhoanChiPhi.toString() ?? '');
    controllers['tenNhom'] = TextEditingController(text: data?.tenNhom ?? '');
    controllers['ngayVaoSo'] = TextEditingController(text: data?.ngayVaoSo?.toString() ?? '');
    controllers['ngaySuDung'] = TextEditingController(text: data?.ngaySuDung?.toString() ?? '');
    controllers['tenDuAn'] = TextEditingController(text: data?.tenDuAn ?? '');
    controllers['tenNguonKinhPhi'] = TextEditingController(text: data?.tenNguonKinhPhi ?? '');
    controllers['kyHieu'] = TextEditingController(text: data?.kyHieu ?? '');
    controllers['soKyHieu'] = TextEditingController(text: data?.soKyHieu ?? '');
    controllers['congSuat'] = TextEditingController(text: data?.congSuat ?? '');
    controllers['nuocSanXuat'] = TextEditingController(text: data?.nuocSanXuat ?? '');
    controllers['namSanXuat'] = TextEditingController(text: data?.namSanXuat?.toString() ?? '');
    controllers['lyDoTang'] = TextEditingController(text: '');
    controllers['hienTrang'] = TextEditingController(text: '');
    controllers['soLuong'] = TextEditingController(text: data?.soLuong?.toString() ?? '');
    controllers['donViTinh'] = TextEditingController(text: '');
    controllers['ghiChu'] = TextEditingController(text: data?.ghiChu ?? '');
    controllers['idDonViBanDau'] = TextEditingController(text: '');
    controllers['idDonViHienThoi'] = TextEditingController(text: '');
  }
}
