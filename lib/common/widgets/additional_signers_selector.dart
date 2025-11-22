import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/common/input/common_checkbox_input.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/models/department.dart';
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
  final PhongBan? defaultDepartment;
  // Optional enhanced props
  final List<PhongBan>? phongBan;
  final List<NhanVien>? listNhanVien;
  final ValueChanged<List<AdditionalSignerData>>? onChangedDetailed;
  // Thêm prop mới để truyền vào danh sách AdditionalSignerData ban đầu
  final List<AdditionalSignerData>? initialSignerData;

  final bool isEditDepartment;

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
    this.defaultDepartment,
    this.isEditDepartment = true,
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
    _hasDepartment =
        widget.phongBan != null &&
        widget.listNhanVien != null &&
        widget.listNhanVien!.isNotEmpty;

    // Khởi tạo từ initialSignerData nếu có, nếu không thì từ initialSigners
    if (widget.initialSignerData != null &&
        widget.initialSignerData!.isNotEmpty) {
      _signersData = List<AdditionalSignerData>.from(widget.initialSignerData!);
      if (widget.defaultDepartment != null) {
        for (int i = 0; i < _signersData.length; i++) {
          if (_signersData[i].department == null) {
            _signersData[i] = _signersData[i].copyWith(
              department: widget.defaultDepartment,
            );
          }
        }
      }
    } else {
      _signersData =
          widget.initialSigners
              .map(
                (e) => AdditionalSignerData(
                  employee: e,
                  department: widget.defaultDepartment,
                ),
              )
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
    _hasDepartment =
        widget.phongBan != null &&
        widget.listNhanVien != null &&
        widget.listNhanVien!.isNotEmpty;

    if (oldWidget.defaultDepartment != widget.defaultDepartment &&
        widget.defaultDepartment != null) {
      for (int i = 0; i < _signersData.length; i++) {
        _signersData[i] = AdditionalSignerData(
          department: widget.defaultDepartment,
          employee: null,
          signed: _signersData[i].signed,
        );
      }
      setState(() {});
    }

    // Đồng bộ khi initialSignerData hoặc initialSigners thay đổi từ bên ngoài
    if (oldWidget.initialSignerData != widget.initialSignerData ||
        oldWidget.initialSigners != widget.initialSigners) {
      if (widget.initialSignerData != null &&
          widget.initialSignerData!.isNotEmpty) {
        _signersData = List<AdditionalSignerData>.from(
          widget.initialSignerData!,
        );
        if (widget.defaultDepartment != null) {
          for (int i = 0; i < _signersData.length; i++) {
            if (_signersData[i].department == null) {
              _signersData[i] = _signersData[i].copyWith(
                department: widget.defaultDepartment,
              );
            }
          }
        }
      } else {
        // Preserve department and signed state when syncing from initialSigners
        _signersData = List.generate(widget.initialSigners.length, (index) {
          final employee = widget.initialSigners[index];
          PhongBan? dept;
          bool signed = false;

          if (index < _signersData.length) {
            dept = _signersData[index].department;
            signed = _signersData[index].signed;
          }

          dept ??= widget.defaultDepartment;

          return AdditionalSignerData(
            employee: employee,
            department: dept,
            signed: signed,
          );
        });
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
      _signersData.add(
        AdditionalSignerData(department: widget.defaultDepartment),
      );
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
    if (!_hasDepartment) {
      return widget.itemsNhanVien;
    }
    if (dept == null) {
      return <DropdownMenuItem<NhanVien>>[];
    }
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
    if (filtered.isEmpty) {
      // Fallback 1: Default department match
      if (widget.defaultDepartment != null &&
          dept.id == widget.defaultDepartment!.id &&
          widget.itemsNhanVien.isNotEmpty) {
        return widget.itemsNhanVien;
      }
      // Fallback 2: If listNhanVien is empty (should be covered by _hasDepartment check but safe to keep)
      if (widget.listNhanVien == null || widget.listNhanVien!.isEmpty) {
        return widget.itemsNhanVien;
      }
    }

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
            final dept =
                _hasDepartment
                    ? (_signersData[index].department ??
                        widget.defaultDepartment)
                    : null;
            var staffItems =
                _hasDepartment
                    ? _buildStaffItemsForDepartment(dept)
                    : widget.itemsNhanVien;
            NhanVien? nhanVien = _signersData[index].employee;
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
                            if (_hasDepartment &&
                                widget.defaultDepartment == null) ...[
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 7.0,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: CmFormDropdownObject<PhongBan>(
                                    label: widget.labelDepartment,
                                    controller: _deptControllers[index],
                                    isEditing:
                                        widget.isEditDepartment == true
                                            ? widget.isEditing
                                            : false,
                                    value:
                                        _signersData[index].department ??
                                        widget.defaultDepartment,
                                    defaultValue:
                                        _signersData[index].department ??
                                        widget.defaultDepartment,
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
                                        _signersData[index] =
                                            AdditionalSignerData(
                                              department: value,
                                              employee: null,
                                              signed: _signersData[index].signed,
                                            );
                                      });
                                      _emitChanges();
                                    },
                                    validationErrors: const {},
                                  ),
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
