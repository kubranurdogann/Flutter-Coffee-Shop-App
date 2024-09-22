import 'dart:nativewrappers/_internal/vm/lib/developer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final firebaseAuth = FirebaseAuth.instance;


  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      log("Something went wrong.");
    }
  }
}
