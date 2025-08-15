import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/pages/department_form_page.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/bloc/staff_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/bloc/staff_event.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/chuc_vu.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/staff.dart';
import 'package:se_gay_components/base_api/api_config.dart';

class StaffFormPage extends StatefulWidget {
  final NhanVien? staff;
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
  late TextEditingController _positionController;
  late TextEditingController _staffIdController;
  late TextEditingController _staffOwnerController;
  late TextEditingController _kieuKyController;
  late TextEditingController _agreementUUIdController;
  late TextEditingController _pinController;
  bool _laQuanLy = false;
  PhongBan? _phongBan;
  NhanVien? _staffDTO;
  ChucVu? _chucVuDTO;
  Uint8List? _chuKyData;
  @override
  void initState() {
    _initData();
    super.initState();
  }

  void _initData() {
    _nameController = TextEditingController(text: widget.staff?.hoTen ?? '');
    _telController = TextEditingController(text: widget.staff?.diDong ?? '');
    _emailController = TextEditingController(
      text: widget.staff?.emailCongViec ?? '',
    );
    _activityController = TextEditingController(
      text: widget.staff?.isActive ?? false ? 'Có' : 'Không',
    );
    _positionController = TextEditingController(
      text: widget.staff?.chucVu ?? '',
    );
    _staffIdController = TextEditingController(text: widget.staff?.id ?? '');
    _staffOwnerController = TextEditingController(
      text: widget.staff?.nguoiQuanLy ?? '',
    );
    try {
      _phongBan = context.read<StaffBloc>().department.firstWhere(
        (group) => group.id == widget.staff?.phongBanId,
      );
    } catch (e) {
      _phongBan = null;
    }
    try {
      _staffDTO = context.read<StaffBloc>().staffs.firstWhere(
        (staff) => staff.id == widget.staff?.id,
      );
    } catch (e) {
      _staffDTO = null;
    }
    try {
      _chucVuDTO = context.read<StaffBloc>().chucvus.firstWhere(
        (chucVu) => chucVu.id == widget.staff?.chucVuId,
      );
    } catch (e) {
      _chucVuDTO = null;
    }
    _kieuKyController = TextEditingController(
      text: widget.staff?.kieuKy?.toString() ?? '',
    );
    _agreementUUIdController = TextEditingController(
      text: widget.staff?.agreementUUId ?? '',
    );
    _pinController = TextEditingController(text: widget.staff?.pin ?? '');
    _laQuanLy = widget.staff?.laQuanLy ?? false;
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
    _positionController.dispose();
    _staffIdController.dispose();
    _staffOwnerController.dispose();
    _kieuKyController.dispose();
    _agreementUUIdController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      if (widget.staff != null) {
        final staff = widget.staff!.copyWith(
          hoTen: _nameController.text.trim(),
          diDong: _telController.text.trim(),
          emailCongViec: _emailController.text.trim(),
          isActive: true, // Assuming isActive is always true for new staff
          chucVu: _chucVuDTO?.id,
          id: _staffIdController.text.trim(),
          nguoiQuanLy: _staffDTO?.id ?? '',
          kieuKy: int.tryParse(_kieuKyController.text),
          agreementUUId: _agreementUUIdController.text.trim(),
          pin: _pinController.text.trim(),
          // chuKy được upload qua file picker, không nhập text
          laQuanLy: _laQuanLy,
          boPhan: _phongBan?.id,
          chuKyData: _chuKyData,
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
    } else {
      final staff = NhanVien(
        hoTen: _nameController.text.trim(),
        diDong: _telController.text.trim(),
        emailCongViec: _emailController.text.trim(),
        isActive: true, // Assuming isActive is always true for new staff
        chucVu: _chucVuDTO?.id,
        id: _staffIdController.text.trim(),
        nguoiQuanLy: _staffDTO?.id ?? '',
        kieuKy: int.tryParse(_kieuKyController.text),
        agreementUUId: _agreementUUIdController.text.trim(),
        pin: _pinController.text.trim(),
        // chuKy được upload qua file picker, không nhập text
        laQuanLy: _laQuanLy,
        boPhan: _phongBan?.id,
        chuKyData: _chuKyData,
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

  File? selectedFile;
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
        _chuKyData = result.files.single.bytes;
      });
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            TextFormField(
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
                            const SizedBox(height: 16),
                            TextFormField(
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
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              decoration: inputDecoration(
                                'Email',
                                required: true,
                              ),
                              validator:
                                  (v) =>
                                      v == null || v.isEmpty
                                          ? 'Nhập email'
                                          : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
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
                            const SizedBox(height: 16),
                            DropdownButtonFormField<ChucVu>(
                              value: _chucVuDTO,
                              decoration: inputDecoration('Chức vụ'),
                              items:
                                  context
                                      .read<StaffBloc>()
                                      .chucvus
                                      .map(
                                        (chucVu) => DropdownMenuItem(
                                          value: chucVu,
                                          child: Row(
                                            children: [
                                              const SizedBox(width: 8),
                                              Text(chucVu.tenChucVu),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (v) => setState(() => _chucVuDTO = v),
                            ),

                            const SizedBox(height: 16),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                onTap: _pickFile,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.shade100,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.upload_file,
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Builder(
                                          builder: (_) {
                                            if (selectedFile != null) {
                                              return Text(
                                                "Chữ ký: ${selectedFile!.path.split('/').last}",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              );
                                            }
                                            final currentSignature =
                                                widget.staff?.chuKy;
                                            if (currentSignature != null &&
                                                currentSignature.isNotEmpty) {
                                              print(
                                                "${ApiConfig.getBaseURL()}/api/upload/download/${currentSignature.split("/").last}",
                                              );
                                              return Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                    child: SizedBox(
                                                      height: 32,
                                                      child: Image.network(
                                                        '${ApiConfig.getBaseURL()}/api/upload/download/${currentSignature.split("/").last}',
                                                        fit: BoxFit.contain,
                                                        errorBuilder: (context, error, stackTrace) {
                                                          return SizedBox();
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Text(
                                                    'Nhấn để chọn file chữ ký mới',
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              );
                                            }
                                            return Text(
                                              'Nhấn để chọn file chữ ký (.png, .jpg...)',
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            );
                                          },
                                        ),
                                      ),
                                      if (selectedFile != null)
                                        IconButton(
                                          icon: const Icon(
                                            Icons.close,
                                            size: 20,
                                            color: Colors.red,
                                          ),
                                          onPressed:
                                              () => setState(
                                                () => selectedFile = null,
                                              ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Checkbox(
                                  value: _laQuanLy,
                                  onChanged:
                                      (val) => setState(
                                        () => _laQuanLy = val ?? false,
                                      ),
                                ),
                                const Text('Là quản lý'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            DropdownButtonFormField<NhanVien>(
                              value: _staffDTO,
                              decoration: inputDecoration('Quản lý'),
                              items:
                                  context
                                      .read<StaffBloc>()
                                      .staffs
                                      .map(
                                        (staff) => DropdownMenuItem(
                                          value: staff,
                                          child: Row(
                                            children: [
                                              const SizedBox(width: 8),
                                              Text(staff?.hoTen ?? ''),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (v) => setState(() => _staffDTO = v),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
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
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _kieuKyController,
                              decoration: inputDecoration('Kiểu ký'),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _agreementUUIdController,
                              decoration: inputDecoration('Agreement UUID'),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _pinController,
                              decoration: inputDecoration('PIN'),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<PhongBan>(
                              value: _phongBan,
                              decoration: inputDecoration('Phòng/Ban cấp trên'),
                              items:
                                  context
                                      .read<StaffBloc>()
                                      .department
                                      .map(
                                        (p) => DropdownMenuItem(
                                          value: p,
                                          child: Text(p.tenPhongBan ?? ''),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (v) => setState(() => _phongBan = v),
                            ),
                          ],
                        ),
                      ),
                    ],
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
