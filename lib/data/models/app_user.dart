class AppUser {
  final String email;
  final String login;
  final String name;
  final String phoneNumber;
  final String phoneNumberAlt;
  final String photoUrl;
  final String role;
  final String userId;

  AppUser({
    required this.email,
    required this.name,
    required this.login,
    required this.phoneNumber,
    required this.phoneNumberAlt,
    required this.photoUrl,
    required this.role,
    required this.userId,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      email: json['email'] ?? '',
      login: json['login'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      phoneNumberAlt: json['phoneNumberAlt'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      role: json['role'] ?? '',
      userId: json['userId'] ?? '',
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'role': role,
      'login': login,
      'phoneNumber': phoneNumber,
      'phoneNumberAlt': phoneNumberAlt,
      'photoUrl': photoUrl,
    };
  }

  AppUser copyWith({
    String? name,
    String? phoneNumber,
    String? phoneNumberAlt,
  }) {
    return AppUser(
      userId: this.userId,
      email: this.email,
      name: name ?? this.name,
      role: this.role,
      login: this.login,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      phoneNumberAlt: phoneNumberAlt ?? this.phoneNumberAlt,
      photoUrl: this.photoUrl,
    );
  }
}
