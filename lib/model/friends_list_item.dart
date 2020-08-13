import 'package:firebase_database/firebase_database.dart';

final _userDatabase = FirebaseDatabase.instance.reference().child("Users");

class FriendsListItem {
  var image;
  var name;
  var status;
  var id;

  FriendsListItem(this.image, this.name, this.status, this.id);

  FriendsListItem.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    _userDatabase.child(snapshot.key).once().then((DataSnapshot dataSnapshot) {
      image = dataSnapshot.value['image'];
      name = dataSnapshot.value['name'];
      status = dataSnapshot.value['status'];
    });
  }
}
