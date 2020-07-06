import 'package:firebase_database/firebase_database.dart';

class UsersListItem{

  String image;
  String name;
  String status;
  String id;

  UsersListItem(this.image, this.name, this.status, this.id);

  UsersListItem.map(dynamic obj) {
    this.image = obj['image'];
    this.name = obj['name'];
    this.status = obj['status'];
    this.id = obj['id'];
  }



  UsersListItem.fromSnapshot(DataSnapshot snapshot) {
    id=snapshot.key;
    image = snapshot.value['image'];
    name = snapshot.value['name'];
    status = snapshot.value['status'];
  }

}