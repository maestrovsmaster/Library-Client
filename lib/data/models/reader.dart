class Reader {
  final String id;
  final String email;
  final String name;
  final String phoneNumber;
  final String phoneNumberAlt;

  Reader({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.phoneNumberAlt,
  });

  factory Reader.fromMap(Map<String, dynamic> json, String docId) {
    print("ReaderMapdoc = $docId $json ");
    return Reader(
      id: docId,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      phoneNumberAlt: json['phoneNumberAlt'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'phoneNumberAlt': phoneNumberAlt,
    };
  }
}
