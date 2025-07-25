import 'package:equatable/equatable.dart';

class CapitalSource extends Equatable {
  final String code;
  final String name;
  final String note;
  final bool isActive;

  const CapitalSource({
    required this.code,
    required this.name,
    required this.note,
    required this.isActive,
  });

  CapitalSource copyWith({
    String? code,
    String? name,
    String? note,
    bool? isActive,
  }) {
    return CapitalSource(
      code: code ?? this.code,
      name: name ?? this.name,
      note: note ?? this.note,
      isActive: isActive ?? this.isActive,
    );
  }

  factory CapitalSource.fromJson(Map<String, dynamic> json) => CapitalSource(
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

List<CapitalSource> sampleCapitalSources() => [
  CapitalSource(code: 'N001', name: 'Vốn đầu tư', note: 'Vốn đầu tư được duyệt hàng năm', isActive: true),
  CapitalSource(code: 'N002', name: 'Theo dự án', note: 'Nguồn vốn phân bổ theo dự án', isActive: true),
  CapitalSource(code: 'N009', name: 'Nguồn vốn khác', note: 'Khác', isActive: true),
  
]; 