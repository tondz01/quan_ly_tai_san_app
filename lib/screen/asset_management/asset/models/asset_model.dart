import 'package:equatable/equatable.dart';

class AssetModel extends Equatable {
  final String id;
  final String name;
  final String registrationDate;
  final String usageDate;
  final String department;
  final String childAssetCount;
  final String attachmentCount;
  final String note;
  final String assetAccount;
  final String project;
  final String assetType;
  final String originalCost;
  final String initialDepreciationValue;
  final String initialDepreciationPeriod;
  final String initialResidualValue;
  final String accruedDepreciationValue;
  final String accruedDepreciationPeriod;
  final String remainingDepreciationValue;
  final String remainingDepreciationPeriod;

  const AssetModel({
    required this.id,
    required this.name,
    required this.registrationDate,
    required this.usageDate,
    required this.department,
    required this.childAssetCount,
    required this.attachmentCount,
    required this.note,
    required this.assetAccount,
    required this.project,
    required this.assetType,
    required this.originalCost,
    required this.initialDepreciationValue,
    required this.initialDepreciationPeriod,
    required this.initialResidualValue,
    required this.accruedDepreciationValue,
    required this.accruedDepreciationPeriod,
    required this.remainingDepreciationValue,
    required this.remainingDepreciationPeriod,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    registrationDate,
    usageDate,
    department,
    childAssetCount,
    attachmentCount,
    note,
    assetAccount,
    project,
    assetType,
    originalCost,
    initialDepreciationValue,
    initialDepreciationPeriod,
    initialResidualValue,
    accruedDepreciationValue,
    accruedDepreciationPeriod,
    remainingDepreciationValue,
    remainingDepreciationPeriod,
  ];

  factory AssetModel.fromCsv(List<dynamic> row) {
    return AssetModel(
      id: row[0],
      name: row[1],
      registrationDate: row[2],
      usageDate: row[3],
      department: row[4],
      childAssetCount: row[5],
      attachmentCount: row[6],
      note: row[7],
      assetAccount: row[8],
      project: row[9],
      assetType: row[10],
      originalCost: row[11],
      initialDepreciationValue: row[12],
      initialDepreciationPeriod: row[13],
      initialResidualValue: row[14],
      accruedDepreciationValue: row[15],
      accruedDepreciationPeriod: row[16],
      remainingDepreciationValue: row[17],
      remainingDepreciationPeriod: row[18],
    );
  }
}