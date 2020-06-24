import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mychatapp/views/main_view.dart';
import 'package:mychatapp/views/start_view.dart';

void main() {

  runApp(MyApp());
}

class MyApp extends StatefulWidget {


  @override
  _MyAppState createState() => _MyAppState();
}




class _MyAppState extends State<MyApp> {
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
    );
  }
}


