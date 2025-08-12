import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_detail_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_movement_dto.dart';

class AssetDepreciationDto {
  final String? id;
  final String? name; // tên Bàn giao tài sản
  final String? decisionNumber; // Quyết định điều động số
  final String? order; // Lệnh điều động
  final String? transferDate; // Ngày bàn giao
  final String? transferDetail; // Chi tiết bàn giao
  final String? senderUnit; // Đơn vị giao
  final String? receiverUnit; // Đơn vị nhận
  final String? createdBy; // Người tạo
  final int? state; // Trạng thái
  final List<AssetHandoverMovementDto>? assetHandoverMovements; // Chi tiết điều động
  final AssetHandoverDetailDto? assetHandoverDetails; // Chi tiết bàn giao (0: Nháp, 1: Sẵn sàng, 2: Xác nhận, 3: Trình duyệt, 4: Hoàn thành, 5: Hủy)

  AssetDepreciationDto({
    this.id,
    this.name,
    this.decisionNumber,
    this.order,
    this.transferDate,
    this.transferDetail,
    this.senderUnit,
    this.receiverUnit,
    this.createdBy,
    this.state,
    this.assetHandoverMovements,
    this.assetHandoverDetails,
  });

  factory AssetDepreciationDto.fromJson(Map<String, dynamic> json) {
    return AssetDepreciationDto(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      decisionNumber: json['decisionNumber'] ?? '',
      order: json['order'] ?? '',
      transferDate: json['transferDate'] ?? '',
      transferDetail: json['transferDetail'] ?? '',
      senderUnit: json['senderUnit'] ?? '',
      receiverUnit: json['receiverUnit'] ?? '',
      createdBy: json['createdBy'] ?? '',
      state: json['state'] ?? -1,
      assetHandoverMovements: json['assetHandoverMovements'] != null
          ? (json['assetHandoverMovements'] as List)
              .map((e) => AssetHandoverMovementDto.fromJson(e))
              .toList()
          : null,
      assetHandoverDetails: json['assetHandoverDetails'] != null
          ? AssetHandoverDetailDto.fromJson(json['assetHandoverDetails'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'decisionNumber': decisionNumber,
      'order': order,
      'transferDate': transferDate,
      'transferDetail': transferDetail,
      'senderUnit': senderUnit,
      'receiverUnit': receiverUnit,
      'createdBy': createdBy,
      'state': state,
      'assetHandoverMovements': assetHandoverMovements?.map((e) => e.toJson()).toList(),
      'assetHandoverDetails': assetHandoverDetails?.toJson(),
    };
  }
}
