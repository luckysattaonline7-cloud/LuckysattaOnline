class User {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final double wallet;
  final DateTime createdAt;
  final bool isActive;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.wallet,
    required this.createdAt,
    required this.isActive,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      wallet: (map['wallet'] ?? 0).toDouble(),
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toString()),
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'wallet': wallet,
      'createdAt': createdAt.toString(),
      'isActive': isActive,
    };
  }
}
