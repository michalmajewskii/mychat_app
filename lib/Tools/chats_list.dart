import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:mychatapp/model/user.dart';
import 'package:mychatapp/views/chat_view.dart';

class ChatsListWidget extends StatefulWidget {
  @override
  _ChatsListWidgetState createState() => _ChatsListWidgetState();
}

class _ChatsListWidgetState extends State<ChatsListWidget> {
  DatabaseReference itemRef;
  final _userDatabase = FirebaseDatabase.instance.reference().child("Users");
  User currentUser = new User();

  @override
  void initState() {
    super.initState();
    final FirebaseDatabase database = FirebaseDatabase.instance;
    getUidFirebase().then((value) {
      currentUser.setUid(value);
      itemRef = database.reference().child('messages/$value/');

      itemRef.onChildAdded.listen(_connectWithDatabase);
      print(value.toString());
    });
  }

  _connectWithDatabase(Event event) {
    final FirebaseDatabase database = FirebaseDatabase.instance;
    setState(() {
      getUidFirebase().then((value) {
        itemRef = database.reference().child('messages/$value/');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(children: <Widget>[
        new Flexible(
          child: new FirebaseAnimatedList(
              padding: const EdgeInsets.all(12.0),
              query: itemRef,
              itemBuilder: (_, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return new ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatView(
                                  friendListUid: snapshot.key.toString(),
                                  currentUserUid: currentUser.getUid(),
                                )));
                  },
                  title: new FutureBuilder(
                    future: getUserNameFirebase(snapshot.key.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return Text("Default Name",
                                style: TextStyle(fontSize: 22));
                          case ConnectionState.active:
                            return Text("active");
                          case ConnectionState.waiting:
                            return Text(
                              "Default Name",
                              style: TextStyle(fontSize: 22),
                            );
                          case ConnectionState.done:
                            return Text(
                              snapshot.data,
                              style: TextStyle(
                                fontSize: 22.0,
                              ),
                            );
                          default:
                            return Text("Default Name",
                                style: TextStyle(fontSize: 22));
                        }
                      } else
                        return Text('Default');
                    },
                  ),
                  subtitle: FutureBuilder(
                    future: getUserMessageFirebase(snapshot.key.toString()),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Text("Default Status",
                              style: TextStyle(fontSize: 15));
                        case ConnectionState.active:
                          return Text("active");
                        case ConnectionState.waiting:
                          return Text("Default Status",
                              style: TextStyle(fontSize: 15));
                        case ConnectionState.done:
                          return Text(
                            snapshot.data,
                            style: new TextStyle(
                              fontSize: 18.0,
                              fontStyle: FontStyle.italic,
                            ),
                          );
                        default:
                          return Text(
                            'Default User',
                            style: TextStyle(fontSize: 15),
                          );
                      }
                    },
                  ),
                  leading: Column(
                    children: <Widget>[
                      FutureBuilder(
                        future: getUserImageFirebase(snapshot.key.toString()),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/appchance.png'));
                            case ConnectionState.active:
                              return Text("active");
                            case ConnectionState.waiting:
                              return CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/appchance.png'));
                            case ConnectionState.done:
                              return CircleAvatar(
                                backgroundImage: NetworkImage(snapshot.data),
                                radius: 25,
                              );
                            default:
                              return Text(
                                'Default User',
                                style: TextStyle(fontSize: 15),
                              );
                          }
                        },
                      ),
                    ],
                  ),
                );
              }),
        )
      ]),
    );
  }

  Future<String> getUidFirebase() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid.toString();
  }

  Future<String> getUserNameFirebase(String snapshot) async {
    String name;
    await _userDatabase
        .child("$snapshot/name")
        .once()
        .then((DataSnapshot dataSnapshot) {
      name = dataSnapshot.value.toString();
    });
    return name;
  }

  Future<String> getUserImageFirebase(String snapshot) async {
    String image;
    await _userDatabase
        .child("$snapshot/image")
        .once()
        .then((DataSnapshot dataSnapshot) {
      image = dataSnapshot.value.toString();
    });
    return image;
  }

  Future<String> getUserMessageFirebase(String snapshot) async {
    String message;
    await itemRef
        .child("$snapshot/")
        .limitToLast(1)
        .once()
        .then((DataSnapshot dataSnapshot) {
      String snapshotString = dataSnapshot.value.toString();
      const start = "message: ";
      const end = "}";
      final startIndex = snapshotString.indexOf(start);
      final endIndex = snapshotString.indexOf(end, startIndex + start.length);
      message = snapshotString
          .substring(startIndex + start.length, endIndex)
          .toString();
    });
    return message;
  }
}
