import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/input/common_checkbox_input.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/uuid_generator.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/bloc/asset_group_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/bloc/asset_group_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/provider/asset_group_provide.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/request/asset_group_request.dart';

class AssetGroupDetail extends StatefulWidget {
  final AssetGroupProvider provider;
  const AssetGroupDetail({super.key, required this.provider});

  @override
  State<AssetGroupDetail> createState() => _AssetGroupDetailState();
}

class _AssetGroupDetailState extends State<AssetGroupDetail> {
  AssetGroupDto? data;
  bool isEditing = false;
  bool isActive = false;
  String? nameAssetGroup;
  String idCongTy = 'ct001';
  DateTime? createdAt;

  TextEditingController controllerIdAssetGroup = TextEditingController();
  TextEditingController controllerNameAssetGroup = TextEditingController();
  TextEditingController controllerIdAndNameAssetGroup = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didUpdateWidget(covariant AssetGroupDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.provider.dataDetail != data) {
      log('message didUpdateWidget: ${widget.provider.dataDetail?.toJson()}');
      _initData();
    }
  }

  @override
  void dispose() {
    controllerIdAssetGroup.dispose();
    controllerNameAssetGroup.dispose();
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
    log('message _initData: ${widget.provider.dataDetail}');
    if (widget.provider.dataDetail != null) {
      setState(() {
        isEditing = false;
      });
      data = widget.provider.dataDetail;
      controllerIdAssetGroup.text = data!.id ?? '';
      controllerNameAssetGroup.text = data!.tenNhom ?? '';
      isActive = data!.hieuLuc ?? false;
      getNameAssetGroup();
    } else {
      log('message _initData: ${widget.provider.isCreate}');
      data = null;
      setState(() {
        isEditing = widget.provider.isCreate;
      });
      controllerIdAssetGroup.text = UUIDGenerator.generateWithFormat('NTS****');
      controllerNameAssetGroup.text = '';
      getNameAssetGroup();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: _buildHeaderDetail(),
        ),
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
              // detail
              CommonFormInput(
                label: 'Nhóm tài sản',
                controller: controllerIdAndNameAssetGroup,
                isEditing: false,
                textContent: controllerIdAndNameAssetGroup.text,
                onChanged: (value) {
                  // _checkForChanges();
                },
              ),
              CommonFormInput(
                label: 'Mã nhóm tài sản',
                controller: controllerIdAssetGroup,
                isEditing: false,
                textContent: controllerIdAssetGroup.text,
                onChanged: (value) {
                  // _checkForChanges();
                  getNameAssetGroup();
                },
              ),
              CommonFormInput(
                label: 'Tên nhóm tài sản',
                controller: controllerNameAssetGroup,
                isEditing: isEditing,
                textContent: controllerNameAssetGroup.text,
                onChanged: (value) {
                  // _checkForChanges();
                  getNameAssetGroup();
                },
              ),
              CommonCheckboxInput(
                label: 'Có hiệu lực',
                value: isActive,
                isEditing: isEditing,
                isDisabled: !isEditing,
                onChanged: (value) {
                  setState(() {
                    isActive = value;
                    log('message isActive: $isActive');
                  });
                },
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
          mainAxisAlignment: MainAxisAlignment.start,
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
                });
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
    if (data == null) {
      AssetGroupRequest request = AssetGroupRequest(
        id: controllerIdAssetGroup.text,
        tenNhom: controllerNameAssetGroup.text,
        isActive: isActive,
        hieuLuc: isActive,
        idCongTy: 'CT001',
        ngayTao: DateTime.parse(getDateNow()),
        ngayCapNhat: DateTime.parse(getDateNow()),
        nguoiTao: 'use001',
        nguoiCapNhat: 'use001',
      );

      context.read<AssetGroupBloc>().add(
        CreateAssetGroupEvent(context, request),
      );
    } else {
      AssetGroupRequest request = AssetGroupRequest(
        id: controllerIdAssetGroup.text,
        tenNhom: controllerNameAssetGroup.text,
        isActive: isActive,
        hieuLuc: isActive,
        idCongTy: 'CT001',
        ngayTao: DateTime.parse(getDateNow()),
        ngayCapNhat: DateTime.parse(getDateNow()),
        nguoiTao: 'use001',
        nguoiCapNhat: 'use001',
      );

      context.read<AssetGroupBloc>().add(
        UpdateAssetGroupEvent(context, request, data!.id!),
      );
    }
  }
  // void _cancelChanges() {
  //   log('message: _cancelChanges');
  // }

  void getNameAssetGroup() {
    controllerIdAndNameAssetGroup.text =
        '${controllerIdAssetGroup.text} - ${controllerNameAssetGroup.text}';
    // return;
  }
}
