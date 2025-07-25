class ToolsAndSuppliesDto {
  final String id;
  final String name;         
  final String importUnit;   
  final String code;         
  final String importDate;   
  final String unit;         
  final int quantity;        
  final double value;        
  final String referenceNumber; 
  final String symbol;       
  final String capacity;     
  final String countryOfOrigin;
  final String yearOfManufacture;
  final String note;

  ToolsAndSuppliesDto({
    required this.id,
    required this.name,
    required this.importUnit,
    required this.code,
    required this.importDate,
    required this.unit,
    required this.quantity,
    required this.value,
    this.referenceNumber = '',
    this.symbol = '',
    this.capacity = '',
    required this.countryOfOrigin,
    required this.yearOfManufacture,
    this.note = '',
  });

  factory ToolsAndSuppliesDto.fromJson(Map<String, dynamic> json) {
    return ToolsAndSuppliesDto(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      importUnit: json['importUnit'] ?? '',
      code: json['code'] ?? '',
      importDate: json['importDate'] ?? '',
      unit: json['unit'] ?? '',
      quantity: json['quantity'] ?? 0,
      value: json['value'] ?? 0.0,
      referenceNumber: json['referenceNumber'] ?? '',
      symbol: json['symbol'] ?? '',
      capacity: json['capacity'] ?? '',
      countryOfOrigin: json['countryOfOrigin'] ?? '',
      yearOfManufacture: json['yearOfManufacture'] ?? '',
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'importUnit': importUnit,
      'code': code,
      'importDate': importDate,
      'unit': unit,
      'quantity': quantity,
      'value': value,
      'referenceNumber': referenceNumber,
      'symbol': symbol,
      'capacity': capacity,
      'countryOfOrigin': countryOfOrigin,
      'yearOfManufacture': yearOfManufacture,
      'note': note,
    };
  }
}