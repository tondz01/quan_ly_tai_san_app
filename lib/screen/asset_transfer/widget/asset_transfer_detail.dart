// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/asset_transfer_movement_table.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/bottom_list_asset_transfer.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/property_handover_minutes.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/asset_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/user.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/asset_transfer_provider.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/note/widget/note_view.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_dropdown_input_button.dart';
import 'package:se_gay_components/common/sg_indicator.dart';
import 'package:se_gay_components/common/sg_input_text.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';

class AssetTransferDetail extends StatefulWidget {
  final AssetTransferDto? item;
  final bool isEditing;
  final bool? isNew;
  final AssetTransferProvider provider;

  const AssetTransferDetail({
    super.key,
    this.item,
    this.isEditing = false,
    this.isNew = false,
    required this.provider,
  });

  @override
  State<AssetTransferDetail> createState() => _AssetTransferDetailState();
}

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

  late AssetTransferDto currentItem;

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
    if (widget.item == null && _selectedFileName == null) {
      newValidationErrors['document'] = true;
    }

    // Check movement details
    // if (widget.item?.movementDetails == null ||
    //     (widget.item?.movementDetails?.isEmpty ?? true)) {
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
    _callGetListAssetHandover();
    isEditing = widget.isEditing;
    if (widget.item != null && widget.item!.status == 0) {
      isEditing = true;
    }
    if (widget.isNew == true) {
      onReload();
    }

    // Initialize controllers with existing values if available (only once)
    if (widget.item != null && !_controllersInitialized) {
      controllerSubject.text = widget.item?.subject ?? '';
      controllerDocumentName.text = widget.item?.documentName ?? '';
      controllerDeliveringUnit.text = widget.item?.deliveringUnit ?? '';
      controllerReceivingUnit.text = widget.item?.receivingUnit ?? '';
      controllerRequester.text = widget.item?.requester ?? '';
      controllerDepartmentApproval.text = widget.item?.departmentApproval ?? '';
      controllerEffectiveDate.text = widget.item?.effectiveDate ?? '';
      controllerEffectiveDateTo.text = widget.item?.effectiveDateTo ?? '';
      controllerApprover.text = widget.item?.approver ?? '';
      controllerDeliveryLocation.text = widget.item?.deliveryLocation ?? '';

      // Initialize selected file if available
      _selectedFileName = widget.item?.documentFileName;
      _selectedFilePath = widget.item?.documentFilePath;

      _controllersInitialized = true;
    } else if (widget.item == null && !_controllersInitialized) {
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

    isPreparerInitialed = widget.item?.preparerInitialed ?? false;
    isRequireManagerApproval = widget.item?.requireManagerApproval ?? false;
    isDeputyConfirmed = widget.item?.deputyConfirmed ?? false;
    proposingUnit = widget.item?.proposingUnit;

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

  // // Initialize FilePicker
  // Future<void> _initializeFilePicker() async {
  //   try {
  //     // We'll just do a simple check if the platform is supported
  //     // This will help initialize FilePicker without forcing a clearTemporaryFiles operation
  //     await FilePicker.platform.getDirectoryPath();
  //   } catch (e) {
  //     log('FilePicker initialization check: $e');
  //     // Silently continue, as we'll handle errors during actual file picking
  //   }
  // }

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
    log('dispose');
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

    // Dispose de los controladores de términos del contrato
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
    if (widget.item == null && !isRefreshing) {
      log('widget.item == null');
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

        // Lắng nghe từ bloc khác (ví dụ: NoteBloc)
        // BlocListener<NoteBloc, NoteState>(
        //   listener: (context, state) {
        //     if (state is NoteCreatedSuccessState) {
        //       // Handle note creation success
        //     }
        //   },
        // ),
      ],
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: _showResponsive(),
        ),
      ),
    );
  }

  Widget _showResponsive() {
    final size = MediaQuery.of(context).size;
    if (size.width < 1560) {
      return Column(
        children: [
          _buildTableDetail(),
          const SizedBox(height: 10),
          _buildNoteSection(),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 4, child: _buildTableDetail()),
          const SizedBox(width: 10),
          Expanded(flex: 2, child: _buildNoteSection()),
        ],
      );
    }
  }

  Widget _buildNoteSection() {
    return SizedBox(
      height: 400,
      // padding: const EdgeInsets.all(8),
      // decoration: BoxDecoration(
      //   // color: Colors.white,
      //   borderRadius: BorderRadius.circular(8),
      //   border: Border.all(color: Colors.grey.shade300),
      // ),
      child: IgnorePointer(
        ignoring: false,
        child: AbsorbPointer(
          absorbing: false,
          child: RepaintBoundary(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return const NoteView();
              },
            ),
          ),
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
                                final provider =
                                    Provider.of<AssetTransferProvider>(
                                  context,
                                  listen: false,
                                );
                                provider.onChangeScreen(
                                  item: null,
                                  isMainScreen: true,
                                  isEdit: false,
                                );
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
              // fontSize: 10,
              currentStep: widget.item?.status ?? 0,
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
              _buildDetailRow(
                label: 'at.document_name'.tr,
                controller: controllerDocumentName,
                isEditing: isEditing,
                textContent: widget.item?.documentName ?? '',
                fieldName: 'documentName',
              ),
              _buildDetailRow(
                label: 'Trích yêu',
                controller: controllerSubject,
                isEditing: isEditing,
                textContent: widget.item?.subject ?? '',
                fieldName: 'subject',
              ),
              _buildDetailRow(
                label: 'at.delivering_unit'.tr,
                controller: controllerDeliveringUnit,
                isEditing: isEditing,
                textContent: widget.item?.deliveringUnit ?? '',
                isDropdown: true,
                items: itemsrReceivingUnit,
                fieldName: 'deliveringUnit',
              ),
              _buildDetailRow(
                label: 'at.receiving_unit'.tr,
                controller: controllerReceivingUnit,
                isEditing: isEditing,
                textContent: widget.item?.receivingUnit ?? '',
                isDropdown: true,
                items: itemsrReceivingUnit,
                fieldName: 'receivingUnit',
              ),
              _buildDetailRow(
                label: 'at.requester'.tr,
                controller: controllerRequester,
                isEditing: isEditing,
                textContent: widget.item?.requester ?? '',
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
              _buildDetailRow(
                label: 'at.proposing_unit'.tr,
                controller: controllerProposingUnit,
                isEditing: false,
                textContent: proposingUnit ?? '',
                inputType: TextInputType.number,
              ),
              _buildDetailRow(
                label: 'at.department_approval'.tr,
                controller: controllerDepartmentApproval,
                isEditing: isEditing,
                textContent: widget.item?.departmentApproval ?? '',
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
              ),
              _buildDetailRow(
                label: 'at.effective_date'.tr,
                controller: controllerEffectiveDate,
                isEditing: isEditing,
                textContent:
                    isEditing
                        ? AppUtility.formatDateDdMmYyyy(DateTime.now())
                        : widget.item?.effectiveDate ??
                            (isEditing
                                ? AppUtility.formatDateDdMmYyyy(DateTime.now())
                                : ''),
                fieldName: 'effectiveDate',
              ),
              _buildDetailRow(
                label: 'at.effective_date_to'.tr,
                controller: controllerEffectiveDateTo,
                isEditing: isEditing,
                textContent: widget.item?.effectiveDateTo ?? '',
                fieldName: 'effectiveDateTo',
              ),
              _buildDetailRow(
                label: 'at.approver'.tr,
                controller: controllerApprover,
                isEditing: isEditing,
                textContent: widget.item?.approver ?? '',
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
              ),
              _buildDocumentUpload(), // Add document upload section
              const SizedBox(height: 20),
              assetTransferMovementTable(
                context,
                widget.item?.movementDetails ?? [],
                isEditing,
              ),
              
              const SizedBox(height: 10),
              BottomListAssetTransfer(
                provider: widget.provider,
                listAssetHandover: listAssetHandover,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String textContent,
    required TextEditingController controller,
    required bool isEditing,
    bool isDropdown = false,
    bool isEnable = true,
    TextInputType? inputType,
    List<DropdownMenuItem<String>>? items,
    Function(String)? onChanged,
    String? fieldName, // Add parameter for field name
  }) {
    // Check if this field has validation errors
    bool hasError = fieldName != null && _validationErrors[fieldName] == true;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              '$label :',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color:
                    !isEditing ? Colors.black87.withOpacity(0.6) : Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isDropdown && isEditing
                    ? SGDropdownInputButton<String>(
                      height: 35,
                      controller: controller,
                      textOverflow: TextOverflow.ellipsis,
                      // Use value directly rather than setting controller.text
                      value: textContent,
                      defaultValue: textContent,
                      items: items ?? [],
                      colorBorder:
                          hasError ? Colors.red : SGAppColors.neutral400,
                      showUnderlineBorderOnly: true,
                      enableSearch: false,
                      isClearController:
                          false, // Ensure this is false to prevent clearing controller
                      fontSize: 16,
                      inputType: inputType,
                      isShowSuffixIcon: true,
                      hintText: 'Chọn ${label.toLowerCase()}',
                      textAlign: TextAlign.left,
                      textAlignItem: TextAlign.left,
                      sizeBorderCircular: 10,
                      contentPadding: const EdgeInsets.only(top: 8, bottom: 8),
                      onChanged: (value) {
                        if (value != null) {
                          log('Dropdown value changed: $value for $label');
                          // Call provided onChanged callback first
                          onChanged?.call(value);
                          // Clear validation error when value changes
                          if (hasError) {
                            setState(() {
                              _validationErrors.remove(fieldName);
                            });
                          }
                        }
                      },
                    )
                    : SGInputText(
                      height: 35,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      controller:
                          controller, // Remove the ..text = textContent assignment
                      borderRadius: 10,
                      enabled: isEnable ? isEditing : false,
                      textAlign: TextAlign.left,
                      readOnly: !isEditing,
                      inputFormatters:
                          inputType == TextInputType.number
                              ? [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.,]'),
                                ),
                              ]
                              : null,
                      onlyLine: true,
                      color: Colors.black,
                      showBorder: isEditing,
                      borderColor: hasError ? Colors.red : null,
                      hintText: !isEditing ? '' : '${'common.hint'.tr} $label',
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      onChanged: (value) {
                        // Clear validation error when text changes
                        if (hasError) {
                          setState(() {
                            _validationErrors.remove(fieldName);
                          });
                        }
                      },
                    ),
                if (hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Trường \'$label\' không được để trống', // Trường 'label.toLowerCase()' không được để trống
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
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

  // Add method to build document upload section
  Widget _buildDocumentUpload() {
    // Check if document has validation error
    bool hasError = _validationErrors['document'] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Tài liệu Quyết định',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasError ? Colors.red : Colors.grey.shade200,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // File selection row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: hasError ? Colors.red : Colors.grey.shade300,
                        ),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.description,
                            color: Colors.blue.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedFileName ?? 'Chưa chọn tệp',
                              style: TextStyle(
                                color:
                                    _selectedFileName != null
                                        ? Colors.black
                                        : Colors.grey.shade600,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          if (_selectedFileName != null)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedFileName = null;
                                  _selectedFilePath = null;
                                });
                              },
                              child: Icon(
                                Icons.close,
                                color: Colors.grey.shade600,
                                size: 16,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: isEditing ? _selectWordDocument : null,
                    icon: const Icon(Icons.upload_file, size: 18),
                    label: const Text('Chọn tệp'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue.shade700,
                      disabledBackgroundColor: Colors.grey.shade400,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed:
                        (_selectedFileName != null &&
                                isEditing &&
                                !_isUploading)
                            ? _uploadWordDocument
                            : null,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green.shade600,
                      disabledBackgroundColor: Colors.grey.shade400,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    child:
                        _isUploading
                            ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text('Tải lên'),
                  ),
                ],
              ),
              // Error message if document is required
              if (hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Tài liệu quyết định là bắt buộc',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              // Document format hint
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Định dạng hỗ trợ: .doc, .docx (Microsoft Word)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Method to select a Word document
  Future<void> _selectWordDocument() async {
    try {
      // Use a simpler configuration to avoid initialization issues
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['doc', 'docx'],
        withData: false, // Don't load file data in memory
        withReadStream: false, // Don't use read stream
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        setState(() {
          _selectedFileName = file.name;
          _selectedFilePath = file.path;

          // Clear document validation error if it exists
          if (_validationErrors.containsKey('document')) {
            _validationErrors.remove('document');
          }
        });
        log('Selected file: $_selectedFileName, Path: $_selectedFilePath');
      }
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi chọn tệp: ${e.message}'),
          backgroundColor: Colors.red.shade600,
        ),
      );
    } catch (e) {
      log('Error selecting file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể chọn tệp: ${e.toString()}'),
          backgroundColor: Colors.red.shade600,
        ),
      );
    }
  }

  // Method to upload the Word document
  Future<void> _uploadWordDocument() async {
    if (_selectedFilePath == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      // Simulate upload with delay
      await Future.delayed(const Duration(seconds: 2));

      // In a real app, we would upload the file to a server here
      // Example:
      // final file = File(_selectedFilePath!);
      // final response = await yourApiService.uploadDocument(file);

      log('File uploaded successfully: $_selectedFileName');

      // Clear any document validation errors
      setState(() {
        _validationErrors.remove('document');
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tệp "$_selectedFileName" đã được tải lên thành công'),
          backgroundColor: Colors.green.shade600,
        ),
      );
    } catch (e) {
      log('Error uploading file: $e');
      // Show error message
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

  // Add a method to save the form data
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
      // Get current values from controllers to ensure we capture the latest data
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
        id: widget.item?.id, // Keep original ID if editing an existing item
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
        status: widget.item?.status ?? 1, // Keep status or set to draft (0)
        // Keep the existing movement details or use an empty list
        movementDetails: widget.item?.movementDetails ?? [],
        deliveryLocation: currentDeliveryLocation,
        // Include document file information
        documentFilePath: _selectedFilePath,
        documentFileName: _selectedFileName,
        proposingUnit: proposingUnit,
      );

      // Access provider to save the data
      final provider = Provider.of<AssetTransferProvider>(
        context,
        listen: false,
      );

      if (widget.item == null) {
        // Creating a new asset transfer
        await provider.createAssetTransfer(savedItem);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tạo phiếu điều chuyển thành công'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Updating existing asset transfer
        await provider.updateAssetTransfer(savedItem);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cập nhật phiếu điều chuyển thành công'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Return to the list view
      provider.onChangeScreen(item: null, isMainScreen: true, isEdit: false);
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

  // Cancel function to return to list view without saving
  void onReload() {
    isEditing = true;
    // Reload trang khi tạo mới
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // Reset tất cả controllers về trạng thái ban đầu
        controllerSubject.clear();
        controllerDocumentName.clear();
        controllerDeliveringUnit.clear();
        controllerReceivingUnit.clear();
        controllerRequester.clear();
        controllerProposingUnit.clear();
        controllerQuantity.clear();
        controllerDepartmentApproval.clear();
        controllerEffectiveDate.clear();
        controllerEffectiveDateTo.clear();
        controllerApprover.clear();
        controllerDeliveryLocation.clear();
        controllerViewerDepartments.clear();
        controllerViewerUsers.clear();
        controllerReason.clear();
        controllerBase.clear();
        controllerArticle1.clear();
        controllerArticle2.clear();
        controllerArticle3.clear();
        controllerDestination.clear();

        // Reset các biến trạng thái
        isPreparerInitialed = false;
        isRequireManagerApproval = false;
        isDeputyConfirmed = false;
        proposingUnit = null;

        // Reset file upload
        _selectedFileName = null;
        _selectedFilePath = null;
        _isUploading = false;

        // Clear validation errors
        _validationErrors.clear();

        // Reset initialization flag để cho phép khởi tạo lại
        _controllersInitialized = false;
      });
    });
  }

  void _callGetListAssetHandover() {
    try {
      final assetHandoverBloc = BlocProvider.of<AssetHandoverBloc>(context);

      assetHandoverBloc.add(GetListAssetHandoverEvent(context));

      log('Calling getListAssetHandover from AssetHandoverBloc');
    } catch (e) {
      log('Error calling getListAssetHandover: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi lấy danh sách: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
