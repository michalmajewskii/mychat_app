import 'package:firebase_database/firebase_database.dart';

class UsersListItem {
  var image;
  var name;
  var status;
  var id;

  UsersListItem(this.image, this.name, this.status, this.id);

  UsersListItem.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    image = snapshot.value['image'];
    name = snapshot.value['name'];
    status = snapshot.value['status'];
  }
}
