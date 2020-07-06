import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mychatapp/Tools/message_display.dart';


class ChatView extends StatefulWidget {

  final String friendListUid;
  final String currentUserUid;
  ChatView({Key key, @required this.friendListUid, this.currentUserUid}) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  TextEditingController messageEditingController = new TextEditingController();
  final _database=FirebaseDatabase.instance.reference();
  DatabaseReference itemRef;




  Widget chatMessages(){
  return StreamBuilder(
    stream: FirebaseDatabase.instance.reference().child('/messages/${widget.currentUserUid}/${widget.friendListUid}/').onValue,
    builder: (context,snap){
      if (snap.hasData && snap.data.snapshot.value != null ) {

        Map data = snap.data.snapshot.value;
        List item = [];
        data.forEach((index, data) => item.add({"key": index, ...data}));
          item.sort((a,b)=> a["time"].compareTo(b["time"]));
        return ListView.builder(
            itemCount: item.length,
            itemBuilder:(context,index){
              return MessageTile(
                message: item[index]["message"],
                sendByMe: widget.currentUserUid.toString() == item[index]["from"],
              );
            }
        );

      }else return Container();
    },
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
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
                   return Text(snapshot.data,
                   );
               }
             },
           ),
           FutureBuilder(
             future: getUserLastSeenFirebase(),
             builder: (context, snapshot){
               switch (snapshot.connectionState){
                 case ConnectionState.none:
                   return Text("");
                 case ConnectionState.active:
                   return Text("");
                 case ConnectionState.waiting:
                   return Text("");
                 case ConnectionState.done:
                   return Text(snapshot.data,style: TextStyle(fontSize: 11));
               }
             },
           ),
         ],
       ),
        backgroundColor: Colors.deepPurple,


      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: Colors.grey,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageEditingController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Message...",
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){sendMessage();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        child: Icon(Icons.send,color: Colors.white70,size: 30,)
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }



  sendMessage(){
    if (messageEditingController.text.isNotEmpty){

      getUidFirebase().then((value){
        Map<String, dynamic> chatMessage = {
          "from": value,
          "message": messageEditingController.text,
          'time': ServerValue.timestamp
        };
        DatabaseReference user_message_push= _database.child('/messages/${value}/${widget.friendListUid}').push();
        String push_id=user_message_push.key.toString();
        print('push: $push_id');

        Map<String, dynamic> chatMessageMap = {
          "/messages/${value}/${widget.friendListUid}/${push_id}": chatMessage,
          "/messages/${widget.friendListUid}/${value}/${push_id}": chatMessage,
        };
        _database.update(chatMessageMap);
      });
    }
  }

  getMessages(){
    final FirebaseDatabase database = FirebaseDatabase.instance;
    setState(() {
      getUidFirebase().then((value){
        itemRef= database.reference().child('messages/${value}/${widget.friendListUid}');
      });
    });
  }

  Future<String> getUidFirebase()async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid.toString();
  }

  Future <String> getUserNameFirebase()async{
    String name;
    await _database.child("Users/${widget.friendListUid}/name").once().then((DataSnapshot dataSnapshot){
      name= dataSnapshot.value.toString();
    });
    return name;
  }


  Future <String> getUserLastSeenFirebase()async{
    String lastSeen;
    await _database.child("Users/${widget.friendListUid}/online").once().then((DataSnapshot dataSnapshot){

      dataSnapshot.value==true ?
        lastSeen = 'Online': lastSeen = 'Offline';

    });
    return lastSeen;
  }

}
