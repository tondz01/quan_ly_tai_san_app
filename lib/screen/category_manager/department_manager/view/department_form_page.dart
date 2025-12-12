import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/input/common_checkbox_input.dart';
import 'package:quan_ly_tai_san_app/common/widgets/input_decoration_custom.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/enum/loai_kho_enum.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/bloc/department_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/bloc/department_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/component/department_constants.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/models/nhom_don_vi.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/provider/department_provide.dart';

class DepartmentFormPage extends StatefulWidget {
  final DepartmentProvider provider;
  const DepartmentFormPage({super.key, required this.provider});

  @override
  State<DepartmentFormPage> createState() => _DepartmentFormPageState();
}

class _DepartmentFormPageState extends State<DepartmentFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _departmentIdController;
  late TextEditingController _departmentNameController;
  NhomDonVi? _group;
  PhongBan? _parentDepartment;
  PhongBan? _data;

  bool isEditing = false;
  bool isKho = false;
  bool typeKhoCP = false;
  bool typeKhoTH = false;
  bool isLanhDao = false;

  int get typeKho {
    if (typeKhoCP) {
      return 1;
    } else if (typeKhoTH) {
      return 2;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    _initData();
    super.initState();
  }

  @override
  void didUpdateWidget(DepartmentFormPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.provider.dataDetail != _data) {
      _initData();
    }
  }

  void _initData() {
    _data = widget.provider.dataDetail;
    if (_data != null) {
      isEditing = false;
      isKho = _data?.isKho ?? false;
      isLanhDao = _data?.isLanhDao ?? false;
      onGetTypeKho(_data?.loaiKho ?? 0);
    } else {
      isEditing = true;
      onGetTypeKho(0);
    }
    _departmentIdController = TextEditingController(text: _data?.id ?? '');

    _departmentNameController = TextEditingController(
      text: _data?.tenPhongBan ?? '',
    );
    // try {
    //   _group = context.read<DepartmentBloc>().departmentGroups.firstWhere(
    //     (group) => group.id == _data?.idNhomDonVi,
    //   );
    // } catch (e) {
    //   _group = null;
    // }

    _parentDepartment = null;

    // try {
    //   _parentDepartment = context.read<DepartmentBloc>().departments.firstWhere(
    //     (parentDepartment) =>
    //         parentDepartment.id == widget.department?.phongCapTren,
    //   );
    // } catch (e) {
    //   _parentDepartment = null;
    // }
  }

  @override
  void dispose() {
    _departmentIdController.dispose();
    _departmentNameController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final department = PhongBan(
        id: _departmentIdController.text.trim(),
        idNhomDonVi: _group?.id ?? '',
        tenPhongBan: _departmentNameController.text.trim(),
        idQuanLy: '',
        phongCapTren: _parentDepartment?.id ?? '',
        isKho: isKho,
        loaiKho: typeKho,
        isLanhDao: isLanhDao,
      );
      if (_data == null) {
        context.read<DepartmentBloc>().add(CreateDepartmentEvent(department));
      } else {
        context.read<DepartmentBloc>().add(UpdateDepartmentEvent(department));
      }
      widget.provider.onCloseDetail(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = !isEditing;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildHeaderDetail(),
            sectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle(
                    Icons.info_outline,
                    'Thông tin đơn vị/phòng ban',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _departmentIdController,
                          decoration: inputDecoration(
                            'Mã đơn vị',
                            required: true,
                          ),
                          enabled:
                              _data?.id != null
                                  ? false
                                  : !isEdit, // Read-only khi update
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? DepartmentConstants
                                          .validationDepartmentIdRequired
                                      : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _departmentNameController,
                          decoration: inputDecoration(
                            'Tên phòng/ban',
                            required: true,
                          ),
                          enabled: !isEdit,
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? DepartmentConstants
                                          .validationDepartmentNameRequired
                                      : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // DropdownButtonFormField<PhongBan>(
                  //   value: _parentDepartment,
                  //   decoration: inputDecoration('Phòng/Ban cấp trên'),
                  //   isExpanded: true,
                  //   isDense: false,
                  //   items:
                  //       context
                  //           .read<DepartmentBloc>()
                  //           .departments
                  //           .map(
                  //             (p) => DropdownMenuItem(
                  //               value: p,
                  //               child: Text(p.tenPhongBan ?? ''),
                  //             ),
                  //           )
                  //           .toList(),
                  //   onChanged:
                  //       isEdit
                  //           ? null
                  //           : (v) => setState(() => _parentDepartment = v),
                  // ),
                  // const SizedBox(height: 24),
                  CommonCheckboxInput(
                    label: 'Là kho',
                    value: isKho,
                    onChanged:
                        isEdit
                            ? null
                            : (v) {
                              setState(() {
                                isKho = v;
                                // Nếu chọn là kho thì bỏ chọn phòng ban lãnh đạo
                                if (v) {
                                  isLanhDao = false;
                                } else {
                                  // Nếu bỏ chọn kho thì reset loại kho
                                  typeKhoCP = false;
                                  typeKhoTH = false;
                                }
                              });
                            },
                    isEditing: isEdit,
                    isDisabled: isEdit || isLanhDao,
                  ),

                  const SizedBox(width: 32),
                  if (isKho) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 93),
                      child: CommonCheckboxInput(
                        label: 'Kho cấp phát',
                        labelWidth: 100,
                        value: typeKhoCP,
                        sizePadding: 5,
                        onChanged:
                            isEdit
                                ? null
                                : (v) {
                                  onChangeTypeKho(v, 1);
                                },
                        isEditing: isEdit,
                        isDisabled: isEdit,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 93),
                      child: CommonCheckboxInput(
                        label: 'Kho thu hồi',
                        labelWidth: 100,
                        value: typeKhoTH,
                        sizePadding: 5,
                        onChanged:
                            isEdit
                                ? null
                                : (v) {
                                  onChangeTypeKho(v, 2);
                                },
                        isEditing: isEdit,
                        isDisabled: isEdit,
                      ),
                    ),
                  ],
                  CommonCheckboxInput(
                    label: 'Là phòng ban lãnh đạo',
                    value: isLanhDao,
                    onChanged:
                        isEdit
                            ? null
                            : (v) {
                              setState(() {
                                isLanhDao = v;
                                // Nếu chọn là phòng ban lãnh đạo thì bỏ chọn kho
                                if (v) {
                                  isKho = false;
                                  typeKhoCP = false;
                                  typeKhoTH = false;
                                }
                              });
                            },
                    isEditing: isEdit,
                    isDisabled: isEdit || isKho,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderDetail() {
    return isEditing
        ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MaterialTextButton(
              text: DepartmentConstants.saveText,
              icon: Icons.save,
              backgroundColor: ColorValue.success,
              foregroundColor: Colors.white,
              onPressed: () {
                _save();
              },
            ),
            const SizedBox(width: 8),
            MaterialTextButton(
              text: DepartmentConstants.cancelText,
              icon: Icons.cancel,
              backgroundColor: ColorValue.error,
              foregroundColor: Colors.white,
              onPressed: () {
                widget.provider.onCloseDetail(context);
              },
            ),
          ],
        )
        : MaterialTextButton(
          text: DepartmentConstants.editText,
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

  onChangeTypeKho(bool? value, int type) {
    setState(() {
      if (type == LoaiKho.capPhat.value) {
        typeKhoCP = value ?? false;
        typeKhoTH = false;
      } else if (type == LoaiKho.thuHoi.value) {
        typeKhoTH = value ?? false;
        typeKhoCP = false;
      }
    });
  }

  onGetTypeKho(int type) {
    setState(() {
      if (type == LoaiKho.capPhat.value) {
        typeKhoCP = true;
      } else if (type == LoaiKho.thuHoi.value) {
        typeKhoTH = true;
      } else {
        typeKhoCP = false;
        typeKhoTH = false;
      }
    });
  }
}

Widget sectionTitle(IconData icon, String title, [String? desc]) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        margin: const EdgeInsets.only(right: 12, top: 2),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF1FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFF7B8EC8), size: 24),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          if (desc != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                desc,
                style: const TextStyle(color: Color(0xFF687082), fontSize: 13),
              ),
            ),
        ],
      ),
    ],
  );
}

Widget sectionCard({required Widget child}) {
  return Container(
    margin: const EdgeInsets.only(top: 20),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFE6EAF3)),
    ),
    child: child,
  );
}

Widget avatar(String name) {
  return CircleAvatar(
    backgroundColor: const Color(0xFFEAF1FF),
    child: Text(
      name.isNotEmpty ? name.trim()[0].toUpperCase() : '',
      style: const TextStyle(
        color: Color(0xFF687082),
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
