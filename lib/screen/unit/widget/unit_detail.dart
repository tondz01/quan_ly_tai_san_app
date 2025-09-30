import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/widgets/input_decoration_custom.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/unit/bloc/unit_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/unit/bloc/unit_event.dart';
import 'package:quan_ly_tai_san_app/screen/unit/model/unit_dto.dart';
import 'package:quan_ly_tai_san_app/screen/unit/provider/unit_provider.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/pages/department_form_page.dart';

class UnitDetail extends StatefulWidget {
  final UnitProvider provider;
  const UnitDetail({super.key, required this.provider});

  @override
  State<UnitDetail> createState() => _UnitDetailState();
}

class _UnitDetailState extends State<UnitDetail> {
  UnitDto? data;
  bool isEditing = false;

  TextEditingController controllerId = TextEditingController();
  TextEditingController controllerTenDonVi = TextEditingController();
  TextEditingController controllerNote = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didUpdateWidget(covariant UnitDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.provider.dataDetail != data) {
      log('message didUpdateWidget: ${widget.provider.dataDetail?.toJson()}');
      _initData();
    }
  }

  @override
  void dispose() {
    controllerId.dispose();
    controllerTenDonVi.dispose();
    controllerNote.dispose();
    super.dispose();
  }

 
  _initData() {
    log('message _initData: ${widget.provider.dataDetail}');
    if (widget.provider.dataDetail != null) {
      setState(() {
        isEditing = false;
      });
      data = widget.provider.dataDetail;
      controllerId.text = data!.id ?? '';
      controllerTenDonVi.text = data!.tenDonVi ?? '';
      controllerNote.text = data!.note ?? '';
    } else {
      log('message _initData: ${widget.provider.isCreate}');
      data = null;
      setState(() {
        isEditing = widget.provider.isCreate;
      });
      controllerId.text = '';
      controllerTenDonVi.text = '';
      controllerNote.text = '';
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle(Icons.info_outline, 'Thông tin đơn vị tính'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controllerId,
                  enabled: data != null ? false : isEditing,
                  decoration: inputDecoration(
                    'Mã đơn vị tính',
                    required: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nhập mã đơn vị tính';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controllerTenDonVi,
                  enabled: isEditing,
                  decoration: inputDecoration(
                    'Tên đơn vị tính',
                    required: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nhập tên đơn vị tính';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controllerNote,
                  enabled: isEditing,
                  decoration: inputDecoration(
                    'Ghi chú',
                  ),
                ),
              ],
            ),
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
          text: 'Chỉnh sửa đơn vị tính',
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
    if (_formKey.currentState!.validate()) {
      if (data == null) {
        final request = UnitDto(
          id: controllerId.text,
          tenDonVi: controllerTenDonVi.text,
          note: controllerNote.text,
        );
        context.read<UnitBloc>().add(
          CreateUnitEvent(context, request),
        );
      } else {
        final request = UnitDto(
          id: controllerId.text,
          tenDonVi: controllerTenDonVi.text,
          note: controllerNote.text,
        );
        context.read<UnitBloc>().add(
          UpdateUnitEvent(context, request, data!.id!),
        );
      }
    }
  }
}
