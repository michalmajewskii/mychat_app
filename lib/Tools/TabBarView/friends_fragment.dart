import 'package:flutter/material.dart';

import 'package:mychatapp/Tools/friends_list.dart';

class FriendsFragment extends StatefulWidget {
  @override
  _FriendsFragmentState createState() => _FriendsFragmentState();
}

class _FriendsFragmentState extends State<FriendsFragment> {
  @override
  Widget build(BuildContext context) {
    return Container(

      child: FriendsListWidget(),
    );
  }
}
