import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/input/common_checkbox_input.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/bloc/ccdc_group_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/bloc/ccdc_group_event.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/model/ccdc_group.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/provider/ccdc_group_provide.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';

class CcdcGroupDetail extends StatefulWidget {
  final CcdcGroupProvider provider;
  const CcdcGroupDetail({super.key, required this.provider});

  @override
  State<CcdcGroupDetail> createState() => _CcdcGroupDetailState();
}

class _CcdcGroupDetailState extends State<CcdcGroupDetail> {
  CcdcGroup? data;
  bool isEditing = false;
  bool isActive = false;
  String? nameCcdcGroup;
  String idCongTy = 'ct001';
  DateTime? createdAt;

  TextEditingController controllerIdCcdcGroup = TextEditingController();
  TextEditingController controllerNameCcdcGroup = TextEditingController();
  Map<String, bool> validationErrors = {};

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didUpdateWidget(covariant CcdcGroupDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.provider.dataDetail != data) {
      _initData();
    }
  }

  @override
  void dispose() {
    controllerIdCcdcGroup.dispose();
    controllerNameCcdcGroup.dispose();
    super.dispose();
  }

  // Thêm: Hàm validate form trước khi lưu
  bool _validateForm() {
    Map<String, bool> newValidationErrors = {};
    if (data == null) {
      if (controllerIdCcdcGroup.text.isEmpty) {
        newValidationErrors['id'] = true;
      }
    }
    if (controllerNameCcdcGroup.text.isEmpty) {
      newValidationErrors['tenNhom'] = true;
    }

    bool hasChanges = !mapEquals(validationErrors, newValidationErrors);
    if (hasChanges) {
      setState(() {
        validationErrors = newValidationErrors;
      });
    }
    return newValidationErrors.isEmpty;
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
      setState(() {
        isEditing = false;
      });
      data = widget.provider.dataDetail;
      controllerIdCcdcGroup.text = data!.id ?? '';
      controllerNameCcdcGroup.text = data!.ten ?? '';
      isActive = data!.hieuLuc ?? false;
    } else {
      data = null;
      setState(() {
        isEditing = widget.provider.isCreate;
      });
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
              CommonFormInput(
                label: 'Mã nhóm ccdc',
                controller: controllerIdCcdcGroup,
                isEditing: data == null ? isEditing : false,
                textContent: controllerIdCcdcGroup.text,
                width: double.infinity,
                validationErrors: validationErrors,
                fieldName: 'id',
                isRequired: true,
              ),
              CommonFormInput(
                label: 'Tên nhóm ccdc',
                controller: controllerNameCcdcGroup,
                isEditing: isEditing,
                textContent: controllerNameCcdcGroup.text,
                width: double.infinity,
                validationErrors: validationErrors,
                fieldName: 'tenNhom',
                isRequired: true,
              ),
              // CommonCheckboxInput(
              //   label: 'Có hiệu lực',
              //   value: isActive,
              //   isEditing: isEditing,
              //   isDisabled: !isEditing,
              //   onChanged: (value) {
              //     setState(() {
              //       isActive = value;
              //     });
              //   },
              // ),
              // _buildInfoCcdcHandoverMobile(isWideScreen),
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
          text: 'Chỉnh sửa nhóm CCDC - Vật tư',
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
    UserInfoDTO? userInfo = AccountHelper.instance.getUserInfo();
    if (!_validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin bắt buộc (*)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (data == null) {
      CcdcGroup request = CcdcGroup(
        id: controllerIdCcdcGroup.text,
        ten: controllerNameCcdcGroup.text,
        hieuLuc: isActive,
        idCongTy: idCongTy,
        ngayTao: DateTime.parse(getDateNow()),
        ngayCapNhat: DateTime.parse(getDateNow()),
        nguoiTao: userInfo?.id ?? '',
      );

      context.read<CcdcGroupBloc>().add(CreateCcdcGroupEvent(context, request));
    } else {
      CcdcGroup request = CcdcGroup(
        id: controllerIdCcdcGroup.text,
        ten: controllerNameCcdcGroup.text,
        hieuLuc: isActive,
        idCongTy: idCongTy,
        ngayTao: DateTime.parse(getDateNow()),
        ngayCapNhat: DateTime.parse(getDateNow()),
        nguoiCapNhat: userInfo?.id ?? '',
      );

      context.read<CcdcGroupBloc>().add(
        UpdateCcdcGroupEvent(context, request, data!.id!),
      );
    }
  }
}
