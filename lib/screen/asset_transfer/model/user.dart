
class User {
  final String? id;
  final String? name;
  final String? department;
  final int? role;

  User({
    this.id,
    this.name,
    this.department,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      department: json['department'] ?? '',
      role: json['role'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() { 
    return {
      'id': id,
      'name': name,
      'department': department,
      'role': role,
    };
  }
}

final List<User> users = [
    User(
      id: '1',
      name: 'Đặng Thị Hồng',
      department: 'Phân xưởng sàng tuyển',
      role: 1,
    ),
    User(
      id: '2',
      name: 'Phạm Văn Bốn',
      department: 'Phân xưởng khai thác đào lò 17',
      role: 1,
    ),
    User(
      id: '3',
      name: 'Ecotel',
      department: 'Phân xưởng khai thác đào lò 17',
      role: 1,
    ),
    User(
      id: '4',
      name: 'Bùi Mạnh Linh',
      department: 'Phân xưởng khai thác đào lò 17',
      role: 1,
    ),
    User(
      id: '5',
      name: 'Bùi Thị Hải Yến',
      department: 'Phân xưởng Cơ điện lò 2',
      role: 1,
    ),
    User(
      id: '6',
      name: 'Bùi Văn Cường',
      department: 'Phân xưởng Vận tải lò 2',
      role: 1,
    ),
    User(
      id: '7',
      name: 'Bùi Văn Cường',
      department: 'Phân xưởng khai thác đào lò 20',
      role: 1,
    ),
    User(
      id: '8',
      name: 'Bùi Văn Hinh',
      department: 'Phân xưởng Cơ giới -Cơ khí 1',
      role: 1,
    ),
    User(
      id: '9',
      name: 'Bùi Văn Khoa',
      department: 'Phân xưởng khai thác đào lò 18',
      role: 1,
    ),
    User(
      id: '10',
      name: 'Mai Xuân Bình',
      department: 'Phân xưởng khai thác đào lò 17',
      role: 2,
    ),
    User(
      id: '10',
      name: 'Ngô Tiến Sĩ',
      department: 'Phân xưởng khai thác đào lò 17',
      role: 3,
    ),
    User(
      id: '11',
      name: 'Lê Đức Đà',
      department: 'Phân xưởng khai thác đào lò 17',
      role: 2,
    ),
    User(
      id: '11',
      name: 'Đoàn Ngọc Hà',
      department: 'Phòng KT',
      role: 2,
    ),
    User(
      id: '12',
      name: 'Dương Văn Hoàng',
      department: 'Công ty CP Cơ điện Uông bí - Vinacomin',
      role: 1,
    ),
    User(
      id: '13',
      name: 'Khúc Thanh Huyền',
      department: 'Phòng CV',
      role: 3,
    ),
    User(
      id: '14',
      name: 'Phạm Xuân Vinh',
      department: 'Phòng CV',
      role: 3,
    ),
    User(
      id: '15',
      name: 'Vũ Nam',
      department: 'Kho Công ty',
      role: 3,
    ),
    User(
      id: '16',
      name: 'Trần Hoàng Anh',
      department: 'Kho Công ty',
      role: 3,
    ),
    User(
      id: '17',
      name: 'Nguyễn Văn Hưng',
      department: 'Kho Công ty',
      role: 3,
    ),
    
  ];