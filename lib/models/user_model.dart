class UserModel {
  final String uid;
  final String email;
  final String username;

  UserModel({required this.uid, required this.email, required this.username});

  // Convert from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      uid: id,
      email: data['email'],
      username: data['username'],
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
    };
  }
}
