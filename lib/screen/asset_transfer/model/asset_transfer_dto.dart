import 'dart:convert';

import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/movement_detail_dto.dart';

class AssetTransferDto {
  final String? id;
  final String? documentName; // Tên phiếu
  final String? decisionNumber; // Số quyết định
  final String? decisionDate; // Ngày quyết định
  final String? requester; // Người đề nghị
  final String? requestingUnit; // Người lập phiếu
  final String? creator; // Người lập phiếu
  final List<MovementDetailDto>? movementDetails; // Chi tiết điều động
  final String? deliveringUnit; // Đơn vị giao
  final String? receivingUnit; // Đơn vị nhận
  final String? proposingUnit; // Đơn vị đề nghị
  final String? deliveryLocation; // Địa điểm Giao Nhận
  final String? effectiveDate; // TGCN từ Ngày
  final String? effectiveDateTo; // TGCN đến Ngày
  final bool? preparerInitialed; // Người lập phiếu ký nháy
  final bool? requireManagerApproval; // Quan trọng, cần TP xác nhận
  final bool? deputyConfirmed; // Phó phòng xác nhận
  final String? rejectionReason; // Lý do từ chối
  final String? departmentApproval; // Trình duyệt cấp phòng
  final String? approver; // Trình duyệt Ban giám đốc
  final int? status; // Trạng thái
  final bool? isEffective; // Có hiệu lực

  AssetTransferDto({
    this.id,
    this.documentName,
    this.decisionNumber,
    this.decisionDate,
    this.requester,
    this.requestingUnit,
    this.creator,
    this.movementDetails,
    this.deliveringUnit,
    this.receivingUnit,
    this.proposingUnit,
    this.deliveryLocation,
    this.effectiveDate,
    this.effectiveDateTo,
    this.preparerInitialed,
    this.requireManagerApproval,
    this.deputyConfirmed,
    this.rejectionReason,
    this.departmentApproval,
    this.approver,
    this.status,
    this.isEffective,
  });

  factory AssetTransferDto.fromJson(Map<String, dynamic> json) {
    return AssetTransferDto(
      id: json['id'],
      documentName: json['documentName'],
      decisionNumber: json['decisionNumber'],
      decisionDate: json['decisionDate'],
      requester: json['requester'],
      requestingUnit: json['requestingUnit'],
      creator: json['creator'],
      movementDetails: json['movementDetails'] != null
          ? List<MovementDetailDto>.from(
              json['movementDetails'].map((detail) => 
                detail is Map<String, dynamic> 
                  ? MovementDetailDto.fromJson(detail)
                  : MovementDetailDto(name: detail)))
          : null,
      deliveringUnit: json['sendingUnit'],
      receivingUnit: json['receivingUnit'],
      proposingUnit: json['proposingUnit'],
      deliveryLocation: json['deliveryLocation'],
      effectiveDate: json['effectiveDate'],
      effectiveDateTo: json['effectiveDateTo'],
      preparerInitialed: json['preparerInitialed'],
      requireManagerApproval: json['requireManagerApproval'],
      deputyConfirmed: json['deputyConfirmed'],
      rejectionReason: json['rejectionReason'],
      departmentApproval: json['departmentApproval'],
      approver: json['approver'],
      status: json['status'],
      isEffective: json['isEffective'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentName': documentName,
      'decisionNumber': decisionNumber,
      'decisionDate': decisionDate,
      'requester': requester,
      'requestingUnit': requestingUnit,
      'creator': creator,
      'movementDetails': movementDetails,
      'sendingUnit': deliveringUnit,
      'receivingUnit': receivingUnit,
      'proposingUnit': proposingUnit,
      'deliveryLocation': deliveryLocation,
      'effectiveDate': effectiveDate,
      'effectiveDateTo': effectiveDateTo,
      'preparerInitialed': preparerInitialed,
      'requireManagerApproval': requireManagerApproval,
      'deputyConfirmed': deputyConfirmed,
      'rejectionReason': rejectionReason,
      'departmentApproval': departmentApproval,
      'approver': approver,
      'status': status,
      'isEffective': isEffective,
    };
  }

  static List<AssetTransferDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => AssetTransferDto.fromJson(json)).toList();
  }

  static String encode(List<AssetTransferDto> transfers) =>
      json.encode(transfers.map((transfer) => transfer.toJson()).toList());

  static List<AssetTransferDto> decode(String transfers) =>
      (json.decode(transfers) as List<dynamic>)
          .map<AssetTransferDto>((item) => AssetTransferDto.fromJson(item))
          .toList();
} 