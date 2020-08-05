import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:mychatapp/model/friends_list_item.dart';
import 'package:mychatapp/model/user.dart';
import 'package:mychatapp/views/chat_view.dart';
import 'package:mychatapp/views/userpage_view.dart';

import 'friends_popupmenu.dart';

class FriendsListWidget extends StatefulWidget {
  @override
  _FriendsListWidgetState createState() => _FriendsListWidgetState();
}

class _FriendsListWidgetState extends State<FriendsListWidget> {

  List<FriendsListItem> items = List();
  FriendsListItem itemFriend;
  DatabaseReference itemRef;
  final _userDatabase=FirebaseDatabase.instance.reference().child("Users");
  User currentUser= new User();

  @override
  void initState() {
    super.initState();
    itemFriend = FriendsListItem("", "", "", "");
    final FirebaseDatabase database = FirebaseDatabase.instance;
    getUidFirebase().then((value) {
      currentUser.setUid(value);
      itemRef = database.reference().child('Friends/${value}/');
     itemRef.onChildAdded.listen(_connectWithDatabase);
    });


  }
  _connectWithDatabase (Event event){
    final FirebaseDatabase database = FirebaseDatabase.instance;
    setState(() {
      getUidFirebase().then((value) {
        itemRef = database.reference().child('Friends/${value}/');
      });
    });
  }


  createAlertDialog(BuildContext context, String uid){

    return showDialog(context: context,
    builder: (BuildContext context){
      return AlertDialog(
       title: Text('Select Options'),
       content: Container(
         height: 100,
         child: Column(
         children: <Widget>[
           FlatButton(
            onPressed: (){
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> ChatView(friendListUid: uid, currentUserUid: currentUser.getUid(),)));
            } ,
             child: Text("Send Message", style: TextStyle(fontSize: 17,color: Colors.black87)),
           ),
           FlatButton(
             onPressed: (){
               Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> UserPageView(userListUid: uid,)));
             } ,
             child: Text("Open Profile", style: TextStyle(fontSize: 17,color: Colors.black87)),
           )
         ],
         ),
       )
      );
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new Column(
            children: <Widget>[
           new Flexible(
            child: new FirebaseAnimatedList(
                padding: const EdgeInsets.all(12.0),
                query: itemRef,
            itemBuilder:(_, DataSnapshot snapshot, Animation<double> animation, int index){
              return new ListTile(
                onTap: (){
                  createAlertDialog(context, snapshot.key.toString());
                },
                title: new  FutureBuilder(
                  future: getUserNameFirebase(snapshot.key.toString()),
                  builder: (context, snapshot){
                    if(snapshot.hasData) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Text("Default Name",style: TextStyle(fontSize: 22));
                        case ConnectionState.active:
                          return Text("active");
                        case ConnectionState.waiting:
                          return Text("Default Name",style: TextStyle(fontSize: 22));
                        case ConnectionState.done:
                          return Text(snapshot.data, style: TextStyle(
                            fontSize: 22.0,
                          ),
                          );
                      }
                    }else return Text('Default');
                  },
                ),
               subtitle: FutureBuilder(
                 future: getUserStatusFirebase(snapshot.key.toString()),
                 builder: (context, snapshot){
                   switch (snapshot.connectionState){
                     case ConnectionState.none:
                       return Text("Default Status",style: TextStyle(fontSize: 15));
                     case ConnectionState.active:
                       return Text("active");
                     case ConnectionState.waiting:
                       return Text("Default Status",style: TextStyle(fontSize: 15));
                     case ConnectionState.done:
                       return Text(snapshot.data, style: new TextStyle(
                         fontSize: 18.0,
                         fontStyle: FontStyle.italic,
                       ),
                       );
                   }
                 },
               ),


                leading: Column(
                  children: <Widget>[
                    FutureBuilder(
                      future: getUserImageFirebase(snapshot.key.toString()),
                      builder: (context, snapshot){
                        switch (snapshot.connectionState){
                          case ConnectionState.none:
                            return CircleAvatar(backgroundImage: AssetImage('assets/appchance.png'));
                          case ConnectionState.active:
                            return Text("active");
                          case ConnectionState.waiting:
                            return CircleAvatar(backgroundImage: AssetImage('assets/appchance.png'));
                          case ConnectionState.done:
                            return CircleAvatar(
                              backgroundImage: NetworkImage(snapshot.data),
                              radius: 25,
                            );
                        }
                      },
                    ),
                  ],
                ),
              );
            }
        ),
           )
        ]
    ),
    );
  }




  Future<String> getUidFirebase()async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid.toString();
  }

  Future <String> getUserNameFirebase(String snapshot)async{
    String name;

    await _userDatabase.child("$snapshot/name").once().then((DataSnapshot dataSnapshot){
      name= dataSnapshot.value.toString();
    });
    return name;
  }

  Future <String> getUserStatusFirebase(String snapshot)async{
    String status;
    await _userDatabase.child("$snapshot/status").once().then((DataSnapshot dataSnapshot){
      status= dataSnapshot.value.toString();
    });
    return status;
  }

  Future <String> getUserImageFirebase(String snapshot)async{
    String status;
    await _userDatabase.child("$snapshot/image").once().then((DataSnapshot dataSnapshot){
      status= dataSnapshot.value.toString();
    });
    return status;
  }
}
