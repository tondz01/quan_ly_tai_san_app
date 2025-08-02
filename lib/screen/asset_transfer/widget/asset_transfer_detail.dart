// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/common/input/common_checkbox_input.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/asset_transfer_movement_table.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/asset_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/user.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/asset_transfer_provider.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:se_gay_components/common/sg_indicator.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/common/widgets/document_upload_widget.dart';

class AssetTransferDetail extends StatefulWidget {
  final bool isEditing;
  final bool? isNew;
  final AssetTransferProvider provider;

  const AssetTransferDetail({
    super.key,
    this.isEditing = false,
    this.isNew = false,
    required this.provider,
  });

  @override
  State<AssetTransferDetail> createState() => _AssetTransferDetailState();
}

// GlobalKey để truy cập widget từ bên ngoài
final GlobalKey<_AssetTransferDetailState> assetTransferDetailKey =
    GlobalKey<_AssetTransferDetailState>();

class _AssetTransferDetailState extends State<AssetTransferDetail> {
  late TextEditingController controllerSubject = TextEditingController();
  late TextEditingController controllerDocumentName = TextEditingController();
  late TextEditingController controllerDeliveringUnit = TextEditingController();
  late TextEditingController controllerReceivingUnit = TextEditingController();
  late TextEditingController controllerRequester = TextEditingController();
  late TextEditingController controllerProposingUnit = TextEditingController();
  late TextEditingController controllerQuantity = TextEditingController();
  late TextEditingController controllerDepartmentApproval =
      TextEditingController();
  late TextEditingController controllerEffectiveDate = TextEditingController();
  late TextEditingController controllerEffectiveDateTo =
      TextEditingController();
  late TextEditingController controllerApprover = TextEditingController();
  late TextEditingController controllerDeliveryLocation =
      TextEditingController();
  late TextEditingController controllerViewerDepartments =
      TextEditingController();
  late TextEditingController controllerViewerUsers = TextEditingController();
  late TextEditingController controllerReason = TextEditingController();
  late TextEditingController controllerBase = TextEditingController();
  late TextEditingController controllerArticle1 = TextEditingController();
  late TextEditingController controllerArticle2 = TextEditingController();
  late TextEditingController controllerArticle3 = TextEditingController();
  late TextEditingController controllerDestination = TextEditingController();

  bool isEditing = false;
  bool isPreparerInitialed = false;
  bool isRequireManagerApproval = false;
  bool isDeputyConfirmed = false;
  bool _isUploading = false;
  bool isRefreshing = false;
  bool isNew = false;

  String? proposingUnit;
  bool _controllersInitialized = false;
  String? _selectedFileName;
  String? _selectedFilePath;

  late AssetTransferDto? item;

  final Map<String, TextEditingController> contractTermsControllers = {};

  final List<AssetHandoverDto> listAssetHandover = [];

  Map<String, bool> _validationErrors = {};

  bool _validateForm() {
    Map<String, bool> newValidationErrors = {};

    if (controllerDocumentName.text.isEmpty) {
      newValidationErrors['documentName'] = true;
    }

    if (controllerSubject.text.isEmpty) {
      newValidationErrors['subject'] = true;
    }

    if (controllerDeliveringUnit.text.isEmpty) {
      newValidationErrors['deliveringUnit'] = true;
    }

    if (controllerReceivingUnit.text.isEmpty) {
      newValidationErrors['receivingUnit'] = true;
    }

    if (controllerEffectiveDate.text.isEmpty) {
      newValidationErrors['effectiveDate'] = true;
    }

    if (controllerEffectiveDateTo.text.isEmpty) {
      newValidationErrors['effectiveDateTo'] = true;
    }

    if (controllerRequester.text.isEmpty) {
      newValidationErrors['requester'] = true;
    }

    // If it's a new item, document is required
    if (item == null && _selectedFileName == null) {
      newValidationErrors['document'] = true;
    }

    // Check movement details
    // if (item?.movementDetails == null ||
    //     (item?.movementDetails?.isEmpty ?? true)) {
    //   newValidationErrors['movementDetails'] = true;
    // }

    // Only update state if validation errors have changed
    bool hasChanges = !mapEquals(_validationErrors, newValidationErrors);
    if (hasChanges) {
      setState(() {
        _validationErrors = newValidationErrors;
      });
    }

    return newValidationErrors.isEmpty;
  }

  @override
  void initState() {
    super.initState();
    item = widget.provider.item;
    _callGetListAssetHandover();
    isEditing = widget.isEditing;

    if (item != null && item!.status == 0) {
      isEditing = true;
    }
    if (widget.isNew == true) {
      onReload();
    }

    // Initialize controllers with existing values if available (only once)
    if (item != null && !_controllersInitialized) {
      controllerSubject.text = item?.subject ?? '';
      controllerDocumentName.text = item?.documentName ?? '';
      controllerDeliveringUnit.text = item?.deliveringUnit ?? '';
      controllerReceivingUnit.text = item?.receivingUnit ?? '';
      controllerRequester.text = item?.requester ?? '';
      controllerDepartmentApproval.text = item?.departmentApproval ?? '';
      controllerEffectiveDate.text = item?.effectiveDate ?? '';
      controllerEffectiveDateTo.text = item?.effectiveDateTo ?? '';
      controllerApprover.text = item?.approver ?? '';
      controllerDeliveryLocation.text = item?.deliveryLocation ?? '';

      // Initialize selected file if available
      _selectedFileName = item?.documentFileName;
      _selectedFilePath = item?.documentFilePath;
      isPreparerInitialed = item?.preparerInitialed ?? false;
      isRequireManagerApproval = item?.requireManagerApproval ?? false;
      isDeputyConfirmed = item?.deputyConfirmed ?? false;
      proposingUnit = item?.proposingUnit;

      _controllersInitialized = true;
    } else if (item == null && !_controllersInitialized) {
      // Initialize controllers for new items (empty strings)
      controllerSubject.text = '';
      controllerDocumentName.text = '';
      controllerDeliveringUnit.text = '';
      controllerReceivingUnit.text = '';
      controllerRequester.text = '';
      controllerDepartmentApproval.text = '';
      controllerEffectiveDate.text = '';
      controllerEffectiveDateTo.text = '';
      controllerApprover.text = '';
      controllerDeliveryLocation.text = '';
      controllerProposingUnit.text = '';

      _controllersInitialized = false;
      _selectedFileName = null;
      _selectedFilePath = null;
      isPreparerInitialed = false;
      isRequireManagerApproval = false;
      isDeputyConfirmed = false;
    }

    if (proposingUnit != null &&
        proposingUnit!.isNotEmpty &&
        !_controllersInitialized) {
      controllerProposingUnit.text = proposingUnit!;
    }

    itemsRequester =
        users
            .map(
              (user) => DropdownMenuItem<String>(
                value: user.id ?? '',
                child: Text(user.name ?? ''),
              ),
            )
            .toList();
  }

  @override
  void didUpdateWidget(AssetTransferDetail oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Kiểm tra nếu provider item thay đổi
    if (widget.provider.item != oldWidget.provider.item) {
      _refreshWidget();
    }

    // Kiểm tra nếu isNew thay đổi
    if (widget.isNew != oldWidget.isNew) {
      _refreshWidget();
    }

    // Kiểm tra nếu isEditing thay đổi
    if (widget.isEditing != oldWidget.isEditing) {
      _refreshWidget();
    }
  }

  // Method để làm mới widget
  void _refreshWidget() {
    setState(() {
      // Reset item từ provider
      item = widget.provider.item;
      log('message item: $item');
      isNew = item == null;

      // Reset editing state
      isEditing = widget.isEditing;
      if (item != null && item!.status == 0) {
        isEditing = true;
      }

      // Reset các biến trạng thái
      isPreparerInitialed = item?.preparerInitialed ?? false;
      isRequireManagerApproval = item?.requireManagerApproval ?? false;
      isDeputyConfirmed = item?.deputyConfirmed ?? false;
      proposingUnit = item?.proposingUnit;

      // Reset file upload
      _selectedFileName = item?.documentFileName;
      _selectedFilePath = item?.documentFilePath;

      _validationErrors.clear();

      _controllersInitialized = false;

      _isUploading = false;
      isRefreshing = false;
    });
  }

  final List<DropdownMenuItem<String>> itemsrReceivingUnit = [
    const DropdownMenuItem(value: 'Ban giám đốc', child: Text('Ban giám đốc')),
    const DropdownMenuItem(
      value: 'Chưa xác định / C.Ty TNHH MTV Môi trường - Vinacomin',
      child: Text('Chưa xác định / C.Ty TNHH MTV Môi trường - Vinacomin'),
    ),
    const DropdownMenuItem(
      value: 'Chưa xác định',
      child: Text('Chưa xác định'),
    ),
    const DropdownMenuItem(
      value: 'Công ty CP Cơ điện Uông bí - Vinacomin',
      child: Text('Công ty CP Cơ điện Uông bí - Vinacomin'),
    ),
    const DropdownMenuItem(
      value: 'Công ty TNHH Nam Hưng',
      child: Text('Công ty TNHH Nam Hưng'),
    ),
    const DropdownMenuItem(value: 'Công đoàn', child: Text('Công đoàn')),
    const DropdownMenuItem(value: 'Kho Công ty', child: Text('Kho Công ty')),
    const DropdownMenuItem(
      value: 'Phân xưởng KT1',
      child: Text('Phân xưởng KT1'),
    ),
    const DropdownMenuItem(
      value: 'P.xưởng Thông gió - thoát nước mỏ 1',
      child: Text('P.xưởng Thông gió - thoát nước mỏ 1'),
    ),
  ];

  late final List<DropdownMenuItem<String>> itemsRequester;

  @override
  void dispose() {
    // Giải phóng các controller
    controllerSubject.dispose();
    controllerDocumentName.dispose();
    controllerDeliveringUnit.dispose();
    controllerReceivingUnit.dispose();
    controllerRequester.dispose();
    controllerProposingUnit.dispose();
    controllerQuantity.dispose();
    controllerDepartmentApproval.dispose();
    controllerEffectiveDate.dispose();
    controllerEffectiveDateTo.dispose();
    controllerApprover.dispose();
    controllerDeliveryLocation.dispose();
    controllerViewerDepartments.dispose();
    controllerViewerUsers.dispose();

    for (final controller in contractTermsControllers.values) {
      controller.dispose();
    }

    // Reset initialization flag
    _controllersInitialized = false;

    super.dispose();
  }

  void findPhongBan(String? value) {
    log('message');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    log('screenWidth: $screenWidth');

    _checkAndRefreshWidget();

    if (item == null && !isRefreshing) {
      log('item == null');
      onReload();
      isEditing = true;
      isRefreshing = true;
    }

    return MultiBlocListener(
      listeners: [
        // Lắng nghe từ AssetHandoverBloc
        BlocListener<AssetHandoverBloc, AssetHandoverState>(
          listener: (context, state) {
            if (state is GetListAssetHandoverSuccessState) {
              // Handle successful data loading
              listAssetHandover.clear();
              listAssetHandover.addAll(state.data);
              log('Asset handover data loaded successfully');
            } else if (state is GetListAssetHandoverFailedState) {
            } else if (state is AssetHandoverLoadingState) {
              // Show loading indicator
              setState(() {
                _isUploading = true;
              });
            } else if (state is AssetHandoverLoadingDismissState) {
              // Hide loading indicator
              setState(() {
                _isUploading = false;
              });
            }
          },
        ),
      ],
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: _buildTableDetail(),
        ),
      ),
    );
  }

  Widget _buildTableDetail() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (isEditing)
              Row(
                children: [
                  MaterialTextButton(
                    text: 'Lưu',
                    icon: Icons.save,
                    backgroundColor: ColorValue.success,
                    foregroundColor: Colors.white,
                    onPressed: () {
                      _saveAssetTransfer(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  MaterialTextButton(
                    text: 'Hủy',
                    icon: Icons.cancel,
                    backgroundColor: ColorValue.error,
                    foregroundColor: Colors.white,
                    onPressed: () {
                      // Confirm before canceling if there are changes
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text('Xác nhận hủy'),
                              content: Text(
                                'Bạn có chắc chắn muốn hủy? Các thay đổi chưa được lưu sẽ bị mất.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.pop(
                                        context,
                                      ), // Close dialog
                                  child: Text('Không'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close dialog
                                  },
                                  child: Text('Có'),
                                ),
                              ],
                            ),
                      );
                    },
                  ),
                ],
              ),
            const SizedBox(width: 5),
            SgIndicator(
              steps: [
                'Nháp',
                'Chờ xác nhận',
                'Xác nhận',
                'Trình duyệt',
                'Duyệt',
                'Từ chối',
                'Hủy',
                'Hoàn thành',
              ],
              fontSize: 10,
              currentStep: item?.status ?? 0,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonFormInput(
                label: 'at.document_name'.tr,
                controller: controllerDocumentName,
                isEditing: isEditing,
                textContent: item?.documentName ?? '',
                fieldName: 'documentName',
                validationErrors: _validationErrors,
              ),
              CommonFormInput(
                label: 'Trích yêu',
                controller: controllerSubject,
                isEditing: isEditing,
                textContent: item?.subject ?? '',
                fieldName: 'subject',
                validationErrors: _validationErrors,
              ),
              CommonFormInput(
                label: 'at.delivering_unit'.tr,
                controller: controllerDeliveringUnit,
                isEditing: isEditing,
                textContent: item?.deliveringUnit ?? '',
                isDropdown: false,
                items: itemsrReceivingUnit,
                fieldName: 'deliveringUnit',
                validationErrors: _validationErrors,
              ),
              CommonFormInput(
                label: 'at.receiving_unit'.tr,
                controller: controllerReceivingUnit,
                isEditing: isEditing,
                textContent: item?.receivingUnit ?? '',
                isDropdown: true,
                items: itemsrReceivingUnit,
                fieldName: 'receivingUnit',
                validationErrors: _validationErrors,
              ),
              CommonFormInput(
                label: 'at.requester'.tr,
                controller: controllerRequester,
                isEditing: isEditing,
                textContent: item?.requester ?? '',
                isDropdown: true,
                items: itemsRequester,
                onChanged: (value) {
                  log('Requester selected: $value');

                  var selectedUser = users.firstWhere(
                    (user) => user.id == value,
                  );
                  proposingUnit = selectedUser.department;
                  controllerRequester.text = selectedUser.name ?? '';
                  // Update the proposingUnit controller without triggering a rebuild
                  // controllerProposingUnit.text = proposingUnit ?? '';
                  log('proposingUnit set to: $proposingUnit');
                },
                fieldName: 'requester',
                validationErrors: _validationErrors,
              ),
              CommonCheckboxInput(
                label: 'at.preparer_initialed'.tr,
                value: isPreparerInitialed,
                isEditing: isEditing,
                isEnable: false,
                onChanged: (newValue) {
                  setState(() {
                    isPreparerInitialed = newValue;
                  });
                },
              ),
              CommonCheckboxInput(
                label: 'at.require_manager_approval'.tr,
                value: isRequireManagerApproval,
                isEditing: isEditing,
                isEnable: false,
                onChanged: (newValue) {
                  setState(() {
                    isRequireManagerApproval = newValue;
                  });
                },
              ),
              if (isRequireManagerApproval)
                CommonCheckboxInput(
                  label: 'at.deputy_confirmed'.tr,
                  value: isDeputyConfirmed,
                  isEditing: isEditing,
                  isEnable: false,
                  onChanged: (newValue) {
                    setState(() {
                      isDeputyConfirmed = newValue;
                    });
                  },
                ),
              CommonFormInput(
                label: 'at.proposing_unit'.tr,
                controller: controllerProposingUnit,
                isEditing: false,
                textContent: proposingUnit ?? '',
                inputType: TextInputType.number,
                validationErrors: _validationErrors,
              ),
              CommonFormInput(
                label: 'at.department_approval'.tr,
                controller: controllerDepartmentApproval,
                isEditing: isEditing,
                textContent: item?.departmentApproval ?? '',
                fieldName: 'departmentApproval',
                isDropdown: true,
                items: itemsRequester,
                onChanged: (value) {
                  log('Department approval selected: $value');
                  var selectedUser = users.firstWhere(
                    (user) => user.id == value,
                  );
                  controllerDepartmentApproval.text = selectedUser.name ?? '';
                },
                validationErrors: _validationErrors,
              ),
              CommonFormInput(
                label: 'at.effective_date'.tr,
                controller: controllerEffectiveDate,
                isEditing: isEditing,
                textContent:
                    isEditing
                        ? AppUtility.formatDateDdMmYyyy(DateTime.now())
                        : item?.effectiveDate ??
                            (isEditing
                                ? AppUtility.formatDateDdMmYyyy(DateTime.now())
                                : ''),
                fieldName: 'effectiveDate',
                validationErrors: _validationErrors,
              ),
              CommonFormInput(
                label: 'at.effective_date_to'.tr,
                controller: controllerEffectiveDateTo,
                isEditing: isEditing,
                textContent: item?.effectiveDateTo ?? '',
                fieldName: 'effectiveDateTo',
                validationErrors: _validationErrors,
              ),
              CommonFormInput(
                label: 'at.approver'.tr,
                controller: controllerApprover,
                isEditing: isEditing,
                textContent: item?.approver ?? '',
                isDropdown: true,
                items: itemsRequester,
                onChanged: (value) {
                  var selectedUser = users.firstWhere(
                    (user) => user.id == value,
                  );
                  controllerApprover.text = selectedUser.name ?? '';
                },
                fieldName: 'approver',
                validationErrors: _validationErrors,
              ),
              DocumentUploadWidget(
                isEditing: isEditing,
                selectedFileName: _selectedFileName,
                selectedFilePath: _selectedFilePath,
                validationErrors: _validationErrors,
                onFileSelected: (fileName, filePath) {
                  setState(() {
                    _selectedFileName = fileName;
                    _selectedFilePath = filePath;

                    if (_validationErrors.containsKey('document')) {
                      _validationErrors.remove('document');
                    }
                  });
                },
                onUpload: _uploadWordDocument,
                isUploading: _isUploading,
                label: 'Tài liệu Quyết định',
                errorMessage: 'Tài liệu quyết định là bắt buộc',
                hintText: 'Định dạng hỗ trợ: .doc, .docx (Microsoft Word)',
                allowedExtensions: ['doc', 'docx'],
              ),

              // const SizedBox(height: 20),
              assetTransferMovementTable(
                context,
                item?.movementDetails ?? [],
                isEditing,
              ),

              //
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _uploadWordDocument() async {
    if (_selectedFilePath == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _validationErrors.remove('document');
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tệp "$_selectedFileName" đã được tải lên thành công'),
          backgroundColor: Colors.green.shade600,
        ),
      );
    } catch (e) {
      log('Error uploading file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi tải lên tệp: ${e.toString()}'),
          backgroundColor: Colors.red.shade600,
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _saveAssetTransfer(BuildContext context) async {
    if (!isEditing) return;

    // Validate form first
    if (!_validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng điền đầy đủ thông tin bắt buộc'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final currentDocumentName = controllerDocumentName.text;
      final currentSubject = controllerSubject.text;
      final currentDeliveringUnit = controllerDeliveringUnit.text;
      final currentReceivingUnit = controllerReceivingUnit.text;
      final currentRequester = controllerRequester.text;
      final currentDepartmentApproval = controllerDepartmentApproval.text;
      final currentEffectiveDate = controllerEffectiveDate.text;
      final currentEffectiveDateTo = controllerEffectiveDateTo.text;
      final currentApprover = controllerApprover.text;
      final currentDeliveryLocation = controllerDeliveryLocation.text;

      // Create an AssetTransferDto with the form data
      final AssetTransferDto savedItem = AssetTransferDto(
        id: item?.id, // Keep original ID if editing an existing item
        documentName: currentDocumentName,
        subject: currentSubject,
        deliveringUnit: currentDeliveringUnit,
        receivingUnit: currentReceivingUnit,
        requester: currentRequester,
        preparerInitialed: isPreparerInitialed,
        requireManagerApproval: isRequireManagerApproval,
        deputyConfirmed: isDeputyConfirmed,
        departmentApproval: currentDepartmentApproval,
        effectiveDate: currentEffectiveDate,
        effectiveDateTo: currentEffectiveDateTo,
        approver: currentApprover,
        status: item?.status ?? 1, // Keep status or set to draft (0)
        // Keep the existing movement details or use an empty list
        movementDetails: item?.movementDetails ?? [],
        deliveryLocation: currentDeliveryLocation,
        // Include document file information
        documentFilePath: _selectedFilePath,
        documentFileName: _selectedFileName,
        proposingUnit: proposingUnit,
      );

      final provider = Provider.of<AssetTransferProvider>(
        context,
        listen: false,
      );

      if (item == null) {
        await provider.createAssetTransfer(savedItem);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tạo phiếu điều chuyển thành công'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        await provider.updateAssetTransfer(savedItem);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cập nhật phiếu điều chuyển thành công'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // provider.onChangeScreen(item: null, isMainScreen: true, isEdit: false);
    } catch (e) {
      log('Error saving asset transfer: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void onReload() {
    _refreshWidget();
  }

  void refreshWidget() {
    _refreshWidget();
  }

  void _checkAndRefreshWidget() {
    if (widget.provider.item != item) {
      _refreshWidget();
    }

    if (widget.isNew == true && item != null) {
      _refreshWidget();
    }
  }

  void _callGetListAssetHandover() {
    try {
      final assetHandoverBloc = BlocProvider.of<AssetHandoverBloc>(context);
      assetHandoverBloc.add(GetListAssetHandoverEvent(context));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi lấy danh sách: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
