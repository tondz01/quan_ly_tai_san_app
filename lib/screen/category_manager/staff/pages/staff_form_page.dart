import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/input/common_checkbox_input.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_dropdown_object.dart';
import 'package:quan_ly_tai_san_app/common/widgets/input_decoration_custom.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/pages/department_form_page.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/bloc/staff_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/component/staff_save_service.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/constants/staff_constants.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/model/chuc_vu.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:se_gay_components/base_api/api_config.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/switch/sg_checkbox.dart';

class StaffFormPage extends StatefulWidget {
  final NhanVien? staff;
  final List<NhanVien>? staffs;
  final int? index;
  final VoidCallback? onCancel;
  final VoidCallback? onSaved;
  final bool isCanUpdate;
  final bool isNew;
  const StaffFormPage({
    super.key,
    this.staff,
    this.staffs,
    this.index,
    this.onCancel,
    this.onSaved,
    this.isCanUpdate = false,
    this.isNew = false,
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
  late TextEditingController _agreementUUIdController;
  late TextEditingController _pinController;
  final TextEditingController controllerDepartment = TextEditingController();
  final TextEditingController controllerChucVu = TextEditingController();
  bool _laQuanLy = false;
  bool isEditing = false;
  PhongBan? _phongBan;
  NhanVien? _staffDTO;
  ChucVu? _chucVuDTO;
  Uint8List? _chuKyNhayData;
  Uint8List? _chuKyThuongData;

  String? _chuKyNhayPathExisting;
  String? _chuKyThuongPathExisting;

  bool _kyNhay = false;
  bool _kyThuong = false;
  bool _kySo = false;
  bool _isActive = false;
  bool _savePin = false;
  bool _obscurePassword = true;
  String? errorChuKyNhay;
  String? errorChuKyThuong;

  bool validateChuKyNhay() {
    if (_kyNhay) {
      final bool hasExisting =
          widget.staff != null && (_chuKyNhayPathExisting?.isNotEmpty ?? false);
      if (selectedFileChuKyNhay == null && !hasExisting) {
        setState(() {
          errorChuKyNhay = 'Vui lòng chọn file chữ ký nháy';
        });
        return true;
      }
    }
    setState(() {
      errorChuKyNhay = null;
    });
    return false;
  }

  bool validateChuKyThuong() {
    if (_kyThuong) {
      final bool hasExisting =
          widget.staff != null &&
          (_chuKyThuongPathExisting?.isNotEmpty ?? false);
      if (selectedFileChuKyThuong == null && !hasExisting) {
        setState(() {
          errorChuKyThuong = 'Vui lòng chọn file chữ ký thường';
        });
        return true;
      }
    }
    setState(() {
      errorChuKyThuong = null;
    });
    return false;
  }

  @override
  void initState() {
    _initData();
    super.initState();
  }

  void _initData() {
    log(
      '_checkPermission: ${widget.isCanUpdate}, isNew: ${widget.isNew} , data: ${widget.staff != null}',
    );
    if (widget.staff != null) {
      isEditing = false;
    } else {
      isEditing = true;
    }
    if (!widget.isCanUpdate && !widget.isNew) {
      isEditing = false;
    }
    _nameController = TextEditingController(text: widget.staff?.hoTen ?? '');
    _telController = TextEditingController(text: widget.staff?.diDong ?? '');
    _emailController = TextEditingController(
      text: widget.staff?.emailCongViec ?? '',
    );
    log('savePin: ${widget.staff?.savePin}');
    _isActive = widget.staff?.active ?? false;
    _savePin = widget.staff?.savePin ?? false;
    _activityController = TextEditingController(
      text: _isActive ? 'Có' : 'Không',
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
      controllerDepartment.text = _phongBan?.tenPhongBan ?? '';
    } catch (e) {
      _phongBan = null;
    }
    try {
      if (widget.staff?.quanLyId != null) {
        _staffDTO = getStaffById(widget.staff?.quanLyId ?? '');
      }
    } catch (e) {
      _staffDTO = null;
    }
    try {
      _chucVuDTO = context.read<StaffBloc>().chucvus.firstWhere(
        (chucVu) => chucVu.id == widget.staff?.chucVuId,
      );
      controllerChucVu.text = _chucVuDTO?.tenChucVu ?? '';
    } catch (e) {
      _chucVuDTO = null;
    }
    _agreementUUIdController = TextEditingController(
      text: widget.staff?.agreementUUId ?? '',
    );
    _laQuanLy = widget.staff?.laQuanLy ?? false;
    _kyNhay = widget.staff?.kyNhay ?? false;
    _kyThuong = widget.staff?.kyThuong ?? false;
    _kySo = widget.staff?.kySo ?? false;
    _pinController = TextEditingController(text: widget.staff?.pin ?? '');

    selectedFileChuKyNhay =
        widget.staff?.chuKyNhay != null ? File(widget.staff!.chuKyNhay!) : null;
    selectedFileChuKyThuong =
        widget.staff?.chuKyThuong != null
            ? File(widget.staff!.chuKyThuong!)
            : null;

    // Đặt sẵn đường dẫn chữ ký hiện có (nếu có) để hiển thị và validate khi cập nhật
    _chuKyNhayPathExisting = widget.staff?.chuKyNhay;
    _chuKyThuongPathExisting = widget.staff?.chuKyThuong;
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

  NhanVien? getStaffById(String id) {
    return widget.staffs?.firstWhere((staff) => staff.id == id);
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
    _agreementUUIdController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _save() async {
    AccountHelper.instance.getUserInfo();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (validateChuKyNhay() || validateChuKyThuong()) {
      return;
    }
    log('savePin: $_savePin');
    final bool ok = await StaffSaveService.save(
      context: context,
      existingStaff: widget.staff,
      nameController: _nameController,
      telController: _telController,
      emailController: _emailController,
      staffIdController: _staffIdController,
      agreementUUIdController: _agreementUUIdController,
      pinController: _pinController,
      laQuanLy: _laQuanLy,
      kyNhay: _kyNhay,
      kyThuong: _kyThuong,
      kySo: _kySo,
      phongBan: _phongBan,
      staffDTO: _staffDTO,
      chucVuDTO: _chucVuDTO,
      selectedFileChuKyNhay: selectedFileChuKyNhay,
      selectedFileChuKyThuong: selectedFileChuKyThuong,
      fileNameChuKyNhay: fileNameChuKyNhay,
      fileNameChuKyThuong: fileNameChuKyThuong,
      chuKyNhayData: _chuKyNhayData,
      chuKyThuongData: _chuKyThuongData,
      isActive: _isActive,
      savePin: _savePin,
    );

    if (ok && widget.onSaved != null) {
      widget.onSaved!();
    }
  }

  File? selectedFileChuKyNhay; //type 1
  File? selectedFileChuKyThuong; // type 2
  String? fileNameChuKyNhay;
  String? fileNameChuKyThuong;
  Future<void> _pickFile(File? selectedFile, int typeKy) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
        if (typeKy == 1) {
          selectedFileChuKyNhay = selectedFile;
          fileNameChuKyNhay = result.files.single.name;
          if (selectedFileChuKyNhay != null) {
            validateChuKyNhay();
          }
        } else if (typeKy == 2) {
          selectedFileChuKyThuong = selectedFile;
          if (selectedFileChuKyThuong != null) {
            validateChuKyThuong();
          }
          fileNameChuKyThuong = result.files.single.name;
        }
        if (typeKy == 1) {
          _chuKyNhayData = result.files.single.bytes;
        } else if (typeKy == 2) {
          _chuKyThuongData = result.files.single.bytes;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          if (widget.isNew ||
              (widget.isCanUpdate && !widget.isNew && widget.staff != null))
            _buildHeaderDetail(),
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
                              readOnly: !isEditing,
                              decoration: inputDecoration(
                                'Mã nhân viên',
                                required: true,
                              ),
                              enabled: isEditing, // Read-only khi update
                              validator:
                                  (v) =>
                                      v == null || v.isEmpty
                                          ? 'Nhập mã nhân viên'
                                          : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _nameController,
                              readOnly: !isEditing,
                              decoration: inputDecoration(
                                'Tên nhân viên',
                                required: true,
                              ),
                              enabled: isEditing,
                              validator:
                                  (v) =>
                                      v == null || v.isEmpty
                                          ? 'Nhập tên nhân viên'
                                          : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              readOnly: !isEditing,
                              decoration: inputDecoration(
                                'Email',
                                required: true,
                              ),
                              enabled: isEditing,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return StaffConstants.errorRequiredField;
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(v)) {
                                  return StaffConstants.errorEmailFormat;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _telController,
                              readOnly: !isEditing,
                              decoration: inputDecoration(
                                'Số điện thoại',
                                required: true,
                              ),
                              enabled: isEditing,
                              keyboardType: TextInputType.phone,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return StaffConstants.errorRequiredField;
                                }
                                final normalized = v.replaceAll(' ', '');
                                String candidate;
                                if (normalized.startsWith('+')) {
                                  if (!normalized.startsWith('+84')) {
                                    return StaffConstants.errorPhoneFormat;
                                  }
                                  candidate = '0${normalized.substring(3)}';
                                } else {
                                  candidate = normalized;
                                }

                                final phonePattern = RegExp(r'^0\d{9,10}$');
                                if (!phonePattern.hasMatch(candidate)) {
                                  return StaffConstants.errorPhoneFormat;
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),
                            CmFormDropdownObject<ChucVu>(
                              label: 'Chức vụ',
                              controller: controllerChucVu,
                              isEditing: isEditing,
                              value: _chucVuDTO,
                              fieldName: 'chucvu',
                              items: [
                                ...context.read<StaffBloc>().chucvus.map(
                                  (e) => DropdownMenuItem<ChucVu>(
                                    value: e,
                                    child: Text(e.tenChucVu),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                _chucVuDTO = value;
                              },
                              validationErrors: {
                                'chucvu': _chucVuDTO == null && isEditing,
                              },
                              isRequired: true,
                            ),
                            const SizedBox(height: 16),
                            CmFormDropdownObject<PhongBan>(
                              label: 'Phòng ban/Bộ phận',
                              controller: controllerDepartment,
                              isEditing: isEditing,
                              value: _phongBan,
                              fieldName: 'department',
                              items: [
                                ...context.read<StaffBloc>().department.map(
                                  (e) => DropdownMenuItem<PhongBan>(
                                    value: e,
                                    child: Text(e.tenPhongBan ?? ''),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                _phongBan = value;
                              },
                              validationErrors: {
                                'department': _phongBan == null && isEditing,
                              },
                              isRequired: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildKieuKy(),
                            if (_kySo)
                              Column(
                                spacing: 16,
                                children: [
                                  TextFormField(
                                    readOnly: !isEditing,
                                    enabled: isEditing,
                                    controller: _agreementUUIdController,
                                    decoration: inputDecoration(
                                      'Agreement UUID',
                                    ),
                                    validator:
                                        (v) =>
                                            v == null || v.isEmpty
                                                ? 'Nhập Agreement UUID'
                                                : null,
                                  ),
                                  TextFormField(
                                    controller: _pinController,
                                    decoration: InputDecoration(
                                      labelText: 'PIN',
                                      hintText: "Nhập mã Pin",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),

                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                      suffixIcon:
                                          isEditing
                                              ? IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _obscurePassword =
                                                        !_obscurePassword;
                                                  });
                                                },
                                                icon: Icon(
                                                  _obscurePassword
                                                      ? Icons.visibility_off
                                                      : Icons.visibility,
                                                ),
                                              )
                                              : null,
                                    ),
                                    readOnly: !isEditing,
                                    enabled: isEditing,
                                    obscureText: _obscurePassword,
                                    onChanged: (value) {
                                      setState(() {
                                        // _pinController.text = value;
                                      });
                                    },

                                    validator:
                                        (v) =>
                                            v == null || v.isEmpty
                                                ? 'Nhập PIN'
                                                : null,
                                  ),
                                  CommonCheckboxInput(
                                    label: 'Lưu mã PIN',
                                    value: _savePin,
                                    isEditing: isEditing,
                                    isDisabled: !isEditing,
                                    onChanged: (value) {
                                      setState(() {
                                        if (_pinController.text.isEmpty &&
                                            value) {
                                          AppUtility.showSnackBar(
                                            context,
                                            'Vui lòng nhập PIN trước khi lưu mã PIN',
                                            isError: true,
                                          );
                                          return;
                                        }
                                        _savePin = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildUploadFileChuKy(
    String chuky,
    File? selectedFile,
    int typeKy,
  ) {
    return Container(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: isEditing ? () => _pickFile(selectedFile, typeKy) : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade100,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.upload_file, color: Colors.green),
              const SizedBox(width: 12),
              Expanded(
                child: Builder(
                  builder: (_) {
                    if (selectedFile == selectedFileChuKyNhay) {
                    } else if (selectedFile == selectedFileChuKyThuong) {}
                    if (selectedFile != null) {
                      return Text(
                        "Chữ ký: ${selectedFile.path.split('/').last}",
                        style: const TextStyle(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      );
                    }
                    if (chuky.isNotEmpty) {
                      return Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: SizedBox(
                              height: 32,
                              child: Image.network(
                                '${ApiConfig.getBaseURL()}/api/upload/download/${chuky.split("/").last}',
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
                            style: TextStyle(color: Colors.grey.shade600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      );
                    }
                    return Text(
                      'Nhấn để chọn file chữ ký (.png, .jpg...)',
                      style: TextStyle(color: Colors.grey.shade600),
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ),
              if (selectedFile != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 20, color: Colors.red),
                  padding: EdgeInsets.zero,
                  onPressed:
                      isEditing
                          ? () => setState(() {
                            if (typeKy == 1) {
                              selectedFileChuKyNhay = null;
                            } else if (typeKy == 2) {
                              selectedFileChuKyThuong = null;
                            }
                          })
                          : null,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKieuKy() {
    return Column(
      spacing: 16,
      children: [
        Column(
          children: [
            SizedBox(
              height: 48,
              child: Row(
                spacing: 8,
                children: [
                  SizedBox(width: 100, child: const SGText(text: "Ký nháy:")),
                  SgCheckbox(
                    value: _kyNhay,
                    isDisabled: !isEditing,
                    onChanged:
                        (value) => setState(() {
                          _kyNhay = value;
                        }),
                  ),
                  if (_kyNhay)
                    Expanded(
                      child:
                          isEditing
                              ? _buildUploadFileChuKy(
                                _chuKyNhayPathExisting ?? '',
                                selectedFileChuKyNhay,
                                1,
                              )
                              : (_chuKyNhayPathExisting != null &&
                                      _chuKyNhayPathExisting!.isNotEmpty
                                  ? Image.network(
                                    '${ApiConfig.getBaseURL()}/api/upload/download/${_chuKyNhayPathExisting!.split('/').last}',
                                    height: 32,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            SizedBox(height: 32),
                                  )
                                  : SizedBox()),
                    ),
                ],
              ),
            ),
            if (errorChuKyNhay != null)
              SGText(text: errorChuKyNhay ?? '', color: Colors.red),
          ],
        ),
        Column(
          children: [
            SizedBox(
              height: 48,
              child: Row(
                spacing: 8,
                children: [
                  SizedBox(width: 100, child: const SGText(text: "Ký thường:")),
                  SgCheckbox(
                    value: _kyThuong,
                    isDisabled: !isEditing,
                    onChanged:
                        (value) => setState(() {
                          _kyThuong = value;
                        }),
                  ),
                  if (_kyThuong)
                    Expanded(
                      child:
                          isEditing
                              ? _buildUploadFileChuKy(
                                _chuKyThuongPathExisting ?? '',
                                selectedFileChuKyThuong,
                                2,
                              )
                              : (_chuKyThuongPathExisting != null &&
                                      _chuKyThuongPathExisting!.isNotEmpty
                                  ? Image.network(
                                    '${ApiConfig.getBaseURL()}/api/upload/download/${_chuKyThuongPathExisting!.split('/').last}',
                                    height: 32,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            SizedBox(height: 32),
                                  )
                                  : SizedBox()),
                    ),
                ],
              ),
            ),
            if (errorChuKyThuong != null)
              SGText(text: errorChuKyThuong ?? '', color: Colors.red),
          ],
        ),
        SizedBox(
          height: 48,
          child: Row(
            spacing: 8,
            children: [
              SizedBox(width: 100, child: const SGText(text: "Ký số:")),
              SgCheckbox(
                value: _kySo,
                isDisabled: !isEditing,
                onChanged:
                    (value) => setState(() {
                      _kySo = value;
                    }),
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
                _save();
              },
            ),
            const SizedBox(width: 8),
            MaterialTextButton(
              text: 'Hủy',
              icon: Icons.cancel,
              backgroundColor: ColorValue.error,
              foregroundColor: Colors.white,
              onPressed: () {
                if (widget.onCancel != null) {
                  widget.onCancel!();
                }
              },
            ),
          ],
        )
        : MaterialTextButton(
          text: 'Chỉnh sửa nhân viên',
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

  // void _changeTypeKy(int type) {
  //   setState(() {
  //     _kyNhay = type == 1;
  //     _kyThuong = type == 2;
  //     _kySo = type == 3;
  //     _kieuKyController.text = type.toString();
  //   });
  // }
}
