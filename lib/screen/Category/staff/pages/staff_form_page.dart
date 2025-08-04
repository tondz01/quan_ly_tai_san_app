import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/pages/department_form_page.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/bloc/staff_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/bloc/staff_event.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/staff.dart';

class StaffFormPage extends StatefulWidget {
  final StaffDTO? staff;
  final int? index;
  final VoidCallback? onCancel;
  final VoidCallback? onSaved;
  const StaffFormPage({
    super.key,
    this.staff,
    this.index,
    this.onCancel,
    this.onSaved,
  });

  @override
  State<StaffFormPage> createState() => _StaffFormPageState();
}

class _StaffFormPageState extends State<StaffFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _telController;
  late TextEditingController _emailController;
  late TextEditingController _activityController;
  late TextEditingController _timeForActivityController;
  late TextEditingController _departmentController;
  late TextEditingController _positionController;
  late TextEditingController _staffIdController;
  late TextEditingController _staffOwnerController;

  @override
  void initState() {
    _initData();
    super.initState();
  }

  void _initData() {
    _nameController = TextEditingController(text: widget.staff?.name ?? '');
    _telController = TextEditingController(text: widget.staff?.tel ?? '');
    _emailController = TextEditingController(text: widget.staff?.email ?? '');
    _activityController = TextEditingController(
      text: widget.staff?.activity ?? '',
    );
    _timeForActivityController = TextEditingController(
      text: widget.staff?.timeForActivity ?? '',
    );
    _departmentController = TextEditingController(
      text: widget.staff?.department ?? '',
    );
    _positionController = TextEditingController(
      text: widget.staff?.position ?? '',
    );
    _staffIdController = TextEditingController(
      text: widget.staff?.staffId ?? '',
    );
    _staffOwnerController = TextEditingController(
      text: widget.staff?.staffOwner ?? '',
    );
  }

  @override
  void didUpdateWidget(StaffFormPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Kiểm tra nếu có thay đổi trong item hoặc isEditing
    if (oldWidget.staff != widget.staff) {
      // Cập nhật lại trạng thái editing
      if (mounted) {
        _initData();
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _telController.dispose();
    _emailController.dispose();
    _activityController.dispose();
    _timeForActivityController.dispose();
    _departmentController.dispose();
    _positionController.dispose();
    _staffIdController.dispose();
    _staffOwnerController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final staff = StaffDTO(
        name: _nameController.text.trim(),
        tel: _telController.text.trim(),
        email: _emailController.text.trim(),
        activity: _activityController.text.trim(),
        timeForActivity: _timeForActivityController.text.trim(),
        department: _departmentController.text.trim(),
        position: _positionController.text.trim(),
        staffId: _staffIdController.text.trim(),
        staffOwner: _staffOwnerController.text.trim(),
      );
      if (widget.staff == null) {
        context.read<StaffBloc>().add(AddStaff(staff));
      } else {
        context.read<StaffBloc>().add(UpdateStaff(staff));
      }
      if (widget.onSaved != null) {
        widget.onSaved!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.staff != null;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          sectionTitle(
            Icons.person,
            isEdit ? 'Cập nhật thông tin nhân viên' : 'Thêm mới nhân viên',
            'Nhập thông tin nhân viên.',
          ),
          sectionCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  sectionTitle(Icons.info_outline, 'Thông tin nhân viên'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _staffIdController,
                          decoration: inputDecoration(
                            'Mã nhân viên',
                            required: true,
                          ),
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Nhập mã nhân viên'
                                      : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          decoration: inputDecoration(
                            'Tên nhân viên',
                            required: true,
                          ),
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Nhập tên nhân viên'
                                      : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _emailController,
                          decoration: inputDecoration('Email', required: true),
                          validator:
                              (v) =>
                                  v == null || v.isEmpty ? 'Nhập email' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _telController,
                          decoration: inputDecoration(
                            'Số điện thoại',
                            required: true,
                          ),
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Nhập số điện thoại'
                                      : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _activityController,
                          decoration: inputDecoration(
                            'Hoạt động',
                            required: true,
                          ),
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Nhập hoạt động'
                                      : null,
                          minLines: 1,
                          maxLines: 3,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _timeForActivityController,
                          decoration: inputDecoration(
                            'Hạn chót cho hoạt động tiếp theo',
                            required: true,
                          ),
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Nhập hạn chót cho hoạt động tiếp theo'
                                      : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _positionController,
                          decoration: inputDecoration(
                            'Chức vụ',
                            required: true,
                          ),
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Nhập chức vụ'
                                      : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _departmentController,
                          decoration: inputDecoration(
                            'Phòng ban',
                            required: true,
                          ),
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Nhập phòng ban'
                                      : null,
                          minLines: 1,
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _staffOwnerController,
                    decoration: inputDecoration(
                      'Người quản lý',
                      required: true,
                    ),
                    validator:
                        (v) =>
                            v == null || v.isEmpty
                                ? 'Nhập người quản lý'
                                : null,
                    minLines: 1,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          if (widget.onCancel != null) {
                            widget.onCancel!();
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF7B8EC8),
                          side: const BorderSide(color: Color(0xFFE6EAF3)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Hủy'),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2264E5),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: Text(isEdit ? 'Cập nhật' : 'Lưu'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
