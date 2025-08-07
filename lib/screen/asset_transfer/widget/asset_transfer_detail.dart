import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_input.dart';
import 'package:quan_ly_tai_san_app/common/input/common_checkbox_input.dart';
import 'package:quan_ly_tai_san_app/common/web_view/web_view_common.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/component/asset_transfer_movement_table.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/controller/asset_transfer_controller.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/asset_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/asset_transfer_provider.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:se_gay_components/common/sg_indicator.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/common/widgets/document_upload_widget.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class AssetTransferDetail extends StatefulWidget {
  final bool isEditing;
  final bool? isNew;
  final AssetTransferProvider provider;
  final AssetTransferController? controller;

  const AssetTransferDetail({
    super.key,
    this.isEditing = false,
    this.isNew = false,
    required this.provider,
    this.controller,
  });

  @override
  State<AssetTransferDetail> createState() => _AssetTransferDetailState();
}

final assetTransferDetailKey = GlobalKey<_AssetTransferDetailState>();

class _AssetTransferDetailState extends State<AssetTransferDetail> {
  String url =
      'https://firebasestorage.googleapis.com/v0/b/shopifyappdata.appspot.com/o/document%2FB%C3%A0n%20giao%20t%C3%A0i%20s%E1%BA%A3n.pdf?alt=media&token=497ba34e-891b-45b0-b228-704ca958760b';

  // Controller instance to manage business logic
  late AssetTransferController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? AssetTransferController();
    controller.initialize(widget.provider, isEditingParam: widget.isEditing, isNewParam: widget.isNew);
    _callGetListAssetHandover();

    if (widget.isNew == true) {
      onReload();
    }
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

    // Kiểm tra nếu listNhanVien thay đổi
    if (widget.provider.listNhanVien != oldWidget.provider.listNhanVien) {
      setState(() {
        controller.updateStaffData(widget.provider.listNhanVien, widget.provider.listPhongBan);
      });
    }
  }

  // Method để làm mới widget
  void _refreshWidget() {
    SGLog.info("AssetTransferDetail", ' _refreshWidget');
    setState(() {
      controller.refreshFromProvider(widget.provider, isEditingParam: widget.isEditing, isNewParam: widget.isNew);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    SGLog.debug("AssetTransferDetail", ' screenWidth: $screenWidth');

    _checkAndRefreshWidget();

    if (controller.item == null && !controller.isRefreshing) {
      SGLog.debug("AssetTransferDetail", ' item == null');
      onReload();
      controller.isEditing = true;
      controller.isRefreshing = true;
    }

    return MultiBlocListener(
      listeners: [
        // Lắng nghe từ AssetHandoverBloc
        BlocListener<AssetHandoverBloc, AssetHandoverState>(
          listener: (context, state) {
            if (state is GetListAssetHandoverSuccessState) {
              // Handle successful data loading
              setState(() {
                controller.listAssetHandover.clear();
                controller.listAssetHandover.addAll(state.data);
              });
              SGLog.debug("AssetTransferDetail", ' Asset handover data loaded successfully');
            } else if (state is GetListAssetHandoverFailedState) {
            } else if (state is AssetHandoverLoadingState) {
              // Show loading indicator
              setState(() {
                controller.isUploading = true;
              });
            } else if (state is AssetHandoverLoadingDismissState) {
              // Hide loading indicator
              setState(() {
                controller.isUploading = false;
              });
            }
          },
        ),
      ],
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(padding: const EdgeInsets.only(top: 10.0), child: _buildTableDetail()),
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
            if (controller.isEditing)
              Row(
                children: [
                  MaterialTextButton(
                    text: 'Lưu',
                    icon: Icons.save,
                    backgroundColor: ColorValue.success,
                    foregroundColor: Colors.white,
                    onPressed: () {
                      // controller.saveAssetTransfer(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  MaterialTextButton(
                    text: 'Hủy',
                    icon: Icons.cancel,
                    backgroundColor: ColorValue.error,
                    foregroundColor: Colors.white,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text('Xác nhận hủy'),
                              content: Text('Bạn có chắc chắn muốn hủy? Các thay đổi chưa được lưu sẽ bị mất.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context), // Close dialog
                                  child: Text('Không'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.read<AssetTransferProvider>().isShowCollapse = false;
                                    context.read<AssetTransferProvider>().isShowInput = false;
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
              steps: ['Nháp', 'Chờ xác nhận', 'Xác nhận', 'Trình duyệt', 'Duyệt', 'Từ chối', 'Hủy', 'Hoàn thành'],
              fontSize: 10,
              currentStep: controller.item?.trangThai ?? 0,
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
                controller: controller.controllerDocumentName,
                isEditing: controller.isEditing,
                textContent: controller.item?.tenPhieu ?? '',
                fieldName: 'documentName',
                validationErrors: controller.validationErrors,
              ),
              CommonFormInput(
                label: 'Trích yêu',
                controller: controller.controllerSubject,
                isEditing: controller.isEditing,
                textContent: controller.item?.trichYeu ?? '',
                fieldName: 'subject',
                validationErrors: controller.validationErrors,
              ),
              CommonFormInput(
                label: 'at.delivering_unit'.tr,
                controller: controller.controllerDeliveringUnit,
                isEditing: controller.isEditing,
                textContent: controller.item?.tenDonViGiao ?? '',
                fieldName: 'deliveringUnit',
                validationErrors: controller.validationErrors,
              ),
              CommonFormInput(
                label: 'at.receiving_unit'.tr,
                controller: controller.controllerReceivingUnit,
                isEditing: controller.isEditing,
                textContent: controller.item?.tenDonViNhan ?? '',
                isDropdown: true,
                items: controller.itemsDepartmentManager,
                fieldName: 'receivingUnit',
                validationErrors: controller.validationErrors,
              ),
              CommonFormInput(
                label: 'at.requester'.tr,
                controller: controller.controllerRequester,
                isEditing: controller.isEditing,
                textContent: controller.item?.tenNguoiDeNghi ?? '',
                isDropdown: true,
                items: controller.itemsRequester,
                onChanged: (value) {
                  setState(() {
                    controller.onRequesterChanged(value);
                  });
                },
                fieldName: 'requester',
                validationErrors: controller.validationErrors,
              ),
              CommonCheckboxInput(
                label: 'at.preparer_initialed'.tr,
                value: controller.isPreparerInitialed,
                isEditing: controller.isEditing,
                isEnable: false,
                onChanged: (newValue) {
                  setState(() {
                    controller.isPreparerInitialed = newValue;
                  });
                },
              ),
              CommonCheckboxInput(
                label: 'at.require_manager_approval'.tr,
                value: controller.isRequireManagerApproval,
                isEditing: controller.isEditing,
                isEnable: false,
                onChanged: (newValue) {
                  setState(() {
                    controller.isRequireManagerApproval = newValue;
                  });
                },
              ),
              if (controller.isRequireManagerApproval)
                CommonCheckboxInput(
                  label: 'at.deputy_confirmed'.tr,
                  value: controller.isDeputyConfirmed,
                  isEditing: controller.isEditing,
                  isEnable: false,
                  onChanged: (newValue) {
                    setState(() {
                      controller.isDeputyConfirmed = newValue;
                    });
                  },
                ),
              CommonFormInput(
                label: 'at.proposing_unit'.tr,
                controller: controller.controllerProposingUnit,
                isEditing: false,
                textContent: controller.proposingUnit ?? '',
                inputType: TextInputType.number,
                validationErrors: controller.validationErrors,
              ),
              CommonFormInput(
                label: 'at.department_approval'.tr,
                controller: controller.controllerDepartmentApproval,
                isEditing: controller.isEditing,
                textContent: controller.item?.tenTrinhDuyetCapPhong ?? '',
                fieldName: 'departmentApproval',
                isDropdown: true,
                items: controller.itemsDepartmentApproval,
                onChanged: (value) {
                  setState(() {
                    controller.onDepartmentApprovalChanged(value);
                  });
                },
                validationErrors: controller.validationErrors,
              ),
              CommonFormInput(
                label: 'at.effective_date'.tr,
                controller: controller.controllerEffectiveDate,
                isEditing: controller.isEditing,
                textContent:
                    controller.isEditing
                        ? AppUtility.formatDateDdMmYyyy(DateTime.now())
                        : controller.item?.tggnTuNgay.toString() ??
                            (controller.isEditing ? AppUtility.formatDateDdMmYyyy(DateTime.now()) : ''),
                fieldName: 'effectiveDate',
                validationErrors: controller.validationErrors,
              ),
              CommonFormInput(
                label: 'at.effective_date_to'.tr,
                controller: controller.controllerEffectiveDateTo,
                isEditing: controller.isEditing,
                textContent: controller.item?.tggnDenNgay.toString() ?? '',
                fieldName: 'effectiveDateTo',
                validationErrors: controller.validationErrors,
              ),
              CommonFormInput(
                label: 'at.approver'.tr,
                controller: controller.controllerApprover,
                isEditing: controller.isEditing,
                textContent: controller.item?.tenTrinhDuyetGiamDoc ?? '',
                isDropdown: true,
                items: controller.itemsApprover,
                onChanged: (value) {
                  setState(() {
                    controller.onApproverChanged(value);
                  });
                },
                fieldName: 'approver',
                validationErrors: controller.validationErrors,
              ),
              DocumentUploadWidget(
                isEditing: controller.isEditing,
                selectedFileName: controller.selectedFileName,
                selectedFilePath: controller.selectedFilePath,
                validationErrors: controller.validationErrors,
                onFileSelected: (fileName, filePath) {
                  setState(() {
                    controller.setSelectedFile(fileName, filePath);
                  });
                },
                onUpload: _uploadWordDocument,
                isUploading: controller.isUploading,
                label: 'Tài liệu Quyết định',
                errorMessage: 'Tài liệu quyết định là bắt buộc',
                hintText: 'Định dạng hỗ trợ: .doc, .docx (Microsoft Word)',
                allowedExtensions: ['doc', 'docx'],
              ),

              const SizedBox(height: 20),
              assetTransferMovementTable(
                context,
                widget.provider.listMovementDetail,
                controller.isEditing,
                controller.isNew,
                isLoading: widget.provider.isLoadingMovementDetail,
              ),
              SizedBox(height: 10),
              previewDocumentAssetTransfer(controller.item),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _uploadWordDocument() async {
    if (controller.selectedFilePath == null) return;

    setState(() {
      controller.isUploading = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        controller.validationErrors.remove('document');
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tệp "${controller.selectedFileName}" đã được tải lên thành công'),
            backgroundColor: Colors.green.shade600,
          ),
        );
      }
    } catch (e) {
      SGLog.debug("AssetTransferDetail", ' Error uploading file: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tải lên tệp: ${e.toString()}'), backgroundColor: Colors.red.shade600),
        );
      }
    } finally {
      setState(() {
        controller.isUploading = false;
      });
    }
  }

  // Method to save asset transfer can be reimplemented using the controller

  void onReload() {
    _refreshWidget();
  }

  void refreshWidget() {
    _refreshWidget();
  }

  void _checkAndRefreshWidget() {
    if (widget.provider.item != controller.item) {
      _refreshWidget();
    }

    if (widget.isNew == true && controller.item != null) {
      _refreshWidget();
    }
  }

  void _callGetListAssetHandover() {
    try {
      final assetHandoverBloc = BlocProvider.of<AssetHandoverBloc>(context);
      assetHandoverBloc.add(GetListAssetHandoverEvent(context));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi lấy danh sách: ${e.toString()}'), backgroundColor: Colors.red));
    }
  }

  Widget previewDocumentAssetTransfer(AssetTransferDto? item) {
    return InkWell(
      onTap: () {
        showWebViewPopup(context, url: url, title: 'Preview Document');
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2.5),
            child: SGText(
              text: "Xem trước tài liệu",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: ColorValue.link),
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.visibility, color: ColorValue.link, size: 18),
        ],
      ),
    );
  }
}
