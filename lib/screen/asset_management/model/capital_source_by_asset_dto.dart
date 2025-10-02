class CapitalSourceByAssetDto {
  final String? id;
  final String? ten;
  final String? note;

  CapitalSourceByAssetDto({
    this.id,
    this.ten,
    this.note,
  });

  factory CapitalSourceByAssetDto.fromJson(Map<String, dynamic> json) {
    return CapitalSourceByAssetDto(
      id: json['id'],
      ten: json['ten'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ten': ten,
      'note': note,
    };
  }

  CapitalSourceByAssetDto copyWith({
    String? id,
    String? ten,
    String? note,
  }) {
    return CapitalSourceByAssetDto(
      id: id ?? this.id,
      ten: ten ?? this.ten,
      note: note ?? this.note,
    );
  }

  @override
  String toString() {
    return 'CapitalSourceByAssetDto(id: $id, ten: $ten, note: $note)';
  }
}