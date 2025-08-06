import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/model/asset_category_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/provider/asset_category_provide.dart';

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
  String idCongTy = 'ct001';
  DateTime? createdAt;

  Map<String, TextEditingController> controllers = {};
  final List<DropdownMenuItem<String>> phuongPhapKhauHaos = [
    const DropdownMenuItem(value: '1', child: Text('Đường thẳng')),
  ];
  final List<DropdownMenuItem<String>> loaiKyKhauHao = [
    const DropdownMenuItem(value: 'Tháng', child: Text('Tháng')),
    const DropdownMenuItem(value: 'Năm', child: Text('Năm')),
  ];

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

  _initData() {
    if (widget.provider.dataDetail != null) {
      data = widget.provider.dataDetail;
      isEditing = false;
      // controllerIdAssetCategory.text = data!.id ?? '';
      // controllerNameAssetCategory.text = data!.tenNhom ?? '';
      // isActive = data!.hieuLuc ?? false;
    } else {
      // log('message _initData: ${widget.provider.isCreate}');
      data = null;
      isEditing = widget.provider.isCreate;
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
              CommonFormInput(
                label: 'Tên mô hình tài sản',
                controller: ctrlTenMoHinh,
                isEditing: isEditing,
                textContent: isEditing ? '' : data!.tenMoHinh ?? '',
                onChanged: (value) {
                  // _checkForChanges();
                },
              ),
              CommonFormInput(
                label: 'Phương pháp khấu hao',
                controller: ctrlPhuongPhapKhauHao,
                isEditing: isEditing,
                textContent: '',
                isDropdown: true,
                items: phuongPhapKhauHaos,
                onChanged: (value) {
                  log('message phuongPhapKhauHao: $value');
                },
              ),
              CommonFormInput(
                label: 'Kỳ khấu hao',
                controller: ctrlKyKhauHao,
                isEditing: isEditing,
                textContent: ctrlKyKhauHao.text,
                inputType: TextInputType.number,
              ),
              CommonFormInput(
                label: 'Loại kỳ khấu hao',
                controller: ctrlLoaiKyKhauHao,
                isEditing: isEditing,
                textContent: '',
                isDropdown: true,
                items: loaiKyKhauHao,
                onChanged: (value) {
                  log('message loaiKyKhauHao: $value');
                },
              ),
              CommonFormInput(
                label: 'Tài khoản tài sản',
                controller: ctrlTaiKhoanTaiSan,
                isEditing: isEditing,
                textContent: '',
                // inputType: TextInputType.number,
              ),
              CommonFormInput(
                label: 'Tài khoản khấu hao',
                controller: ctrlTaiKhoanKhauHao,
                isEditing: isEditing,
                textContent: '',
              ),
              CommonFormInput(
                label: 'Tài khoản chi phí',
                controller: ctrlTaiKhoanChiPhi,
                isEditing: isEditing,
                textContent: '',
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

  // void _saveChanges() {
  //   log('message: _saveChanges');
  //   AssetCategoryRequest request = AssetCategoryRequest(
  //     id: controllerIdAssetCategory.text,
  //     tenNhom: controllerNameAssetCategory.text,
  //     isActive: isActive,
  //     hieuLuc: isActive,
  //     idCongTy: 'ct001',
  //     ngayTao: DateTime.parse(getDateNow()),
  //     ngayCapNhat: DateTime.parse(getDateNow()),
  //     nguoiTao: 'TK001',
  //     nguoiCapNhat: 'TK001',
  //   );

  //   widget.provider.createAssetCategory(context, request);
  // }

  void _cancelChanges() {
    log('message: _cancelChanges');
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
