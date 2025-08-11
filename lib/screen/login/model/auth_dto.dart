class AuthDTO {
  final String accessToken;
  final String userName;
  final String fullName;
  final String role;
  final String message;

  AuthDTO({
    required this.accessToken,
    required this.userName,
    required this.fullName,
    required this.role,
    required this.message,
  });

  // Convert from Json to EventDTO.
  factory AuthDTO.fromJson(Map<String, dynamic> json) {
    return AuthDTO(
        accessToken: json['token'] ?? json['token'] ?? '',
        userName: json['username'] ?? '',
        fullName: json['fullName'] ?? '',
        role: json['role'] ?? '',
        message: json['message'] ?? '');
  }
}
