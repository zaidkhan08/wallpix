import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/userModel.dart';

class UserRepo {
  final FirebaseFirestore _firestore;

  UserRepo(this._firestore);

  // To ADD Coins in User's Account
  Future<void> addCoins(String userId, int coins) async {
    final QuerySnapshot snapshot = await _firestore.collection('users').where('userId', isEqualTo: userId).get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data() as Map<String, dynamic>;
      final int currentCoins = data['pixCoins'] as int;
      await _firestore.collection('users').doc(snapshot.docs.first.id).update({
        'pixCoins': currentCoins + coins,
      });
    } else {
      throw Exception('User not found');
    }
  }

  // To deduct/ REMOVE Coins in User's Account
  Future<void> deductCoins(String userId, int coins) async {
    final QuerySnapshot snapshot = await _firestore.collection('users').where('userId', isEqualTo: userId).get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data() as Map<String, dynamic>;
      final int currentCoins = data['pixCoins'] as int;
      await _firestore.collection('users').doc(snapshot.docs.first.id).update({
        'pixCoins': currentCoins - coins,
      });
    } else {
      throw Exception('User not found');
    }
  }

  // getUser -- not checked yet
  Future<UserModel> getUser(String userId) async {
    final DocumentSnapshot snapshot = await _firestore.collection('users').doc(userId).get();
    if (!snapshot.exists) {
      throw Exception('User not found');
    }
    return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  // check how many coins do user have
  Future<int> checkPixCoins(String userId) async {
    final QuerySnapshot snapshot = await _firestore.collection('users').where('userId', isEqualTo: userId).get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data() as Map<String, dynamic>;
      return data['pixCoins'] as int;
    } else {
      throw Exception('User not found');
    }
  }

  // register user and add 200 Coins to users A/c
  Future<void> addUsersCoins({required String userId, required int pixCoins}) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'userId': userId,
        'pixCoins': pixCoins,
      });
      print('User Registered with $pixCoins Coins');
    } catch (error) {
      print('Failed to register or add Coins: $error');
    }
  }

}