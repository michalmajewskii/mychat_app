import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mychatapp/model/user.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase.instance.reference();

  User userFromFirebase(FirebaseUser user) {
    return user != null ? User(userId: user.uid) : null;
  }

  Future<void> signIn(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return userFromFirebase(firebaseUser);
    } catch (e) {
      print('Error Sign In' + e);
    }
  }

  Future signUp(String email, String password, String name) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      String userUid = firebaseUser.uid.toString();

      _database.child("Users").child(userUid).set({
        'name': name,
        'status': "Hi, there, I'm using Chat App.",
        'image': 'https://appchance.com/images/image-link.png',
        'thumb_image': 'default',
        'online': true,
      });

      return userUid;
    } catch (e) {
      print('Error Sign Up');
    }
  }
}
