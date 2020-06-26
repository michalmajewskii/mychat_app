

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FirebaseMethods{
  final _database=FirebaseDatabase.instance.reference();

  changeUserStatus(String status) async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    _database.child("Users").child(user.uid).child('status').set(status);
  }
}



