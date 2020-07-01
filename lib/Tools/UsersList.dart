
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mychatapp/model/users_list_item.dart';
import 'package:mychatapp/views/userpage_view.dart';

class UsersList extends StatefulWidget {
  @override
  _UsersListState createState() => _UsersListState();

}

class _UsersListState extends State<UsersList> {
  final _database=FirebaseDatabase.instance.reference().child("Users");
  List<UsersListItem> items;
  StreamSubscription<Event> _onUserAddedSubscription;
  StreamSubscription<Event> _onUserChangedSubscription;


  @override
  void initState() {
    super.initState();

    items = new List();
    _onUserAddedSubscription = _database.onChildAdded.listen(_onUserAdded);
    _onUserChangedSubscription = _database.onChildChanged.listen(_onUserUpdated);
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: items.length,
        padding: const EdgeInsets.all(15.0),
        itemBuilder: (context,position){
          return Column(
            children: <Widget>[
              Divider(height: 5.0),
              ListTile(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=> UserPageView(userListUid: items[position].id,),
                  ));
                },
                  title: Text(
                  '${items[position].name}',
                  style: TextStyle(
                  fontSize: 22.0,
              ),
          ),
          subtitle: Text(
          '${items[position].status}',
          style: new TextStyle(
          fontSize: 18.0,
          fontStyle: FontStyle.italic,
          ),
          ),
            leading: Column(
              children: <Widget>[

                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  radius: 25,
                  backgroundImage: NetworkImage( "${(items[position].image).toString()}"),
                ),
              ],
            ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onUserAdded(Event event) {
    setState(() {
      items.add(new UsersListItem.fromSnapshot(event.snapshot));
    });
  }

  void _onUserUpdated(Event event) {
    var oldUserValue = items.singleWhere((user) => user.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldUserValue)] = new UsersListItem.fromSnapshot(event.snapshot);
    });
  }



}
