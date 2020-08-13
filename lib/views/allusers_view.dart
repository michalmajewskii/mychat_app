import 'package:flutter/material.dart';
import 'package:mychatapp/Tools/UsersList.dart';

class UsersView extends StatefulWidget {
  @override
  _UsersViewState createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Users'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        child: UsersList(),
      ),
    );
  }
}
