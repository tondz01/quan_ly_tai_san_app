import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/Category/departments/bloc/department_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/Category/departments/bloc/department_event.dart';
import 'package:quan_ly_tai_san_app/screen/Category/staff/models/staff.dart';
import 'package:se_gay_components/common/sg_button.dart';
import 'package:se_gay_components/common/sg_dropdown_input_button.dart';
import 'package:se_gay_components/common/sg_textfield.dart';
import '../models/department.dart';

class DepartmentFormPage extends StatefulWidget {
  final Department? department;
  final int? index;
  final VoidCallback? onCancel;
  final VoidCallback? onSaved;
  const DepartmentFormPage({
    super.key,
    this.department,
    this.index,
    this.onCancel,
    this.onSaved,
  });

  @override
  State<DepartmentFormPage> createState() => _DepartmentFormPageState();
}

class _DepartmentFormPageState extends State<DepartmentFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _departmentIdController;
  late TextEditingController _departmentGroupController;
  late TextEditingController _departmentNameController;
  late TextEditingController _managerNameController;
  late TextEditingController _employeeCountController;
  late TextEditingController _parentRoomController;
  StaffDTO? _staffDTO;

  @override
  void initState() {
    super.initState();

    _departmentIdController = TextEditingController(
      text: widget.department?.departmentId ?? '',
    );
    _departmentGroupController = TextEditingController(
      text: widget.department?.departmentGroup ?? '',
    );
    _departmentNameController = TextEditingController(
      text: widget.department?.departmentName ?? '',
    );
    _managerNameController = TextEditingController(
      text: _staffDTO?.staffId ?? '',
    );
    try {
     _staffDTO = context.read<DepartmentBloc>().staffs.firstWhere((staff) => staff.staffId == widget.department?.managerId) ;
    } catch (e) {
      _staffDTO = null;
    }
    _employeeCountController = TextEditingController(
      text: widget.department?.employeeCount ?? '',
    );
    _parentRoomController = TextEditingController(
      text: widget.department?.parentRoom ?? '',
    );
  }

  @override
  void dispose() {
    _departmentIdController.dispose();
    _departmentGroupController.dispose();
    _departmentNameController.dispose();
    _managerNameController.dispose();
    _employeeCountController.dispose();
    _parentRoomController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final department = Department(
        departmentId: _departmentIdController.text.trim(),
        departmentGroup: _departmentGroupController.text.trim(),
        departmentName: _departmentNameController.text.trim(),
        managerId: _staffDTO?.staffId ?? '',
        employeeCount: _employeeCountController.text.trim(),
        parentRoom: _parentRoomController.text.trim(),
      );
      if (widget.department == null) {
        context.read<DepartmentBloc>().add(AddDepartment(department));
      } else {
        context.read<DepartmentBloc>().add(UpdateDepartment(department));
      }
      if (widget.onSaved != null) {
        widget.onSaved!();
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.department != null;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        margin: EdgeInsets.only(right: 50, top: 16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      isEdit ? 'Cập nhật thông tin dự án' : 'Thêm mới dự án',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 32.0,
                horizontal: 32.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: SGTextField(
                                    controller: _departmentIdController,
                                    label: 'Mã đơn vị',
                                    prefixIcon: Icon(
                                      Icons.code,
                                      color: Colors.orange,
                                    ),
                                    validator:
                                        (v) =>
                                            v == null || v.isEmpty
                                                ? 'Nhập mã đơn vị'
                                                : null,
                                  ),
                                ),
                                const SizedBox(width: 25),
                                Expanded(
                                  child: SGTextField(
                                    controller: _departmentGroupController,
                                    label: 'Nhóm đơn vị',
                                    prefixIcon: Icon(
                                      Icons.title,
                                      color: Colors.orange,
                                    ),
                                    validator:
                                        (v) =>
                                            v == null || v.isEmpty
                                                ? 'Nhập tên nhóm đơn vị'
                                                : null,
                                    minLines: 1,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: SGTextField(
                                    controller: _departmentNameController,
                                    label: 'Tên phòng/ban',
                                    prefixIcon: Icon(
                                      Icons.code,
                                      color: Colors.orange,
                                    ),
                                    validator:
                                        (v) =>
                                            v == null || v.isEmpty
                                                ? 'Nhập tên phòng/ban'
                                                : null,
                                  ),
                                ),
                                const SizedBox(width: 25),
                                Expanded(
                                  child: SGDropdownInputButton<StaffDTO>(
                                    controller: _managerNameController,
                                    items:
                                        context
                                            .read<DepartmentBloc>()
                                            .staffs
                                            .map((staff) => DropdownMenuItem<StaffDTO>(
                                              value: staff,
                                              child: Text(staff.name),
                                            ))
                                            .toList(),
                                    value: _staffDTO,
                                    onChanged: (value) {
                                      setState(() {
                                        _staffDTO = value;
                                      });
                                    },
                                    textAlign: TextAlign.start,
                                    colorBorder: Colors.grey.withValues(alpha: 0.4),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: SGTextField(
                                    controller: _parentRoomController,
                                    label: 'Phòng/Ban cấp trên',
                                    prefixIcon: Icon(
                                      Icons.title,
                                      color: Colors.orange,
                                    ),
                                    minLines: 1,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SGButton(
                          text: 'Hủy',
                          onPressed: () {
                            if (widget.onCancel != null) {
                              widget.onCancel!();
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          mainColor: Colors.blueAccent,
                        ),
                        const SizedBox(width: 16),
                        SGButton(
                          text: isEdit ? 'Cập nhật' : 'Thêm mới',
                          onPressed: _save,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
