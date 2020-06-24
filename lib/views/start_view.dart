import 'package:flutter/material.dart';
import 'package:mychatapp/views/signin_view.dart';
import 'package:mychatapp/views/signup_view.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Padding(
                padding: EdgeInsets.only(left: 50, right: 50,bottom: 20),
                child: Image.asset('assets/messenger.png'),

              ),
              Text('Welcome To My Chat App', style: TextStyle(fontSize: 22, color: Colors.white)
              ),

              SizedBox(height: 60,),
              RaisedButton(
                child: Text('ALREADY HAVE ACCOUNT'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> SignInScreen()));

                },
              ),
              RaisedButton(
                  child: Text('CREATE NEW ACCOUNT'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUpScreen()));

                },
              ),
              SizedBox(height: 50,),
            ]),
      ),
    );
  }
}