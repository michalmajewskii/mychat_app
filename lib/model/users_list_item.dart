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

  String get _image => image;
  String get _name => name;
  String get _status => status;
  String get _id => id;

  UsersListItem.fromSnapshot(DataSnapshot snapshot) {

    image = snapshot.value['image'];
    name = snapshot.value['name'];
    status = snapshot.value['status'];
    id=snapshot.key;
  }

}