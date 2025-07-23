import 'package:equatable/equatable.dart';

class StaffDTO extends Equatable {
  final String name;
  final String tel;
  final String email;
  final String activity;
  final String timeForActivity;
  final String department;
  final String position;
  final String staffId;
  final String staffOwner;

  const StaffDTO({
    required this.name,
    required this.tel,
    required this.email,
    required this.activity,
    required this.timeForActivity,
    required this.department,
    required this.position,
    required this.staffId,
    required this.staffOwner,
  });

  StaffDTO copyWith({
    String? name,
    String? tel,
    String? email,
    String? activity,
    String? timeForActivity,
    String? department,
    String? position,
    String? staffId,
    String? staffOwner,
  }) {
    return StaffDTO(
      name: name ?? this.name,
      tel: tel ?? this.tel,
      email: email ?? this.email,
      activity: activity ?? this.activity,
      timeForActivity: timeForActivity ?? this.timeForActivity,
      department: department ?? this.department,
      position: position ?? this.position,
      staffId: staffId ?? this.staffId,
      staffOwner: staffOwner ?? this.staffOwner,
    );
  }

  factory StaffDTO.fromJson(Map<String, dynamic> json) => StaffDTO(
        name: json['name'] ?? '',
        tel: json['tel'] ?? '',
        email: json['email'] ?? '',
        activity: json['activity'] ?? '',
        timeForActivity: json['timeForActivity'] ?? '',
        department: json['department'] ?? '',
        position: json['position'] ?? '',
        staffId: json['staffId'] ?? '',
        staffOwner: json['staffOwner'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'tel': tel,
        'email': email,
        'activity': activity,
        'timeForActivity': timeForActivity,
        'department': department,
        'position': position,
        'staffId': staffId,
        'staffOwner': staffOwner,
      };

  @override
  List<Object?> get props => [name, tel, email, activity, timeForActivity, department, position, staffId, staffOwner];
}

List<StaffDTO> sampleStaffDTOs() => [
  StaffDTO(name: "Cấn Công Cường", tel: "0386328935", email: "congcuong108@gmai.com", activity: "", timeForActivity: "", department: "IT", position: "Nhân viên", staffId: "459117", staffOwner: "")

]; 