class PropertyHandoverMinutesDto {
  final String? id;
  final String? assetDetailId;
  final String? internalSigningSlip; // Phiếu ký nội sinh
  final String? signingDate; // Ngày ký
  final String? effectiveDate; // Ngày hiệu lực
  final String? boardApproval; // Trình duyệt Ban giám đốc
  final String? approvedDocument; // Tài liệu duyệt
  final bool? isEffective; // Có hiệu lực
  final String? digitalSignature; // Ký số

  PropertyHandoverMinutesDto({
    this.id,
    this.assetDetailId,
    this.internalSigningSlip,
    this.signingDate,
    this.effectiveDate,
    this.boardApproval,
    this.approvedDocument,
    this.isEffective,
    this.digitalSignature,
  });

  factory PropertyHandoverMinutesDto.fromJson(Map<String, dynamic> json) {
    return PropertyHandoverMinutesDto(
      id: json['id'] ?? '',
      assetDetailId: json['assetDetailId'] ?? '',
      internalSigningSlip: json['internalSigningSlip'] ?? '',
      signingDate: json['signingDate'] ?? '',
      effectiveDate: json['effectiveDate'] ?? '',
      boardApproval: json['boardApproval'] ?? '',
      approvedDocument: json['approvedDocument'] ?? '',
      isEffective: json['isEffective'] ?? false,
      digitalSignature: json['digitalSignature'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assetDetailId': assetDetailId,
      'internalSigningSlip': internalSigningSlip,
      'signingDate': signingDate,
      'effectiveDate': effectiveDate,
      'boardApproval': boardApproval,
      'approvedDocument': approvedDocument,
      'isEffective': isEffective,
      'digitalSignature': digitalSignature,
    };
  }
}