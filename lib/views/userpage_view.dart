
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mychatapp/services/storage_firebase.dart';

class UserPageView extends StatefulWidget {

  final String userListUid;
  UserPageView({Key key, @required this.userListUid}) : super(key: key);

  @override
  _UserPageViewState createState() => _UserPageViewState();
}

class _UserPageViewState extends State<UserPageView> {
  final _database=FirebaseDatabase.instance.reference();


  final picker = ImagePicker();

  StorageFirebaseMethods _storageFirebaseMethods= new StorageFirebaseMethods();
  String textButton="SEND FRIEND REQUEST";
  String textButton2="DECLINE FRIEND REQUEST";
  String currentFriendState='not_friends';


  @override
  void initState(){
    super.initState();
    getUidFirebase().then((value){
      _database.child('Friend_req/${value}/${widget.userListUid}/request_type').once().then((DataSnapshot dataSnapshot) {
        if (dataSnapshot.value!=null){
          print(dataSnapshot.toString());
          String reqType = dataSnapshot.value.toString();
        if (reqType == "received") {
          setState(() {
            textButton = 'ACCEPT FRIEND REQUEST';
            currentFriendState = "req_received";
          });
        } else if (reqType == "sent") {
          setState(() {
            textButton = 'CANCEL FRIEND REQUEST';
            currentFriendState = "req_sent";
          });
        }
      }else{
          _database.child('Friends/${value}/${widget.userListUid}').once().then((DataSnapshot dataSnapshot){
            if(dataSnapshot != null){

              setState(() {
                textButton="UNFRIEND THIS PERSON";
                currentFriendState="friends";
              });
            }
          });
        }
      });
    });
  }

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
            FutureBuilder(
              future: getUserImageFirebase(),
              builder: (context, snapshot){
                switch (snapshot.connectionState){
                  case ConnectionState.none:
                    return CircleAvatar(backgroundImage: AssetImage('assets/appchance.png'));
                  case ConnectionState.active:
                    return Text("active");
                  case ConnectionState.waiting:
                    return Text("Default User",style: TextStyle(fontSize: 25));
                  case ConnectionState.done:
                    return CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data),
                      radius: 70,
                    );
                }
              },
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
            SizedBox(height: 250,),
            GestureDetector(
                onTap: (){
                 friendsStateMethod();

                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width*0.5,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.deepOrange,
                            Colors.deepOrangeAccent
                          ]
                      ),
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text('$textButton', style: TextStyle(
                      fontSize: 15, color: Colors.white
                  ),
                  ),
                )
            ),
            SizedBox(height: 14,),
            GestureDetector(
                onTap: (){

                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width*0.5,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.deepOrange,
                            Colors.deepOrangeAccent
                          ]
                      ),
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text('$textButton2', style: TextStyle(
                      fontSize: 15, color: Colors.white
                  ),
                  ),
                )
            ),
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
    String name;
    await _database.child("Users/${widget.userListUid}/name").once().then((DataSnapshot dataSnapshot){
      name= dataSnapshot.value.toString();
    });
    return name;
  }

  Future <String> getUserStatusFirebase()async{
    String status;
    await _database.child("Users/${widget.userListUid}/status").once().then((DataSnapshot dataSnapshot){
      status= dataSnapshot.value.toString();
    });
    return status;
  }

  Future <String> getUserImageFirebase()async{
    String image;
    await _database.child("Users/${widget.userListUid}/image").once().then((DataSnapshot dataSnapshot){
      image= dataSnapshot.value.toString();
    });
    return image;
  }
  


    void friendsStateMethod()async{

    getUidFirebase().then((value) {

      ////NOT FRIENDS STATE

      if(currentFriendState=="not_friends") {
        print('send');
        Map<String, dynamic> requestMap = {};
        requestMap["Friend_req/${value}/${widget.userListUid}/request_type"] = 'sent';
        requestMap["Friend_req/${widget.userListUid}/${value}/request_type"] = 'received';
        _database.update(requestMap);
        currentFriendState="req_sent";
        setState(() {
          textButton="CANCEL FRIEND REQUEST";
        });

      }else if(currentFriendState=="req_sent"){
        print("cancel");

        //// CANCEL REQUEST STATE
        _database.child('Friend_req/${value}/${widget.userListUid}').remove();
      _database.child("Friend_req/${widget.userListUid}/${value}").remove();
        currentFriendState="not_friends";
        setState(() {
          textButton="SEND FRIEND REQUEST";
        });
      }else if(currentFriendState=="req_received"){


        //ACCEPT FRIEND REQUEST
        String currentDate = new DateTime.now().toString();
        print('accept');
        Map<String, dynamic> friendsMap = {};
        friendsMap["Friends/${value}/${widget.userListUid}/date"] = currentDate;
        friendsMap["Friends/${widget.userListUid}/${value}/date"] =currentDate;
        _database.child('Friend_req/${value}/${widget.userListUid}').remove();
        _database.child("Friend_req/${widget.userListUid}/${value}").remove();
        _database.update(friendsMap);
        currentFriendState="friends";
        setState(() {
          textButton="UNFRIEND THIS PERSON";
        });

      }else if(currentFriendState=="friends"){
      print('unfriend');
        //UNFRIEND
      _database.child('Friends/${value}/${widget.userListUid}').remove();
      _database.child("Friends/${widget.userListUid}/${value}").remove();
      currentFriendState="not_friends";

        setState(() {
          textButton="SEND FRIEND REQUEST";
        });


      }





      });




      
      
    }
      
    
    }
  
  
  
  
  


