import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mychatapp/Tools/TabBarView/chats_fragment.dart';
import 'package:mychatapp/Tools/TabBarView/friends_fragment.dart';
import 'package:mychatapp/Tools/TabBarView/requests_fragment.dart';
import 'package:mychatapp/Tools/main_popupmenu.dart';
import 'package:mychatapp/model/user.dart';
import 'package:mychatapp/views/account_view.dart';
import 'package:mychatapp/views/allusers_view.dart';
import 'package:mychatapp/views/start_view.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {

  TabController _tabController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _database=FirebaseDatabase.instance.reference();
  User simpleUser=new User();

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    keepLogInOrNot();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: Text('Main Screen'),
        backgroundColor: Colors.deepPurple,
        bottom: TabBar(
          unselectedLabelColor: Colors.white24,
          labelColor: Colors.white,
          tabs: [
            new Tab(
              icon: new Icon(Icons.notifications),
              text: 'REQUESTS',),
            new Tab(
              icon: new Icon(Icons.chat),
              text: 'CHATS',
            ),
            new Tab(
              icon: new Icon(Icons.group),
              text: 'FRIENDS',
            )
          ],
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,),
        bottomOpacity: 1,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context){
              return MainPopupMenu.choices.map((String choice){
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text (choice),
                );
              }).toList();
            },
          )
        ],
      ),


      body:Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            )
        ),
        child: TabBarView(
          children: <Widget>[
            RequestsFragment(),
            ChatsFragment(),
            FriendsFragment()
          ],
          controller: _tabController,
        ),
      )
    );
  }

  keepLogInOrNot() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if(user==null) {
      sendToStart();
    }else{
      _database.child("Users").child(user.uid).child('online').set(true);
      simpleUser.setUid(user.uid);
      print(user.uid);
    }
  }

  void sendToStart(){
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        StartScreen()), (Route<dynamic> route) => false);
  }
  void choiceAction(String choice){
    if(choice == MainPopupMenu.Account){
      print('Account');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AccountView()));
    }else if (choice==MainPopupMenu.Users){
      print('Users');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => UsersView()));



    }else if(choice== MainPopupMenu.Logout){
      try {
        _database.child("Users").child(simpleUser.getUid()).child('online').set(ServerValue.timestamp).then((value) {
          _signOut();
          sendToStart();
        });

      }catch(e){
        print('Logout error');
      }
    }
  }

  _signOut() async {
    await _auth.signOut();
  }


}
