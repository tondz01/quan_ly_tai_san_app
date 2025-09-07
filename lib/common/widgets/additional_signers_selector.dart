import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/common/input/common_checkbox_input.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';

class AdditionalSignerData {
  final PhongBan? department;
  final NhanVien? employee;
  final bool signed;

  AdditionalSignerData({this.department, this.employee, this.signed = false});
  Map<String, dynamic> toJson() {
    return {
      'department': department?.toJson(),
      'employee': employee?.toJson(),
      'signed': signed,
    };
  }

  AdditionalSignerData copyWith({
    PhongBan? department,
    NhanVien? employee,
    bool? signed,
  }) {
    return AdditionalSignerData(
      department: department ?? this.department,
      employee: employee ?? this.employee,
      signed: signed ?? this.signed,
    );
  }
}

class AdditionalSignersSelector extends StatefulWidget {
  final bool isEditing;
  final String addButtonText;
  final String labelSigned;
  final String labelDepartment;
  final List<DropdownMenuItem<NhanVien>> itemsNhanVien;
  final List<NhanVien?> initialSigners;
  final ValueChanged<List<NhanVien?>> onChanged;
  // Optional enhanced props
  final List<PhongBan>? phongBan;
  final List<NhanVien>? listNhanVien;
  final ValueChanged<List<AdditionalSignerData>>? onChangedDetailed;
  // Thêm prop mới để truyền vào danh sách AdditionalSignerData ban đầu
  final List<AdditionalSignerData>? initialSignerData;

  const AdditionalSignersSelector({
    super.key,
    required this.isEditing,
    required this.itemsNhanVien,
    required this.initialSigners,
    required this.onChanged,
    this.addButtonText = 'Thêm người ký mới',
    this.labelSigned = 'Người đại diện',
    this.labelDepartment = 'Phòng ban',
    this.phongBan,
    this.listNhanVien,
    this.onChangedDetailed,
    this.initialSignerData, // Thêm parameter mới
  });

  @override
  State<AdditionalSignersSelector> createState() =>
      _AdditionalSignersSelectorState();
}

class _AdditionalSignersSelectorState extends State<AdditionalSignersSelector> {
  // Single source of truth
  late List<AdditionalSignerData> _signersData;
  final List<TextEditingController> _controllers = [];
  // Controllers cho dropdown phòng ban
  final List<TextEditingController> _deptControllers = [];
  // Enhanced per-row state
  late bool _hasDepartment;

  @override
  void initState() {
    super.initState();
    _hasDepartment = widget.phongBan != null && widget.listNhanVien != null;

    // Khởi tạo từ initialSignerData nếu có, nếu không thì từ initialSigners
    if (widget.initialSignerData != null &&
        widget.initialSignerData!.isNotEmpty) {
      _signersData = List<AdditionalSignerData>.from(widget.initialSignerData!);
    } else {
      _signersData =
          widget.initialSigners
              .map((e) => AdditionalSignerData(employee: e))
              .toList();
    }

    _controllers.addAll(
      List.generate(_signersData.length, (_) => TextEditingController()),
    );
    _deptControllers.addAll(
      List.generate(_signersData.length, (_) => TextEditingController()),
    );
  }

  @override
  void didUpdateWidget(covariant AdditionalSignersSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    _hasDepartment = widget.phongBan != null && widget.listNhanVien != null;

    // Đồng bộ khi initialSignerData hoặc initialSigners thay đổi từ bên ngoài
    if (oldWidget.initialSignerData != widget.initialSignerData ||
        oldWidget.initialSigners != widget.initialSigners) {
      if (widget.initialSignerData != null &&
          widget.initialSignerData!.isNotEmpty) {
        _signersData = List<AdditionalSignerData>.from(
          widget.initialSignerData!,
        );
      } else {
        _signersData =
            widget.initialSigners
                .map((e) => AdditionalSignerData(employee: e))
                .toList();
      }

      // Cập nhật controllers theo số lượng mới
      _updateControllers();
      setState(() {});
    }
  }

  void _updateControllers() {
    // Cập nhật controllers cho nhân viên
    if (_controllers.length < _signersData.length) {
      final need = _signersData.length - _controllers.length;
      _controllers.addAll(List.generate(need, (_) => TextEditingController()));
    } else if (_controllers.length > _signersData.length) {
      final remove = _controllers.length - _signersData.length;
      for (int i = 0; i < remove; i++) {
        _controllers.removeLast().dispose();
      }
    }

    // Cập nhật controllers phòng ban
    if (_deptControllers.length < _signersData.length) {
      final need = _signersData.length - _deptControllers.length;
      _deptControllers.addAll(
        List.generate(need, (_) => TextEditingController()),
      );
    } else if (_deptControllers.length > _signersData.length) {
      final remove = _deptControllers.length - _signersData.length;
      for (int i = 0; i < remove; i++) {
        _deptControllers.removeLast().dispose();
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final c in _deptControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _emitChanges() {
    // Giữ tương thích cũ
    widget.onChanged(_signersData.map((e) => e.employee).toList());
    // Bản mở rộng nếu có
    if (widget.onChangedDetailed != null) {
      widget.onChangedDetailed!(List<AdditionalSignerData>.from(_signersData));
    }
  }

  void _addSigner() {
    setState(() {
      _signersData.add(AdditionalSignerData());
      _controllers.add(TextEditingController());
      _deptControllers.add(TextEditingController());
    });
    _emitChanges();
  }

  void _removeSigner(int index) {
    setState(() {
      _signersData.removeAt(index);
      _controllers.removeAt(index).dispose();
      _deptControllers.removeAt(index).dispose();
    });
    _emitChanges();
  }

  List<DropdownMenuItem<NhanVien>> _buildStaffItemsForDepartment(
    PhongBan? dept,
  ) {
    if (!_hasDepartment) return widget.itemsNhanVien;
    if (dept == null) return <DropdownMenuItem<NhanVien>>[];
    final filtered =
        widget.listNhanVien!
            .where((e) => e.phongBanId == (dept.id ?? ''))
            .map(
              (e) => DropdownMenuItem<NhanVien>(
                value: e,
                child: Text(e.hoTen ?? ''),
              ),
            )
            .toList();
    return filtered;
  }

  void _ensureLengths() {
    // đảm bảo độ dài các controllers khớp với _signersData
    if (_controllers.length < _signersData.length) {
      final need = _signersData.length - _controllers.length;
      _controllers.addAll(List.generate(need, (_) => TextEditingController()));
    } else if (_controllers.length > _signersData.length) {
      final remove = _controllers.length - _signersData.length;
      for (int i = 0; i < remove; i++) {
        _controllers.removeLast().dispose();
      }
    }

    if (_deptControllers.length < _signersData.length) {
      final need = _signersData.length - _deptControllers.length;
      _deptControllers.addAll(
        List.generate(need, (_) => TextEditingController()),
      );
    } else if (_deptControllers.length > _signersData.length) {
      final remove = _deptControllers.length - _signersData.length;
      for (int i = 0; i < remove; i++) {
        _deptControllers.removeLast().dispose();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _ensureLengths();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
            child: MaterialTextButton(
              text: widget.addButtonText,
              icon: Icons.person_add_alt,
              backgroundColor: ColorValue.lightBlue,
              foregroundColor: Colors.white,
              onPressed: widget.isEditing ? _addSigner : null,
            ),
          ),
        ),
        Column(
          children: List.generate(_signersData.length, (index) {
            final dept = _hasDepartment ? _signersData[index].department : null;
            final staffItems =
                _hasDepartment
                    ? _buildStaffItemsForDepartment(dept)
                    : widget.itemsNhanVien;
            NhanVien? nhanVien = _signersData[index].employee;
            log('message test1 phong ban: ${_signersData[index].department}');
            TextEditingController controller = _controllers[index];
            controller.text = nhanVien?.hoTen ?? '';
            _deptControllers[index].text =
                _signersData[index].department?.tenPhongBan ?? '';
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            if (_hasDepartment) ...[
                              SizedBox(
                                width: double.infinity,
                                child: CmFormDropdownObject<PhongBan>(
                                  label: widget.labelDepartment,
                                  controller: _deptControllers[index],
                                  isEditing: widget.isEditing,
                                  value: _signersData[index].department,
                                  defaultValue: _signersData[index].department,
                                  fieldName: 'additionalSigner_dept_$index',
                                  items: [
                                    ...widget.phongBan!.map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.tenPhongBan ?? ''),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _signersData[index] = _signersData[index]
                                          .copyWith(
                                            department: value,
                                            employee: null,
                                          );
                                    });
                                    _emitChanges();
                                  },
                                  validationErrors: const {},
                                ),
                              ),
                            ],
                            CmFormDropdownObject<NhanVien>(
                              label: '${widget.labelSigned} ${index + 1}',
                              controller: controller,
                              isEditing: widget.isEditing,
                              value: nhanVien,
                              defaultValue: nhanVien,
                              fieldName: 'additionalSigner_$index',
                              items: staffItems,
                              onChanged: (value) {
                                setState(() {
                                  _signersData[index] = _signersData[index]
                                      .copyWith(employee: value);
                                });
                                _emitChanges();
                              },
                              validationErrors: const {},
                            ),
                          ],
                        ),
                      ),
                      Tooltip(
                        message: 'Xóa người ký',
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.red.shade700,
                            size: 20,
                          ),
                          onPressed:
                              widget.isEditing
                                  ? () => _removeSigner(index)
                                  : null,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 8),

                  Row(
                    children: [
                      Expanded(
                        child: CommonCheckboxInput(
                          label: '${widget.labelSigned} ${index + 1} đã ký',
                          value: _signersData[index].signed,
                          isEditing: widget.isEditing,
                          isDisabled: true,
                          onChanged: (newValue) {
                            // Disabled; giữ giá trị để hiển thị, không thay đổi
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
