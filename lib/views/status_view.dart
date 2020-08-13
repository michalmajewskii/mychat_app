import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mychatapp/services/realtime_firebase.dart';

class StatusView extends StatefulWidget {
  @override
  _StatusViewState createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  FirebaseMethods methods = new FirebaseMethods();
  TextEditingController userNameStatusEditingController =
      new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Your Status'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            TextFormField(
              controller: userNameStatusEditingController,
              decoration: InputDecoration(
                hintText: "Hi, there, I'm using Chat App.",
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.5, top: 15),
              child: GestureDetector(
                  onTap: () {
                    print(userNameStatusEditingController.text);
                    methods
                        .changeUserStatus(userNameStatusEditingController.text);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.deepOrange,
                          Colors.deepOrangeAccent
                        ]),
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      "CHANGE STATUS",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
