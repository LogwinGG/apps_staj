// ignore_for_file: prefer_final_fields

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  Future<User?> createUser(String email, String password) async {
    UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

    User? user = result.user;
    return user;
  }

  Future<User?> signIn(String email, String password) async{
    try {
      UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = result.user;
      return user;
    }
    catch (e){
      return null;
    }
  }


  Future<void> signOut() {
    return FirebaseAuth.instance.signOut();
  }


}