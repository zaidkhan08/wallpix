class UserModel {
  final String userId;
  int pixCoins;

  UserModel({required this.userId, required this.pixCoins});

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      userId: data['userId'],
      pixCoins: data['pixCoins'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'pixCoins': pixCoins,
    };
  }
}