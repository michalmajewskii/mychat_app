import 'package:flutter/material.dart';
import 'package:mychatapp/Tools/chats_list.dart';

class ChatsFragment extends StatefulWidget {
  @override
  _ChatsFragmentState createState() => _ChatsFragmentState();
}

class _ChatsFragmentState extends State<ChatsFragment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ChatsListWidget(),
    );
  }
}
