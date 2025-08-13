class AssetHandoverMovementDto {
  String? id;
  String? handoverId;
  String? name;
  String? measurementUnit;
  String? quantity;
  String? setCondition;
  String? countryOfOrigin;

  AssetHandoverMovementDto({
    this.id,
    this.handoverId,
    this.name,
    this.measurementUnit,
    this.quantity,
    this.setCondition,
    this.countryOfOrigin,
  });

  factory AssetHandoverMovementDto.fromJson(Map<String, dynamic> json) {
    return AssetHandoverMovementDto(
      id: json['id'],
      handoverId: json['handoverId'],
      name: json['name'],
      measurementUnit: json['measurementUnit'],
      quantity: json['quantity'],
      setCondition: json['setCondition'],
      countryOfOrigin: json['countryOfOrigin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'handoverId': handoverId,
      'name': name,
      'measurementUnit': measurementUnit,
      'quantity': quantity,
      'setCondition': setCondition,
      'countryOfOrigin': countryOfOrigin,
    };
  }

  factory AssetHandoverMovementDto.empty() {
    return AssetHandoverMovementDto(
      id: '',
      handoverId: '',
      name: '',
      measurementUnit: '',
      quantity: '',
      setCondition: '',
      countryOfOrigin: '',
    );
  }
}
