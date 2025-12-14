import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/bloc/current_status_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/bloc/current_status_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/model/current_status.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/provider/current_status_provider.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/view/department_form_page.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';

class CurrentStatusDetail extends StatefulWidget {
  final CurrentStatusProvider provider;
  const CurrentStatusDetail({super.key, required this.provider});

  @override
  State<CurrentStatusDetail> createState() => _CurrentStatusDetailState();
}

class _CurrentStatusDetailState extends State<CurrentStatusDetail> {
  CurrentStatus? data;
  bool isEditing = false;
  String? nameCurrentStatus;
  String idCongTy = 'ct001';
  DateTime? createdAt;

  TextEditingController controllerId = TextEditingController();
  TextEditingController controllerName = TextEditingController();

  Map<String, bool> validationErrors = {};

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didUpdateWidget(covariant CurrentStatusDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.provider.dataDetail != data) {
      _initData();
    }
  }

  @override
  void dispose() {
    controllerId.dispose();
    controllerName.dispose();
    super.dispose();
  }

  // Thêm: Hàm validate form trước khi lưu
  bool _validateForm() {
    Map<String, bool> newValidationErrors = {};
    if (data == null) {
      if (controllerId.text.isEmpty) {
        newValidationErrors['id'] = true;
      }
    }
    if (controllerName.text.isEmpty) {
      newValidationErrors['tenHTKT'] = true;
    }

    bool hasChanges = !mapEquals(validationErrors, newValidationErrors);
    if (hasChanges) {
      setState(() {
        validationErrors = newValidationErrors;
      });
    }
    return newValidationErrors.isEmpty;
  }

  _initData() {
    if (widget.provider.dataDetail != null) {
      setState(() {
        isEditing = false;
      });
      data = widget.provider.dataDetail;
      controllerId.text = data!.id?.toString() ?? '';
      controllerName.text = data!.tenHTKT ?? '';
    } else {
      data = null;
      setState(() {
        isEditing = widget.provider.isCreate;
      });
      // Clear form when creating new
      controllerId.text = '';
      controllerName.text = '';
      validationErrors = {};
    }
    setState(() {});
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
              sectionTitle(Icons.info_outline, 'Thông tin hiện trạng'),
              const SizedBox(height: 16),
              CommonFormInput(
                label: 'Mã hiện trạng',
                controller: controllerId,
                isEditing: data == null ? isEditing : false,
                textContent: controllerId.text,
                width: double.infinity,
                validationErrors: validationErrors,
                fieldName: 'id',
                inputType: TextInputType.number,
                isRequired: true,
              ),
              CommonFormInput(
                label: 'Tên hiện trạng',
                controller: controllerName,
                isEditing: isEditing,
                textContent: controllerName.text,
                width: double.infinity,
                validationErrors: validationErrors,
                fieldName: 'tenHTKT',
                isRequired: true,
              ),
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
                  if (widget.provider.dataDetail == null) {
                    widget.provider.onCloseDetail(context);
                  }
                });
              },
            ),
          ],
        )
        : MaterialTextButton(
          text: 'Chỉnh sửa hiện trạng',
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
    if (data == null) {
      if (!_validateForm()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vui lòng điền đầy đủ thông tin bắt buộc (*)'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      CurrentStatus request = CurrentStatus(
        id: int.parse(controllerId.text),
        tenHTKT: controllerName.text,
        moTa: '',
        ngayTao: DateTime.now().toString(),
        ngayCapNhat: DateTime.now().toString(),
        nguoiTao: AccountHelper.instance.getUserInfo()?.tenDangNhap ?? '',
        nguoiCapNhat: '',
        isActive: true,
      );

      context.read<CurrentStatusBloc>().add(CreateCurrentStatusEvent(context, request));
    } else {
      if (!_validateForm()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vui lòng điền đầy đủ thông tin bắt buộc (*)'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      CurrentStatus request = CurrentStatus(
        id: int.parse(controllerId.text),
        tenHTKT: controllerName.text,
        moTa: '',
        ngayTao: DateTime.now().toString(),
        ngayCapNhat: DateTime.now().toString(),
        nguoiTao: '',
        nguoiCapNhat: AccountHelper.instance.getUserInfo()?.tenDangNhap ?? '',
        isActive: true,
      );

      context.read<CurrentStatusBloc>().add(
        UpdateCurrentStatusEvent(context, request, data!.id!.toString()),
      );
    }
  }
}
