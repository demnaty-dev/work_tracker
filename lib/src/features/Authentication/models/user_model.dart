class UserModel {
  final String uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;

  const UserModel({
    required this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
  });
}
