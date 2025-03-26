import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _user;
  UserModel? get user => _user;

  // Register User
  Future<String?> registerUser(String email, String password, String username) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel newUser = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        username: username,
      );

      await _firestore.collection('users').doc(newUser.uid).set(newUser.toMap());
      _user = newUser;
      notifyListeners();
      return null; // No error
    } catch (e) {
      return e.toString();
    }
  }

  // Login User
  Future<String?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userCredential.user!.uid).get();
      
      _user = UserModel.fromMap(userDoc.data() as Map<String, dynamic>, userDoc.id);
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Logout User
  Future<void> logoutUser() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
