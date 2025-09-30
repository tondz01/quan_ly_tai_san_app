import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
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

  final NumberFormat _vnNumber = NumberFormat('#,##0', 'vi_VN');
  String _fmtNum(double? v) {
    if (v == null) return '';
    try {
      return '${_vnNumber.format(v)}đ';
    } catch (_) {
      return v.toString();
    }
  }

  String _fmtDate(DateTime? d) {
    if (d == null) return '';
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd/$mm/$yyyy';
  }

  // Controllers for detail fields aligned with list columns
  final TextEditingController ctrlSoThe = TextEditingController();
  final TextEditingController ctrlTenTaiSan = TextEditingController();
  final TextEditingController ctrlNguonVon = TextEditingController();
  final TextEditingController ctrlMaTk = TextEditingController();
  final TextEditingController ctrlNgayTinhKhao = TextEditingController();
  final TextEditingController ctrlThangKh = TextEditingController();
  final TextEditingController ctrlNguyenGia = TextEditingController();
  final TextEditingController ctrlKhauHaoBanDau = TextEditingController();
  final TextEditingController ctrlKhauHaoPsdk = TextEditingController();
  final TextEditingController ctrlGtclBanDau = TextEditingController();
  final TextEditingController ctrlKhauHaoPsck = TextEditingController();
  final TextEditingController ctrlGtclHienTai = TextEditingController();
  final TextEditingController ctrlKhauHaoBinhQuan = TextEditingController();
  final TextEditingController ctrlSoTien = TextEditingController();
  final TextEditingController ctrlChenhLech = TextEditingController();
  final TextEditingController ctrlKhKyTruoc = TextEditingController();
  final TextEditingController ctrlClKyTruoc = TextEditingController();
  final TextEditingController ctrlHsdCkh = TextEditingController();
  final TextEditingController ctrlTkNo = TextEditingController();
  final TextEditingController ctrlTkCo = TextEditingController();
  final TextEditingController ctrlDtgt = TextEditingController();
  final TextEditingController ctrlDtth = TextEditingController();
  final TextEditingController ctrlKmcp = TextEditingController();
  final TextEditingController ctrlGhiChuKhao = TextEditingController();
  final TextEditingController ctrlUserId = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didUpdateWidget(covariant AssetDepreciationDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.provider.dataDepreciationDetail != data) {
      log(
        'message didUpdateWidget: ${widget.provider.dataDepreciationDetail?.toJson()}',
      );
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
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                CommonFormInput(
                  label: 'Số thẻ',
                  controller: ctrlSoThe,
                  isEditing: false,
                  textContent: ctrlSoThe.text,
                  fieldName: 'soThe',
                ),
                CommonFormInput(
                  label: 'Tên tài sản',
                  controller: ctrlTenTaiSan,
                  isEditing: false,
                  textContent: ctrlTenTaiSan.text,
                  fieldName: 'tenTaiSan',
                ),
                CommonFormInput(
                  label: 'Nguồn vốn',
                  controller: ctrlNguonVon,
                  isEditing: false,
                  textContent: ctrlNguonVon.text,
                  fieldName: 'nguonVon',
                ),
                CommonFormInput(
                  label: 'Mã tài khoản',
                  controller: ctrlMaTk,
                  isEditing: false,
                  textContent: ctrlMaTk.text,
                  fieldName: 'maTk',
                ),
                CommonFormInput(
                  label: 'Ngày tính khấu hao',
                  controller: ctrlNgayTinhKhao,
                  isEditing: false,
                  textContent: ctrlNgayTinhKhao.text,
                  fieldName: 'ngayTinhKhao',
                ),
                CommonFormInput(
                  label: 'Tháng khấu hao',
                  controller: ctrlThangKh,
                  isEditing: false,
                  textContent: ctrlThangKh.text,
                  fieldName: 'thangKh',
                ),
                CommonFormInput(
                  label: 'Nguyên giá',
                  controller: ctrlNguyenGia,
                  isEditing: false,
                  textContent: ctrlNguyenGia.text,
                  fieldName: 'nguyenGia',
                  isMoney: true,
                ),
                CommonFormInput(
                  label: 'Khấu hao ban đầu',
                  controller: ctrlKhauHaoBanDau,
                  isEditing: false,
                  textContent: ctrlKhauHaoBanDau.text,
                  fieldName: 'khauHaoBanDau',
                  isMoney: true,
                ),
                CommonFormInput(
                  label: 'Khấu hao PSDK',
                  controller: ctrlKhauHaoPsdk,
                  isEditing: false,
                  textContent: ctrlKhauHaoPsdk.text,
                  fieldName: 'khauHaoPsdk',
                  isMoney: true,
                ),
                CommonFormInput(
                  label: 'GTCL ban đầu',
                  controller: ctrlGtclBanDau,
                  isEditing: false,
                  textContent: ctrlGtclBanDau.text,
                  fieldName: 'gtclBanDau',
                  isMoney: true,
                ),
                CommonFormInput(
                  label: 'DTGT',
                  controller: ctrlDtgt,
                  isEditing: false,
                  textContent: ctrlDtgt.text,
                  fieldName: 'dtgt',
                ),
                CommonFormInput(
                  label: 'DTTH',
                  controller: ctrlDtth,
                  isEditing: false,
                  textContent: ctrlDtth.text,
                  fieldName: 'dtth',
                ),
                CommonFormInput(
                  label: 'Ghi chú khấu hao',
                  controller: ctrlGhiChuKhao,
                  isEditing: false,
                  textContent: ctrlGhiChuKhao.text,
                  fieldName: 'ghiChuKhao',
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                CommonFormInput(
                  label: 'Khấu hao PSCK',
                  controller: ctrlKhauHaoPsck,
                  isEditing: false,
                  textContent: ctrlKhauHaoPsck.text,
                  fieldName: 'khauHaoPsck',
                  isMoney: true,
                ),
                CommonFormInput(
                  label: 'GTCL hiện tại',
                  controller: ctrlGtclHienTai,
                  isEditing: false,
                  textContent: ctrlGtclHienTai.text,
                  fieldName: 'gtclHienTai',
                  isMoney: true,
                ),
                CommonFormInput(
                  label: 'Khấu hao bình quân',
                  controller: ctrlKhauHaoBinhQuan,
                  isEditing: false,
                  textContent: ctrlKhauHaoBinhQuan.text,
                  fieldName: 'khauHaoBinhQuan',
                  isMoney: true,
                ),
                CommonFormInput(
                  label: 'Số tiền',
                  controller: ctrlSoTien,
                  isEditing: false,
                  textContent: ctrlSoTien.text,
                  fieldName: 'soTien',
                  isMoney: true,
                ),
                CommonFormInput(
                  label: 'Chênh lệch',
                  controller: ctrlChenhLech,
                  isEditing: false,
                  textContent: ctrlChenhLech.text,
                  fieldName: 'chenhLech',
                  isMoney: true,
                ),
                CommonFormInput(
                  label: 'Khấu hao kỳ trước',
                  controller: ctrlKhKyTruoc,
                  isEditing: false,
                  textContent: ctrlKhKyTruoc.text,
                  fieldName: 'khKyTruoc',
                  isMoney: true,
                ),
                CommonFormInput(
                  label: 'Chênh lệch kỳ trước',
                  controller: ctrlClKyTruoc,
                  isEditing: false,
                  textContent: ctrlClKyTruoc.text,
                  fieldName: 'clKyTruoc',
                  isMoney: true,
                ),
                CommonFormInput(
                  label: 'HSDCKH',
                  controller: ctrlHsdCkh,
                  isEditing: false,
                  textContent: ctrlHsdCkh.text,
                  fieldName: 'hsdCkh',
                  isMoney: true,
                ),
                CommonFormInput(
                  label: 'Tài khoản nợ',
                  controller: ctrlTkNo,
                  isEditing: false,
                  textContent: ctrlTkNo.text,
                  fieldName: 'tkNo',
                ),
                CommonFormInput(
                  label: 'Tài khoản có',
                  controller: ctrlTkCo,
                  isEditing: false,
                  textContent: ctrlTkCo.text,
                  fieldName: 'tkCo',
                ),

                CommonFormInput(
                  label: 'KMCP',
                  controller: ctrlKmcp,
                  isEditing: false,
                  textContent: ctrlKmcp.text,
                  fieldName: 'kmcp',
                ),
                CommonFormInput(
                  label: 'Người tạo',
                  controller: ctrlUserId,
                  isEditing: false,
                  textContent: ctrlUserId.text,
                  fieldName: 'userId',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _initController() {
    if (data == null) {
      ctrlSoThe.text = '';
      ctrlTenTaiSan.text = '';
      ctrlNguonVon.text = '';
      ctrlMaTk.text = '';
      ctrlNgayTinhKhao.text = '';
      ctrlThangKh.text = '';
      ctrlNguyenGia.text = '';
      ctrlKhauHaoBanDau.text = '';
      ctrlKhauHaoPsdk.text = '';
      ctrlGtclBanDau.text = '';
      ctrlKhauHaoPsck.text = '';
      ctrlGtclHienTai.text = '';
      ctrlKhauHaoBinhQuan.text = '';
      ctrlSoTien.text = '';
      ctrlChenhLech.text = '';
      ctrlKhKyTruoc.text = '';
      ctrlClKyTruoc.text = '';
      ctrlHsdCkh.text = '';
      ctrlTkNo.text = '';
      ctrlTkCo.text = '';
      ctrlDtgt.text = '';
      ctrlDtth.text = '';
      ctrlKmcp.text = '';
      ctrlGhiChuKhao.text = '';
      ctrlUserId.text = '';
    } else {
      ctrlSoThe.text = data!.soThe ?? '';
      ctrlTenTaiSan.text = data!.tenTaiSan ?? '';
      ctrlNguonVon.text = data!.nguonVon ?? '';
      ctrlMaTk.text = data!.maTk ?? '';
      ctrlNgayTinhKhao.text = _fmtDate(data!.ngayTinhKhao);
      ctrlThangKh.text = data!.thangKh?.toString() ?? '';
      ctrlNguyenGia.text = _fmtNum(data!.nguyenGia);
      ctrlKhauHaoBanDau.text = _fmtNum(data!.khauHaoBanDau);
      ctrlKhauHaoPsdk.text = _fmtNum(data!.khauHaoPsdk);
      ctrlGtclBanDau.text = _fmtNum(data!.gtclBanDau);
      ctrlKhauHaoPsck.text = _fmtNum(data!.khauHaoPsck);
      ctrlGtclHienTai.text = _fmtNum(data!.gtclHienTai);
      ctrlKhauHaoBinhQuan.text = _fmtNum(data!.khauHaoBinhQuan);
      ctrlSoTien.text = _fmtNum(data!.soTien);
      ctrlChenhLech.text = _fmtNum(data!.chenhLech);
      ctrlKhKyTruoc.text = _fmtNum(data!.khKyTruoc);
      ctrlClKyTruoc.text = _fmtNum(data!.clKyTruoc);
      ctrlHsdCkh.text = _fmtNum(data!.hsdCkh);
      ctrlTkNo.text = data!.tkNo ?? '';
      ctrlTkCo.text = data!.tkCo ?? '';
      ctrlDtgt.text = data!.dtgt ?? '';
      ctrlDtth.text = data!.dtth ?? '';
      ctrlKmcp.text = data!.kmcp ?? '';
      ctrlGhiChuKhao.text = data!.ghiChuKhao ?? '';
      ctrlUserId.text = data!.userId ?? '';
    }
  }
}
