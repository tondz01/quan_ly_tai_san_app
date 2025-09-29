import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/bloc/type_asset_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/bloc/type_asset_event.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/model/type_asset.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/provider/type_asset_provider.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';

class TypeAssetDetail extends StatefulWidget {
  final TypeAssetProvider provider;
  const TypeAssetDetail({super.key, required this.provider});

  @override
  State<TypeAssetDetail> createState() => _TypeAssetDetailState();
}

class _TypeAssetDetailState extends State<TypeAssetDetail> {
  TypeAsset? data;
  bool isEditing = false;
  String? nameTypeAsset;
  String idCongTy = 'ct001';
  DateTime? createdAt;

  TextEditingController controllerId = TextEditingController();
  TextEditingController controllerIdLoaiTs = TextEditingController();
  TextEditingController controllerName = TextEditingController();

  Map<String, bool> validationErrors = {};
  List<AssetGroupDto> listAssetGroup = [];
  AssetGroupDto? assetGroup;
  List<DropdownMenuItem<AssetGroupDto>> itemsAssetGroup = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didUpdateWidget(covariant TypeAssetDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.provider.dataDetail != data) {
      _initData();
    }
  }

  @override
  void dispose() {
    controllerId.dispose();
    controllerIdLoaiTs.dispose();
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
    if (controllerIdLoaiTs.text.isEmpty) {
      newValidationErrors['idLoaiTs'] = true;
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
      controllerIdLoaiTs.text = data!.idLoaiTs ?? '';
      controllerName.text = data!.tenLoai ?? '';
      assetGroup = tryGetAssetGroup(data!.idLoaiTs ?? '');
    } else {
      data = null;
      setState(() {
        isEditing = widget.provider.isCreate;
      });
      // Clear form when creating new
      controllerId.text = '';
      controllerIdLoaiTs.text = '';
      controllerName.text = '';
      assetGroup = null;
      validationErrors = {};
    }
    listAssetGroup = AccountHelper.instance.getAssetGroup() ?? [];
    itemsAssetGroup =
        listAssetGroup
            .map(
              (e) => DropdownMenuItem<AssetGroupDto>(
                value: e,
                child: Text(e.tenNhom ?? ''),
              ),
            )
            .toList();
    setState(() {});
  }

  //Tài sản con (safe lookup)
  AssetGroupDto? tryGetAssetGroup(String id) {
    for (final item in listAssetGroup) {
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
              CommonFormInput(
                label: 'Mã loại tài sản *',
                controller: controllerId,
                isEditing: data == null ? isEditing : false,
                textContent: controllerId.text,
                width: double.infinity,
                validationErrors: validationErrors,
                fieldName: 'id',
              ),
              CmFormDropdownObject<AssetGroupDto>(
                label: 'Mã loại tài sản cha *',
                value: assetGroup,
                controller: controllerIdLoaiTs,
                isEditing: isEditing,
                items: itemsAssetGroup,
                defaultValue:
                    controllerIdLoaiTs.text.isNotEmpty
                        ? tryGetAssetGroup(controllerIdLoaiTs.text)
                        : null,
                onChanged: (value) {
                  setState(() {
                    assetGroup = value;
                  });
                },
                fieldName: 'idLoaiTs',
                validationErrors: validationErrors,
              ),
              CommonFormInput(
                label: 'Tên loại tài sản *',
                controller: controllerName,
                isEditing: isEditing,
                textContent: controllerName.text,
                width: double.infinity,
                validationErrors: validationErrors,
                fieldName: 'tenLoai',
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
          text: 'Chỉnh sửa loại tài sản',
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

      TypeAsset request = TypeAsset(
        id: controllerId.text,
        idLoaiTs: assetGroup?.id ?? '',
        tenLoai: controllerName.text,
      );

      context.read<TypeAssetBloc>().add(CreateTypeAssetEvent(context, request));
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

      TypeAsset request = TypeAsset(
        id: controllerId.text,
        idLoaiTs: assetGroup?.id ?? '',
        tenLoai: controllerName.text,
      );

      context.read<TypeAssetBloc>().add(
        UpdateTypeAssetEvent(context, request, data!.id!),
      );
    }
  }
}
