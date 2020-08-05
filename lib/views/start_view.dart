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

              GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SignInScreen()));
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
                    child: Text("ALREADY HAVE ACCOUNT", style: TextStyle(
                        fontSize: 15, color: Colors.white
                    ),
                    ),
                  )
              ),
              SizedBox(height: 15,),

              GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUpScreen()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width*0.5,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Text('CREATE NEW ACCOUNT', style: TextStyle(
                        fontSize: 15, color: Colors.deepPurple
                    ),
                    ),
                  )
              ),

              SizedBox(height: 50,),
            ]),
      ),
    );
  }
}