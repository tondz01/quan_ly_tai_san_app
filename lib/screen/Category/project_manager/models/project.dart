import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String code;
  final String name;
  final String note;
  final bool isActive;

  const Project({
    required this.code,
    required this.name,
    required this.note,
    required this.isActive,
  });

  Project copyWith({
    String? code,
    String? name,
    String? note,
    bool? isActive,
  }) {
    return Project(
      code: code ?? this.code,
      name: name ?? this.name,
      note: note ?? this.note,
      isActive: isActive ?? this.isActive,
    );
  }

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        code: json['code'] ?? '',
        name: json['name'] ?? '',
        note: json['note'] ?? '',
        isActive: json['isActive'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
        'note': note,
        'isActive': isActive,
      };

  @override
  List<Object?> get props => [code, name, note, isActive];
}

List<Project> sampleProjects() => [
  Project(code: '001', name: '001 - 99', note: '99', isActive: true),
  Project(code: '002', name: '002 - MTB', note: 'MTB', isActive: true),
  Project(code: '003', name: '003 - NCSTLBMT Đồng Vông', note: 'NCSTLBMT Đồng Vông', isActive: true),
  Project(code: '004', name: '004 - Duy trì SX 2010', note: 'Duy trì SX 2010', isActive: true),
  Project(code: '005', name: '005 - Duy trì SX 2011', note: 'Duy trì SX 2011', isActive: true),
  Project(code: '006', name: '006 - Duy trì SX 2013 - than Đồng Vông', note: 'Duy trì SX 2013 - than Đồng Vông', isActive: true),
  Project(code: '007', name: '007 - Dự án: ĐTXD bãi chế biến than Uông thượng', note: 'Dự án: ĐTXD bãi chế biến than Uông thượng', isActive: true),
  Project(code: '008', name: '008 - Duy trì sản xuất năm 2012- XN Cảng', note: 'Duy trì sản xuất năm 2012- XN Cảng', isActive: true),
  Project(code: '009', name: '009 - MRNCSKTBDV ( TANDAN)', note: 'MRNCSKTBDV ( TANDAN)', isActive: true),
  Project(code: '010', name: '010 - DA Nhà hội trường – HBO', note: 'DA Nhà hội trường – HBO', isActive: true),
  Project(code: '011', name: '011 - BCKTKT NCNLVC người và VLPV sản xuất', note: 'BCKTKT NCNLVC người và VLPV sản xuất', isActive: true),
]; 