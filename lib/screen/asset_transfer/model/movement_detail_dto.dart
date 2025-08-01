class MovementDetailDto {
  String? id;
  String? assetId;
  String? name;
  String? measurementUnit;
  String? quantity;
  String? setCondition;
  String? note;

  MovementDetailDto({
    this.id,
    this.assetId,
    this.name,
    this.measurementUnit,
    this.quantity,
    this.setCondition,
    this.note,
  });

  factory MovementDetailDto.fromJson(Map<String, dynamic> json) {
    return MovementDetailDto(
      id: json['id'],
      assetId: json['assetId'],
      name: json['name'],
      measurementUnit: json['measurementUnit'],
      quantity: json['quantity'],
      setCondition: json['setCondition'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assetId': assetId,
      'name': name,
      'measurementUnit': measurementUnit,
      'quantity': quantity,
      'setCondition': setCondition,
      'note': note,
    };
  } 

  factory MovementDetailDto.empty() {
    return MovementDetailDto(
      id: '',
      assetId: '',
      name: '',
      measurementUnit: '',
      quantity: '',
      setCondition: '',
      note: '',
    );
  }
}