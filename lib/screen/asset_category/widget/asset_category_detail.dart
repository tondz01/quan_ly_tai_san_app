import 'dart:convert';
import 'dart:developer';
import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/bloc/asset_category_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/bloc/asset_category_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/component/asset_category_form.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/model/asset_category_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/provider/asset_category_provide.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';

class AssetCategoryDetail extends StatefulWidget {
  final AssetCategoryProvider provider;
  final bool? isEditing;
  const AssetCategoryDetail({
    super.key,
    required this.provider,
    this.isEditing = false,
  });

  @override
  State<AssetCategoryDetail> createState() => _AssetCategoryDetailState();
}

class _AssetCategoryDetailState extends State<AssetCategoryDetail> {
  AssetCategoryDto? data;
  bool isEditing = false;
  bool isActive = false;
  String? nameAssetCategory;
  String idCongTy = '';
  DateTime? createdAt;

  String? loaiKyKhauHao;
  String? phuongPhapKhauHao;

  final TextEditingController ctrlIdMoHinh = TextEditingController();
  final TextEditingController ctrlTenMoHinh = TextEditingController();
  final TextEditingController ctrlPhuongPhapKhauHao = TextEditingController();
  final TextEditingController ctrlKyKhauHao = TextEditingController();
  final TextEditingController ctrlLoaiKyKhauHao = TextEditingController();
  final TextEditingController ctrlTaiKhoanTaiSan = TextEditingController();
  final TextEditingController ctrlTaiKhoanKhauHao = TextEditingController();
  final TextEditingController ctrlTaiKhoanChiPhi = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didUpdateWidget(covariant AssetCategoryDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.provider.dataDetail != data) {
      log('message didUpdateWidget: ${widget.provider.dataDetail?.toJson()}');
      _initData();
    }
  }

  @override
  void dispose() {
    ctrlTenMoHinh.dispose();
    ctrlPhuongPhapKhauHao.dispose();
    ctrlKyKhauHao.dispose();
    ctrlLoaiKyKhauHao.dispose();
    ctrlTaiKhoanTaiSan.dispose();
    ctrlTaiKhoanKhauHao.dispose();
    ctrlTaiKhoanChiPhi.dispose();
    super.dispose();
  }

  /// Hàm lấy thời gian hiện tại theo định dạng ISO 8601
  String getDateNow() {
    final now = DateTime.now();
    final utc = now.toUtc();
    final year = utc.year.toString().padLeft(4, '0');
    final month = utc.month.toString().padLeft(2, '0');
    final day = utc.day.toString().padLeft(2, '0');
    final hour = utc.hour.toString().padLeft(2, '0');
    final minute = utc.minute.toString().padLeft(2, '0');
    final second = utc.second.toString().padLeft(2, '0');
    final millisecond = utc.millisecond.toString().padLeft(3, '0');

    return '$year-$month-${day}T$hour:$minute:$second.$millisecond+00:00';
  }

  String generateId4Digits() {
    final random = Random();
    final number = random.nextInt(10000); // từ 0 đến 9999
    return number.toString().padLeft(4, '0'); // thêm số 0 ở đầu cho đủ 4 chữ số
  }

  _initData() {
    idCongTy = widget.provider.userInfo?.idCongTy ?? '';
    if (widget.provider.dataDetail != null) {
      setState(() {
        isEditing = false;
      });
      data = widget.provider.dataDetail;
      ctrlIdMoHinh.text = data?.id ?? '';
      ctrlPhuongPhapKhauHao.text = data?.phuongPhapKhauHao.toString() ?? '';
      ctrlKyKhauHao.text = data?.kyKhauHao.toString() ?? '';
      ctrlLoaiKyKhauHao.text = data?.loaiKyKhauHao.toString() ?? '';
      ctrlTaiKhoanTaiSan.text = data?.taiKhoanTaiSan ?? '';
      ctrlTaiKhoanKhauHao.text = data?.taiKhoanKhauHao ?? '';
      ctrlTaiKhoanChiPhi.text = data?.taiKhoanChiPhi ?? '';
      loaiKyKhauHao = data?.loaiKyKhauHao;
      phuongPhapKhauHao = data?.phuongPhapKhauHao.toString();
      // isActive = data!.hieuLuc ?? false;
    } else {
      // log('message _initData: ${widget.provider.isCreate}');
      data = null;
      setState(() {
        isEditing = widget.provider.isCreate;
      });
      ctrlIdMoHinh.text = generateId4Digits();
      ctrlPhuongPhapKhauHao.text = '';
      ctrlKyKhauHao.text = '';
      ctrlLoaiKyKhauHao.text = '';
      ctrlTaiKhoanTaiSan.text = '';
      ctrlTaiKhoanKhauHao.text = '';
      ctrlTaiKhoanChiPhi.text = '';
      loaiKyKhauHao = '';
      phuongPhapKhauHao = '';
      // controllerIdAssetCategory.text = '';
      // controllerNameAssetCategory.text = '';
    }
    initController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderDetail(),
        const SizedBox(height: 5),
        buildAssetCategoryForm(
          context: context,
          isEditing: isEditing,
          data: data,
          ctrlIdMohinh: ctrlIdMoHinh,
          ctrlTenMoHinh: ctrlTenMoHinh,
          ctrlPhuongPhapKhauHao: ctrlPhuongPhapKhauHao,
          ctrlKyKhauHao: ctrlKyKhauHao,
          ctrlLoaiKyKhauHao: ctrlLoaiKyKhauHao,
          ctrlTaiKhoanTaiSan: ctrlTaiKhoanTaiSan,
          ctrlTaiKhoanKhauHao: ctrlTaiKhoanKhauHao,
          ctrlTaiKhoanChiPhi: ctrlTaiKhoanChiPhi,
          onChangedPhuongPhapKhauHaos: (value) {
            log('message phuongPhapKhauHao: $value');
            phuongPhapKhauHao = value;
          },
          onChangedLoaiKyKhauHaos: (value) {
            log('message loaiKyKhauHao: $value');
            loaiKyKhauHao = value;
          },
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
              onPressed: () {
                _saveChanges();
              },
            ),
            const SizedBox(width: 8),
            MaterialTextButton(
              text: 'Hủy',
              icon: Icons.cancel,
              backgroundColor: ColorValue.error,
              foregroundColor: Colors.white,
              onPressed: () {
                setState(() {
                  isEditing = false;
                  _initData();
                });
                
                // widget.provider.onCloseDetail(context);
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

  void _saveChanges() {
    log('message: _saveChanges');
    UserInfoDTO userInfo = widget.provider.userInfo!;
    AssetCategoryDto request = AssetCategoryDto(
      id: ctrlIdMoHinh.text,
      tenMoHinh: ctrlTenMoHinh.text,
      phuongPhapKhauHao: int.tryParse(phuongPhapKhauHao ?? '0') ?? 0,
      kyKhauHao: int.tryParse(ctrlKyKhauHao.text) ?? 0,
      loaiKyKhauHao: loaiKyKhauHao,
      taiKhoanTaiSan: ctrlTaiKhoanTaiSan.text,
      taiKhoanKhauHao: ctrlTaiKhoanKhauHao.text,
      taiKhoanChiPhi: ctrlTaiKhoanChiPhi.text,
      idCongTy: idCongTy,
      ngayTao: getDateNow(),
      ngayCapNhat: getDateNow(),
      nguoiTao: userInfo.id,
      nguoiCapNhat: userInfo.id,
      isActive: isActive,
    );

    log('message request: ${jsonEncode(request)}');
    if (data == null) {
      context.read<AssetCategoryBloc>().add(
        CreateAssetCategoryEvent(context, request),
      );
    } else {
      context.read<AssetCategoryBloc>().add(
        UpdateAssetCategoryEvent(context, request, data!.id ?? ''),
      );
    }
  }


  String getDepreciationMethod(int type) {
    String nameDepreciationMethod = 'Đường thẳng';
    switch (type) {
      case 1:
        nameDepreciationMethod = 'Đường thẳng';
    }
    return nameDepreciationMethod;
  }

  initController() {
    ctrlTenMoHinh.text = data?.tenMoHinh ?? '';
    ctrlPhuongPhapKhauHao.text = data?.phuongPhapKhauHao.toString() ?? '';
    ctrlKyKhauHao.text = data?.kyKhauHao.toString() ?? '';
    ctrlLoaiKyKhauHao.text = data?.loaiKyKhauHao ?? '';
    ctrlTaiKhoanTaiSan.text = data?.taiKhoanTaiSan ?? '';
    ctrlTaiKhoanKhauHao.text = data?.taiKhoanKhauHao ?? '';
    ctrlTaiKhoanChiPhi.text = data?.taiKhoanChiPhi ?? '';
  }
}
