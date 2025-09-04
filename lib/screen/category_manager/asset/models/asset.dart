import 'package:equatable/equatable.dart';

class AssetDTO extends Equatable {
  final String assetId; // Mã tài sản
  final String originalPrice; // Nguyên giá tài sản
  final String initialDepreciationValue; // Giá trị khấu hao ban đầu
  final String initialDepreciationPeriod; // Kỳ khấu hao ban đầu
  final String liquidationValue; // Giá trị thanh lý
  final String assetModel; // Mô hình tài sản
  final String depreciationMethod; // Phương pháp khấu hao
  final String depreciationPeriods; // Số kỳ khấu hao
  final String assetAccount; // Tài khoản tài sản
  final String depreciationAccount; // Tài khoản khấu hao
  final String costAccount; // Tài khoản chi phí
  final String assetGroup; // Nhóm tài sản
  final String entryDate; // Ngày vào sổ
  final String usageDate; // Ngày sử dụng
  final String project; // Dự án
  final String fundingSource; // Nguồn kinh phí
  final String symbol; // Ký hiệu
  final String symbolNumber; // Số ký hiệu
  final String capacity; // Công suất
  final String countryOfOrigin; // Nước sản xuất
  final String yearOfManufacture; // Năm sản xuất
  final String reasonForIncrease; // Lý do tăng
  final String status; // Hiện trạng
  final String quantity; // Số lượng
  final String unit; // Đơn vị tính
  final String note; // Ghi chú
  final bool initialUnitCreated; // Khởi tạo Đơn vị ban đầu
  final String initialUsageUnit; // Đơn vị sử dụng ban đầu
  final String currentUnit; // Đơn vị hiện thời

  const AssetDTO({
    required this.assetId,
    required this.originalPrice,
    required this.initialDepreciationValue,
    required this.initialDepreciationPeriod,
    required this.liquidationValue,
    required this.assetModel,
    required this.depreciationMethod,
    required this.depreciationPeriods,
    required this.assetAccount,
    required this.depreciationAccount,
    required this.costAccount,
    required this.assetGroup,
    required this.entryDate,
    required this.usageDate,
    required this.project,
    required this.fundingSource,
    required this.symbol,
    required this.symbolNumber,
    required this.capacity,
    required this.countryOfOrigin,
    required this.yearOfManufacture,
    required this.reasonForIncrease,
    required this.status,
    required this.quantity,
    required this.unit,
    required this.note,
    required this.initialUnitCreated,
    required this.initialUsageUnit,
    required this.currentUnit,
  });

  AssetDTO copyWith({
    String? assetId,
    String? originalPrice,
    String? initialDepreciationValue,
    String? initialDepreciationPeriod,
    String? liquidationValue,
    String? assetModel,
    String? depreciationMethod,
    String? depreciationPeriods,
    String? assetAccount,
    String? depreciationAccount,
    String? costAccount,
    String? assetGroup,
    String? entryDate,
    String? usageDate,
    String? project,
    String? fundingSource,
    String? symbol,
    String? symbolNumber,
    String? capacity,
    String? countryOfOrigin,
    String? yearOfManufacture,
    String? reasonForIncrease,
    String? status,
    String? quantity,
    String? unit,
    String? note,
    bool? initialUnitCreated,
    String? initialUsageUnit,
    String? currentUnit,
  }) {
    return AssetDTO(
      assetId: assetId ?? this.assetId,
      originalPrice: originalPrice ?? this.originalPrice,
      initialDepreciationValue: initialDepreciationValue ?? this.initialDepreciationValue,
      initialDepreciationPeriod: initialDepreciationPeriod ?? this.initialDepreciationPeriod,
      liquidationValue: liquidationValue ?? this.liquidationValue,
      assetModel: assetModel ?? this.assetModel,
      depreciationMethod: depreciationMethod ?? this.depreciationMethod,
      depreciationPeriods: depreciationPeriods ?? this.depreciationPeriods,
      assetAccount: assetAccount ?? this.assetAccount,
      depreciationAccount: depreciationAccount ?? this.depreciationAccount,
      costAccount: costAccount ?? this.costAccount,
      assetGroup: assetGroup ?? this.assetGroup,
      entryDate: entryDate ?? this.entryDate,
      usageDate: usageDate ?? this.usageDate,
      project: project ?? this.project,
      fundingSource: fundingSource ?? this.fundingSource,
      symbol: symbol ?? this.symbol,
      symbolNumber: symbolNumber ?? this.symbolNumber,
      capacity: capacity ?? this.capacity,
      countryOfOrigin: countryOfOrigin ?? this.countryOfOrigin,
      yearOfManufacture: yearOfManufacture ?? this.yearOfManufacture,
      reasonForIncrease: reasonForIncrease ?? this.reasonForIncrease,
      status: status ?? this.status,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      note: note ?? this.note,
      initialUnitCreated: initialUnitCreated ?? this.initialUnitCreated,
      initialUsageUnit: initialUsageUnit ?? this.initialUsageUnit,
      currentUnit: currentUnit ?? this.currentUnit,
    );
  }

  factory AssetDTO.fromJson(Map<String, dynamic> json) => AssetDTO(
        assetId: json['assetId'] ?? '',
        originalPrice: json['originalPrice'] ?? '',
        initialDepreciationValue: json['initialDepreciationValue'] ?? '',
        initialDepreciationPeriod: json['initialDepreciationPeriod'] ?? '',
        liquidationValue: json['liquidationValue'] ?? '',
        assetModel: json['assetModel'] ?? '',
        depreciationMethod: json['depreciationMethod'] ?? '',
        depreciationPeriods: json['depreciationPeriods'] ?? '',
        assetAccount: json['assetAccount'] ?? '',
        depreciationAccount: json['depreciationAccount'] ?? '',
        costAccount: json['costAccount'] ?? '',
        assetGroup: json['assetGroup'] ?? '',
        entryDate: json['entryDate'] ?? '',
        usageDate: json['usageDate'] ?? '',
        project: json['project'] ?? '',
        fundingSource: json['fundingSource'] ?? '',
        symbol: json['symbol'] ?? '',
        symbolNumber: json['symbolNumber'] ?? '',
        capacity: json['capacity'] ?? '',
        countryOfOrigin: json['countryOfOrigin'] ?? '',
        yearOfManufacture: json['yearOfManufacture'] ?? '',
        reasonForIncrease: json['reasonForIncrease'] ?? '',
        status: json['status'] ?? '',
        quantity: json['quantity'] ?? '',
        unit: json['unit'] ?? '',
        note: json['note'] ?? '',
        initialUnitCreated: json['initialUnitCreated'] ?? false,
        initialUsageUnit: json['initialUsageUnit'] ?? '',
        currentUnit: json['currentUnit'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'assetId': assetId,
        'originalPrice': originalPrice,
        'initialDepreciationValue': initialDepreciationValue,
        'initialDepreciationPeriod': initialDepreciationPeriod,
        'liquidationValue': liquidationValue,
        'assetModel': assetModel,
        'depreciationMethod': depreciationMethod,
        'depreciationPeriods': depreciationPeriods,
        'assetAccount': assetAccount,
        'depreciationAccount': depreciationAccount,
        'costAccount': costAccount,
        'assetGroup': assetGroup,
        'entryDate': entryDate,
        'usageDate': usageDate,
        'project': project,
        'fundingSource': fundingSource,
        'symbol': symbol,
        'symbolNumber': symbolNumber,
        'capacity': capacity,
        'countryOfOrigin': countryOfOrigin,
        'yearOfManufacture': yearOfManufacture,
        'reasonForIncrease': reasonForIncrease,
        'status': status,
        'quantity': quantity,
        'unit': unit,
        'note': note,
        'initialUnitCreated': initialUnitCreated,
        'initialUsageUnit': initialUsageUnit,
        'currentUnit': currentUnit,
      };

  @override
  List<Object?> get props => [
    assetId,
    originalPrice,
    initialDepreciationValue,
    initialDepreciationPeriod,
    liquidationValue,
    assetModel,
    depreciationMethod,
    depreciationPeriods,
    assetAccount,
    depreciationAccount,
    costAccount,
    assetGroup,
    entryDate,
    usageDate,
    project,
    fundingSource,
    symbol,
    symbolNumber,
    capacity,
    countryOfOrigin,
    yearOfManufacture,
    reasonForIncrease,
    status,
    quantity,
    unit,
    note,
    initialUnitCreated,
    initialUsageUnit,
    currentUnit,
  ];
} 