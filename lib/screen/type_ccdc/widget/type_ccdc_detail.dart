import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/pages/department_form_page.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/model/ccdc_group.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/bloc/type_ccdc_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/bloc/type_ccdc_event.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/model/type_ccdc.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/provider/type_ccdc_provider.dart';

class TypeCcdcDetail extends StatefulWidget {
  final TypeCcdcProvider provider;
  const TypeCcdcDetail({super.key, required this.provider});

  @override
  State<TypeCcdcDetail> createState() => _TypeCcdcDetailState();
}

class _TypeCcdcDetailState extends State<TypeCcdcDetail> {
  TypeCcdc? data;
  bool isEditing = false;
  bool isActive = false;

  TextEditingController controllerId = TextEditingController();
  TextEditingController controllerIdLoaiCCDC = TextEditingController();
  TextEditingController controllerName = TextEditingController();

  Map<String, bool> validationErrors = {};
  List<CcdcGroup> listCcdcGroup = [];
  CcdcGroup? ccdcGroup;
  List<DropdownMenuItem<CcdcGroup>> itemsCcdcGroup = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didUpdateWidget(covariant TypeCcdcDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.provider.dataDetail != data) {
      _initData();
    }
  }

  @override
  void dispose() {
    controllerId.dispose();
    controllerIdLoaiCCDC.dispose();
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
    if (controllerIdLoaiCCDC.text.isEmpty) {
      newValidationErrors['idLoaiCCDC'] = true;
    }
    if (controllerName.text.isEmpty) {
      newValidationErrors['tenLoai'] = true;
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
      controllerId.text = data!.id ?? '';
      controllerIdLoaiCCDC.text = data!.idLoaiCCDC ?? '';
      controllerName.text = data!.tenLoai ?? '';
      ccdcGroup = tryGetCcdcGroup(data!.idLoaiCCDC ?? '');
    } else {
      data = null;
      setState(() {
        isEditing = widget.provider.isCreate;
      });
      controllerId.text = '';
      controllerIdLoaiCCDC.text = '';
      controllerName.text = '';
      ccdcGroup = null;
      validationErrors = {};
    }
    listCcdcGroup = AccountHelper.instance.getCcdcGroup() ?? [];
    itemsCcdcGroup =
        listCcdcGroup
            .map(
              (e) => DropdownMenuItem<CcdcGroup>(
                value: e,
                child: Text(e.ten ?? ''),
              ),
            )
            .toList();
    setState(() {});
  }

  //CCDC GROUP (safe lookup)
  CcdcGroup? tryGetCcdcGroup(String id) {
    for (final item in listCcdcGroup) {
      if (item.id == id) return item;
    }
    return null;
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
              sectionTitle(Icons.info_outline, 'Thông tin loại CCDC'),
              const SizedBox(height: 16),
              CommonFormInput(
                label: 'Mã loại CCDC',
                controller: controllerId,
                isEditing: data == null ? isEditing : false,
                textContent: controllerId.text,
                width: double.infinity,
                validationErrors: validationErrors,
                fieldName: 'id',
                isRequired: true,
              ),
              CmFormDropdownObject<CcdcGroup>(
                label: 'Mã loại CCDC cha',
                value: ccdcGroup,
                controller: controllerIdLoaiCCDC,
                isEditing: isEditing,
                items: itemsCcdcGroup,
                defaultValue:
                    controllerIdLoaiCCDC.text.isNotEmpty
                        ? tryGetCcdcGroup(controllerIdLoaiCCDC.text)
                        : null,
                onChanged: (value) {
                  setState(() {
                    ccdcGroup = value;
                  });
                },
                fieldName: 'idLoaiCCDC',
                validationErrors: validationErrors,
                isRequired: true,
              ),
              CommonFormInput(
                label: 'Tên loại CCDC',
                controller: controllerName,
                isEditing: isEditing,
                textContent: controllerName.text,
                width: double.infinity,
                validationErrors: validationErrors,
                fieldName: 'tenLoai',
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
                });
              },
            ),
          ],
        )
        : MaterialTextButton(
          text: 'Chỉnh sửa loại CCDC',
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
      TypeCcdc request = TypeCcdc(
        id: controllerId.text,
        idLoaiCCDC: ccdcGroup?.id ?? '',
        tenLoai: controllerName.text,
      );

      context.read<TypeCcdcBloc>().add(CreateTypeCcdcEvent(context, request));
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
      TypeCcdc request = TypeCcdc(
        id: controllerId.text,
        idLoaiCCDC: ccdcGroup?.id ?? '',
        tenLoai: controllerName.text,
      );

      context.read<TypeCcdcBloc>().add(
        UpdateTypeCcdcEvent(context, request, data!.id!),
      );
    }
  }
}
