import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/bloc/department_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/bloc/department_event.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/staff.dart';

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
  late TextEditingController _departmentNameController;
  late TextEditingController _employeeCountController;
  StaffDTO? _staffDTO;
  String? _group;
  String? _parentDepartment;

  final List<String> groups = [
    'Nhóm 1',
    'Nhóm 2',
    'Nhóm 3',
  ];
  final List<String> parentDepartments = [
    'Chưa xác định',
    'Phân xưởng KT7',
    'Phân xưởng KT6',
    'Phân xưởng Cơ khí 1',
    'Phân xưởng Cơ khí 2',
    'Phân xưởng sàng tuyển',
  ];

  @override
  void initState() {
    super.initState();
    _departmentIdController = TextEditingController(text: widget.department?.departmentId ?? '');
    _departmentNameController = TextEditingController(text: widget.department?.departmentName ?? '');
    _employeeCountController = TextEditingController(text: widget.department?.employeeCount ?? '');
    try {
      _staffDTO = context.read<DepartmentBloc>().staffs.firstWhere((staff) => staff.staffId == widget.department?.managerId);
    } catch (e) {
      _staffDTO = null;
    } 
    try {
      _group = groups.firstWhere((group) => group == widget.department?.departmentGroup);
    } catch (e) { 
      _group = null;
    }
    try {
      _parentDepartment = parentDepartments.firstWhere((parent) => parent == widget.department?.parentRoom);
    } catch (e) {
      _parentDepartment = null;
    }
  }

  @override
  void dispose() {
    _departmentIdController.dispose();
    _departmentNameController.dispose();
    _employeeCountController.dispose();
    super.dispose();
  }

  

  void _save() {
    if (_formKey.currentState!.validate()) {
      final department = Department(
        departmentId: _departmentIdController.text.trim(),
        departmentGroup: _group ?? '',
        departmentName: _departmentNameController.text.trim(),
        managerId: _staffDTO?.staffId ?? '',
        employeeCount: _employeeCountController.text.trim(),
        parentRoom: _parentDepartment ?? '',
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
    final List<StaffDTO> staffs = context.read<DepartmentBloc>().staffs;
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              sectionTitle(Icons.account_tree, isEdit ? 'Cập nhật phòng ban' : 'Thêm đơn vị / phòng ban', 'Nhập thông tin đơn vị hoặc phòng ban mới.'),
              sectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionTitle(Icons.info_outline, 'Thông tin đơn vị/phòng ban'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _departmentIdController,
                            decoration: inputDecoration('Mã đơn vị', required: true),
                            validator: (v) => v == null || v.isEmpty ? 'Nhập mã đơn vị' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _group?.trim().isEmpty ?? true ? null : _group,
                            decoration: inputDecoration('Nhóm đơn vị'),
                            items: groups.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                            onChanged: (v) => setState(() => _group = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _departmentNameController,
                      decoration: inputDecoration('Tên phòng/ban', required: true),
                      validator: (v) => v == null || v.isEmpty ? 'Nhập tên phòng/ban' : null,
                    ),
                  ],
                ),
              ),
              sectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionTitle(Icons.group, 'Thông tin bổ sung'),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<StaffDTO>(
                      value: _staffDTO,
                      decoration: inputDecoration('Quản lý'),
                      items: staffs.map((staff) => DropdownMenuItem(
                        value: staff,
                        child: Row(
                          children: [
                            avatar(staff.name),
                            const SizedBox(width: 8),
                            Text(staff.name),
                          ],
                        ),
                      )).toList(),
                      onChanged: (v) => setState(() => _staffDTO = v),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _employeeCountController,
                            decoration: inputDecoration('Số nhân viên'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _parentDepartment,
                            decoration: inputDecoration('Phòng/Ban cấp trên'),
                            items: parentDepartments.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                            onChanged: (v) => setState(() => _parentDepartment = v),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      if (widget.onCancel != null) {
                        widget.onCancel!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF7B8EC8),
                      side: const BorderSide(color: Color(0xFFE6EAF3)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Hủy'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2264E5),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: Text(isEdit ? 'Cập nhật' : 'Lưu'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
InputDecoration inputDecoration(String label, {bool required = false, String? hint}) {
    return InputDecoration(
      labelText: required ? '$label *' : label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget sectionTitle(IconData icon, String title, [String? desc]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            if (desc != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(desc, style: const TextStyle(color: Color(0xFF687082), fontSize: 13)),
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
        style: const TextStyle(color: Color(0xFF687082), fontWeight: FontWeight.bold),
      ),
    );
  }
