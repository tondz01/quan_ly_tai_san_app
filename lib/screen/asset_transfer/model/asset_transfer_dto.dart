import 'dart:convert';

class AssetTransferDto {
  final String? id;
  final String? documentName; // Tên phiếu
  final String? decisionNumber; // Số quyết định
  final String? decisionDate; // Ngày quyết định
  final String? requester; // Người đề nghị
  final String? creator; // Người lập phiếu
  final List<String>? movementDetails; // Chi tiết điều động
  final String? sendingUnit; // Đơn vị gửi
  final String? receivingUnit; // Đơn vị nhận
  final String? effectiveDate; // TGCN từ Ngày
  final String? approver; // Trình duyệt Ban giám đốc
  final String? status; // Trạng thái
  final bool? isEffective; // Có hiệu lực

  AssetTransferDto({
    this.id,
    this.documentName,
    this.decisionNumber,
    this.decisionDate,
    this.requester,
    this.creator,
    this.movementDetails,
    this.sendingUnit,
    this.receivingUnit,
    this.effectiveDate,
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
      creator: json['creator'],
      movementDetails: json['movementDetails'] != null
          ? List<String>.from(json['movementDetails'])
          : null,
      sendingUnit: json['sendingUnit'],
      receivingUnit: json['receivingUnit'],
      effectiveDate: json['effectiveDate'],
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
      'creator': creator,
      'movementDetails': movementDetails,
      'sendingUnit': sendingUnit,
      'receivingUnit': receivingUnit,
      'effectiveDate': effectiveDate,
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