import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';


class StorageFirebaseMethods {
  final _database=FirebaseDatabase.instance.reference();


  void uploadImage(File image ) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String _uid=user.uid.toString();
    final StorageReference storageReference= FirebaseStorage.instance.ref().child("profile_images/$_uid.jpg");
    final StorageUploadTask task = storageReference.putFile(image);


    String downloadUrl =
    await (await task.onComplete).ref.getDownloadURL();
    _database.child("Users/$_uid/image").set(downloadUrl);
    }






}