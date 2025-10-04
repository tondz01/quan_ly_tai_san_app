import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/pages/department_form_page.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/bloc/reason_increase_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/bloc/reason_increase_event.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/model/reason_increase.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/provider/reason_increase_provider.dart';

class ReasonIncreaseDetail extends StatefulWidget {
  final ReasonIncreaseProvider provider;
  const ReasonIncreaseDetail({super.key, required this.provider});

  @override
  State<ReasonIncreaseDetail> createState() => _ReasonIncreaseDetailState();
}

class _ReasonIncreaseDetailState extends State<ReasonIncreaseDetail> {
  ReasonIncrease? data;
  bool isEditing = false;
  bool isIncrease = true;
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
  void didUpdateWidget(covariant ReasonIncreaseDetail oldWidget) {
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
      // Parse increase/decrease from name suffix e.g. "<name>#1" or "<name>#0"
      final parts = (data!.ten ?? '').split('#');
      if (parts.length > 1) {
        isIncrease = parts[1].trim() == '1';
      } else {
        isIncrease = true;
      }
    } else {
      data = null;
      setState(() {
        isEditing = widget.provider.isCreate;
        isIncrease = true;
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
              sectionTitle(Icons.info_outline, 'Thông tin lý do tăng'),
              const SizedBox(height: 16),
              CommonFormInput(
                label: 'Mã lý do tăng',
                controller: controllerIdCcdcGroup,
                isEditing: data == null ? isEditing : false,
                textContent: controllerIdCcdcGroup.text,
                width: double.infinity,
                validationErrors: validationErrors,
                fieldName: 'id',
                isRequired: true,
              ),
              CommonFormInput(
                label: 'Tên lý do tăng',
                controller: controllerNameCcdcGroup,
                isEditing: isEditing,
                textContent: controllerNameCcdcGroup.text,
                width: double.infinity,
                validationErrors: validationErrors,
                fieldName: 'tenNhom',
                isRequired: true,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: isIncrease,
                      onChanged:
                          isEditing
                              ? (value) {
                                if (value == null) return;
                                setState(() {
                                  isIncrease = value;
                                });
                              }
                              : null,
                    ),
                    const Text('Tăng'),
                    const SizedBox(width: 16),
                    Radio<bool>(
                      value: false,
                      groupValue: isIncrease,
                      onChanged:
                          isEditing
                              ? (value) {
                                if (value == null) return;
                                setState(() {
                                  isIncrease = value;
                                });
                              }
                              : null,
                    ),
                    const Text('Giảm'),
                  ],
                ),
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
                });
              },
            ),
          ],
        )
        : MaterialTextButton(
          text: 'Chỉnh sửa lý do tăng',
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
      ReasonIncrease request = ReasonIncrease(
        id: controllerIdCcdcGroup.text,
        ten: controllerNameCcdcGroup.text,
        tangGiam: isIncrease ? 1 : 0,
      );

      context.read<ReasonIncreaseBloc>().add(
        CreateReasonIncreaseEvent(context, request),
      );
    } else {
      ReasonIncrease request = ReasonIncrease(
        id: controllerIdCcdcGroup.text,
        ten: controllerNameCcdcGroup.text,
        tangGiam: isIncrease ? 1 : 0,
      );

      context.read<ReasonIncreaseBloc>().add(
        UpdateReasonIncreaseEvent(context, request, data!.id!),
      );
    }
  }
}
