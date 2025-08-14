import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/component/asset_depreciation_information.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_depreciation_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';

class AssetDepreciationDetail extends StatefulWidget {
  const AssetDepreciationDetail({super.key, required this.provider});
  final AssetManagementProvider provider;

  @override
  State<AssetDepreciationDetail> createState() =>
      _AssetDepreciationDetailState();
}

class _AssetDepreciationDetailState extends State<AssetDepreciationDetail> {
  AssetDepreciationDto? data;

  TextEditingController ctrlButToanKhauHao = TextEditingController();
  TextEditingController ctrlTaiSan = TextEditingController();
  TextEditingController ctrlTaiSanKhauHao = TextEditingController();
  TextEditingController ctrlTaiSanChiPhi = TextEditingController();
  TextEditingController ctrlGiaTriKhauHao = TextEditingController();
  TextEditingController ctrlKyKhauHao = TextEditingController();
  TextEditingController ctrlTrangThaiButToan = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didUpdateWidget(covariant AssetDepreciationDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.provider.dataDepreciationDetail != data) {
      log('message didUpdateWidget: ${widget.provider.dataDepreciationDetail?.toJson()}');
      _initData();
    }
  }

  _initData() {
    if (widget.provider.dataDepreciationDetail != null) {
      data = widget.provider.dataDepreciationDetail;
    } else {
      data = null;
    }
    _initController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: buildDepreciationInformation(
        context,
        ctrlButToanKhauHao: ctrlButToanKhauHao,
        ctrlTaiSan: ctrlTaiSan,
        ctrlTaiSanKhauHao: ctrlTaiSanKhauHao,
        ctrlTaiSanChiPhi: ctrlTaiSanChiPhi,
        ctrlGiaTriKhauHao: ctrlGiaTriKhauHao,
        ctrlKyKhauHao: ctrlKyKhauHao,
        ctrlTrangThaiButToan: ctrlTrangThaiButToan,
        provider: widget.provider,
      ),
    );
  }

  void _initController() {
    // If data is null, set all controllers to empty string
    if (data == null) {
      ctrlButToanKhauHao.text = '';
      ctrlTaiSan.text = '';
      ctrlTaiSanKhauHao.text = '';
      ctrlTaiSanChiPhi.text = '';
      ctrlGiaTriKhauHao.text = '';
      ctrlKyKhauHao.text = '';
      ctrlTrangThaiButToan.text = '';
    } else {
      ctrlButToanKhauHao.text =  'Khấu hao ${data!.id} - ${data!.tenTaiSan} ${data!.soKyKhauHao}';
      ctrlTaiSan.text = '${data!.id} - ${data!.tenTaiSan}';
      ctrlTaiSanKhauHao.text = data!.taiKhoanKhauHao.toString();
      ctrlTaiSanChiPhi.text = data!.taiKhoanChiPhi.toString();
      ctrlGiaTriKhauHao.text = data!.giaTriKhauHao.toString();
      ctrlKyKhauHao.text = data!.soKyKhauHao.toString();
      ctrlTrangThaiButToan.text = "Hoàn thành";
      // If data is not null, set controllers with data values
    }
  }

}
