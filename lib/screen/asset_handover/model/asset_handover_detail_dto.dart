import 'package:quan_ly_tai_san_app/screen/asset_handover/model/property_handover_minutes_dto.dart';

class AssetHandoverDetailDto {
  final String? id;
  final String? handoverId;
  final String? leader; // lãnh đạo
  final String? issuingUnitRepresentative; // Đại diện Đơn vị ban hành QĐ
  final bool? isUnitConfirm; // Đơn vị đã xác nhận
  final String? delivererRepresentative; // Đại diện bên giao
  final bool? isDelivererConfirm; // Bên giao đã xác nhận
  final String? receiverRepresentative; // Chi tiết bàn giao
  final bool? isReceiverConfirm; // Bên nhận đã xác nhận
  final String? representativeUnit; // Đơn vị đại diện
  final bool? isRepresentativeUnitConfirm; // Đơn vị đại diện đã xác nhận
  final List<PropertyHandoverMinutesDto>? propertyHandoverMinutes;

  AssetHandoverDetailDto({
    this.id,
    this.handoverId,
    this.leader,
    this.issuingUnitRepresentative,
    this.isUnitConfirm,
    this.delivererRepresentative,
    this.isDelivererConfirm,
    this.receiverRepresentative,
    this.isReceiverConfirm,
    this.representativeUnit,
    this.isRepresentativeUnitConfirm,
    this.propertyHandoverMinutes,
  });

  factory AssetHandoverDetailDto.fromJson(Map<String, dynamic> json) {
    return AssetHandoverDetailDto(
      id: json['id'] ?? '',
      handoverId: json['handoverId'] ?? '',
      leader: json['leader'] ?? '',
      issuingUnitRepresentative: json['issuingUnitRepresentative'] ?? '',
      isUnitConfirm: json['isUnitConfirm'] ?? false,
      delivererRepresentative: json['delivererRepresentative'] ?? '',
      isDelivererConfirm: json['isDelivererConfirm'] ?? false,
      receiverRepresentative: json['receiverRepresentative'] ?? '',
      isReceiverConfirm: json['isReceiverConfirm'] ?? false,
      representativeUnit: json['representativeUnit'] ?? '',
      isRepresentativeUnitConfirm: json['isRepresentativeUnitConfirm'] ?? false,
      propertyHandoverMinutes:
          json['propertyHandoverMinutes'] != null
              ? (json['propertyHandoverMinutes'] as List)
                  .map((e) => PropertyHandoverMinutesDto.fromJson(e))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'handoverId': handoverId,
      'leader': leader,
      'issuingUnitRepresentative': issuingUnitRepresentative,
      'isUnitConfirm': isUnitConfirm,
      'delivererRepresentative': delivererRepresentative,
      'isDelivererConfirm': isDelivererConfirm,
      'receiverRepresentative': receiverRepresentative,
      'isReceiverConfirm': isReceiverConfirm,
      'representativeUnit': representativeUnit,
      'isRepresentativeUnitConfirm': isRepresentativeUnitConfirm,
      'propertyHandoverMinutes':
          propertyHandoverMinutes?.map((e) => e.toJson()).toList(),
    };
  }
}
