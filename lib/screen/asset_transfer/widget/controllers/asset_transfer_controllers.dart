import 'package:flutter/material.dart';

class AssetTransferControllers {
  late TextEditingController controllerSoChungTu = TextEditingController();
  late TextEditingController controllerSubject = TextEditingController();
  late TextEditingController controllerDocumentName = TextEditingController();
  late TextEditingController controllerDeliveringUnit = TextEditingController();
  late TextEditingController controllerReceivingUnit = TextEditingController();
  late TextEditingController controllerRequester = TextEditingController();
  late TextEditingController controllerProposingUnit = TextEditingController();
  late TextEditingController controllerQuantity = TextEditingController();
  late TextEditingController controllerDepartmentApproval = TextEditingController();
  late TextEditingController controllerEffectiveDate = TextEditingController();
  late TextEditingController controllerEffectiveDateTo = TextEditingController();
  late TextEditingController controllerApprover = TextEditingController();
  late TextEditingController controllerDeliveryLocation = TextEditingController();
  late TextEditingController controllerViewerDepartments = TextEditingController();
  late TextEditingController controllerViewerUsers = TextEditingController();
  late TextEditingController controllerReason = TextEditingController();
  late TextEditingController controllerBase = TextEditingController();
  late TextEditingController controllerArticle1 = TextEditingController();
  late TextEditingController controllerArticle2 = TextEditingController();
  late TextEditingController controllerArticle3 = TextEditingController();
  late TextEditingController controllerDestination = TextEditingController();
  late TextEditingController controllerTPDonViGiao = TextEditingController();
  late TextEditingController controllerPPDonViNhan = TextEditingController();
  late TextEditingController controllerNguoiKyNhay = TextEditingController();

  void dispose() {
    controllerSoChungTu.dispose();
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
    controllerReason.dispose();
    controllerBase.dispose();
    controllerArticle1.dispose();
    controllerArticle2.dispose();
    controllerArticle3.dispose();
    controllerDestination.dispose();
    controllerTPDonViGiao.dispose();
    controllerPPDonViNhan.dispose();
    controllerNguoiKyNhay.dispose();
  }

  void clearAll() {
    controllerSoChungTu.clear();
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
    controllerTPDonViGiao.clear();
    controllerPPDonViNhan.clear();
    controllerNguoiKyNhay.clear();
  }
} 