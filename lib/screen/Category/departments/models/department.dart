import 'package:equatable/equatable.dart';

class Department extends Equatable {
  final String departmentId;
  final String departmentGroup;
  final String departmentName;
  final String managerId;
  final String employeeCount;
  final String parentRoom;

  const Department({
    required this.departmentId,
    required this.departmentGroup,
    required this.departmentName,
    required this.managerId,
    required this.employeeCount,
    required this.parentRoom,
  });

  Department copyWith({
    String? departmentId,
    String? departmentGroup,
    String? departmentName,
    String? managerId,
    String? employeeCount,
    String? parentRoom,
  }) {
    return Department(
      departmentId: departmentId ?? this.departmentId,
      departmentGroup: departmentGroup ?? this.departmentGroup,
      departmentName: departmentName ?? this.departmentName,
      managerId: managerId ?? this.managerId,
      employeeCount: employeeCount ?? this.employeeCount,
      parentRoom: parentRoom ?? this.parentRoom,
    );
  }

  factory Department.fromJson(Map<String, dynamic> json) => Department(
    departmentId: json['departmentId'] ?? '',
    departmentGroup: json['departmentGroup'] ?? '',
    departmentName: json['departmentName'] ?? '',
    managerId: json['managerId'] ?? '',
    employeeCount: json['employeeCount'] ?? '',
    parentRoom: json['parentRoom'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'departmentId': departmentId,
    'departmentGroup': departmentGroup,
    'departmentName': departmentName,
    'managerId': managerId,
    'employeeCount': employeeCount,
    'parentRoom': parentRoom,
  };

  @override
  List<Object?> get props => [
    departmentId,
    departmentGroup,
    departmentName,
    managerId,
    employeeCount,
    parentRoom,
  ];
}

List<Department> sampleDepartments() => [
  Department(
    departmentId: 'ĐU',
    departmentGroup: 'Quản lý',
    departmentName: 'VP Đảng ủy',
    managerId: "01",
    employeeCount: '1',
    parentRoom: '',
  ),
];

