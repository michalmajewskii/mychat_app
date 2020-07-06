import 'package:firebase_database/firebase_database.dart';
final _userDatabase=FirebaseDatabase.instance.reference().child("Users");

class FriendsListItem{

  String image;
  String name;
  String status;
  String id;

  FriendsListItem(this.image, this.name, this.status, this.id);

  FriendsListItem.map(dynamic obj) {
    this.image = obj['image'];
    this.name = obj['name'];
    this.status = obj['status'];
    this.id = obj['id'];
  }


  FriendsListItem.fromSnapshot(DataSnapshot snapshot)  {
    id=snapshot.key;

  _userDatabase.child(snapshot.key).once().then((DataSnapshot dataSnapshot){
      image = dataSnapshot.value['image'];
      name = dataSnapshot.value['name'];
      status = dataSnapshot.value['status'];

    });

  }

}