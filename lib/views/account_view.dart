import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mychatapp/model/user.dart';

class AccountView extends StatefulWidget {
  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {

  final _database=FirebaseDatabase.instance.reference();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Container(
          width: MediaQuery.of(context).size.width*0.9,
          margin: const EdgeInsets.symmetric(vertical: 70, horizontal: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),

          child: Column(
            children: <Widget>[
              SizedBox(height: 14,),
              CircleAvatar(
                //TODO: FUTUREBUILDER FOR AVATARS
                radius: 70,
                backgroundImage: NetworkImage('https://appchance.com/images/image-link.png'),
              ),
              SizedBox(height: 14,),
              FutureBuilder(
                future: getUserNameFirebase(),
                builder: (context, snapshot){
                  switch (snapshot.connectionState){
                    case ConnectionState.none:
                      return Text("Default User",style: TextStyle(fontSize: 25));
                    case ConnectionState.active:
                      return Text("active");
                    case ConnectionState.waiting:
                      return Text("Default User",style: TextStyle(fontSize: 25));
                    case ConnectionState.done:
                      return Text(snapshot.data, style: TextStyle(fontSize: 25),
                      );
                  }
                },

              ),
              SizedBox(height: 14,),
              FutureBuilder(
                future: getUserStatusFirebase(),
                builder: (context, snapshot){
                  switch (snapshot.connectionState){
                    case ConnectionState.none:
                      return Text("Default Status",style: TextStyle(fontSize: 15));
                    case ConnectionState.active:
                      return Text("active");
                    case ConnectionState.waiting:
                      return Text("Default Status",style: TextStyle(fontSize: 15));
                    case ConnectionState.done:
                      return Text(snapshot.data, style: TextStyle(fontSize: 15),
                      );
                  }
                },

              ),
              SizedBox(height: 150,),
        RaisedButton(
          child: Text('CHANGE IMAGE'),
        ),
              RaisedButton(
                child: Text('CHANGE IMAGE'),
              )
            ],
          ),
      ),
    );
  }

  Future<String> getUidFirebase()async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid.toString();
  }


  Future <String> getUserNameFirebase()async{
    String name, _uid;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    _uid=user.uid.toString();
    await _database.child("Users/$_uid/name").once().then((DataSnapshot dataSnapshot){
      name= dataSnapshot.value.toString();
    });
    return name;
  }

  Future <String> getUserStatusFirebase()async{
    String status, _uid;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    _uid=user.uid.toString();
    await _database.child("Users/$_uid/status").once().then((DataSnapshot dataSnapshot){
      status= dataSnapshot.value.toString();
    });
    return status;
  }


}
