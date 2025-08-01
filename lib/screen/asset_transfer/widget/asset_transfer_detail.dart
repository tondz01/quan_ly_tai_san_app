// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
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
final GlobalKey<_AssetTransferDetailState> assetTransferDetailKey = GlobalKey<_AssetTransferDetailState>();

/*
CÁCH SỬ DỤNG WIDGET VỚI KHẢ NĂNG LÀM MỚI:

1. Sử dụng GlobalKey để truy cập widget:
   AssetTransferDetail(
     key: assetTransferDetailKey,
     provider: provider,
     isEditing: true,
     isNew: false,
   )

2. Làm mới widget từ bên ngoài:
   assetTransferDetailKey.currentState?.refreshWidget();

3. Widget sẽ tự động làm mới khi:
   - Provider item thay đổi
   - isNew thay đổi
   - isEditing thay đổi
   - Widget được rebuild với dữ liệu mới

4. Các trường hợp làm mới tự động:
   - Khi chuyển từ xem chi tiết sang tạo mới
   - Khi chuyển từ tạo mới sang chỉnh sửa
   - Khi provider cập nhật item mới
   - Khi widget được gọi lại với tham số khác
*/
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

      _controllersInitialized = true;
    }

    isPreparerInitialed = item?.preparerInitialed ?? false;
    isRequireManagerApproval = item?.requireManagerApproval ?? false;
    isDeputyConfirmed = item?.deputyConfirmed ?? false;
    proposingUnit = item?.proposingUnit;

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
      log('AssetTransferDetail: Provider item changed, refreshing widget');
      _refreshWidget();
    }
    
    // Kiểm tra nếu isNew thay đổi
    if (widget.isNew != oldWidget.isNew) {
      log('AssetTransferDetail: isNew changed, refreshing widget');
      _refreshWidget();
    }
    
    // Kiểm tra nếu isEditing thay đổi
    if (widget.isEditing != oldWidget.isEditing) {
      log('AssetTransferDetail: isEditing changed, refreshing widget');
      _refreshWidget();
    }
  }

  // Method để làm mới widget
  void _refreshWidget() {
    setState(() {
      // Reset item từ provider
      item = widget.provider.item;
      
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
      
      // Clear validation errors
      _validationErrors.clear();
      
      // Reset initialization flag để cho phép khởi tạo lại controllers
      _controllersInitialized = false;
      
      // Reset loading states
      _isUploading = false;
      isRefreshing = false;
    });
    
    // Khởi tạo lại controllers với dữ liệu mới
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeControllers();
    });
  }

  // Method để khởi tạo controllers
  void _initializeControllers() {
    if (item != null) {
      // Initialize controllers with existing values
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
      controllerProposingUnit.text = proposingUnit ?? '';
    } else {
      // Initialize controllers for new items (empty strings)
      controllerSubject.clear();
      controllerDocumentName.clear();
      controllerDeliveringUnit.clear();
      controllerReceivingUnit.clear();
      controllerRequester.clear();
      controllerDepartmentApproval.clear();
      controllerEffectiveDate.clear();
      controllerEffectiveDateTo.clear();
      controllerApprover.clear();
      controllerDeliveryLocation.clear();
      controllerProposingUnit.clear();
    }
    
    _controllersInitialized = true;
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
    
    // Kiểm tra và làm mới widget nếu cần
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
                                    // Access provider to navigate back
                                    // final provider =
                                    //     Provider.of<AssetTransferProvider>(
                                    //       context,
                                    //       listen: false,
                                    //     );
                                    // provider.isShowInput = true;
                                    // provider.onChangeDetailAssetTransfer(null);
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
                isDropdown: true,
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
              _buildDetailCheckBox(
                label: 'at.preparer_initialed'.tr,
                valueBoolean: isPreparerInitialed,
                isEditing: isEditing,
                isEnable: false,
              ),
              _buildDetailCheckBox(
                label: 'at.require_manager_approval'.tr,
                valueBoolean: isRequireManagerApproval,
                isEditing: isEditing,
                isEnable: false,
              ),
              if (isRequireManagerApproval)
                _buildDetailCheckBox(
                  label: 'at.deputy_confirmed'.tr,
                  valueBoolean: isDeputyConfirmed,
                  isEditing: isEditing,
                  isEnable: false,
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
                  log('Approver selected: $value');
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
              // assetTransferMovementTable(
              //   context,
              //   item?.movementDetails ?? [],
              //   isEditing,
              // ),

              //
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCheckBox({
    required String label,
    required bool valueBoolean,
    required bool isEditing,
    required bool isEnable,
  }) {
    // Primero, obtener el valor actual para este checkbox
    bool currentValue = valueBoolean;
    if (label == 'at.preparer_initialed'.tr) {
      currentValue = isPreparerInitialed;
    } else if (label == 'at.require_manager_approval'.tr) {
      currentValue = isRequireManagerApproval;
    } else if (label == 'at.deputy_confirmed'.tr) {
      currentValue = isDeputyConfirmed;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: Text(
              '$label :',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color:
                    !isEnable ? Colors.black : Colors.black87.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(width: 18),
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: currentValue,
              onChanged:
                  !isEnable
                      ? (newValue) {
                        setState(() {
                          // Actualizar el estado correcto según el label
                          if (label == 'at.preparer_initialed'.tr) {
                            isPreparerInitialed = newValue ?? false;
                            log(
                              'isPreparerInitialed cambiado a: $isPreparerInitialed',
                            );
                          } else if (label ==
                              'at.require_manager_approval'.tr) {
                            isRequireManagerApproval = newValue ?? false;
                            log(
                              'isRequireManagerApproval cambiado a: $isRequireManagerApproval',
                            );
                          } else if (label == 'at.deputy_confirmed'.tr) {
                            isDeputyConfirmed = newValue ?? false;
                            log(
                              'isDeputyConfirmed cambiado a: $isDeputyConfirmed',
                            );
                          }
                        });
                      }
                      : null,
              activeColor: const Color(0xFF80C9CB),
              checkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
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
      _isUploading = true; // Show loading state while saving
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
    log('AssetTransferDetail: onReload called');
    _refreshWidget();
  }

  void refreshWidget() {
    log('AssetTransferDetail: refreshWidget called from outside');
    _refreshWidget();
  }

  void _checkAndRefreshWidget() {
    if (widget.provider.item != item) {
      log('AssetTransferDetail: Provider item changed in build, refreshing widget');
      _refreshWidget();
    }
    
    if (widget.isNew == true && item != null) {
      log('AssetTransferDetail: isNew is true but item exists, refreshing widget');
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
