class AppUser {
  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
  });

  final String uid;
  final String name;
  final String email;
  final String role;

  factory AppUser.fromMap(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      name: data['name']?.toString().trim() ?? '',
      email: data['email']?.toString().trim() ?? '',
      role: data['role']?.toString().trim() ?? '',
    );
  }

  bool get isAdmin => role.toLowerCase() == 'admin';
  bool get isOperator => role.toLowerCase() == 'operator';
  bool get hasKnownRole => isAdmin || isOperator;
  bool get canCreate => hasKnownRole;
  bool get canRead => hasKnownRole;
  bool get canUpdate => isAdmin;
  bool get canDelete => isAdmin;

  String get displayRole => isAdmin ? 'Admin' : 'Operator';
}
