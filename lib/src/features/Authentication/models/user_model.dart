class UserModel {
  final String uid;
  final String displayName;
  final String email;
  final String phone;
  final String photoUrl;

  const UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.phone,
    required this.photoUrl,
  });

  UserModel.fromJson({required this.uid, required Map<String, dynamic> json})
      : displayName = json['displayName'],
        email = json['email'],
        phone = json['phone'],
        photoUrl = json['photoUrl'];

  String toJson(String imagePath) {
    return '{\n  "displayName": "$displayName",\n  "email": "$email",\n  "phone": "$phone",\n  "photoUrl": "$imagePath"\n}';
  }
}
