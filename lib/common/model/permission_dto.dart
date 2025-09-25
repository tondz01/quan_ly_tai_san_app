class PermissionDto {
  final String userId;
  final String permissionCode;
  final bool canCreate;
  final bool canRead;
  final bool canUpdate;
  final bool canDelete;

  PermissionDto({
    required this.userId,
    required this.permissionCode,
    required this.canCreate,
    required this.canRead,
    required this.canUpdate,
    required this.canDelete,
  });

  factory PermissionDto.fromJson(Map<String, dynamic> json) {
    return PermissionDto(
      userId: json['userId'] ?? '',
      permissionCode: json['permissionCode'] ?? '',
      canCreate: json['canCreate'] ?? false,
      canRead: json['canRead'] ?? false,
      canUpdate: json['canUpdate'] ?? false,
      canDelete: json['canDelete'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'permissionCode': permissionCode,
      'canCreate': canCreate,
      'canRead': canRead,
      'canUpdate': canUpdate,
      'canDelete': canDelete,
    };
  }

  PermissionDto copyWith({
    String? userId,
    String? permissionCode,
    bool? canCreate,
    bool? canRead,
    bool? canUpdate,
    bool? canDelete,
  }) {
    return PermissionDto(
      userId: userId ?? this.userId,
      permissionCode: permissionCode ?? this.permissionCode,
      canCreate: canCreate ?? this.canCreate,
      canRead: canRead ?? this.canRead,
      canUpdate: canUpdate ?? this.canUpdate,
      canDelete: canDelete ?? this.canDelete,
    );
  }
}
