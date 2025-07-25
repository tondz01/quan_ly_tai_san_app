import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/bloc/staff_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/bloc/staff_event.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/staff.dart';
import 'package:se_gay_components/common/sg_button.dart';
import 'package:se_gay_components/common/sg_textfield.dart';

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
    super.initState();
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
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.staff != null;
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
                      isEdit
                          ? 'Cập nhật thông tin nhân viên'
                          : 'Thêm mới nhân viên',
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
                                    controller: _staffIdController,
                                    label: 'Mã nhân viên',
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.orange,
                                    ),
                                    validator:
                                        (v) =>
                                            v == null || v.isEmpty
                                                ? 'Nhập mã nhân viên'
                                                : null,
                                    minLines: 1,
                                    maxLines: 3,
                                  ),
                                ),
                                const SizedBox(width: 25),
                                Expanded(
                                  child: SGTextField(
                                    controller: _nameController,
                                    label: 'Tên nhân viên',
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.orange,
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
                                  child: SGTextField(
                                    controller: _emailController,
                                    label: 'Email',
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Colors.orange,
                                    ),
                                    validator:
                                        (v) =>
                                            v == null || v.isEmpty
                                                ? 'Nhập email'
                                                : null,
                                  ),
                                ),
                                const SizedBox(width: 25),
                                Expanded(
                                  child: SGTextField(
                                    controller: _telController,
                                    label: 'Số điện thoại',
                                    prefixIcon: Icon(
                                      Icons.phone,
                                      color: Colors.orange,
                                    ),
                                    validator:
                                        (v) =>
                                            v == null || v.isEmpty
                                                ? 'Nhập số điện thoại'
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
                                    controller: _activityController,
                                    label: 'Hoạt động',
                                    prefixIcon: Icon(
                                      Icons.note_alt,
                                      color: Colors.orange,
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
                                const SizedBox(width: 25),
                                Expanded(
                                  child: SGTextField(
                                    controller: _timeForActivityController,
                                    label: 'Hạn chót cho hoạt động tiếp theo',
                                    prefixIcon: Icon(
                                      Icons.calendar_month,
                                      color: Colors.orange,
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
                                  child: SGTextField(
                                    controller: _positionController,
                                    label: 'Chức vụ',
                                    prefixIcon: Icon(
                                      Icons.work,
                                      color: Colors.orange,
                                    ),
                                    validator:
                                        (v) =>
                                            v == null || v.isEmpty
                                                ? 'Nhập chức vụ'
                                                : null,
                                  ),
                                ),
                                const SizedBox(width: 25),
                                Expanded(
                                  child: SGTextField(
                                    controller: _departmentController,
                                    label: 'Phòng ban',
                                    prefixIcon: Icon(
                                      Icons.home,
                                      color: Colors.orange,
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
                            Row(
                              children: [
                                Expanded(
                                  child: SGTextField(
                                    controller: _staffOwnerController,
                                    label: 'Người quản lý',
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.orange,
                                    ),
                                    validator:
                                        (v) =>
                                            v == null || v.isEmpty
                                                ? 'Nhập người quản lý'
                                                : null,
                                    minLines: 1,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
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
