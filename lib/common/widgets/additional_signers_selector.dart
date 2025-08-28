import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/common/input/common_checkbox_input.dart';

class AdditionalSignerData {
  final PhongBan? department;
  final NhanVien? employee;
  final bool signed;

  AdditionalSignerData({this.department, this.employee, this.signed = false});

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
  });

  @override
  State<AdditionalSignersSelector> createState() =>
      _AdditionalSignersSelectorState();
}

class _AdditionalSignersSelectorState extends State<AdditionalSignersSelector> {
  late List<NhanVien?> _signers;
  final List<TextEditingController> _controllers = [];
  // Controllers cho dropdown phòng ban
  final List<TextEditingController> _deptControllers = [];
  // Enhanced per-row state
  late bool _hasDepartment;
  late List<PhongBan?> _departments;
  late List<bool> _signedStatuses;

  @override
  void initState() {
    super.initState();
    _hasDepartment = widget.phongBan != null && widget.listNhanVien != null;
    _signers = List<NhanVien?>.from(widget.initialSigners);
    _controllers.addAll(
      List.generate(_signers.length, (_) => TextEditingController()),
    );
    _departments = List<PhongBan?>.filled(
      _signers.length,
      null,
      growable: true,
    );
    _signedStatuses = List<bool>.filled(_signers.length, false, growable: true);
    _deptControllers.addAll(
      List.generate(_signers.length, (_) => TextEditingController()),
    );
  }

  @override
  void didUpdateWidget(covariant AdditionalSignersSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    _hasDepartment = widget.phongBan != null && widget.listNhanVien != null;
    // Đồng bộ khi initialSigners thay đổi từ bên ngoài
    if (oldWidget.initialSigners != widget.initialSigners) {
      _signers = List<NhanVien?>.from(widget.initialSigners);
      // Cập nhật controllers theo số lượng mới
      if (_controllers.length < _signers.length) {
        final need = _signers.length - _controllers.length;
        _controllers.addAll(
          List.generate(need, (_) => TextEditingController()),
        );
      } else if (_controllers.length > _signers.length) {
        final remove = _controllers.length - _signers.length;
        for (int i = 0; i < remove; i++) {
          _controllers.removeLast().dispose();
        }
      }
      // Cập nhật controllers phòng ban
      if (_deptControllers.length < _signers.length) {
        final need = _signers.length - _deptControllers.length;
        _deptControllers.addAll(
          List.generate(need, (_) => TextEditingController()),
        );
      } else if (_deptControllers.length > _signers.length) {
        final remove = _deptControllers.length - _signers.length;
        for (int i = 0; i < remove; i++) {
          _deptControllers.removeLast().dispose();
        }
      }
      // Cập nhật các mảng phụ trợ
      _ensureLengths();
      setState(() {});
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
    widget.onChanged(_signers);
    // Bản mở rộng nếu có
    if (widget.onChangedDetailed != null) {
      final detailed = List<AdditionalSignerData>.generate(
        _signers.length,
        (i) => AdditionalSignerData(
          department: _hasDepartment ? _departments[i] : null,
          employee: _signers[i],
          signed: _signedStatuses[i],
        ),
      );
      widget.onChangedDetailed!(detailed);
    }
  }

  void _addSigner() {
    setState(() {
      _signers.add(null);
      _controllers.add(TextEditingController());
      _departments.add(null);
      _signedStatuses.add(false);
      _deptControllers.add(TextEditingController());
    });
    _emitChanges();
  }

  void _removeSigner(int index) {
    setState(() {
      _signers.removeAt(index);
      _controllers.removeAt(index).dispose();
      _departments.removeAt(index);
      _signedStatuses.removeAt(index);
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
    // đảm bảo độ dài các mảng phụ trợ khớp với _signers
    if (_departments.length < _signers.length) {
      _departments.addAll(
        List<PhongBan?>.filled(_signers.length - _departments.length, null),
      );
    } else if (_departments.length > _signers.length) {
      _departments.removeRange(_signers.length, _departments.length);
    }
    if (_signedStatuses.length < _signers.length) {
      _signedStatuses.addAll(
        List<bool>.filled(_signers.length - _signedStatuses.length, false),
      );
    } else if (_signedStatuses.length > _signers.length) {
      _signedStatuses.removeRange(_signers.length, _signedStatuses.length);
    }
    if (_deptControllers.length < _signers.length) {
      _deptControllers.addAll(
        List.generate(
          _signers.length - _deptControllers.length,
          (_) => TextEditingController(),
        ),
      );
    } else if (_deptControllers.length > _signers.length) {
      final remove = _deptControllers.length - _signers.length;
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
          children: List.generate(_signers.length, (index) {
            final dept = _hasDepartment ? _departments[index] : null;
            final staffItems =
                _hasDepartment
                    ? _buildStaffItemsForDepartment(dept)
                    : widget.itemsNhanVien;
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
                                  value: _departments[index],
                                  defaultValue: _departments[index],
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
                                      _departments[index] = value;
                                      // Reset nhân viên khi đổi phòng ban
                                      _signers[index] = null;
                                    });
                                    _emitChanges();
                                  },
                                  validationErrors: const {},
                                ),
                              ),
                              // const SizedBox(height: 8),
                            ],
                            CmFormDropdownObject<NhanVien>(
                              label: '${widget.labelSigned} ${index + 1}',
                              controller: _controllers[index],
                              isEditing: widget.isEditing,
                              value: _signers[index],
                              defaultValue: _signers[index],
                              fieldName: 'additionalSigner_$index',
                              items: staffItems,
                              onChanged: (value) {
                                setState(() {
                                  _signers[index] = value;
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
                          value: _signedStatuses[index],
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
